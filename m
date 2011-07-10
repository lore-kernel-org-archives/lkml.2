Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1GJXu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:50:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45887 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab1GJXuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:50:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 11 Jul 2011 01:50:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Joel bourrigaud <joel@bourrigaud.info>,
        =?UTF-8?B?QmrDuHJu?= Forbord <bforbord@broadpark.no>,
        linux1394-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: ohci: do not bind to Pinnacle or Fujitsu HCI,
 prevent panic
Message-ID: <20110711015009.012a26d1@stein>
In-Reply-To: <20110711012422.1e585783@stein>
References: <20110604002938.78c85881@stein>
	<20110604010625.1a37638e@stein>
	<4DEA697A.1090104@bourrigaud.info>
	<20110612145303.2099aa81@stein>
	<4DF4FF4F.4020607@bourrigaud.info>
	<20110612210111.3e979131@stein>
	<4DF528CF.50407@bourrigaud.info>
	<20110709235410.08004e5d@stein>
	<4E1A161D.1050304@ladisch.de>
	<20110711012422.1e585783@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 11 Stefan Richter wrote:
> This device with link layer PCI IDs 11bd:0015 and 1394 PHY IDs
> 00000e:086613 is apparently a Fujitsu MB86613 --- hence the PHY IDs.
> Therefore, blacklist the MB86613 too

On the other hand, maybe the original MB86613 does not exhibit the issue.
The Pinnacle device is combined with another device or function, hence not
identical with MB86613:

0c:07.0 Multimedia controller [0480]: Pinnacle Systems Inc. AV/DV Studio Capture Card [11bd:bede]
        Subsystem: Pinnacle Systems Inc. Device [11bd:0023]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort+ >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 4000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at fb7ff000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

0c:07.1 FireWire (IEEE 1394) [0c00]: Pinnacle Systems Inc. Device [11bd:0015] (prog-if 10 [OHCI])
        Subsystem: Pinnacle Systems Inc. Device [11bd:0023]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (8000ns min, 20000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at fb7fe800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel modules: firewire-ohci

BTW, I dimly remember hear-say about Fujitsu controllers, particularly
because they are among the few (or the only ones?) that featured a
programmable PhysicalUpperBound.  So there was at least one Linux users who
had such a controller; perhaps as onboard controllers of a Fujitsu
notebook.  (Which has got a shorter service life expectancy than a PCI
card...)
-- 
Stefan Richter
-=====-==-== -=== -=-==
http://arcgraph.de/sr/
