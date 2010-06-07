Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0FGJ2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:28:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60287 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0FGJ2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:28:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: [Regression, post-rc1] Multiple issues after enabling SetVoltage on rs780m
Date: Mon, 7 Jun 2010 11:29:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006071129.32159.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

Your commit 9349d5cc920c10845693f906ebd67f394f1d0d04
(drm/radeon/kms/pm: enable SetVoltage on r7xx/evergreen) has caused my test-bed
Acer Ferrari One to behave quite unreliably.  The symptoms are:

- the system hangs hard (~ 50% of the time) when starting Xorg
- the system hangs hard (~ 50% of the time) when stopping Xorg during system
  reboot
- the system sometimes hangs hard during suspend to RAM

These problems are not reproducible with the commit above reverted.

Below is the information about the graphics adapter from lspci.

Rafael



01:05.0 VGA compatible controller: ATI Technologies Inc RS780M/RS780MN [Radeon HD 3200 Graphics] (prog-if 00 [VGA controller])
	Subsystem: Acer Incorporated [ALI] Device 029e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at a0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 9000 [size=256]
	Region 2: Memory at 9fdf0000 (32-bit, non-prefetchable) [size=64K]
	Region 5: Memory at 9fe00000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: radeon
