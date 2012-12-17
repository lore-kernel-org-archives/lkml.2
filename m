Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab2LQEpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 23:45:00 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53174 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab2LQEo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 23:44:58 -0500
Date: Mon, 17 Dec 2012 04:44:52 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm next
Message-ID: <alpine.DEB.2.00.1212170432550.3570@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-843984693-1355719492=:3570"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-843984693-1355719492=:3570
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is the one and only next pull for 3.8, we had a regression we found 
last week, so I was waiting for that to resolve itself, and I ended up 
with some Intel fixes on top as well.

Highlights:
new driver: nvidia tegra 20/30/hdmi support 
radeon: add support for previously unused DMA engines, more HDMI regs,  
eviction speeds ups and fixes
i915:  HSW support enable, agp removal on GEN6, seqno wrapping
exynos: IPP subsystem support (image post proc), HDMI
nouveau: display class reworking, nv20->40 z compression 
ttm: start of locking fixes, rcu usage for lookups,
core: documentation updates, docbook integration, monotonic clock usage, 
move from connector to object properties

Dave.

The following changes since commit e548a83c34806b8bc2c55f52d3bc481a13a3829e:

  Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux (2012-11-28 16:51:10 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-next

for you to fetch changes up to 55bde6b1442fed8af67b92d21acce67db454c9f9:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next (2012-12-16 06:05:03 +0000)

----------------------------------------------------------------

Adam Jackson (6):
      drm: Export drm_probe_ddc()
      drm/dp: Update DPCD defines
      drm/i915/dp: Fetch downstream port info if needed during DPCD fetch
      drm/i915/dp: Be smarter about connection sense for branch devices
      drm/dp: Document DP spec versions for various DPCD registers
      drm/dp: Make sink count DP 1.2 aware

Akinobu Mita (2):
      drm: use memchr_inv()
      drm/radeon: Use hweight32

Alan Cox (1):
      gma600: Enable HDMI support

Alex Deucher (29):
      drm: fix documentation for drm_crtc_set_mode()
      drm/radeon/dce3.2: add registers for ELD handling
      drm/radeon/dce4/5: add registers for ELD handling
      drm/radeon/dce32+: use fractional fb dividers for high clocks
      drm/radeon: add new INFO ioctl requests
      drm/radeon: fix eDP clk and lane setup for scaled modes
      drm/radeon: bump driver version for new info ioctl requests
      drm/radeon/kms: Add initial support for async DMA on r6xx/r7xx
      drm/radeon/kms: Add initial support for async DMA on evergreen
      drm/radeon/kms: Add initial support for async DMA on cayman/TN
      drm/radeon/kms: Add initial support for async DMA on SI
      drm/radeon/kms: add support for dma rings to radeon_test_moves()
      drm/radeon: use async dma for ttm buffer moves on 6xx-SI
      drm/radeon: add dma engine support for vm pt updates on ni (v5)
      drm/radeon: use DMA engine for VM page table updates on cayman/TN
      drm/radeon: add dma engine support for vm pt updates on si (v2)
      drm/radeon: use DMA engine for VM page table updates on SI
      drm/radeon: improve mc_stop/mc_resume on r5xx-r7xx
      drm/radeon: add register headers for CP DMA on r6xx-SI
      drm/radeon: add support for CP DMA packet to r6xx/r7xx CS checker
      drm/radeon: add support for CP DMA packet to evergreen CS checker
      drm/radeon/cayman: add VM CS checker support for CP DMA
      drm/radeon/si: add VM CS checker support for CP DMA
      drm/radeon/kms: add 6xx/7xx CS parser for async DMA (v2)
      drm/radeon/kms: add evergreen/cayman CS parser for async DMA (v2)
      drm/radeon: add VM CS parser support for async DMA on cayman/TN/SI
      drm/radeon: enable the async DMA rings in the CS ioctl
      drm/radeon: bump version for CS ioctl support for async DMA
      drm/radeon: add more pedantic checks in the CP DMA checker

Ben Skeggs (90):
      drm/nouveau/bios: attempt to fetch entire acpi rom image in one shot
      drm/nouveau/fb: split tile and compression region handling
      drm/nv20/fb: split implementation into nv20/nv25 pieces
      drm/nv30/fb: split implementation into nv34(nv10)/nv30/nv35 pieces
      drm/nv40/fb: split implementation into nv40/nv41/nv44/nv46/nv47/nv49/nv4e pieces
      drm/nv20/fb: fix zcomp register calculation on big-endian systems
      drm/nv30-nv40/fb: make use of bankoff for zeta buffers, where supported
      drm/nv40/fb: start bashing zcomp registers on relevant chipsets
      drm/nouveau/fb: read TILE_BASE after writing it to avoid a hardware race
      drm/nouveau: replace some open-coded mm_initialised checks
      drm/nv30/fb: start bashing zcomp registers with 'disabled' (for now)
      drm/nouveau/fb: create tag heap from common code for all relevant chipsets
      drm/nv30-nv40/fb: call zcomp setup hook from tiling setup
      drm/nv30-nv40/graph: poke zcomp regs from tile_prog hook
      drm/nv20/fb: fixup compression tag allocation size
      drm/nv40/fb: enable z compression
      drm/nv30/fb: enable z compression
      drm/nv40/fb: use an actual compressed zeta format
      drm/nouveau: remove newline-only NV_DEBUG calls
      drm/nouveau/gpio: place upper limit on using old-school tvdac bios data
      drm/nouveau: pass address to object accessor functions as u64
      drm/nouveau/dmaobj: merge everything except ctor and bind together
      drm/nouveau/dmaobj: move parent class check to bind() method
      drm/nvc0/dmaobj: stub bind function for now so we can call unconditionally
      drm/nvd0/dmaobj: duplicate fermi class, will diverge real soon now
      drm/nv50/dmaobj: extend class to allow gpu-specific attributes to be defined
      drm/nvc0/dmaobj: implement initial bind() method
      drm/nvd0/dmaobj: initial bind() method implementation
      drm/nv50/disp: create skeleton display/channel object classes
      drm/nv50/disp: copy caps to evo
      drm/nv50/disp: enable interrupts and setup memory area
      drm/nv50/disp: initial implementation of the various channel object classes
      drm/nv50/disp: allow PCI_US pushbuf binding
      drm/nvd0-nve0/disp: initial implementation of evo channel classes
      drm/nvd0/disp: introduce a nvd0_head as a subclass of nouveau_crtc
      drm/nouveau/drm/nvd0/disp: display->disp
      drm/nouveau: run mode_config destructor before destroying internal display state
      drm/nvd0/disp: allocate display and evo channels from driver core
      drm/nouveau/bios: implement BIT 'U' table (and subtable) parsing in core
      drm/nouveau/core: add some missing subdev/engine disable flags
      drm/nvd0/disp: move remaining interrupt handling to core
      drm/nouveau/bios: implement "full" BIT 'd' table (and subtable) parsing in core
      drm/nouveau/core: expose full method calling capabilities with nv_exec
      drm/nouveau/core: allow representing method ranges in nouveau_omthds
      drm/nvd0/disp: move link training helpers into core as display methods
      drm/nvd0/disp: call into core to handle sor power state changes
      drm/nvd0/disp: call into core to handle dac power state changes
      drm/nvd0/disp: move HDA codec setup to core
      drm/nvd0/disp: move HDMI control to core
      drm/nvd0/disp: handle DP transfer unit setup from second supervisor interrupt
      drm/nouveau/bios: implement some dcb output entry parsing/matching functions
      drm/nv50/disp: allocate display from driver core
      drm/nv50/disp: call into core to handle dac/sor power state changes
      drm/nv50/disp: call into core for dac load detection
      drm/nv50/disp: move dp link training helpers into core
      drm/nva3/disp: move hda codec handling to core
      drm/nv84/disp: move hdmi control into core
      drm/nvd0/disp: calculate U script id in supervisor interrupt
      drm/nv50/disp: move remaining interrupt handling into core
      drm/nouveau: remove (now obsolete) BIT U table parsing from DRM code
      drm/nouveau/dp: move core link training calls to common code
      drm/nouveau/dp: remove last bits of VBIOS parsing from DRM code
      drm/nvd0/disp: start implementing support for older display classes
      drm/nvd0/disp: implement dac support for older display classes
      drm/nvd0/disp: implement sor support for older display classes
      drm/nvd0/disp: implement support for older DISP_SYNC classes
      drm/nvd0/disp: support creation of fb dma objects on older chipsets
      drm/nvd0/disp: enable support for older display classes
      drm/nvd0/disp: remove fetching of capabilities report
      drm/nvd0/disp: implement support for colour vibrance control
      drm/nv50-nvc0: switch to common disp impl, removing previous version
      drm/nouveau: rename nvd0_display to nv50_display to reflect reality since merge
      drm/nouveau/disp: add support for 10bpc over DisplayPort
      drm/nouveau: initial falcon (fuc) engine base class implementation
      drm/nv98/crypt: use nouveau_falcon base class
      drm/nva3/copy: use nouveau_falcon base class
      drm/nvc0/copy: use nouveau_falcon base class
      drm/nouveau/copy: remove nouveau_copy base class
      drm/nouveau/mc: allow calling of multiple handlers for a give intr bit
      drm/nv50/fb: implement trap handler as subdev interrupt handler
      drm/nvc0/copy: share interrupt handler with nva3
      drm/nouveau/core: implement shortcut for simple engctx construction
      drm/nve0: allow specification of channel engine type in abi16 call
      drm/nve0/bsp: implement initial support for engine
      drm/nve0/vp: implement initial support for engine
      drm/nve0/fifo: allow for future binding of ppp contexts
      drm/nouveau/vdec: remove nouveau_{bsp,vp} base classes, use nouveau_engine directly
      nve0/ppp: enable support via nvc0's implementation
      drm/nouveau/ppp: remove nouveau_ppp base class
      drm/nouveau/fifo: trigger engine context unload before zeroing context pointer

Ben Widawsky (19):
      drm/i915: Extract PCU communication
      drm/i915: Workaround to bump rc6 voltage to 450
      drm/i915: Add rc6vids to debugfs
      drm/i915: No LLC_MLC for HSW.
      drm/i915: Add dev to ppgtt
      drm/i915: introduce gtt_pte_t
      drm/i915: Extract PPGTT pte encoding
      drm/i915: move more pte encoding to pte encode
      drm/i915: Stop using AGP layer for GEN6+
      drm/i915: Calculate correct stolen size for GEN7+
      drm/i915: Kill off now unused gen6+ AGP code
      drm/i915: flush system agent TLBs on SNB
      drm/i915: Move the remaining gtt code
      drm/i915: Missed lock change with rps lock
      drm/i915: Fix sparse warnings in from AGP kill code
      drm/i915: Allocate the proper size for contexts.
      drm/i915: Fix warning in i915_gem_chipset_flush
      drm/i915: Use pci_resource functions for BARs.
      drm/i915: Fix pte updates in ggtt clear range

Chris Wilson (31):
      drm/i915: Align the hangcheck wakeup to the nearest second
      drm/i915: Align the retire_requests worker to the nearest second
      drm/i915: Allow DRM_ROOT_ONLY|DRM_MASTER to submit privileged batchbuffers
      drm/i915: Document the multi-threaded FORCEWAKE bits
      drm/i915: Clear FORCEWAKE when taking over from BIOS
      drm/i915: Always calculate 8xx WM values based on a 32-bpp framebuffer
      drm/i915: Clear unused fields of mode for framebuffer creation
      drm/i915: Update load-detect failure paths for modeset-rework
      drm/i915/i2c: Track users of GMBUS force-bit
      drm/i915: Report amount of usable graphics memory in MiB
      drm/i915: Restore physical HWS_PGA after resume
      drm/i915: Use LRI to update the semaphore registers
      drm/i915: Remove save/restore of physical HWS_PGA register
      drm/i915: Remove bogus test for a present execbuffer
      drm/i915: Guard pages being reaped by OOM whilst binding-to-GTT
      drm/i915: Pin the object whilst faulting it in
      drm/i915: Flush outstanding unpin tasks before pageflipping
      drm/i915: Apply the IBX transcoder A w/a for HDMI to SDVO as well
      drm/i915: Defer assignment of obj->gtt_space until after all possible mallocs
      drm/i915: Borrow our struct_mutex for the direct reclaim
      drm/i915: LVDS fallback to fixed-mode if EDID not present
      drm/i915: Report the origin of the LVDS fixed panel mode
      drm/i915: Increase the response time for slow SDVO devices
      drm/i915: Wait upon the last request seqno, rather than a future seqno
      drm/i915: Preallocate next seqno before touching the ring
      drm/i915: Simplify flushing activity on the ring
      drm/i915: Rearrange code to only have a single method for waiting upon the ring
      drm/i915: Include the last semaphore sync point in the error-state
      drm/i915: Decouple the object from the unbound list before freeing pages
      drm/i915: Clear the existing watermarks for g4x when modifying the cursor sr
      drm/i915: Close race between processing unpin task and queueing the flip

Christian König (1):
      drm/radeon: stop page faults from hanging the system (v2)

Damien Lespiau (16):
      drm/i915: Remove the disabling of VHR unit clock gating for HSW
      drm/i915: Document that we are implementing WaDisableBackToBackFlipFix
      drm/i915: Remove the WaDisableBackToBackFlipFix w/a for Haswell
      drm/i915: Fix the SCC/SSC typo in the SPLL bits definition
      drm/i915: Consolidate ILK_DSPCLK_GATE and PCH_DSPCLK_GATE
      drm/i915: Program DSPCLK_GATE_D only once on Ironlake
      drm/i915: Don't program DSPCLK_GATE_D twice on IVB and VLV
      drm/i915: Don't try to use SPR_SCALE when we don't have a sprite scaler
      drm/i915: VLV does not have a sprite scaler
      drm/i915/tv: Use intel_flush_display_plane() to flush the primary plane
      drm/i915: Error out when trying to set a y-tiled as a sprite
      drm/i915: Fix primary plane offset on HSW
      drm/i915: Fix sprite offset on HSW
      drm/i915: adjust sprite base address
      drm/i915: Flush using only the correct base address register
      drm/i915: Only check for valid PP_{ON, OFF}_DELAYS on pre ILK hardware

Daniel J Blueman (1):
      drm/nouveau: prevent log mangling

Daniel Vetter (69):
      drm/i915: s/DRM_IRQ_ARGS/int irq, void *arg
      drm/i915: move hpd handling to (ibx|cpt)_irq_handler
      drm/i915: don't save/restore DP regs for kms
      drm/i915: don't save/restore irq regs for kms
      drm/i915: don't save/restore HWS_PGA reg for kms
      drm/i915/crt: don't set HOTPLUG bits on !PCH
      drm/i915/crt: explicitly set up HOTPLUG_BITS on resume
      drm/i915: don't save/restor ADPA for kms
      drm/i915: unconditionally use mt forcewake on hsw/ivb
      Merge tag 'v3.7-rc2' into drm-intel-next-queued
      drm: rename drm_dp_i2c_helper.c to drm_dp_helper.c
      drm: dp helper: extract drm_dp_channel_eq_ok
      drm: dp helper: extract drm_dp_clock_recovery_ok
      drm: extract helpers to compute new training values from sink request
      drm: extract dp link train delay functions from radeon
      drm/i915: use the new dp train delay helpers
      drm: extract dp link bw helpers
      drm: extract drm_dp_max_lane_count helper
      drm/i915/dp: actually nack test request
      drm/i915: make edp panel power sequence setup more robust
      drm/i915: enable/disable backlight for eDP
      drm/i915/eDP: compute the panel power clock divisor from the pch rawclock
      drm/i915/dp: compute the pch dp aux divider from the rawclk
      drm/i915: extract intel_dp_init_panel_power_sequencer
      drm/i915: shut up spurious message in intel_dp_get_hw_state
      drm/i915: Write the FDI RX TU size reg at the right time
      drm/i915: clarify why we need to enable fdi plls so early
      drm/i915: set FDI_RX_MISC to recommended values on CPT/PPT
      drm/i915: add comment about pch pll enabling rules
      drm/i915: BUG on impossible pch dp port
      drm/i915: add ->display.modeset_global_resources callback
      drm/i915: check fdi B/C lane sharing constraint
      drm/i915: implement WaIssueDummyWriteToWakeupFromRC6
      drm/i915: implement WaDisableRenderCachePipelinedFlush
      drm/i915: move encoder->mode_set calls to crtc_mode_set
      drm: add helper to sort panels to the head of the connector list
      drm/i915: move panel connectors to the front
      drm/i915: check whether the pch is the soulmate of the cpu
      drm/i915: drop unnecessary check from fdi_link_train code
      drm/i915: CPT+ pch transcoder workaround
      drm/i915: implement WADP0ClockGatingDisable
      drm/i915: kill pch_init_clock_gating indirection
      drm/i915: move the suspend/resume register file out of dev_priv
      drm/i915: move dev_priv->(rps|ips) out of line
      drm/i915: move pwrctx/renderctx to the other ilk power state
      drm/i915: move dri1 dungeon out of dev_priv
      drm/i915: extract l3_parity substruct from dev_priv
      drm/i915: drop the double-OP_STOREDW usage in blt_ring_flush
      drm: extract drm_kms_helper_hotplug_event
      drm: handle HPD and polled connectors separately
      drm: run the hpd irq event code directly
      drm: properly init/reset connector status
      drm: don't start the poll engine in probe_single_connector
      drm: don't poll forced connectors
      drm: don't unnecessarily enable the polling work
      drm/i915: drop buggy write to FDI_RX_CHICKEN register
      drm/i915: resurrect panel lid handling
      drm/edid: tune down debug message in parse_hdmi_vsdb
      drm/doc: Helpers are not a Midlayer!
      drm/doc: integrate crtc helper api into docbook
      drm/doc: integrate fb helper reference into docs
      drm/doc: add new dp helpers into drm DocBook
      drm/i915: force restore on lid open
      drm/i915: fixup l3 parity sysfs access check
      drm/i915: disable cpt phase pointer fdi rx workaround
      drm/exynos: reorder framebuffer init sequence
      drm/radeon: add W|RREG32_IDX for MM_INDEX|DATA based mmio accesss
      drm/radeon: make indirect register access concurrency-safe
      drm/radeon: fix fence locking in the pageflip callback

Dave Airlie (13):
      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      drm/nouveau: Add interface to detect optimus and v1 support
      drm/nouveau: convert to dev_pm_ops
      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'connector-to-object-prop' of git://github.com/robclark/kernel-omap4 into drm-next
      Merge branch 'drm-next-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-next-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-next-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next
      radeon: fix regression with eviction since evict caching changes
      Merge branch 'drm-next-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'exynos-drm-next' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next

David Herrmann (1):
      drm: fix returning -EINVAL on setmaster if another master is active

Egbert Eich (2):
      DRM/KMS: Add Bail-Out Conditions for Loop.
      drm/exynos: fix memory leak to EDID block

Eunchul Kim (5):
      drm/exynos: add ipp subsystem
      drm/exynos: add iommu support for ipp
      drm/exynos: add fimc ipp driver
      drm/exynos: add rotator ipp driver
      drm/exynos: add gsc ipp driver

Gajanan Bhat (1):
      drm/i915: Add eDP support for Valleyview

Igor Murzov (1):
      vga_switcheroo: Drop unused include and unused variables.

Imre Deak (6):
      drm: use monotonic time in drm_calc_vbltimestamp_from_scanoutpos
      drm: add support for monotonic vblank timestamps
      drm/exynos: hold event_lock while accessing pageflip_event_list
      drm/exynos: call drm_vblank_put for each queued flip event
      drm/exynos: fix lockdep for event_lock wrt. vbl_time_lock
      drm: hold event_lock while accessing vblank_event_list

Inki Dae (15):
      drm/exynos: fix linux framebuffer address setting.
      drm/exynos: remove unnecessary code.
      drm/exynos: fix overlay updating issue
      drm/exynos: add iommu support for exynos drm framework
      drm/exynos: add iommu support to fimd driver
      drm/exynos: add iommu support for hdmi driver
      drm/exynos: add iommu support for g2d
      drm/exynos: remove EXYNOS_BO_NONCONTIG type checking.
      drm/exynos: add userptr feature for g2d module
      drm/exynos: add vm_ops to specific gem mmaper
      drm/exynos: make sure that overlay data are updated
      drm/exynos: add dmabuf attach/detach callbacks.
      drm/exynos: add exception codes to exynos_drm_fbdev_create()
      drm/exynos: use DMA_ATTR_NO_KERNEL_MAPPING attribute
      drm/exynos: fix allocation and cache mapping type

James Hogan (1):
      drm: only build ati_pcigart if PCI enabled

Jani Nikula (20):
      drm/i915: add debug logging to ASLE backlight set requests
      drm/i915/lvds: Rename intel_lvds to intel_lvds_encoder
      drm/i915/lvds: Introduce intel_lvds_connector
      drm/i915/lvds: Move the acpi_lid_notifier from drm_i915_private to the connector
      drm/i915: Backlight setup requires connector so pass it as parameter
      drm/i915/lvds: Move some connector specific info across from the encoder
      drm/i915/dp: Initialize eDP fixed mode in intel_dp_init
      drm/i915: Create generic intel_panel for LVDS and eDP
      drm/i915: Move the fixed mode to intel_panel
      drm/i915: Do not free the passed EDID in intel_connector_update_modes()
      drm/i915: Move cached EDID to intel_connector
      drm/i915: remove an extra #define for DP_RECEIVER_CAP_SIZE
      drm/i915/sdvo: force GPIO bit-banging also on default pin
      drm/i915/sdvo: restore i2c adapter config on intel_sdvo_init() failures
      drm/i915: debug print all of the DPCD we have
      drm/i915/lvds: move fitting mode from intel_lvds_connector to intel_panel
      drm/i915: pass adjusted_mode to intel_choose_pipe_bpp_dither(), again
      drm/i915: remove HAS_eDP as unnecessary and inconsistent indirection
      drm/i915/sdvo: kfree the intel_sdvo_connector, not drm_connector, on destroy
      drm/i915: do not access BLC_PWM_CTL2 on pre-gen4 hardware

Jean Delvare (1):
      drm/i915: Optimize DIV_ROUND_CLOSEST call

Jerome Glisse (5):
      drm/radeon: use cached memory when evicting for vram on non agp
      drm/radeon: do not move bo to different placement at each cs
      drm/radeon: fix amd afusion gpu setup aka sumo v2
      drm/radeon: fix fence driver for dma ring when wb is disabled
      drm/radeon: fix htile buffer size computation for command stream checker

Jesse Barnes (15):
      drm/i915: limit VLV IRQ enables to those we use
      drm/i915: implement WaForceL3Serialization on VLV and IVB
      drm/i915: implement WaDisableEarlyCull for VLV and IVB
      drm/i915: implement WaDisableL3CacheAging on VLV
      drm/i915: implement WaDisableDopClockGatingisable on VLV and IVB
      drm/i915: implement WaForceL3Serialization on VLV and IVB
      drm/i915: implement WaDisableVLVClockGating_VBIIssue on VLV
      drm/i915: implement WaDisablePSDDualDispatchEnable on IVB & VLV
      drm/i915: TLB invalidation with MI_FLUSH_DW requires a post-sync op v3
      drm/i915: PIPE_CONTROL TLB invalidate requires CS stall
      drm/i915: add clock gating regs to VLV offset check function
      drm/i915: don't block resume on fb console resume v2
      drm/i915: put ring frequency and turbo setup into a work queue v5
      drm/i915: protect RPS/RC6 related accesses (including PCU) with a new mutex
      drm/i915: don't rewrite the GTT on resume v4

Jingoo Han (1):
      drm/pci: add missing variable initialization

Joonyoung Shim (4):
      drm/exynos: fix fb offset calculation for plane
      drm/exynos: fix x, y coordinates for right bottom pixel
      drm/exynos: support extended screen coordinate of fimd
      drm/exynos: support device tree for fimd

Maarten Lankhorst (17):
      drm/ttm: add ttm_bo_is_reserved
      drm/radeon: Use ttm_bo_is_reserved
      drm/vmwgfx: use ttm_bo_is_reserved
      drm/vmwgfx: remove use of fence_obj_args
      drm/ttm: remove sync_obj_arg member
      drm/ttm: remove sync_obj_arg from ttm_bo_move_accel_cleanup
      drm/ttm: remove sync_arg from driver functions
      drm/ttm: alter cpu_writers to return -EBUSY in ttm_execbuf_util reservations
      nvc0/bsp: initial implementation of engine
      nvc0/vp: initial implementation of engine
      nvc0/ppp: initial implementation of engine
      drm/ttm: change fence_lock to inner lock
      drm/radeon: allow move_notify to be called without reservation
      drm/ttm: call ttm_bo_cleanup_refs with reservation and lru lock held, v3
      drm/ttm: cope with reserved buffers on swap list in ttm_bo_swapout, v2
      drm/ttm: cope with reserved buffers on lru list in ttm_mem_evict_first, v2
      drm/ttm: remove no_wait_reserve, v3

Marcin Slusarz (9):
      drm/ttm: remove ttm_buffer_object->buffer_start
      drm/ttm: remove ttm_bo_device->nice_mode
      drm/ttm: remove ttm_mem_global->queue
      drm/nouveau: remove unused variable from nouveau_bios_shadow_of
      drm/nv50: decode PGRAPH status registers on TLB flush fail
      drm/nouveau: raise reporting levels of some messages
      drm/nouveau: remove misleading comment from nouveau_prime_new
      drm/nouveau: unpin pushbuffer bo before destroying it
      drm/nouveau: unpin various bo's before destroying

Marek Ol¨ák (1):
      drm/radeon: add a CS flag END_OF_FRAME

Marek Szyprowski (2):
      common: DMA-mapping: add DMA_ATTR_FORCE_CONTIGUOUS attribute
      ARM: dma-mapping: add support for DMA_ATTR_FORCE_CONTIGUOUS attribute

Martin Peres (1):
      drm/nouveau/core: fix the assumption that NVDEV_XXXX is always under 32

Mika Kuoppala (4):
      drm/i915: remove unused mem_block struct definition
      drm/i915/ringbuffer: exclude last 2 cachelines on 845g on all callpaths
      drm/i915: fix possible NULL dereference of dev_priv
      drm/i915: Set sync_seqno properly after seqno wrap

Paulo Zanoni (100):
      drm/i915: don't recheck for invalid pipe bpp
      drm/i915: extract set_m_n from ironlake_crtc_mode_set
      drm/i915: extract compute_dpll from ironlake_crtc_mode_set
      drm/i915: remove unused variables from ironlake_crtc_mode_set
      drm/i915: extract intel_set_pipe_timings from crtc_mode_set
      drm/i915: rewrite the LCPLL code
      drm/i915: enable and disable DDI_FUNC_CTL at the right time
      drm/i915: enable and disable PIPE_CLK_SEL at the right time
      drm/i915: add haswell_crtc_mode_set
      drm/i915: add proper CPU/PCH checks to crtc_mode_set functions
      drm/i915: add haswell_set_pipeconf
      drm/i915: completely rewrite the Haswell PLL handling code
      drm/i915: don't rely on previous values set on DDI_BUF_CTL
      drm/i915: don't implement WaDisableEarlyCull for Haswell
      drm/i915: disable DDI_BUF_CTL at the correct time
      drm/i915: pipe and planes should be disabled on haswell_crtc_mode_set
      drm/i915: add DP support to intel_ddi_enable_pipe_func
      drm/i915: add intel_ddi_set_pipe_settings
      drm/i915: add DP support to intel_ddi_pll_mode_set
      drm/i915: add basic Haswell DP link train bits
      drm/i915: use TU_SIZE macro at intel_dp_set_m_n
      drm/i915: fix DP AUX register definitions on Haswell
      drm/i915: add DP support to intel_ddi_get_encoder_port
      drm/i915: add DP support to intel_ddi_get_hw_state
      drm/i915: add DP support to intel_enable_ddi
      drm/i915: add DP support to intel_ddi_mode_set
      drm/i915: add DP support to intel_ddi_disable_port
      drm/i915: fix Haswell DP M/N registers
      drm/i915: implement Haswell DP link train sequence
      drm/i915: set the correct function pointers for Haswell DP
      drm/i915: fork a Haswell version of ironlake_crtc_{enable, disable}
      drm/i915: fix checks inside ironlake_crtc_{enable, disable}
      drm/i915: fix checks inside haswell_crtc_{enable, disable}
      drm/i915: simplify intel_crtc_driving_pch
      drm/i915: don't call Haswell PCH code when we can't or don't need
      drm/i915: add TRANSCODER_EDP
      drm/i915: convert PIPE_CLK_SEL to transcoder
      drm/i915: convert DDI_FUNC_CTL to transcoder
      drm/i915: check TRANSCODER_EDP on intel_modeset_setup_hw_state
      drm/i915: convert PIPECONF to use transcoder instead of pipe
      drm/i915: convert PIPE_MSA_MISC to transcoder
      drm/i915: convert CPU M/N timings to transcoder
      drm/i915: convert pipe timing definitions to transcoder
      drm/i915: implement workaround for VTOTAL when using TRANSCODER_EDP
      drm/i915: select the correct pipe when using TRANSCODER_EDP
      drm/i915: set the correct eDP aux channel clock divider on DDI
      drm/i915: set/unset the DDI eDP backlight
      drm/i915: turn the eDP DDI panel on/off
      drm/i915: enable DDI eDP
      drm/i915: simplify assignments inside intel_dp.c
      drm/i915: add intel_dp_to_dev and intel_hdmi_to_dev
      drm/i915: create intel_digital_port and use it
      drm/i915: split intel_hdmi_init into encoder and connector pieces
      drm/i915: split intel_dp_init into encoder and connector pieces
      drm/i915: reset intel_encoder->type when DP or HDMI is detected
      drm/i915: add port field to intel_digital_port
      drm/i915: add intel_ddi_connector_get_hw_state
      drm/i915: create the DDI encoder
      drm/i915: don't set ADPA pipe select on LPT
      drm/i915: use intel_ddi_get_hw_state on CRT encoder too
      drm/i915: add lpt_pch_enable
      drm/i915: remove Haswell/LPT bits from ironlake_pch_enable
      drm/i915: remove ironlake bits from lpt_pch_enable
      drm/i915: rename intel_enable_pch_pll to ironlake_enable_pch_pll
      drm/i915: don't call ironlake_enable_pch_pll on lpt_pch_enable
      drm/i915: don't assert_panel_unlocked on LPT
      drm/i915: use the CPU and PCH transcoders on lpt_pch_enable
      drm/i915: rename intel_{en, dis}able_transcoder
      drm/i915: fork lpt version of ironlake_{en, dis}able_pch_transcoder
      drm/i915: remove Haswell code from ironlake_enable_pch_transcoder
      drm/i915: remove IBX code from lpt_enable_pch_transcoder
      drm/i915: don't assert_pch_pll_enabled on lpt_enable_pch_transcoder
      drm/i915: use CPU and PCH transcoders on lpt_enable_pch_transcoder
      drm/i915: don't rely on previous values when setting LPT TRANSCONF
      drm/i915: don't assert_pch_ports_disabled on LPT
      drm/i915: use PIPECONF_INTERLACE_MASK_HSW on lpt_enable_pch_transcoder
      drm/i915: use CPU and PCH transcoders on lpt_disable_pch_transcoder
      drm/i915: implement timing override workarounds on LPT
      drm/i915: don't call intel_disable_pch_pll on Haswell/LPT
      drm/i915: don't assert disabled FDI before disabling the FDI
      drm/i915: set the correct number of FDI lanes on Haswell
      drm/i915: fix Haswell FDI link training code
      drm/i915: fix Haswell FDI link disable path
      drm/i915: don't limit Haswell CRT encoder to pipe A
      drm/i915: use cpu/pch transcoder on intel_enable_pipe
      drm/i915: fix false positive "Unclaimed write" messages
      drm/i915: make DP work on LPT-LP machines
      drm/i915: don't intel_crt_init if DDI A has 4 lanes
      drm/i915: make the panel fitter work on pipes B and C on IVB
      drm/i915: make the panel fitter work on pipes B and C on Haswell
      drm/i915: fix intel_ddi_get_cdclk_freq for ULT machines
      drm/i915: implement WaMbcDriverBootEnable on Haswell
      drm/i915: promote Haswell to full support
      drm: add drm_mode_cea_vic
      drm/i915: set the VIC of the mode on the AVI InfoFrame
      drm/i915: fix hsw_fdi_link_train "retry" code
      drm/i915: reject modes the LPT FDI receiver can't handle
      drm/i915: add support for mPHY destination on intel_sbi_{read, write}
      drm/i915: add lpt_init_pch_refclk
      drm/i915: set the LPT FDI RX polarity reversal bit when needed

Prathyush K (11):
      drm/exynos: remove unnecessary sg_alloc_table call
      drm/exynos: add exynos drm specific fb_mmap function
      drm/exynos: remove 'pages' and 'page_size' elements in exynos gem buffer
      drm/exynos: use sgt instead of pages for framebuffer address
      drm/exynos: make wait_for_vblank a manager op
      drm/exynos: move hdmi's wait_for_vblank to manager_ops
      drm/exynos: move fimd wait_for_vblank to manager_ops
      drm/exynos: modify wait_for_vblank of mixer
      drm/exynos: modify wait_for_vblank of fimd
      drm/exynos: clear windows in mixer dpms off
      drm/exynos: clear windows in fimd dpms off

Rahul Sharma (8):
      drm: exynos: fix for mapping of dma buffers
      drm: exynos: fix for loosing display mode header during mode adjustment
      drm/exynos: sending AVI and AUI info frames
      drm: exynos: moved exynos drm device registration to drm driver
      drm: exynos: moved exynos drm hdmi device registration to drm driver
      drm/exynos: added runtime pm support for hdmi
      drm/exynos: add runtime pm support for mixer
      drm/exynos: add support for hdmiphy power control for exynos5

Rob Clark (12):
      drm: add drm_send_vblank_event() helper (v5)
      drm/i915: use drm_send_vblank_event() helper
      drm/i915: drm_connector_property -> drm_object_property
      drm/gma500: drm_connector_property -> drm_object_property
      drm/radeon: drm_connector_property -> drm_object_property
      drm/shmob: drm_connector_property -> drm_object_property
      drm/udl: drm_connector_property -> drm_object_property
      drm/vmwgfx: drm_connector_property -> drm_object_property
      drm/i2c: drm_connector_property -> drm_object_property
      drm/i915: One more drm_connector_property -> drm_object_property
      drm/nouveau: drm_connector_property -> drm_object_property
      drm: remove legacy drm_connector_property fxns

Sachin Kamat (19):
      drm/fb_helper: Fix checkpatch errors
      drm/fb_helper: Convert printk to pr_* and dev_*
      drm/drm_fb_helper: Remove unnecessary braces
      drm/crtc: Remove redundant NULL check before kfree
      drm/crtc: Fix potential NULL pointer dereference
      drm/fb_helper: Fix potential NULL pointer dereference
      drm/drm_stub: Remove unnecessary null check before kfree.
      drm/udl: Add missing static storage class specifiers in udl_connector.c
      drm/nouveau: remove duplicate inclusion of nouveau_ttm.h
      drm/nouveau/device: Remove duplicate inclusion of core/device.h
      drm/exynos: Make exynos4/5_fimd_driver_data static
      drm/exynos: Fix potential NULL pointer dereference in exynos_drm_encoder.c
      drm/exynos: Use devm_clk_get in exynos_drm_g2d.c
      drm/exynos: Fix potential NULL pointer dereference
      drm/exynos: Use devm_clk_get in exynos_mixer.c
      drm/exynos: Use devm_* APIs in exynos_hdmi.c
      drm/exynos: Use devm_clk_get in exynos_drm_fimd.c
      drm/exynos: hdmi: Add CONFIG_OF and use of_match_ptr() macro
      drm/exynos: hdmi: Fix potential NULL pointer dereference error

Stephane Marchesin (1):
      drm: get cea video id code for a given display mode

Takashi Iwai (2):
      drm/i915: Enable DP audio for Haswell
      drm/i915: Fix shifted screen on top of LVDS on IVY laptop

Thierry Reding (5):
      drm: Add NVIDIA Tegra20 support
      drm: tegra: Add HDMI support
      drm: tegra: Use framebuffer pitch as line stride
      drm: tegra: Add Tegra30 support
      drm: tegra: Add maintainers entry

Thomas Hellstrom (19):
      drm: Make hashtab rcu-safe
      kref: Implement kref_get_unless_zero v3
      drm/ttm, drm/vmwgfx: Use RCU locking for object lookups v3
      drm/ttm: Optimize reservation slightly
      drm/vmwgfx: Enable traces *after* we've hidden SVGA
      drm/vmwgfx: Make overlay code not require fifo at init time
      drm/vmwgfx: Make screen object code not require fifo at init time
      drm/vmwgfx: Refactor module load to not require fifo unless fbdev is loaded
      drm/vmwgfx: Make vmw_dmabuf_unreference handle NULL objects
      drm/vmwgfx: Refactor resource management
      drm/vmwgfx: Break out surface and context management to separate files
      drm/vmwgfx: Add and make use of a header for surface size calculation.
      drm: Add a hash-tab rcu-safe API
      kref: Add kref_get_unless_zero documentation
      drm/vmwgfx: Free user-space fence objects correctly
      drm/ttm: Fix locking in an error path
      drm/ttm: Use the hashtab _rcu interface for ttm_objects
      drm/ttm: Optimize vm locking using kref_get_unless_zero v3
      drm/vmwgfx: Tighten the security around buffer maps

Tommi Rantala (6):
      drm/cirrus: check alloc_apertures() success in cirrus_kick_out_firmware_fb()
      drm/mgag200: check alloc_apertures() success in mga_vram_init()
      drm/mgag200: free memory allocated with alloc_apertures()
      drm/mgag200: remove unneeded aper->count assignment after alloc_apertures()
      drm/radeon: check alloc_apertures() success in radeon_kick_out_firmware_fb()
      drm/nouveau: free memory allocated with alloc_apertures()

Vijay Purushothaman (6):
      drm/i915: Set aux clk to 100MHz for Valleyview
      drm/i915: Fix SDVO IER and status bits for Valleyview
      drm/i915: Add Valleyview lane control definitions
      drm/i915: Program correct m n tu register for Valleyview
      drm/i915: Enable DisplayPort in Valleyview
      drm/i915: Fixup HDMI output on Valleyview

Viktor Novotný (1):
      drm/nouveau/clk: fix crystal frequency retrieval on nv25

Ville Syrjälä (12):
      drm: Be more paranoid with integer overflows
      drm: Constify some function arguments
      drm: Ignore blob propertys in drm_property_change_is_valid()
      drm/i915: Fix display pixel format handling
      drm/i915: Check framebuffer stride more thoroughly
      drm/i915: Check the framebuffer offset
      drm/i915: pixel_size == cpp
      drm/i915: Bad pixel formats can't reach the sprite code
      drm/i915: Introduce intel_crtc_update_sarea_pos()
      drm/i915: Add SURFLIVE register definitions
      drm: Reject addfb2 with undefined flag bits set
      drm/i915: Don't allow ring tail to reach the same cacheline as head

Wei Shun Chang (1):
      drm/i915: add LynxPoint-LP PCH ID

Wei Yongjun (3):
      drm/i915: remove duplicated include from intel_modes.c
      gma500: medfield: drop bogus NULL check in mdfld_dsi_output_init()
      drm/exynos/iommu: fix return value check in drm_create_iommu_mapping()

YoungJun Cho (1):
      drm/exynos: remove unused vaddr member

Yuly Novikov (2):
      drm/i915/dp: allow configuring eDP panel fitting scaling mode
      drm/i915/dp: change eDP default scaling mode to respect aspect ratio

Zhenyu Wang (2):
      drm/i915: Fix HSW power well control state read
      drm/i915: Fix missed needs_dmar setting

 Documentation/DMA-attributes.txt                   |    9 +
 Documentation/DocBook/drm.tmpl                     |   39 +-
 .../bindings/gpu/nvidia,tegra20-host1x.txt         |  191 ++
 Documentation/kref.txt                             |   88 +
 MAINTAINERS                                        |    9 +
 arch/arm/mm/dma-mapping.c                          |   41 +-
 drivers/char/agp/intel-agp.h                       |   91 -
 drivers/char/agp/intel-gtt.c                       |  320 +--
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    6 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |   12 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                |   13 +-
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |   12 +-
 drivers/gpu/drm/drm_crtc.c                         |   63 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |  161 +-
 .../drm/{drm_dp_i2c_helper.c => drm_dp_helper.c}   |  146 +-
 drivers/gpu/drm/drm_edid.c                         |   48 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   76 +-
 drivers/gpu/drm/drm_hashtab.c                      |   38 +-
 drivers/gpu/drm/drm_ioctl.c                        |    3 +
 drivers/gpu/drm/drm_irq.c                          |  120 +-
 drivers/gpu/drm/drm_modes.c                        |    8 +-
 drivers/gpu/drm/drm_pci.c                          |    2 +-
 drivers/gpu/drm/drm_stub.c                         |   37 +-
 drivers/gpu/drm/drm_sysfs.c                        |    6 +-
 drivers/gpu/drm/exynos/Kconfig                     |   30 +
 drivers/gpu/drm/exynos/Makefile                    |    5 +
 drivers/gpu/drm/exynos/exynos_ddc.c                |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_buf.c            |  115 +-
 drivers/gpu/drm/exynos/exynos_drm_buf.h            |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |    5 +
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |  150 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  117 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   43 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.c        |   36 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.h        |    1 +
 drivers/gpu/drm/exynos/exynos_drm_fb.c             |   94 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |   74 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           | 2001 +++++++++++++++
 drivers/gpu/drm/exynos/exynos_drm_fimc.h           |   37 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  200 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |  495 +++-
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |  435 ++--
 drivers/gpu/drm/exynos/exynos_drm_gem.h            |   58 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            | 1870 ++++++++++++++
 drivers/gpu/drm/exynos/exynos_drm_gsc.h            |   38 +
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |   59 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h           |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_iommu.c          |  150 ++
 drivers/gpu/drm/exynos/exynos_drm_iommu.h          |   85 +
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            | 2060 ++++++++++++++++
 drivers/gpu/drm/exynos/exynos_drm_ipp.h            |  266 ++
 drivers/gpu/drm/exynos/exynos_drm_plane.c          |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |  855 +++++++
 drivers/gpu/drm/exynos/exynos_drm_rotator.h        |   33 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   26 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  324 ++-
 drivers/gpu/drm/exynos/exynos_hdmiphy.c            |    4 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |  376 +--
 drivers/gpu/drm/exynos/regs-fimc.h                 |  669 +++++
 drivers/gpu/drm/exynos/regs-gsc.h                  |  284 +++
 drivers/gpu/drm/exynos/regs-hdmi.h                 |   22 +-
 drivers/gpu/drm/exynos/regs-rotator.h              |   73 +
 drivers/gpu/drm/gma500/cdv_device.c                |    4 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |    2 +-
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c            |    6 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   10 +-
 drivers/gpu/drm/gma500/mdfld_dsi_output.c          |   12 +-
 drivers/gpu/drm/gma500/mdfld_intel_display.c       |    2 +-
 drivers/gpu/drm/gma500/oaktrail.h                  |    6 +
 drivers/gpu/drm/gma500/oaktrail_crtc.c             |   10 +-
 drivers/gpu/drm/gma500/oaktrail_device.c           |    2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |  365 ++-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    8 +-
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   10 +-
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |   24 +-
 drivers/gpu/drm/i2c/ch7006_drv.c                   |   20 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   66 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   95 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  136 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  472 ++--
 drivers/gpu/drm/i915/i915_gem.c                    |  292 +--
 drivers/gpu/drm/i915/i915_gem_context.c            |    5 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   64 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  420 +++-
 drivers/gpu/drm/i915/i915_irq.c                    |   86 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  308 ++-
 drivers/gpu/drm/i915/i915_suspend.c                |  763 +++---
 drivers/gpu/drm/i915/i915_sysfs.c                  |   45 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   10 +-
 drivers/gpu/drm/i915/intel_bios.c                  |    3 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   62 +-
 drivers/gpu/drm/i915/intel_ddi.c                   | 1091 +++++++--
 drivers/gpu/drm/i915/intel_display.c               | 2029 +++++++++++----
 drivers/gpu/drm/i915/intel_dp.c                    |  961 +++++---
 drivers/gpu/drm/i915/intel_drv.h                   |  123 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  135 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |    9 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  227 +-
 drivers/gpu/drm/i915/intel_modes.c                 |   11 +-
 drivers/gpu/drm/i915/intel_opregion.c              |    2 +
 drivers/gpu/drm/i915/intel_panel.c                 |   90 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  511 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  250 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   36 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  128 +-
 drivers/gpu/drm/i915/intel_sprite.c                |  101 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   21 +-
 drivers/gpu/drm/mgag200/mgag200_main.c             |    4 +-
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |   12 +-
 drivers/gpu/drm/nouveau/Makefile                   |   38 +-
 drivers/gpu/drm/nouveau/core/core/engctx.c         |   15 +
 drivers/gpu/drm/nouveau/core/core/falcon.c         |  247 ++
 drivers/gpu/drm/nouveau/core/core/gpuobj.c         |    4 +-
 drivers/gpu/drm/nouveau/core/core/mm.c             |   17 +-
 drivers/gpu/drm/nouveau/core/engine/bsp/nv84.c     |  108 +-
 drivers/gpu/drm/nouveau/core/engine/bsp/nvc0.c     |  110 +
 drivers/gpu/drm/nouveau/core/engine/bsp/nve0.c     |  110 +
 drivers/gpu/drm/nouveau/core/engine/copy/nva3.c    |  124 +-
 drivers/gpu/drm/nouveau/core/engine/copy/nvc0.c    |  167 +-
 drivers/gpu/drm/nouveau/core/engine/copy/nve0.c    |   54 +-
 drivers/gpu/drm/nouveau/core/engine/crypt/nv84.c   |   46 +-
 drivers/gpu/drm/nouveau/core/engine/crypt/nv98.c   |   83 +-
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |   88 +
 drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c |   48 +
 drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c |   53 +
 .../gpu/drm/nouveau/core/engine/disp/hdminv84.c    |   66 +
 .../gpu/drm/nouveau/core/engine/disp/hdminva3.c    |   66 +
 .../gpu/drm/nouveau/core/engine/disp/hdminvd0.c    |   62 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    | 1144 ++++++++-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.h    |  142 ++
 drivers/gpu/drm/nouveau/core/engine/disp/nv84.c    |   98 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv94.c    |  109 +
 drivers/gpu/drm/nouveau/core/engine/disp/nva0.c    |   88 +
 drivers/gpu/drm/nouveau/core/engine/disp/nva3.c    |  111 +
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |  884 ++++++-
 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c    |   94 +
 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c |  112 +
 drivers/gpu/drm/nouveau/core/engine/disp/sornv94.c |  190 ++
 drivers/gpu/drm/nouveau/core/engine/disp/sornvd0.c |  126 +
 drivers/gpu/drm/nouveau/core/engine/dmaobj/base.c  |   71 +-
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nv04.c  |   68 +-
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nv50.c  |  126 +-
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nvc0.c  |  104 +-
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c  |  122 +
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |   19 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.c    |   17 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv10.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv17.c    |    8 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv40.c    |    8 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c    |   36 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |   60 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |   26 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |   21 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv04.c   |  184 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv10.c   |   10 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv20.c   |    6 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c   |   38 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |   83 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |    2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/regs.h   |    5 +
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv31.c    |    6 +-
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv50.c    |    1 -
 drivers/gpu/drm/nouveau/core/engine/ppp/nv98.c     |  107 +-
 drivers/gpu/drm/nouveau/core/engine/ppp/nvc0.c     |  110 +
 .../gpu/drm/nouveau/core/engine/software/nv04.c    |    4 +-
 .../gpu/drm/nouveau/core/engine/software/nv10.c    |    2 +-
 .../gpu/drm/nouveau/core/engine/software/nv50.c    |   10 +-
 .../gpu/drm/nouveau/core/engine/software/nvc0.c    |   10 +-
 drivers/gpu/drm/nouveau/core/engine/vp/nv84.c      |  108 +-
 drivers/gpu/drm/nouveau/core/engine/vp/nvc0.c      |  110 +
 drivers/gpu/drm/nouveau/core/engine/vp/nve0.c      |  110 +
 drivers/gpu/drm/nouveau/core/include/core/class.h  |  225 ++
 drivers/gpu/drm/nouveau/core/include/core/engctx.h |    3 +
 drivers/gpu/drm/nouveau/core/include/core/falcon.h |   81 +
 drivers/gpu/drm/nouveau/core/include/core/gpuobj.h |    4 +-
 drivers/gpu/drm/nouveau/core/include/core/mm.h     |    6 +
 drivers/gpu/drm/nouveau/core/include/core/object.h |   41 +-
 drivers/gpu/drm/nouveau/core/include/core/parent.h |    2 +-
 drivers/gpu/drm/nouveau/core/include/engine/bsp.h  |   41 +-
 drivers/gpu/drm/nouveau/core/include/engine/copy.h |   39 +-
 .../gpu/drm/nouveau/core/include/engine/crypt.h    |   39 -
 drivers/gpu/drm/nouveau/core/include/engine/disp.h |    5 +
 .../gpu/drm/nouveau/core/include/engine/dmaobj.h   |   29 +-
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |    6 +-
 drivers/gpu/drm/nouveau/core/include/engine/ppp.h  |   40 +-
 drivers/gpu/drm/nouveau/core/include/engine/vp.h   |   41 +-
 .../gpu/drm/nouveau/core/include/subdev/bios/dcb.h |   34 +-
 .../drm/nouveau/core/include/subdev/bios/disp.h    |   48 +
 .../gpu/drm/nouveau/core/include/subdev/bios/dp.h  |   32 +-
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   43 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |   32 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |   63 +
 drivers/gpu/drm/nouveau/core/subdev/bios/disp.c    |  178 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/dp.c      |  182 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/gpio.c    |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |   13 +-
 drivers/gpu/drm/nouveau/core/subdev/device/base.c  |   28 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv10.c  |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv20.c  |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv30.c  |    6 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv40.c  |   28 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nv50.c  |   26 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c  |   64 +-
 drivers/gpu/drm/nouveau/core/subdev/device/nve0.c  |   17 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.c |   34 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/base.c      |   92 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv04.c      |   62 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv10.c      |   52 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c      |   89 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv20.c      |   86 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv25.c      |   81 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv30.c      |   51 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv35.c      |   82 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv36.c      |   82 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv40.c      |  131 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv41.c      |  106 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv44.c      |  114 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv46.c      |   79 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv47.c      |   66 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv49.c      |   84 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv4e.c      |   72 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |  393 +--
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |  126 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c      |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.c |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv50.c |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c      |    8 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |    1 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |    1 +
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |   27 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   30 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.h             |    4 +
 drivers/gpu/drm/nouveau/nouveau_bios.c             |  235 +-
 drivers/gpu/drm/nouveau/nouveau_bios.h             |    9 -
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   65 +-
 drivers/gpu/drm/nouveau/nouveau_bo.h               |    2 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |    6 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   25 +-
 drivers/gpu/drm/nouveau/nouveau_connector.h        |   16 +
 drivers/gpu/drm/nouveau/nouveau_crtc.h             |   10 -
 drivers/gpu/drm/nouveau/nouveau_display.c          |   25 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |  141 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   98 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |    4 +-
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |    7 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_hdmi.c             |  261 --
 drivers/gpu/drm/nouveau/nouveau_irq.c              |   12 -
 drivers/gpu/drm/nouveau/nouveau_prime.c            |    4 -
 drivers/gpu/drm/nouveau/nouveau_vga.c              |    5 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c                |    6 +-
 drivers/gpu/drm/nouveau/nv04_display.c             |    5 -
 drivers/gpu/drm/nouveau/nv10_fence.c               |    7 +-
 drivers/gpu/drm/nouveau/nv17_tv.c                  |   16 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c                |  764 ------
 drivers/gpu/drm/nouveau/nv50_cursor.c              |  136 --
 drivers/gpu/drm/nouveau/nv50_dac.c                 |  321 ---
 drivers/gpu/drm/nouveau/nv50_display.c             | 2579 ++++++++++++++------
 drivers/gpu/drm/nouveau/nv50_display.h             |   71 +-
 drivers/gpu/drm/nouveau/nv50_evo.c                 |  403 ---
 drivers/gpu/drm/nouveau/nv50_evo.h                 |  120 -
 drivers/gpu/drm/nouveau/nv50_fence.c               |    5 +-
 drivers/gpu/drm/nouveau/nv50_pm.c                  |    2 +-
 drivers/gpu/drm/nouveau/nv50_sor.c                 |  530 ----
 drivers/gpu/drm/nouveau/nvc0_fence.c               |   28 +-
 drivers/gpu/drm/nouveau/nvd0_display.c             | 2141 ----------------
 drivers/gpu/drm/radeon/atombios_crtc.c             |    2 +
 drivers/gpu/drm/radeon/atombios_dp.c               |  149 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |    2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  218 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |  739 +++++-
 drivers/gpu/drm/radeon/evergreend.h                |  131 +
 drivers/gpu/drm/radeon/ni.c                        |  357 ++-
 drivers/gpu/drm/radeon/nid.h                       |   86 +
 drivers/gpu/drm/radeon/r100.c                      |   23 +-
 drivers/gpu/drm/radeon/r600.c                      |  480 +++-
 drivers/gpu/drm/radeon/r600_cp.c                   |    7 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |  357 ++-
 drivers/gpu/drm/radeon/r600_reg.h                  |    9 +
 drivers/gpu/drm/radeon/r600d.h                     |   86 +-
 drivers/gpu/drm/radeon/radeon.h                    |   38 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |  198 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   34 +
 drivers/gpu/drm/radeon/radeon_combios.c            |    6 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   62 +-
 drivers/gpu/drm/radeon/radeon_cp.c                 |   14 -
 drivers/gpu/drm/radeon/radeon_cs.c                 |   13 +
 drivers/gpu/drm/radeon/radeon_cursor.c             |   17 +-
 drivers/gpu/drm/radeon/radeon_device.c             |    1 +
 drivers/gpu/drm/radeon/radeon_display.c            |    4 +
 drivers/gpu/drm/radeon/radeon_drv.c                |   18 +-
 drivers/gpu/drm/radeon/radeon_drv.h                |    1 -
 drivers/gpu/drm/radeon/radeon_fence.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |    1 -
 drivers/gpu/drm/radeon/radeon_kms.c                |   16 +
 drivers/gpu/drm/radeon/radeon_mode.h               |    2 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   52 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    2 +-
 drivers/gpu/drm/radeon/radeon_test.c               |   37 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   40 +-
 drivers/gpu/drm/radeon/rv515.c                     |  122 +-
 drivers/gpu/drm/radeon/rv770.c                     |   31 +-
 drivers/gpu/drm/radeon/rv770d.h                    |   71 +
 drivers/gpu/drm/radeon/si.c                        |  355 ++-
 drivers/gpu/drm/radeon/sid.h                       |  119 +
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |    2 +-
 drivers/gpu/drm/tegra/Kconfig                      |   23 +
 drivers/gpu/drm/tegra/Makefile                     |    7 +
 drivers/gpu/drm/tegra/dc.c                         |  834 +++++++
 drivers/gpu/drm/tegra/dc.h                         |  388 +++
 drivers/gpu/drm/tegra/drm.c                        |  115 +
 drivers/gpu/drm/tegra/drm.h                        |  234 ++
 drivers/gpu/drm/tegra/fb.c                         |   56 +
 drivers/gpu/drm/tegra/hdmi.c                       | 1334 ++++++++++
 drivers/gpu/drm/tegra/hdmi.h                       |  575 +++++
 drivers/gpu/drm/tegra/host1x.c                     |  325 +++
 drivers/gpu/drm/tegra/output.c                     |  272 +++
 drivers/gpu/drm/tegra/rgb.c                        |  228 ++
 drivers/gpu/drm/ttm/ttm_bo.c                       |  321 ++-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    8 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |    4 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |   10 +-
 drivers/gpu/drm/ttm/ttm_memory.c                   |    1 -
 drivers/gpu/drm/ttm/ttm_object.c                   |   51 +-
 drivers/gpu/drm/udl/udl_connector.c                |   14 +-
 drivers/gpu/drm/vmwgfx/Makefile                    |    3 +-
 drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h        |  909 +++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |   23 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c            |  274 +++
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c             |   22 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   92 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  153 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  917 +++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |    7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   21 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           | 2113 ++++++----------
 drivers/gpu/drm/vmwgfx/vmwgfx_resource_priv.h      |   84 +
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  893 +++++++
 drivers/gpu/vga/vga_switcheroo.c                   |    6 -
 include/drm/drmP.h                                 |    3 +
 include/drm/drm_crtc.h                             |   19 +-
 include/drm/drm_crtc_helper.h                      |    3 +
 include/drm/drm_dp_helper.h                        |   39 +
 include/drm/drm_hashtab.h                          |   14 +
 include/drm/exynos_drm.h                           |   26 +
 include/drm/intel-gtt.h                            |    7 +-
 include/drm/ttm/ttm_bo_api.h                       |   33 +-
 include/drm/ttm/ttm_bo_driver.h                    |   45 +-
 include/drm/ttm/ttm_execbuf_util.h                 |    3 -
 include/drm/ttm/ttm_memory.h                       |    2 -
 include/drm/ttm/ttm_object.h                       |    4 +
 include/linux/dma-attrs.h                          |    1 +
 include/linux/kref.h                               |   21 +
 include/uapi/drm/drm.h                             |    1 +
 include/uapi/drm/exynos_drm.h                      |  203 +-
 include/uapi/drm/i915_drm.h                        |    6 +
 include/uapi/drm/radeon_drm.h                      |    6 +
 364 files changed, 39036 insertions(+), 14981 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
 rename drivers/gpu/drm/{drm_dp_i2c_helper.c => drm_dp_helper.c} (58%)
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_fimc.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_fimc.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_gsc.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_gsc.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_iommu.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_iommu.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_ipp.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_ipp.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_rotator.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_rotator.h
 create mode 100644 drivers/gpu/drm/exynos/regs-fimc.h
 create mode 100644 drivers/gpu/drm/exynos/regs-gsc.h
 create mode 100644 drivers/gpu/drm/exynos/regs-rotator.h
 create mode 100644 drivers/gpu/drm/nouveau/core/core/falcon.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/bsp/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/bsp/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/hdminvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nv50.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nv94.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nva0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/sornv94.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/sornvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/ppp/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/vp/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/vp/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/falcon.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/disp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/disp.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv25.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv35.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv36.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv41.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv44.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv46.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv47.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv49.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv4e.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_hdmi.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_crtc.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_cursor.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_dac.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_evo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_evo.h
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_sor.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvd0_display.c
 create mode 100644 drivers/gpu/drm/tegra/Kconfig
 create mode 100644 drivers/gpu/drm/tegra/Makefile
 create mode 100644 drivers/gpu/drm/tegra/dc.c
 create mode 100644 drivers/gpu/drm/tegra/dc.h
 create mode 100644 drivers/gpu/drm/tegra/drm.c
 create mode 100644 drivers/gpu/drm/tegra/drm.h
 create mode 100644 drivers/gpu/drm/tegra/fb.c
 create mode 100644 drivers/gpu/drm/tegra/hdmi.c
 create mode 100644 drivers/gpu/drm/tegra/hdmi.h
 create mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 drivers/gpu/drm/tegra/output.c
 create mode 100644 drivers/gpu/drm/tegra/rgb.c
 create mode 100644 drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_context.c
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_resource_priv.h
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
--29444707-843984693-1355719492=:3570--
