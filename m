Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0EGP07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:26:59 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:49249 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab0EGP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:26:58 -0400
Date: Fri, 7 May 2010 17:26:40 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: UBIFS: Oops while rebooting 2.6.34-rc6
Message-ID: <20100507152640.GX30801@buzzloop.caiaq.de>
References: <20100507131652.GT30801@buzzloop.caiaq.de>
 <1273245826.4537.294.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273245826.4537.294.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 06:23:46PM +0300, Artem Bityutskiy wrote:
> On Fri, 2010-05-07 at 15:16 +0200, Daniel Mack wrote:
> > Hi,
> > 
> > We've had a kernel Oops today when rebooting an ARM PXA based machine
> > while file I/O via SSH was outstanding.
> > 
> > Daniel
> > 
> > # reboot
> > # [  671.190085] UBIFS: un-mount UBI device 0, volume 1
> > The system is going down NOW!
> > Sent SIGTERM to all processes
> > [  672.083833] Unable to handle kernel NULL pointer dereference at virtual address 000000ac
> > [  672.094587] pgd = c0004000
> > [  672.097301] [000000ac] *pgd=00000000
> > [  672.100850] Internal error: Oops: 817 [#1]
> > [  672.104919] last sysfs file: /sys/devices/platform/spi_gpio.0/spi0.2/value
> 
> It's Firday, and I want to go home, so here is another quick idea for
> you where to dig.
> 
> When the system reboots it re-mounts the FS to RO mode, usually. And
> there is some emergency remount business (see do_emergency_remount()),
> which will re-mount the FS even if there are files opened for writing.
> 
> So, if there is a UBIFS or VFS bug, and somehow one process is in
> make_reservation() and is about to write something, and another process
> managed to re-mount the FS to R/O mode, then we may ooops, because UBIFS
> frees these 'wbuf' objects when it is mounted to R/O (see
> ubifs_remount_ro()).
> 
> So, inject printks to ubifs_remount_ro() to check this theory.
> 
> Have a nice weekend and bughunting!

Thanks for your feedback - I'll give that a try next week.

Have a good weekend :)

Daniel
