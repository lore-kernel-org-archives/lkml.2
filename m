Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1DKPdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:33:32 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:37036 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754410Ab1DKPda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:33:30 -0400
X-Amavis-Alert: BAD HEADER SECTION, Improper folded header field made up
	entirely of whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n
	jycPrvgA\n\t\n R1goSzOnkp14Y[...]
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Gabriel Paubert <paubert@iram.es>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <20110411133128.GA24344@iram.es>
References: <20110404235259.GA30132@iram.es>
	 <20110406084101.GB13963@pengutronix.de>
	 <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
	 <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local>
	 <20110411133128.GA24344@iram.es>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 17:32:43 +0200
Message-ID: <1302535963.24704.268.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding the dri-devel list ]

On Mon, 2011-04-11 at 15:31 +0200, Gabriel Paubert wrote: 
> On Thu, Apr 07, 2011 at 04:04:35PM +0200, Michel Dänzer wrote:
> > On Mit, 2011-04-06 at 22:43 +0200, Gabriel Paubert wrote: 
> > > 
> > > The probem is that, at least on one of my machines, the new driver
> > > does not work: the system hangs (apparently solid, but it's before
> > > networking starts up and I've not yet hooked up a serial console), 
> > > after the "radeon: ib pool ready" message.
> > 
> > Does radeon.agpmode=-1 radeon.no_wb=1 help?
> > 
> > You might be able to get more information via netconsole if you prevent
> > the radeon module from loading automatically (or load it with
> > radeon.modeset=0 first) and then load it e.g. via ssh with modeset=1.
> 
> Loading the module with modeset=1 results in insmod blocked in
> kernel state (not consuming CPU cycles either). The last kernel 
> message is always the same (ib pool ready). This seems to be 
> independent of agpmode and no_wb. The kernel messages when
> loading the driver are:
> 
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
> kernel: irq: irq 9 on host /mpic mapped to virtual irq 24
> kernel: u3msi: allocated virq 0x18 (hw 0x9) addr 0xf8004090
> kernel: radeon 0000:f1:00.0: radeon: using MSI.

Have you ruled out any MSI related problems? I think the IRQ not working
could explain the symptoms...

> kernel: [drm] radeon: irq initialized.
> kernel: [drm] Detected VRAM RAM=512M, BAR=256M
> kernel: [drm] RAM width 128bits DDR
> kernel: [TTM] Zone  kernel: Available graphics memory: 1002914 kiB.
> kernel: [TTM] Initializing pool allocator.
> kernel: [drm] radeon: 512M of VRAM memory ready
> kernel: [drm] radeon: 512M of GTT memory ready.
> kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
> kernel: [drm] radeon: 1 quad pipes, 2 z pipes initialized.
> kernel: [drm] PCIE GART of 512M enabled (table at 0x00040000).
> kernel: radeon 0000:f1:00.0: WB enabled

Make sure this line changes to 'WB disabled' with no_wb=1. There's a
writeback endianness bug with modeset=1, see
http://lists.freedesktop.org/archives/dri-devel/2011-April/009960.html .

> kernel: [drm] Loading R500 Microcode
> kernel: [drm] radeon: ring at 0x0000000020001000
> kernel: [drm] ring test succeeded in 6 usecs
> kernel: [drm] radeon: ib pool ready.


> For now, with modeset=0, agpmode=-1 and no_wb=1, the driver
> seems to work.

The agpmode and no_wb options only have an effect with modeset=1, and
you don't seem to be using AGP anyway. :)


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
