Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956Ab2JDEIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:08:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58575 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab2JDEIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:08:52 -0400
Date: Thu, 4 Oct 2012 05:08:48 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm merge for rc1 (part 1)
Message-ID: <alpine.DEB.2.00.1210040456090.3115@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1680291690-1349323728=:3115"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1680291690-1349323728=:3115
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

So first of all my tree and uapi stuff has a conflict mess, its my fault 
as the nouveau stuff didn't hit -next as were trying to rebase regressions 
out of it before we merged.

So this pull is for my drm-next-merged branch which is my drm-next branch 
merged with your tree, and some fixups applied to the merge.

Highlights:
SH mobile modesetting driver and associated helpers
some DRM core documentation
i915 modesetting rework, haswell hdmi, haswell and vlv fixes, write 
combined pte writing, ilk rc6 support,
nouveau: major driver rework into a hw core driver, makes features like 
SLI a lot saner  to implement,
psb: add eDP/DP support for Cedarview
radeon: 2 layer page tables, async VM pte updates, better PLL selection 
for > 2 screens, better ACPI interactions

The rest is general grab bag of fixes.

So why part 1? well I have the exynos pull req which came in a bit late 
but was waiting for me to do something they shouldn't have and it looks 
fairly safe, and David Howells has some more header cleanups he'd like me 
to pull, that seem like a good idea, but I'd like to get this merge out of 
the way so -next dosen't get blocked.

Dave.

The following changes since commit 3a494318b14b1bc0f59d2d6ce84c505c74d82d2a:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace (2012-10-03 16:09:09 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-next-merged

for you to fetch changes up to a8d5415b0aac6b9fac34c752ed9e09312545f487:

  drm: Merge remote-tracking branch 'pfdo/drm-next' into linus (2012-10-04 13:25:34 +1000)

----------------------------------------------------------------

Akinobu Mita (1):
      gpu/drm/ttm: use copy_highpage

Alan Cox (6):
      gma500: Add the support of display port on CDV
      gma500/cdv: add the bits that don't need the new code
      gma500/cdv: sync up and add the displayport code to the build
      gma500/cdv: enable the DisplayPort support
      gma500/cdv: Fix call to cdv_intel_dp_set_m_n
      gma500: Fix frequency detection

Alex Deucher (45):
      drm/radeon/dce4+: don't use radeon_crtc for vblank callback
      drm/radeon: clean up evergreen_get_vblank_counter
      drm/radeon/r1xx-r4xx: don't use radeon_crtc for vblank callback
      drm/radeon/r5xx-r7xx: don't use radeon_crtc for vblank callback (v2)
      drm/radeon: properly handle mc_stop/mc_resume on evergreen+ (v2)
      drm/radeon/dynpm: wait for fences on all rings when reclocking
      drm/radeon: remove gui_idle interrupt infrastructure
      drm/radeon: add new AMD ACPI header and update relevant code (v2)
      drm/radeon: add a license header to radeon_apci.c
      drm/radeon: track whether the GPU controls the backlight (v2)
      drm/radeon: rework legacy backlight control
      drm/radeon: add backlight control for atom devices (v2)
      drm/radeon: re-organize the acpi notifier callback
      drm/radeon: document radeon_acpi.c
      drm/radeon: update ATPX verify interface handling (v2)
      drm/radeon: reorganize ATPX support (v2)
      drm/radeon: document radeon_atpx_handler.c (v2)
      drm/radeon: add initial support for ATCS ACPI methods
      drm/radeon: rework the backlight control to be an asic callback
      drm/radeon/atom: add consolidate bpc code
      drm/radeon: document async VM changes in ni.c
      drm/radeon: implement bounds checking on thermal controller lookup
      drm/radeon: remove dead function def
      drm/radeon: clean up encoder dp checks
      drm/radeon: white space cleanup in transmitter setup
      drm/radeon/atom: fix typo in SetPixelClock handling
      drm/radeon: fix typo in atombios_get_encoder_mode
      drm/radeon: rework pll selection (v4)
      drm/radeon/dce3: use a single PPLL for all DP displays
      drm/radeon: allow PPLL sharing on non-DP displays
      drm/radeon: rework crtc pll setup to better support PPLL sharing
      drm/radeon: store the encoder in the radeon_crtc
      drm/radeon: make non-DP PPLL sharing more robust
      drm/radeon: work around KMS modeset limitations in PLL allocation (v2)
      drm/radeon: validate PPLL in crtc fixup
      drm/radeon: only adjust default clocks on NI GPUs
      drm/radeon: add get_backlight_level callback
      drm/radeon: restore backlight level on resume
      drm/radeon: Add MSI quirk for gateway RS690
      drm/radeon: force MSIs on RS690 asics
      drm/radeon: fix radeon power state debug output
      drm/radeon/pm: fix multi-head profile handling on BTC+ (v2)
      drm/radeon: use WRITE_DATA packets for vm flush on SI
      drm/radeon: rework the vm_flush interface
      drm/radeon: add vm set_page() callback for SI

Andy Shevchenko (1):
      drm: use %*ph to dump small buffers

Ben Skeggs (85):
      drm/nvc0/fence: restore pre-suspend fence buffer context on resume
      drm/nouveau/gem: use bo.offset rather than mm_node.start
      drm/nouveau: restructure source tree, split core from drm implementation
      drm/nouveau/agp: move all agp stuff into its own source file
      drm/nouveau/core: pull in most of the new core infrastructure
      drm/nouveau: implement module init functions in nouveau_drm.c
      drm/nouveau: have non-core mmio accesses go through device object
      drm/nouveau/bios: pull in basic vbios subdev, more to come later
      drm/nouveau/oldbios: remove shadowing support, use bios subdev's image
      drm/nouveau/gpio: port gpio to subdev interfaces
      drm/nouveau/i2c: port to subdev interfaces
      drm/nouveau/clk: implement stub clock subdev
      drm/nouveau/clock: pull in the implementation from all over the place
      drm/nouveau: implement devinit subdev, and new init table parser
      drm/nouveau/mc: port to subdev interfaces
      drm/nouveau/timer: port to subdev interfaces
      drm/nouveau/core: add support for reverse mm allocations
      drm/nv50-/instmem: allocate vram for kernel objects from end of vram
      drm/nouveau/fb: merge fb/vram and port to subdev interfaces
      drm/nv04-nv40/instmem: duplicate nv04 code as nv40, remove alternate paths
      drm/nv04-nv40/instmem: remove use of nouveau_gpuobj_new_fake()
      drm/nv04-nv40/fifo: remove use of nouveau_gpuobj_new_fake()
      drm/nvc0/fifo: handle bar1 control regs much like fifo/nve0
      drm/nouveau/gpuobj: create wrapper functions for mapping gpuobj into vm/bar
      drm/nouveau/gpuobj: remove flags for vm-mappings
      drm/nv50/instmem: remove use of nouveau_gpuobj_new_fake()
      drm/nouveau: remove last use of nouveau_gpuobj_new_fake()
      drm/nouveau/instmem: completely new implementation, as a subdev module
      drm/nv04/disp: kick all private state out to own header
      drm/nouveau: pull nouveau_bo definitions into their own header
      drm/nouveau: pull nouveau_gem definitions into their own header
      drm/nouveau/fence: un-port from nouveau_exec_engine interfaces
      drm/nvc0-nve0/graph: rename dev to priv, no code changes
      drm/nouveau: move some more code around to more appropriate places
      drm/nouveau/pageflip: kick flip handling out of engsw and into fence
      drm/nvc0-/gr: share headers between fermi and kepler graphics code
      drm/nvc0-/gr: generate grctx template at init time, not first context ctor
      drm/nouveau: port all engines to new engine module format
      drm/nouveau: start culling unused code
      drm/nouveau/mxm: split up into bios code and a subdev module
      drm/nouveau/acpi: move definitions out of nouveau_drv.h
      drm/nouveau: move compat ioctl out of nouveau_drv.h
      drm/nouveau: flatten nv{Read,Write}{MC,VIDEO,FB,EXTDEV}
      drm/nouveau/backlight: remove dependence on nouveau_drv.h
      drm/nouveau/device: include the official chipset names
      drm/nouveau: port remainder of drm code, and rip out compat layer
      drm/nouveau: add Kconfig options for debug control
      drm/nvc0-/gr: remove reset-after-grctx-construction hack
      drm/nouveau/core: remove some left-over pieces from the porting process
      drm/nouveau/device: return proper error codes if ioremap fails
      drm/nve0/fifo: support engine selection when creating fifo channels
      drm/nve0/copy: add initial support for the async copy engines
      drm/nve0: use async copy engine for ttm buffer moves if available
      drm/nv84/fifo: mask only the engine we're waiting on for channel unload
      drm/nouveau/core: protect engine context list with hardirq-safe spinlock
      drm/nouveau/fifo: add method to lookup fifo chid related to a given object
      drm/nouveau/core: have fifo store a unique context identifier at attach time
      drm/nouveau: restore fifo chid information in engine error messages
      drm/nouveau/fifo: separate object classes for dma channels
      drm/nouveau/fifo: version the dma channel class struct
      drm/nv84/fifo: add support for dma channel class
      drm/nv50/fifo: add support for dma channel class
      drm/nouveau: add defines for internal class names
      drm/nouveau/dmaobj: reject unsupported parent types instead of half-succeeding
      drm/nouveau/fifo: use defines instead of hardcoded class ids
      drm/nouveau/sw: trap and clear PMC_INTR_0_SOFTWARE
      drm/nve0/ibus: handle PIBUS interrupts to prevent storm
      drm/nve0/gr: initial fuc implementation, based on fermi's code
      drm/nve0/gr: remove 0x404160 bashing from hub fuc
      drm/nve0/gr: enable use of our fuc by default
      drm/nvc0/ltcg: read LTS count at startup
      drm/nvc0/gr: rebuild fuc with latest envyas
      drm/nvc0/gr: implement initial trap handler
      drm/nvc0/fifo: re-bash PBUS regs after vm-fault to BARs/PEEPHOLE
      drm/nouveau/core: have client-id be a string, rather than an integer
      drm/nouveau: have drm debugging macros build on top of core macros
      drm/nouveau: log channel debug/error messages from client object rather than drm client
      drm/nouveau/bios: check that fixed tvdac gpio data is valid before using it
      drm/nvc0/ibus: initial implementation of subdev
      drm/nouveau: store supported dma mask in vmmgr
      drm/nv04/dmaobj: fixup vm target handling in preparation for nv4x pcie
      drm/nv44/vm: fix and enable use of "real" pciegart
      drm/nv41/vm: fix and enable use of "real" pciegart
      drm/nouveau/devinit: fixup various issues with subdev ctor/init ordering
      drm/nv98/crypt: fix fuc build with latest envyas

Ben Widawsky (24):
      drm/i915: add register read IOCTL
      drm/i915: Add contexts for HSW
      drm/i915: Macro to determine DPF support
      drm/i915: Expand DPF support to Haswell
      drm/i915: Add ERR_INT to gen7 error state
      drm/i915: Find unclaimed MMIO writes.
      drm/i915: Extract reading INSTDONE
      drm/i915: Add new INSTDONE registers
      drm/i915: Use new INSTDONE registers (Gen7+)
      drm/i915: Extract forcewake ack timeout
      drm/i915: use cpu_relax() in wait_for_atomic
      drm/i915: Change forcewake timeout to 2ms
      drm/i915: Never read FORCEWAKE
      drm/i915: Enable some sysfs stuff without CONFIG_PM
      drm/i915: placeholder getparam
      drm/i915: variable renames
      drm/i915: #define gpu freq multipler
      drm/i915: Add current/max/min GPU freq to sysfs
      drm/i915: POSTING_READ the new rps value
      drm/i915: Error checks in gen6_set_rps
      drm/i915: Add setters for min/max frequency
      drm/i915: Show render P state thresholds in sysfs
      drm/i915: Fix !CONFIG_PM sysfs for real this time
      drm/i915: s/cacheing/caching/

Chris Wilson (43):
      drm/i915: Cleanup context switching through do_switch()
      drm/i915: Return a mask of the active rings in the high word of busy_ioctl
      drm/i915: Allow late allocation of request for i915_add_request()
      drm/i915: Remove assertion over write domain after i915_gem_object_sync()
      drm/i915: Replace the pending_gpu_write flag with an explicit seqno
      drm/i915: Remove the defunct flushing list
      drm/i915: Remove the per-ring write list
      drm/i915: Remove explicit flush from i915_gem_object_flush_fence()
      drm/i915: Remove the explicit flush of the GPU write domain
      drm/i915: Clear the pending_gpu_fenced_access flag at the start of execbuffer
      drm/i915: Split i915_gem_flush_ring() into seperate invalidate/flush funcs
      drm/i915: Avoid concurrent access when marking the device as idle/busy
      drm/i915: Segregate memory domains in the GTT using coloring
      drm/i915: Export ability of changing cache levels to userspace
      drm/i915: Only apply the SNB pipe control w/a to gen6
      drm/i915: Add I915_GEM_PARAM_HAS_SEMAPHORES
      drm/i915: Lazily apply the SNB+ seqno w/a
      drm/i915: Track unbound pages
      drm/i915: Add some sanity checks to unbound tracking
      drm/i915: Show (count, size) of purgeable objects in i915_gem_objects
      drm/i915: Show pin count in debugfs
      drm/i915: Try harder to allocate an mmap_offset
      drm/i915: Cantiga+ cannot handle a hsync front porch of 0
      drm/i915: Only pwrite through the GTT if there is space in the aperture
      drm/i915: Protect private gem objects from truncate (such as imported dmabuf)
      drm/i915: Extract general object init routine
      drm/i915: Use cpu relocations if the object is in the GTT but not mappable
      drm/i915: Juggle code order to ease flow of the next patch
      drm/i915: Use a non-blocking wait for set-to-domain ioctl
      drm/i915: Avoid unbinding due to an interrupted pin_and_fence during execbuffer
      drm/i915: Convert remaining debugfs iterators over rings to for_each_ring()
      drm/i915: Introduce drm_i915_gem_object_ops
      drm/i915: Pin backing pages whilst exporting through a dmabuf vmap
      drm/i915: Pin backing pages for pwrite
      drm/i915: Pin backing pages for pread
      drm/i915: Replace the array of pages with a scatterlist
      drm/i915: Drop the misleading cast to the wrong user pointer type
      drm/i915: Limit the ioremap of the PCI bar to the registers
      agp/intel: Use a write-combining map for updating PTEs
      drm/i915: Convert the dmabuf object to use the new i915_gem_object_ops
      drm/i915: Assert that the exec object lookup table is a power-of-two
      drm/i915: Wrap external callers to IPS state with appropriate locks
      drm: Destroy the planes prior to destroying the associated CRTC

Christian König (18):
      drm/radeon: cleanup VM id handling a bit
      drm/radeon: move VM funcs into asic structure
      drm/radeon: remove vm_unbind
      drm/radeon: add sync helper function
      drm/radeon: make VM flushs a ring operation
      drm/radeon: rework VMID handling
      drm/radeon: rework VM page table handling
      drm/radeon: Move looping over the PTEs into chip code
      drm/radeon: make page table updates async v2
      drm/radeon: fix VM syncing with multiple rings
      drm/radeon: fix VA range check
      drm/radeon: fix VA overlap check
      drm/radeon: move IB pool to 1MB offset
      drm/radeon: move and rename radeon_bo_va function
      drm/radeon: let bo_reserve take no_intr instead of no_wait param
      drm/radeon: fix gem_close_object handling
      drm/radeon: rework the VM code a bit more (v2)
      drm/radeon: refactor set_page chipset interface v5

Damien Lespiau (1):
      drm/i915: Don't hardcode the number of pipes in the error state dump

Dan Carpenter (1):
      drm/ast: drop duplicate initialization

Daniel Vetter (113):
      drm/i915: group ADPA #defines together
      drm/i915: simplify possible_clones computation
      drm/i915: add port parameter to intel_hdmi_init
      drm/i915: Reserve ioctl numbers for set/get_caching
      drm/i915: create VLV_DSIPLAY_BASE #define
      drm/i915: add inte_crt->adpa_reg
      drm/i915: Replace the complex flushing logic with simple invalidate/flush all
      drm/i915: Only set the down rps limit when at the loweset frequency
      drm/i915: rip out sanitize_pm again
      drm/i915: fixup desired rps frequency computation
      drm/i915: dump the device info
      drm/i915: properly guard ilk ips state
      drm/i915: fixup up debugfs rps state handling
      drm/i915: use mutex_lock_interruptible for debugfs files
      drm/i915: move all rps state into dev_priv->rps
      drm/i915: kill dev_priv->mchdev_lock
      drm/i915: DE_PCU_EVENT irq is ilk-only
      drm/i915: fix up ilk drps/ips locking
      drm/i915: enable rc6 on ilk again
      drm/i915: don't grab dev->struct_mutex for userspace forcewak
      Merge tag 'v3.6-rc2' into drm-intel-next
      drm/i915: add missing gen2 pipe A quirk entries
      drm/i915/ns2501: kill pll A enabling hack
      drm/i915: rip out the overlay pipe A workaround
      drm/i915: prepare load-detect pipe code for dpms changes
      drm/i915: drop intel_encoder argument to load_detect_pipe functions
      drm/i915: simplify dvo dpms interface
      drm/i915: kill a few unused things in dev_priv
      drm/i915: extract ironlake_fdi_pll_disable
      drm/fb-helper: don't clobber output routing in setup_crtcs
      drm/i915: move functions around
      drm/i915: disable rc6 on ilk when vt-d is enabled
      drm/i915: move i915_get_extra_insdone out of CONFIG_DEBUG_FS block
      drm/ips: move drps/ips/ilk related variables into dev_priv->ips
      drm/i915: add a tracepoint for gpu frequency changes
      drm/i915: align vlv forcewake with common lore
      drm/i915: differ error message between forcwake timeouts
      drm/i915: add crtc->enable/disable vfuncs insted of dpms
      drm/i915: rip out crtc prepare/commit indirection
      drm/i915: add direct encoder disable/enable infrastructure
      drm/i915/hdmi: convert to encoder->disable/enable
      drm/i915/tv: convert to encoder enable/disable
      drm/i915/lvds: convert to encoder disable/enable
      drm/i915/dp: convert to encoder disable/enable
      drm/i915/crt: convert to encoder disable/enable
      drm/i915/sdvo: convert to encoder disable/enable
      drm/i915/dvo: convert to encoder disable/enable
      drm/i915: convert dpms functions of dvo/sdvo/crt
      drm/i915: rip out encoder->disable/enable checks
      drm/i915: clean up encoder_prepare/commit
      drm/i915: copy&paste drm_crtc_helper_set_config
      drm/i915: call set_base directly
      drm/i915: inline intel_best_encoder
      drm/i915: copy&paste drm_crtc_helper_set_mode
      drm/i915: simplify intel_crtc_prepare_encoders
      drm/i915: rip out encoder->prepare/commit
      drm/i915: call crtc functions directly
      drm/i915: WARN when trying to enabled an unused crtc
      drm/i915: Add interfaces to read out encoder/connector hw state
      drm/i915/dp: implement get_hw_state
      drm/i915/hdmi: implement get_hw_state
      drm/i915/tv: implement get_hw_state
      drm/i915/lvds: implement get_hw_state
      drm/i915/crt: implement get_hw_state
      drm/i915/sdvo: implement get_hw_state
      drm/i915/dvo: implement get_hw_state
      drm/i915: read out the modeset hw state at load and resume time
      drm/i915: check connector hw/sw state
      drm/i915: rip out intel_crtc->dpms_mode
      drm/i915: rip out intel_dp->dpms_mode
      drm/i915: ensure the force pipe A quirk is actually followed
      drm/i915: introduce struct intel_set_config
      drm/i915: extract modeset config save/restore code
      drm/i915: extract intel_set_config_compute_mode_changes
      drm/i915: extract intel_set_config_update_output_state
      drm/i915: implement crtc helper semantics relied upon by the fb helper
      drm/i915: don't update the fb base if there is no fb
      drm/i915: convert pointless error checks in set_config to BUGs
      drm/i915: don't save all the encoder/crtc state in set_config
      drm/i915: stage modeset output changes
      drm/i915: push crtc->fb update into pipe_set_base
      drm/i915: remove crtc disabling special case
      drm/i915: move output commit and crtc disabling into set_mode
      drm/i915: extract adjusted mode computation
      drm/i915: use staged outuput config in tv->mode_fixup
      drm/i915: use staged outuput config in lvds->mode_fixup
      drm/i915: compute masks of crtcs affected in set_mode
      drm/i915: implement new set_mode code flow
      drm/i915: push commit_output_state past crtc disabling
      drm/i915: s/intel_encoder_disable/intel_encoder_noop
      drm/i915: WARN if the pipe won't turn off
      drm/i915: switch the load detect code to the staged modeset config
      drm/i915: push commit_output_state past the crtc/encoder preparing
      drm/i915: disable all crtcs at suspend time
      drm/i915: no longer call drm_helper_resume_force_mode
      drm/i915: add tons of modeset state checks
      drm/i915: improve modeset state checking after dpms calls
      Merge the modeset-rework, basic conversion into drm-intel-next
      drm/fb helper: don't call drm_helper_connector_dpms directly
      drm/i915: correctly update crtc->x/y in set_base
      drm/i915: fix OOPS in lid_notify
      drm/i915: rip out early dp port write for gm45/ilk
      drm/i915: add encoder->pre_enable/post_disable
      drm/i915: clean up the cpu edp pll special case
      drm/i915: robustify edp_pll_on/off
      drm/i915: rip out dp port enabling cludges^Wchecks
      drm/i915: disable the cpu edp port after the cpu pipe
      drm/i915: rip out edp special case from dp_link_down
      drm/i915: rip out intel_disable_pch_ports
      drm/i915: don't disable fdi links harder in ilk_crtc_enable
      drm/i915: don't call dpms funcs after set_mode
      drm/i915: update dpms property in set_mode
      Merge tag 'v3.6-rc7' into drm-intel-next-queued

Dave Airlie (14):
      drm/i915: implement dma buf begin_cpu_access (v2)
      drm/udl: call begin/end cpu access at more appropriate time
      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-doc' of git://linuxtv.org/pinchartl/fbdev into drm-next
      gma500: fix incorrect declaration.
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux into drm-next
      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-lcdc' of git://linuxtv.org/pinchartl/fbdev into drm-next
      drm: micro optimise cache flushing
      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-next-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      drm: Merge remote-tracking branch 'pfdo/drm-next' into linus

David Herrmann (1):
      drm: make buffer management work without DRM_MASTER

Dmitry Cherkasov (1):
      drm/radeon: add 2-level VM pagetables support v9

Dmitry Eremin-Solenikov (1):
      drm/nouveau: fix pm initialization order

Emil Goode (1):
      gma500: Remove unused variable

Eugeni Dodonov (1):
      drm/i915: prevent possible pin leak on error path

Florian Zumbiehl (1):
      drm/savage: re-add busmaster enable, regression fix

Forest Bond (2):
      gma500: Fix comment mispelling in cdv_intel_limits definition.
      gma500: psb_intel_crtc: Drop crtc_enable flag.

Huacai Chen (2):
      drm: Handle io prot correctly for MIPS.
      drm: Define SAREA_MAX for Loongson (PageSize = 16KB).

Jani Nikula (7):
      drm/i915: fix EDID memory leak in SDVO
      drm/ast: fix EDID memory leak
      drm: remove the raw_edid field from struct drm_display_info
      gma500: remove an unreachable return statement
      gma500: remove references to drm_display_info raw_edid field
      drm/i915: only enable sdvo hotplug irq if needed
      drm/i915: fix sdvo hotplug support check and activation

Jerome Glisse (2):
      drm/edid: limit printk when facing bad edid
      drm/radeon: make sure ib bo is properly bound and up to date in vm space

Keith Packard (1):
      drm/i915: Allow VGA on CRTC 2

Lars-Peter Clausen (1):
      DRM: Add DRM KMS/FB CMA helper

Laurent Pinchart (4):
      Documentation: DocBook DRM framework documentation
      drm: gma500: Kill the GEM glue layer
      drm: Add NV24 and NV42 pixel formats
      drm: Renesas SH Mobile DRM driver

Lauri Kasanen (2):
      drm/radeon: Mark all possible functions / structs as static
      drm/radeon: Remove unused functions

Lekensteyn (1):
      i915: initialize CADL in opregion

Luca Tettamanti (6):
      drm/radeon: refactor radeon_atif_call
      drm/radeon: implement radeon_atif_verify_interface
      drm/radeon: implement wrapper for GET_SYSTEM_PARAMS
      drm/radeon: implement handler for ACPI event
      ACPI video: allow events handlers to veto the keypress
      drm/radeon: block the keypress on ATIF events

Maarten Lankhorst (3):
      drm/ast: remove unused validate_sequence
      drm/cirrus: Remove unused validate_sequence
      drm/mgag200: remove unused validate_sequence

Marcin Slusarz (2):
      drm/nouveau: constify instances of nouveau_bitfield and nouveau_enum structs
      drm/nouveau: quiet some static-related sparse noise

Marek Ol¨ák (2):
      drm/radeon/kms: allow STRMOUT_BASE_UPDATE on RS780 and RS880
      drm/radeon: allow MIP_ADDRESS=0 for MSAA textures on Evergreen

Mark Brown (1):
      drm/i2c/ch7006: Convert to dev_pm_ops

Martin Peres (9):
      drm/nouveau/gpio: expose the PWM/TOGGLE parameter found in the gpio vbios table
      drm/nouveau/therm: rework thermal table parsing
      drm/nouveau/therm: use the EXTDEV table to detect i2c monitoring devices
      drm/nouveau/bios: parse the pwm divisor from the perf table
      drm/nouveau/therm: move thermal-related functions to the therm subdev
      drm/nouveau/fan: rewrite the fan tachometer driver to get more precision, faster
      drm/nouveau/therm: calculate the pwm divisor on nv50+
      drm/nouveau/hwmon: rename pwm0* to pmw1* to follow hwmon's rules
      drm/nouveau/therm: add support for fan-control modes

Michel Dänzer (1):
      drm/radeon: Fix scratch register leak in IB test.

Paulo Zanoni (18):
      drm/i915: move common code to intel_dp_set_link_train
      drm/i915: add port field to struct intel_dp and use it
      drm/i915: fix pipe DDI mode select
      drm/i915: set the DDI sync polarity bits
      drm/i915: correctly set the DDI_FUNC_CTL bpc field
      drm/i915: completely reset the value of DDI_FUNC_CTL
      drm/i915: reindent Haswell register definitions
      drm/i915: add parentheses around PIXCLK_GATE definitions
      drm/i915: use the correct encoder type when comparing
      drm/i915: try harder to find WR PLL clock settings
      drm/i915: add gen7_render_ring_flush
      drm/i915: add workarounds directly to gen6_render_ring_flush
      drm/i915: add workarounds to gen7_render_ring_flush
      drm/i915: extract ironlake_set_pipeconf form ironlake_crtc_mode_set
      drm/i915: simplify setting DSPCNTR inside ironlake_crtc_mode_set
      drm/i915: extract compute_clocks from ironlake_crtc_mode_set
      drm/i915: BUG() on unexpected HDMI register
      drm/i915: make sure we write all the DIP data bytes

Peter Senna Tschudin (1):
      drivers/gpu/drm/ttm/ttm_page_alloc_dma.c: Remove useless kfree

Rob Clark (3):
      drm: refcnt drm_framebuffer (v4.1)
      drm: support for rotated scanout
      drm: change ioctl permissions

Robert P. J. Day (1):
      drm: Remove unnecessary test for ARM.

Russell King - ARM Linux (1):
      drm: consistently name interlaced modes

Sachin Kamat (7):
      drm/usb: select USB_SUPPORT in Kconfig
      drm: Add missing static storage class specifier in drm_irq.c file
      drm: Add misssing static storage class specifier in drm_fb_helper.c file
      drm/udl: Use NULL instead of 0 for pointers
      drm/udl: Make udl_enc_destroy() static
      drm/udl: Make udl_crtc_init() static
      drm/udl: Add missing static storage class specifiers in udl_fb.c

Sascha Hauer (1):
      DRM: Add DRM GEM CMA helper

Sedat Dilek (2):
      drm/i915: Remove __GFP_NO_KSWAPD
      drm: udl: usb: Fix recursive Kconfig dependency

Shirish S (1):
      drm: edid: add support for E-DDC

Shobhit Kumar (1):
      drm/i915: Move DP structs to shared location

Steven Fuerst (3):
      Rename i2f() to int2float(), and make it global so one copy can be removed.
      Replace int2float() with an optimized version.
      Annotate int2float() as being a pure function.

Tejun Heo (1):
      i915: use alloc_ordered_workqueue() instead of explicit UNBOUND w/ max_active = 1

Thomas Richter (1):
      drm/i915: Support for ns2501-DVO

Ville Syrjälä (3):
      drm: edid: Add some bounds checking
      drm: edid: Add bounds checking to HDMI VSDB parsing
      drm: edid: Refactor HDMI VSDB detection

Wang Xingchao (5):
      drm/i915: HSW audio registers definition
      drm/i915: write eld info for HDMI audio
      drm/i915: ironlake_write_eld code cleanup
      drm/i915: Haswell HDMI audio initialization
      drm/i915: HDMI - Clear Audio Enable bit for Hot Plug unconditionally

Wei Yongjun (1):
      vmwgfx: remove useless set memory to zero use memset()

Xu, Anhua (2):
      drm/i915: fix wrong order of parameters in port checking functions
      drm/i915: fix reassignment of variable "intel_dp->DP"

Zhao Yakui (4):
      gma500: Fix incorrect SR issue when disabling CRTC already in disabled state
      gma500: Program the DPLL lane based on the selected digitial port
      gma500/cdv: Add eDP support
      gma500: Disable the clock gating of display controller to make DP/eDP work well

 Documentation/DocBook/drm.tmpl                     | 2835 +++++++++---
 drivers/acpi/video.c                               |    8 +-
 drivers/char/agp/intel-gtt.c                       |   62 +-
 drivers/gpu/drm/Kconfig                            |   19 +-
 drivers/gpu/drm/Makefile                           |    3 +
 drivers/gpu/drm/ast/ast_drv.h                      |    1 -
 drivers/gpu/drm/ast/ast_mode.c                     |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.h                |    1 -
 drivers/gpu/drm/drm_cache.c                        |   28 +-
 drivers/gpu/drm/drm_crtc.c                         |  139 +-
 drivers/gpu/drm/drm_drv.c                          |   22 +-
 drivers/gpu/drm/drm_edid.c                         |  208 +-
 drivers/gpu/drm/drm_edid_load.c                    |   29 +-
 drivers/gpu/drm/drm_edid_modes.h                   |   42 +-
 drivers/gpu/drm/drm_fb_cma_helper.c                |  406 ++
 drivers/gpu/drm/drm_fb_helper.c                    |   10 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |  251 ++
 drivers/gpu/drm/drm_irq.c                          |    2 +-
 drivers/gpu/drm/drm_vm.c                           |   11 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c      |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   13 -
 drivers/gpu/drm/gma500/Makefile                    |    5 +-
 drivers/gpu/drm/gma500/backlight.c                 |   45 +
 drivers/gpu/drm/gma500/cdv_device.c                |   72 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |  236 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              | 1950 +++++++++
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c            |    6 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   12 +-
 drivers/gpu/drm/gma500/framebuffer.c               |    7 +
 drivers/gpu/drm/gma500/gem.c                       |    9 +-
 drivers/gpu/drm/gma500/gem_glue.c                  |   90 -
 drivers/gpu/drm/gma500/gem_glue.h                  |    2 -
 drivers/gpu/drm/gma500/intel_bios.c                |  101 +
 drivers/gpu/drm/gma500/intel_bios.h                |   46 +
 drivers/gpu/drm/gma500/mdfld_dsi_output.c          |   13 +-
 drivers/gpu/drm/gma500/mid_bios.c                  |    8 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |    1 -
 drivers/gpu/drm/gma500/opregion.c                  |    3 +-
 drivers/gpu/drm/gma500/psb_device.c                |    1 +
 drivers/gpu/drm/gma500/psb_drv.h                   |   20 +-
 drivers/gpu/drm/gma500/psb_intel_drv.h             |   28 +-
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   13 +-
 drivers/gpu/drm/gma500/psb_intel_reg.h             |  197 +-
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |    4 -
 drivers/gpu/drm/i2c/ch7006_drv.c                   |   16 +-
 drivers/gpu/drm/i915/Makefile                      |    1 +
 drivers/gpu/drm/i915/dvo.h                         |   16 +-
 drivers/gpu/drm/i915/dvo_ch7017.c                  |   21 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |   17 +-
 drivers/gpu/drm/i915/dvo_ivch.c                    |   23 +-
 drivers/gpu/drm/i915/dvo_ns2501.c                  |  588 +++
 drivers/gpu/drm/i915/dvo_sil164.c                  |   20 +-
 drivers/gpu/drm/i915/dvo_tfp410.c                  |   18 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  251 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   73 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   61 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  239 +-
 drivers/gpu/drm/i915/i915_gem.c                    | 1548 ++++---
 drivers/gpu/drm/i915/i915_gem_context.c            |   65 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |  174 +-
 drivers/gpu/drm/i915/i915_gem_evict.c              |   44 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  391 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  144 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   16 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  194 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  328 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |  220 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   25 +-
 drivers/gpu/drm/i915/intel_crt.c                   |  165 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  144 +-
 drivers/gpu/drm/i915/intel_display.c               | 2173 ++++++---
 drivers/gpu/drm/i915/intel_dp.c                    |  401 +-
 drivers/gpu/drm/i915/intel_drv.h                   |  147 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |  115 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  221 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   99 +-
 drivers/gpu/drm/i915/intel_modes.c                 |    1 -
 drivers/gpu/drm/i915/intel_opregion.c              |   23 +-
 drivers/gpu/drm/i915/intel_overlay.c               |   60 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  420 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  152 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   20 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  210 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   70 +-
 drivers/gpu/drm/mgag200/mgag200_drv.h              |    1 -
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    1 -
 drivers/gpu/drm/nouveau/Kconfig                    |   36 +-
 drivers/gpu/drm/nouveau/Makefile                   |  225 +-
 drivers/gpu/drm/nouveau/core/core/client.c         |  103 +
 drivers/gpu/drm/nouveau/core/core/engctx.c         |  236 +
 drivers/gpu/drm/nouveau/core/core/engine.c         |   55 +
 .../nouveau/{nouveau_util.c => core/core/enum.c}   |   47 +-
 drivers/gpu/drm/nouveau/core/core/gpuobj.c         |  318 ++
 drivers/gpu/drm/nouveau/core/core/handle.c         |  223 +
 .../drm/nouveau/{nouveau_mm.c => core/core/mm.c}   |  174 +-
 drivers/gpu/drm/nouveau/core/core/namedb.c         |  203 +
 drivers/gpu/drm/nouveau/core/core/object.c         |  468 ++
 drivers/gpu/drm/nouveau/core/core/option.c         |  131 +
 drivers/gpu/drm/nouveau/core/core/parent.c         |  139 +
 drivers/gpu/drm/nouveau/core/core/printk.c         |   74 +
 drivers/gpu/drm/nouveau/core/core/ramht.c          |  109 +
 drivers/gpu/drm/nouveau/core/core/subdev.c         |  115 +
 drivers/gpu/drm/nouveau/core/engine/bsp/nv84.c     |  175 +
 .../engine/copy/fuc/nva3.fuc}                      |    0
 .../engine/copy/fuc/nva3.fuc.h}                    |    4 +-
 .../engine/copy/fuc/nvc0.fuc.h}                    |    4 +-
 drivers/gpu/drm/nouveau/core/engine/copy/nva3.c    |  222 +
 drivers/gpu/drm/nouveau/core/engine/copy/nvc0.c    |  265 ++
 drivers/gpu/drm/nouveau/core/engine/copy/nve0.c    |  156 +
 .../engine/crypt/fuc/nv98.fuc}                     |    2 +-
 .../engine/crypt/fuc/nv98.fuc.h}                   |    4 +-
 drivers/gpu/drm/nouveau/core/engine/crypt/nv84.c   |  217 +
 drivers/gpu/drm/nouveau/core/engine/crypt/nv98.c   |  208 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c    |   90 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |  125 +
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c    |  118 +
 drivers/gpu/drm/nouveau/core/engine/disp/vga.c     |  215 +
 drivers/gpu/drm/nouveau/core/engine/dmaobj/base.c  |   87 +
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nv04.c  |  185 +
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nv50.c  |  173 +
 drivers/gpu/drm/nouveau/core/engine/dmaobj/nvc0.c  |   99 +
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |  181 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.c    |  630 +++
 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.h    |  178 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv10.c    |  171 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv17.c    |  208 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv40.c    |  349 ++
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c    |  502 +++
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.h    |   36 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |  420 ++
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c    |  647 +++
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |  628 +++
 .../{nouveau_grctx.h => core/engine/graph/ctx.h}   |   26 +-
 .../{nv40_grctx.c => core/engine/graph/ctxnv40.c}  |  133 +-
 .../{nv50_grctx.c => core/engine/graph/ctxnv50.c}  |  561 ++-
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.c    | 3039 +++++++++++++
 .../gpu/drm/nouveau/core/engine/graph/ctxnve0.c    | 2788 ++++++++++++
 .../engine/graph/fuc/gpcnvc0.fuc}                  |    8 +-
 .../engine/graph/fuc/gpcnvc0.fuc.h}                |   66 +
 .../drm/nouveau/core/engine/graph/fuc/gpcnve0.fuc  |  451 ++
 .../nouveau/core/engine/graph/fuc/gpcnve0.fuc.h    |  530 +++
 .../engine/graph/fuc/hubnvc0.fuc}                  |    8 +-
 .../engine/graph/fuc/hubnvc0.fuc.h}                |   89 +
 .../drm/nouveau/core/engine/graph/fuc/hubnve0.fuc  |  780 ++++
 .../nouveau/core/engine/graph/fuc/hubnve0.fuc.h    |  857 ++++
 .../engine/graph/fuc/nvc0.fuc}                     |    0
 .../gpu/drm/nouveau/core/engine/graph/fuc/nve0.fuc |  400 ++
 drivers/gpu/drm/nouveau/core/engine/graph/nv04.c   | 1387 ++++++
 drivers/gpu/drm/nouveau/core/engine/graph/nv10.c   | 1314 ++++++
 drivers/gpu/drm/nouveau/core/engine/graph/nv20.c   |  381 ++
 drivers/gpu/drm/nouveau/core/engine/graph/nv20.h   |   31 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv25.c   |  167 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv2a.c   |  134 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv30.c   |  238 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv34.c   |  168 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv35.c   |  166 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c   |  495 +++
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.h   |   21 +
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c   |  888 ++++
 drivers/gpu/drm/nouveau/core/engine/graph/nv50.h   |    7 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  955 ++++
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |  171 +
 drivers/gpu/drm/nouveau/core/engine/graph/nve0.c   |  576 +++
 drivers/gpu/drm/nouveau/core/engine/graph/regs.h   |  269 ++
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv31.c    |  308 ++
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv40.c    |  144 +
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv50.c    |  240 +
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv84.c    |  104 +
 drivers/gpu/drm/nouveau/core/engine/ppp/nv98.c     |  175 +
 .../gpu/drm/nouveau/core/engine/software/nv04.c    |  147 +
 .../gpu/drm/nouveau/core/engine/software/nv10.c    |  129 +
 .../gpu/drm/nouveau/core/engine/software/nv50.c    |  199 +
 .../gpu/drm/nouveau/core/engine/software/nvc0.c    |  181 +
 drivers/gpu/drm/nouveau/core/engine/vp/nv84.c      |  175 +
 drivers/gpu/drm/nouveau/core/include/core/class.h  |  118 +
 drivers/gpu/drm/nouveau/core/include/core/client.h |   42 +
 drivers/gpu/drm/nouveau/core/include/core/debug.h  |   13 +
 drivers/gpu/drm/nouveau/core/include/core/device.h |  136 +
 drivers/gpu/drm/nouveau/core/include/core/engctx.h |   51 +
 drivers/gpu/drm/nouveau/core/include/core/engine.h |   57 +
 drivers/gpu/drm/nouveau/core/include/core/enum.h   |   23 +
 drivers/gpu/drm/nouveau/core/include/core/gpuobj.h |   71 +
 drivers/gpu/drm/nouveau/core/include/core/handle.h |   31 +
 drivers/gpu/drm/nouveau/core/include/core/math.h   |   16 +
 drivers/gpu/drm/nouveau/core/include/core/mm.h     |   33 +
 drivers/gpu/drm/nouveau/core/include/core/namedb.h |   56 +
 drivers/gpu/drm/nouveau/core/include/core/object.h |  188 +
 drivers/gpu/drm/nouveau/core/include/core/option.h |   11 +
 drivers/gpu/drm/nouveau/core/include/core/parent.h |   64 +
 drivers/gpu/drm/nouveau/core/include/core/printk.h |   39 +
 drivers/gpu/drm/nouveau/core/include/core/ramht.h  |   23 +
 drivers/gpu/drm/nouveau/core/include/core/subdev.h |  118 +
 drivers/gpu/drm/nouveau/core/include/engine/bsp.h  |   45 +
 drivers/gpu/drm/nouveau/core/include/engine/copy.h |   49 +
 .../gpu/drm/nouveau/core/include/engine/crypt.h    |   46 +
 drivers/gpu/drm/nouveau/core/include/engine/disp.h |   44 +
 .../gpu/drm/nouveau/core/include/engine/dmaobj.h   |   57 +
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |  111 +
 .../gpu/drm/nouveau/core/include/engine/graph.h    |   72 +
 drivers/gpu/drm/nouveau/core/include/engine/mpeg.h |   61 +
 drivers/gpu/drm/nouveau/core/include/engine/ppp.h  |   45 +
 .../gpu/drm/nouveau/core/include/engine/software.h |   60 +
 drivers/gpu/drm/nouveau/core/include/engine/vp.h   |   45 +
 drivers/gpu/drm/nouveau/core/include/subdev/bar.h  |   55 +
 drivers/gpu/drm/nouveau/core/include/subdev/bios.h |   34 +
 .../gpu/drm/nouveau/core/include/subdev/bios/bit.h |   13 +
 .../gpu/drm/nouveau/core/include/subdev/bios/bmp.h |   39 +
 .../drm/nouveau/core/include/subdev/bios/conn.h    |   27 +
 .../gpu/drm/nouveau/core/include/subdev/bios/dcb.h |   90 +
 .../gpu/drm/nouveau/core/include/subdev/bios/dp.h  |    8 +
 .../drm/nouveau/core/include/subdev/bios/extdev.h  |   30 +
 .../drm/nouveau/core/include/subdev/bios/gpio.h    |   33 +
 .../gpu/drm/nouveau/core/include/subdev/bios/i2c.h |   25 +
 .../drm/nouveau/core/include/subdev/bios/init.h    |   21 +
 .../gpu/drm/nouveau/core/include/subdev/bios/mxm.h |    9 +
 .../drm/nouveau/core/include/subdev/bios/perf.h    |   14 +
 .../gpu/drm/nouveau/core/include/subdev/bios/pll.h |   77 +
 .../drm/nouveau/core/include/subdev/bios/therm.h   |   46 +
 .../gpu/drm/nouveau/core/include/subdev/clock.h    |   59 +
 .../gpu/drm/nouveau/core/include/subdev/device.h   |   24 +
 .../gpu/drm/nouveau/core/include/subdev/devinit.h  |   40 +
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |  134 +
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |   64 +
 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h  |   60 +
 drivers/gpu/drm/nouveau/core/include/subdev/ibus.h |   34 +
 .../gpu/drm/nouveau/core/include/subdev/instmem.h  |   73 +
 drivers/gpu/drm/nouveau/core/include/subdev/ltcg.h |   33 +
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |   49 +
 drivers/gpu/drm/nouveau/core/include/subdev/mxm.h  |   37 +
 .../gpu/drm/nouveau/core/include/subdev/therm.h    |   58 +
 .../gpu/drm/nouveau/core/include/subdev/timer.h    |   53 +
 drivers/gpu/drm/nouveau/core/include/subdev/vga.h  |   30 +
 .../{nouveau_vm.h => core/include/subdev/vm.h}     |   87 +-
 drivers/gpu/drm/nouveau/core/os.h                  |   47 +
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |  135 +
 drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c     |  263 ++
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     |  215 +
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |  479 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/bit.c     |   52 +
 drivers/gpu/drm/nouveau/core/subdev/bios/conn.c    |   56 +
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |  135 +
 drivers/gpu/drm/nouveau/core/subdev/bios/dp.c      |   76 +
 drivers/gpu/drm/nouveau/core/subdev/bios/extdev.c  |  100 +
 drivers/gpu/drm/nouveau/core/subdev/bios/gpio.c    |  121 +
 drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c     |  129 +
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    | 2120 +++++++++
 drivers/gpu/drm/nouveau/core/subdev/bios/mxm.c     |  135 +
 drivers/gpu/drm/nouveau/core/subdev/bios/perf.c    |   75 +
 drivers/gpu/drm/nouveau/core/subdev/bios/pll.c     |  417 ++
 drivers/gpu/drm/nouveau/core/subdev/bios/therm.c   |  177 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c   |  359 ++
 .../{nouveau_ramht.h => core/subdev/clock/nv40.c}  |   56 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c   |  105 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c   |   95 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c   |   94 +
 drivers/gpu/drm/nouveau/core/subdev/clock/pll.h    |    9 +
 .../gpu/drm/nouveau/core/subdev/clock/pllnv04.c    |  242 +
 .../{nv50_calc.c => core/subdev/clock/pllnva3.c}   |   69 +-
 drivers/gpu/drm/nouveau/core/subdev/device/base.c  |  472 ++
 drivers/gpu/drm/nouveau/core/subdev/device/nv04.c  |   86 +
 drivers/gpu/drm/nouveau/core/subdev/device/nv10.c  |  195 +
 drivers/gpu/drm/nouveau/core/subdev/device/nv20.c  |  126 +
 drivers/gpu/drm/nouveau/core/subdev/device/nv30.c  |  147 +
 drivers/gpu/drm/nouveau/core/subdev/device/nv40.c  |  375 ++
 drivers/gpu/drm/nouveau/core/subdev/device/nv50.c  |  410 ++
 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c  |  285 ++
 drivers/gpu/drm/nouveau/core/subdev/device/nve0.c  |  109 +
 .../{nv98_ppp.c => core/subdev/devinit/base.c}     |   69 +-
 .../gpu/drm/nouveau/core/subdev/devinit/fbmem.h    |   98 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c |  189 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c |  159 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c |  124 +
 .../{nouveau_i2c.h => core/subdev/devinit/nv1a.c}  |   65 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c |   96 +
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.c |   87 +
 drivers/gpu/drm/nouveau/core/subdev/fb/base.c      |  130 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv04.c      |  130 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv10.c      |  120 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv20.c      |  136 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv30.c      |  148 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv40.c      |  178 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |  498 +++
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |  245 ++
 drivers/gpu/drm/nouveau/core/subdev/gpio/base.c    |  271 ++
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv10.c    |  169 +
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv50.c    |  194 +
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |  104 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c      |  212 +
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |  407 ++
 drivers/gpu/drm/nouveau/core/subdev/i2c/bit.c      |  230 +
 drivers/gpu/drm/nouveau/core/subdev/ibus/nvc0.c    |  123 +
 drivers/gpu/drm/nouveau/core/subdev/ibus/nve0.c    |  123 +
 drivers/gpu/drm/nouveau/core/subdev/instmem/base.c |  135 +
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.c |  198 +
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.h |   39 +
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c |  138 +
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv50.c |  172 +
 drivers/gpu/drm/nouveau/core/subdev/ltcg/nvc0.c    |   93 +
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c      |   49 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c      |   83 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c      |   74 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |   80 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |   73 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |   75 +
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c     |  290 ++
 drivers/gpu/drm/nouveau/core/subdev/mxm/mxms.c     |  193 +
 drivers/gpu/drm/nouveau/core/subdev/mxm/mxms.h     |   22 +
 drivers/gpu/drm/nouveau/core/subdev/mxm/nv50.c     |  233 +
 drivers/gpu/drm/nouveau/core/subdev/therm/base.c   |  144 +
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c    |  234 +
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c     |  116 +
 drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c   |  163 +
 drivers/gpu/drm/nouveau/core/subdev/therm/nv50.c   |  157 +
 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h   |   73 +
 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c   |   81 +
 drivers/gpu/drm/nouveau/core/subdev/timer/base.c   |   87 +
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |  249 ++
 .../{nouveau_vm.c => core/subdev/vm/base.c}        |  163 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nv04.c      |  151 +
 drivers/gpu/drm/nouveau/core/subdev/vm/nv04.h      |   19 +
 drivers/gpu/drm/nouveau/core/subdev/vm/nv41.c      |  158 +
 drivers/gpu/drm/nouveau/core/subdev/vm/nv44.c      |  248 ++
 .../nouveau/{nv50_vm.c => core/subdev/vm/nv50.c}   |  118 +-
 .../nouveau/{nvc0_vm.c => core/subdev/vm/nvc0.c}   |  123 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |  426 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.h            |   32 +
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   26 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.h             |   22 +
 drivers/gpu/drm/nouveau/nouveau_agp.c              |  152 +
 drivers/gpu/drm/nouveau/nouveau_agp.h              |   10 +
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |   94 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             | 4614 +-------------------
 drivers/gpu/drm/nouveau/nouveau_bios.h             |  178 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  439 +-
 drivers/gpu/drm/nouveau/nouveau_bo.h               |   99 +
 drivers/gpu/drm/nouveau/nouveau_calc.c             |  234 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |  400 ++
 drivers/gpu/drm/nouveau/nouveau_chan.h             |   47 +
 drivers/gpu/drm/nouveau/nouveau_channel.c          |  396 --
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  219 +-
 drivers/gpu/drm/nouveau/nouveau_connector.h        |    5 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |  196 -
 drivers/gpu/drm/nouveau/nouveau_display.c          |  259 +-
 drivers/gpu/drm/nouveau/nouveau_display.h          |   94 +
 drivers/gpu/drm/nouveau/nouveau_dma.c              |   55 +-
 drivers/gpu/drm/nouveau/nouveau_dma.h              |   51 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |  280 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  693 +++
 drivers/gpu/drm/nouveau/nouveau_drm.h              |  144 +
 drivers/gpu/drm/nouveau/nouveau_drv.c              |  512 ---
 drivers/gpu/drm/nouveau/nouveau_drv.h              | 1655 -------
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |   21 +-
 drivers/gpu/drm/nouveau/nouveau_fb.h               |   47 -
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |  226 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.h            |    3 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   27 +-
 drivers/gpu/drm/nouveau/nouveau_fence.h            |   41 +-
 drivers/gpu/drm/nouveau/nouveau_fifo.h             |   32 -
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  178 +-
 drivers/gpu/drm/nouveau/nouveau_gem.h              |   43 +
 drivers/gpu/drm/nouveau/nouveau_gpio.c             |  400 --
 drivers/gpu/drm/nouveau/nouveau_gpio.h             |   71 -
 drivers/gpu/drm/nouveau/nouveau_gpuobj.c           |  807 ----
 drivers/gpu/drm/nouveau/nouveau_hdmi.c             |   41 +-
 drivers/gpu/drm/nouveau/nouveau_hw.c               |  435 +-
 drivers/gpu/drm/nouveau/nouveau_hw.h               |  182 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.c              |  394 --
 drivers/gpu/drm/nouveau/nouveau_ioc32.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_ioctl.h            |    6 +
 drivers/gpu/drm/nouveau/nouveau_irq.c              |  132 +-
 drivers/gpu/drm/nouveau/nouveau_irq.h              |   11 +
 drivers/gpu/drm/nouveau/nouveau_mem.c              |  739 +---
 drivers/gpu/drm/nouveau/nouveau_mm.h               |   67 -
 drivers/gpu/drm/nouveau/nouveau_mxm.c              |  723 ---
 drivers/gpu/drm/nouveau/nouveau_notifier.c         |  162 -
 drivers/gpu/drm/nouveau/nouveau_perf.c             |   65 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c               |  462 +-
 drivers/gpu/drm/nouveau/nouveau_pm.h               |  186 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   10 +-
 drivers/gpu/drm/nouveau/nouveau_ramht.c            |  309 --
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |  377 +-
 drivers/gpu/drm/nouveau/nouveau_software.h         |   56 -
 drivers/gpu/drm/nouveau/nouveau_state.c            | 1304 ------
 drivers/gpu/drm/nouveau/nouveau_temp.c             |  331 --
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |  354 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.h              |   25 +
 drivers/gpu/drm/nouveau/nouveau_util.h             |   49 -
 drivers/gpu/drm/nouveau/nouveau_vga.c              |   99 +
 drivers/gpu/drm/nouveau/nouveau_vga.h              |    8 +
 drivers/gpu/drm/nouveau/nouveau_volt.c             |   53 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c                |  142 +-
 drivers/gpu/drm/nouveau/nv04_cursor.c              |    8 +-
 drivers/gpu/drm/nouveau/nv04_dac.c                 |  148 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c                 |  132 +-
 drivers/gpu/drm/nouveau/nv04_display.c             |  129 +-
 drivers/gpu/drm/nouveau/nv04_display.h             |  184 +
 drivers/gpu/drm/nouveau/nv04_fb.c                  |   54 -
 drivers/gpu/drm/nouveau/nv04_fbcon.c               |   70 +-
 drivers/gpu/drm/nouveau/nv04_fence.c               |   67 +-
 drivers/gpu/drm/nouveau/nv04_fifo.c                |  505 ---
 drivers/gpu/drm/nouveau/nv04_graph.c               | 1325 ------
 drivers/gpu/drm/nouveau/nv04_instmem.c             |  192 -
 drivers/gpu/drm/nouveau/nv04_mc.c                  |   23 -
 drivers/gpu/drm/nouveau/nv04_pm.c                  |   37 +-
 drivers/gpu/drm/nouveau/nv04_software.c            |  147 -
 drivers/gpu/drm/nouveau/nv04_timer.c               |   83 -
 drivers/gpu/drm/nouveau/nv04_tv.c                  |   36 +-
 drivers/gpu/drm/nouveau/nv10_fb.c                  |  103 -
 drivers/gpu/drm/nouveau/nv10_fence.c               |  103 +-
 drivers/gpu/drm/nouveau/nv10_fifo.c                |  137 -
 drivers/gpu/drm/nouveau/nv10_gpio.c                |  123 -
 drivers/gpu/drm/nouveau/nv10_graph.c               | 1188 -----
 drivers/gpu/drm/nouveau/nv17_fifo.c                |  176 -
 drivers/gpu/drm/nouveau/nv17_tv.c                  |   98 +-
 drivers/gpu/drm/nouveau/nv17_tv.h                  |    6 +-
 drivers/gpu/drm/nouveau/nv17_tv_modes.c            |    5 +-
 drivers/gpu/drm/nouveau/nv20_fb.c                  |  147 -
 drivers/gpu/drm/nouveau/nv20_graph.c               |  835 ----
 drivers/gpu/drm/nouveau/nv30_fb.c                  |  115 -
 drivers/gpu/drm/nouveau/nv31_mpeg.c                |  346 --
 drivers/gpu/drm/nouveau/nv40_fb.c                  |  162 -
 drivers/gpu/drm/nouveau/nv40_fifo.c                |  209 -
 drivers/gpu/drm/nouveau/nv40_graph.c               |  466 --
 drivers/gpu/drm/nouveau/nv40_mc.c                  |   27 -
 drivers/gpu/drm/nouveau/nv40_pm.c                  |  182 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c                |  118 +-
 drivers/gpu/drm/nouveau/nv50_cursor.c              |   32 +-
 drivers/gpu/drm/nouveau/nv50_dac.c                 |   89 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |  551 +--
 drivers/gpu/drm/nouveau/nv50_display.h             |   31 +-
 drivers/gpu/drm/nouveau/nv50_evo.c                 |  268 +-
 drivers/gpu/drm/nouveau/nv50_fb.c                  |  295 --
 drivers/gpu/drm/nouveau/nv50_fbcon.c               |   36 +-
 drivers/gpu/drm/nouveau/nv50_fence.c               |  127 +
 drivers/gpu/drm/nouveau/nv50_fifo.c                |  293 --
 drivers/gpu/drm/nouveau/nv50_gpio.c                |  155 -
 drivers/gpu/drm/nouveau/nv50_graph.c               |  867 ----
 drivers/gpu/drm/nouveau/nv50_instmem.c             |  427 --
 drivers/gpu/drm/nouveau/nv50_mc.c                  |   39 -
 drivers/gpu/drm/nouveau/nv50_mpeg.c                |  241 -
 drivers/gpu/drm/nouveau/nv50_pm.c                  |  247 +-
 drivers/gpu/drm/nouveau/nv50_software.c            |  203 -
 drivers/gpu/drm/nouveau/nv50_sor.c                 |  133 +-
 drivers/gpu/drm/nouveau/nv50_vram.c                |  237 -
 drivers/gpu/drm/nouveau/nv84_bsp.c                 |   83 -
 drivers/gpu/drm/nouveau/nv84_crypt.c               |  205 -
 drivers/gpu/drm/nouveau/nv84_fence.c               |  127 +-
 drivers/gpu/drm/nouveau/nv84_fifo.c                |  249 --
 drivers/gpu/drm/nouveau/nv84_vp.c                  |   83 -
 drivers/gpu/drm/nouveau/nv98_crypt.c               |  216 -
 drivers/gpu/drm/nouveau/nva3_copy.c                |  203 -
 drivers/gpu/drm/nouveau/nva3_pm.c                  |  274 +-
 drivers/gpu/drm/nouveau/nvc0_copy.c                |  243 --
 drivers/gpu/drm/nouveau/nvc0_fb.c                  |  134 -
 drivers/gpu/drm/nouveau/nvc0_fbcon.c               |   31 +-
 drivers/gpu/drm/nouveau/nvc0_fence.c               |  150 +-
 drivers/gpu/drm/nouveau/nvc0_fifo.c                |  477 --
 drivers/gpu/drm/nouveau/nvc0_graph.c               |  897 ----
 drivers/gpu/drm/nouveau/nvc0_graph.h               |   97 -
 drivers/gpu/drm/nouveau/nvc0_grctx.c               | 2878 ------------
 drivers/gpu/drm/nouveau/nvc0_instmem.c             |  223 -
 drivers/gpu/drm/nouveau/nvc0_pm.c                  |  178 +-
 drivers/gpu/drm/nouveau/nvc0_software.c            |  153 -
 drivers/gpu/drm/nouveau/nvc0_vram.c                |  160 -
 drivers/gpu/drm/nouveau/nvd0_display.c             |  504 ++-
 drivers/gpu/drm/nouveau/nve0_fifo.c                |  453 --
 drivers/gpu/drm/nouveau/nve0_graph.c               |  831 ----
 drivers/gpu/drm/nouveau/nve0_graph.h               |   89 -
 drivers/gpu/drm/nouveau/nve0_grctx.c               | 2777 ------------
 drivers/gpu/drm/radeon/atombios_crtc.c             |  663 ++-
 drivers/gpu/drm/radeon/atombios_dp.c               |    4 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |  367 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  282 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   61 +-
 drivers/gpu/drm/radeon/evergreen_reg.h             |    2 +
 drivers/gpu/drm/radeon/evergreend.h                |    7 +
 drivers/gpu/drm/radeon/ni.c                        |  134 +-
 drivers/gpu/drm/radeon/nid.h                       |    1 +
 drivers/gpu/drm/radeon/r100.c                      |   96 +-
 drivers/gpu/drm/radeon/r300.c                      |    4 +-
 drivers/gpu/drm/radeon/r520.c                      |    4 +-
 drivers/gpu/drm/radeon/r600.c                      |   37 +-
 drivers/gpu/drm/radeon/r600_blit.c                 |  115 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c             |   52 +-
 drivers/gpu/drm/radeon/r600_blit_shaders.h         |    1 +
 drivers/gpu/drm/radeon/r600_cs.c                   |    5 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon.h                    |  192 +-
 drivers/gpu/drm/radeon/radeon_acpi.c               |  607 ++-
 drivers/gpu/drm/radeon/radeon_acpi.h               |  445 ++
 drivers/gpu/drm/radeon/radeon_asic.c               |   93 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   28 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   15 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |  411 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |    9 -
 drivers/gpu/drm/radeon/radeon_connectors.c         |   43 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   83 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   11 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |    4 +-
 drivers/gpu/drm/radeon/radeon_encoders.c           |   19 +-
 drivers/gpu/drm/radeon/radeon_fb.c                 |   16 -
 drivers/gpu/drm/radeon/radeon_fence.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |  602 ++-
 drivers/gpu/drm/radeon/radeon_gem.c                |   54 +-
 drivers/gpu/drm/radeon/radeon_ioc32.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |   43 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   17 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |    7 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |   65 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |   49 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   22 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    4 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  104 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   30 +-
 drivers/gpu/drm/radeon/radeon_sa.c                 |   20 +-
 drivers/gpu/drm/radeon/radeon_test.c               |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |    2 +-
 drivers/gpu/drm/radeon/rs400.c                     |    6 +-
 drivers/gpu/drm/radeon/rs600.c                     |   49 +-
 drivers/gpu/drm/radeon/rs690.c                     |    6 +-
 drivers/gpu/drm/radeon/rv515.c                     |   18 +-
 drivers/gpu/drm/radeon/rv770.c                     |   10 +-
 drivers/gpu/drm/radeon/si.c                        |  113 +-
 drivers/gpu/drm/radeon/sid.h                       |   15 +
 drivers/gpu/drm/savage/savage_bci.c                |    2 +
 drivers/gpu/drm/shmobile/Kconfig                   |   10 +
 drivers/gpu/drm/shmobile/Makefile                  |    7 +
 drivers/gpu/drm/shmobile/shmob_drm_backlight.c     |   90 +
 drivers/gpu/drm/shmobile/shmob_drm_backlight.h     |   23 +
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c          |  763 ++++
 drivers/gpu/drm/shmobile/shmob_drm_crtc.h          |   60 +
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |  361 ++
 drivers/gpu/drm/shmobile/shmob_drm_drv.h           |   47 +
 drivers/gpu/drm/shmobile/shmob_drm_kms.c           |  160 +
 drivers/gpu/drm/shmobile/shmob_drm_kms.h           |   34 +
 drivers/gpu/drm/shmobile/shmob_drm_plane.c         |  268 ++
 drivers/gpu/drm/shmobile/shmob_drm_plane.h         |   22 +
 drivers/gpu/drm/shmobile/shmob_drm_regs.h          |  311 ++
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |    5 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |   16 +-
 drivers/gpu/drm/udl/udl_connector.c                |    3 -
 drivers/gpu/drm/udl/udl_encoder.c                  |    2 +-
 drivers/gpu/drm/udl/udl_fb.c                       |   26 +-
 drivers/gpu/drm/udl/udl_gem.c                      |    7 -
 drivers/gpu/drm/udl/udl_main.c                     |    7 +-
 drivers/gpu/drm/udl/udl_modeset.c                  |    2 +-
 drivers/gpu/drm/udl/udl_transfer.c                 |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    1 -
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    1 -
 drivers/staging/omapdrm/omap_connector.c           |    5 +-
 drivers/staging/omapdrm/omap_fbdev.c               |    4 +-
 include/drm/drmP.h                                 |    1 +
 include/drm/drm_crtc.h                             |   24 +-
 include/drm/drm_fb_cma_helper.h                    |   27 +
 include/drm/drm_fourcc.h                           |    2 +
 include/drm/drm_gem_cma_helper.h                   |   44 +
 include/drm/drm_sarea.h                            |    2 +
 include/drm/i915_drm.h                             |   36 +-
 include/drm/intel-gtt.h                            |   10 +-
 include/linux/platform_data/shmob_drm.h            |   99 +
 562 files changed, 71126 insertions(+), 43374 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_fb_cma_helper.c
 create mode 100644 drivers/gpu/drm/drm_gem_cma_helper.c
 create mode 100644 drivers/gpu/drm/gma500/cdv_intel_dp.c
 delete mode 100644 drivers/gpu/drm/gma500/gem_glue.c
 delete mode 100644 drivers/gpu/drm/gma500/gem_glue.h
 create mode 100644 drivers/gpu/drm/i915/dvo_ns2501.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/client.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/engctx.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/engine.c
 rename drivers/gpu/drm/nouveau/{nouveau_util.c => core/core/enum.c} (86%)
 create mode 100644 drivers/gpu/drm/nouveau/core/core/gpuobj.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/handle.c
 rename drivers/gpu/drm/nouveau/{nouveau_mm.c => core/core/mm.c} (53%)
 create mode 100644 drivers/gpu/drm/nouveau/core/core/namedb.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/object.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/option.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/parent.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/printk.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/ramht.c
 create mode 100644 drivers/gpu/drm/nouveau/core/core/subdev.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/bsp/nv84.c
 rename drivers/gpu/drm/nouveau/{nva3_copy.fuc => core/engine/copy/fuc/nva3.fuc} (100%)
 rename drivers/gpu/drm/nouveau/{nva3_copy.fuc.h => core/engine/copy/fuc/nva3.fuc.h} (99%)
 rename drivers/gpu/drm/nouveau/{nvc0_copy.fuc.h => core/engine/copy/fuc/nvc0.fuc.h} (99%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/copy/nva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/copy/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/copy/nve0.c
 rename drivers/gpu/drm/nouveau/{nv98_crypt.fuc => core/engine/crypt/fuc/nv98.fuc} (99%)
 rename drivers/gpu/drm/nouveau/{nv98_crypt.fuc.h => core/engine/crypt/fuc/nv98.fuc.h} (99%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/crypt/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/crypt/nv98.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/disp/vga.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/dmaobj/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/dmaobj/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/dmaobj/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/dmaobj/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv10.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv17.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
 rename drivers/gpu/drm/nouveau/{nouveau_grctx.h => core/engine/graph/ctx.h} (84%)
 rename drivers/gpu/drm/nouveau/{nv40_grctx.c => core/engine/graph/ctxnv40.c} (85%)
 rename drivers/gpu/drm/nouveau/{nv50_grctx.c => core/engine/graph/ctxnv50.c} (91%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxnve0.c
 rename drivers/gpu/drm/nouveau/{nvc0_grgpc.fuc => core/engine/graph/fuc/gpcnvc0.fuc} (98%)
 rename drivers/gpu/drm/nouveau/{nvc0_grgpc.fuc.h => core/engine/graph/fuc/gpcnvc0.fuc.h} (78%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcnve0.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/gpcnve0.fuc.h
 rename drivers/gpu/drm/nouveau/{nvc0_grhub.fuc => core/engine/graph/fuc/hubnvc0.fuc} (99%)
 rename drivers/gpu/drm/nouveau/{nvc0_grhub.fuc.h => core/engine/graph/fuc/hubnvc0.fuc.h} (81%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubnve0.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/hubnve0.fuc.h
 rename drivers/gpu/drm/nouveau/{nvc0_graph.fuc => core/engine/graph/fuc/nvc0.fuc} (100%)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/fuc/nve0.fuc
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv10.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv20.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv25.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv2a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv30.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv34.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv35.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv40.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nv50.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/regs.h
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/mpeg/nv31.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/mpeg/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/mpeg/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/mpeg/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/ppp/nv98.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/software/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/software/nv10.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/software/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/software/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/vp/nv84.c
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/class.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/client.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/debug.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/device.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/engctx.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/engine.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/enum.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/gpuobj.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/handle.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/math.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/mm.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/namedb.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/object.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/option.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/parent.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/printk.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/ramht.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/core/subdev.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/bsp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/copy.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/crypt.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/disp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/dmaobj.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/fifo.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/graph.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/mpeg.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/ppp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/software.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/engine/vp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bar.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/bit.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/bmp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/conn.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/dcb.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/dp.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/extdev.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/gpio.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/i2c.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/init.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/mxm.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/perf.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/pll.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/bios/therm.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/clock.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/device.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/devinit.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/fb.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/ibus.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/instmem.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/ltcg.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/mc.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/mxm.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/therm.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/timer.h
 create mode 100644 drivers/gpu/drm/nouveau/core/include/subdev/vga.h
 rename drivers/gpu/drm/nouveau/{nouveau_vm.h => core/include/subdev/vm.h} (60%)
 create mode 100644 drivers/gpu/drm/nouveau/core/os.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bar/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/bit.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/conn.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/dp.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/extdev.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/gpio.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/init.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/mxm.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/perf.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/pll.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bios/therm.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c
 rename drivers/gpu/drm/nouveau/{nouveau_ramht.h => core/subdev/clock/nv40.c} (55%)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/pll.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/pllnv04.c
 rename drivers/gpu/drm/nouveau/{nv50_calc.c => core/subdev/clock/pllnva3.c} (52%)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/nv10.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/nv20.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/nv30.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/device/nve0.c
 rename drivers/gpu/drm/nouveau/{nv98_ppp.c => core/subdev/devinit/base.c} (52%)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/fbmem.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c
 rename drivers/gpu/drm/nouveau/{nouveau_i2c.h => core/subdev/devinit/nv1a.c} (52%)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv10.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv20.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv30.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/nv10.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/bit.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/nve0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/instmem/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/instmem/nv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/instmem/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ltcg/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mxm/mxms.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mxm/mxms.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/mxm/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/nv50.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/timer/base.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
 rename drivers/gpu/drm/nouveau/{nouveau_vm.c => core/subdev/vm/base.c} (72%)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/vm/nv04.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/vm/nv04.h
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/vm/nv41.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/vm/nv44.c
 rename drivers/gpu/drm/nouveau/{nv50_vm.c => core/subdev/vm/nv50.c} (59%)
 rename drivers/gpu/drm/nouveau/{nvc0_vm.c => core/subdev/vm/nvc0.c} (53%)
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_acpi.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_agp.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_agp.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_bo.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_chan.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_chan.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_channel.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_debugfs.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_display.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_drm.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_drm.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_drv.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_drv.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_fb.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_fifo.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_gem.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_gpio.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_gpio.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_gpuobj.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_i2c.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_ioctl.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_irq.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_mm.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_mxm.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_notifier.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_ramht.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_software.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_state.c
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_temp.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_ttm.h
 delete mode 100644 drivers/gpu/drm/nouveau/nouveau_util.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_vga.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_vga.h
 create mode 100644 drivers/gpu/drm/nouveau/nv04_display.h
 delete mode 100644 drivers/gpu/drm/nouveau/nv04_fb.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv04_fifo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv04_graph.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv04_instmem.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv04_mc.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv04_software.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv04_timer.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv10_fb.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv10_fifo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv10_gpio.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv10_graph.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv17_fifo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv20_fb.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv20_graph.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv30_fb.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv31_mpeg.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv40_fb.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv40_fifo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv40_graph.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv40_mc.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_fb.c
 create mode 100644 drivers/gpu/drm/nouveau/nv50_fence.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_fifo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_gpio.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_graph.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_instmem.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_mc.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_mpeg.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_software.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv50_vram.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv84_bsp.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv84_crypt.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv84_fifo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv84_vp.c
 delete mode 100644 drivers/gpu/drm/nouveau/nv98_crypt.c
 delete mode 100644 drivers/gpu/drm/nouveau/nva3_copy.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_copy.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_fb.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_fifo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_graph.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_graph.h
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_grctx.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_instmem.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_software.c
 delete mode 100644 drivers/gpu/drm/nouveau/nvc0_vram.c
 delete mode 100644 drivers/gpu/drm/nouveau/nve0_fifo.c
 delete mode 100644 drivers/gpu/drm/nouveau/nve0_graph.c
 delete mode 100644 drivers/gpu/drm/nouveau/nve0_graph.h
 delete mode 100644 drivers/gpu/drm/nouveau/nve0_grctx.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_acpi.h
 create mode 100644 drivers/gpu/drm/shmobile/Kconfig
 create mode 100644 drivers/gpu/drm/shmobile/Makefile
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_backlight.c
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_backlight.h
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_crtc.c
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_crtc.h
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_drv.c
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_drv.h
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_kms.c
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_kms.h
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_plane.c
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_plane.h
 create mode 100644 drivers/gpu/drm/shmobile/shmob_drm_regs.h
 create mode 100644 include/drm/drm_fb_cma_helper.h
 create mode 100644 include/drm/drm_gem_cma_helper.h
 create mode 100644 include/linux/platform_data/shmob_drm.h
--29444707-1680291690-1349323728=:3115--
