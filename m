Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2AJKgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:36:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49347 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab2AJKgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:36:48 -0500
Date: Tue, 10 Jan 2012 10:36:45 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm merge for 3.3-rc1.
Message-ID: <alpine.DEB.2.00.1201101022540.25051@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-431945765-1326191805=:25051"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-431945765-1326191805=:25051
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is the main pull request for the drm for this merge window. It has 
two conflicts with your tree, I've fixed them up in a separate 
drm-linus-merged branch if you don't want to exercise your merging 
fingers.

Highlights:
drm core: add plane support and userspace interface to expose overlays for 
intel and soc hardwre. Lots of code removal through restructing by Daniel 
Vetter. EDID support for CEA modes.
ttm: DMA aware page pool added, allows for use under Xen, and makes 
support for radeon VM easier.
radeon: multi-ring support, semaphore support, better IB pool support, add 
VM support for Cayman and upcoming GPUs, evergreen HDMI audio  support
gma500: Initial GMA500 KMS driver moved from staging into drm proper.
nouveau: HDMI audio support, lots of power management fixes, overscan 
connector property, initial nvd9 support, 
exynos: hdmi support, pm support, plane support.
intel: better HDMI ELD support, plane support, GEN 7 streamout support.

The Intel guys are also having process issues again, and then Intel pull 
request was very late and it looked like nobody was pulling stuff into a 
-next tree at all regularly. I'm sort of tempted to just drop anything 
more from them for this cycle, to give them time to sort themselves out 
for the next one. I think there is one missed IRQ fix from them I'd like 
to see, the rest I'm thinking can wait.

Dave.


The following changes since commit 6abff3c78051e40130a1c653f874fb12b9d40254:

  vmwgfx: Clip cliprects against screen boundaries in present and dirty (2011-12-19 14:06:05 +0000)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-core-next

Akshay Joshi (1):
      gma500: Convert spaces to tabs in accel_2d.c.

Alan Cox (31):
      gma500: Move the basic driver out of staging
      gma500: GEM and GEM glue
      gma500: introduce the GTT and MMU handling logic
      gma500: introduce the framebuffer support code
      gma500: Add device framework
      gma500: Add the glue to the various BIOS and firmware interfaces
      gma500: Add the i2c bus support
      gma500: Add the core DRM files and headers
      gma500: Add Poulsbo support
      gma500: Add Oaktrail support
      gma500: Add support for Cedarview
      gma500: Now connect up to the DRM build to finish the job
      drm/gma500: begin pruning dead bits of API
      gma500: Rename the ioctls to avoid clashing with the legacy drivers
      gma500: kill off NUM_PIPE define
      gma500: Move the API
      gma500: kill virtual mapping support
      gma500: do a pass over the FIXME tags
      gma500: kill bogus code
      gma500: Fix backlight crash
      gma500: frame buffer locking
      gma500: gtt based hardware scrolling console
      gma500: Be smarter about layout
      gma500: Fix oaktrail probing part 1
      gma500: Oaktrail BIOS handling
      gma500: Final enables for Oaktrail
      gma500: Oaktrail fixes
      gma500/oaktrail: panel display quality fix
      gma500: Add the E6xx PCI identifier we are missing
      gma500: Fix Cedarview support (Correct version)
      gma500: remove no_fb bits

Alex Deucher (9):
      drm/radeon/kms: add support for multiple fence queues v2
      drm/radeon/kms: add some new ring params to better handle other ring types
      drm/radeon/kms: add cayman specific fence_ring_emit
      drm/radeon/kms: add support for per-ring fence interrupts
      drm/radeon/kms: add missing ring ready check in sync tests
      drm/radeon/kms: disable writeback on pre-R300 asics
      drm/radeon/kms: sync across multiple rings when doing bo moves v3
      drm/radeon/kms: check if vm is supported in VA ioctl
      drm/radeon/kms: remove pointless CS flags priority struct

Arjan van de Ven (1):
      drm: Make the per-driver file_operations struct const

Ben Skeggs (88):
      drm/nv40/pm: parse fan pwm divisor from vbios tables
      drm/nv40/pm: implement first type of pwm fanspeed funcs
      drm/nv41/pm: implement a second type of fanspeed pwm
      drm/nouveau/pm: hook up fanspeed get/set if they're present
      drm/nouveau/vdec: implement stub modules for the known engines
      drm/nv50/pm: add support for pwm fan control
      drm/nv50/pm: mostly nailed down fan pwm frequency selection
      drm/nouveau/gpio: remove invert flag, use state[] everywhere
      drm/nouveau/pm: introduce generic handler for on-chip fan controller
      drm/nv50/pm: convert to new fanspeed pwm controller hooks
      drm/nv40/pm: convert to new pwm hooks, also fixing pwm type detection
      drm/nouveau/pm: remove defunct fanspeed_set/get from pm table
      drm/nv50/pm: s/unk05/vdec/
      drm/nouveau/hdmi: build ELD from EDID, notify audio driver of its presence
      drm/nouveau/hdmi: add hdmi register accessors to handle hdmi block move
      drm/nouveau/hdmi: enable sending of avi/audio infoframes
      drm/nv50/crtc: disable flip overlay around scaling mode changes
      drm/nouveau: move master modesetting init to nouveau_display
      drm/nouveau: add overscan compensation connector properties
      drm/nv50/disp: move sync routine to where it can be used by other modules
      drm/nv50/disp: synchronise display right after init
      drm/nv50/disp: completely reset disp if master evo channel active at init
      drm/nv50/disp: disconnect encoders before reprogramming them
      drm/nv50/disp: wait for encoder disconnect to complete before link training
      drm/nouveau: determine a value for display_info.bpc if edid doesn't
      drm/nouveau: no need to pass parameters into set_scale/dither
      drm/nouveau: improve dithering properties, and implement proper auto mode
      drm/nouveau: don't pretend to support the DVI-I 'select subconnector' prop
      drm/nv50/disp: allow interlaced and doublescan modes on digital outputs
      drm/nouveau/disp: kill off nouveau_crtc.mode
      drm/nv50/disp: rewrite crtc timing calculation, with proper names and fixes
      drm/nv50/disp: fix scaling of doublescan modes
      drm/nv50/pm: rewrite clock management, and switch to the new pm hooks
      drm/nv04-nv30/pm: port to newer interfaces
      drm/nouveau/pm: remove the older interfaces completely
      drm/nouveau/pm: change volt/fan before upclock, but after downclock
      drm/nv50/pm: free state struct after setting clocks
      drm/nv50/disp: stricter check for evo being active on init
      drm/nvc0/gr: update fuc source to assemble with latest envyas
      drm/nvc0/gr: add initial support for nvd9, not quite there yet..
      drm/nv50/pm: 0x84/0x86 can't use "1" for nvclk src, need 0x50 method
      drm/nv50/pm: fix thinko which lead to clocks being slightly off sometimes
      drm/nv50/pm: avoid touching dom6/vdec clocks if perflvl doesn't define it
      drm/nv50/pm: stabilise transition to 100MHz mclk a bit
      drm/nv50/pm: only touch 0x611200 on nv92-
      drm/nva3/copy: update fuc source for latest envytools
      drm/nva3/copy: fix typo in fuc which caused host to not recieve exceptions
      drm/nouveau/hdmi: enable audio for nva3:nvd0 chipsets
      drm/nvd0/disp: send eld to the audio codec
      drm/nvd0/disp: enable hdmi on sor if hdmi monitor present
      drm/nvd0/disp: hook evo up to debugging
      drm/nvd0/disp: enable hdmi audio
      drm/nouveau/pm: fix missing volt changes when boot voltage is undefined
      drm/nouveau/disp: introduce proper init/fini, separate from create/destroy
      drm/nouveau: re-jig fbcon suspend/resume process a little
      drm/nv50/disp: fix evo for create/init + destroy/fini split
      drm/nouveau: shutdown display on suspend/hibernate
      drm/nvd0/disp: update crtc timing calculations for interlace/doublescan
      drm/nvd0/disp: scaler updates, overscan compensation etc
      drm/nvd0/disp: init display sync channels
      drm/nvd0/disp: have evo names now, use them
      drm/nvd0/disp: make it clearer that the cursor regs are pio evo channels
      drm/nvd0/disp: add support for page flipping
      drm/nvd0/disp: initialise overlay channels
      drm/nvd0/disp: handle yet another interrupt
      drm/nvd0/disp: rename sync channel to flip channel
      drm/nvd0/disp: use single, shared, sync bo for all evo channels
      drm/nouveau/bios: pass drm_device to ROMPTR, rather than nvbios
      drm/nouveau/bios: fold fixup_legacy_i2c
      drm/nouveau/bios: start refactoring dcb routines
      drm/nouveau/i2c: do parsing of i2c-related vbios info in nouveau_i2c.c
      drm/nouveau/i2c: tidy up bit-bang helpers, also fixing nv50 setsda bug
      drm/nouveau/i2c: fix debug message
      drm/nouveau/i2c: handle bit-banging ourselves
      drm/nouveau/disp: parse connector info directly in nouveau_connector.c
      drm/nouveau/mxm: initial implementation of dcb sanitisation
      drm/nouveau/mxm: implement wmi shadow method
      drm/nouveau/mxm: implement _DSM shadow method
      drm/nouveau/mxm: implement ROM shadow method
      drm/nouveau/dp: remove broken display depth function, use the improved one
      drm/nv04/disp: handle dual-link spwg panels without needing quirks
      drm/nouveau/hwsq: remove some magic, give proper opcode names
      drm/nouveau: just pass gpio line to pwm_*, not entire gpio struct
      drm/nouveau/gpio: reimplement as nouveau_gpio.c, fixing a number of issues
      drm/nv40/disp: implement support for hotplug irq
      drm/nouveau: move hpd enable/disable to common code
      drm/nvc0/pm: initial engine reclocking
      drm/nouveau/ttm: fix crash as a result of a recent ttm change

Ben Widawsky (4):
      drm/i915: relative_constants_mode race fix
      drm/i915: Force sync command ordering (Gen6+)
      drm/i915: Update GEN6_RP_CONTROL definitions
      drm/i915: drpc debugfs update for gen6

Chen Jie (1):
      drm/radeon/benchmark: common modes sweep ignores 640x480@32

Christian König (15):
      drm/radeon: fix debugfs handling v3
      drm/radeon: no need to check all relocs for duplicates
      drm/radeon: fix a spelling mistake
      drm/radeon/kms: add support for semaphores v3
      drm/radeon: make all functions work with multiple rings.
      drm/radeon: make ring rptr and wptr register offsets variable
      drm/radeon: make cp variable an array
      drm/radeon: Add radeon_test_syncing function v2
      drm/radeon: make some asic pointers per ring
      drm/radeon: add radeon_fence_count_emited function
      drm/radeon: disable compute rings on cayman for now
      drm/radeon: rename struct radeon_cp to radeon_ring
      drm/radeon: move ring debugfs into radeon_ring.c
      drm/radeon: improve radeon_test_syncing function
      drm/radeon/kms: Add support for multi-ring sync in CS ioctl (v2)

Christian Schmidt (4):
      drm/edid: support CEA video modes.
      drm_edid_to_eld: check for CEA data blocks only from structure revision 3 on
      Fix wrong assumptions in cea_for_each_detailed_block v2
      drm/intel: Fix initialization if startup happens in interlaced mode [v2]

Dan Carpenter (4):
      drm/radeon: use after free in radeon_vm_bo_add()
      drm/radeon: double lock typo in radeon_vm_bo_rmv()
      drm/ttm: fix condition (and vs or)
      gma500: silence gcc warnings in mid_get_vbt_data()

Daniel Vetter (16):
      drm/i915: check ACTHD of all rings
      drm/sis: track obj->drm_fd relations in the driver
      drm/via: track obj->drm_fd relations in the driver
      drm/sman: kill owner tracking interface functions
      drm/sman: rip out owner tracking
      drm/via: track user->memblock mapping with idr
      drm/sis: track user->memblock mapping with idr
      drm/sman: kill user_hash_tab
      drm/via: use drm_mm instead of drm_sman
      drm/sis: use drm_mm instead of drm_sman
      drm: kill drm_sman
      drm/i810: cleanup reclaim_buffers
      drm/i810: don't acces hw regs in lastclose
      drm/i915: kicking rings stuck on semaphores considered harmful
      drm/i915: don't bail out of intel_wait_ring_buffer too early
      drm/sis|via: don't return stack garbage from free_mem ioctl

Dave Airlie (23):
      Merge branch 'drm-plane-jbarnes' into drm-core-next
      gma500: fixup build versus latest header changes.
      Merge branch 'drm-gma500-alanc' into drm-core-next
      drm/gma500: port framebuffer to new plane interface.
      drm/radeon/kms: fix up for BIG ENDIAN breakage
      drm: move the fb bpp/depth helper into the core.
      drm: Merge branch 'drm-gma500-alancox' into drm-core-next
      drm: Merge branch 'drm-cleanups-jbarnes' into drm-core-next
      drm/Merge branch 'drm-ttm-glisse' of ../drm-radeon-next into drm-core-next
      staging/gma500: fixup staging code to build following core changes.
      Merge tag 'v3.2-rc6' of /home/airlied/devel/kernel/linux-2.6 into drm-core-next
      Merge branch 'drm-radeon-next' of ../drm-radeon-next into drm-core-next
      drm/radeon/kms: don't use 0 bpc for adjusting hdmi clock
      Merge branch 'exynos-drm-next' of git://git.infradead.org/users/kmpark/linux-samsung into drm-core-next
      Merge remote-tracking branch 'pfdo/drm-fixes' into drm-core-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next
      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm into drm-core-next
      drm: add missing exports for i810 driver.
      Merge branch 'exynos-drm-next' of git://git.infradead.org/users/kmpark/linux-samsung into drm-core-next
      Merge branch 'drm-intel-next' of git://people.freedesktop.org/~keithp/linux into drm-core-next
      Merge branch 'drm-radeon-testing' of ../drm-radeon-next into drm-core-next
      drm: introduce drm_can_sleep and use in intel/radeon drivers. (v2)
      drm/nouveau/pm: fix build with HWMON off

Eric Anholt (5):
      drm/i915: Set two chicken bits implicated in missed IRQs on Ivybridge.
      drm/i915: Do the fallback non-IRQ wait in ring throttle, too.
      drm/i915: Work around gen7 BLT ring synchronization issues.
      drm/i915: Make the fallback IRQ wait not sleep.
      drm/i915: Add support for resetting the SO write pointers on gen7.

Francisco Jerez (2):
      drm/nouveau: Fix pushbufs over the 4GB mark.
      drm/nouveau: Fix notifier blocks over the 4GB mark.

Hugh Dickins (1):
      drm: avoid switching to text console if there is no panic timeout

Ilija Hadzic (4):
      drm/gma500: remove genrated file
      drm/gma500: fix compile error
      drm: no need to hold global mutex for static data
      drm: make DRM_UNLOCKED ioctls with their own mutex

Inki Dae (5):
      drm/exynos: updated crtc and encoder dpms framework.
      drm/exynos: added pm support.
      drm/exynos: change driver name.
      drm/exynos: extend vblank off delay time.
      drm/exynos: added mutex lock and code clean.

Jerome Glisse (17):
      drm/ttm: remove userspace backed ttm object support
      drm/ttm: remove split btw highmen and lowmem page
      drm/ttm: remove unused backend flags field
      drm/ttm: use ttm put pages function to properly restore cache attribute
      drm/ttm: test for dma_address array allocation failure
      drm/ttm: page allocation use page array instead of list
      drm/ttm: merge ttm_backend and ttm_tt V5
      drm/ttm: introduce callback for ttm_tt populate & unpopulate V4
      drm/ttm: isolate dma data from ttm_tt V4
      drm/ttm: simplify memory accounting for ttm user v2
      drm/ttm: callback move_notify any time bo placement change v4
      drm/radeon: precompute fence cpu/gpu addr once v3
      drm/radeon: introduce a sub allocator and convert ib pool to it v4
      drm/radeon: make ib size variable
      drm/radeon: allocate semaphore from the ib pool
      drm/radeon: GPU virtual memory support v22
      ttm: fix agp since ttm tt rework

Jesse Barnes (18):
      drm: add plane support v3
      drm: add an fb creation ioctl that takes a pixel format v5
      drm/staging/gma500: fix linux-next build
      drm: remove unused connector_count field from drm_display_mode
      drm: fix comments for drm_crtc struct
      drm: add comments for drm_encoder_funcs
      drm: add drm_encoder comments
      drm: remove unused fields in drm_connector and document the rest
      drm: document drm_mode_set structure
      drm: document and cleanup drm_mode_config_funcs
      drm: document the drm_mode_group structure
      drm: document the drm_mode_config structure
      drm: remove some potentially dangerous DRM_ERRORs
      drm/i915: add SNB and IVB video sprite support v6
      drm/i915: track sprite coverage and disable primary plane if possible
      drm/i915: add color key support v4
      drm/i915: don't disable a PCH DPLL that's in use
      drm/i915: only set the intel_crtc DPMS mode to on if the mode set succeeded

Joonyoung Shim (8):
      drm/exynos: Fix compile errors
      drm/exynos: Use struct drm_mode_fb_cmd2
      drm/exynos: add runtime pm feature for fimd
      drm/exynos: Add plane support with fimd
      drm/exynos: gem code cleanup
      drm/exynos: Fix a fake mmap offset creation
      drm/exynos: Split creation of gem object and gem handle
      drm/exynos: remove buffer creation of fbdev from drm framebuffer creation

Keith Packard (1):
      drm/i915: Clean up multi-threaded forcewake patch

Konrad Rzeszutek Wilk (6):
      swiotlb: Expose swiotlb_nr_tlb function to modules
      drm/ttm: provide dma aware ttm page pool code V9
      drm/radeon/kms: enable the ttm dma pool if swiotlb is on V4
      drm/nouveau: enable the ttm dma pool when swiotlb is active V3
      drm/ttm/dma: Only call set_pages_array_wb when the page is not in WB pool.
      drm/ttm/dma: Fix accounting error when calling ttm_mem_global_free_page and don't try to free freed pages.

Marcin Slusarz (2):
      drm/nouveau: print correct engine number which failed to unload/idle
      drm/nv50: fix page faulting for 128MB page table sizes

Martin Peres (6):
      drm/nouveau/pm: manual pwm fanspeed management for nv40+ boards
      drm/nvd0: read temperature as we did on nv84+ boards
      drm/nouveau/pm: make clocks_set return an error code clocks_set can fail.
      drm/nv50/pm: s/PLL_UNK05/PLL_VDEC/
      drm/nv50/pm: fix a typo in clock calculation
      drm/nv50/pm: introduce hwsq-based memory reclocking

Maxim Levitsky (4):
      drm/nv50: also report errors in MP1/MP2 when they happen.
      drm/nouveau: disable output polling through suspend.
      drm/nouveau: restore performance mode a bit later.
      drm/nouveau: restore cursors after restoring mode

Michel Dänzer (1):
      radeon: Fix disabling PCI bus mastering on big endian hosts.

Patrik Jakobsson (12):
      gma500: Only register interrupt handler for poulsbo hardware
      gma500: Don't enable MSI on Poulsbo
      gma500: Add VBLANK support for Poulsbo hardware
      gma500: Initial support for our encoder and connector structs
      gma500: Remove psb_intel_output from ddc_probe and ddc_get_modes
      gma500: Fix encoder type checking for connectors
      gma500: Convert PSB LVDS to new output handling
      gma500: Add support for Intel GMBUS
      gma500: Replace SDVO code with slightly modified version from i915
      gma500: Convert Cedarview to work with new output handling
      gma500: Convert Oaktrail to work with new output handling
      gma500: SDVO DDC bus guessing isn't working so hardcode it instead

Rafa³ Mi³ecki (6):
      drm/radeon/kms: do not force DVI mode on DCE4 if audio is on
      drm/radeon/kms: minor HDMI audio cleanups
      drm/radeon/kms: support for audio on Evergreen
      drm/radeon/kms: setup HDMI mode on Evergreen encoders
      drm/radeon/kms: workaround invalid AVI infoframe checksum issue
      drm/radeon/kms: define TMDS/LVTM HDMI enabling bits

Rob Clark (3):
      drm: call connector dpms fxn, when setting config
      drm: disconnect plane from fb/crtc when disabled
      drm: add support for private planes

Seung-Woo Kim (3):
      drm: Add multi buffer plane pixel formats
      drm/exynos: Support multi buffers
      drm/exynos: added hdmi display support

Tormod Volden (1):
      agp: Fix multi-line warning message whitespace

Ville Syrjälä (14):
      drm: Redefine pixel formats
      drm: Add a missing ')'
      drm: Install drm_fourcc.h
      drm: fourcc: Use __u32 instead of u32
      drm: plane: mutex_unlock() was missing
      drm: Fix __user sparse warnings
      drm: plane: Clear plane.crtc and plane.fb after disable_plane()
      drm: plane: Check source coordinates
      drm: plane: Check crtc coordinates against integer overflows in setplane ioctl
      drm: plane: Make 'formats' parameter to drm_plane_init() const
      drm: plane: Check that the fb pixel format is supported by the plane
      drm: Check that the requested pixel format is valid
      drm: Replace pitch with pitches[] in drm_framebuffer
      drm: Add drm_format_num_planes() utility function

Wu Fengguang (5):
      drm/i915: fix ELD writing for SandyBridge
      drm/i915: rename audio ELD registers
      drm/i915: dont trigger hotplug events on unchanged ELD
      drm/i915: HDMI hot remove notification to audio driver
      drm/i915: DisplayPort hot remove notification to audio driver

 drivers/char/agp/generic.c                   |    8 +-
 drivers/gpu/drm/Kconfig                      |    3 +
 drivers/gpu/drm/Makefile                     |    3 +-
 drivers/gpu/drm/drm_context.c                |    5 +-
 drivers/gpu/drm/drm_crtc.c                   |  608 ++++++-
 drivers/gpu/drm/drm_crtc_helper.c            |   50 +-
 drivers/gpu/drm/drm_drv.c                    |   14 +-
 drivers/gpu/drm/drm_edid.c                   |  103 +-
 drivers/gpu/drm/drm_edid_modes.h             |  284 +++
 drivers/gpu/drm/drm_fb_helper.c              |    7 +
 drivers/gpu/drm/drm_fops.c                   |    2 +-
 drivers/gpu/drm/drm_ioctl.c                  |   15 +-
 drivers/gpu/drm/drm_lock.c                   |    3 +
 drivers/gpu/drm/drm_sman.c                   |  351 ----
 drivers/gpu/drm/exynos/Kconfig               |    7 +
 drivers/gpu/drm/exynos/Makefile              |    5 +-
 drivers/gpu/drm/exynos/exynos_ddc.c          |   58 +
 drivers/gpu/drm/exynos/exynos_drm_buf.c      |    5 +-
 drivers/gpu/drm/exynos/exynos_drm_buf.h      |    3 -
 drivers/gpu/drm/exynos/exynos_drm_crtc.c     |   89 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c      |   35 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h      |   29 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.c  |  135 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.h  |    5 +
 drivers/gpu/drm/exynos/exynos_drm_fb.c       |  166 +--
 drivers/gpu/drm/exynos/exynos_drm_fb.h       |   24 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c    |   84 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c     |  292 +++-
 drivers/gpu/drm/exynos/exynos_drm_gem.c      |  227 ++--
 drivers/gpu/drm/exynos/exynos_drm_gem.h      |   53 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c     |  439 +++++
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h     |   73 +
 drivers/gpu/drm/exynos/exynos_drm_plane.c    |  163 ++
 drivers/gpu/drm/exynos/exynos_drm_plane.h    |   14 +
 drivers/gpu/drm/exynos/exynos_hdmi.c         | 1176 ++++++++++++
 drivers/gpu/drm/exynos/exynos_hdmi.h         |   87 +
 drivers/gpu/drm/exynos/exynos_hdmiphy.c      |   58 +
 drivers/gpu/drm/exynos/exynos_mixer.c        | 1070 +++++++++++
 drivers/gpu/drm/exynos/exynos_mixer.h        |   92 +
 drivers/gpu/drm/exynos/regs-hdmi.h           |  147 ++
 drivers/gpu/drm/exynos/regs-mixer.h          |  141 ++
 drivers/gpu/drm/exynos/regs-vp.h             |   91 +
 drivers/gpu/drm/gma500/Kconfig               |   27 +
 drivers/gpu/drm/gma500/Makefile              |   40 +
 drivers/gpu/drm/gma500/accel_2d.c            |  364 ++++
 drivers/gpu/drm/gma500/backlight.c           |   49 +
 drivers/gpu/drm/gma500/cdv_device.c          |  351 ++++
 drivers/gpu/drm/gma500/cdv_device.h          |   36 +
 drivers/gpu/drm/gma500/cdv_intel_crt.c       |  333 ++++
 drivers/gpu/drm/gma500/cdv_intel_display.c   | 1508 +++++++++++++++
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c      |  394 ++++
 drivers/gpu/drm/gma500/cdv_intel_lvds.c      |  732 +++++++
 drivers/gpu/drm/gma500/framebuffer.c         |  831 ++++++++
 drivers/gpu/drm/gma500/framebuffer.h         |   47 +
 drivers/gpu/drm/gma500/gem.c                 |  292 +++
 drivers/gpu/drm/gma500/gem_glue.c            |   89 +
 drivers/gpu/drm/gma500/gem_glue.h            |    2 +
 drivers/gpu/drm/gma500/gtt.c                 |  553 ++++++
 drivers/gpu/drm/gma500/gtt.h                 |   64 +
 drivers/gpu/drm/gma500/intel_bios.c          |  303 +++
 drivers/gpu/drm/gma500/intel_bios.h          |  430 +++++
 drivers/gpu/drm/gma500/intel_gmbus.c         |  493 +++++
 drivers/gpu/drm/gma500/intel_i2c.c           |  169 ++
 drivers/gpu/drm/gma500/intel_opregion.c      |   81 +
 drivers/gpu/drm/gma500/mid_bios.c            |  263 +++
 drivers/gpu/drm/gma500/mid_bios.h            |   21 +
 drivers/gpu/drm/gma500/mmu.c                 |  858 +++++++++
 drivers/gpu/drm/gma500/oaktrail.h            |  252 +++
 drivers/gpu/drm/gma500/oaktrail_crtc.c       |  604 ++++++
 drivers/gpu/drm/gma500/oaktrail_device.c     |  512 +++++
 drivers/gpu/drm/gma500/oaktrail_hdmi.c       |  859 +++++++++
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c   |  328 ++++
 drivers/gpu/drm/gma500/oaktrail_lvds.c       |  449 +++++
 drivers/gpu/drm/gma500/power.c               |  316 ++++
 drivers/gpu/drm/gma500/power.h               |   67 +
 drivers/gpu/drm/gma500/psb_device.c          |  328 ++++
 drivers/gpu/drm/gma500/psb_drv.c             |  703 +++++++
 drivers/gpu/drm/gma500/psb_drv.h             |  956 ++++++++++
 drivers/gpu/drm/gma500/psb_intel_display.c   | 1446 ++++++++++++++
 drivers/gpu/drm/gma500/psb_intel_display.h   |   28 +
 drivers/gpu/drm/gma500/psb_intel_drv.h       |  289 +++
 drivers/gpu/drm/gma500/psb_intel_lvds.c      |  868 +++++++++
 drivers/gpu/drm/gma500/psb_intel_modes.c     |   75 +
 drivers/gpu/drm/gma500/psb_intel_reg.h       | 1309 +++++++++++++
 drivers/gpu/drm/gma500/psb_intel_sdvo.c      | 2617 ++++++++++++++++++++++++++
 drivers/gpu/drm/gma500/psb_intel_sdvo_regs.h |  723 +++++++
 drivers/gpu/drm/gma500/psb_irq.c             |  564 ++++++
 drivers/gpu/drm/gma500/psb_irq.h             |   45 +
 drivers/gpu/drm/gma500/psb_lid.c             |   88 +
 drivers/gpu/drm/gma500/psb_reg.h             |  582 ++++++
 drivers/gpu/drm/i810/i810_dma.c              |   19 +-
 drivers/gpu/drm/i810/i810_drv.c              |   24 +-
 drivers/gpu/drm/i810/i810_drv.h              |    6 +-
 drivers/gpu/drm/i915/Makefile                |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c          |   86 +-
 drivers/gpu/drm/i915/i915_dma.c              |    5 +
 drivers/gpu/drm/i915/i915_drv.c              |   38 +-
 drivers/gpu/drm/i915/i915_drv.h              |    8 +-
 drivers/gpu/drm/i915/i915_gem.c              |   10 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c   |   63 +-
 drivers/gpu/drm/i915/i915_irq.c              |   22 +-
 drivers/gpu/drm/i915/i915_reg.h              |  186 ++-
 drivers/gpu/drm/i915/intel_display.c         |  360 +++-
 drivers/gpu/drm/i915/intel_dp.c              |    1 +
 drivers/gpu/drm/i915/intel_drv.h             |   51 +-
 drivers/gpu/drm/i915/intel_fb.c              |   19 +-
 drivers/gpu/drm/i915/intel_hdmi.c            |    8 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c      |   30 +-
 drivers/gpu/drm/i915/intel_sprite.c          |  668 +++++++
 drivers/gpu/drm/mga/mga_drv.c                |   29 +-
 drivers/gpu/drm/nouveau/Makefile             |    9 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c       |  904 +++-------
 drivers/gpu/drm/nouveau/nouveau_bios.h       |   69 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c         |  119 ++-
 drivers/gpu/drm/nouveau/nouveau_channel.c    |    2 +
 drivers/gpu/drm/nouveau/nouveau_connector.c  |  403 +++--
 drivers/gpu/drm/nouveau/nouveau_connector.h  |   36 +-
 drivers/gpu/drm/nouveau/nouveau_crtc.h       |    6 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c    |    3 +-
 drivers/gpu/drm/nouveau/nouveau_display.c    |  198 ++-
 drivers/gpu/drm/nouveau/nouveau_dma.c        |   14 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c         |   22 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c        |   80 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h        |  133 +-
 drivers/gpu/drm/nouveau/nouveau_fb.h         |    4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c      |   22 +-
 drivers/gpu/drm/nouveau/nouveau_gpio.c       |  400 ++++
 drivers/gpu/drm/nouveau/nouveau_gpio.h       |   71 +
 drivers/gpu/drm/nouveau/nouveau_hdmi.c       |  258 +++
 drivers/gpu/drm/nouveau/nouveau_hwsq.h       |  115 ++
 drivers/gpu/drm/nouveau/nouveau_i2c.c        |  556 ++++--
 drivers/gpu/drm/nouveau/nouveau_i2c.h        |   21 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c        |   10 +-
 drivers/gpu/drm/nouveau/nouveau_mxm.c        |  677 +++++++
 drivers/gpu/drm/nouveau/nouveau_notifier.c   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_object.c     |   25 +-
 drivers/gpu/drm/nouveau/nouveau_perf.c       |   18 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c         |  382 ++++-
 drivers/gpu/drm/nouveau/nouveau_pm.h         |   24 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c      |  179 +--
 drivers/gpu/drm/nouveau/nouveau_state.c      |  197 +-
 drivers/gpu/drm/nouveau/nouveau_temp.c       |   29 +-
 drivers/gpu/drm/nouveau/nouveau_vm.c         |    3 +-
 drivers/gpu/drm/nouveau/nouveau_vm.h         |    2 +-
 drivers/gpu/drm/nouveau/nouveau_volt.c       |   15 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c          |   14 +-
 drivers/gpu/drm/nouveau/nv04_dac.c           |   14 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c           |   16 +-
 drivers/gpu/drm/nouveau/nv04_display.c       |    5 +
 drivers/gpu/drm/nouveau/nv04_pm.c            |  109 +-
 drivers/gpu/drm/nouveau/nv04_timer.c         |    3 +-
 drivers/gpu/drm/nouveau/nv10_gpio.c          |  117 +-
 drivers/gpu/drm/nouveau/nv17_tv.c            |   20 +-
 drivers/gpu/drm/nouveau/nv40_pm.c            |   50 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c          |  347 ++--
 drivers/gpu/drm/nouveau/nv50_dac.c           |    7 +-
 drivers/gpu/drm/nouveau/nv50_display.c       |  140 +-
 drivers/gpu/drm/nouveau/nv50_display.h       |    4 +
 drivers/gpu/drm/nouveau/nv50_evo.c           |   12 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c          |    6 +-
 drivers/gpu/drm/nouveau/nv50_gpio.c          |  272 +---
 drivers/gpu/drm/nouveau/nv50_graph.c         |    4 +-
 drivers/gpu/drm/nouveau/nv50_pm.c            |  783 +++++++-
 drivers/gpu/drm/nouveau/nv50_sor.c           |   28 +-
 drivers/gpu/drm/nouveau/nv50_vm.c            |    2 +-
 drivers/gpu/drm/nouveau/nv84_bsp.c           |   83 +
 drivers/gpu/drm/nouveau/nv84_vp.c            |   83 +
 drivers/gpu/drm/nouveau/nv98_crypt.c         |   78 +
 drivers/gpu/drm/nouveau/nv98_ppp.c           |   78 +
 drivers/gpu/drm/nouveau/nva3_copy.fuc        |  262 ++--
 drivers/gpu/drm/nouveau/nva3_copy.fuc.h      |    2 +-
 drivers/gpu/drm/nouveau/nva3_pm.c            |    6 +-
 drivers/gpu/drm/nouveau/nvc0_copy.fuc.h      |    2 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c         |    6 +-
 drivers/gpu/drm/nouveau/nvc0_graph.fuc       |   56 +-
 drivers/gpu/drm/nouveau/nvc0_graph.h         |    1 +
 drivers/gpu/drm/nouveau/nvc0_grctx.c         |  127 +-
 drivers/gpu/drm/nouveau/nvc0_grgpc.fuc       |  217 ++-
 drivers/gpu/drm/nouveau/nvc0_grgpc.fuc.h     |   80 +-
 drivers/gpu/drm/nouveau/nvc0_grhub.fuc       |  311 ++--
 drivers/gpu/drm/nouveau/nvc0_grhub.fuc.h     |   96 +-
 drivers/gpu/drm/nouveau/nvc0_pm.c            |  237 +++
 drivers/gpu/drm/nouveau/nvd0_display.c       |  833 +++++++--
 drivers/gpu/drm/r128/r128_drv.c              |   30 +-
 drivers/gpu/drm/radeon/Makefile              |    5 +-
 drivers/gpu/drm/radeon/atom.c                |    2 +
 drivers/gpu/drm/radeon/atombios_crtc.c       |    6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c   |   35 +-
 drivers/gpu/drm/radeon/evergreen.c           |  241 ++-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c  |  242 ++--
 drivers/gpu/drm/radeon/evergreen_cs.c        |  246 +++-
 drivers/gpu/drm/radeon/evergreen_reg.h       |   13 +
 drivers/gpu/drm/radeon/evergreend.h          |   65 +-
 drivers/gpu/drm/radeon/ni.c                  |  395 +++-
 drivers/gpu/drm/radeon/nid.h                 |   35 +
 drivers/gpu/drm/radeon/r100.c                |  232 ++--
 drivers/gpu/drm/radeon/r200.c                |   21 +-
 drivers/gpu/drm/radeon/r300.c                |  160 +-
 drivers/gpu/drm/radeon/r420.c                |   49 +-
 drivers/gpu/drm/radeon/r500_reg.h            |    2 +
 drivers/gpu/drm/radeon/r520.c                |   25 +-
 drivers/gpu/drm/radeon/r600.c                |  273 ++--
 drivers/gpu/drm/radeon/r600_audio.c          |   57 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c       |  235 ++--
 drivers/gpu/drm/radeon/r600_cp.c             |    2 +-
 drivers/gpu/drm/radeon/r600_cs.c             |    8 +-
 drivers/gpu/drm/radeon/r600_hdmi.c           |   65 +-
 drivers/gpu/drm/radeon/r600d.h               |    2 +
 drivers/gpu/drm/radeon/radeon.h              |  367 +++-
 drivers/gpu/drm/radeon/radeon_asic.c         |  197 ++-
 drivers/gpu/drm/radeon/radeon_asic.h         |   48 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c    |    8 +-
 drivers/gpu/drm/radeon/radeon_cs.c           |  302 +++-
 drivers/gpu/drm/radeon/radeon_device.c       |   76 +-
 drivers/gpu/drm/radeon/radeon_display.c      |   10 +-
 drivers/gpu/drm/radeon/radeon_drv.c          |   69 +-
 drivers/gpu/drm/radeon/radeon_fb.c           |   24 +-
 drivers/gpu/drm/radeon/radeon_fence.c        |  307 ++--
 drivers/gpu/drm/radeon/radeon_gart.c         |  425 ++++-
 drivers/gpu/drm/radeon/radeon_gem.c          |  147 ++-
 drivers/gpu/drm/radeon/radeon_irq_kms.c      |   24 +-
 drivers/gpu/drm/radeon/radeon_kms.c          |   47 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c  |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h         |    2 +-
 drivers/gpu/drm/radeon/radeon_object.c       |   38 +-
 drivers/gpu/drm/radeon/radeon_object.h       |   32 +
 drivers/gpu/drm/radeon/radeon_pm.c           |   34 +-
 drivers/gpu/drm/radeon/radeon_ring.c         |  465 +++---
 drivers/gpu/drm/radeon/radeon_sa.c           |  189 ++
 drivers/gpu/drm/radeon/radeon_semaphore.c    |  178 ++
 drivers/gpu/drm/radeon/radeon_test.c         |  269 +++-
 drivers/gpu/drm/radeon/radeon_ttm.c          |  355 ++--
 drivers/gpu/drm/radeon/rs400.c               |   27 +-
 drivers/gpu/drm/radeon/rs600.c               |   38 +-
 drivers/gpu/drm/radeon/rs690.c               |   30 +-
 drivers/gpu/drm/radeon/rv515.c               |  106 +-
 drivers/gpu/drm/radeon/rv770.c               |   63 +-
 drivers/gpu/drm/savage/savage_drv.c          |   23 +-
 drivers/gpu/drm/sis/sis_drv.c                |   56 +-
 drivers/gpu/drm/sis/sis_drv.h                |    7 +-
 drivers/gpu/drm/sis/sis_mm.c                 |  199 ++-
 drivers/gpu/drm/tdfx/tdfx_drv.c              |   23 +-
 drivers/gpu/drm/ttm/Makefile                 |    4 +
 drivers/gpu/drm/ttm/ttm_agp_backend.c        |  105 +-
 drivers/gpu/drm/ttm/ttm_bo.c                 |   90 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c            |   32 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c              |    9 +-
 drivers/gpu/drm/ttm/ttm_memory.c             |    2 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c         |  184 ++-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c     | 1143 +++++++++++
 drivers/gpu/drm/ttm/ttm_tt.c                 |  324 +---
 drivers/gpu/drm/via/via_drv.c                |   48 +-
 drivers/gpu/drm/via/via_drv.h                |    7 +-
 drivers/gpu/drm/via/via_map.c                |   10 +-
 drivers/gpu/drm/via/via_mm.c                 |  135 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c       |   71 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c          |   30 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c          |   32 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h          |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c          |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c     |   35 +-
 drivers/staging/gma500/accel_2d.c            |    2 +-
 drivers/staging/gma500/cdv_intel_display.c   |    4 +-
 drivers/staging/gma500/framebuffer.c         |   41 +-
 drivers/staging/gma500/mdfld_intel_display.c |    4 +-
 drivers/staging/gma500/mrst_crtc.c           |    4 +-
 drivers/staging/gma500/power.c               |    2 +-
 drivers/staging/gma500/psb_drv.c             |   23 +-
 drivers/staging/gma500/psb_intel_display.c   |    4 +-
 drivers/xen/swiotlb-xen.c                    |    2 +-
 include/drm/Kbuild                           |    1 +
 include/drm/drm.h                            |    4 +
 include/drm/drmP.h                           |   10 +-
 include/drm/drm_crtc.h                       |  212 ++-
 include/drm/drm_crtc_helper.h                |    5 +-
 include/drm/drm_fourcc.h                     |  137 ++
 include/drm/drm_mode.h                       |   74 +-
 include/drm/drm_sman.h                       |  176 --
 include/drm/exynos_drm.h                     |   37 +
 include/drm/gma_drm.h                        |   91 +
 include/drm/i915_drm.h                       |   40 +
 include/drm/radeon_drm.h                     |   36 +
 include/drm/sis_drm.h                        |    4 +
 include/drm/ttm/ttm_bo_api.h                 |   24 +-
 include/drm/ttm/ttm_bo_driver.h              |  203 +--
 include/drm/ttm/ttm_page_alloc.h             |   77 +-
 include/drm/via_drm.h                        |    4 +
 include/linux/swiotlb.h                      |    2 +-
 lib/swiotlb.c                                |    5 +-
 289 files changed, 43103 insertions(+), 6739 deletions(-)
 delete mode 100644 drivers/gpu/drm/drm_sman.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_ddc.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_hdmi.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_hdmi.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_plane.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_plane.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_hdmiphy.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_mixer.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_mixer.h
 create mode 100644 drivers/gpu/drm/exynos/regs-hdmi.h
 create mode 100644 drivers/gpu/drm/exynos/regs-mixer.h
 create mode 100644 drivers/gpu/drm/exynos/regs-vp.h
 create mode 100644 drivers/gpu/drm/gma500/Kconfig
 create mode 100644 drivers/gpu/drm/gma500/Makefile
 create mode 100644 drivers/gpu/drm/gma500/accel_2d.c
 create mode 100644 drivers/gpu/drm/gma500/backlight.c
 create mode 100644 drivers/gpu/drm/gma500/cdv_device.c
 create mode 100644 drivers/gpu/drm/gma500/cdv_device.h
 create mode 100644 drivers/gpu/drm/gma500/cdv_intel_crt.c
 create mode 100644 drivers/gpu/drm/gma500/cdv_intel_display.c
 create mode 100644 drivers/gpu/drm/gma500/cdv_intel_hdmi.c
 create mode 100644 drivers/gpu/drm/gma500/cdv_intel_lvds.c
 create mode 100644 drivers/gpu/drm/gma500/framebuffer.c
 create mode 100644 drivers/gpu/drm/gma500/framebuffer.h
 create mode 100644 drivers/gpu/drm/gma500/gem.c
 create mode 100644 drivers/gpu/drm/gma500/gem_glue.c
 create mode 100644 drivers/gpu/drm/gma500/gem_glue.h
 create mode 100644 drivers/gpu/drm/gma500/gtt.c
 create mode 100644 drivers/gpu/drm/gma500/gtt.h
 create mode 100644 drivers/gpu/drm/gma500/intel_bios.c
 create mode 100644 drivers/gpu/drm/gma500/intel_bios.h
 create mode 100644 drivers/gpu/drm/gma500/intel_gmbus.c
 create mode 100644 drivers/gpu/drm/gma500/intel_i2c.c
 create mode 100644 drivers/gpu/drm/gma500/intel_opregion.c
 create mode 100644 drivers/gpu/drm/gma500/mid_bios.c
 create mode 100644 drivers/gpu/drm/gma500/mid_bios.h
 create mode 100644 drivers/gpu/drm/gma500/mmu.c
 create mode 100644 drivers/gpu/drm/gma500/oaktrail.h
 create mode 100644 drivers/gpu/drm/gma500/oaktrail_crtc.c
 create mode 100644 drivers/gpu/drm/gma500/oaktrail_device.c
 create mode 100644 drivers/gpu/drm/gma500/oaktrail_hdmi.c
 create mode 100644 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
 create mode 100644 drivers/gpu/drm/gma500/oaktrail_lvds.c
 create mode 100644 drivers/gpu/drm/gma500/power.c
 create mode 100644 drivers/gpu/drm/gma500/power.h
 create mode 100644 drivers/gpu/drm/gma500/psb_device.c
 create mode 100644 drivers/gpu/drm/gma500/psb_drv.c
 create mode 100644 drivers/gpu/drm/gma500/psb_drv.h
 create mode 100644 drivers/gpu/drm/gma500/psb_intel_display.c
 create mode 100644 drivers/gpu/drm/gma500/psb_intel_display.h
 create mode 100644 drivers/gpu/drm/gma500/psb_intel_drv.h
 create mode 100644 drivers/gpu/drm/gma500/psb_intel_lvds.c
 create mode 100644 drivers/gpu/drm/gma500/psb_intel_modes.c
 create mode 100644 drivers/gpu/drm/gma500/psb_intel_reg.h
 create mode 100644 drivers/gpu/drm/gma500/psb_intel_sdvo.c
 create mode 100644 drivers/gpu/drm/gma500/psb_intel_sdvo_regs.h
 create mode 100644 drivers/gpu/drm/gma500/psb_irq.c
 create mode 100644 drivers/gpu/drm/gma500/psb_irq.h
 create mode 100644 drivers/gpu/drm/gma500/psb_lid.c
 create mode 100644 drivers/gpu/drm/gma500/psb_reg.h
 create mode 100644 drivers/gpu/drm/i915/intel_sprite.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_gpio.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_gpio.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_hdmi.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_hwsq.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_mxm.c
 create mode 100644 drivers/gpu/drm/nouveau/nv84_bsp.c
 create mode 100644 drivers/gpu/drm/nouveau/nv84_vp.c
 create mode 100644 drivers/gpu/drm/nouveau/nv98_crypt.c
 create mode 100644 drivers/gpu/drm/nouveau/nv98_ppp.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_sa.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_semaphore.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
 create mode 100644 include/drm/drm_fourcc.h
 delete mode 100644 include/drm/drm_sman.h
 create mode 100644 include/drm/gma_drm.h
--29444707-431945765-1326191805=:25051--
