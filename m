Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423135Ab2JaPUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:20:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43461 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422815Ab2JaPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:20:04 -0400
Date: Wed, 31 Oct 2012 11:20:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Oliver Neukum <oneukum@suse.de>, <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH v3 2/6] PM / Runtime: introduce pm_runtime_set[get]_memalloc_noio()
In-Reply-To: <CACVXFVNxucCVLS-=EQkmVop3LQMkeXW7RbZq4yfkiq_MUGndvg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1210311117310.1954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Ming Lei wrote:

> The below idea may help the problem which 'memalloc_noio' flag isn't set during
> usb_reset_device().
> 
> - for usb mass storage device, call pm_runtime_set_memalloc_noio(true)
>   inside usb_stor_probe2() and uas_probe(), and call
>   pm_runtime_set_memalloc_noio(false) inside uas_disconnect()
>   and usb_stor_disconnect().

Why would you want to do that?  The probe and disconnect routines
usually -- but not always -- run in the khubd thread.  Surely you don't
want to prevent khubd from using GFP_KERNEL?

And what if probe runs in khubd but disconnect runs in a different 
thread?

Alan Stern

