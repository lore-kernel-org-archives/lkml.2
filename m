Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0H3Lhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:37:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0H3Lhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:37:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Mon, 30 Aug 2010 13:37:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <20100830001855.1071b6fc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100830001855.1071b6fc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301337.27672.arnd@arndb.de>
X-Provags-ID: V02:K0:zeQoXAol+nVqQzkHxdiLw543vBxv3LhFbNGirk/MNaz
 sP5VSkZUALagRYp+omkXGL/aMdcCeBtu19QirIAzAdCm6rwJUY
 wtxLBoHkNLOf5UKqVLWgiv/pUxz3QqbTuYQds1yPht6UkAkDvq
 jCSbPktYAI216RCtp2wvjmu3RYCy7dELpJRzIBbX7bVv5AJ6Do
 D9sJEtDUehFobQUPK0DkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010, Alan Cox wrote:
> > Of course, moving stuff around always has the tendency to
> > break patches against it, so we might not want to do this after
> > all.
> > 
> > Any other opinions?
> 
> Linus actually suggested this should get done in some form a while ago
> back when I was tty maintainer but about the same time as I decided not
> to be.

ok.

> >   tty: move tty layer code to drivers/tty
> 
> I would be tempted to put the core stuff in /tty as its not drivers

Do you consider vt to be core (I guess yes)? What about hvc (I guess no)?

> >   tty/vt: move files to drivers/tty/vt/
> >   tty/hvc: move files to drivers/tty/hvc
> >   tty/hw: move hardware drivers to drivers/tty/hw
> >   tty: rearrange Kconfig structure
> 
> drivers/serial should also walk into tty I think ?

Yes, good point.

> drivers/pcmcia/serial is a bit trickier but I guess should stay as with
> drivers/usb/serial

I don't see drivers/pcmcia/serial. Are you thinking of the tty drivers
in drivers/char/pcmcia? I moved both of these to drivers/tty/hw
in my patch.

> There are several unbuildable ancient drivers. Perhaps if we are having
> the great rename those should simply get deleted first, as there is no
> way to test them in their current config ?

These are the drivers I was planning to move:
+obj-$(CONFIG_MVME147_SCC)      += generic_serial.o vme_scc.o
+obj-$(CONFIG_MVME162_SCC)      += generic_serial.o vme_scc.o
+obj-$(CONFIG_BVME6000_SCC)     += generic_serial.o vme_scc.o
+obj-$(CONFIG_ROCKETPORT)       += rocket.o
+obj-$(CONFIG_SERIAL167)        += serial167.o
+obj-$(CONFIG_CYCLADES)         += cyclades.o
+obj-$(CONFIG_STALLION)         += stallion.o
+obj-$(CONFIG_ISTALLION)        += istallion.o
+obj-$(CONFIG_NOZOMI)           += nozomi.o
+obj-$(CONFIG_DIGIEPCA)         += epca/
+obj-$(CONFIG_SPECIALIX)        += specialix.o
+obj-$(CONFIG_MOXA_INTELLIO)    += moxa.o
+obj-$(CONFIG_A2232)            += ser_a2232.o generic_serial.o
+obj-$(CONFIG_ATARI_DSP56K)     += dsp56k.o
+obj-$(CONFIG_MOXA_SMARTIO)     += mxser.o
+obj-$(CONFIG_COMPUTONE)        += ip2/
+obj-$(CONFIG_RISCOM8)          += riscom8.o
+obj-$(CONFIG_ISI)              += isicom.o
+obj-$(CONFIG_SYNCLINK)         += synclink.o
+obj-$(CONFIG_SYNCLINKMP)       += synclinkmp.o
+obj-$(CONFIG_SYNCLINK_GT)      += synclink_gt.o
+obj-$(CONFIG_SYNCLINK_CS)      += synclink_cs.o
+obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
+obj-$(CONFIG_BFIN_JTAG_COMM)   += bfin_jtag_comm.o
+obj-$(CONFIG_SX)               += sx.o generic_serial.o
+obj-$(CONFIG_RIO)              += rio/ generic_serial.o
+obj-$(CONFIG_IPWIRELESS)       += ipwireless/

Which of these do you think should get deleted?

AFAICT, the only ones that are getting nontrivial updates once in
a while are amiserial, bfin_jtag_comm, isicom, cyclades. moxa, mxser,
nozomi, serial167, stallion and synclink, while the users of
generic_serial.o seem to be the ones getting the least attention.

	Arnd
