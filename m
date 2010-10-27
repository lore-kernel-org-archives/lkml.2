Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab0J0B2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:28:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51568 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222Ab0J0B2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:28:47 -0400
Date: Wed, 27 Oct 2010 02:28:34 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm tree for merge window
In-Reply-To: <alpine.DEB.2.00.1010270214140.28394@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1010270228090.28394@skynet.skynet.ie>
References: <alpine.DEB.2.00.1010270214140.28394@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1800553809-1288142914=:28394"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1800553809-1288142914=:28394
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


This time with a subject line.

> 
> Hi Linus,
> 
> sorry this is a bit later than I expected got sidetracked into a real-life 
> gastro bug for a couple of days just after merge window opened,
> 
> Main features amongst it all:
> new stub driver for poulsbo backlight support
> drm core: kdb lut support, lots of cleanups, edid enhancement for audio 
> capability
> ttm: optimised eviction process (saves a lot of unnecessary object 
> movement) + allow an alternate underlying memory manager to be plugged in
> vmware: bring in line with upstream changes + use alternate memory manager
> nouveau: iniital power management support, hardware inter-channel sync,
> better handling of gpu errors and non-mappable VRAM, tiling corruption 
> fixes, nvaf support
> radeon: new fences on r6xx+, spread spectrum improvements on r5xx+ (DP 
> support and LVDS fixes), evergreen blit support, ppl fixes, lots of tiling 
> fixes
> intel: rework of AGP/DRM driver interfaces to be a lot cleaner, support 
> for using the whole GTT range instead of just the CPU mappable region
> lots of eDP fixes, unload fixes, DP audio support, also a lot of output 
> from the Chris Wilson bugfixing machine.
> 
> Dave.
> 
> The following changes since commit 2b666ca4a68cbc22483b0f2e1ba3c0e59b01ae9e:
> 
>   Merge branch 'fix/misc' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2010-10-17 09:38:08 -0700)
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next
> 
> Alex Deucher (18):
>       drm/radeon/kms: clean up r6xx/r7xx blit init (v2)
>       drm/radeon/kms: enable writeback (v2)
>       drm/radeon/kms/r6xx+: use new style fencing (v3)
>       drm/radeon/kms: properly handle 40 bit MC addresses in the cursor code
>       drm/radeon/kms: prefer high post dividers in legacy pll algo
>       drm/radeon/kms: remove some pll algo flags
>       drm/radeon/kms: remove new pll algo
>       drm/radeon/kms: rework spread spectrum handling
>       drm/radeon/kms: add drm blit support for evergreen
>       drm/radeon/kms: make sure blit addr masks are 64 bit
>       drm/radeon/kms: avivo cursor workaround applies to evergreen as well
>       drm/radeon/kms/evergreen: add some additional safe regs v2
>       drm/radeon/kms: implement display watermark support for evergreen
>       drm/radeon/kms: MC vram map needs to be >= pci aperture size
>       drm/radeon/kms/evergreen: set the clear state to the blit state
>       drm/radeon/kms: fix 2D tile height alignment in the r600 CS checker
>       drm/radeon/kms: properly compute group_size on 6xx/7xx
>       drm/radeon/kms: fix r6xx/7xx 1D tiling CS checker v2
> 
> Andrea Gelmini (1):
>       drivers: gpu: drm: i915: Fix a typo.
> 
> Ben Skeggs (56):
>       drm/nv50: add new accelerated bo move funtion
>       drm/nouveau: move check for no-op bo move before memcpy fallback
>       drm/nouveau: remove second map of notifier bo
>       drm/nouveau: require explicit unmap of kmapped bos
>       drm/nouveau: have nv_mask return original register value
>       drm/nouveau: move ramht code out of nouveau_object.c, nothing to see here
>       drm/nouveau: modify object accessors, offset in bytes rather than dwords
>       drm/nouveau: rebase per-channel pramin heap offsets to 0
>       drm/nouveau: remove nouveau_gpuobj_ref completely, replace with sanity
>       drm/nouveau: simplify fake gpu objects
>       drm/nv50: allow gpuobjs that aren't mapped into aperture
>       drm/nv50: calculate vram reordering block size
>       drm/nouveau: rework init ordering so nv50_instmem.c can be less bad
>       drm/nouveau: tidy ram{ht,fc,ro} a bit
>       drm/nouveau: add spinlock around ramht modifications
>       drm/nouveau: fix gpuobj refcount to use atomics
>       drm/nouveau: protect gpuobj list + global instmem heap with spinlock
>       drm/nouveau: remove nouveau_gpuobj_late_takedown
>       drm/nouveau: protect ramht_find() from oopsing if on channel without ramht
>       drm/nv50: move vm trap to nv50_fb.c
>       drm/nv50: report BAR access faults
>       drm/nv50: fix SOR count for early chipsets
>       drm/nouveau: better handling of unmappable vram
>       drm/nouveau: handle fifo pusher errors better
>       drm/nouveau: we can't free ACPI EDID, so make a copy that we can
>       drm/nv50: mark PCIEGART pages non-present rather than using dummy page
>       drm/nouveau: zero dummy page
>       drm/nv50: fix 100c90 write on nva3
>       drm/nouveau: make the behaviour of get_pll_limits() consistent
>       drm/nouveau: make bios code easier to use externally
>       drm/nouveau: import initial work on vbios performance table parsing
>       drm/nv50: import initial clock get/set routines + hook up pm engine
>       drm/nv04-nv40: import initial pm backend
>       drm/nouveau: allow static performance level setting
>       drm/nouveau: restore perflvl on resume, and restore boot perflvl on unload
>       drm/nouveau: fix potential accuracy loss when parsing perf 0x1c tables
>       drm/nouveau: implement parsing of DCB 2.2 GPIO table
>       drm/nouveau: fix thinko in volt 0x1x parsing
>       drm/nv50: flush bar1 vm / dma object setup before poking 0x1708
>       drm/nouveau: correct INIT_DP_CONDITION subcondition 5
>       drm/nouveau: add debugfs file to forcibly evict everything from vram
>       drm/nv50: assume smaller tiles for bo moves
>       drm/nouveau: fix chipset vs card_type thinko
>       drm/nouveau: fix panels using straps-based mode detection
>       drm/nouveau: v3.0 pll limits tables have type<->register mapping too
>       drm/nv50: use pll type rather than register for CRTC PLL
>       drm/nouveau: enable enhanced framing only if DP display supports it
>       drm/nouveau: pass perflvl struct to clock_pre()
>       drm/nouveau: run perflvl and M table scripts on mem clock change
>       drm/nva3: split pm backend out from nv50
>       drm/nouveau: fix typo in c2aa91afea5f7e7ae4530fabd37414a79c03328c
>       drm/nouveau: fix required mode bandwidth calculation for DP
>       drm/nv50: prevent (IB_PUT == IB_GET) for occurring unless idle
>       drm/nouveau: parse voltage from perf 0x40 entires
>       drm/ttm: introduce utility function to free an allocated memory node
>       drm/ttm: restructure to allow driver to plug in alternate memory manager
> 
> Bryan Freed (1):
>       drm/i915: Initialize panel timing registers if VBIOS did not
> 
> Chia-I Wu (1):
>       drm/i915: Fix current fb blocking for page flip
> 
> Chris Ball (3):
>       drm/radeon/kms: Implement KDB debug hooks for radeon KMS.
>       drm/nouveau/kms: Implement KDB debug hooks for nouveau KMS.
>       drm/nouveau/kms: Avoid a hang entering KDB with VT accel on.
> 
> Chris Wilson (190):
>       Merge remote branch 'airlied/drm-core-next' into HEAD
>       drm/i915: Drop the msleep parameter to wait_for()
>       drm/i915: Avoid using msleep under kdb and wait_for()
>       drm/i915/crt: Flush register prior to waiting for vblank.
>       drm/i915: Rename i915_opregion.c to intel_opregion.c
>       drm/i915: Use the VBT from OpRegion when available (v3)
>       drm/i915: Addin-offset is an unreliable indicator of LVDS presence (v2)
>       drm/i915: Ironlake page-flipping is per-plane not per-pipe
>       drm/i915/tv: Preserve reserved DAC bits during mode-setting
>       drm/i915/tv: Poll for DAC state change
>       drm/i915/tv: Mark the format names as constant and so avoid the memleak
>       drm/i915: Sanity check user framebuffer parameters on creation
>       drm/i915/sdvo: Preserve pixel-multiplier
>       drm/i915/overlay: Whitespace
>       drm/i915/overlay: Missing breaks between case statements for color depth
>       drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing.
>       drm/i915/overlay: Move capabilities bits to common info block.
>       drm/i915/overlay: Use non-atomic mappings for the common case.
>       drm/i915/overlay: Tidy attribute checking.
>       drm/i915/overlay: Use the recommended page alignment for physical regs
>       drm/i915/overlay: Destroy reg_bo on shutdown.
>       drm/i915/overlay: Remove duplicated definition of OFC_UPDATE
>       drm/i915/overlay: Tidy update_pfit_vscale_ratio()
>       drm/i915/overlay: Tidy check_overlay_dst()
>       drm/i915/overlay: Refactor do_wait_request()
>       drm/i915/overlay: Explicitly pass regs from map to unmap
>       drm/i915/overlay: Combine SWITCH_OFF into a single step
>       drm/i915/overlay: Tidy release_old_vid()
>       drm/i915: Preallocate requests
>       drm/i915/overlay: Make do_put_image() as static
>       drm/i915/overlay: Workaround i830 overlay activation bug.
>       drm/i915/overlay: Pass interruptible to switch_off()
>       drm/i915/overlay: Make the overlay control struct opaque.
>       drm/i915/overlay: Use a continuation hook to finish work after a flip.
>       drm/i915: Compile out error state without DEBUG_FS
>       drm/i915: Remove the random SyncFlush during initialisation
>       drm/i915: Kill the active list spinlock
>       drm/i915: Quieten sparse warnings for missing prototypes.
>       drm/i915: Remove redundant initialisation of fb_base
>       drm/i915: Refactor panel backlight controls
>       drm/i915/tv: After disabling the pipe, use wait_for_vblank_off()
>       drm/i915: Show device capabilities in debugfs
>       drm/i915: Show framebuffer info in debugfs
>       drm/i915: Clear scanline waits after disabling the pipe.
>       drm/i915: Add ringbuffer wait reset to hangcheck
>       drm/i915: Remove impossible error handling from bit17 swizzling
>       drm/i915/dp: Flush the PLL register write before sleeping
>       drm/i915: Rename intel_encoder->enc to base for consistency
>       drm/i915: Use the direct mapping of pipe->crtc
>       drm/i915: Make the connector->encoder relationship explicit
>       drm/i915/debug: Include Ironlake in self-refresh status
>       drm/i915: Adapt workqueue to new alloc_workqueue interface
>       drm/i915: Ensure all PLL registers are flushed before a udelay()
>       drm/i915: Only call udelay() when waiting for clocks to stabilise
>       drm/i915: Use the real FDI frequency for determining b/w
>       Merge branch 'drm-intel-fixes' into drm-intel-next
>       drm/i915: Fix updating FBC
>       drm/i915: Tidy Ironlake watermark computation
>       drm/i915: Use macros to switch between equivalent pipe registers
>       drm/i915/dp: Convert a udelay(17000) to a sleep during link-off
>       drm/i915/i2c: The bit-banging interface controls the delay, drop ours
>       drm/i915/lvds: Remove busy wait for powering down the panel
>       drm/i915/lvds: Remove busy wait for powering up the panel.
>       drm/i915: Use msleep instead of mdelay during wait_vblank_off
>       drm/i915/sdvo: Poll command status 5 times without delay on read
>       drm/i915/bios: Prevent NULL dereference after allocation failure
>       drm/i915/lvds: Ensure panel is unlocked for Ironlake or the panel fitter
>       drm/i915/lvds: Remove incorrect mode locking
>       drm/i915/lvds: Move private data to the connector from the device.
>       drm/i915: Share crtc setup and teardown between dpms and disable/enable
>       drm/i915: Fix an overlay regression from 7e7d76c
>       drm/i915: Initialize intel_crtc->active
>       drm/i915: Remove redundant initialisation of crtc->pipe
>       drm/i915: Reduce hangcheck frequency
>       drm/i915: Consolidate flushing the display plane
>       drm/i915: Fix regression in ba3d8d749b
>       agp/intel: Use macro to set the count of the size array
>       drm/i915: Push pipelining of display plane flushes to the caller
>       drm/i915: Allow get_fence_reg() to be uninterruptible
>       drm/i915/i2c: Track the parent encoder rather than just the dev
>       drm/i915: Remove unused intel_ringbuffer->ring_flag
>       drm/i915/sdvo: Tidy intel_sdvo_hdmi_sink_detect
>       drm/i915/sdvo: Propagate i2c error from switching DDC control bus.
>       agp/intel: Remove redundant setting of gtt_mappable_entries
>       agp/intel: Fix resume regression from 2d2430cf
>       drm/i915/sdvo: Only create the analog encoder as required
>       drm/i915/sdvo: Mark the status as unknown if attached with EDID
>       drm/i915: call drm_encoder_init first
>       drm/i915: use GMBUS to manage i2c links
>       Merge branch 'drm-intel-fixes' into HEAD
>       drm/i915: Cache LVDS EDID
>       drm/i915: INTEL_INFO->gen supercedes i8xx, i9xx, i965g
>       drm/i915: After a reset perform a forced modeset
>       drm/i915/debug: Dump BSD ring buffers to debugfs
>       drm/i915: Inline i915_gem_ring_retire_request()
>       drm/i915: Only emit a flush request on the active ring.
>       drm/i915: Clear flushing lists on GPU reset
>       drm/i915: Clear GPU read domains on reset
>       drm/i915: Clean up bo lists on all hung gpus
>       drm/i915/ringbuffer: Implement advance using set_tail
>       drm/i915/ringbuffer: Mark the initialisation structs as constant.
>       drm/i915: Use ring->flush() instead of MI_FLUSH
>       drm/i915/ringbuffer: whitespace cleanup
>       drm/i915: Track gpu fence usage
>       drm/i915: Merge ring flushing and lazy requests
>       drm/i915: Drain any pending flips on the fb prior to unpinning
>       drm/i915: Track pinned objects
>       drm/i915: Disable output polling across suspend & resume
>       drm/i915: Drop crtc->fb pin on disable.
>       drm/i915: Use the correct DPB GMBUS port for GPIOE
>       drm/i915/lvds: Unlock the PP register when panel-fitting
>       drm/i915: Don't overwrite the returned error-code
>       drm/i915: Clear the gpu_write_list on resetting write_domain upon hang
>       drm/i915: Don't offset the pin used for crt_ddc
>       drm/i915: Drop ring->lazy_request
>       drm/i915: Disable "disabled FBC" message when a no-op
>       drm/i915/crt: Use a DDC probe on 0xA0 before load-detect
>       drm/i915: Remove the broken flush_ring from page-flip
>       drm/i915/tv: Sleep before checking for state changes.
>       drm/i915/lvds: Probe DDC on creation
>       drm/i915: Remove idle timer debugging messages
>       drm/i915/ringbuffer: Fix sign of ring space.
>       drm/i915: Remove unused dev_priv->panel_wants_dither
>       drm/i915: Use an uninterruptible wait for page-flips during modeset
>       drm/i915/lvds: Use the GMBUS pin if specified in VBT
>       drm/i915: Parse the eDP link configuration from the vBIOS
>       drm/i915: Only hold a process-local lock whilst throttling.
>       drm/i915: Adjust hangcheck EIO semantics
>       drm/i915: Make the mutex_lock interruptible on ioctl paths
>       drm/i915: Convert the file mutex into a spinlock
>       drm/i915: fix debugging compilation error from previous commit
>       drm/i915: Ensure that the mode change flushing is currently uninterruptible
>       Revert "drm/i915: Drop ring->lazy_request"
>       drm/i915/sdvo: Fix GMBUSification
>       drm/i915: Use i2c bit banging instead of GMBUS
>       MAINTAINERS: Add contact details for drm/i915
>       Merge branch 'drm-intel-fixes' into drm-intel-next
>       drm/i915: Disable LVDS i2c probing when using GPIO bit banging
>       drm/i915: Tidy dvo_ch7017 and print out which chip we detect
>       drm/i915/dvo: Fix panel and DDC i2c pins
>       drm/i915/debug: Remove defunct WATCH_LRU
>       drm/i915/debug: Remove default WATCH_BUF
>       drm/i915: Avoid blocking the kworker thread on a stuck mutex
>       drm/i915/debug: Convert i915_verify_active() to scan all lists
>       drm/i915: Report the deferred free list in debugfs
>       drm/i915/debugfs: Include list totals
>       drm/i915: Make get/put pages static
>       drm/i915: Remove redundant deletion of obj->gpu_write_list
>       drm: Move the GTT accounting to i915
>       drm/i915: Force the domain to CPU on unbinding whilst wedged.
>       drm/i915: Clear fence registers on GPU reset
>       drm/i915: Try to reset gen2 devices.
>       drm/i915: Only print 'generating error event' if we actually are
>       drm/i915: If the GPU hangs twice within 5 seconds, declare it wedged.
>       drm/i915: Don't mask the return code whilst relocating.
>       Merge branch 'drm-intel-fixes' into drm-intel-next
>       Merge branch 'drm-intel-fixes' into drm-intel-next
>       drm/i915: Skip pread/pwrite if size to copy is 0.
>       drm/i915: Avoid circular locking from intel_fbdev_fini()
>       drm/i915: Wait for pending flips on the GPU
>       Merge remote branch 'airlied/drm-core-next' into tmp
>       Revert "drm/i915: Prevent module unload to avoid random memory corruption"
>       drm/i915: Remove duplicate set of ADPA definitions
>       drm/i915: restore fixed FDI link rate on Sandybridge
>       drm/i915: Sleep whilst waiting for the ring
>       drm/i915/dp: Add 'force_audio' property
>       drm/i915/sdvo: Add 'force_audio' property
>       drm/i915/hdmi: Add 'force_audio' property
>       drm/i915: Avoid vmallocing a buffer for the relocations
>       drm/i915: Perform relocations in CPU domain [if in CPU domain]
>       drm/i915: Avoid taking the mutex for dropping the refcnt upon creation
>       drm/i915: Attempt to prefault user pages for pread/pwrite
>       drm/i915: Rearrange acquisition of mutex during pwrite
>       drm/i915: rearrange mutex acquisition for pread
>       agp/intel: Also add B43.1 to list of supported devices
>       drm/i915: Do interrupible mutex lock first to avoid locking for unreference
>       drm/i915: cache the last object lookup during pin_and_relocate()
>       drm/i915: Simplify most HAS_BSD() checks
>       drm/i915: Track objects in global active list (as well as per-ring)
>       drm/i915: Copy the updated reloc->presumed_offset back to the user
>       drm/i915/ringbuffer: Fix emit batch buffer regression from 8187a2b
>       drm/i915/ringbuffer: Remove broken intel_fill_struct()
>       drm/i915: Enable SandyBridge blitter ring
>       drm/i915: IS_IRONLAKE is synonymous with gen == 5
>       drm/i915/sdvo: Remove unused encoding member
>       drm/i915: Fix flushing regression from 9af90d19f
>       agp/intel: Restore valid PTE bit for Sandybridge after bdd3072
>       drm/i915/ringbuffer: Write the value passed in to the tail register
>       drm/i915: Invalidate the to-ring, flush the old-ring when updating domains
>       drm/i915: Move gpu_write_list to per-ring
> 
> Dan Carpenter (1):
>       i915: snprintf returns large values
> 
> Daniel Vetter (85):
>       drm: don't export drm_sg_alloc
>       drm: kill kernel_context_switch callbacks
>       drm: kill procfs callbacks
>       drm: kill dma_ready callbacks
>       drm: kill gem_free_object_unlocked driver callback
>       drm: kill context_ctor callback
>       drm: don't export drm_get_drawable_info
>       drm: drop return value of drm_free_agp
>       drm: kill drm_map_ofs callbacks
>       drm: don't export dri1 locking functions
>       drm: replace drawable ioctl by noops
>       drm: kill agp indirection mess
>       drm: kill dev->timer
>       drm: kill get_reg_ofs callback
>       drm/i915: unload: fix intel dp encoder cleanup
>       drm/i915: unload: fix error_work races
>       drm/i915: unload: fix hotplug_work races
>       drm/i915: unload: don't leak error state
>       drm/i915: unload: fix idle_timer/idle_work races
>       drm/i915: unload: fix unpin_work related races
>       drm/i915: unload: ensure that gem is idle
>       drm/i915: unload: fix retire_work races
>       drm/i915: allow lazy emitting of requests
>       drm/i915: move flushing list processing to i915_gem_flush
>       drm/i915: only one interrupt per batchbuffer is not enough!
>       drm/i915: move flushing list processing to i915_retire_commands
>       drm/i915: kill a no longer necessary BUG_ON
>       drm/i915: drop seqno argument from i915_gem_object_move_to_active
>       drm/i915: move the wait_rendering call into flush_gpu_write_domain
>       drm/i915: drop i915_add_request right in front of i915_wait_request
>       agp/intel: split out gmch/gtt probe, part 2
>       agp/intel: make intel-gtt.c into a real source file
>       intel-gtt: introduce drm/intel-gtt.h
>       intel-gtt: store a local pointer to the bridge pci dev
>       intel-gtt: s/intel_i830_init_gtt_entries/intel_gtt_stolen_entries
>       intel-gtt: new function intel_gtt_mappable_entries
>       intel-gtt: generic intel_fake_agp_fetch_size
>       intel-gtt: sane variable names for intel_gtt_stolen_entries
>       intel-gtt: drop unnecessary conditions in intel_gtt_stolen_entries
>       intel-gtt: adjust overhead entries in intel_gtt_stolen_entries
>       intel-gtt: s/i8[13]0/fake_agp for generic functions
>       intel-gtt: fix gtt_total_entries detection
>       intel-gtt: introduce intel_gtt_driver
>       intel-gtt: i915: use detected gtt size for mapping
>       intel-gtt: i965: use detected gtt size for mapping
>       intel-gtt: i830: adjust ioremap of regs and gtt to i9xx
>       intel-gtt: consolidate the gtt ioremap calls
>       intel-gtt: consolidate i830 setup
>       intel-gtt: consolidate i9xx setup
>       intel-gtt: call init_gtt_init in probe function
>       intel-gtt: use chipset generation number some more
>       drm/i915: drop prealloc_start from i915_dma gtt init
>       drm/i915: die, i915_probe_agp, die
>       drm/i915: kill duplicated/unneeded register defines
>       drm/i915: add relative ring register macros
>       drm/i915: use new macros to access the ring tail register
>       drm/i915: use new macros to access the ring start register
>       drm/i915: use new macros to access the ring head register
>       drm/i915: use new macros to access the ring ctl register
>       drm/i915: don't explicitly initialize ringbuffer members to zero
>       drm/i915: drop alignment ringbuffer parameter
>       intel-gtt: initialize our own scratch page
>       intel-gtt: introduce pte write function for i8xx/i915/i945
>       intel-gtt: introduce pte write function for g33/i965/gm45
>       intel-gtt: introduce pte write function for gen6
>       intel-gtt: drop agp scratch page support stuff
>       agp: kill agp_(map|unmap)_page
>       intel-gtt: generic (insert|remove)_entries for i830
>       intel-gtt: generic (insert|remove)_entries for i915
>       intel-gtt: generic (insert|remove)_entries for g33/i965
>       intel-gtt: generic (insert|remove)_entries for sandybridge
>       intel-gtt: kill mask_memory functions
>       intel-gtt: move chipset flush to the gtt driver struct
>       intel-gtt: consolidate fake_agp driver structs
>       agp: kill agp_(unmap|map)_memory
>       intel-gtt: clean up gtt size reporting
>       intel-gtt: store the dma mask size in intel_gtt_driver
>       intel-gtt add a cleanup function for chipset specific stuff
>       drm/i915: kill now unnecessary gtt defines from i915_reg.h
>       drm/i915: fix ACTHD for gen <= 3
>       drm/i915: kill per-ring macros
>       drm/i915: kill ring->get_active_head
>       drm/i915: kill ring->setup_status_page
>       drm: readd drm_lock_free in drm_unlock
>       drm/i915: Fix oops on HWS unload
> 
> Dave Airlie (13):
>       Merge remote branch 'origin/master' of /home/airlied/kernel//linux-2.6 into drm-core-next
>       Merge remote branch 'intel/drm-intel-next' of ../drm-next into drm-core-next
>       Merge remote branch 'korg/drm-fixes' into drm-vmware-next
>       Merge branch 'drm-vmware-next' into drm-core-next
>       Merge remote branch 'nouveau/for-airlied' of ../drm-nouveau-next into drm-core-next
>       Merge branch 'drm-kdb-next' into drm-core-next
>       Merge branch 'drm-radeon-next' of ../drm-radeon-next into drm-core-next
>       Merge branch 'drm-fixes' of /home/airlied/kernel/linux-2.6 into drm-core-next
>       drm/ttm: add unlocked variant of new manager put node.
>       Revert "drm/radeon/kms: remove some pll algo flags"
>       Merge remote branch 'intel/drm-intel-next' of ../drm-next into drm-core-next
>       drm/radeon/r600: fix tiling issues in CS checker.
>       drm/radeon/kms: don't poll dac load detect.
> 
> David Härdeman (1):
>       i915: enable AVI infoframe for intel_hdmi.c [v4]
> 
> Emil Velikov (1):
>       drm/nouveau: don't use the default pll limits in table v2.1 on nv50+ cards
> 
> Francesco Marella (1):
>       drm/nv40: fix reading temp value
> 
> Francisco Jerez (30):
>       drm/nouveau: Fix suspend on some nv4x AGP cards.
>       drm/nv20: Use the nv30 CRTC bandwidth calculation code.
>       drm/nv17-nv4x: Fix analog load detection false positive on rare occasions.
>       drm/nv40: Try to set up CRE_LCD even if it has unknown bits set.
>       drm/nouveau: Break some long lines in the TV-out code.
>       drm/nouveau: Don't remove ramht entries from the neighboring channels.
>       drm/nouveau: Don't enable AGP FW on nv18.
>       drm/nouveau: Add module parameter to override the default AGP rate.
>       drm/nouveau: PRAMIN is available from the start on pre-nv50.
>       drm/nouveau: Remove implicit argument from nv_wait().
>       drm/nouveau: Simplify tile region handling.
>       drm/nouveau: Try to fetch an EDID from OF if DDC fails.
>       drm/nouveau: Parse old style perf tables.
>       drm/nv10: Don't oops if the card wants to switch to a channel with no grctx.
>       drm/nouveau: Don't try to parse a GPIO table on early DCBv2.2 BIOSes.
>       drm/nouveau: Add sane sensor correction defaults for nv4a.
>       drm/nouveau: Fix parsing of the temperature constant correction.
>       drm/nouveau: Double the perf table memory clocks on pre-G71 cards.
>       drm/nouveau: Refactor nouveau_temp_get() into engine pointers.
>       drm/nouveau: Add support for I2C hardware monitoring devices.
>       drm/nouveau: Misc cleanup of the PM code.
>       drm/nouveau: Fix perf table parsing on BMP v5.25.
>       drm/nv30-nv40: Fix postdivider mask when writing engine/memory PLLs.
>       drm/nv0x-nv4x: Leave the 0x40 bit untouched when changing CRE_LCD.
>       drm/nouveau: Minor refactoring/cleanup of the fence code.
>       drm/nouveau: Provide a means to have arbitrary work run on fence completion.
>       drm/nouveau: Use semaphores to handle inter-channel sync in hardware.
>       drm/nouveau: Synchronize buffer object moves in hardware.
>       drm/nv50: Fix large 3D performance regression caused by the interchannel sync patches.
>       agp/amd-k7: Allow binding user memory to the AGP GART.
> 
> Hette Visser (1):
>       drm/i915/dp: Wait for PP_CONTROL to take effect.
> 
> Jan Beulich (1):
>       some clean up to intel-gtt.c
> 
> Jason Wessel (5):
>       drm, kdb, kms: Add an enter argument to mode_set_base_atomic() API
>       radeon, kdb, kms: Save and restore the LUT on atomic KMS enter/exit
>       Revert "radeon, kdb, kms: Save and restore the LUT on atomic KMS enter/exit"
>       kdb, kms: Save and restore the LUT on atomic KMS enter/exit
>       drm, kdb, kms: Change mode_set_base_atomic() enter argument to be an enum
> 
> Jean Delvare (1):
>       drm/ttm: Simplify ttm_bo_wait_unreserved
> 
> Jesse Barnes (40):
>       drm/i915: add MMIO debug output
>       drm/i915: fix pipeconf dither bit definitions
>       drm/i915: set dither bits on eDP panels too
>       drm/i915: fix eDP detection
>       drm/i915: use 125MHz reference clock for PCH attached eDP
>       drm/i915: use VDD AUX for panel power around detection and in prepare
>       drm/i915: split DP link training across panel power sequencing
>       drm/i915: don't change VDD AUX status in panel power functions
>       drm/i915: make sure VDD AUX power has time to settle
>       drm/i915: make sure panel is sequenced off when starting a mode set
>       drm/i915: split Ironlake CRTC enable/disable code
>       drm/i915: split i9xx CRTC enable/disable code
>       drm/i915: don't unlock panel regs
>       drm/i915: use i915 and Ironlake CRTC enable/disable functions in prepare/commit
>       drm/i915: enable PCH PLL, FDI training and transcoder even for eDP
>       drm/i915: split Ironlake FDI enable function
>       drm/i915: don't write TU size to N1 reg
>       drm/i915: set FDI RX TU size to match transmit size
>       drm/i915: enable thermal reporting for IPS
>       drm/i915/dp: convert eDP checks to functions and document
>       drm/i915/dp: remove redundant is_pch_edp checks
>       drm/i915/dp: correct eDP lane count and bpp
>       drm/i915: add eDP checking functions for the display code
>       drm/i915: remove broken intel_pch_has_edp function
>       drm/i915: fix CPU vs PCH eDP confusion
>       drm/i915/dp: eDP power sequencing fixes
>       drm/i915: add _DSM support
>       drm/i915: fetch eDP configuration data from the VBT
>       drm/i915: add Ironlake clock gating workaround for FDI link training
>       drm/i915: fix PCH eDP SSC support
>       drm/i915: use 120MHz refclk in PCH eDP case too
>       drm/i915: use DPLL_DVO_HIGH_SPEED for PCH eDP
>       drm/i915: fix ironlake CRTC enable/disable
>       drm/i915: don't program FDI RX/TX in mode_set
>       drm/i915/dp: cache eDP DPCD data
>       drm/i915/dp: use VBT provided eDP params if available
>       drm/i915/dp: don't bother with DP PLL for PCH attached eDP
>       drm/i915/dp: make eDP PLL functions work as advertised
>       drm/i915: diasable clock gating for the panel power sequencer
>       drm/i915/dp: down the DP link even if the reg indicates it's already down
> 
> Keith Packard (3):
>       drm/i915: avoid struct mutex output_poll mutex lock loop on unload
>       drm/i915: mark display port DPMS state as 'ON' when enabling output
>       drm/i915: Free hardware status page on unload when physically mapped
> 
> Kenneth Graunke (3):
>       drm/i915: Actually set the reset bit in i965_reset.
>       drm/i915: Rename graphics reset registers.
>       drm/i915: Add support for GPU soft reset on Ironlake.
> 
> Lee, Chun-Yi (1):
>       gpu: Add Intel GMA500(Poulsbo) Stub Driver
> 
> Marcin Ko¶cielnicki (2):
>       drm/nv50: demagic grctx, and add NVAF support
>       drm/nouveau: Add a module option to force card POST.
> 
> Mario Kleiner (2):
>       drm/radeon: Add function for display scanout position query.
>       drm/radeon: Modify radeon_pm_in_vbl to use radeon_get_crtc_scanoutpos()
> 
> Marius Gröger (1):
>       drm/radeon: add properties to configure the width of the underscan borders
> 
> Martin Peres (1):
>       drm/nouveau: Add temperature support (vbios parsing, readings, hwmon)
> 
> Matthew Garrett (1):
>       drm/i915: Don't disable panel for modesetting if pfit hasn't changed
> 
> Phil Turmel (1):
>       drm/nouveau: Fix build regression, undefined reference to `acpi_video_get_edid'
> 
> Roy Spliet (2):
>       drm/nouveau: Import initial memory timing work
>       drm/nouveau: fix thinkos in mem timing table recordlen check
> 
> Simon Que (1):
>       i915: Added function to initialize VBT settings
> 
> Sitsofe Wheeler (1):
>       drm/i915: Revert extra intel_wait_for_vblank to prevent stalls.
> 
> Thomas Hellstrom (14):
>       drm/vmwgfx: Really support other depths than 32
>       drm/vmwgfx: Fix ACPI S3 & S4 functionality.
>       drm/vmwgfx: Add new-style PM hooks to improve hibernation behavior
>       drm: vmwgfx: Add a struct drm_file parameter to the dirty framebuffer callback
>       drm/vmwgfx: Take the ttm lock around the dirty ioctl
>       drm/vmwgfx: Prune modes based on available VRAM size
>       drm/vmwgfx: Don't flush fb if we're in the suspended state.
>       drm/vmwgfx: Add a parameter to get the max fb size
>       drm/vmwgfx: Add modinfo version
>       drm/vmwgfx: Save at least one screen layout
>       drm/vmwgfx: Bump minor and driver date
>       drm/ttm: Avoid using the ttm_mem_type_manager::put_locked function
>       drm/ttm: Optimize delayed buffer destruction
>       vmwgfx: Implement a proper GMR eviction mechanism
> 
> Xiang, Haihao (4):
>       drm/i915: fix HAS_BSD with a device info flag
>       drm/i915: do not export the instances of struct intel_ring_buffer
>       drm/i915: add set_tail hook in struct intel_ring_buffer
>       drm/i915: add a new BSD ring buffer for Sandybridge
> 
> Yuanhan Liu (2):
>       drm/i915/crt: Make sure the hotplug interrupt is enabled
>       drm/i915: Update hotplug interrupts register definitions for Sandybridge
> 
> Zhenyu Wang (4):
>       drm/i915: Fix GPIO pin to register mapping
>       drm/edid: add helper function to detect monitor audio capability
>       drm/i915: Enable DisplayPort audio
>       drm/i915: Enable HDMI audio for monitor with audio support
> 
>  MAINTAINERS                                        |    9 +
>  drivers/char/agp/Makefile                          |    1 +
>  drivers/char/agp/agp.h                             |    5 -
>  drivers/char/agp/amd-k7-agp.c                      |    6 +-
>  drivers/char/agp/backend.c                         |   22 +-
>  drivers/char/agp/generic.c                         |    8 -
>  drivers/char/agp/intel-agp.c                       |  201 +--
>  drivers/char/agp/intel-agp.h                       |   43 +-
>  drivers/char/agp/intel-gtt.c                       | 1612 +++++-----
>  drivers/gpu/Makefile                               |    2 +-
>  drivers/gpu/drm/Makefile                           |    2 +-
>  drivers/gpu/drm/drm_agpsupport.c                   |   40 +-
>  drivers/gpu/drm/drm_context.c                      |    8 -
>  drivers/gpu/drm/drm_crtc.c                         |    3 +-
>  drivers/gpu/drm/drm_debugfs.c                      |    1 -
>  drivers/gpu/drm/drm_drawable.c                     |  198 --
>  drivers/gpu/drm/drm_drv.c                          |   10 +-
>  drivers/gpu/drm/drm_edid.c                         |   93 +-
>  drivers/gpu/drm/drm_fb_helper.c                    |   32 +-
>  drivers/gpu/drm/drm_gem.c                          |   14 -
>  drivers/gpu/drm/drm_info.c                         |   14 -
>  drivers/gpu/drm/drm_lock.c                         |   30 +-
>  drivers/gpu/drm/drm_memory.c                       |   14 +-
>  drivers/gpu/drm/drm_proc.c                         |   14 -
>  drivers/gpu/drm/drm_scatter.c                      |    2 -
>  drivers/gpu/drm/drm_stub.c                         |    4 -
>  drivers/gpu/drm/drm_vm.c                           |   13 +-
>  drivers/gpu/drm/i810/i810_drv.c                    |    2 -
>  drivers/gpu/drm/i830/i830_drv.c                    |    2 -
>  drivers/gpu/drm/i915/Makefile                      |    4 +-
>  drivers/gpu/drm/i915/dvo_ch7017.c                  |   66 +-
>  drivers/gpu/drm/i915/dvo_ch7xxx.c                  |   10 +-
>  drivers/gpu/drm/i915/dvo_ivch.c                    |   10 +-
>  drivers/gpu/drm/i915/dvo_sil164.c                  |   10 +-
>  drivers/gpu/drm/i915/dvo_tfp410.c                  |   10 +-
>  drivers/gpu/drm/i915/i915_debugfs.c                |  336 ++-
>  drivers/gpu/drm/i915/i915_dma.c                    |  360 +--
>  drivers/gpu/drm/i915/i915_drv.c                    |  214 +-
>  drivers/gpu/drm/i915/i915_drv.h                    |  271 ++-
>  drivers/gpu/drm/i915/i915_gem.c                    | 2211 +++++++-------
>  drivers/gpu/drm/i915/i915_gem_debug.c              |  148 +-
>  drivers/gpu/drm/i915/i915_gem_evict.c              |   72 +-
>  drivers/gpu/drm/i915/i915_gem_tiling.c             |   54 +-
>  drivers/gpu/drm/i915/i915_irq.c                    |  259 +-
>  drivers/gpu/drm/i915/i915_reg.h                    |  335 ++-
>  drivers/gpu/drm/i915/i915_suspend.c                |   28 +-
>  drivers/gpu/drm/i915/intel_acpi.c                  |  286 ++
>  drivers/gpu/drm/i915/intel_bios.c                  |  234 +-
>  drivers/gpu/drm/i915/intel_bios.h                  |    6 +-
>  drivers/gpu/drm/i915/intel_crt.c                   |  127 +-
>  drivers/gpu/drm/i915/intel_display.c               | 2357 ++++++++-------
>  drivers/gpu/drm/i915/intel_dp.c                    |  658 +++--
>  drivers/gpu/drm/i915/intel_drv.h                   |  160 +-
>  drivers/gpu/drm/i915/intel_dvo.c                   |   69 +-
>  drivers/gpu/drm/i915/intel_fb.c                    |   29 +-
>  drivers/gpu/drm/i915/intel_hdmi.c                  |  193 +-
>  drivers/gpu/drm/i915/intel_i2c.c                   |  484 +++-
>  drivers/gpu/drm/i915/intel_lvds.c                  |  435 ++--
>  drivers/gpu/drm/i915/intel_modes.c                 |   16 +-
>  .../drm/i915/{i915_opregion.c => intel_opregion.c} |  181 +-
>  drivers/gpu/drm/i915/intel_overlay.c               | 1006 ++++---
>  drivers/gpu/drm/i915/intel_panel.c                 |  109 +
>  drivers/gpu/drm/i915/intel_ringbuffer.c            |  457 ++--
>  drivers/gpu/drm/i915/intel_ringbuffer.h            |   81 +-
>  drivers/gpu/drm/i915/intel_sdvo.c                  | 1076 +++----
>  drivers/gpu/drm/i915/intel_tv.c                    |  165 +-
>  drivers/gpu/drm/mga/mga_drv.c                      |    2 -
>  drivers/gpu/drm/nouveau/Kconfig                    |    1 +
>  drivers/gpu/drm/nouveau/Makefile                   |    6 +-
>  drivers/gpu/drm/nouveau/nouveau_acpi.c             |    2 +-
>  drivers/gpu/drm/nouveau/nouveau_bios.c             |  366 ++-
>  drivers/gpu/drm/nouveau/nouveau_bios.h             |   43 +-
>  drivers/gpu/drm/nouveau/nouveau_bo.c               |  290 ++-
>  drivers/gpu/drm/nouveau/nouveau_calc.c             |   10 +-
>  drivers/gpu/drm/nouveau/nouveau_channel.c          |   23 +-
>  drivers/gpu/drm/nouveau/nouveau_connector.c        |   54 +-
>  drivers/gpu/drm/nouveau/nouveau_connector.h        |    3 +
>  drivers/gpu/drm/nouveau/nouveau_debugfs.c          |   16 +
>  drivers/gpu/drm/nouveau/nouveau_dma.c              |   32 +-
>  drivers/gpu/drm/nouveau/nouveau_dma.h              |    1 +
>  drivers/gpu/drm/nouveau/nouveau_dp.c               |   10 +-
>  drivers/gpu/drm/nouveau/nouveau_drv.c              |   23 +-
>  drivers/gpu/drm/nouveau/nouveau_drv.h              |  253 +-
>  drivers/gpu/drm/nouveau/nouveau_encoder.h          |    1 +
>  drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    6 +
>  drivers/gpu/drm/nouveau/nouveau_fence.c            |  318 ++-
>  drivers/gpu/drm/nouveau/nouveau_gem.c              |    4 +-
>  drivers/gpu/drm/nouveau/nouveau_grctx.h            |    2 +-
>  drivers/gpu/drm/nouveau/nouveau_hw.c               |   45 +-
>  drivers/gpu/drm/nouveau/nouveau_i2c.c              |    8 +-
>  drivers/gpu/drm/nouveau/nouveau_i2c.h              |    5 +-
>  drivers/gpu/drm/nouveau/nouveau_irq.c              |  123 +-
>  drivers/gpu/drm/nouveau/nouveau_mem.c              |  363 ++-
>  drivers/gpu/drm/nouveau/nouveau_notifier.c         |    9 +-
>  drivers/gpu/drm/nouveau/nouveau_object.c           |  776 ++----
>  drivers/gpu/drm/nouveau/nouveau_perf.c             |  205 ++
>  drivers/gpu/drm/nouveau/nouveau_pm.c               |  518 +++
>  drivers/gpu/drm/nouveau/nouveau_pm.h               |   74 +
>  drivers/gpu/drm/nouveau/nouveau_ramht.c            |  289 ++
>  drivers/gpu/drm/nouveau/nouveau_ramht.h            |   55 +
>  drivers/gpu/drm/nouveau/nouveau_reg.h              |    9 +-
>  drivers/gpu/drm/nouveau/nouveau_sgdma.c            |   68 +-
>  drivers/gpu/drm/nouveau/nouveau_state.c            |  123 +-
>  drivers/gpu/drm/nouveau/nouveau_temp.c             |  309 ++
>  drivers/gpu/drm/nouveau/nouveau_volt.c             |  212 ++
>  drivers/gpu/drm/nouveau/nv04_crtc.c                |   60 +-
>  drivers/gpu/drm/nouveau/nv04_dac.c                 |   11 +-
>  drivers/gpu/drm/nouveau/nv04_dfp.c                 |   39 +-
>  drivers/gpu/drm/nouveau/nv04_fbcon.c               |    9 +-
>  drivers/gpu/drm/nouveau/nv04_fifo.c                |   68 +-
>  drivers/gpu/drm/nouveau/nv04_instmem.c             |  140 +-
>  drivers/gpu/drm/nouveau/nv04_pm.c                  |   81 +
>  drivers/gpu/drm/nouveau/nv04_tv.c                  |   10 +-
>  drivers/gpu/drm/nouveau/nv10_fifo.c                |   19 +-
>  drivers/gpu/drm/nouveau/nv10_graph.c               |    2 +-
>  drivers/gpu/drm/nouveau/nv17_tv.c                  |  110 +-
>  drivers/gpu/drm/nouveau/nv17_tv.h                  |   15 +-
>  drivers/gpu/drm/nouveau/nv17_tv_modes.c            |   48 +-
>  drivers/gpu/drm/nouveau/nv20_graph.c               |  506 ++--
>  drivers/gpu/drm/nouveau/nv40_fifo.c                |   20 +-
>  drivers/gpu/drm/nouveau/nv40_graph.c               |   16 +-
>  drivers/gpu/drm/nouveau/nv40_grctx.c               |    6 +-
>  drivers/gpu/drm/nouveau/nv50_crtc.c                |   87 +-
>  drivers/gpu/drm/nouveau/nv50_cursor.c              |    2 +-
>  drivers/gpu/drm/nouveau/nv50_dac.c                 |    4 +-
>  drivers/gpu/drm/nouveau/nv50_display.c             |   92 +-
>  drivers/gpu/drm/nouveau/nv50_fb.c                  |   40 +
>  drivers/gpu/drm/nouveau/nv50_fbcon.c               |    4 +-
>  drivers/gpu/drm/nouveau/nv50_fifo.c                |  286 +-
>  drivers/gpu/drm/nouveau/nv50_graph.c               |   51 +-
>  drivers/gpu/drm/nouveau/nv50_grctx.c               | 3305 +++++++++++++-------
>  drivers/gpu/drm/nouveau/nv50_instmem.c             |  418 ++--
>  drivers/gpu/drm/nouveau/nv50_pm.c                  |  131 +
>  drivers/gpu/drm/nouveau/nv50_sor.c                 |    4 +-
>  drivers/gpu/drm/nouveau/nva3_pm.c                  |   95 +
>  drivers/gpu/drm/nouveau/nvc0_fifo.c                |    6 -
>  drivers/gpu/drm/nouveau/nvc0_instmem.c             |   13 +-
>  drivers/gpu/drm/nouveau/nvreg.h                    |    1 +
>  drivers/gpu/drm/r128/r128_drv.c                    |    2 -
>  drivers/gpu/drm/radeon/Makefile                    |    2 +-
>  drivers/gpu/drm/radeon/atombios_crtc.c             |  406 ++-
>  drivers/gpu/drm/radeon/evergreen.c                 |  564 ++++-
>  drivers/gpu/drm/radeon/evergreen_blit_kms.c        |  772 +++++
>  drivers/gpu/drm/radeon/evergreen_blit_shaders.c    |  348 ++
>  drivers/gpu/drm/radeon/evergreen_blit_shaders.h    |   35 +
>  drivers/gpu/drm/radeon/evergreend.h                |   20 +
>  drivers/gpu/drm/radeon/r100.c                      |  100 +-
>  drivers/gpu/drm/radeon/r300.c                      |   15 +-
>  drivers/gpu/drm/radeon/r420.c                      |   16 +-
>  drivers/gpu/drm/radeon/r520.c                      |   11 +-
>  drivers/gpu/drm/radeon/r600.c                      |  179 +-
>  drivers/gpu/drm/radeon/r600_blit_kms.c             |   51 +-
>  drivers/gpu/drm/radeon/r600_cs.c                   |   36 +-
>  drivers/gpu/drm/radeon/r600d.h                     |   21 +
>  drivers/gpu/drm/radeon/radeon.h                    |   23 +-
>  drivers/gpu/drm/radeon/radeon_asic.c               |    6 +-
>  drivers/gpu/drm/radeon/radeon_asic.h               |   11 +-
>  drivers/gpu/drm/radeon/radeon_atombios.c           |  129 +-
>  drivers/gpu/drm/radeon/radeon_connectors.c         |   65 +-
>  drivers/gpu/drm/radeon/radeon_cursor.c             |   43 +-
>  drivers/gpu/drm/radeon/radeon_device.c             |   83 +-
>  drivers/gpu/drm/radeon/radeon_display.c            |  405 ++--
>  drivers/gpu/drm/radeon/radeon_drv.c                |   11 +-
>  drivers/gpu/drm/radeon/radeon_encoders.c           |   16 +-
>  drivers/gpu/drm/radeon/radeon_fb.c                 |    2 +
>  drivers/gpu/drm/radeon/radeon_fence.c              |   10 +-
>  drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |   49 +-
>  drivers/gpu/drm/radeon/radeon_mode.h               |   53 +-
>  drivers/gpu/drm/radeon/radeon_object.c             |    6 +-
>  drivers/gpu/drm/radeon/radeon_pm.c                 |   70 +-
>  drivers/gpu/drm/radeon/radeon_ring.c               |   12 +-
>  drivers/gpu/drm/radeon/radeon_ttm.c                |   34 +-
>  drivers/gpu/drm/radeon/reg_srcs/evergreen          |    8 +
>  drivers/gpu/drm/radeon/rs400.c                     |   15 +-
>  drivers/gpu/drm/radeon/rs600.c                     |   15 +-
>  drivers/gpu/drm/radeon/rs690.c                     |   15 +-
>  drivers/gpu/drm/radeon/rv515.c                     |   15 +-
>  drivers/gpu/drm/radeon/rv770.c                     |   38 +-
>  drivers/gpu/drm/savage/savage_drv.c                |    2 -
>  drivers/gpu/drm/sis/sis_drv.c                      |    3 -
>  drivers/gpu/drm/tdfx/tdfx_drv.c                    |    2 -
>  drivers/gpu/drm/ttm/Makefile                       |    3 +-
>  drivers/gpu/drm/ttm/ttm_agp_backend.c              |    3 +-
>  drivers/gpu/drm/ttm/ttm_bo.c                       |  305 +-
>  drivers/gpu/drm/ttm/ttm_bo_manager.c               |  148 +
>  drivers/gpu/drm/ttm/ttm_bo_util.c                  |   12 +-
>  drivers/gpu/drm/via/via_drv.c                      |    2 -
>  drivers/gpu/drm/vmwgfx/Makefile                    |    2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |   84 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  130 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   40 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   29 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |   13 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                |   38 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c      |  137 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |    3 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  200 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |   28 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   75 -
>  drivers/gpu/stub/Kconfig                           |   13 +
>  drivers/gpu/stub/Makefile                          |    1 +
>  drivers/gpu/stub/poulsbo.c                         |   64 +
>  drivers/video/Kconfig                              |    2 +
>  include/drm/drmP.h                                 |   45 +-
>  include/drm/drm_crtc.h                             |    4 +-
>  include/drm/drm_crtc_helper.h                      |    8 +-
>  include/drm/drm_dp_helper.h                        |    3 +
>  include/drm/i915_drm.h                             |    6 +-
>  include/drm/intel-gtt.h                            |   18 +
>  include/drm/ttm/ttm_bo_api.h                       |    3 +-
>  include/drm/ttm/ttm_bo_driver.h                    |   27 +-
>  include/drm/vmwgfx_drm.h                           |    1 +
>  212 files changed, 18764 insertions(+), 11690 deletions(-)
>  delete mode 100644 drivers/gpu/drm/drm_drawable.c
>  create mode 100644 drivers/gpu/drm/i915/intel_acpi.c
>  rename drivers/gpu/drm/i915/{i915_opregion.c => intel_opregion.c} (81%)
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_perf.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_pm.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_pm.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_ramht.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_ramht.h
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_temp.c
>  create mode 100644 drivers/gpu/drm/nouveau/nouveau_volt.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv04_pm.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv50_pm.c
>  create mode 100644 drivers/gpu/drm/nouveau/nva3_pm.c
>  create mode 100644 drivers/gpu/drm/radeon/evergreen_blit_kms.c
>  create mode 100644 drivers/gpu/drm/radeon/evergreen_blit_shaders.c
>  create mode 100644 drivers/gpu/drm/radeon/evergreen_blit_shaders.h
>  create mode 100644 drivers/gpu/drm/ttm/ttm_bo_manager.c
>  create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
>  create mode 100644 drivers/gpu/stub/Kconfig
>  create mode 100644 drivers/gpu/stub/Makefile
>  create mode 100644 drivers/gpu/stub/poulsbo.c
>  create mode 100644 include/drm/intel-gtt.h
--29444707-1800553809-1288142914=:28394--
