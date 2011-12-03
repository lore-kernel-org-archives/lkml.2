Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1LCRfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 12:35:13 -0500
Received: from shutemov.name ([188.40.19.243]:47832 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1LCRfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 12:35:10 -0500
Date: Sat, 3 Dec 2011 19:35:08 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Adam Jackson <ajax@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: i915: eDP regression
Message-ID: <20111203173508.GA15806@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit dc22ee6 introduces regression on my laptop HP EliteBook 8440p.  I see
nothing on the panel after mode setting. Reverting the commit fixes the issue.

$ sudo lspci -vv -xxxx -s 00:02.0
00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Hewlett-Packard Company Device 172a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 43
        Region 0: Memory at d0000000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 5058 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4179
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915
00: 86 80 46 00 07 04 90 00 02 00 00 03 00 00 00 00
10: 04 00 00 d0 00 00 00 00 0c 00 00 c0 00 00 00 00
20: 59 50 00 00 00 00 00 00 00 00 00 00 3c 10 2a 17
30: 00 00 00 00 90 00 00 00 00 00 00 00 0a 01 00 00
40: 09 00 0c 01 26 61 21 00 88 00 40 00 0f 17 17 17
50: 00 00 50 0b 09 00 00 00 00 00 00 00 00 00 00 be
60: 00 00 02 02 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 05 d0 01 00 0c f0 e0 fe 79 41 00 00 00 00 00 00
a0: 11 11 11 00 13 00 06 03 00 00 14 60 25 04 3a 30
b0: 00 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 a4 22 00 00 00 00 00 00 00 00 00 00 01 02 00
e0: 00 00 00 00 01 00 00 00 00 80 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 ab 0f 18 00 18 d0 6f bb

-- 
 Kirill A. Shutemov
