Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949Ab2JaDFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:05:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934913Ab2JaDFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:05:34 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVMRJPfPSC_4ZamqfYUSYNsMEVYXMFmcs26T=4MdB_Kntw@mail.gmail.com>
References: <CACVXFVOPDu6wVgPmvtTkokn7VV41x3XVvL4g_E0pz0mikUbvUg@mail.gmail.com>
	<Pine.LNX.4.44L0.1210301112270.1363-100000@iolanthe.rowland.org>
	<CACVXFVO5-UPNrWsySzDE5AfOv1TMqbyitQX9ViidSJPM36fqAQ@mail.gmail.com>
	<2504263.kbM6W9JoH9@linux-lqwf.site>
	<CACVXFVMRJPfPSC_4ZamqfYUSYNsMEVYXMFmcs26T=4MdB_Kntw@mail.gmail.com>
Date: Wed, 31 Oct 2012 11:05:33 +0800
Message-ID: <CACVXFVNxucCVLS-=EQkmVop3LQMkeXW7RbZq4yfkiq_MUGndvg@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] PM / Runtime: introduce pm_runtime_set[get]_memalloc_noio()
From: Ming Lei <ming.lei@canonical.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:08 AM, Ming Lei <ming.lei@canonical.com> wrote:
>> I am afraid it is, because a disk may just have been probed as the deviceis being reset.
>
> Yes, it is probable, and sounds like similar with 'root_wait' problem, see
> prepare_namespace(): init/do_mounts.c, so looks no good solution
> for the problem, and maybe we have to set the flag always before resetting
> usb device.

The below idea may help the problem which 'memalloc_noio' flag isn't set during
usb_reset_device().

- for usb mass storage device, call pm_runtime_set_memalloc_noio(true)
  inside usb_stor_probe2() and uas_probe(), and call
  pm_runtime_set_memalloc_noio(false) inside uas_disconnect()
  and usb_stor_disconnect().

- for usb network device, register_netdev() is always called inside usb
  interface's probe(),  looks no such problem.

Thanks,
--
Ming Lei
