Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab1KJM4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:56:50 -0500
Received: from hercules.aytolacoruna.es ([212.51.63.15]:60053 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1KJM4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:56:48 -0500
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Nov 2011 07:56:48 EST
Date: Thu, 10 Nov 2011 13:47:42 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: problems with pata_via, hangs after random time
Message-ID: <20111110124742.GA3246@vip.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

As kernel 3.1.0 was released I decided to switch from legacy IDE drivers to
the new ones, thus activating CONFIG_PATA_VIA=y on my config and turning off
all the old IDE drivers, those where the only things I touched on my config.

The result was a 1 day uptime and then a total freeze with even the keyboard
not responding and the HD led on all the time.  Then I rebooted the machine
and started to search for problems with pata_via and saw a few people
complaining about hangs on both fedora, ubuntu and red hat but everything
was old (early 2.6.30's) and they had not found the root of the problem,
even though some sugestions said that it was due to HPET but I don't have it
enabled.

Today, after an uptime of almost 15 days I got the second hang, again
everything dead with the keyboard not responding, the screen again showed
normal condition, no kernel messages or anything and again the led was on
all the time, again, I have just rebooted it.

Computer is a PIII 1Ghz with a via based motherboard with this ide chip:

00:07.1 0101: 1106:0571 (rev 10) (prog-if 8a [Master SecP PriP])
00:07.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 10) (prog-if 8a [Master SecP PriP])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
        Region 4: I/O ports at e400 [size=16]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pata_via

Right now for the first time as I switched to run lspci I got this error:

ata2: lost interrupt (Status 0x50)
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: cmd ca/00:80:3f:9c:fe/00:00:00:00:00/e0 tag 0 dma 65536 out
         res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting link
ata2.00: configured for UDMA/66
ata2.00: device reported invalid CHS sector 0
ata2: EH complete

I had never seen this error before and running a grep on all logs looking for
"lost interrupt" only returned this error, no prior ones.

I'm thinking of this problems as via_pata based because of my changes on the
config, but I really don't know if this is the case or if the hardware is
starting to fail, so maybe the best thing to do for now is to go back to the
old IDE drivers and seek high uptimes there and if everything is ok then go
back to try to debug this, as we don't have much info right now.

I'm waiting for comments on what to do with this.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
