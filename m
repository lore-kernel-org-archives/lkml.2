Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab1CQEKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 00:10:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36175 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1CQEKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 00:10:18 -0400
Date: Thu, 17 Mar 2011 04:09:47 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm next tree
Message-ID: <alpine.DEB.2.00.1103170403160.3429@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

since I see drm named in two other pull threads (staging + bkl) I suppose 
I should send my pull req.

Highlights:
core: drop i830 driver and BKL, add support to drm core to allow USB drm 
drivers, generic unaccelerated buffer create/map fns for simple fbdev 
applications (like plymouth), generic drm capabilities ioctl.
ttm: add support for Xen Dom0
radeon: cayman GPU support (fw is in linux-firmware), r600 tiling + 
predication support
nouveau: pageflipping,  Z compression
i915: big 855 fix, lots of output setup refactoring, lots of misc fixes.

Dave.

The following changes since commit 5359533801e3dd3abca5b7d3d985b0b33fd9fe8b:

  drm/radeon: fix problem with changing active VRAM size. (v2) (2011-03-14 12:51:04 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Alex Deucher (17):
      drm/radeon/kms: add cayman chip family
      drm/radeon/kms: add ucode loader for cayman
      drm/radeon/kms: add gpu_init function for cayman
      drm/radeon/kms: add support for cayman gart setup
      drm/radeon/kms: add support for CP setup on cayman asics
      drm/radeon/kms: add support for cayman irqs
      drm/radeon/kms: add cayman asic reset support
      drm/radeon/kms/cayman: add asic init/startup/fini/suspend/resume functions
      drm/radeon/kms: add cayman safe regs
      drm/radeon/kms: add radeon_asic entry for cayman
      drm/radeon/kms: add cayman CS check support
      drm/radeon/kms: additional default context regs for cayman
      drm/radeon/kms/cayman: always set certain VGT regs at CP init
      drm/radeon/kms: cayman/evergreen cs checker updates
      drm/radeon/kms: add cayman pci ids
      drm/radeon/kms: allow max clock of 340 Mhz on hdmi 1.3+
      drm/radeon/kms: fix typo in atom overscan setup

Alexander Lam (1):
      drm/i915: allow 945 to control self refresh (CxSR) automatically

Arnd Bergmann (2):
      drm: remove i830 driver
      drm/i810: remove the BKL

Ben Skeggs (46):
      drm/ttm: call driver move_notify() when doing system->tt bo moves
      Merge remote-tracking branch 'airlied/drm-core-next' into drm-nouveau-next
      drm/nouveau: move + rename some stuff in nouveau_sgdma.c
      drm/nouveau: introduce new gart type, and name _SGDMA more appropriately
      drm/nv40: implement support for on-chip PCIEGART
      drm/nv40: support for 39-bit dma addresses on native PCIE chipsets
      drm/nv84: switch to new-style semaphores
      drm/nvc0/pfifo: semi-handle a couple more irqs
      drm/nvc0: implement semaphores for inter-channel sync
      drm/nouveau: silence some compiler warnings
      drm/nv50: 0x50 needs semaphore yields too
      drm/nv84: use vm offsets for semaphores
      drm/nv50: drop explicit yields in favour of smaller PFIFO timeslice
      drm/nv50-nvc0: move non-sharable display state into private structure
      drm/nv50-nvc0: rename disp->evo to disp->master
      drm/nv50-nvc0: disp channels have fixed purposes, don't "allocate" them
      drm/nv50-nvc0: fix ramht entries for multiple evo channels
      drm/nv50-nvc0: tidy evo init failure paths
      drm/nv50-nvc0: include nv50_display in evo debugging
      drm/nouveau: make vbios parser runnable from an atomic context
      drm/nv50-nvc0: switch to tasklet for display isr bh
      drm/nv50-nvc0: request and wait on notification of modeset completion
      drm/nv50-nvc0: tidy evo object creation some more
      drm/nv50-nvc0: precalculate some fb state when creating them
      drm/nv50-nvc0: initialise display sync channels
      drm/nv50-nvc0: activate/update ds channel's framebuffer on modesets
      drm/nv50: enable page flipping
      drm/nvc0: support for sw methods + enable page flipping
      drm/nouveau/vbios: parse more gpio tag bits from connector table
      drm/nouveau: remove no_vm/mappable flags from nouveau_bo
      drm/nv50: simplify bo moves now that they're all through the vm
      drm/nouveau: pass domain rather than ttm flags to gem_new()
      drm/nv50-nvc0: restrict memtype to those specified at creation time
      drm/nv50-nvc0: move vm bind/unbind to move_notify hook
      drm/nv50-nvc0: unmap buffers from the vm when they're evicted
      drm/nvc0: allow creation of buffers with any non-compressed memtype
      drm/nouveau: rename nouveau_vram to nouveau_mem
      drm/nv50-nvc0: delay GART binding until move_notify time
      drm/nv50: support for compression
      drm/nv50: flesh out ZCULL init and match nvidia on later chipsets
      drm/core: add ioctl to query device/driver capabilities
      drm/nvc0: remove vm hack forcing large/small pages to not share a PDE
      drm/nouveau: add nouveau_enum_find() util function
      drm/nv50: decode vm faults some more
      drm/nv50: check for vm traps on every gr irq
      drm/nv40: attempt to reserve just enough vram for all 32 channels

Benjamin Franzke (1):
      drm/nouveau: Fix pageflip event

Bryan Freed (2):
      drm/i915: Honour LVDS sync polarity from EDID
      drm/i915/bios: Change default clock source on PineView to use SSC

Chris Wilson (54):
      drm/i915: Use ACPI OpRegion to determine lid status
      drm/i915: Use PM QoS to prevent C-State starvation of gen3 GPU
      drm/i915: Trivial sparse fixes
      drm/i915: Disable SSC for outputs other than LVDS or DP
      drm/i915: Include TLB miss latency in g4x watermark computations
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915/ringbuffer: Kill an annoyingly frequent debug message
      drm/i915: Remove unused code: i915_enable_interrupt()
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Silence a few -Wunused-but-set-variable
      drm/i915: Refactor self-refresh watermark calculations
      drm/i915/sdvo: Use a compact test for determining a multi-function device
      drm/i915/sdvo: Add BUILD_BUG_ON to warn if the structs are ever miscompiled
      drm/i915: Check wedged status before throttling
      drm/i915: Defer reporting EIO until we try to use the GPU
      drm/i915: Record all error ringbuffers
      drm/i915: Trivial spelling mistake 'assertiing'
      drm/i915: Override SDVO panel type in VBT
      drm/i915: Remove unreachable condition
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Enable GMBUS for post-gen2 chipsets
      drm/i915: Include 'i915_error_state' hint for when the GPU catches fire
      drm/i915: Use DEBUG_KMS for the self-refresh watermarks
      drm/i915: Fix infinite loop regression from 21dd3734
      drm/i915: Refine tracepoints
      drm/i915: Skip the no-op domain changes when already in CPU|GTT domains
      drm/i915: i915_mutex_interruptible() returns -EINTR
      drm/i915: Ignore a hung GPU when flushing the framebuffer prior to a switch
      agp/intel: Experiment with a 855GM GWB bit
      drm/i915: Move the lvds OpRegion lid detection code to panel and reuse for eDP
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Revert "drm/i915: Disable SSC for outputs other than LVDS or DP"
      drm/i915: Protect against drm_gem_object not being the first member
      drm/i915: Add a module parameter to ignore lid status
      drm/i915: First try a normal large kmalloc for the temporary exec buffers
      drm/i915: Use a device flag for non-interruptible phases
      drm/i915: Add support for limited color range of broadcast outputs
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm: Mark constant arrays of drm_display_mode const
      drm: Trim the GEM mmap offset hashtab
      drm: Remove unused members from struct drm_open_hash
      drm/i915: Use a symbolic constant for OpRegion lid state
      drm/i915: Silence an innocuous compiler warning for an unused variable
      drm/i915: Allow relocation deltas outside of target bo
      Revert "drm/i915: Use PM QoS to prevent C-State starvation of gen3 GPU"
      drm/i915: Replace vblank PM QoS with "Interrupt-Based AGPBUSY#"
      drm/i915: Re-enable GPU semaphores for SandyBridge mobile
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: don't store the reg value for HWS_PGA
      drm/i915/dp: Sanity check eDP existence
      drm/i915: Only wait on a pending flip if we intend to write to the buffer
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm: Hold the mode mutex whilst probing for sysfs status
      drm: Retry i2c transfer of EDID block after failure

Dan Carpenter (1):
      drm/radeon/r600_cs: off by one errors

Daniel Vetter (11):
      drm/nouveau: don't munge in drm_mm internals
      drm: mm: track free areas implicitly
      drm: mm: extract node insert helper functions
      drm: mm: add api for embedding struct drm_mm_node
      drm: mm: add helper to unwind scan state
      drm/radeon: embed struct drm_gem_object
      drm/radeon: introduce gem_to_radeon_bo helper
      drm/radeon: kill radeon_bo->gobj pointer
      radeon: consolidate asic-specific function decls for r600 & later
      radeon: kill decls for inline functions
      radeon: move blit functions to radeon_asic.h

Dave Airlie (20):
      drm: dumb scanout create/mmap for intel/radeon (v3)
      drm: rework PCI/platform driver interface.
      drm: add usb framework
      drm/radeon: overhaul texture checking. (v3)
      Merge branch 'stable/ttm.pci-api.v5' of git://git.kernel.org/.../konrad/xen into drm-next
      Merge branch 'drm-mm-cleanup' into drm-next
      Revert "ttm: Include the 'struct dev' when using the DMA API."
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      drm/radeon: make sure ib reads are in-order.
      drm/r600: parse the set predication command. (v2)
      drm/radeon: bump version to 2.9
      drm/radeon: fix up dereferencing of busy objects.
      drm/radeon: add new getparam for number of backends.
      Merge remote branch 'korg/drm-radeon-cayman' into drm-core-next
      drm: add cap bit to denote if dumb ioctl is available or not.
      Merge remote branch 'intel/drm-intel-next' of ../drm-next into drm-core-next
      drm/i915: disable opregion lid detection for now.
      Merge remote branch 'nouveau/drm-nouveau-next' of ../drm-nouveau-next into drm-core-next
      Merge commit '5359533801e3dd3abca5b7d3d985b0b33fd9fe8b' into drm-core-next
      drm/radeon: fixup refcounts in radeon dumb create ioctl.

Eric Anholt (1):
      drm/i915: Set the transcoder port to none when disabling DP.

Jesse Barnes (20):
      drm/i915: don't enable plane, pipe and PLL prematurely
      drm/i915: add pipe/plane enable/disable functions
      drm/i915: add panel lock assertion function
      drm/i915: add PLL enable/disable functions
      drm/i915: add PCH DPLL enable/disable functions
      drm/i915: assert panel is unlocked before writing transcoder timing regs
      drm/i915: add transcoder enable/disable functions
      drm/i915: factor out FDI disable and add FDI assertions
      drm/i915: set phase sync pointer override enable before setting phase sync pointer
      drm/i915: skip FDI & PCH enabling for DP_A
      drm/i915: tune Sandy Bridge DRPS constants
      drm/i915: remove now unnecessary delays in eDP panel power sequencing
      drm/i915: use VDD AUX override to make panel power sequencing look better
      drm/i915: don't check plane vs pipe enable on ILK+
      drm/i915: add port assertion check when disabling transcoders
      drm/i915: the PCH reference clocks are global, so don't clobber unconditionally
      drm/i915: cleanup per-pipe reg usage
      drm/i915: disable PCH ports if needed when disabling a CRTC
      drm/i915: don't enable FDI & transcoder interrupts after all
      drm/i915: fix per-pipe reads after "cleanup"

Konrad Rzeszutek Wilk (6):
      ttm: Introduce a placeholder for DMA (bus) addresses.
      ttm: Utilize the DMA API for pages that have TTM_PAGE_FLAG_DMA32 set.
      ttm: Expand (*populate) to support an array of DMA addresses.
      radeon/ttm/PCIe: Use dma_addr if TTM has set it.
      nouveau/ttm/PCIe: Use dma_addr if TTM has set it.
      ttm: Include the 'struct dev' when using the DMA API.

Lucas Stach (1):
      drm/nouveau: use I2C_MODULE_PREFIX kernel define

Marcin Slusarz (4):
      drm/nv50: fix typos in CCACHE error reporting
      drm/nouveau: decode PFIFO DMA_PUSHER error codes
      drm/nouveau: properly handle pushbuffer check failures
      drm/nouveau: fix __nouveau_fence_wait performance

Nicolas Kaiser (1):
      radeon: merge list_del()/list_add_tail() to list_move_tail()

Paul Bolle (1):
      drm: radeon: *_cs_packet_parse_vline() cleanup

Rob Clark (1):
      drm: psuedocolor support for ARGB modes

Tejun Heo (1):
      drm/nouveau: use system_wq instead of dev_priv->wq

Zhenyu Wang (1):
      drm/i915: Don't save/restore hardware status page address register

 drivers/gpu/drm/Kconfig                      |   47 +-
 drivers/gpu/drm/Makefile                     |    3 +-
 drivers/gpu/drm/drm_crtc.c                   |   33 +
 drivers/gpu/drm/drm_drv.c                    |   49 +-
 drivers/gpu/drm/drm_edid.c                   |   59 +-
 drivers/gpu/drm/drm_edid_modes.h             |    4 +-
 drivers/gpu/drm/drm_fb_helper.c              |    5 +
 drivers/gpu/drm/drm_gem.c                    |    5 +-
 drivers/gpu/drm/drm_hashtab.c                |   27 +-
 drivers/gpu/drm/drm_info.c                   |   27 +-
 drivers/gpu/drm/drm_ioctl.c                  |  134 +--
 drivers/gpu/drm/drm_irq.c                    |   14 +-
 drivers/gpu/drm/drm_mm.c                     |  570 +++++----
 drivers/gpu/drm/drm_modes.c                  |    6 +-
 drivers/gpu/drm/drm_pci.c                    |  205 +++-
 drivers/gpu/drm/drm_platform.c               |   75 +-
 drivers/gpu/drm/drm_stub.c                   |   21 +-
 drivers/gpu/drm/drm_sysfs.c                  |    7 +
 drivers/gpu/drm/drm_usb.c                    |  117 ++
 drivers/gpu/drm/i810/i810_dma.c              |   18 +-
 drivers/gpu/drm/i810/i810_drv.c              |   20 +-
 drivers/gpu/drm/i830/Makefile                |    8 -
 drivers/gpu/drm/i830/i830_dma.c              | 1560 ----------------------
 drivers/gpu/drm/i830/i830_drv.c              |  107 --
 drivers/gpu/drm/i830/i830_drv.h              |  295 ----
 drivers/gpu/drm/i830/i830_irq.c              |  186 ---
 drivers/gpu/drm/i915/i915_debugfs.c          |   78 +-
 drivers/gpu/drm/i915/i915_dma.c              |   40 +-
 drivers/gpu/drm/i915/i915_drv.c              |   33 +-
 drivers/gpu/drm/i915/i915_drv.h              |  125 +--
 drivers/gpu/drm/i915/i915_gem.c              |  406 +++---
 drivers/gpu/drm/i915/i915_gem_debug.c        |   45 -
 drivers/gpu/drm/i915/i915_gem_evict.c        |    5 +
 drivers/gpu/drm/i915/i915_gem_execbuffer.c   |  176 +--
 drivers/gpu/drm/i915/i915_gem_tiling.c       |   10 +-
 drivers/gpu/drm/i915/i915_irq.c              |  214 ++--
 drivers/gpu/drm/i915/i915_reg.h              |  484 ++++---
 drivers/gpu/drm/i915/i915_suspend.c          |  435 +++---
 drivers/gpu/drm/i915/i915_trace.h            |  301 +++--
 drivers/gpu/drm/i915/intel_bios.c            |   53 +-
 drivers/gpu/drm/i915/intel_crt.c             |   33 +-
 drivers/gpu/drm/i915/intel_display.c         | 1847 +++++++++++++++++---------
 drivers/gpu/drm/i915/intel_dp.c              |  157 ++-
 drivers/gpu/drm/i915/intel_drv.h             |   13 +-
 drivers/gpu/drm/i915/intel_dvo.c             |    2 +-
 drivers/gpu/drm/i915/intel_hdmi.c            |   13 +
 drivers/gpu/drm/i915/intel_i2c.c             |    3 +-
 drivers/gpu/drm/i915/intel_lvds.c            |   11 +-
 drivers/gpu/drm/i915/intel_modes.c           |   30 +
 drivers/gpu/drm/i915/intel_opregion.c        |    4 +
 drivers/gpu/drm/i915/intel_overlay.c         |   41 +-
 drivers/gpu/drm/i915/intel_panel.c           |   25 +
 drivers/gpu/drm/i915/intel_ringbuffer.c      |   30 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h      |   29 +-
 drivers/gpu/drm/i915/intel_sdvo.c            |   61 +-
 drivers/gpu/drm/i915/intel_tv.c              |   10 +-
 drivers/gpu/drm/mga/mga_dma.c                |    2 +-
 drivers/gpu/drm/mga/mga_drv.c                |   13 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c       |   41 +-
 drivers/gpu/drm/nouveau/nouveau_bios.h       |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c         |  255 ++--
 drivers/gpu/drm/nouveau/nouveau_channel.c    |    5 +-
 drivers/gpu/drm/nouveau/nouveau_display.c    |   75 +-
 drivers/gpu/drm/nouveau/nouveau_dma.c        |   10 +-
 drivers/gpu/drm/nouveau/nouveau_dma.h        |    7 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c         |    2 -
 drivers/gpu/drm/nouveau/nouveau_drv.c        |   21 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h        |   47 +-
 drivers/gpu/drm/nouveau/nouveau_fb.h         |    3 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c      |    4 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c      |  207 ++-
 drivers/gpu/drm/nouveau/nouveau_gem.c        |   50 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c        |  173 ++-
 drivers/gpu/drm/nouveau/nouveau_mm.h         |    6 +-
 drivers/gpu/drm/nouveau/nouveau_notifier.c   |   23 +-
 drivers/gpu/drm/nouveau/nouveau_object.c     |   46 +-
 drivers/gpu/drm/nouveau/nouveau_ramht.c      |    4 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c      |  368 +++++-
 drivers/gpu/drm/nouveau/nouveau_state.c      |   50 +-
 drivers/gpu/drm/nouveau/nouveau_temp.c       |    4 +-
 drivers/gpu/drm/nouveau/nouveau_util.c       |   23 +-
 drivers/gpu/drm/nouveau/nouveau_util.h       |    4 +
 drivers/gpu/drm/nouveau/nouveau_vm.c         |   30 +-
 drivers/gpu/drm/nouveau/nouveau_vm.h         |   19 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c          |    2 +-
 drivers/gpu/drm/nouveau/nv04_fifo.c          |   19 +-
 drivers/gpu/drm/nouveau/nv17_tv.c            |    4 +-
 drivers/gpu/drm/nouveau/nv17_tv.h            |    2 +-
 drivers/gpu/drm/nouveau/nv17_tv_modes.c      |    2 +-
 drivers/gpu/drm/nouveau/nv40_fb.c            |   59 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c          |  164 ++--
 drivers/gpu/drm/nouveau/nv50_cursor.c        |    8 +-
 drivers/gpu/drm/nouveau/nv50_dac.c           |    6 +-
 drivers/gpu/drm/nouveau/nv50_display.c       |  191 +++-
 drivers/gpu/drm/nouveau/nv50_display.h       |   42 +-
 drivers/gpu/drm/nouveau/nv50_evo.c           |  290 +++--
 drivers/gpu/drm/nouveau/nv50_evo.h           |    8 +-
 drivers/gpu/drm/nouveau/nv50_fb.c            |  199 +++-
 drivers/gpu/drm/nouveau/nv50_fifo.c          |    3 +-
 drivers/gpu/drm/nouveau/nv50_gpio.c          |   13 +-
 drivers/gpu/drm/nouveau/nv50_graph.c         |  149 ++-
 drivers/gpu/drm/nouveau/nv50_instmem.c       |    6 +-
 drivers/gpu/drm/nouveau/nv50_sor.c           |    6 +-
 drivers/gpu/drm/nouveau/nv50_vm.c            |   20 +-
 drivers/gpu/drm/nouveau/nv50_vram.c          |   65 +-
 drivers/gpu/drm/nouveau/nv84_crypt.c         |    2 +-
 drivers/gpu/drm/nouveau/nvc0_fifo.c          |   17 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c         |   20 +-
 drivers/gpu/drm/nouveau/nvc0_instmem.c       |    2 +-
 drivers/gpu/drm/nouveau/nvc0_vm.c            |    6 +-
 drivers/gpu/drm/nouveau/nvc0_vram.c          |   62 +-
 drivers/gpu/drm/r128/r128_drv.c              |   14 +-
 drivers/gpu/drm/radeon/Makefile              |    7 +-
 drivers/gpu/drm/radeon/atombios_crtc.c       |   12 +-
 drivers/gpu/drm/radeon/cayman_blit_shaders.c |   55 +
 drivers/gpu/drm/radeon/cayman_blit_shaders.h |   32 +
 drivers/gpu/drm/radeon/evergreen.c           |   16 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c  |    2 +-
 drivers/gpu/drm/radeon/evergreen_cs.c        |  130 ++-
 drivers/gpu/drm/radeon/evergreend.h          |   17 +
 drivers/gpu/drm/radeon/ni.c                  | 1294 ++++++++++++++++++-
 drivers/gpu/drm/radeon/nid.h                 |  495 +++++++
 drivers/gpu/drm/radeon/r100.c                |   16 +-
 drivers/gpu/drm/radeon/r600.c                |   16 +-
 drivers/gpu/drm/radeon/r600_audio.c          |    1 +
 drivers/gpu/drm/radeon/r600_blit_kms.c       |    2 +-
 drivers/gpu/drm/radeon/r600_cs.c             |  425 ++++--
 drivers/gpu/drm/radeon/r600_hdmi.c           |    1 +
 drivers/gpu/drm/radeon/r600d.h               |    5 +
 drivers/gpu/drm/radeon/radeon.h              |  137 +-
 drivers/gpu/drm/radeon/radeon_asic.c         |   49 +
 drivers/gpu/drm/radeon/radeon_asic.h         |   87 ++-
 drivers/gpu/drm/radeon/radeon_benchmark.c    |    4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c   |   11 +-
 drivers/gpu/drm/radeon/radeon_cp.c           |    4 +-
 drivers/gpu/drm/radeon/radeon_cs.c           |    2 +-
 drivers/gpu/drm/radeon/radeon_device.c       |    5 +-
 drivers/gpu/drm/radeon/radeon_display.c      |    4 +-
 drivers/gpu/drm/radeon/radeon_drv.c          |   52 +-
 drivers/gpu/drm/radeon/radeon_family.h       |    1 +
 drivers/gpu/drm/radeon/radeon_fb.c           |   12 +-
 drivers/gpu/drm/radeon/radeon_fence.c        |    6 +-
 drivers/gpu/drm/radeon/radeon_gart.c         |   38 +-
 drivers/gpu/drm/radeon/radeon_gem.c          |   98 +-
 drivers/gpu/drm/radeon/radeon_kms.c          |   22 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c  |    4 +-
 drivers/gpu/drm/radeon/radeon_mode.h         |    1 +
 drivers/gpu/drm/radeon/radeon_object.c       |   30 +-
 drivers/gpu/drm/radeon/radeon_object.h       |    7 +-
 drivers/gpu/drm/radeon/radeon_ring.c         |    4 +-
 drivers/gpu/drm/radeon/radeon_test.c         |    4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c          |   10 +-
 drivers/gpu/drm/radeon/reg_srcs/cayman       |  619 +++++++++
 drivers/gpu/drm/radeon/reg_srcs/evergreen    |    2 +
 drivers/gpu/drm/radeon/rv770.c               |    2 +-
 drivers/gpu/drm/savage/savage_drv.c          |   14 +-
 drivers/gpu/drm/sis/sis_drv.c                |   13 +-
 drivers/gpu/drm/tdfx/tdfx_drv.c              |   13 +-
 drivers/gpu/drm/ttm/ttm_agp_backend.c        |    3 +-
 drivers/gpu/drm/ttm/ttm_bo.c                 |    3 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c         |   34 +-
 drivers/gpu/drm/ttm/ttm_tt.c                 |   12 +-
 drivers/gpu/drm/via/via_drv.c                |   13 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c       |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c          |   23 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c          |    5 +-
 include/drm/Kbuild                           |    1 -
 include/drm/drm.h                            |   13 +
 include/drm/drmP.h                           |  122 +-
 include/drm/drm_crtc.h                       |   13 +-
 include/drm/drm_hashtab.h                    |    6 +-
 include/drm/drm_mm.h                         |   49 +-
 include/drm/drm_mode.h                       |   29 +
 include/drm/drm_pciids.h                     |   14 +
 include/drm/drm_usb.h                        |   15 +
 include/drm/i830_drm.h                       |  342 -----
 include/drm/i915_drm.h                       |    1 +
 include/drm/nouveau_drm.h                    |    1 +
 include/drm/radeon_drm.h                     |    1 +
 include/drm/ttm/ttm_bo_driver.h              |    6 +-
 include/drm/ttm/ttm_page_alloc.h             |    8 +-
 181 files changed, 9261 insertions(+), 6428 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_usb.c
 delete mode 100644 drivers/gpu/drm/i830/Makefile
 delete mode 100644 drivers/gpu/drm/i830/i830_dma.c
 delete mode 100644 drivers/gpu/drm/i830/i830_drv.c
 delete mode 100644 drivers/gpu/drm/i830/i830_drv.h
 delete mode 100644 drivers/gpu/drm/i830/i830_irq.c
 create mode 100644 drivers/gpu/drm/radeon/cayman_blit_shaders.c
 create mode 100644 drivers/gpu/drm/radeon/cayman_blit_shaders.h
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/cayman
 create mode 100644 include/drm/drm_usb.h
 delete mode 100644 include/drm/i830_drm.h
