Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2LPUsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:48:10 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:4071 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2LPUsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:48:08 -0500
Date: Sun, 16 Dec 2012 21:48:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] swim: Add missing spinlock init
Message-ID: <20121216214800.3ad603b4@endymion.delvare>
In-Reply-To: <CAMuHMdUXvB8P9J26KbMXeicv0BH=gdaCHaRq-ZAP=73hn+ThMw@mail.gmail.com>
References: <20120906134830.52cbdfec@endymion.delvare>
	<CAMuHMdUXvB8P9J26KbMXeicv0BH=gdaCHaRq-ZAP=73hn+ThMw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thu, 6 Sep 2012 14:03:27 +0200, Geert Uytterhoeven wrote:
> On Thu, Sep 6, 2012 at 1:48 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > It doesn't seem this spinlock was properly initialized.
> 
> Quiet possible. There's no SMP on m68k, so all spinlock ops expand to nothing.

Can we apply my patch still? Or were you suggesting you're fine with
the code as it is?

Certainly this isn't my area of expertise but I don't quite get the
point of passing a custom lock to blk_init_queue() if locks resolve to
nothing anyway.

> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Finn Thain <fthain@telegraphics.com.au>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> > I can't even build-test this.
> >
> >  drivers/block/swim.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > --- linux-3.6-rc4.orig/drivers/block/swim.c     2012-07-21 22:58:29.000000000 +0200
> > +++ linux-3.6-rc4/drivers/block/swim.c  2012-09-06 13:09:26.713382169 +0200
> > @@ -845,6 +845,7 @@ static int __devinit swim_floppy_init(st
> >                 swd->unit[drive].swd = swd;
> >         }
> >
> > +       spin_lock_init(&swd->lock);
> >         swd->queue = blk_init_queue(do_fd_request, &swd->lock);
> >         if (!swd->queue) {
> >                 err = -ENOMEM;

-- 
Jean Delvare
