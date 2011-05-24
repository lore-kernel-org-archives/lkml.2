Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1EXJy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:54:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44237 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1EXJyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:54:54 -0400
Date: Tue, 24 May 2011 10:54:18 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm pull for gardenshed-rc1
Message-ID: <alpine.DEB.2.00.1105241047040.22142@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1420232094-1306230858=:22142"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1420232094-1306230858=:22142
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

core: updates for 30-bit color
intel: Ivybridge support + hopeful rc6 support
nouveau: rewritten engine support for adding PCOPY engine
radeon: Displayport overhaul for pending Llano APU along with more cayman 
and fusion fixes.

There is also a platform/x86 driver for the MXM GPU standard for allowing 
switchable graphics support on nvidia hw, Matthew has acked it coming via 
my tree. Also the VGA ARB is now smarter about devices hiding behind 
bridges.

Dave.

The following changes since commit 0ee5623f9a6e52df90a78bd21179f8ab370e102e:

  Linux 2.6.39-rc6 (2011-05-03 19:59:13 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Alex Deucher (31):
      drm/radeon/kms: remove some underscan leftovers
      drm/radeon/kms: add support for thermal chips on combios asics
      drm/radeon/kms: set i2c adapter class to I2C_CLASS_DDC
      drm/radeon/kms: fix up r1xx-rs4xx i2c buses
      drm/radeon/kms: fix some logic errors in combios i2c mapping
      drm/radeon/kms: DCE4.1 DIG encoders are fully routeable just like DCE3.2
      drm/radeon/kms: properly handle bpc >8 in atom command tables
      drm/radeon/kms: spread spectrum fixes
      drm/radeon/kms: fix up DP clock programming on DCE4/5
      drm/radeon/kms: adjust eDP handling (v2)
      drm/radeon/kms: fix eDP panel power function
      drm/radeon/kms: make sure eDP panel is on for modesetting
      drm/radeon/kms: add some dp encoder/connector helper funcs
      drm/radeon/kms: improve DP detect logic
      drm/radeon/kms: improve aux error handling
      drm/radeon/kms: handle DP bridges
      drm/dp: add some new DP regs for DP 1.2
      drm/radeon/kms: atombios.h updates for DP panel mode
      drm/radeon/kms/atom: add support for setting DP panel mode
      drm/radeon/kms: rewrite DP handling
      drm/radeon/kms: simplify hotplug handler logic
      drm/radeon/kms: bail early for eDP in hotplug callback
      drm/radeon/kms: fixup eDP connector handling
      drm/radeon/kms: properly set the CLK_REF bit for DCE3 devices
      drm/radeon/kms: the SS_Id field in the LCD table if for LVDS only
      drm/radeon/evergreen/btc/fusion: setup hdp to invalidate and flush when asked
      drm/radeon/kms: fix typo in spread spectrum code
      drm/radeon/kms/cayman: fix typo in register mask
      drm/radeon/kms/atom: move dig phy init out of modesetting
      drm/radeon/kms: properly set num banks for fusion asics
      drm/radeon/kms: bump kms version number

Alex Williamson (2):
      vga_switcheroo: Remove unbalanced pci_enable_device
      drm/i915/lvds: Only act on lid notify when the device is on

Andrew Morton (1):
      drivers/gpu/drm/radeon/atom.c: fix warning

Ben Skeggs (43):
      drm/nvc0: more vm fault engines
      drm/nvc0: more vm fault reasons
      drm/nvc0: decode gpc/hubclient on vm fault
      drm/nouveau: use static vidshift of 2 on volt 0x30 tables
      drm/nouveau: move engine object creation into per-engine hooks
      drm/nouveau: remove some unused members from dev_priv
      drm/nouveau: working towards a common way to represent engines
      drm/nv50/gr: move to exec engine interfaces
      drm/nvc0/gr: move to exec engine interfaces
      drm/nv40/gr: move to exec engine interfaces
      drm/nv20-nv30/gr: move to exec engine interface
      drm/nv10/gr: move to exec engine interfaces
      drm/nv04/gr: move to exec engine interfaces
      drm/nouveau: move set_tile_region to nouveau_exec_engine
      drm/nouveau: remove remnants of nouveau_pgraph_engine from nouveau_channel
      drm/nouveau: fix suspend failure path to reinitialise all engines
      drm/nouveau: remove remnants of nouveau_pgraph_engine
      drm/nva3: implement support for copy engine
      drm/nvc0: implement support for copy engines
      drm/nv40/vpe: add support for PMPEG
      drm/nv84: add support for PMPEG
      drm/nv50: rename nv84_mpeg to nv50_mpeg
      drm/nv50: support PMPEG on original nv50
      drm/nvc0/gr: better handling of fuc firmware
      drm/nvc0/fifo: kick channels off during suspend
      drm/nvc0/fifo: restore context table on resume
      drm/nvc0/gr: no need to store context in graph_fini()
      drm/nvc0/fifo: stick user area into a gpuobj rather than a bo
      drm/nv40/gr: oops, fix random bits getting set in engine obj
      drm/nouveau: pull refclk from vbios on limits 0x40 boards
      drm/nva3: somewhat improve clock reporting
      drm/nouveau: fix uninitialised variable warning
      drm/nouveau: recognise DCB connector type 0x41 as LVDS
      drm/nv50: respect LVDS link count from EDID on SPWG panels
      drm/nvc0/gr: calculate some more of our magic numbers
      drm/nva3/pm: initial pass at set_clock() hook
      drm/nva3: support for memory timing map table
      drm/nouveau/pm: remove memtiming support check when assigning to perflvl
      drm/nvc0/pm: correct core/mem/shader perflvl parsing
      drm/nvc0/pm: parse clock for pll 0x0a (0x137020) from perf table
      drm/nva3/pm: allow use of divisor 16
      drm/nouveau/pm: translate ramcfg strap through ram restrict table
      drm/nva3/clk: better pll calculation when no fractional fb div available

Ben Widawsky (10):
      drm/i915: fix ilk rc6 teardown locking
      drm/1915: ringbuffer wait for idle function
      drm/i915: fix rc6 initialization on Ironlake
      drm/i915: debugfs for context information
      drm/i915: proper use of forcewake
      drm/i915: reference counted forcewake
      drm/i915: forcewake struct mutex locking fixes
      drm/i915: move gen6 rps handling to workqueue
      drm/i915: debugfs interface for forcewake reference count
      drm/i915: forcewake debugfs fix

Chris Wilson (19):
      drm: Take lock around probes for drm_fb_helper_hotplug_event
      drm: Export the command-line mode parser
      drm/i915: Release object along create user fb error path
      drm/i915/dp: Be paranoid in case we disable a DP before it is attached
      drm/i915: Only enable the plane after setting the fb base (pre-ILK)
      drm/i915: fix intel_crtc_clock_get pipe reads after "cleanup cleanup"
      drm/i915: Move the irq wait queue initialisation into the ring init
      drm/i915: Simplify return value from intel_get_load_detect_pipe
      drm/i915: Propagate failure to set mode for load-detect pipe
      drm/i915: Don't store temporary load-detect variables in the generic encoder
      drm/i915: Remove unused supported_crtc from intel_load_detect_pipe
      drm/i915: Pass the saved adjusted_mode when adding to the load-detect crtc
      drm/i915: Remove dead code from intel_get_load_detect_pipe()
      drm/i915: Remove dead code from intel_release_load_detect_pipe()
      drm/i915: Attach a fb to the load-detect pipe
      drm/i915: Rename agp_type to cache_level
      drm/i915: Do not clflush snooped objects
      drm/i915: Disable all outputs early, before KMS takeover
      drm/i915/sdvo: Reorder i2c initialisation before ddc proxy

Dave Airlie (16):
      drm/fb: fix CONFIG_DRM=m && CONFIG_FB=n
      platform/x86: add MXM WMI driver.
      nouveau/acpi: hook up to the MXM method for mux switching.
      vgaarb: use bridges to control VGA routing where possible.
      nouveau: add optimus detection to DSM code.
      mxm/wmi: add MXMX interface entry point.
      Merge remote branch 'korg/drm-nvidia-switch-fixes' into drm-core-next
      drm/mxm: fix Kconfig options for when to build MXM WMI driver.
      Merge remote branch 'keithp/drm-intel-next' of /ssd/git/drm-next into drm-core-next
      Merge remote branch 'nouveau/drm-nouveau-next' of /ssd/git/drm-nouveau-next into drm-core-next
      Merge remote branch 'keithp/drm-intel-next' of ../drm-next into drm-core-next
      drm/radeon/cayman: setup hdp to invalidate and flush when asked
      drm/radeon/kms: add wait idle ioctl for eg->cayman
      drm/radeon/kms: fix incorrect comparison in cayman setup code.
      drm/radeon/kms: fix tile_config value reported to userspace on cayman.
      Merge branch 'drm-radeon-next' of /ssd/git/drm-radeon-next into drm-core-next

Emil Velikov (5):
      drm/nouveau: Fix indentation-related checkpatch.pl error messages.
      drm/nouveau: Clean up trailing whitespace and C99-style comments.
      drm/nouveau: Fix brace placement checkpatch.pl errors.
      drm/nouveau: Fix missing whitespace checkpatch.pl errors.
      drm/nv50: improve nv50_pm_get_clock()

Eric Anholt (12):
      drm/i915: Split the crtc_mode_set function along HAS_PCH_SPLIT() lines.
      drm/i915: Move the vblank pre/post modeset to the common crtc_mode_set.
      drm/i915: Remove the PCH paths from the pre-Ironlake crtc_mode_set().
      drm/i915: Drop the eDP paths from the pre-Ironlake crtc_mode_set.
      drm/i915: Drop the remaining bit of Ironlake code from i9xx_crtc_mode_set().
      drm/i915: Drop non-HAS_PCH_SPLIT() code from ironlake_crtc_mode_set().
      drm/i915: Drop remaining pre-Ironlake code from ironlake_crtc_mode_set().
      drm/i915: Clean up leftover DPLL and LVDS register choice from pch split.
      drm/i915: Fold the DPLL limit defines into the structs that use them.
      drm/i915: Use existing function instead of open-coding fence reg clear.
      drm/i915: Add support for fence registers on Ivybridge.
      drm/i915: Update the location of the ringbuffers' HWS_PGA registers for IVB.

Feng, Boqun (2):
      drm/i915: fix user irq miss in BSD ring on g4x
      drm/i915: clean up unused ring_get_irq/ring_put_irq functions

Jesse Barnes (25):
      drm: add bit depth parsing
      drm: parse color format support for digital displays
      drm/i915: use i915_enable_rc6 on SNB too
      drm/i915: make FDI training a display function
      drm/i915: split irq handling into per-chipset functions
      drm/i915: split enable/disable vblank code into chipset specific functions
      drm/i915: add IS_GEN7 macro to cover Ivy Bridge and later
      drm/i915: add IS_IVYBRIDGE macro for checks
      drm/i915: Ivy Bridge has split display and pipe control
      drm/i915: add swizzle/tiling support for Ivy Bridge
      drm/i915: manual FDI training for Ivy Bridge
      drm/i915: treat Ivy Bridge watermarks like Sandy Bridge
      drm/i915: interrupt & vblank support for Ivy Bridge
      drm/i915: page flip support for Ivy Bridge
      drm/i915: ring support for Ivy Bridge
      agp/intel: add Ivy Bridge support
      drm/i915: add PantherPoint PCH ID
      drm/i915: add Ivy Bridge PCI IDs and driver feature structs
      drm/i915: set IBX pch type explicitly
      drm/i915: split clock gating init into per-chipset functions
      drm/i915: add Ivybridge clock gating init function
      drm/i915: split PCH clock gating init
      drm/i915: add fbc enable flag, but disable by default
      drm/i915: enable rc6 by default
      drm/i915: initialize gen6 rps work queue on Sandy Bridge and Ivy Bridge

Jimmy Rentz (2):
      drm/nouveau: Free nv04 instmem ramin heap at card takedown
      drm/nouveau: Fix a crash at card takedown for NV40 and older cards

Joe Perches (2):
      drm: Create and use drm_err
      drm: Verify debug message arguments

Keith Packard (2):
      MAINTAINERS: Switch maintainer for drm/i915 to Keith Packard
      drm/i915: FDI link training broken on Ironlake by Ivybridge integration

Marcin Slusarz (1):
      drm/nouveau: make cursor_set implementation consistent with other drivers

Martin Peres (3):
      drm/nouveau: name the boot perflvl "boot"
      drm/nouveau/pm: fix compilation failure when CONFIG_POWER_SUPPLY is not set
      drm/nouveau: Associate memtimings with performance levels on cards <= nv98

Michel Dänzer (1):
      agp/uninorth: Fix lockups with radeon KMS and >1x.

Randy Dunlap (1):
      drm: fix nouveau_acpi build

Roy Spliet (1):
      drm/nouveau: improve memtiming table parsing

 MAINTAINERS                                 |    4 +-
 drivers/char/agp/intel-agp.c                |    3 +
 drivers/char/agp/intel-agp.h                |    8 +
 drivers/char/agp/intel-gtt.c                |   10 +
 drivers/char/agp/uninorth-agp.c             |    2 +-
 drivers/gpu/drm/drm_edid.c                  |   61 +-
 drivers/gpu/drm/drm_fb_helper.c             |  233 +--
 drivers/gpu/drm/drm_irq.c                   |    9 +-
 drivers/gpu/drm/drm_modes.c                 |  156 ++
 drivers/gpu/drm/drm_stub.c                  |   21 +
 drivers/gpu/drm/i915/i915_debugfs.c         |  131 ++-
 drivers/gpu/drm/i915/i915_dma.c             |   60 +-
 drivers/gpu/drm/i915/i915_drv.c             |   68 +-
 drivers/gpu/drm/i915/i915_drv.h             |  113 +-
 drivers/gpu/drm/i915/i915_gem.c             |   36 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c         |   35 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c      |    2 +-
 drivers/gpu/drm/i915/i915_irq.c             |  311 +++-
 drivers/gpu/drm/i915/i915_reg.h             |   35 +-
 drivers/gpu/drm/i915/i915_suspend.c         |    3 +-
 drivers/gpu/drm/i915/intel_bios.c           |    6 +-
 drivers/gpu/drm/i915/intel_crt.c            |   24 +-
 drivers/gpu/drm/i915/intel_display.c        | 2307 ++++++++++++++++-----------
 drivers/gpu/drm/i915/intel_dp.c             |   17 +-
 drivers/gpu/drm/i915/intel_drv.h            |   19 +-
 drivers/gpu/drm/i915/intel_lvds.c           |    3 +
 drivers/gpu/drm/i915/intel_ringbuffer.c     |   88 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h     |   35 +-
 drivers/gpu/drm/i915/intel_sdvo.c           |   10 +-
 drivers/gpu/drm/i915/intel_tv.c             |   13 +-
 drivers/gpu/drm/nouveau/Kconfig             |    2 +
 drivers/gpu/drm/nouveau/Makefile            |    2 +
 drivers/gpu/drm/nouveau/nouveau_acpi.c      |  108 ++-
 drivers/gpu/drm/nouveau/nouveau_bios.c      |    7 +-
 drivers/gpu/drm/nouveau/nouveau_bios.h      |    1 +
 drivers/gpu/drm/nouveau/nouveau_channel.c   |   20 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c |    8 +-
 drivers/gpu/drm/nouveau/nouveau_display.c   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c       |   25 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h       |  208 +--
 drivers/gpu/drm/nouveau/nouveau_grctx.h     |   10 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c       |   68 +-
 drivers/gpu/drm/nouveau/nouveau_object.c    |  118 +--
 drivers/gpu/drm/nouveau/nouveau_perf.c      |   92 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c        |   21 +-
 drivers/gpu/drm/nouveau/nouveau_reg.h       |   14 +-
 drivers/gpu/drm/nouveau/nouveau_state.c     |  217 ++--
 drivers/gpu/drm/nouveau/nouveau_vm.h        |    3 +-
 drivers/gpu/drm/nouveau/nouveau_volt.c      |   10 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c         |    9 +-
 drivers/gpu/drm/nouveau/nv04_graph.c        |  383 +++--
 drivers/gpu/drm/nouveau/nv04_instmem.c      |    3 +
 drivers/gpu/drm/nouveau/nv10_graph.c        |  212 ++--
 drivers/gpu/drm/nouveau/nv20_graph.c        |  510 +++----
 drivers/gpu/drm/nouveau/nv40_fifo.c         |    2 +
 drivers/gpu/drm/nouveau/nv40_graph.c        |  323 ++--
 drivers/gpu/drm/nouveau/nv40_mpeg.c         |  311 ++++
 drivers/gpu/drm/nouveau/nv50_calc.c         |   68 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c         |   13 +-
 drivers/gpu/drm/nouveau/nv50_display.c      |   18 +-
 drivers/gpu/drm/nouveau/nv50_graph.c        |  442 +++---
 drivers/gpu/drm/nouveau/nv50_grctx.c        |   10 +-
 drivers/gpu/drm/nouveau/nv50_mpeg.c         |  256 +++
 drivers/gpu/drm/nouveau/nv50_pm.c           |   15 +
 drivers/gpu/drm/nouveau/nv50_vm.c           |   12 +-
 drivers/gpu/drm/nouveau/nv84_crypt.c        |  135 ++-
 drivers/gpu/drm/nouveau/nva3_copy.c         |  226 +++
 drivers/gpu/drm/nouveau/nva3_copy.fuc       |  870 ++++++++++
 drivers/gpu/drm/nouveau/nva3_copy.fuc.h     |  534 +++++++
 drivers/gpu/drm/nouveau/nva3_pm.c           |  169 ++-
 drivers/gpu/drm/nouveau/nvc0_copy.c         |  243 +++
 drivers/gpu/drm/nouveau/nvc0_copy.fuc.h     |  527 ++++++
 drivers/gpu/drm/nouveau/nvc0_fifo.c         |  142 ++-
 drivers/gpu/drm/nouveau/nvc0_graph.c        |  600 ++++----
 drivers/gpu/drm/nouveau/nvc0_graph.h        |   29 +-
 drivers/gpu/drm/nouveau/nvc0_grctx.c        |   20 +-
 drivers/gpu/drm/radeon/atom.c               |    4 +-
 drivers/gpu/drm/radeon/atombios.h           |   22 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |  132 +-
 drivers/gpu/drm/radeon/atombios_dp.c        | 1046 +++++++------
 drivers/gpu/drm/radeon/evergreen.c          |   14 +-
 drivers/gpu/drm/radeon/evergreend.h         |    2 +
 drivers/gpu/drm/radeon/ni.c                 |    8 +-
 drivers/gpu/drm/radeon/nid.h                |    4 +-
 drivers/gpu/drm/radeon/radeon_asic.c        |    4 +
 drivers/gpu/drm/radeon/radeon_combios.c     |  117 ++-
 drivers/gpu/drm/radeon/radeon_connectors.c  |  607 +++++---
 drivers/gpu/drm/radeon/radeon_device.c      |    3 +
 drivers/gpu/drm/radeon/radeon_display.c     |   10 +-
 drivers/gpu/drm/radeon/radeon_drv.c         |    3 +-
 drivers/gpu/drm/radeon/radeon_encoders.c    |  252 +++-
 drivers/gpu/drm/radeon/radeon_i2c.c         |    2 +
 drivers/gpu/drm/radeon/radeon_mode.h        |   19 +-
 drivers/gpu/vga/vga_switcheroo.c            |    6 -
 drivers/gpu/vga/vgaarb.c                    |  113 ++-
 drivers/pci/pci.c                           |   25 +-
 drivers/platform/x86/Kconfig                |    7 +
 drivers/platform/x86/Makefile               |    1 +
 drivers/platform/x86/mxm-wmi.c              |  111 ++
 include/drm/drmP.h                          |   49 +-
 include/drm/drm_crtc.h                      |    6 +-
 include/drm/drm_dp_helper.h                 |    5 +
 include/drm/drm_edid.h                      |   25 +-
 include/drm/drm_fb_helper.h                 |   18 +-
 include/linux/mxm-wmi.h                     |   33 +
 include/linux/pci.h                         |    7 +-
 106 files changed, 9440 insertions(+), 4056 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/nv40_mpeg.c
 create mode 100644 drivers/gpu/drm/nouveau/nv50_mpeg.c
 create mode 100644 drivers/gpu/drm/nouveau/nva3_copy.c
 create mode 100644 drivers/gpu/drm/nouveau/nva3_copy.fuc
 create mode 100644 drivers/gpu/drm/nouveau/nva3_copy.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_copy.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_copy.fuc.h
 create mode 100644 drivers/platform/x86/mxm-wmi.c
 create mode 100644 include/linux/mxm-wmi.h
--29444707-1420232094-1306230858=:22142--
