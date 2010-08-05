Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab0HEKs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:48:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33220 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab0HEKs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:48:56 -0400
Date: Thu, 5 Aug 2010 11:48:40 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm tree
Message-ID: <alpine.DEB.2.00.1008051136220.30829@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-558529026-1281005320=:30829"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-558529026-1281005320=:30829
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


Hi Linus,

drm merge window pull,
highlights (or at least major movers)
core: BKL removal
      some whitespace misc cleanup
      non-pci drm layer support
      misc memory leak fixes
      vblank tracepoints

Intel: ongoing eDP support
       misc ickle patches all over
       pageflip and vblank tracepoints
       
Radeon: r600/700 tiling support
        r300/r500 hyper-z support
        r600 thermal sensors support
        r600 kernel blit state emission minimisation
	ioport accessors for BIOS scripts
	underscan support for HDMI TVs
        rs690 family HDMI audio support

Nouveau: improved nv10->nv40 suspend/resume support
	 sil164 i2c chip support
         improved nv50 DP support + hotplug support
	 EDID from ACPI support

Along with lots of fixes all over the place.

Dave.

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Adam Jackson (7):
      drm/i915/pch: Cosmetic fix to FDI link training
      drm/i915/dp: Rename has_edp to is_pch_edp to reflect its real meaning
      drm/i915/dp: Correctly report eDP in the core connector type
      drm/i915: Initialize LVDS and eDP outputs before anything else
      drm/i915/pch: Set transcoder sync polarity for DP based on actual mode
      drm/i915/hdmi: Set sync polarity based on actual mode
      drm/i915/sdvo: Set sync polarity based on actual mode

Albert Damen (1):
      drm/nouveau: set encoder for lvds

Alberto Milone (1):
      drm/radeon: Add support for the ATIF ACPI method to the radeon driver

Alex Deucher (28):
      drm/kms: add crtc disable function
      drm/radeon/kms/atom: add crtc disable function
      drm/radeon/kms: minor driver cleanups
      drm/radeon/kms/atom: bump atom loop timeout from 1 sec to 5 secs
      drm/radeon/kms: add support for internal thermal sensors (v3)
      drm/radeon/kms: Add crtc tiling setup support for r6xx/r7xx
      drm/radeon/kms: Add crtc tiling setup support for evergreen
      drm/radeon/kms: add tiling support to the cs checker for r6xx/r7xx
      drm/radeon/kms: fix CS alignment checking for tiling (v2)
      drm/radeon/kms/r6xx+: add query for tile config (v2)
      drm/radeon/kms: add ioport register access
      drm/radeon/kms: remove rs4xx gart limit
      drm/radeon/kms/r7xx: add workaround for hw issue with HDP flush
      drm/radeon: add comments to r6xx/r7xx blit state
      drm/radeon: remove duplicate state emit in r6xx/r7xx blit
      drm/radeon: group r6xx/r7xx sequential blit state
      drm/radeon: r6xx/r7xx move vport clipping to a single packet
      drm/radeon: reorder r6xx/r7xx blit state emit to make more regs sequential
      drm/radeon: group r6xx/r7xx newly sequential blit state
      drm/radeon: remove viewport transform from r6xx/r7xx blit emit
      drm/radeon/kms: make sure rio_mem is valid before unmapping it
      drm/radeon/kms: make sure HPD is set to NONE on analog-only connectors
      drm/radeon/kms: handle the case of no active displays properly in the bandwidth code
      drm/radeon/kms/igp: sideport is AMD only
      drm/radeon/kms: fix calculation of h/v scaling factors
      drm/radeon/kms: enable underscan option for digital connectors
      drm/radeon: add new pci ids
      drm/radeon/kms: only expose underscan on avivo chips

Arnd Bergmann (1):
      drm: kill BKL from common code

Ben Skeggs (46):
      drm: disable encoder rather than dpms off in drm_crtc_prepare_encoders()
      drm/nouveau: place notifiers in system memory by default
      drm/nouveau: move LVDS detection back to connector detect() time
      drm/nouveau: use drm_mm in preference to custom code doing the same thing
      drm/nouveau: remove left-over !DRIVER_MODESET paths
      drm/nouveau: missed some braces
      drm/nv50: fix memory detection for cards with >=4GiB VRAM
      drm/nouveau: tidy connector/encoder creation a little
      drm/nouveau: downgrade severity of most init table parser errors
      drm/nv50: fix DP->DVI if output has been programmed for native DP previously
      drm/nv50: DCB quirk for Dell M6300
      drm/nv50: supply encoder disable() hook for SOR outputs
      drm/nv50: when debugging on, log which crtc we connect an encoder to
      drm/nv50: send evo "update" command after each disconnect
      drm/nv50: rewrite display irq handler
      drm/nouveau: move DP script invocation to nouveau_dp.c
      drm/nv50: set DP display power state during DPMS
      drm/nouveau: add scaler-only modes for eDP too
      drm/nouveau: remove dev_priv->init_state and friends
      drm/nv50: implement DAC disconnect fix missed in earlier commit
      drm/nouveau: add instmem flush() hook
      drm/nv50: move tlb flushing to a helper function
      drm/nouveau: remove ability to use external firmware
      drm/nouveau: allocate fixed amount of PRAMIN per channel on all chipsets
      drm/nouveau: remove unused fbdev_info
      drm/nv50: cleanup nv50_fifo.c
      drm/nv20-nv30: move context table object out of dev_priv
      drm/nv50: fix dp_set_tmds to work on the right OR
      drm/nouveau: fix mtrr cleanup path
      drm/nv50: move dp_set_tmds() function to happen in the last display irq
      drm/nouveau: initialise display before enabling interrupts
      drm/nouveau: fix pcirom vbios shadow breakage from acpi rom patch
      drm/nv50: fix RAMHT size
      drm/nouveau: reduce usage of fence spinlock to when absolutely necessary
      drm: add "auto" dithering method
      drm/nv50: use correct PRAMIN flush register on original nv50
      drm/nouveau: remove quirk to fabricate DVI-A output on DCB 1.5 boards
      drm/nouveau: support fetching LVDS EDID from ACPI
      drm/nv50: fix regression that break LVDS in some places
      drm/nouveau: fix build without CONFIG_ACPI
      drm/nouveau: add nv_mask register accessor
      drm/nv50: add function to control GPIO IRQ reporting
      drm/nouveau: disable hotplug detect around DP link training
      drm/nv50: correct wait condition for instmem flush
      drm/nouveau: introduce gpio engine
      drm/nv50: fix some not-error error messages

Chris Wilson (31):
      drm: Return EBUSY if the framebuffer is unbound when flipping.
      drm/vmgfx: operation on ‘par->dirty.y1’ may be undefined
      drm: Free the idr layers before calling idr_destroy()
      drm: Free devname along with master->unique
      drm/i915: Explosion following OOM in do_execbuffer.
      drm/i915: Propagate error from drm_install_irq() during EnterVT
      drm/i915: Propagate error from drm_vblank_get() during page-flipping.
      drm/i915: Propagate error from i915_gem_object_flush_gpu_write_domain()
      drm/i915: Silence sparse complaints over insufficient bitfield int types.
      drm/i915: Silence sparse over duplicate members in static initializer
      drm/i915: Silence sparse over non-static local structure.
      drm/i915: Sparse warns about the incorrect sign for storing bit17
      drm/i915: Sparse warning about invalid value for burst_ena in tv_modes
      drm/i915: Remove the WARN when failing to set tiling.
      drm/i915: Include instdone[1] in hangcheck
      drm/i915: Use 128k alignment for untiled display surface on i965 (v2)
      drm/i915: Include any alternate names by which the device is known.
      agp/intel: Destroy the scatterlist on allocation failure
      drm/i915: Remove the redundant check for a fixed_panel_mode
      drm/i915: Refactor panel fitting on the LVDS. (v2)
      drm/i915: Check overlay stride errata for i830 and i845
      drm/i915: Typo in (unused) register mask for overlay.
      drm/i915: Round up the watermark entries (v3)
      drm/i915: Warn if we run out of FIFO space for a mode
      drm/i915: Refactor i915_gem_retire_requests()
      drm/i915: Repeat unbinding during free if interrupted (v6)
      drm/i915: Attempt to uncouple object after catastrophic failure in unbind
      drm/i915: Unreference object not handle on creation
      drm/i915: Unset cursor if out-of-bounds upon mode change (v4)
      drm: Cleanup after failing to create master->unique and dev->name
      drm,io-mapping: Specify slot to use for atomic mappings

Dan Carpenter (2):
      drm: radeon: fix sign bug
      drm/i915: cleanup: use ARRAY_SIZE()

Daniel Vetter (6):
      drm: use list_for_each_entry in drm_mm.c
      drm: kill drm_mm_node->private
      drm: kill dead code in drm_mm.c
      drm: sane naming for drm_mm.c
      drm_mm: extract check_free_mm_node
      drm: implement helper functions for scanning lru list

Dave Airlie (14):
      Merge tag 'v2.6.35-rc4' into drm-testing
      Merge branch 'drm-platform' into drm-testing
      Merge branch 'drm-intel-lru' into drm-testing
      Merge branch 'drm-tracepoints' into drm-testing
      drm: add PCI requirements to low-level drivers.
      drm/radeon/kms: check/restore sanity before doing anything else with GPU.
      Merge tag 'v2.6.35-rc6' into drm-radeon-next
      Merge branch 'drm-radeon-next' of ../drm-radeon-next into drm-core-next
      Merge remote branch 'nouveau/for-airlied' of ../drm-nouveau-next into drm-core-next
      drm/radeon/kms: move a bunch of modesetting debug to correct debug usage.
      drm/radeon: add basic zmask/hiz support (v4)
      drm: move ttm global code to core drm
      Merge remote branch 'intel/drm-intel-next' of /ssd/git/drm-next into drm-core-next
      drm/radeon: tone down overchatty acpi debug messages.

Eric Anholt (2):
      Merge remote branch 'origin/master' into drm-intel-next
      drm/i915: Clear the Ironlake dithering flags when the pipe doesn't want it.

Francisco Jerez (33):
      drm/nouveau: Put the dithering check back in nouveau_connector_create.
      drm/nouveau: Don't clear AGPCMD completely on INIT_RESET.
      drm/nouveau: Ignore broken legacy I2C entries.
      drm/nv17-nv40: Avoid using active CRTCs for load detection.
      drm/nv04-nv40: Prevent invalid DAC/TVDAC combinations.
      drm/nv04-nv40: Disable connector polling when there're no spare CRTCs left.
      drm/nouveau: Fix a couple of sparse warnings.
      drm/nouveau: INIT_CONFIGURE_PREINIT/CLK/MEM on newer BIOSes is not an error.
      drm/nv04-nv40: Drop redundant logging.
      drm/nouveau: Move the fence wait before migration resource clean-up.
      drm/nouveau: Workaround broken TV load detection on a "Zotac FX5200".
      drm/nouveau: Fix crashes during fbcon init on single head cards.
      drm/nouveau: Disable PROM access on init.
      drm/nv04: Enable context switching on PFIFO init.
      drm/i2c/ch7006: Fix up suspend/resume.
      drm/nouveau: Fix a sparse warning.
      drm/nouveau: Don't pick an interlaced mode as the panel native mode.
      drm/nouveau: Add another Zotac FX5200 TV-out quirk.
      drm/nouveau: Add some PFB register defines.
      drm/nv04-nv3x: Implement init-compute-mem.
      drm/i2c/ch7006: Don't assume that the specified config points to static memory.
      drm/nouveau: Add some generic I2C gadget detection code.
      drm/nouveau: Remove useless CRTC_OWNER logging.
      drm/nouveau: No need to lock/unlock the VGA CRTC regs all the time.
      drm/nouveau: Reset CRTC owner to 0 before BIOS init.
      drm/nv30: Init the PFB+0x3xx memory timing regs.
      drm/nouveau: Reset AGP before running the init scripts.
      drm/nouveau: Put back the old 2-messages I2C slave test.
      drm/nouveau: Move display init to a new nouveau_engine.
      drm/nouveau: Get rid of the remaining VGA CRTC locking.
      drm/nouveau: Fix TV-out detection on unposted cards lacking a usable DCB table.
      drm: Import driver for the sil164 I2C TMDS transmitter.
      drm/kms: Simplify setup of the initial I2C encoder config.

Jerome Glisse (1):
      drm: unify crtc,connector,encoder,fb debug printing

Jesse Barnes (8):
      drm: add vblank event trace point
      drm: add per-event vblank event trace points
      drm/i915: add tracepoints for flip requests & completions
      drm/i915: remove unused vblank_enable var from i915_driver_irq_handler
      drm/i915: remove duplicate PIPE*STAT bit definitions
      drm/i915: fix FDI frequency check
      drm/i915: apply DP bandwidth workaround for PCH eDP as well
      drm/agp/i915: trim stolen space to 32M

Jordan Crouse (4):
      drm: Remove drm_resource wrappers
      drm: Add support for platform devices to register as DRM devices
      drm: Add __arm defines to DRM
      drm: Make sure the DRM offset matches the CPU

Kulikov Vasiliy (3):
      drm/nouveau: set TASK_(UN)INTERRUPTIBLE before schedule_timeout()
      agp: efficeon-agp: do not use PCI resources before pci_enable_device()
      agp: intel-agp: do not use PCI resources before pci_enable_device()

Michel Dänzer (1):
      drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.

Nicolas Kaiser (7):
      drm/i810: fixed coding style issues
      drm/i830: fixed brace and spacing coding style issues
      drm/via: fixed coding style issues, simplified return
      drm/mga: fixed brace, macro and spacing coding style issues
      drm/r128: fixed brace and spacing coding style issues
      drm/sis: fixed brace and spacing coding style issues
      drm/i915: Typo in #define

Ondrej Zary (1):
      intel_agp: Don't oops with zero stolen memory

Rafał Miłecki (3):
      drm/radeon/kms: track audio engine state, do not use not setup timer
      drm/radeon/kms: enable HDMI audio on RS600/RS690/RS740
      drm/radeon/kms: trivial code style fixes for audio

Thomas Bächler (1):
      gpu/drm/i915: Add a blacklist to omit modeset on LID open

Zhao Yakui (10):
      drm/i915: Add the support of eDP on DP-D for Ibex/CPT
      drm/i915: Fix watermark calculation in self-refresh mode
      drm/i915: Fix fifo size for self-refresh watermark on 965G
      drm/i915: Apply self-refresh watermark calculation for cursor plane
      drm/i915: Calculate cursor watermark under non-SR state for Ironlake
      drm/i915: Add frame buffer compression support on Ironlake mobile
      drm/i915: Add fixed panel mode parsed from EDID for eDP without fixed mode in VBT
      drm/i915: Enable panel fitting for eDP
      drm/i915: Always use the fixed panel timing for eDP
      drm/i915: Validate the mode for eDP by using fixed panel size

Zhenyu Wang (2):
      agp/intel: Support the extended physical addressing bits on Sandybridge.
      agp/intel: Add actual definitions of the Sandybridge PTE caching bits.

 drivers/char/agp/efficeon-agp.c                    |   22 +-
 drivers/char/agp/intel-agp.c                       |   26 +-
 drivers/char/agp/intel-agp.h                       |    6 +
 drivers/char/agp/intel-gtt.c                       |   83 ++-
 drivers/gpu/drm/Kconfig                            |   11 +-
 drivers/gpu/drm/Makefile                           |    7 +-
 drivers/gpu/drm/drm_bufs.c                         |   15 +-
 drivers/gpu/drm/drm_crtc.c                         |   30 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |   71 +-
 drivers/gpu/drm/drm_drv.c                          |   43 +-
 drivers/gpu/drm/drm_edid.c                         |    4 +-
 drivers/gpu/drm/drm_encoder_slave.c                |    7 +
 drivers/gpu/drm/drm_fops.c                         |   23 +-
 drivers/gpu/drm/drm_gem.c                          |   11 +
 drivers/gpu/drm/{ttm/ttm_global.c => drm_global.c} |   30 +-
 drivers/gpu/drm/drm_info.c                         |   23 +-
 drivers/gpu/drm/drm_ioctl.c                        |  140 ++-
 drivers/gpu/drm/drm_irq.c                          |   26 +-
 drivers/gpu/drm/drm_mm.c                           |  359 ++++---
 drivers/gpu/drm/drm_pci.c                          |  143 +++
 drivers/gpu/drm/drm_platform.c                     |  122 +++
 drivers/gpu/drm/drm_stub.c                         |   92 +--
 drivers/gpu/drm/drm_sysfs.c                        |    3 +-
 drivers/gpu/drm/drm_trace.h                        |   66 ++
 drivers/gpu/drm/drm_trace_points.c                 |    4 +
 drivers/gpu/drm/drm_vm.c                           |   14 +-
 drivers/gpu/drm/i2c/Makefile                       |    3 +
 drivers/gpu/drm/i2c/ch7006_drv.c                   |   22 +-
 drivers/gpu/drm/i2c/ch7006_priv.h                  |    2 +-
 drivers/gpu/drm/i2c/sil164_drv.c                   |  462 ++++++++
 drivers/gpu/drm/i810/i810_dma.c                    |  125 ++-
 drivers/gpu/drm/i810/i810_drv.c                    |    2 +-
 drivers/gpu/drm/i810/i810_drv.h                    |   65 +-
 drivers/gpu/drm/i830/i830_dma.c                    |  137 ++--
 drivers/gpu/drm/i830/i830_drv.c                    |    2 +-
 drivers/gpu/drm/i830/i830_drv.h                    |   49 +-
 drivers/gpu/drm/i830/i830_irq.c                    |   10 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   24 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   66 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   29 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  172 ++-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |    2 -
 drivers/gpu/drm/i915/i915_irq.c                    |   58 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   56 +-
 drivers/gpu/drm/i915/i915_suspend.c                |    9 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   36 +
 drivers/gpu/drm/i915/intel_display.c               |  586 ++++++++---
 drivers/gpu/drm/i915/intel_dp.c                    |  143 +++-
 drivers/gpu/drm/i915/intel_drv.h                   |   10 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |    9 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  331 +++----
 drivers/gpu/drm/i915/intel_overlay.c               |   14 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    8 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   12 +-
 drivers/gpu/drm/mga/mga_dma.c                      |  103 +-
 drivers/gpu/drm/mga/mga_drv.c                      |    4 +-
 drivers/gpu/drm/mga/mga_drv.h                      |  187 ++--
 drivers/gpu/drm/mga/mga_irq.c                      |    9 +-
 drivers/gpu/drm/mga/mga_state.c                    |   47 +-
 drivers/gpu/drm/mga/mga_warp.c                     |    4 +-
 drivers/gpu/drm/nouveau/Kconfig                    |   11 +-
 drivers/gpu/drm/nouveau/Makefile                   |    6 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   38 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |  636 +++++++++---
 drivers/gpu/drm/nouveau/nouveau_bios.h             |    4 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   11 +-
 drivers/gpu/drm/nouveau/nouveau_calc.c             |    4 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c          |    8 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  404 ++++----
 drivers/gpu/drm/nouveau/nouveau_connector.h        |    7 +-
 drivers/gpu/drm/nouveau/nouveau_dma.c              |    8 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |   41 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c              |   41 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |  137 ++--
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |   10 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   35 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   11 +-
 drivers/gpu/drm/nouveau/nouveau_grctx.c            |  160 ---
 drivers/gpu/drm/nouveau/nouveau_i2c.c              |   42 +
 drivers/gpu/drm/nouveau/nouveau_i2c.h              |    3 +
 drivers/gpu/drm/nouveau/nouveau_mem.c              |  332 ++-----
 drivers/gpu/drm/nouveau/nouveau_notifier.c         |   30 +-
 drivers/gpu/drm/nouveau/nouveau_object.c           |  105 +--
 drivers/gpu/drm/nouveau/nouveau_reg.h              |   91 ++-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |   46 +-
 drivers/gpu/drm/nouveau/nouveau_state.c            |  255 +++--
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |   20 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c                |    5 +
 drivers/gpu/drm/nouveau/nv04_dac.c                 |   50 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c                 |   12 +-
 drivers/gpu/drm/nouveau/nv04_display.c             |   90 +-
 drivers/gpu/drm/nouveau/nv04_fifo.c                |   20 +-
 drivers/gpu/drm/nouveau/nv04_graph.c               |    5 +-
 drivers/gpu/drm/nouveau/nv04_instmem.c             |   21 +-
 drivers/gpu/drm/nouveau/nv04_mc.c                  |    4 +
 drivers/gpu/drm/nouveau/nv04_tv.c                  |  125 +--
 drivers/gpu/drm/nouveau/nv10_fifo.c                |   10 -
 .../gpu/drm/nouveau/{nv17_gpio.c => nv10_gpio.c}   |    4 +-
 drivers/gpu/drm/nouveau/nv17_tv.c                  |   65 +-
 drivers/gpu/drm/nouveau/nv20_graph.c               |  100 +-
 drivers/gpu/drm/nouveau/nv30_fb.c                  |   87 ++
 drivers/gpu/drm/nouveau/nv40_fifo.c                |    8 -
 drivers/gpu/drm/nouveau/nv40_graph.c               |   60 +-
 drivers/gpu/drm/nouveau/nv40_mc.c                  |    2 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c                |   42 +-
 drivers/gpu/drm/nouveau/nv50_dac.c                 |   43 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |  419 +++++---
 drivers/gpu/drm/nouveau/nv50_display.h             |    6 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c                |  126 +--
 drivers/gpu/drm/nouveau/nv50_gpio.c                |   35 +
 drivers/gpu/drm/nouveau/nv50_graph.c               |   86 +-
 drivers/gpu/drm/nouveau/nv50_instmem.c             |   68 +-
 drivers/gpu/drm/nouveau/nv50_sor.c                 |  105 +-
 drivers/gpu/drm/nouveau/nvreg.h                    |   22 -
 drivers/gpu/drm/r128/r128_cce.c                    |   52 +-
 drivers/gpu/drm/r128/r128_drv.c                    |    2 +-
 drivers/gpu/drm/r128/r128_drv.h                    |  122 +--
 drivers/gpu/drm/r128/r128_irq.c                    |    4 +-
 drivers/gpu/drm/r128/r128_state.c                  |  121 +--
 drivers/gpu/drm/radeon/Makefile                    |    1 +
 drivers/gpu/drm/radeon/atom.c                      |    9 +-
 drivers/gpu/drm/radeon/atom.h                      |    2 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |  212 +++--
 drivers/gpu/drm/radeon/atombios_dp.c               |   18 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   22 +-
 drivers/gpu/drm/radeon/evergreen_reg.h             |    5 +
 drivers/gpu/drm/radeon/evergreend.h                |    5 +
 drivers/gpu/drm/radeon/r100.c                      |   55 +-
 drivers/gpu/drm/radeon/r100d.h                     |    2 +
 drivers/gpu/drm/radeon/r300.c                      |   46 +-
 drivers/gpu/drm/radeon/r300d.h                     |    2 +
 drivers/gpu/drm/radeon/r420.c                      |    2 +
 drivers/gpu/drm/radeon/r500_reg.h                  |    5 +
 drivers/gpu/drm/radeon/r520.c                      |    2 +
 drivers/gpu/drm/radeon/r600.c                      |   49 +-
 drivers/gpu/drm/radeon/r600_audio.c                |   22 +-
 drivers/gpu/drm/radeon/r600_blit_shaders.c         | 1115 +++++++-------------
 drivers/gpu/drm/radeon/r600_cs.c                   |  232 ++++-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |    6 +-
 drivers/gpu/drm/radeon/r600d.h                     |   12 +
 drivers/gpu/drm/radeon/radeon.h                    |   53 +-
 drivers/gpu/drm/radeon/radeon_acpi.c               |   67 ++
 drivers/gpu/drm/radeon/radeon_asic.h               |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |   75 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |    2 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |   51 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   48 +-
 drivers/gpu/drm/radeon/radeon_cp.c                 |    8 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   45 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   77 ++-
 drivers/gpu/drm/radeon/radeon_drv.c                |    5 +-
 drivers/gpu/drm/radeon/radeon_encoders.c           |   15 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   37 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |   18 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |   30 +-
 drivers/gpu/drm/radeon/radeon_legacy_tv.c          |    6 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |   18 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   27 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  114 ++-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   20 +-
 drivers/gpu/drm/radeon/reg_srcs/r300               |   13 -
 drivers/gpu/drm/radeon/reg_srcs/r420               |   14 +-
 drivers/gpu/drm/radeon/reg_srcs/rs600              |   13 -
 drivers/gpu/drm/radeon/reg_srcs/rv515              |   13 -
 drivers/gpu/drm/radeon/rs400.c                     |   10 +-
 drivers/gpu/drm/radeon/rs600.c                     |   16 +-
 drivers/gpu/drm/radeon/rs690.c                     |   44 +-
 drivers/gpu/drm/radeon/rv515.c                     |   25 +-
 drivers/gpu/drm/radeon/rv770.c                     |   27 +-
 drivers/gpu/drm/radeon/rv770d.h                    |    6 +
 drivers/gpu/drm/savage/savage_bci.c                |   24 +-
 drivers/gpu/drm/sis/sis_drv.c                      |    3 +-
 drivers/gpu/drm/sis/sis_mm.c                       |   14 +-
 drivers/gpu/drm/ttm/Makefile                       |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   10 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    2 -
 drivers/gpu/drm/ttm/ttm_module.c                   |    4 -
 drivers/gpu/drm/via/via_dma.c                      |  120 +--
 drivers/gpu/drm/via/via_dmablit.c                  |   71 +-
 drivers/gpu/drm/via/via_dmablit.h                  |    8 +-
 drivers/gpu/drm/via/via_drv.h                      |   22 +-
 drivers/gpu/drm/via/via_irq.c                      |   13 +-
 drivers/gpu/drm/via/via_map.c                      |    4 +-
 drivers/gpu/drm/via/via_mm.c                       |    7 +-
 drivers/gpu/drm/via/via_verifier.c                 |   47 +-
 drivers/gpu/drm/via/via_verifier.h                 |    4 +-
 drivers/gpu/drm/via/via_video.c                    |    6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c           |   20 +-
 include/drm/drm.h                                  |    2 +
 include/drm/drmP.h                                 |   62 +-
 include/drm/drm_crtc_helper.h                      |    3 +
 include/drm/drm_global.h                           |   53 +
 include/drm/drm_mm.h                               |   27 +-
 include/drm/drm_mode.h                             |    1 +
 include/drm/drm_pciids.h                           |    7 +
 include/drm/i2c/sil164.h                           |   63 ++
 include/drm/radeon_drm.h                           |    2 +
 include/drm/ttm/ttm_bo_driver.h                    |    7 +-
 include/drm/ttm/ttm_module.h                       |   20 -
 include/linux/io-mapping.h                         |   16 +-
 204 files changed, 6985 insertions(+), 4985 deletions(-)
 rename drivers/gpu/drm/{ttm/ttm_global.c => drm_global.c} (79%)
 create mode 100644 drivers/gpu/drm/drm_platform.c
 create mode 100644 drivers/gpu/drm/drm_trace.h
 create mode 100644 drivers/gpu/drm/drm_trace_points.c
 create mode 100644 drivers/gpu/drm/i2c/sil164_drv.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_grctx.c
 rename drivers/gpu/drm/nouveau/{nv17_gpio.c => nv10_gpio.c} (95%)
 create mode 100644 drivers/gpu/drm/nouveau/nv30_fb.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_acpi.c
 create mode 100644 include/drm/drm_global.h
 create mode 100644 include/drm/i2c/sil164.h
--29444707-558529026-1281005320=:30829--
