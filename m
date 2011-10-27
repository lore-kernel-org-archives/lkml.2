Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab1J0TJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 15:09:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35550 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1J0TJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 15:09:19 -0400
Date: Thu, 27 Oct 2011 20:09:49 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm rc1 tree
Message-ID: <alpine.DEB.2.00.1110271959350.21460@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1207823296-1319742589=:21460"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1207823296-1319742589=:21460
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

this is the main pull request for the drm tree, I've got some more stuff 
coming but it all looks like -fixes stuff so no reason to hold this up 
which I had ready pre-ks except for some reverts off a radeon/ttm feature 
that wasn't what we wanted yet.

Highlights:
Samsung: exynos SoC modesetting driver (no accel support/interfaces).
vmwgfx: driver moves out of staging and has supportable ABI.
nouveau: displayport rewrite and 0xd9 gpu modesetting code
radeon: general fixes + blit speedups
intel: Apple Macbook Air fixes, RHEL stabilisation fixes.

Also a whole bunch of deinlining of insane stuff from Andi, 

This tree also contains some cross-over with dwmw2 on iommu fixes, as we
weren't sure what the merge plan was for them, but they shouldn't 
conflict, and had to be in this tree just to let me test them usefully.

/me goes back to looking for replacement cars :)

Dave.

The following changes since commit 899e3ee404961a90b828ad527573aaaac39f0ab1:

  Linux 3.1-rc10 (2011-10-17 21:06:23 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux.git drm-core-next

Adam Jackson (9):
      drm: Add KMS debug printk's for encoder and crtc fixup failure
      drm/i915: Remove "i2c_speed" nonsense from child device table
      drm/i915: Fix multifunction SDVO detection
      drm/i915: Rename intel_sdvo_hdmi_sink_detect
      drm/i915: Remove redundant bit shifting from intel_gmbus_set_speed
      drm/i915/dp: Fix the math in intel_dp_link_required
      drm/i915/dp: Remove eDP special cases from bandwidth checks
      drm/i915/dp: Introduce is_cpu_edp()
      drm/i915/dp: Fix eDP on PCH DP on CPT/PPT

Akshay Joshi (1):
      Drivers: i915: Fix all space related issues.

Alex Deucher (5):
      drm/radeon/kms: bail early in dvi_detect for digital only connectors
      drm/radeon/kms: handle !force case in connector detect more gracefully
      drm/radeon/kms: set DMA mask properly on newer PCI asics
      drm/radeon/kms: simplify r6xx blit code
      drm/radeon/kms: make r600-NI blit suspend code common

Andi Kleen (7):
      drm/radeon: Drop inlines from evergreen_cs.c / r600_cs.c
      drm/radeon: drop inlines in r600_blit.c
      drm/radeon: Remove now unused functions in radeon driver
      drm/radeon: Remove more bogus inlines in the radeon driver.
      drm/radeon: Move more code out of line
      drm/radeon: Move r100_*_*reg out of line
      i915: Move i915_read/write out of line

Ben Skeggs (105):
      drm/nouveau/pm: store voltage in microvolts
      drm/nouveau/pm: initial attempt at parsing volt 0x40
      drm/nouveau/pm: add yet another vid gpio tag
      drm/nouveau/pm: add support for parsing perflvl voltage on fermi chips
      drm/nouveau/pm: show any info we can manage to glean on current perflvl
      drm/nvc0/pm: enable voltage_get
      drm/nouveau/pm: allow voltage-only perflvl set, enable nvc0
      drm/nouveau/pm: some fermi chipsets still use volt 0x30
      drm/nva3/pm: rewrite clock readback functions, far more correct now
      drm/nouveau/pm: add hooks to get/set *all* clocks at once
      drm/nva3/pm: rewrite clock_set, and switch to new interfaces
      drm/nva3/pm: parse/reclock vdec/41a0 clocks
      drm/nva3/pm: tidy and add some comments here and there
      drm/nv50/gr: insert set/clr of a ctxprog flag at start/end of ctxprog
      drm/nouveau: add function to wait until a callback returns true
      drm/nva3/pm: idle graphics engine before changing clocks
      drm/nvc0/pm: initial implementation of clocks_get()
      drm/nvc0/pm: more complete parsing of clock domains
      drm/nouveau: rename nv40_mpeg to nv31_mpeg
      drm/nv31/mpeg: support for a single class3174 user
      drm/nouveau: embed nouveau_mm
      drm/nouveau: allow a nouveau_mm to be created with holes
      drm/nvc0/gr: add support for nvcf chipset
      drm/nvc0/vram: support non-uniform memory size per controller
      drm/nvc0/gr: copy GPC mpart config from PFFB
      drm/nouveau: don't complain for disabled timingset entries
      drm/nvc0/gr: unblacklist nvcf acceleration
      drm/nouveau/tmr: calibrate for ns timestamps on init
      drm/nvd0: add a card_type for 0xdX chipsets
      drm/nouveau: make general drm modesetting init common
      drm/nouveau: fixup init/fini sequence to deal with no CRTCs
      drm/nouveau: allow modeset module option to select 'headless mode'
      drm/nouveau: initial chipset description for nvdX chipsets
      drm/nvd0/i2c: initial implementation
      drm/nvd0/gpio: initial implementation
      drm/nouveau/bios: fix INIT_GPIO for new chipsets
      drm/nvd0/pm: enable clock/voltage hooks
      drm/nouveau/bios: allow passing in crtc to the init table parser
      drm/nvd0/disp: very initial evo setup
      drm/nvd0/disp: whip up some basic dma handling for the evo channels
      drm/nvd0/disp: start on interrupt handling
      drm/nvd0/disp: setup a couple of dma objects we'll need
      drm/nvd0/disp: start on SOR encoder functions
      drm/nvd0/disp: skeletal handling of modeset interrupts
      drm/nvd0/disp: initial crtc object implementation
      drm/nvd0/disp: they moved the linear flag..
      drm/nvd0/disp: some magic to make evo happeir
      drm/nvd0/disp: remove lp reordering from vram dmaobj, create fb dmaobjs
      drm/nvd0/disp: extend the init voodoo to cover crtcs
      drm/nvd0/disp: dac encoder module
      drm/nvd0/disp: stub dac load detect, prevents oops
      drm/nvd0/disp: initial attempt at modeset irq handling
      drm/nvd0/disp: fixup clut so it actually works
      drm/nvd0/disp: push the update button in mode_set_base()
      drm/nvd0/disp: scaling
      drm/nvd0/disp: handle sync polarity, kill off some unknown
      drm/nvd0/disp: dac load detect
      drm/nvd0/disp: determine U table config in or_mode_set()
      drm/nvd0/disp: track down fb positioning method
      drm/nvd0/disp: untested LVDS support
      drm/nvd0/disp: do modeset irq handling from tasklet
      drm/nvd0/disp: rewrite irq handler, should be somewhat sturdier now
      drm/nvd0/disp: tidy up what we have so far
      drm/nvd0: lets not attempt to dereference a nv50_display pointer
      drm/nvc0/gr: remove max tpc count info
      drm/nvd0: no page flipping at the moment
      drm/nouveau: remove special-casing of hotplug detection type
      drm/nouveau: magic to make auxch on new macbooks booted in EFI mode work
      drm/nva3/pm: pll disabled if bit 0 of ctrl not set
      drm/nouveau: determine timing crystal freq from straps
      drm/nva3/pm: use crystal freq where appropriate
      drm/nva3/pm: fixup for NVAF special
      drm/nouveau/tmr: fix miscalculation of ratio on pre-nv4x chipsets
      drm/nouveau: workaround semaphore hw bug causing unnecessary interrupts
      drm/nouveau/dp: rewrite auxch transaction routines
      drm/nouveau/dp: remove reliance on vbios for native displayport
      drm/nouveau: tidy connector hotplug handler, punt messages to debug
      drm/nouveau/backlight: make more consistent with rest of driver style
      drm/nv50/backlight: take the sor into account when bashing regs
      drm/nv50/backlight: express brightness level in percent
      drm/nva3/backlight: add suppport for newer style backlight regs
      drm/nouveau/bios: check for null script pointers in parser
      drm/nouveau/dp: pass in required datarate to link training
      drm/nouveau/dp: restructure link training code
      drm/nouveau/dp: store unencoded link_bw everywhere
      drm/nouveau/dp: execute some more vbios tables relating to link rate
      drm/nouveau/dp: enable down-spread if vbios and sink support it
      drm/nv40/pm: parse geometric delta clock from vbios
      drm/nv40/pm: write nv40-specific reclocking routines
      drm/nouveau/dp: link rate scripts are selected with a comparison table
      drm/nouveau/dp: use alternate lane mask for nvaf
      drm/nvc0/gr: remove MODULE_FIRMWARE() lines
      drm/nouveau/dp: preserve non-pattern bits in DP_TRAINING_PATTERN_SET
      drm/nouveau/bios: simplify U/d table hash matching func to just match
      drm/nouveau/dp: return master dp table pointer too when looking up encoder
      drm/nouveau/dp: add support for displayport table 0x30
      drm/nouveau: if requested, try harder at disabling sysmem pushbufs
      drm/nv50/gr: refactor initialisation
      drm/nv40/pm: execute memory reset script from vbios
      drm/nvc0/pm: minor clock readback fixes
      drm/nvd9/disp: stub some more api hooks so we don't oops on resume
      drm/nvd9/disp: bail out of mode_set_base if no fb bound to crtc
      drm/nvc0/fifo: avoid touching missing subfifos
      drm/nvc0/fb: slightly improve PMFB intr handling, move out of nvc0_graph.c
      drm/nouveau: remove allocations from gart populate() hook

Ben Widawsky (4):
      drm/i915: Dumb down the semaphore logic
      drm/i915: Remove early exit on i915_gpu_idle
      drm/i915: ILK + VT-d workaround
      drm: Add Panel Self Refresh DP addresses

Chris Wilson (1):
      drm/i915: Defend against userspace creating a gem object with size==0

Dan Carpenter (3):
      vmwgfx: return -EFAULT instead of number of bytes remaining
      vmwgfx: memory leaks caused by double allocation
      vmwgfx: information leak in vmw_execbuf_copy_fence_user()

Daniel Vetter (7):
      drm/i915: close PM interrupt masking races in the irq handler
      drm/i915: close PM interrupt masking races in the rps work func
      drm/i915: properly cancel rps_work on module unload v2
      drm/i915: fix swizzling on gen6+
      drm/i915: simplify swapin/out swizzle checking a bit
      io-mapping: ensure io_mapping_map_atomic _is_ atomic
      drm/i915: drop KM_USER0 argument to k(un)map_atomic

Dave Airlie (8):
      Merge branch 'drm-nouveau-next' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-intel-next' of git://people.freedesktop.org/~keithp/linux into drm-next
      Merge branch 'drm-vmware-next' into drm-core-next
      Merge branch 'drm-intel-next' of git://people.freedesktop.org/~keithp/linux into drm-core-next
      Merge tag 'v3.1-rc10' into drm-core-next
      Merge branch 'drm-intel-next' of git://people.freedesktop.org/~keithp/linux into drm-core-next
      Revert "drm/radeon/kms: add a new gem_wait ioctl with read/write flags"
      Revert "drm/ttm: add a way to bo_wait for either the last read or last write"

Dave Jones (1):
      drm/radeon: Lower the severity of the radeon lockup messages.

David Woodhouse (2):
      intel-iommu: Workaround IOTLB hang on Ironlake GPU
      intel-iommu: Export a flag indicating that the IOMMU is used for iGFX.

Ilija Hadzic (10):
      drm/radeon: allow pcie gen2 speed on NI
      drm/radeon: allow pcie gen2 speed on Cayman
      drm/radeon/kms: simplify evergreen blit code
      drm/radeon/kms: demystify evergreen blit code
      drm/radeon/kms: demystify r600 blit code
      drm/radeon/kms: cleanup benchmark code
      drm/radeon/kms: add more elaborate benchmarks
      drm/radeon/kms: cleanup r600 blit code
      drm/radeon/kms: rename a variable for consistency
      drm/radeon/kms: blit code commoning

Inki Dae (8):
      DRM: add DRM Driver for Samsung SoC EXYNOS4210.
      drm/exynos: fixed overlay data updating.
      drm/exynos: fixed overlay updating time at page flip.
      drm/exynos: added device object as argument of subdrv_probe().
      drm/exynos: fixed bug to exynos_drm_fb_dev_reinit().
      drm/exynos: added comments and code clean.
      drm/exynos: fixed page flip bug.
      drm/exynos: fixed build warnings and comments.

Jakob Bornecrantz (21):
      vmwgfx: Update register files to latest from vmware-sdk
      vmwgfx: Document vmw_fifo_reserve
      vmwgfx: Add comments for buffer pinning code
      vmwgfx: Make sure the reserved area is at the start of vram
      vmwgfx: Some comments and BUG_ON
      vmwgfx: Break out dirty submission code
      vmwgfx: Expand the command checker to cover screen object commands
      vmwgfx: Refactor common display unit functions to shared file
      vmwgfx: Add dmabuf helper functions for pinning
      vmwgfx: Add screen object support
      vmwgfx: Drop 3D Legacy Display Unit support
      vmwgfx: Place overlays in GMR area if we can
      vmwgfx: Add present and readback ioctls
      vmwgfx: Disallow user space to send present and readback commands
      vmwgfx: Be more strict with fb depths when using screen objects
      vmwgfx: Don't use virtual coords when using screen objects
      vmwgfx: Fix display system init & close functions
      vmwgfx: Whitespace & code style in display unit
      vmwgfx: Add vblank stubs
      vmwgfx: Emulate depth 32 framebuffers
      vmwgfx: Don't pass unused arguments to do_dirty functions

Jean Delvare (2):
      drm/radeon/kms: Fix I2C mask definitions
      drm/radeon/kms: Simplify I2C post_xfer function

Jesse Barnes (19):
      drm/i915: Use PIPE_CONTROL for flushing on gen6+.
      drm/i915: always set FDI composite sync bit
      drm/i915: PLL macro cleanup and pipe assertion check
      drm/i915: support 3 pipes on IVB+
      drm/i915: split refclk code out of ironlake_crtc_mode_set
      drm/i915: use transcoder select bits on VGA and HDMI on CPT
      drm/i915: fix PCH PLL assertion check for 3 pipes
      drm/i915: add PLL sharing support to handle 3 pipes
      drm/i915: fix debug output for 3 pipe configs
      drm/i915: fix IVB cursor support
      drm/i915: fix transcoder PLL select masking
      drm/i915: export a CPT mode set verification function
      drm/i915: set watermarks for third pipe on IVB
      drm/i915: if transcoder disable fails, say which
      drm/i915: remove transcoder PLL mashing from mode_set per specs
      drm/i915: read full receiver capability field during DP hot plug
      drm/i915: add DP test request handling
      drm/i915: fix ILK+ infoframe support
      drm/i915: use correct SPD type value

Keith Packard (33):
      drm/i915: Enable dither whenever display bpc < frame buffer bpc
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: broken copyright encoding in intel_bios.c
      drm/i915: Use DRM_DEBUG_KMS for all messages in intel_bios.c
      drv/i915: Pull display_clock_mode out of VBT table
      drm/i915: Document a few more BDB_GENERAL_FEATURES bits from PCH BIOS
      drm/i915: Allow SSC parameter to override VBT value
      drm/i915: Fix PCH SSC reference clock settings
      drm/i915: Use CK505 as non-SSC source where available
      drm/i915: All PCH refclks are 120MHz
      drm/i915: Initialize PCH refclks at modeset init time
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Enable digital port hotplug on PCH systems
      drm/i915: Shut down PCH interrupts during irq_uninstall
      drm/i915: Only use VBT panel mode on eDP if no EDID is found
      drm/i915: Check eDP power when doing aux channel communications
      drm/i915: Unlock PCH_PP_CONTROL always
      drm/i915: Check for eDP inside edp panel on/off funcs
      drm/i915: Turn force VDD back off when panel running in intel_dp_dpms
      drm/i915: Ensure panel is on during DPMS off
      drm/i915: Delay DP i2c initialization until panel power timings are computed
      drm/i915: Wrap DP EDID fetch functions to enable eDP panel power
      drm/i915: Enable eDP panel power during I2C initialization sequence
      drm/i915: Ensure eDP powered up during DP_SET_POWER operation in dp_prepare
      drm/i915: Correct eDP panel power sequencing delay computations
      drm/i915: Move eDP panel fixed mode from dev_priv to intel_dp
      drm/i915: edp_panel_on does not need to return a bool
      drm/i915: Create helper functions to determine eDP power state
      drm/i915: Disable eDP VDD in a delayed work proc instead of synchronously
      drm/i915: Restrict ILK-specific eDP power hack to ILK
      drm/i915: No need to wait for eDP power off delay if panel is on
      Merge branch 'edp-training-fixes' into drm-intel-next
      Merge branch 'fix-pch-refclk' into foo

Ken Milmore (1):
      drm/nouveau: enable hwmon support when both nouveau/hwmon are built as modules.

Kenneth Graunke (2):
      drm/i915: Remove implied length of 2 from GFX_OP_PIPE_CONTROL #define.
      drm/i915: Rename PIPE_CONTROL bit defines to be less terse.

Marcin Slusarz (3):
      drm/nouveau: fix printk typo in ioremap failure path
      drm: fix error message about failed procfs file registration
      drm: simplify error printing in drm_debugfs_create_files

Marek Ol¨ák (2):
      drm/ttm: add a way to bo_wait for either the last read or last write
      drm/radeon/kms: add a new gem_wait ioctl with read/write flags

Martin Peres (2):
      drm/nv04/pm: recalibrate timer on nvclk changes
      drm/nv50/gr: enable ctxprog xfer only when we need it to save power

Michael Witten (1):
      DRM: bug: RADEON_DEBUGFS_MAX_{NUM_FILES => COMPONENTS}

Michel Dänzer (4):
      vmwgfx: Add support for depth 8
      vmwgfx: Don't write to read-only registers
      vmwgfx: Fix 'bbp' typo
      vmwgfx: Print error diagnostics if depth doesn't match the host expectation

Rob Clark (3):
      drm/gem: add functions for mmap offset creation
      drm/i915: use common functions for mmap offset creation
      drm: drm_ioctl() should zero-init extra data

Roy Spliet (2):
      drm/nouveau/pm: add initial NV3x/NVCx memtiming support, improve other cards
      drm/nouveau/pm: Document and expose CL and WR for 0x1002Cx

Takashi Iwai (1):
      drm/i915/panel: Always record the backlight level again (but cleverly)

Thomas Hellstrom (30):
      vmwgfx: Let SVGA_REG_NUM_DISPLAYS determine output connectivity
      vmwgfx: Fix potential execbuf deadlocks
      vmwgfx: Switch to VGA when we drop master and vmwgfx fbdev is not active
      vmwgfx: Restrict number of GMR pages to device limit
      vmwgfx: Update register definitions for HWV8 and print out new capabilities
      vmwgfx: Implement GMR2
      vmwgfx: Remove the fifo debug ioctl
      vmwgfx: Remove the update layout IOCTL.
      vmwgfx: Remove the possibility to map the fifo from user-space
      vmwgfx: Add functionality to get 3D caps
      vmwgfx: Fix confusion caused by using "fence" in various places
      vmwgfx: Make vmw_wait_seqno a bit more readable
      vmwgfx: Implement fence objects
      vmwgfx: Bump major
      ttm: export ttm_bo_create
      vmwgfx: Break out execbuf command processing
      vmwgfx: Require HWV8 for 3d support
      vmwgfx: minor dmabuf utilities cleanup
      vmwgfx: Allow reference and unreference of NULL fence objects.
      vmwgfx: Fix up query processing
      vmwgfx: Optimize the command submission resource list
      vmwgfx: Make sure we always have a user-space handle to use for objects that are backing kms framebuffers.
      vmwgfx: Handle device surface memory limit
      vmwgfx: Bump driver minor to advertise support for new ioctls.
      vmwgfx: Minor cleanups
      vmwgfx: Implement memory accounting for resources
      vmwgfx: Break out and comment vmw_execbuf_copy_fence_user
      vmwgfx: Add fence events
      vmwgfx: Wrap drm_read and drm_poll
      vmwgfx: Take the driver out of staging

Tormod Volden (1):
      drm/radeon: Print gart initialization details on all chipsets

Wu Fengguang (2):
      drm: support routines for HDMI/DP ELD
      drm/i915: pass ELD to HDMI/DP audio driver

 drivers/char/agp/intel-gtt.c                       |   28 +
 drivers/gpu/drm/Kconfig                            |    4 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/drm_crtc_helper.c                  |    2 +
 drivers/gpu/drm/drm_debugfs.c                      |    5 +-
 drivers/gpu/drm/drm_drv.c                          |    2 +
 drivers/gpu/drm/drm_edid.c                         |  171 +++
 drivers/gpu/drm/drm_gem.c                          |   88 ++
 drivers/gpu/drm/drm_proc.c                         |    3 +-
 drivers/gpu/drm/exynos/Kconfig                     |   20 +
 drivers/gpu/drm/exynos/Makefile                    |   11 +
 drivers/gpu/drm/exynos/exynos_drm_buf.c            |  110 ++
 drivers/gpu/drm/exynos/exynos_drm_buf.h            |   53 +
 drivers/gpu/drm/exynos/exynos_drm_connector.c      |  293 ++++
 drivers/gpu/drm/exynos/exynos_drm_connector.h      |   34 +
 drivers/gpu/drm/exynos/exynos_drm_core.c           |  272 ++++
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |  381 +++++
 drivers/gpu/drm/exynos/exynos_drm_crtc.h           |   38 +
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  244 ++++
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |  254 ++++
 drivers/gpu/drm/exynos/exynos_drm_encoder.c        |  271 ++++
 drivers/gpu/drm/exynos/exynos_drm_encoder.h        |   45 +
 drivers/gpu/drm/exynos/exynos_drm_fb.c             |  265 ++++
 drivers/gpu/drm/exynos/exynos_drm_fb.h             |   37 +
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |  456 ++++++
 drivers/gpu/drm/exynos/exynos_drm_fbdev.h          |   37 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  811 +++++++++++
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |  415 ++++++
 drivers/gpu/drm/exynos/exynos_drm_gem.h            |  107 ++
 drivers/gpu/drm/i915/dvo_ch7017.c                  |    2 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |    4 +-
 drivers/gpu/drm/i915/dvo_ivch.c                    |    6 +-
 drivers/gpu/drm/i915/dvo_sil164.c                  |    2 +-
 drivers/gpu/drm/i915/dvo_tfp410.c                  |   14 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   38 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   48 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   63 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  103 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  113 +--
 drivers/gpu/drm/i915/i915_gem_debug.c              |    8 +-
 drivers/gpu/drm/i915/i915_gem_evict.c              |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |    3 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   30 +
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   15 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   42 +-
 drivers/gpu/drm/i915/i915_mem.c                    |   14 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  111 ++-
 drivers/gpu/drm/i915/i915_suspend.c                |    8 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   46 +-
 drivers/gpu/drm/i915/intel_acpi.c                  |    2 +-
 drivers/gpu/drm/i915/intel_bios.c                  |   23 +-
 drivers/gpu/drm/i915/intel_bios.h                  |   22 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   20 +-
 drivers/gpu/drm/i915/intel_display.c               |  762 +++++++---
 drivers/gpu/drm/i915/intel_dp.c                    |  614 ++++++---
 drivers/gpu/drm/i915/intel_drv.h                   |   21 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |   33 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |    8 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |    8 +-
 drivers/gpu/drm/i915/intel_modes.c                 |    2 +
 drivers/gpu/drm/i915/intel_opregion.c              |   90 +-
 drivers/gpu/drm/i915/intel_overlay.c               |  146 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   27 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  369 ++++--
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   16 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  249 ++--
 drivers/gpu/drm/i915/intel_sdvo_regs.h             |  558 ++++----
 drivers/gpu/drm/i915/intel_tv.c                    |   58 +-
 drivers/gpu/drm/nouveau/Makefile                   |    9 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |  169 ++-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |  275 ++--
 drivers/gpu/drm/nouveau/nouveau_bios.h             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    2 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c          |   16 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   52 +-
 drivers/gpu/drm/nouveau/nouveau_crtc.h             |    3 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |    9 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |  963 +++++++------
 drivers/gpu/drm/nouveau/nouveau_drv.c              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |  123 ++-
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |   27 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.c              |   56 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c              |  284 ++--
 drivers/gpu/drm/nouveau/nouveau_mm.c               |   89 +-
 drivers/gpu/drm/nouveau/nouveau_mm.h               |    5 +-
 drivers/gpu/drm/nouveau/nouveau_object.c           |   18 +-
 drivers/gpu/drm/nouveau/nouveau_perf.c             |  118 ++-
 drivers/gpu/drm/nouveau/nouveau_pm.c               |  100 +-
 drivers/gpu/drm/nouveau/nouveau_pm.h               |   15 +-
 drivers/gpu/drm/nouveau/nouveau_reg.h              |   11 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |   66 +-
 drivers/gpu/drm/nouveau/nouveau_state.c            |  210 +++-
 drivers/gpu/drm/nouveau/nouveau_vm.c               |   40 +-
 drivers/gpu/drm/nouveau/nouveau_vm.h               |    2 +-
 drivers/gpu/drm/nouveau/nouveau_volt.c             |   46 +-
 drivers/gpu/drm/nouveau/nv04_display.c             |   23 -
 drivers/gpu/drm/nouveau/nv04_pm.c                  |    4 +
 drivers/gpu/drm/nouveau/nv04_timer.c               |   84 +-
 .../gpu/drm/nouveau/{nv40_mpeg.c => nv31_mpeg.c}   |   91 +-
 drivers/gpu/drm/nouveau/nv40_pm.c                  |  338 +++++
 drivers/gpu/drm/nouveau/nv50_crtc.c                |    2 -
 drivers/gpu/drm/nouveau/nv50_cursor.c              |   18 -
 drivers/gpu/drm/nouveau/nv50_display.c             |   76 +-
 drivers/gpu/drm/nouveau/nv50_gpio.c                |   31 +
 drivers/gpu/drm/nouveau/nv50_graph.c               |  118 +--
 drivers/gpu/drm/nouveau/nv50_grctx.c               |   11 +
 drivers/gpu/drm/nouveau/nv50_pm.c                  |    8 +-
 drivers/gpu/drm/nouveau/nv50_sor.c                 |   42 +-
 drivers/gpu/drm/nouveau/nv50_vram.c                |    4 +-
 drivers/gpu/drm/nouveau/nva3_pm.c                  |  402 ++++--
 drivers/gpu/drm/nouveau/nvc0_fb.c                  |   27 +
 drivers/gpu/drm/nouveau/nvc0_fifo.c                |    2 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c               |   40 +-
 drivers/gpu/drm/nouveau/nvc0_graph.h               |    1 +
 drivers/gpu/drm/nouveau/nvc0_grctx.c               |   13 +-
 drivers/gpu/drm/nouveau/nvc0_grgpc.fuc             |    8 +-
 drivers/gpu/drm/nouveau/nvc0_grgpc.fuc.h           |   29 +-
 drivers/gpu/drm/nouveau/nvc0_grhub.fuc             |    3 +
 drivers/gpu/drm/nouveau/nvc0_grhub.fuc.h           |   16 +-
 drivers/gpu/drm/nouveau/nvc0_pm.c                  |  155 ++
 drivers/gpu/drm/nouveau/nvc0_vram.c                |   50 +-
 drivers/gpu/drm/nouveau/nvd0_display.c             | 1473 ++++++++++++++++++++
 drivers/gpu/drm/radeon/evergreen.c                 |   51 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c        |  348 +----
 drivers/gpu/drm/radeon/evergreen_cs.c              |   32 +-
 drivers/gpu/drm/radeon/evergreend.h                |   42 +
 drivers/gpu/drm/radeon/ni.c                        |   21 +-
 drivers/gpu/drm/radeon/r100.c                      |  149 ++-
 drivers/gpu/drm/radeon/r100_track.h                |  110 +--
 drivers/gpu/drm/radeon/r300.c                      |    5 +-
 drivers/gpu/drm/radeon/r300_cmdbuf.c               |    2 +-
 drivers/gpu/drm/radeon/r600.c                      |   37 +-
 drivers/gpu/drm/radeon/r600_blit.c                 |   24 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c             |  359 ++---
 drivers/gpu/drm/radeon/r600_cs.c                   |   41 +-
 drivers/gpu/drm/radeon/r600d.h                     |   22 +
 drivers/gpu/drm/radeon/radeon.h                    |  109 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   16 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   14 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |    4 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c          |  247 +++-
 drivers/gpu/drm/radeon/radeon_combios.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   28 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   22 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |    4 +-
 drivers/gpu/drm/radeon/radeon_i2c.c                |   48 +-
 drivers/gpu/drm/radeon/radeon_irq.c                |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_tv.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |    1 +
 drivers/gpu/drm/radeon/radeon_object.c             |   41 +
 drivers/gpu/drm/radeon/radeon_object.h             |   42 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   38 +
 drivers/gpu/drm/radeon/radeon_state.c              |   16 +-
 drivers/gpu/drm/radeon/rs400.c                     |    3 +
 drivers/gpu/drm/radeon/rs600.c                     |    3 +
 drivers/gpu/drm/radeon/rv770.c                     |   15 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |    1 +
 drivers/gpu/drm/vmwgfx/Kconfig                     |    9 +-
 drivers/gpu/drm/vmwgfx/Makefile                    |    3 +-
 drivers/gpu/drm/vmwgfx/svga3d_reg.h                |  259 +++-
 drivers/gpu/drm/vmwgfx/svga_escape.h               |    2 +-
 drivers/gpu/drm/vmwgfx/svga_overlay.h              |   22 +-
 drivers/gpu/drm/vmwgfx/svga_reg.h                  |  304 ++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |   73 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c             |  322 +++++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  276 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  227 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  870 ++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |   74 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              | 1135 ++++++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.h              |  113 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               |  156 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                |   81 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c      |   46 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |  273 ++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c                |  187 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                | 1083 +++++++++++----
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |   44 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |  305 +----
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c             |  171 +++
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |  192 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           | 1035 ++++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |  567 ++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c           |    5 +-
 drivers/iommu/intel-iommu.c                        |   31 +-
 drivers/staging/Kconfig                            |    2 -
 include/drm/drmP.h                                 |    3 +
 include/drm/drm_crtc.h                             |    9 +
 include/drm/drm_dp_helper.h                        |   61 +
 include/drm/drm_edid.h                             |    9 +
 include/drm/exynos_drm.h                           |  104 ++
 include/drm/intel-gtt.h                            |    2 +
 include/drm/vmwgfx_drm.h                           |  358 ++++--
 include/linux/io-mapping.h                         |    4 +
 196 files changed, 18675 insertions(+), 5588 deletions(-)
 create mode 100644 drivers/gpu/drm/exynos/Kconfig
 create mode 100644 drivers/gpu/drm/exynos/Makefile
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_buf.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_buf.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_connector.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_connector.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_core.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_crtc.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_crtc.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_drv.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_drv.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_encoder.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_encoder.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_fb.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_fb.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_fbdev.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_fbdev.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_fimd.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_gem.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_gem.h
 rename drivers/gpu/drm/nouveau/{nv40_mpeg.c => nv31_mpeg.c} (76%)
 create mode 100644 drivers/gpu/drm/nouveau/nv40_pm.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_pm.c
 create mode 100644 drivers/gpu/drm/nouveau/nvd0_display.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
 create mode 100644 include/drm/exynos_drm.h
--29444707-1207823296-1319742589=:21460--
