Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1EWRgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:36:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58763 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932252Ab1EWRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:36:52 -0400
Date: Mon, 23 May 2011 13:33:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Jens Axboe <axboe@kernel.dk>, TejunHeo <tj@kernel.org>,
        Micha Nelissen <micha@neli.hopto.org>, lud <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB stick as root device does not work
In-Reply-To: <20110523101405.e3ccafe9.rdunlap@xenotime.net>
Message-ID: <Pine.LNX.4.44L0.1105231332090.2020-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, Randy Dunlap wrote:

> [adding cc: of linux-usb mailing list]

Better to ask people familiar with the block layer (CC'ed).

Alan Stern

> On Sun, 22 May 2011 16:13:17 +0200 Micha Nelissen wrote:
> 
> > Hi,
> > 
> > Using USB stick as root device does not work for me. I specify
> > 'root=/dev/sdb1 rootwait' on the kernel commandline, but the kernel does
> > not wait for the USB stick to be scanned and its partitions found. I
> > have a harddisk which is /dev/sda, and this USB stick would be /dev/sdb.
> > 
> > I think blk_lookup_devt returns the block device number even if it does
> > not exist yet, and init/do_mounts.c:473 therefore skips waiting:
> > 
> >         if ((ROOT_DEV == 0) && root_wait) {
> > 
> > due to ROOT_DEV having become non-zero already.
> > 
> > If I use the commandline: 'root=/dev/sdb1 rootdelay=5' then it does
> > mount and boot properly. However, using rootwait seems safer and faster
> > to me, that it's meant for this use case.
> > 
> > Thanks for any pointers,
> > 
> > Micha
> > --
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

