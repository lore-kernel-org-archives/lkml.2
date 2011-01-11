Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1AKXU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:20:57 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:46800 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1AKXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:20:53 -0500
Message-ID: <4D2CE5C8.60601@de.ibm.com>
Date: Wed, 12 Jan 2011 00:20:40 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100918 Lightning/1.0b2 Icedove/3.1.4
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm for rc1
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.01.2011 23:59, schrieb Dave Airlie:
> 
> Hi Linus,
> 
> non-drm changes:
> one kref change we needed that went on list with no comments
> 
> New hardware:
> radeon: add support for Fusion APUs and Radeon HD6xxx chipsets
> nouveau: Fermi acceleration support (requires external fw for now)
> 
> Highlights:
> core/drivers: add support for high precision vblank timestamps
> radeon: pageflipping support, Gen2 PCIE support
> nouveau: reworked VRAM and VM support
> intel: better ILK/SNB powersaving support, Full GTT support
> 
> There are also some switcheroo patches to further improve it, though I 
> have a later patch blocking on an x86 platform driver for the nvidia/intel 
> switcher.
> 
> Dave.

Now nouveau framebuffer is completely broken on my T61p (01:00.0 VGA compatible controller: nVidia Corporation G84M [Quadro FX 570M] (rev a1))
During startup the framebuffer shows only stripes and a blank
screen after suspend/resume.
I also see lots of TRAP messages. (see below).
X11 seems to work fine though...

$ dmesg | grep drm
[    0.520906] [drm] Initialized drm 1.1.0 20060810
[    0.521200] [drm] radeon defaulting to kernel modesetting.
[    0.521416] [drm] radeon kernel modesetting enabled.
[    0.522179] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    0.536664] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x084c00a2)
[    0.556998] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    0.641884] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    0.642058] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    0.642227] [drm] nouveau 0000:01:00.0: Bios version 60.84.51.00
[    0.642400] [drm] nouveau 0000:01:00.0: TMDS table version 2.0                                                                                                           
[    0.642567] [drm] nouveau 0000:01:00.0: BIT table 'd' not found                                                                                                          
[    0.642736] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0                                                                                    
[    0.642969] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000323 00010034                                                                                               
[    0.643141] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02811300 00000028                                                                                               
[    0.643315] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02822312 00010030                                                                                               
[    0.643490] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 0000000e 00000000                                                                                               
[    0.643662] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2                                                                                            
[    0.643836] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[    0.644089] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[    0.644317] [drm] nouveau 0000:01:00.0:   2: 0x00001231: type 0x31 idx 2 tag 0x07
[    0.644543] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xDEBB
[    0.688140] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE208
[    0.724028] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEC55
[    0.724264] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xED47
[    0.732117] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEF7A
[    0.732345] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEFDF
[    0.756029] [drm] nouveau 0000:01:00.0: 0xEFDF: Condition still not met after 20ms, skipping following opcodes
[    0.775483] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[    0.775663] [drm] nouveau 0000:01:00.0: 0: memory 100MHz core 169MHz shader 338MHz voltage 1150mV fanspeed 100%
[    0.775900] [drm] nouveau 0000:01:00.0: 1: memory 301MHz core 275MHz shader 550MHz voltage 1150mV fanspeed 100%
[    0.776165] [drm] nouveau 0000:01:00.0: 2: memory 702MHz core 475MHz shader 950MHz voltage 1200mV fanspeed 100%
[    0.776419] [drm] nouveau 0000:01:00.0: c: memory 302MHz core 275MHz shader 550MHz voltage 1150mV
[    0.777232] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[    0.817893] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    0.889393] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.889565] [drm] No driver support for vblank timestamp query.
[    0.904293] [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
[    1.071762] [drm] nouveau 0000:01:00.0: allocated 1920x1200 fb: 0x60000000, bo ffff88013af63400
[    1.071842] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[    1.071866] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP1: Unhandled ustatus 0x00000001
[    1.071871] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[    1.071881] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x060c data 0x000004b0
[    1.086542] drm: registered panic notifier
[    1.086564] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   32.672642] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672651] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP1: Unhandled ustatus 0x00000001
[   32.672653] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672656] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672670] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672672] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672675] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x0000c676
[   32.672688] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672691] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672693] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672706] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672709] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672711] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672724] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672727] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672729] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0814 data 0x00000000
[   32.672742] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672745] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672747] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x6cc61800
[   32.672760] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672763] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672765] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672777] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672780] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672782] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672795] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672798] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672800] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672813] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672816] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672818] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672831] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672834] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672836] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672849] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672852] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672854] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672867] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672870] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672872] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x18cc0030
[   32.672885] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672888] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672890] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672903] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672905] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672907] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672920] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672923] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672925] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672938] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672941] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672943] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x7c306000
[   32.672956] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672959] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672961] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672974] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672977] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672979] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[   32.672992] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[   32.672994] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[   32.672996] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  292.805813] [drm] nouveau 0000:01:00.0: Disabling fbcon acceleration...
[  292.805815] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[  292.805868] [drm] nouveau 0000:01:00.0: Evicting buffers...
[  292.894426] [drm] nouveau 0000:01:00.0: Idling channels...
[  292.894642] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
[  294.215429] [drm] nouveau 0000:01:00.0: And we're gone!
[  295.977202] [drm] nouveau 0000:01:00.0: We're back, enabling device...
[  295.977249] [drm] nouveau 0000:01:00.0: POSTing device...
[  295.977251] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xDEBB
[  296.020249] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE208
[  296.056123] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEC55
[  296.056182] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xED47
[  296.064227] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEF7A
[  296.064231] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEFDF
[  296.088139] [drm] nouveau 0000:01:00.0: Restoring GPU objects...
[  296.200888] [drm] nouveau 0000:01:00.0: Reinitialising engines...
[  296.200957] [drm] nouveau 0000:01:00.0: Restoring mode...
[  296.400184] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  296.400189] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  296.400196] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  296.518972] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  296.518977] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  296.518981] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572687] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572690] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572694] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572717] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572719] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572722] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x66c66c00
[  750.572744] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572747] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572749] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572771] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572774] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572776] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572798] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572801] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572803] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572821] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572824] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572826] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572848] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572850] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572852] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572875] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572877] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572879] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572901] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572904] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572906] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572924] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572927] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572929] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572951] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572954] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572956] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.572978] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.572981] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.572983] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.573005] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.573008] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.573010] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.573032] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.573035] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.573037] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.573056] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.573058] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.573061] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.573083] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.573085] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.573087] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.573109] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.573112] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.573114] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.573136] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.573138] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.573141] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x36cc00d6
[  750.573163] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.573165] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.573167] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[  750.573186] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[  750.573188] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[  750.573191] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 4433.086943] [drm] nouveau 0000:01:00.0: Disabling fbcon acceleration...
[ 4433.086946] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[ 4433.087018] [drm] nouveau 0000:01:00.0: Evicting buffers...
[ 4433.136993] [drm] nouveau 0000:01:00.0: Idling channels...
[ 4433.137214] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
[ 4434.544626] [drm] nouveau 0000:01:00.0: And we're gone!
[ 4436.393123] [drm] nouveau 0000:01:00.0: We're back, enabling device...
[ 4436.393171] [drm] nouveau 0000:01:00.0: POSTing device...
[ 4436.393173] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xDEBB
[ 4436.436181] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE208
[ 4436.472068] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEC55
[ 4436.472129] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xED47
[ 4436.480155] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEF7A
[ 4436.480157] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEFDF
[ 4436.504063] [drm] nouveau 0000:01:00.0: Restoring GPU objects...
[ 4436.618075] [drm] nouveau 0000:01:00.0: Reinitialising engines...
[ 4436.618162] [drm] nouveau 0000:01:00.0: Restoring mode...
[ 4436.816114] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 4436.816117] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 4436.816120] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 4436.939497] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 4436.939501] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 4436.939505] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 4659.547242] [drm] nouveau 0000:01:00.0: Disabling fbcon acceleration...
[ 4659.547245] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[ 4659.547291] [drm] nouveau 0000:01:00.0: Evicting buffers...
[ 4659.574552] [drm] nouveau 0000:01:00.0: Idling channels...
[ 4659.574772] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
[ 4660.983319] [drm] nouveau 0000:01:00.0: And we're gone!
[ 4662.857200] [drm] nouveau 0000:01:00.0: We're back, enabling device...
[ 4662.857247] [drm] nouveau 0000:01:00.0: POSTing device...
[ 4662.857250] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xDEBB
[ 4662.900194] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE208
[ 4662.936079] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEC55
[ 4662.936127] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xED47
[ 4662.944177] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEF7A
[ 4662.944179] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEFDF
[ 4662.968079] [drm] nouveau 0000:01:00.0: Restoring GPU objects...
[ 4663.081161] [drm] nouveau 0000:01:00.0: Reinitialising engines...
[ 4663.081233] [drm] nouveau 0000:01:00.0: Restoring mode...
[ 4663.280132] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 4663.280135] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 4663.280139] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 4663.404469] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 4663.404473] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 4663.404477] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 5972.191217] [drm] nouveau 0000:01:00.0: Disabling fbcon acceleration...
[ 5972.191219] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[ 5972.191276] [drm] nouveau 0000:01:00.0: Evicting buffers...
[ 5972.237659] [drm] nouveau 0000:01:00.0: Idling channels...
[ 5972.237877] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
[ 5973.560045] [drm] nouveau 0000:01:00.0: And we're gone!
[ 5975.517189] [drm] nouveau 0000:01:00.0: We're back, enabling device...
[ 5975.517237] [drm] nouveau 0000:01:00.0: POSTing device...
[ 5975.517240] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xDEBB
[ 5975.560229] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE208
[ 5975.596110] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEC55
[ 5975.596173] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xED47
[ 5975.604211] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEF7A
[ 5975.604214] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEFDF
[ 5975.628116] [drm] nouveau 0000:01:00.0: Restoring GPU objects...
[ 5975.741878] [drm] nouveau 0000:01:00.0: Reinitialising engines...
[ 5975.741948] [drm] nouveau 0000:01:00.0: Restoring mode...
[ 5975.940156] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 5975.940161] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 5975.940168] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 5976.122264] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 5976.122269] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 5976.122273] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061038] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061046] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061056] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061075] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061082] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061089] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x66c66c00
[ 7620.061109] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061115] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061122] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061141] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061147] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061154] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061173] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061179] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061186] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061205] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061211] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061218] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061237] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061243] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061250] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061269] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061275] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061282] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061301] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061307] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061314] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061333] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061339] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061345] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061365] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061371] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061377] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061396] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061402] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061409] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061429] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061434] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061441] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061460] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061466] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061473] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061492] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061498] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061505] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061524] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061530] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061537] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061556] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061562] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061568] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061587] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061593] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061600] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x36cc00d6
[ 7620.061619] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061625] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061632] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[ 7620.061651] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - TP0: Unhandled ustatus 0x00000001
[ 7620.061657] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[ 7620.061664] [drm] nouveau 0000:01:00.0: PGRAPH - ch 1 (0x0000388000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
