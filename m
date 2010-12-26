Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0LZTvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 14:51:31 -0500
Received: from nm14-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.234]:34450 "HELO
	nm14-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752613Ab0LZTv3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 14:51:29 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 784259.48555.bm@omp1012.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=UzVgwqLogfzYFtPREtcsyQFC6UGTA6lSjn/LN3l0qyXm/5SDIFrX4pKWgagSVqGGYFBvqjEaYNWl9jDpS3aTmRWCoFBLP+H1tlC3ERJABnK3Pip5qlfUq01Uva0DqszZdpYzgqq7s9pnURnbhWNmV29tarbqgszxynf2wSjznU4=;
Message-ID: <620568.36178.qm@web65706.mail.ac4.yahoo.com>
X-YMail-OSG: kYLPg_4VM1l0i02s4I1v4tFIAj.lsNZGGDNm4R7KXiLlNLE
 _wGBnbJZC9sfcTnIofUvCGL5dXcUtTkimDrplSnOgGgER4.uX8CYHHlQVxaa
 e.IMlcTNn.0oCOLb96vLBvQkVyiSdR4Frk4gqzM31Ito4K70ajO5GuCeBYVV
 YzrLiltadZNgXolnl_toFZiWTFYAH13AQK4cXqj6RpVTfvl.h0n5660QqGMY
 tRAavCRpWM6ES1eb_i0jHVl6PO.ZxOHbpZAnc0a_Gx4xRek4sfXK0jDjr86Y
 prJ7.zBccevyqlmvkLQx7UIMneFN_18pp52vRsr3RjBKAuPcJSZ0SY6QGsGC
 d.XKblfBQvtgac_rJwc5f3u7xvv2xRLqQiIcmmoHXn4ubAxllbm1zz2699om
 QNjjDnl8NR4xS7AXNJFHxJp5CZw--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Sun, 26 Dec 2010 11:51:28 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101226184124.GA29774@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Many thanks for your reply. I will try to install git and download the latest release candidate. I see that 2.6.37.rc7 is already available. I think I will also hope to find get_icount there to address Pete's concern,

Thank you again,
 Vadim.

--- On Sun, 12/26/10, Greg KH <gregkh@suse.de> wrote:

> From: Greg KH <gregkh@suse.de>
> Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
> To: "Tsozik" <tsozik@yahoo.com>
> Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Sunday, December 26, 2010, 1:41 PM
> On Sat, Dec 25, 2010 at 09:39:39PM
> -0800, Tsozik wrote:
> > From: Vadim Tsozik <tsozik@yahoo.com>
> > 
> > Added mct_u232_ioctl function and implemented
> TIOCMIWAIT and TIOCGICOUNT commands. MCT u232 p9 is one of a
> few usb to serail adapters which converts USB +/-5v voltage
> levels to COM +/-15 voltages. So it can also power COM
> interfaced devices. This makes it very usable for legacy COM
> interfaced data-acquisition hardware. I tested new
> implementation with AWARE Electronics RM-60 radiation meter,
> which sends pulse via RNG COM line whenever new particle is
> registered.
> > 
> > Patch below is based on
> linux-2.6.35.10-72.fc14.x86_64.
> 
> Care to make sure this applies on a kernel that we can
> actually apply
> patches to (i.e 2.6.37-rc6?)  The .35 kernel was a
> long time ago.
> 
> > 
> > Signed-off-by: Vadim Tsozik <tsozik@yahoo.com>
> > 
> > ---
> > --- original/mct_u232.c 2010-12-25 21:31:13.744174626
> -0500
> > +++ mct_u232.c  2010-12-25 21:44:57.714640343
> -0500
> 
> Care to read over Documentation/SubmittingPatches which
> shows you the
> proper patch level to make a patch against?
> 
> > @@ -24,6 +24,12 @@
> >   *   Basic tests have
> been performed with minicom/zmodem transfers and
> >   *   modem dialing
> under Linux 2.4.0-test10 (for me it works fine).
> >   *
> > + * 24-Apr-2010 Vadim Tsozik <tsozik@yahoo.com>
> > + *   - Added implementation of
> 'TIOCMIWAIT' and 'TIOCGICOUNT' ioctls.
> > + *     This routines are
> necessary if you use mct u232 p9 as data
> > + *     acquisition interface.
> These routines were tested with RM-60 AWARE
> > + *     Electronics Radiation
> Monitor.
> > + *
> 
> No need to ever add an entry here, your changelog
> information is now
> stored in git,  not in the files themselves.
> 
> >   * 04-Nov-2003 Bill Marr <marr at
> flex dot com>
> >   *   - Mimic Windows
> driver by sending 2 USB 'device request' messages
> >   *     following
> normal 'baud rate change' message.  This allows data to
> be
> > @@ -78,6 +84,8 @@
> >  #include <asm/unaligned.h>
> >  #include <linux/usb.h>
> >  #include <linux/usb/serial.h>
> > +#include <linux/serial.h>
> > +#include <linux/ioctl.h>
> >  #include "mct_u232.h"
> > 
> >  /*
> > @@ -104,6 +112,8 @@ static void
> mct_u232_break_ctl(struct tt
> >  static int  mct_u232_tiocmget(struct
> tty_struct *tty, struct file *file);
> >  static int  mct_u232_tiocmset(struct
> tty_struct *tty, struct file *file,
> >               
>          unsigned int set,
> unsigned int clear);
> > +static int  mct_u232_ioctl(struct tty_struct
> *tty, struct file *file,
> > +             
>           unsigned int cmd,
> unsigned long arg);
> >  static void mct_u232_throttle(struct tty_struct
> *tty);
> >  static void mct_u232_unthrottle(struct
> tty_struct *tty);
> > 
> > @@ -150,6 +160,7 @@ static struct usb_serial_driver
> mct_u232
> >         .tiocmset
> =          mct_u232_tiocmset,
> >         .attach = 
>           mct_u232_startup,
> >         .release = 
>          mct_u232_release,
> > +       .ioctl =   
>          mct_u232_ioctl,
> 
> Your email client converted the tabs to spaces, making this
> patch
> unable to apply.  Please fix your email client and
> also run your patch
> through the scripts/checkpatch.pl script before sending it
> to fix up the
> formatting errors that are in it.
> 
> Care to try again after doing this, and addressing Pete's
> concerns?
> 
> thanks,
> 
> greg k-h
> 


      
