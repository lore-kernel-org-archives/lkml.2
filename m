Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802Ab2JaCIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:08:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50826 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2JaCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <2504263.kbM6W9JoH9@linux-lqwf.site>
References: <CACVXFVOPDu6wVgPmvtTkokn7VV41x3XVvL4g_E0pz0mikUbvUg@mail.gmail.com>
	<Pine.LNX.4.44L0.1210301112270.1363-100000@iolanthe.rowland.org>
	<CACVXFVO5-UPNrWsySzDE5AfOv1TMqbyitQX9ViidSJPM36fqAQ@mail.gmail.com>
	<2504263.kbM6W9JoH9@linux-lqwf.site>
Date: Wed, 31 Oct 2012 10:08:40 +0800
Message-ID: <CACVXFVMRJPfPSC_4ZamqfYUSYNsMEVYXMFmcs26T=4MdB_Kntw@mail.gmail.com>
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

On Wed, Oct 31, 2012 at 12:30 AM, Oliver Neukum <oneukum@suse.de> wrote:
>> If the USB mass-storage device is being reseted, the flag should be set
>> already generally.  If the flag is still unset, that means the disk/network
>> device isn't added into system(or removed just now), so memory allocation
>> with block I/O should be allowed during the reset. Looks it isn't one problem,
>> isn't it?
>
> I am afraid it is, because a disk may just have been probed as the deviceis being reset.

Yes, it is probable, and sounds like similar with 'root_wait' problem, see
prepare_namespace(): init/do_mounts.c, so looks no good solution
for the problem, and maybe we have to set the flag always before resetting
usb device.


Thanks,
--
Ming Lei
