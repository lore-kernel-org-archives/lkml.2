Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab0HaKmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:42:09 -0400
Received: from dtp.xs4all.nl ([80.101.171.8]:40545 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754220Ab0HaKmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:42:07 -0400
Date: Tue, 31 Aug 2010 12:42:05 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Roger Wolff <R.E.Wolff@BitWizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100831104205.GA2301@bitwizard.nl>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201008302333.22447.arnd@arndb.de> <20100830232800.3cb768fc@lxorguk.ukuu.org.uk> <201008311126.45190.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008311126.45190.arnd@arndb.de>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

The question is whether I want the drivers I wrote to stay or to
go away?

I was paid years ago to make Linux support the Specialix cards. It
started with one card from their line of "solutions", but the others
followed.

I personally don't use "serial" very much anymore. If I do, I end up
getting an USB-serial converter for $3 in China (includes shipping).

But my personal interest in the serial protocol is that I interface
with microcontrollers. The mess of the +/- 12V levels is a nuisance. 

Other people might use "serial" devices because they are stuck with a
historical setup. If you have a factory with a well-designed computer
system, it is very well possible that some installations are still
running with a serial terminal on every desk. Some desks will have a
windows PC and a terminal application, but the serial interface to the
central "mainframe" will still be maintained.

Those central "mainframes" might be Linux PCs. The Linux PCs replaced
older hardware and software. Maybe they were running SCO or another
Unix variant, and through the years the application was ported to
Linux. 

In those setups, I can imagine a 8-port or 32-port serial card to be
useful. It would be nice that people supporting that sort of setup
would be able to install Ubuntu 10.10 and have their hardware simply
work. Buying new multiport serial cards seems unneccesary unless they
are ISA. But specialix cards are available in PCI. So if you already
have PCI cards why force them to new hardware if they have hardware
that works?

Oh! One more thing. The sysops at shops that use these multiport
serial cards are not the types to monitor Linux-kernel and make waves
if support for their card is going to be dropped.

Now I've missed the first part of this discussion... Is there a change
imminent that requires rewriting of all the drivers?


(If rewriting serial drivers, PLEASE make it so that the
userspace-kernel interface just passes a baud rate integer, not the
one-of-16-possible baudrate-flags. The old stuff can be emulated in a
library. Secondly serial port drivers should NOT have to worry about
DCD changes and what to do with sleeping processes. The driver should
have an kernel function to call: "hey, one of the control lines
changed level. These are the new ones". And "These characters
arrived". And the driver has an entry point: "please send these
characters". )

	Roger. 


On Tue, Aug 31, 2010 at 11:26:45AM +0200, Arnd Bergmann wrote:
> On Tuesday 31 August 2010, Alan Cox wrote:
> > > drivers/char/tty_*      -> tty/*
> > > drivers/char/{vt stuff} -> tty/vt/
> > > drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
> > > drivers/serial/*        -> drivers/tty/serial/*
> > 
> > There are dead bits in there too we should prune 68xxx stuff mostly
> 
> Geert, can you comment on the 68k serial drivers? Which
> ones are to stay, which ones can get phased out?
> 
> > > drivers/usb/serial      -> drivers/usb/serial
> > > 
> > > cyclades,moxa,mxser     -> drivers/tty/hw/
> > > 
> > > stallion,istallion,
> > > epca,specialix,ip2,
> > > riscom,isicom           -> drivers/staging/tty/*
> > 
> > isicom has users and gets tested a bit, not sure about ip2/specialix.
> 
> I'll leave isicom then.
> 
> Specialix is marked in MAINTAINERS as supported by Roger, ip2
> is maintained by Michael, maybe they have a preference for their
> drivers.
> 
> Both drivers have a web page that is ~10 years old, which hints
> that there is probably not much new hardware around.
> 
> > > generic_serial,vme_scc,
> > > ser_a2232,sx,rio        -> drivers/staging/generic_serial/*
> > > 
> > > amiserial,nozomi,
> > > serial167,synclink      -> drivers/tty/hw (?)
> > 
> > Why /hw - its a tty driver so drivers/tty - the non hw stuff is now in
> > tty/
> 
> Right, makes sense.
> 
> > serial167 is dead/staging stuff, synclink* are used
> 
> ok
>  
> > > bfin_jtag_comm          -> drivers/tty/hvc/hvc_bfin_jtag (?)
> > 
> > Nothing to do with hvc
> 
> Not yet ;-)
> 
> You didn't reply to my question why it couldn't be. I'll let Mike
> judge this one when he has looked at the hvc infrastructure.
> 
> I wouldn't move it to that directory unless the code gets changed
> first, but I wanted to write down where I think it should end up.
> 
> > > rocket,ipwireless       -> drivers/staging/tty/* (?)
> > 
> > Rocket is used, ipwireless I think is also used
> 
> ok.
> 
> 	Arnd
> 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
