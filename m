Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab1GZMDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:03:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38761 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1GZMDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:03:14 -0400
Date: Tue, 26 Jul 2011 13:02:35 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm pull for -rc1
Message-ID: <alpine.DEB.2.00.1107261254260.29862@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-190760463-1311681755=:29862"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-190760463-1311681755=:29862
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Main drm pull request for -rc1, main highlights,

Nouveau: open source fermi ucode, per-client gpu address spaces for nv50 
and up.
Intel: FBC cleanups (on by default now), high color support, ring 
frequency scaling, shared LLC support, and hangcheck module disabling.
radeon: initial compute shader support for evergreen, pageflip changes, 
powerpc/big endian fixes

core: misc changes, nothing major.

(and btw I know Keith has a lot of fixes into next merges, its hard to 
balance the requirement about not merging with the fact his QA team need 
to test merged trees and I want to pull what the QA team has tested).

Dave.

The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:

  Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Alan Cox (1):
      drm/gem: add support for private objects

Alex Deucher (5):
      drm/radeon/kms: set dma_copy to NULL for r6xx+
      drm/radeon/kms: add initial CS checker support for compute
      drm/radeon/kms: add info query for backend map
      drm/radeon/kms: fix i2c map for rv250/280
      drm/radeon/kms: add missing vddci setting on NI+

Ben Skeggs (64):
      drm/gem: add hooks to notify driver when object handle is created/destroyed
      drm/nvc0/fb: allocate page for some unknown PFFB object
      drm/nvc0/fifo: fix typos in unload_context
      drm/nvc0/gr: macro to determine fermi class, will use it in a few places
      drm/nvc0/gr: 0x9197/0x9297 state init
      drm/nvc0/gr: some initial state modifications
      drm/nvc0/gr: enable 0xc8/0xce support, no idea if it works or not..
      drm/nvc1/gr: switch on acceleration support
      drm/nouveau: default to noaccel on 0xc1/0xc8/0xce for now
      drm/nvc0: fix suspend/resume of PGRAPH/PCOPYn
      drm/nvc0/gr: import and use our own fuc by default
      drm/nvc0/gr: add some missing magics for 0xc1/0xc8/0xce
      drm/nvc0/gr: calculate magicgpc918 ourselves
      drm/nvc0/gr: fix typo in class9197 init
      drm/nvc0/gr: fill in some more data for 0xc1/0xc8/0xce
      drm/nouveau: log if accel is disabled by default on a chipset
      drm/nv50: DCB table quirks for another busted XFX board
      drm/nouveau: silence error for missing dac loadval table
      drm/nouveau: allocate structure to store per-client data
      drm/nouveau: use NULL file_priv for DRM-created channels
      drm/nouveau: store a per-client channel list
      drm/nouveau: no need to update bo.offset from vma after validate
      drm/nv50-nvc0/vm: don't touch chan_vm
      drm/nv50-nvc0/vm: take client reference on shared channel vm
      drm/nv50-nvc0/chan: inherit vm from fpriv, rather than chan_vm directly
      drm/nouveau: remove 'chan' argument from nouveau_gem_new
      drm/nouveau/gem: implement stub hooks for GEM object open/close
      drm/nouveau: modify gpuobj/ntfy takedown ordering
      drm/nouveau: initialise any vm for a channel before pushbuf/ntfy
      drm/nouveau: will need to specify channel for vm-ful gpuobj allocations
      drm/nouveau: skip move_notify() if bo does not have a vma attached
      drm/nouveau: store bo's page size in nouveau_bo
      drm/nouveau: create temp vmas for both src and dst of bo moves
      drm/nouveau: convert some bo.offset use to vma.offset
      drm/nouveau: convert bo.mem.start usage to bo.offset
      drm/nv50-nvc0: completely disable relocs
      drm/nouveau: initial changes to support multiple VMAs per buffer object
      drm/nv50-nvc0: explicitly map fbcon fb into channel vm
      drm/nv50-nvc0: explicitly map notifier bo into channel vm
      drm/nv50-nvc0: explicitly map pushbuf bo into channel vm
      drm/nv84-nvc0: explicitly map semaphore buffer into channel vm
      drm/nv50-nvc0: lookup pushbuf virtual address on dma_push
      drm/nvc0: explicitly map PDISP semaphore buffer into each channel's vm
      drm/nouveau: fixup gem_info ioctl to return client-specific bo virtual
      drm/nouveau: remove 'chan' argument from nouveau_bo_new
      drm/nouveau: remove implicit mapping of every bo into chan_vm
      drm/nv50: enable use of per-client gpu address space
      drm/nouveau: add some debug output if nouveau_mm busy at destroy time
      drm/nvc0: enable per-client address spaces
      drm/nouveau: fix display takedown order to match reverse init order
      drm/nouveau: shut lockdep up if last vm ref needs to destroy pgd
      drm/nouveau: rework vram init/fini ordering a little
      drm/nouveau: fix null pointer deref on pre-nv50 chipsets
      drm/nouveau: un-blacklist nvce accel
      drm/nvc0: push prunk140 irq messages to debug loglevel
      drm/nouveau: fix off-by-one
      drm/nouveau: fix fetching vbios from above 4GiB vram addresses
      drm/nv50/dp: fix hack to work for macbooks booted via EFI
      drm/nouveau: ignore connector type when deciding digital/analog on DVI-I
      drm/nouveau: detect disabled device in irq handler and return IRQ_NONE
      drm/nv40/gr: rewrite/split context takedown functions
      drm/nouveau: replace nv04_graph_fifo_access() use with direct reg bashing
      drm/nouveau: pass flag to engine fini() method on suspend
      drm/nouveau/gr: disable fifo access and idle before suspend ctx unload

Ben Widawsky (3):
      drm/i915: hangcheck disable parameter
      drm/i915: add module parameter compiler hints
      drm/i915: provide module parameter description

Benjamin Herrenschmidt (6):
      drm/radeon: Remove a bunch of useless _iomem casts
      drm/radeon: Writeback endian fixes
      drm/radeon: Do an MMIO read on interrupts when not uisng MSIs
      drm/radeon: Fix the definition of RADEON_BUF_SWAP_32BIT
      drm/radeon: ATOM Endian fix for atombios_crtc_program_pll()
      drm/radeon: Add a rmb() in IH processing

Chris Wilson (17):
      drm/i915: Introduce i915_gem_object_finish_gpu()
      drm/i915: Introduce i915_gem_object_finish_gtt()
      drm/i915/gtt: Split out i915_gem_gtt_rebind_object()
      drm/i915: Add an interface to dynamically change the cache level
      drm/i915: Mark the cursor and the overlay as being part of the display planes
      drm/i915: Combine pinning with setting to the display plane
      drm/i915: Only export the generic intel_disable_fbc() interface
      drm/i915: Replace direct calls to vfunc.disable_fbc with intel_disable_fbc()
      drm/i915: Remove vestigial pitch from post-gen2 FBC control routines
      drm/i915: Use of a CPU fence is mandatory to update FBC regions upon CPU writes
      drm/i915: Set persistent-mode for ILK/SNB framebuffer compression
      drm/i915: Disable FBC across page-flipping
      drm/i915: Perform intel_enable_fbc() from a delayed task
      drm/i915: Share the common work of disabling active FBC before updating
      drm/i915/ringbuffer: Idling requires waiting for the ring to be empty
      drm/i915: Cache GT fifo count for SandyBridge
      drm/i915/bios: Avoid temporary allocation whilst searching for downclock

Dan Carpenter (1):
      drm/nouveau: error paths leak in nvc0_graph_construct_context()

Dave Airlie (5):
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next
      Merge branch 'drm-nouveau-next' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next
      Merge 3.0-rc7 into drm-core-next
      Merge branch 'drm-intel-next' of ssh://master.kernel.org/.../keithp/linux-2.6 into drm-core-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next

Emil Velikov (3):
      drm/nouveau/temp: Fix signed/unsigned int logic
      drm/nouveau/temp: Add default calibration values for nv67
      drm/nouveau: Add a quirk for Gigabyte NX86T

Eric Anholt (2):
      drm/i915: Use the uncached domain for the display planes
      drm/i915: Use the LLC mode on gen6 for everything but display.

Hugh Dickins (1):
      drm/i915: more struct_mutex locking

Jerome Glisse (1):
      drm/radeon/kms: fix DP training for DPEncoderService revision bigger than 1.1

Jesper Juhl (1):
      drm/nouveau: do not leak in nv20_graph_create

Jesse Barnes (20):
      cpufreq: expose a cpufreq_quick_get_max routine
      drm/i915: load a ring frequency scaling table v3
      drm/i915: enable ring freq scaling, RC6 and graphics turbo on Ivy Bridge v3
      drm/i915: don't set SDVO color range on ILK+
      drm/i915: don't set transcoder bpc on CougarPoint
      drm/i915: set bpc for DP transcoder
      drm/i915: split out Ironlake pipe bpp picking code
      drm/i915: split out plane update code
      drm/i915: use pipe bpp in DP link bandwidth calculations
      drm/i915: use pipe bpp when setting HDMI bpc
      drm: bpp and depth changes require full mode sets
      drm/i915: check for supported depth at fb init time
      drm/i915: use pipe bpp in DP link bandwidth calculation
      drm/i915/dp: retry link status read 3 times on failure
      drm/i915/dp: use DP DPCD defines when looking at DPCD values
      drm/i915/dp: read more receiver capability bits on hotplug
      drm/i915/dp: try to read receiver capabilities 3 times when detecting
      drm/i915/dp: remove DPMS mode tracking from DP
      drm/i915/dp: consolidate AUX retry code
      drm/i915/dp: manage sink power state if possible

Jon Mason (1):
      DRM: remove drm_pci_device_is_pcie

Keith Packard (18):
      drm/i915: Call intel_enable_plane from i9xx_crtc_mode_set (again)
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: i915_gem_object_finish_gtt must always release gtt mmap
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Enable i915 frame buffer compression by default
      drm/i915: Clean up i915_driver_load failure path
      Revert "drm/i915: enable rc6 by default"
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Select correct pipe during TV detect
      drm/i915: TVDAC_STATE_CHG does not indicate successful load-detect

Kenneth Graunke (1):
      drm/i915: Enable GPU reset on Ivybridge.

Konrad Rzeszutek Wilk (1):
      ttm: Fix spelling mistakes and remove unused #ifdef

Marcin Slusarz (2):
      drm/nouveau: fix nouveau_mem object leak
      drm/nouveau: fix nouveau_vma object leak

Martin Peres (1):
      drm/nvc0: Read temperature on Fermi like we do on nv84+

Matthew Garrett (1):
      i915: Fix opregion notifications

Michel Dänzer (2):
      drm/radeon: Don't generate new fence for page flip.
      drm/radeon: Don't clobber error return value in page flipping cleanup paths.

Ralf Baechle (1):
      DRM: Radeon: Fix section mismatch.

Rob Clark (1):
      drm: platform multi-device support

Rolf Eike Beer (1):
      DRM: clean up and document parsing of video= parameter

Tormod Volden (1):
      drm: really make debug levels match in edid failure code

Younes Manton (1):
      drm/nouveau: Calculate reserved VRAM for PRAMIN value before use.

 Documentation/fb/modedb.txt                 |   21 +-
 drivers/acpi/video.c                        |    7 +-
 drivers/cpufreq/cpufreq.c                   |   20 +
 drivers/gpu/drm/drm_crtc_helper.c           |    5 +
 drivers/gpu/drm/drm_edid.c                  |    4 +-
 drivers/gpu/drm/drm_gem.c                   |   47 ++-
 drivers/gpu/drm/drm_modes.c                 |   87 ++-
 drivers/gpu/drm/drm_platform.c              |    5 +-
 drivers/gpu/drm/i915/i915_debugfs.c         |   41 ++-
 drivers/gpu/drm/i915/i915_dma.c             |   18 +-
 drivers/gpu/drm/i915/i915_drv.c             |   70 ++-
 drivers/gpu/drm/i915/i915_drv.h             |   46 +-
 drivers/gpu/drm/i915/i915_gem.c             |  191 ++++++-
 drivers/gpu/drm/i915/i915_gem_gtt.c         |   39 +-
 drivers/gpu/drm/i915/i915_irq.c             |   13 +-
 drivers/gpu/drm/i915/i915_reg.h             |    6 +-
 drivers/gpu/drm/i915/i915_suspend.c         |    8 +-
 drivers/gpu/drm/i915/intel_bios.c           |  142 +++--
 drivers/gpu/drm/i915/intel_display.c        |  699 ++++++++++++++++------
 drivers/gpu/drm/i915/intel_dp.c             |  135 ++++--
 drivers/gpu/drm/i915/intel_drv.h            |    9 +
 drivers/gpu/drm/i915/intel_hdmi.c           |    8 +-
 drivers/gpu/drm/i915/intel_opregion.c       |   15 +-
 drivers/gpu/drm/i915/intel_overlay.c        |    6 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c     |    6 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h     |    2 +-
 drivers/gpu/drm/i915/intel_tv.c             |   46 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c      |   50 ++-
 drivers/gpu/drm/nouveau/nouveau_bo.c        |  232 ++++----
 drivers/gpu/drm/nouveau/nouveau_channel.c   |  167 +++---
 drivers/gpu/drm/nouveau/nouveau_connector.c |   34 +-
 drivers/gpu/drm/nouveau/nouveau_dma.c       |    7 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c       |   23 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h       |   78 ++-
 drivers/gpu/drm/nouveau/nouveau_fb.h        |    1 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c     |   15 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c     |   31 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c       |  148 ++++--
 drivers/gpu/drm/nouveau/nouveau_irq.c       |    2 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c       |  119 +---
 drivers/gpu/drm/nouveau/nouveau_mm.c        |   11 +-
 drivers/gpu/drm/nouveau/nouveau_mm.h        |    1 +
 drivers/gpu/drm/nouveau/nouveau_notifier.c  |   20 +-
 drivers/gpu/drm/nouveau/nouveau_object.c    |   98 +++-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c     |    4 +-
 drivers/gpu/drm/nouveau/nouveau_state.c     |  114 +++-
 drivers/gpu/drm/nouveau/nouveau_temp.c      |   15 +-
 drivers/gpu/drm/nouveau/nouveau_vm.c        |   21 +-
 drivers/gpu/drm/nouveau/nouveau_vm.h        |    2 +
 drivers/gpu/drm/nouveau/nv04_crtc.c         |    2 +-
 drivers/gpu/drm/nouveau/nv04_graph.c        |   22 +-
 drivers/gpu/drm/nouveau/nv04_instmem.c      |   28 +-
 drivers/gpu/drm/nouveau/nv10_graph.c        |   15 +-
 drivers/gpu/drm/nouveau/nv20_graph.c        |   13 +-
 drivers/gpu/drm/nouveau/nv40_graph.c        |  112 +---
 drivers/gpu/drm/nouveau/nv40_mpeg.c         |    2 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c         |   10 +-
 drivers/gpu/drm/nouveau/nv50_display.c      |    6 +-
 drivers/gpu/drm/nouveau/nv50_evo.c          |   10 +-
 drivers/gpu/drm/nouveau/nv50_fbcon.c        |   10 +-
 drivers/gpu/drm/nouveau/nv50_graph.c        |    9 +-
 drivers/gpu/drm/nouveau/nv50_instmem.c      |    8 +-
 drivers/gpu/drm/nouveau/nv50_mpeg.c         |    2 +-
 drivers/gpu/drm/nouveau/nv50_sor.c          |    2 +
 drivers/gpu/drm/nouveau/nv50_vm.c           |    2 +-
 drivers/gpu/drm/nouveau/nv50_vram.c         |   41 +-
 drivers/gpu/drm/nouveau/nv84_crypt.c        |    2 +-
 drivers/gpu/drm/nouveau/nva3_copy.c         |    2 +-
 drivers/gpu/drm/nouveau/nvc0_copy.c         |    8 +-
 drivers/gpu/drm/nouveau/nvc0_fb.c           |   68 +++-
 drivers/gpu/drm/nouveau/nvc0_fbcon.c        |   14 +-
 drivers/gpu/drm/nouveau/nvc0_fifo.c         |    4 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c        |  270 ++++++---
 drivers/gpu/drm/nouveau/nvc0_graph.fuc      |  400 +++++++++++++
 drivers/gpu/drm/nouveau/nvc0_graph.h        |   24 +-
 drivers/gpu/drm/nouveau/nvc0_grctx.c        |  239 +++-----
 drivers/gpu/drm/nouveau/nvc0_grgpc.fuc      |  474 +++++++++++++++
 drivers/gpu/drm/nouveau/nvc0_grgpc.fuc.h    |  483 +++++++++++++++
 drivers/gpu/drm/nouveau/nvc0_grhub.fuc      |  808 ++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nvc0_grhub.fuc.h    |  838 +++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nvc0_instmem.c      |   14 +-
 drivers/gpu/drm/nouveau/nvc0_vm.c           |    6 +-
 drivers/gpu/drm/nouveau/nvc0_vram.c         |   14 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    5 +-
 drivers/gpu/drm/radeon/atombios_dp.c        |   22 +-
 drivers/gpu/drm/radeon/evergreen.c          |    7 +-
 drivers/gpu/drm/radeon/evergreen_cs.c       |   57 ++-
 drivers/gpu/drm/radeon/evergreend.h         |    2 +
 drivers/gpu/drm/radeon/ni.c                 |    1 +
 drivers/gpu/drm/radeon/r600.c               |   15 +-
 drivers/gpu/drm/radeon/r600_cp.c            |   23 +-
 drivers/gpu/drm/radeon/r600_cs.c            |    9 +
 drivers/gpu/drm/radeon/radeon.h             |   25 +-
 drivers/gpu/drm/radeon/radeon_asic.c        |   14 +-
 drivers/gpu/drm/radeon/radeon_clocks.c      |    4 +-
 drivers/gpu/drm/radeon/radeon_combios.c     |    3 +-
 drivers/gpu/drm/radeon/radeon_cp.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_display.c     |   42 +--
 drivers/gpu/drm/radeon/radeon_drv.c         |    5 +-
 drivers/gpu/drm/radeon/radeon_kms.c         |   15 +-
 drivers/gpu/drm/radeon/radeon_pm.c          |    3 +
 drivers/gpu/drm/radeon/radeon_reg.h         |    2 +-
 drivers/gpu/drm/radeon/reg_srcs/cayman      |    2 +
 drivers/gpu/drm/radeon/reg_srcs/evergreen   |    3 +
 drivers/gpu/drm/radeon/reg_srcs/r600        |    1 +
 drivers/gpu/drm/radeon/rs600.c              |    2 +-
 drivers/gpu/drm/radeon/rv770.c              |    1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c        |   16 +-
 include/acpi/video.h                        |    2 +
 include/drm/drmP.h                          |   11 +-
 include/drm/radeon_drm.h                    |    1 +
 include/drm/ttm/ttm_bo_api.h                |    3 -
 include/drm/ttm/ttm_bo_driver.h             |    6 +-
 include/drm/ttm/ttm_memory.h                |    2 +-
 include/drm/ttm/ttm_object.h                |    4 +-
 include/drm/ttm/ttm_page_alloc.h            |    2 +-
 include/linux/cpufreq.h                     |    5 +
 117 files changed, 5697 insertions(+), 1471 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_graph.fuc
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_grgpc.fuc
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_grgpc.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_grhub.fuc
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_grhub.fuc.h
--29444707-190760463-1311681755=:29862--
