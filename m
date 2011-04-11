Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1DKNbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 09:31:45 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:41912 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1DKNbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 09:31:44 -0400
Date: Mon, 11 Apr 2011 15:31:28 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110411133128.GA24344@iram.es>
References: <20110404235259.GA30132@iram.es> <20110406084101.GB13963@pengutronix.de> <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com> <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302185075.24704.143.camel@thor.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 04:04:35PM +0200, Michel Dänzer wrote:
> On Mit, 2011-04-06 at 22:43 +0200, Gabriel Paubert wrote: 
> > 
> > The probem is that, at least on one of my machines, the new driver
> > does not work: the system hangs (apparently solid, but it's before
> > networking starts up and I've not yet hooked up a serial console), 
> > after the "radeon: ib pool ready" message.
> 
> Does radeon.agpmode=-1 radeon.no_wb=1 help?
> 
> You might be able to get more information via netconsole if you prevent
> the radeon module from loading automatically (or load it with
> radeon.modeset=0 first) and then load it e.g. via ssh with modeset=1.

Loading the module with modeset=1 results in insmod blocked in
kernel state (not consuming CPU cycles either). The last kernel 
message is always the same (ib pool ready). This seems to be 
independent of agpmode and no_wb. The kernel messages when
loading the driver are:

kernel: [drm] radeon kernel modesetting enabled.
kernel: checking generic (c0000000 140000) vs hw (c0000000 10000000)
kernel: fb: conflicting fb hw usage radeondrmfb vs OFfb vga,Displa - removing generic driver
kernel: [drm] initializing kernel modesetting (RV530 0x1002:0x71C7).
kernel: radeon 0000:f1:00.0: Using 64-bit DMA iommu bypass
kernel: [drm] register mmio base: 0xE8000000
kernel: [drm] register mmio size: 65536
kernel: radeon 0000:f1:00.0: Invalid ROM contents
kernel: ATOM BIOS: X1650PRO
kernel: [drm] Generation 2 PCI interface, using max accessible memory
kernel: radeon 0000:f1:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
kernel: radeon 0000:f1:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
kernel: [drm] Driver supports precise vblank timestamp query.
kernel: irq: irq 9 on host /mpic mapped to virtual irq 24
kernel: u3msi: allocated virq 0x18 (hw 0x9) addr 0xf8004090
kernel: radeon 0000:f1:00.0: radeon: using MSI.
kernel: [drm] radeon: irq initialized.
kernel: [drm] Detected VRAM RAM=512M, BAR=256M
kernel: [drm] RAM width 128bits DDR
kernel: [TTM] Zone  kernel: Available graphics memory: 1002914 kiB.
kernel: [TTM] Initializing pool allocator.
kernel: [drm] radeon: 512M of VRAM memory ready
kernel: [drm] radeon: 512M of GTT memory ready.
kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
kernel: [drm] radeon: 1 quad pipes, 2 z pipes initialized.
kernel: [drm] PCIE GART of 512M enabled (table at 0x00040000).
kernel: radeon 0000:f1:00.0: WB enabled
kernel: [drm] Loading R500 Microcode
kernel: [drm] radeon: ring at 0x0000000020001000
kernel: [drm] ring test succeeded in 6 usecs
kernel: [drm] radeon: ib pool ready.


For now, with modeset=0, agpmode=-1 and no_wb=1, the driver
seems to work. But it sometimes took hours to fail, so some
more wait is needed.

	Regards,
	Gabriel
