Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab1FFPFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:05:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFPFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:05:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] spi: reorganize drivers
Date: Mon, 6 Jun 2011 17:04:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-pcmcia@lists.infradead.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        "David S. Miller" <davem@davemloft.net>, Michael Buesch <mb@bu3sch.de>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Florian Fainelli <florian@openwrt.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
References: <20110605071725.26517.11573.stgit@ponder> <201106061457.43999.arnd@arndb.de> <20110606154447.51f07c7b@stein>
In-Reply-To: <20110606154447.51f07c7b@stein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061704.27196.arnd@arndb.de>
X-Provags-ID: V02:K0:agzHH3nU/wLtBMlLEXYlBBvzg3HjQdculDpQ7x7pj5X
 zpUxuLVhfdb6XmjRaQOuIRS0eQkZmB4VKu1bwhVHxre+76u+5X
 AmnZ4L0CTJGkSSt9FzpDG2RpM1nXB+KZjtJGgaBK7mT6gE5paz
 TXvEfH4J0dkAy1MzP9RpsnCPIO6zmI6UYu6V53hhHrcxjvkjuN
 wUCz20ybfLiDvX1qMNvhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011, Stefan Richter wrote:
> On Jun 06 Arnd Bergmann wrote:
> > On Monday 06 June 2011, Jean Delvare wrote:
> On drivers/firewire/:
> 
> FireWire drivers are currently spread over drivers/firewire (three
> link-layer controller drivers + the IEEE 1394 core + two IEEE 1394
> application layer drivers), drivers/media/dvb/firewire/ (one 1394
> application layer driver), sound/firewire/ (two 1394 application layer
> drivers, more are planned to be added there).
> 
> From the Linux driver model POV,
>   1. the IEEE 1394 core driver implements the firewire bus,
>   2. the link-layer controller drivers implement pci bus based devices,
>   3. the IEEE 1394 application layer drivers implement firewire bus based
>      devices.  The two of them that are located in drivers/firewire/
>      expose a SCSI LLD (a transport in SCSI Architecture Model terms, but
>      a host rather than a transport in Linux implementation terms) and a
>      networking interface driver.
> 
> Number 2 is something one would expect to find in a hypothetical
> drivers/bus/ directory.  But where do the others belong?
> 
> Would type 1 drivers be kept in drivers/bus/firewire/?  I understand your
> above response to Jean that this is what you have in mind.

Correct.

> firewire-sbp2 could be moved into drivers/scsi/, and firewire-net could be
> moved into drivers/net/.  But what about maintenance?  They could still be
> maintained via linux1394-2.6.git because this worked so far, but then the
> directory structure might irritate people who don't use
> scripts/get_maintainer.pl all the time.  Well, I could actually picture
> firewire-net to be maintained via the net development tree, but I do
> wonder how well firewire-sbp2 maintenance through the scsi tree would work.

I guess the real question is whether firewire should be considered a bus
like USB or a device class like SCSI, and it's abit of a grey area (SCSI
is too). If you declare it to be a bus, I'd suggest moving the sbp2 and
network drivers to drivers/scsi and drivers/net. If you like to think
of firewire as a closed subsystem instead, it's probably better to leave
all of it in drivers/firewire.

> PS,
> these are the same questions like with USB, only on a smaller scale.  (The
> usb-storage driver is maintained through the usb tree as well, not the
> scsi tree.  drivers/net/usb/ has got T: git .../gregkh/usb-2.6.git
> assigned in MAINTAINERS but most of the commits there are actually done by
> DaveM.)

The difference that I see with usb-storage is that this one is really
a set of different drivers for all sorts of devices, while the firewire sbp2
driver feels more like a single driver that includes a few special
cases. Also, USB is generally perceived as a generic interconnect, while
firewire is seen primarily as a way to attach disk drives.

The differences are of course gradual.

	Arnd
