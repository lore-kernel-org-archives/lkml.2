Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0HaJ0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:26:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0HaJ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:26:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Tue, 31 Aug 2010 11:26:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Roger Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201008302333.22447.arnd@arndb.de> <20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008311126.45190.arnd@arndb.de>
X-Provags-ID: V02:K0:jAhFcCOcdvapTqpzDscUCCmIwVPHbgS5FY2UDwyXbfb
 QAILFKxdyt4z3yxgO84Wr35W2+DOqxekO8ADIj0DS3YzWdJPcz
 NnUyy783KEQ71P+zX+dBfWOLG81YfVGrX0BESPvgVUVAAngSfD
 xQCv2fxzYpf14IfGTp/4Sh+TEH22sbosG/m49FBkM5TBv7p+L4
 manqCmtxe1mFHa/xBR0hA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 August 2010, Alan Cox wrote:
> > drivers/char/tty_*      -> tty/*
> > drivers/char/{vt stuff} -> tty/vt/
> > drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
> > drivers/serial/*        -> drivers/tty/serial/*
> 
> There are dead bits in there too we should prune 68xxx stuff mostly

Geert, can you comment on the 68k serial drivers? Which
ones are to stay, which ones can get phased out?

> > drivers/usb/serial      -> drivers/usb/serial
> > 
> > cyclades,moxa,mxser     -> drivers/tty/hw/
> > 
> > stallion,istallion,
> > epca,specialix,ip2,
> > riscom,isicom           -> drivers/staging/tty/*
> 
> isicom has users and gets tested a bit, not sure about ip2/specialix.

I'll leave isicom then.

Specialix is marked in MAINTAINERS as supported by Roger, ip2
is maintained by Michael, maybe they have a preference for their
drivers.

Both drivers have a web page that is ~10 years old, which hints
that there is probably not much new hardware around.

> > generic_serial,vme_scc,
> > ser_a2232,sx,rio        -> drivers/staging/generic_serial/*
> > 
> > amiserial,nozomi,
> > serial167,synclink      -> drivers/tty/hw (?)
> 
> Why /hw - its a tty driver so drivers/tty - the non hw stuff is now in
> tty/

Right, makes sense.

> serial167 is dead/staging stuff, synclink* are used

ok
 
> > bfin_jtag_comm          -> drivers/tty/hvc/hvc_bfin_jtag (?)
> 
> Nothing to do with hvc

Not yet ;-)

You didn't reply to my question why it couldn't be. I'll let Mike
judge this one when he has looked at the hvc infrastructure.

I wouldn't move it to that directory unless the code gets changed
first, but I wanted to write down where I think it should end up.

> > rocket,ipwireless       -> drivers/staging/tty/* (?)
> 
> Rocket is used, ipwireless I think is also used

ok.

	Arnd
