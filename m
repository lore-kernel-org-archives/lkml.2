Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab1KUPsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:48:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47977 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1KUPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:48:37 -0500
Message-ID: <1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, tj@kernel.org
Date: Mon, 21 Nov 2011 16:48:30 +0100
In-Reply-To: <20111121153621.GA1678@x4.trippels.de>
References: <20111118075521.GB1615@x4.trippels.de>
	 <1321605837.30341.551.camel@debian> <20111118085436.GC1615@x4.trippels.de>
	 <20111118120201.GA1642@x4.trippels.de> <1321836285.30341.554.camel@debian>
	 <20111121080554.GB1625@x4.trippels.de>
	 <20111121082445.GD1625@x4.trippels.de>
	 <1321866988.2552.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111121131531.GA1679@x4.trippels.de>
	 <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111121153621.GA1678@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 novembre 2011 à 16:36 +0100, Markus Trippelsdorf a écrit :
> On 2011.11.21 at 15:16 +0100, Eric Dumazet wrote:
> > Le lundi 21 novembre 2011 à 14:15 +0100, Markus Trippelsdorf a écrit :
> > 
> > > I've enabled CONFIG_SLUB_DEBUG_ON and this is what happend:
> > > 
> > 
> > Thanks
> > 
> > Please continue to provide more samples.
> > 
> > There is something wrong somewhere, but where exactly, its hard to say.
> 
> New sample. This one points to lib/idr.c:
> 
> [drm] Initialized drm 1.1.0 20060810
> [drm] radeon defaulting to kernel modesetting.
> [drm] radeon kernel modesetting enabled.
> radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> radeon 0000:01:05.0: setting latency timer to 64
> [drm] initializing kernel modesetting (RS780 0x1002:0x9614 0x1043:0x834D).
> [drm] register mmio base: 0xFBEE0000
> [drm] register mmio size: 65536
> ATOM BIOS: 113
> radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
> radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
> [drm] Detected VRAM RAM=128M, BAR=128M
> [drm] RAM width 32bits DDR
> [TTM] Zone  kernel: Available graphics memory: 4083428 kiB.
> [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
> [TTM] Initializing pool allocator.
> [drm] radeon: 128M of VRAM memory ready
> [drm] radeon: 512M of GTT memory ready.
> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [drm] Driver supports precise vblank timestamp query.
> [drm] radeon: irq initialized.
> [drm] GART: num cpu pages 131072, num gpu pages 131072
> [drm] Loading RS780 Microcode
> [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
> radeon 0000:01:05.0: WB enabled
> [drm] ring test succeeded in 1 usecs
> [drm] radeon: ib pool ready.
> [drm] ib test succeeded in 0 usecs
> =============================================================================
> BUG idr_layer_cache: Poison overwritten
> -----------------------------------------------------------------------------

Thanks, could you now add "CONFIG_DEBUG_PAGEALLOC=y" in your config as
well ?



