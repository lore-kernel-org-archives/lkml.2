Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0KAMML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:12:11 -0400
Received: from mail.sysgo.com ([195.145.229.155]:52584 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab0KAMMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:12:10 -0400
Date: Mon, 1 Nov 2010 13:11:59 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org
Subject: Re: carl9170 disconnects under load
Message-ID: <20101101121159.GB19442@pma.sysgo.com>
References: <20101026104811.GA11357@pma.sysgo.com>
 <20101101093140.GA2766@pma.sysgo.com>
 <20101101094649.GA3391@pma.sysgo.com>
 <20101101101012.GB3391@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101101012.GB3391@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > I'm testing driver from -wireless testing, cca 2.6.26-rc7.
> > > > 
> > > > It seems to work (up to 802.11n speeds -- I've seen iwconfig claiming
> > > > 121 MB/sec), but disconnects rather quickly when under load:
> > > > 
> > > > telnet 192.168.1.3 chargen > /dev/null
> > > > 
> > > > The machine is powerpc mpc5200b board, with OHCI driver -- it is not
> > > > capable of USB2.0 speeds.
> > > 
> > > So I tried with different AP, one not capable of 802.11n speeds. It
> > > fails in different way :-(. But this one is with my backport to
> > > 2.6.34...
> > 
> > But it fails with wireless-testing tree, too :-(.
> > 
> > Linux mpc5200b 2.6.36-rc8-wl-pma-48197-gdcae733-dirty #43 Tue Oct 26
> >  12:06:21 CEST 2010 ppc
> 
> It works "better" if I force AP to 1Mbps.... (Note that I have USB1.1
> host only).

Ok, so I tried on powerpc machine with usb2.0... it worked a bit
better, but after a reboot, I got this one:

usb 1-3: Atheros AR9170 is registered as 'phy0'
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): warning: maximal mount count reached, running e2fsck
is recommended
EXT3-fs (sda3): using internal journal
EXT3-fs (sda3): recovery complete
EXT3-fs (sda3): mounted filesystem with writeback data mode
warning: `proftpd' uses 32-bit capabilities (legacy support in use)
PHY: f0003000:01 - Link is Up - 100/Full
mpc5xxx_can f0000900.can: setting BTR0=0x07 BTR1=0x1c
FW: MAC RESET
wlan0: authenticate with 00:11:95:05:30:d7 (try 1)
wlan0: authenticated
wlan0: associate with 00:11:95:05:30:d7 (try 1)
wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x421 status=0
aid=1)
wlan0: associated
usb 1-3: no command feedback received (-110).
carl9170 cmd: 08 01 00 00 f0 36 1c 00 00 24 00 00
.....6...$..
usb 1-3: restart device (6)
writing reg 0x1c36f0 (val 0x2400) failed (-110)
lost 3 command responses/traps! w:13 g:0
writing reg 0x1d0104 (val 0x3) failed (-110)
usb 1-3: kill pending tx urbs.
usb 1-3: firmware upload failed (-110).
usb 1-3: stuck tx urbs!
usb 1-3: Failed to restart device  (-110).
writing reg 0x1c36f0 (val 0x2400) failed (-5)
writing reg 0x1c36f0 (val 0x2400) failed (-5)
writing reg 0x1c36f0 (val 0x5000) failed (-5)
wlan0: deauthenticating from 00:11:95:05:30:d7 by local choice
(reason=3)
usb 1-3: reset high speed USB device using ehci_hcd and address 3
cfg80211: Calling CRDA to update world regulatory domain
