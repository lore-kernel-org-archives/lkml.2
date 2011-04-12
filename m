Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1DLLqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:46:47 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:41296 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751794Ab1DLLqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:46:46 -0400
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Gabriel Paubert <paubert@iram.es>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Date: Tue, 12 Apr 2011 13:46:10 +0200
In-Reply-To: <20110412113033.GA16649@iram.es>
References: <20110404235259.GA30132@iram.es>
	 <20110406084101.GB13963@pengutronix.de>
	 <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
	 <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local>
	 <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local>
	 <20110412113033.GA16649@iram.es>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.0- 
Message-ID: <1302608770.27054.36.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2011-04-12 at 13:30 +0200, Gabriel Paubert wrote: 
> 
> On Mon, Apr 11, 2011 at 05:32:43PM +0200, Michel Dänzer wrote:
> > 
> > Have you ruled out any MSI related problems? I think the IRQ not working
> > could explain the symptoms...
> 
> Booting with MSI disabled does not change anything. Actually on this
> machine the Ethernet (tigon3) uses MSI and everything is fine. OTOH,
> on my home PC (dual code Athlon64 4 1/2 years old), MSI has never worked.

Okay, the fact no_wb helps probably rules out an IRQ problem anyway.


> > Make sure this line changes to 'WB disabled' with no_wb=1. There's a
> > writeback endianness bug with modeset=1, see
> > http://lists.freedesktop.org/archives/dri-devel/2011-April/009960.html .
> > 
> 
> With no_wb=1 the driver goes a bit further but the X server ends
> up in an infinite ioctl loop and the logs are: 

Which ioctl does it loop on? Please provide the Xorg.0.log file as well.


> kernel: [drm] radeon kernel modesetting enabled.
> kernel: checking generic (c0000000 140000) vs hw (c0000000 10000000)
> kernel: fb: conflicting fb hw usage radeondrmfb vs OFfb vga,Displa - removing generic driver
> kernel: [drm] initializing kernel modesetting (RV530 0x1002:0x71C7).
> kernel: radeon 0000:f1:00.0: Using 64-bit DMA iommu bypass
> kernel: [drm] register mmio base: 0xE8000000
> kernel: [drm] register mmio size: 65536
> kernel: radeon 0000:f1:00.0: Invalid ROM contents
> kernel: ATOM BIOS: X1650PRO
> kernel: [drm] Generation 2 PCI interface, using max accessible memory
> kernel: radeon 0000:f1:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
> kernel: radeon 0000:f1:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
> kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> kernel: [drm] Driver supports precise vblank timestamp query.
> kernel: [drm] radeon: irq initialized.
> kernel: [drm] Detected VRAM RAM=512M, BAR=256M
> kernel: [drm] RAM width 128bits DDR
> kernel: [TTM] Zone  kernel: Available graphics memory: 1003018 kiB.
> kernel: [TTM] Initializing pool allocator.
> kernel: [drm] radeon: 512M of VRAM memory ready
> kernel: [drm] radeon: 512M of GTT memory ready.
> kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
> kernel: [drm] radeon: 1 quad pipes, 2 z pipes initialized.
> kernel: [drm] PCIE GART of 512M enabled (table at 0x00040000).
> kernel: radeon 0000:f1:00.0: WB disabled
> kernel: [drm] Loading R500 Microcode
> kernel: [drm] radeon: ring at 0x0000000020001000
> kernel: [drm] ring test succeeded in 6 usecs
> kernel: [drm] radeon: ib pool ready.
> kernel: [drm] ib test succeeded in 0 usecs
> kernel: [drm] Radeon Display Connectors
> kernel: [drm] Connector 0:
> kernel: [drm]   DVI-I
> kernel: [drm]   HPD1
> kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
> kernel: [drm]   Encoders:
> kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> kernel: [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
> kernel: [drm] Connector 1:
> kernel: [drm]   S-video
> kernel: [drm]   Encoders:
> kernel: [drm]     TV1: INTERNAL_KLDSCP_DAC2
> kernel: [drm] Connector 2:
> kernel: [drm]   DVI-I
> kernel: [drm]   HPD2
> kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
> kernel: [drm]   Encoders:
> kernel: [drm]     CRT2: INTERNAL_KLDSCP_DAC2
> kernel: [drm]     DFP3: INTERNAL_LVTM1
> kernel: [drm] Possible lm63 thermal controller at 0x4c
> kernel: [drm] fb mappable at 0xC00C0000
> kernel: [drm] vram apper at 0xC0000000
> kernel: [drm] size 9216000
> kernel: [drm] fb depth is 24
> kernel: [drm]    pitch is 7680
> kernel: checking generic (c0000000 140000) vs hw (c0000000 10000000)
> kernel: fb: conflicting fb hw usage radeondrmfb vs OFfb vga,Displa - removing generic driver
> kernel: fb1: radeondrmfb frame buffer device

Hmm, I think this should say fb0, but that should only matter for
console, not X.

> kernel: drm: registered panic notifier
> kernel: [drm] Initialized radeon 2.8.0 20080528 for 0000:f1:00.0 on minor 0
> kernel: [drm:drm_mode_getfb] *ERROR* invalid framebuffer id

BTW, if your kernel contains commit
69a07f0b117a40fcc1a479358d8e1f41793617f2, can you try if reverting that
helps?


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
