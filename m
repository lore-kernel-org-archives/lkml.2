Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2EXTFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:05:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42141 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2EXTFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:05:48 -0400
Date: Thu, 24 May 2012 20:05:46 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm merge window pull
Message-ID: <alpine.DEB.2.00.1205241757020.9794@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1107782847-1337880771=:9794"
Content-ID: <alpine.DEB.2.00.1205241952130.1017@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1107782847-1337880771=:9794
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1205241952131.1017@skynet.skynet.ie>


Hi Linus,

this is the main merge window request for the drm,

Its big, but jam packed will lots of features and of course 0 regressions. 
(okay maybe there'll be one).

Highlights:
new KMS drivers for server GPU chipsets: ast, mgag200 and cirrus (qemu 
only). These drivers use the generic modesetting drivers.
initial prime/dma-buf support for i915, nouveau, radeon, udl and exynos

switcheroo audio support: so GPUs with HDMI can turn off the sound driver
without crashing stuff.

There are some patches drifting outside drivers/gpu into x86 and EFI for 
better handling of multiple video adapters in Apple Macs, they've got 
correct acks except one trivial fixup.

Core:
edid parser has better DMT and reduced blanking support,
crtc properties,
plane properties,

Drivers:
exynos: add 2D core accel support, prime support, hdmi features
intel: more Haswell support, initial Valleyview support, more hdmi 
infoframe fixes, update MAINTAINERS for Daniel, lots of cleanups and fixes
radeon: more HDMI audio support, improved GPU lockup recovery support, 
remove nested mutexes, less memory copying on PCIE, fix bus master enable 
race (kexec), improved fence handling
gma500: cleanups, 1080p support, acpi fixes
nouveau: better nva3 memory reclocking, kepler accel (needs external 
firmware rip), async buffer moves on nv84+ hw.

I've some more dma-buf patches that rely on the dma-buf merge for vmap 
stuff, and I've a few fixes building up, but I'd decided I'd better get 
rid of the main pull sooner rather than later, so the audio guys are also 
unblocked.

Dave.

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-core-next

Adam Jackson (20):
      drm/i915: Pull MTRR setup to its own function
      drm/i915: Don't do MTRR setup if PAT is enabled
      drm/edid: Document drm_mode_find_dmt
      drm/edid: Rewrite drm_mode_find_dmt search loop
      drm/edid: Allow drm_mode_find_dmt to hunt for reduced-blanking modes
      drm/edid: Remove a misleading comment
      drm/edid: s/drm_gtf_modes_for_range/drm_dmt_modes_for_range/
      drm/edid: Add the reduced blanking DMT modes to the DMT list
      drm/edid: Fix some comment typos in the DMT mode list
      drm/edid: Do drm_dmt_modes_for_range() for all range descriptor types
      drm/edid: Update range descriptor struct for EDID 1.4
      drm/edid: Give the est3 mode struct a real name
      drm/edid: Add extra_modes
      drm/edid: Generate modes from extra_modes for range descriptors
      drm/edid: Try harder to fix up base EDID blocks
      drm/dp: Add DPCD OUI register defines
      drm/dp: Add DPCD defines for register 0x007
      drm/i915/dp: Probe branch/sink OUIs
      drm/radeon/dp: Probe branch/sink OUIs
      drm/nouveau/dp: Probe branch/sink OUIs (v2)

Alan Cox (31):
      gma500: Fix leak of uncached page
      gma500: read the PLL bits
      gma500: Update the Cedarview clock handling
      gma500: mark framebuffer pages write combining
      gma500: intel_bios updates
      gma500: panel presence check
      gma500: support 1080p
      gma500: Clean up weirdness in the cdv mode test code
      cdv: continue synching up with updated reference code
      gma500: Add ops for hotplug support.
      gma500: Add the base elements of CDV hotplug support
      gma500: Set the mapping mask
      gma500: don't register the ACPI video bus
      gma500: Sync up Oaktrail HDMI
      gma500: wide framebuffer memory
      gma500: implement backlight functionality for Cedartrail devices
      gma500: opregion and ACPI
      gma500: address the lid code
      gma500: Fix build without ACPI
      gma500: introduce a structure describing each pipe
      gma500: Clean up from the psb_pipe structure
      gma500: introduce some register maps
      gma500: use the register map to clean up
      gma500: Clean up some of the noise
      cdv: Add all cedarview pci ids
      gma500: clean up some more checks
      gma500: Turn on the IRQ for everything
      gma500: Fix crash on D2700MUD and various other boards
      gma500: unload fixes
      gma500: Prevent endless loop in panel power up sequence
      gma500: Fix Poulsbo suspend/resume crash on devices with SDVO ports

Alex Deucher (7):
      drm/radeon/kms: improve bpc handling (v2)
      drm/radeon/kms: add register definitions for audio
      drm/radeon/kms: fix up audio interrupt handling
      drm/radeon: add connector table for SAM440ep embedded board
      drm/radeon: make use of radeon_gem_init() consistent
      drm/radeon/hdmi: store info about all AFMT blocks
      drm/radeon: add PRIME support (v2)

Andreas Heider (2):
      drm/nouveau: Check dsm on switcheroo unregister
      drm/nouveau: Unregister switcheroo client on exit

Armin Reese (1):
      drm/i915: Mask reserved bits in display/sprite address registers

Ben Skeggs (53):
      drm/nva3/pm: introduce more paranoia
      drm/nva3/pm: hook up to ram reclocking helper
      drm/nva3/pm: initial attempt at more magic PFB regs
      drm/nva3/pm: more random unknown PFB regs
      drm/nva3/pm: begin to restructure memory clock changes + another magic
      drm/nva3/pm: attempt to bash a few 0x100200 bits correctly
      drm/nva3/pm: make pll->pll mode work
      drm/nva3/pm: initial attempt at handling 111100/111104
      drm/nva3/pm: another few magic regs, and slightly better 0x004018 handling
      drm/nvc0/pm: start filling in memory reclocking stubs
      drm/nvc0/pm: enable mpll src pll, and calc mpll coefficients
      drm/nvd9/pm: oops, fix timing calc
      drm/nvc0/pm: very initial mclk freq change
      drm/nouveau/pm: some more delays for ddr3 reclocking
      drm/nouveau: give a slightly larger pci(e)gart aperture on all chipsets
      drm/nve0/fifo: initial implementation
      drm/nve0/gr: initial implementation
      drm/nv50-/fbcon: move 2d class to subchannel 3
      drm/nve0/ttm: implement buffer moves with weirdo pcopy-on-pgraph methods
      drm/nouveau/bios: allow loading alternate vbios image as firmware
      drm/nouveau: use the same packet header macros as userspace
      drm/nve0/graph: bump hub2gpc buffer size
      drm/nv50/disp: fixup error paths in crtc object creation
      drm/nv40-50/gr: restructure grctx/prog generation
      drm/nv04/disp: disable vblank interrupts when disabling display
      drm/nvd0/disp: remove unnecessary sync from flip_next
      drm/nouveau: create real execution engine for software object class
      drm/nouveau: move flip-related channel setup to software engine
      drm/nouveau/fence: make ttm interfaces wrap ours, not the other way around
      drm/nouveau/fence: minor api changes for an upcoming rework
      drm/nouveau/fence: convert to exec engine, and improve channel sync
      drm/nouveau: fix engine context destructor ordering
      drm/nouveau/bios: fix some shadowing issues, particularly acpi
      drm/nouveau/fence: fix a race where fence->channel can disappear
      drm/nouveau/fifo: remove all the "special" engine hooks
      drm/nv50/fifo: construct playlist from hw context table state
      drm/nv50/gr: make sure NEXT_TO_CURRENT is executed even if nothing done
      drm/nv50/fifo: use hardware channel kickoff functionality
      drm/nv50: remove execution engine context saves on suspend
      drm/nv50: remove manual context unload on context destruction
      drm/nv50/graph: remove ability to do interrupt-driven context switching
      drm/nouveau/fifo: turn all fifo modules into engine modules
      drm/nv98/crypt: non-stub implementation of the engine hooks
      drm/nouveau/fbcon: use fence for sync, rather than notifier
      drm/nouveau/ttm: untangle code to support accelerated buffer moves
      drm/nv84/ttm: use crypto engine for async buffer copies
      drm/nv98/ttm: add in a (disabled) crypto engine buffer copy method
      drm/nva3/ttm: use copy engine for async buffer moves
      drm/nvc0/ttm: use copy engines for async buffer moves
      drm/nvd9/copy: initialise copy engine, seems to work like nvc0
      drm/nouveau/disp: fix dithering not being enabled on some eDP macbooks
      drm/nouveau: turn a BUG into a WARN
      drm/nouveau: fix a minor annoyance in an output string

Ben Widawsky (26):
      drm/i915: [dinq] shut up two instances -Wunitialized
      drm/i915: [dinq] shut up six instances of -Warray-bounds
      drm/i915: ring irq cleanups
      drm/i915: open code gen6+ ring irqs
      drm/i915: VCS is not the last ring
      drm/i915: add rc6 residency times to debugfs
      drm/i915: use semaphores for the display plane
      drm/i915: rc6 in sysfs
      drm/i915: i915_gem_object_sync must handle NULL
      drm/i915: fix for when semaphore updates fail
      drm/i915: hide (seqno-1) in ringbuffer code
      drm/i915: [sparse] trivial sparse fixes
      drm/i915: [sparse] don't use variable size arrays
      drm/i915: [GEN7] Use HW scheduler for fixed function shaders
      drm/i915: rc6 residency (fix the fix)
      drm/i915: [sparse] __iomem fixes for opregion
      drm/i915: [sparse] __iomem fixes for overlay
      drm/i915: [sparse] __iomem fixes for gem
      drm/i915: remove do_retire from i915_wait_request
      drm/i915: move vbetool invoked ier stuff
      drm/i915: kill waiting_seqno
      drm/i915: drop polled waits from i915_wait_request
      drm/i915: extract __wait_seqno from i915_wait_request
      drm/i915: remove polled wait from throttle
      drm/i915: use __wait_seqno for ring throttle
      drm/i915: extract some common olr+wedge code

Carsten Emde (3):
      drm/i915: panel: invert brightness via parameter
      drm/i915: panel: invert brightness via quirk
      drm/i915: panel: invert brightness acer aspire 5734z

Chris Wilson (72):
      drm/i915: Release the mmap offset when purging a buffer
      drm/i915: Batch copy_from_user for relocation processing
      drm/i915: Avoid using mappable space for relocation processing through the CPU
      drm/i915: Initialise GTT MTRR to -1
      drm/i915/sdvo: Include YRPB as an additional TV output type
      drm/i915: Reorganise rules for get_fence/put_fence
      drm/i915: Ironlake shares the same video sprite controls as Sandybridge
      drm/i915: Allow concurrent read access between CPU and GPU domain
      drm/i915: Trigger hangcheck if we detect more a repeating missed IRQ
      drm/i915: Refactor the deferred PM_IIR handling into a single function
      drm/i915: Export the generic, not arch specific, intel_update_watermarks()
      drm/i915/sprite: Always enable the scaler on IronLake
      drm/i915/dp: Flush any outstanding work to turn the VDD off
      drm/i915: Always flush tiling changes before accessing through the GTT
      drm/i915: Replace open coded MI_BATCH_GTT
      drm/i915: Unpin the flip target if we fail to queue the flip
      drm/i915: intel_update_fbc() requires struct_mutex, so no longer atomic
      drm/i915: Don't set a MBZ bit in gen2/3 MI_FLUSH
      drm/i915: Wait for all pending operations to the fb before disabling the pipe
      drm/i915: Remove the pipelined parameter from get_fence()
      drm/i915: Remove fence pipelining
      drm/i915: Remove unused ring->setup_seqno
      drm/i915: Discard the unused obj->last_fenced_ring
      drm/i915: Simplify fence finding
      drm/i915: Remove the unsightly "optimisation" from flush_fence()
      drm/i915: Prepare to consolidate fence writing
      drm/i915: Refactor put_fence() to use the common fence writing routine
      drm/i915: Refactor fence clearing to use the common fence writing routine
      drm/i915: Refactor get_fence() to use the common fence writing routine
      drm/i915: Silence the change of LVDS sync polarity
      drm/i915/sprite: Avoid incurring extra vblank stall when updating plane on IVB
      drm/i915: Remove i915_gem_ringbuffer_(data|info) from debugfs
      drm/i915: Clarify the semantics of tiling_changed
      drm/i915: Only the zap the VMA after updating the tiling parameters
      drm/i915: i8xx interrupt handler
      drm/i915: Use a global lock for modifying global irq flags
      drm/i915: Remove too early plane enable on pre-PCH hardware
      drm/i915: Bump the inactive LRU on set-to-GTT-domain
      drm/i915: Remove i915_gem_evict_inactive()
      drm/i915: Remove the list of pinned inactive objects
      drm/i915: Remove the deferred-free list
      drm/i915: Split the stolen handling for GEM out of i915_dma.c
      drm/i915: Move GEM initialisation from i915_dma.c to i915_gem.c
      drm/i915: CR clock gating is recommend to be set on PineView
      drm/i915: Unconditionally initialise the interrupt workers
      drm/i915: Remove redundant initialisation of per-ring IRQ waitqueues
      drm/i915: pending_flip_is_done is gen3, name it so
      drm/i915: Duplicate and split the gen3/4 irq handler
      drm/i915: Clear FlipDone semantics change for pageflipping on gen3
      drm/i915: Remove gen3 irq code from gen4 irq routine
      drm/i915: Remove gen4 irq code from gen3 irq routine
      drm/i915: HWSTAM is only 16-bit on gen3
      drm/i915: Cleanup gen3 irq uninstall
      drm/i915: Handle PendingFlip on gen3 robustly
      drm/i915: Inline I915_INTERRUPT_ENABLE_FIX
      drm/i915: Remove unused and unloved vblank macros
      drm/i915: Remove unused ring->irq_seqno
      drm/i915: Only enable IPS polling for gen5
      drm/i915: Remove unused dev_priv->vblank_pipe
      drm/i915: Wait for the clocks to stabilise before updating PLLs
      drm/i915: Periodically sanity check power management
      drm/i915: Support pageflipping interrupts for all 3-pipes on IVB
      drm/i915: Limit calling mark-busy only for potential scanouts
      drm/i915: Avoid a double-read of PCH_IIR during interrupt handling
      drm/i915: Simplify interrupt processing for IvyBridge
      drm/i915: gen6_enable_rps() wants to be called after ring initialisation
      drm/i915: Assert that the transcoder is indeed off before modifying it
      drm/i915: Introduce for_each_ring() macro
      drm/i915: Check whether the ring is initialised prior to dispatch
      drm/i915: Replace the feature tests for BLT/BSD with ring init checks
      drm/i915: Convert BUG_ON(!pll->active) and friends to a WARN
      drm/i915: Enable the PCH PLL for all generations after link training

Christian König (28):
      drm/radeon: make radeon_gpu_is_lockup a per ring function
      drm/radeon: replace gpu_lockup with ring->ready flag
      drm/radeon: register ring debugfs handlers on init
      drm/radeon: use central function for IB testing
      drm/radeon: rework gpu lockup detection and processing
      drm/radeon: fix a bug in the SA code
      drm/radeon: return -ENOENT in fence_wait_next v2
      drm/radeon: rename fence_wait_last to fence_wait_empty
      drm/radeon: don't keep list of created fences.
      drm/radeon: fix a bug with the ring syncing code
      drm/radeon: rework recursive gpu reset handling
      drm/radeon: move lockup detection code into radeon_ring.c
      drm/radeon: make lockup timeout a module param
      drm/radeon: unlock the ring mutex while waiting for the next fence
      drm/radeon: make forcing ring activity a common function
      drm/radeon: remove r300_gpu_is_lockup
      drm/radeon: remove cayman_gpu_is_lockup
      drm/radeon: replace the per ring mutex with a global one
      drm/radeon: rework locking ring emission mutex in fence deadlock detection v2
      drm/radeon: use inline functions to calc sa_bo addr
      drm/radeon: add proper locking to the SA v3
      drm/radeon: add sub allocator debugfs file
      drm/radeon: keep start and end offset in the SA
      drm/radeon: make sa bo a stand alone object
      drm/radeon: define new SA interface v3
      drm/radeon: multiple ring allocator v3
      drm/radeon: immediately free ttm-move semaphore
      drm/radeon: remove r600 blit mutex v2

Corentin Chary (1):
      drm/backlight: initialize struct backlight_properties properly

Dan Carpenter (3):
      drm/radeon: check kmalloc() for failures
      gma500: silence an unused variable warning
      drm: checking the wrong variable in savage_do_init_bci()

Daniel Kurtz (16):
      drm/i915/intel_i2c: refactor gmbus_xfer
      drm/i915/intel_i2c: cleanup error messages and comments
      drm/i915/intel_i2c: assign HDMI port D to pin pair 6
      drm/i915/intel_i2c: use i2c pre/post_xfer functions to setup gpio xfers
      drm/i915/intel_i2c: refactor using intel_gmbus_get_adapter
      drm/i915/intel_i2c: gmbus disabled and reserved ports are invalid
      drm/i915/intel_i2c: allocate gmbus array as part of drm_i915_private
      drm/i915/intel_i2c: handle zero-length writes
      drm/i915/intel_i2c: use double-buffered writes
      drm/i915/intel_i2c: always wait for IDLE before clearing NAK
      drm/i915/intel_i2c: use WAIT cycle, not STOP
      drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
      drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
      drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
      drm/i915/intel_i2c: handle zero-length reads
      drm/i915/intel_i2c: reduce verbosity of some messages

Daniel Vetter (117):
      drm/i915: split out dma mapping from global gtt bind/unbind functions
      drm/i915: bind objects to the global gtt only when needed
      drm/i915: implement SNB workaround for lazy global gtt
      drm/i915: enable lazy global-gtt binding
      drm/i915: add HAS_ALIASING_PPGTT parameter for userspace
      drm/i915/sdov: switch IS_SDVOB to a flag
      drm/i915: add an explict mmio base for gpio/gmbus io
      drm/i915: enable gmbus on gen2
      drm/i915: reinstate GM45 TV detection fix
      drm/i915: s/i915_gem_do_init/i915_gem_init_global_gtt
      drm/i915: the intel gtt is _not_ an agp bridge!
      drm/i915: clear the entire gtt when using gem
      drm/i915: merge shmem_pwrite slow&fast-path
      drm/i915: merge shmem_pread slow&fast-path
      drm: add helper to clflush a virtual address range
      drm/i915: move clflushing into shmem_pread
      drm/i915: kill ranged cpu read domain support
      drm/i915: don't use gtt_pwrite on LLC cached objects
      drm/i915: don't call shmem_read_mapping unnecessarily
      drm/i915: drop gtt slowpath
      drm/i915: don't clobber userspace memory before commiting to the pread
      drm/i915: implement inline clflush for pwrite
      drm/i915: fall back to shmem pwrite when the buffer is not accessible
      drm/i915: use uncached writes in pwrite
      drm/i915: extract copy helpers from shmem_pread|pwrite
      mm: extend prefault helpers to fault in more than PAGE_SIZE
      drm/i915: fixup in-line clflushing on bit17 swizzled bos
      drm/i915: mark pwrite/pread slowpaths with unlikely
      drm/i915: split LVDS update code out of i9xx_crtc_mode_set
      drm/i915: split PLL update code out of i9xx_crtc_mode_set
      drm/i915: rip out old HWSTAM missed irq WA for vlv
      drm/i915: use render gen to switch ring irq functions
      drm/i915: extract gt interrupt handler
      drm/i915: refuse to load on gen6+ without kms
      drm/i915: disallow gem init ioctl on ilk
      drm/i915: dump the DMA fetch addr register on pre-gen6
      drm/i915: make quirks more verbose
      drm/i915: Add a dual link lvds quirk for MacBook Pro 8,2
      drm/i915: simplify ppgtt setup
      drm/i915: re-init modeset hw state after gpu reset
      drm/i915: rip out ring->irq_mask
      drm/i915: set ring->size in common ring setup code
      drm/i915: dynamically set up the render ring functions and params
      drm/i915: dynamically set up bsd ring functions and params
      drm/i915: dynamically set up blt ring functions and parameters
      drm/i915: don't set up rings on gen6+ for non-kms
      drm/i915: consolidate ring->sync-to functions
      drm/i915: abstract away ring-specific irq_get/put
      drm/i915: split out the gen5 ring irq get/put functions
      drm/i915: don't enable the gen6 bsd ring tail write enable on gen7
      drm/i915: split up ring->dispatch_execbuffer functions
      drm/i915: consolidate ring->add_request a bit
      drm/i915: don't set up gem ring functions on gen5 for !kms
      drm/i915: inline enable/disable_irq into ring->get/put_irq
      drm/i915: don't pwrite tiled objects through the gtt
      Merge tag 'v3.4-rc3' into drm-intel-next-queued
      drm/i915: implement a media hang w/a
      drm/i915: set w/a bit for snb pagefaults
      drm/i915: properly set ppgtt cacheability on snb
      drm/i915: implement w/a for incorrect guarband clipping
      drm/i915: set stc evict disable lra evict w/a
      drm/i915: invalidate render cache on gen2
      mm: fixup compilation error due to an asm write through a const pointer
      drm/i915: print computed bpp in dp link configuration
      drm/i915: [sparse] __iomem fixes for debugfs
      drm/i915: re-add static qualifier to get_cxsr_latency
      drm/i915: fixup tv load-detect on enabled but not active crtc
      drm/i915: create macros to handle masked bits
      drm/i915: implement Disable4x2SubspanOptimization w/a for ivb, too
      drm/i915: properly check for MODESET for kms driver ioctls
      drm/i915: disallow gem ums init ioctl for kms
      drm/i915: rip out GEM drm feature checks
      drm/i915: rip out dev_priv->has_gem
      drm/i915: check for kms in dri1 ioctls
      drm/i915: use the new masked bit macro some more
      drm/i915: move dri1 vblank stubs to i915_dma.c
      drm/i915: create dev_priv->dri1 dragon dungeon^W^W sub-struct
      drm/i915 disallow physical batchbuffers for KMS
      drm/i915: rip out dev_priv->tex_lru_log_granularity
      drm/i915: remove LP_RING&friends from modeset code
      drm/i915: kill intel_clear_scanline_wait
      drm/i915: rip out dri1 breadcrumb updates from gen5+ irq handlers
      drm/i915: move dri1 irq ioctl code to i915_dma.c
      drm/i915: extract dri1 breadcrumb update from irq handler
      drm/i915: move LP_RING&friends to i915_dma.c
      drm/i915: disallow clip rects on gen5+
      drm/i915: move the ips code to intel_pm.c
      drm/i915: move rps/emon function declarations
      drm/i915: kill pointless clearing of dev_priv->hws_map
      drm/i915: rework legacy GFX HWS handling
      drm/i915: fixup __iomem mixups in ringbuffer.c
      drm/i915: move pnv|ilk_gem_mem_freq to intel_pm.c
      drm/i915: rip out intel_dpio_write again
      drm/i915: rip out unnecessary calls to drm_mode_set_crtcinfo
      drm/i915: use mode values consistently when converting to sdvo dtd
      drm/i915: add interface to simulate gpu hangs
      drm/i915: rework dev->first_error locking
      drm/i915: allow the existing error_state to be destroyed
      drm/i915: simplify i915_reset a bit
      drm/i915: extract intel_gpu_reset
      drm/i915: make gpu hangman more resilient
      drm/i915: kill flags parameter for reset functions
      drm/i915: also reset the media engine on gen4/5
      drm/i915: remove modeset reset from i915_reset
      drm/i915: fix gen4 gpu reset
      Merge tag 'v3.4-rc6' into drm-intel-next
      Merge remote-tracking branch 'airlied/drm-core-next' into drm-intel-next-queued
      drm/i915: replace intel_infoframe_freq with VIDEO_DIP_FREQ_VSYNC
      drm/i915: s/i9xx_/gm45_ for the gm45 write_infoframe function
      drm/i915: s/intel_infoframe/gm45_infoframe
      MAINTAINERS: switch drm/i915 to Daniel Vetter
      drm/i915: enable semaphores on gen6 if dmar is not active
      drm/i915: disable gmbus on i830
      drm/i915: don't clobber the pipe param in sanitize_modesetting
      drm/i915: fixup infoframe support for sdvo
      drm/i915: IBX has a fixed pch pll to pch pipe mapping
      i915: add dmabuf/prime buffer sharing support.

Dave Airlie (34):
      drm/radeon: enable pci bus mastering after card is initialised (v2)
      drm/radeon/kms: attempt to avoid copying data twice on coherent cards. (v3)
      Merge branch 'drm-intel-next' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next
      drm/i915/tv: fix open-coded ARRAY_SIZE.
      vga-switcheroo: select VGA arbitration.
      drm/edid: fix collision between two patches breaking build
      Merge tag 'drm-intel-next-2012-04-23' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next
      drm/kms: reduce some messages to debug level (v2)
      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next
      drm/radeon/kms: fix warning on 32-bit in atomic fence printing
      Merge tag 'drm-intel-next-2012-05-06-merged' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next
      Merge branch 'topic/vga-switcheroo' of git://git.kernel.org/.../tiwai/sound into drm-core-next
      x86/vga: set the default device from the fixup.
      x86/vga: fix build with efi disabled.
      drm: Initial KMS driver for AST (ASpeed Technologies) 2000 series (v2)
      mgag200: initial g200se driver (v2)
      drm/kms: driver for virtual cirrus under qemu
      gma500: fix build warning
      drm/prime: expose capability flags for userspace.
      drm/cirrus/ast/mgag200: fix build without CONFIG_VGA_CONSOLE
      drm/kms: fix Kconfig for new drivers.
      Merge tag 'drm-intel-next-2012-05-20' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next
      nouveau: nouveau_set_bo_placement takes TTM flags
      Merge branch 'exynos-drm-next' of git://git.infradead.org/users/kmpark/linux-samsung into drm-core-next
      drm/prime: introduce sg->pages/addr arrays helper
      drm/prime: add exported buffers to current fprivs imported buffer list (v2)
      udl: add prime fd->handle support.
      ttm: add prime sharing support to TTM (v2)
      nouveau: add PRIME support
      Merge branch 'prime-merge' of ssh://people.freedesktop.org/~airlied/linux into drm-core-next
      drm: update ast/cirrus/mgag200 for change in TTM api
      drm/i915: make some dmabuf things static
      drm/nouveau/radeon: add static const to the dma-buf ops.
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next

Eugeni Dodonov (56):
      drm/i915: transform HAS_PCH_SPLIT in a feature check
      drm/i915: add Haswell devices and their PCI IDs
      drm/i915: add support for LynxPoint PCH
      drm/i915: add support for power wells
      drm/i915: add enumeration for DDI ports
      drm/i915: add DDI registers
      drm/i915: add DP_TP_CTL registers
      drm/i915: add DP_TP_STATUS registers
      drm/i915: add definitions for DDI_BUF_CTL registers
      drm/i915: add definition of DDI buffer translations regs
      drm/i915: add SBI registers
      drm/i915: add PIXCLK_GATE register
      drm/i915: add S PLL control
      drm/i915: add port clock selection support for HSW
      drm/i915: add SSC offsets for SBI access
      drm/i915: add LCPLL control registers
      drm/i915: add WRPLL clocks
      drm/i915: add WM_LINETIME registers
      drm/i915: add SFUSE_STRAP registers for digital port detection
      drm/i915: add definition of LPT FDI port width registers
      drm/i915: add WRPLL divider programming bits
      drm/i915: share forcewaking code between IVB and HSW
      drm/i915: haswell has 3 pipes as well
      drm/i915: share IVB cursor routine with Haswell
      drm/i915: disable rc6 on haswell for now
      drm/i915: move fbc-related functionality into intel_pm module
      drm/i915: move watermarks settings into intel_pm module
      drm/i915: fix line breaks in intel_pm
      drm/i915: move drps, rps and rc6-related functions to intel_pm
      drm/i915: move emon functionality into intel_pm module
      drm/i915: move clock gating functionality into intel_pm module
      drm/i915: add generic power management initialization
      drm/i915: add new Haswell DIP controls registers
      drm/i915: reuse Ivy Bridge interrupts code for Haswell
      drm/i915: add support for SBI ops
      drm/i915: calculate watermarks for devices that have 3 pipes
      drm/i915: properly check for pipe count
      drm/i915: show unknown sdvox registers on hdmi init
      drm/i915: do not use fdi_normal_train on Haswell
      drm/i915: detect PCH encoders on Haswell
      drm/i915: enable power wells on Haswell init
      drm/i915: add LPT PCH checks
      drm/i915: handle DDI-related assertions
      drm/i915: account for only one PCH receiver on Haswell
      drm/i915: initialize DDI buffer translations
      drm/i915: support DDI training in FDI mode
      drm/i915: use ironlake eld write routine for Haswell
      drm/i915: define Haswell watermarks and clock gating
      drm/i915: program WM_LINETIME on Haswell
      drm/i915: program iCLKIP on Lynx Point
      drm/i915: detect digital outputs on Haswell
      drm/i915: add support for DDI-controlled digital outputs
      drm/i915: add WR PLL programming table
      drm/i915: move HDMI structs to shared location
      drm/i915: prepare HDMI link for Haswell
      drm/i915: hook Haswell devices in place

Gajanan Bhat (1):
      drm/i915: program drain latency regs on ValleyView

Ian Pilcher (1):
      drm: Store vendor IDs directly in the EDID quirk structure

Ilija Hadzic (1):
      drm/radeon: eliminate redundant connector_names table

Inki Dae (4):
      Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux into drm-next
      drm/exynos: added cache attribute support for gem.
      drm/exynos: added drm prime feature.
      drm/exynos: added a feature to get gem buffer information.

Jerome Glisse (10):
      drm/radeon: avoid leaking const ib (not used yet on si and newer GPU)
      drm/radeon: fix possible lack of synchronization btw ttm and other ring
      drm/radeon: convert fence to uint64_t v4
      drm/radeon: rework fence handling, drop fence list v7
      drm/radeon: use one wait queue for all rings add fence_wait_any v2
      drm/radeon: simplify semaphore handling v2
      drm/radeon: rip out the ib pool
      drm/radeon: move the semaphore from the fence into the ib
      drm/radeon: make the ib an inline object
      drm/radeon: don't mess with hot plug detect for eDP or LVDS connector v2

Jesse Barnes (21):
      drm/i915: remove ACPI related DRM_ERRORs
      drm/i915: move NEEDS_FORCE_WAKE to i915_drv.c
      drm/i915: re-order GT IIR bit definitions
      drm/i915: add ValleyView driver structs and IS_VALLEYVIEW macro
      drm/i915: ValleyView watermark support
      drm/i915: PLL defines for VLV
      drm/i915: add DPIO support
      drm/i915: add ValleyView clock gating init
      agp/intel: map more registers for use by the GTT code
      agp/intel: add ValleyView AGP driver
      drm/i915: add ValleyView specific force wake get/put functions
      drm/i915: interrupt bit definitions for VLV
      drm/i915: ValleyView IRQ support
      drm/i915: check for disabled interrupts on ValleyView
      drm/i915: use register name when disabling VGA
      drm/i915: make DP configuration vars less confusing in ironlake_crtc_mode_se
      drm/i915: check PPS regs for sanity when using eDP
      drm/i915: disable turbo on ValleyView for now
      drm/i915: allow PCH PWM override on IVB
      drm/i915: IBX+ doesn't have separate vsync/hsync controls on the VGA DAC
      drm/i915: manage PCH PLLs separately from pipes

Jim Cromie (1):
      drm: replace open-coded ARRAY_SIZE with macro

Joe Perches (1):
      i915: Add and use pr_fmt and pr_<level>

Joonyoung Shim (6):
      drm/exynos: cleanup for hdmi platform data
      drm/exynos: use platform_get_irq_byname for hdmi
      drm/exynos: use threaded irq for hdmi hotplug
      drm/exynos: add dpms for hdmi
      drm/exynos: add PM functions for hdmi and mixer
      drm/exynos: add G2D driver

Kirill A. Shutemov (12):
      gma500: mdfld_dsi_dpi_mode_set() do not corrupt DSPSTRIDE
      gma500: psb_gtt_init(): drop unused variable
      gma500: gtt: fix __iomem sparse warnings
      gma500: sgx_reg and vdc_reg should be __iomem
      gma500: vram_addr should be __iomem
      gma500: framebuffer: mark psb_fb_helper_funcs as static
      gma500: psb_irq_turn_off_dpst() fix bit operation
      gma500: lid_state should be __iomem
      gma500: oaktrail_hdmi_i2c_handler(): base should be __iomem
      gma500: cdv_intel_lvds: mark cdv_intel_lvds_enc_funcs as static
      gma500: fix -Wmissing-include-dirs warnings
      gma500: mid-bios: rewrite VBT/GCT handling in a cleaner way

Lars-Peter Clausen (2):
      drm: Fix EDID color format parsing
      drm: Parse color format information in CEA blocks

Laurent Pinchart (6):
      drm: Delete the vblank timer synchronously at cleanup time
      drm: Don't initialize local ret variable when not needed
      drm: Miscellaneous typo fixes and documentation updates
      drm: Constify gem_vm_ops pointer
      drm: Constify drm_mode_config_funcs pointer
      drm: Make the CRTC gamma_set operation optional

Marcin Ko¶cielnicki (1):
      drm/nouveau/nvd9: Fix GPIO initialisation sequence.

Marcin Slusarz (4):
      drm/nv50: fix ramin heap size for kernel channel too
      drm/nouveau: cleanup after display init failure
      drm/nouveau: base fence timeout on time of emission
      drm/nv50: decode PGRAPH DATA_ERROR = 0x24

Mathias Fröhlich (1):
      i915: Add option to bypass vbt table.

Matthew Garrett (7):
      vgaarb: Add support for setting the default video device (v2)
      vga-switcheroo: Use vga_default_device()
      x86: Use vga_default_device() when determining whether an fb is primary
      efifb: Implement vga_default_device() (v2)
      vga: fix build when fbdev is a module
      vgaarb: Provide dummy default device functions
      vgaarb: Provide dummy default device functions

Michel Dänzer (2):
      drm/radeon: Original Radeons had PCI GART, not PCIe GART.
      drm/radeon: Also reset BCI on SI GPU reset.

Patrik Jakobsson (2):
      cdv: Fix typos in initialization of mdfld_chip_ops
      gma500: handle poulsbo cursor restriction

Paulo Zanoni (25):
      drm: add the VIC number to the CEA EDID modes
      drm: add DRM_MODE_FLAG_DBLCLK to CEA modes requiring it
      drm/i915: rename AVI InfoFrame field 'PR' to 'YQ_CN_PR'
      drm/i915: make DBLCLK modes work
      drm/i915: DSL_LINEMASK is 12 bits only on gen2
      drm/i915: change coding style of the write_infoframe functions
      drm/i915: start writing infoframes at address 0 on gen 4
      drm/i915: mask the video DIP port select
      drm/i915: break intel_infoframe_flags into _enable and _frequency
      drm/i915: disable the infoframe before changing it
      drm/i915: mask the video DIP frequency when changing it
      drm/i915: simplify intel_encoder_commit
      drm/i915: split ironlake_write_infoframe into ibx_ and cpt_
      drm/i915: ibx_write_infoframe can disable AVI
      drm/i915: set the DIP port on ibx_write_infoframe
      drm/i915: implement ironlake_wait_for_vblank
      drm: add drm_property_change_is_valid
      drm: WARN() when drm_connector_attach_property fails
      drm: create struct drm_object_properties and use it
      drm: add generic ioctls to get/set properties on any object
      drm: make the connector properties code use the object properties code
      drm: add 'count' to struct drm_object_properties
      drm: add CRTC properties
      drm/i915: small hdmi coding style cleanups
      drm/i915: implement hsw_write_infoframe

Rafa³ Mi³ecki (13):
      drm/radeon/kms: move audio params to separated struct
      drm/radeon/kms: get rid of hdmi_config_offset
      drm/radeon/kms: get rid of r600_hdmi_find_free_block
      drm/radeon/kms: keep HDMI state in separated variable
      drm/radeon/kms/hdmi: use relative offsets, official regs
      drm/radeon/kms/hdmi: enable audio packets at one place
      drm/radeon/kms/hdmi: clean&improve handling HDMI mode
      drm/radeon/kms/hdmi: helper getting ready ACR entry
      drm/radeon/hdmi: separate evergreen code
      drm/radeon/hdmi: update modesetting
      drm/radeon/hdmi: fix some coding style
      drm/radeon/hdmi: use new AFMT structs
      drm/radeon/hdmi: compile audio status in 1 function

Rob Clark (3):
      drm: pass dev to drm_vm_{open,close}_locked()
      drm: add bitmask property type
      drm: add plane properties

Robert Morell (1):
      drm: fixed: Add dfixed_frac

Santosh Nayak (2):
      agp: Remove 'break' after 'return' statement.
      agp: Use u32 __iomem annotation to silence sparse warning.

Sean Paul (2):
      drm/i915: Retry reading the PCH FDI receiver ISR
      drm/i915: Add wait_for in init_ring_common

Seung-Woo Kim (5):
      drm/exynos: fixed wrong pageflip finish event for interlace mode
      drm/exynos: enable dvi mode for dvi monitor
      drm/exynos: add additional display mode for hdmi
      drm/exynos: added source size to overlay structure
      drm/exynos: added vp scaling feature for hdmi

Shobhit Kumar (1):
      drm/i915: Enable HDMI on ValleyView

Takashi Iwai (8):
      drm/i915: Check VBIOS value for determining LVDS dual channel mode, too
      drm/i915: Add lvds_channel module option
      drm/edid: add missing NULL checks.
      drm/edid: Add a workaround for 1366x768 HD panel
      drm/edid: Add packed attribute to new gtf2 and cvt structs
      vga_switcheroo: Refactor using linked list
      vga_switcheroo: Introduce struct vga_switcheroo_client_ops
      vga_switcheroo: Add the support for audio clients

Ville Syrjälä (5):
      drm: Move drm_format_num_planes() to drm_crtc.c
      drm: Add drm_format_plane_cpp() utility function
      drm: Add drm_format_{horz, vert}_chroma_subsampling() utility functions
      drm: Add sanity checks to framebuffer creation
      drm: Unify and fix idr error handling

 Documentation/kernel-parameters.txt                |   14 +
 MAINTAINERS                                        |    4 +-
 arch/x86/include/asm/vga.h                         |    6 +
 arch/x86/pci/fixup.c                               |    3 +
 arch/x86/video/fbdev.c                             |   20 +-
 drivers/char/agp/generic.c                         |    4 +-
 drivers/char/agp/intel-agp.c                       |    5 +
 drivers/char/agp/intel-agp.h                       |   14 +
 drivers/char/agp/intel-gtt.c                       |   45 +-
 drivers/char/agp/sgi-agp.c                         |    1 -
 drivers/gpu/drm/Kconfig                            |    6 +
 drivers/gpu/drm/Makefile                           |    3 +
 drivers/gpu/drm/ast/Kconfig                        |   16 +
 drivers/gpu/drm/ast/Makefile                       |    9 +
 drivers/gpu/drm/ast/ast_dram_tables.h              |  144 +
 drivers/gpu/drm/ast/ast_drv.c                      |  244 +
 drivers/gpu/drm/ast/ast_drv.h                      |  356 +
 drivers/gpu/drm/ast/ast_fb.c                       |  341 +
 drivers/gpu/drm/ast/ast_main.c                     |  527 +
 drivers/gpu/drm/ast/ast_mode.c                     | 1160 +++
 drivers/gpu/drm/ast/ast_post.c                     | 1780 ++++
 drivers/gpu/drm/ast/ast_tables.h                   |  265 +
 drivers/gpu/drm/ast/ast_ttm.c                      |  453 +
 drivers/gpu/drm/cirrus/Kconfig                     |   12 +
 drivers/gpu/drm/cirrus/Makefile                    |    5 +
 drivers/gpu/drm/cirrus/cirrus_drv.c                |  108 +
 drivers/gpu/drm/cirrus/cirrus_drv.h                |  246 +
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |  307 +
 drivers/gpu/drm/cirrus/cirrus_main.c               |  335 +
 drivers/gpu/drm/cirrus/cirrus_mode.c               |  629 ++
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |  453 +
 drivers/gpu/drm/drm_cache.c                        |   23 +
 drivers/gpu/drm/drm_context.c                      |    9 +-
 drivers/gpu/drm/drm_crtc.c                         |  583 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |   35 +-
 drivers/gpu/drm/drm_drv.c                          |    4 +-
 drivers/gpu/drm/drm_edid.c                         |  222 +-
 drivers/gpu/drm/drm_edid_load.c                    |   12 +-
 drivers/gpu/drm/drm_edid_modes.h                   |  292 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   10 +-
 drivers/gpu/drm/drm_gem.c                          |   35 +-
 drivers/gpu/drm/drm_ioctl.c                        |    4 +
 drivers/gpu/drm/drm_irq.c                          |   23 +-
 drivers/gpu/drm/drm_lock.c                         |    2 +-
 drivers/gpu/drm/drm_prime.c                        |   48 +
 drivers/gpu/drm/drm_stub.c                         |    7 +-
 drivers/gpu/drm/drm_sysfs.c                        |   10 +-
 drivers/gpu/drm/drm_vm.c                           |   18 +-
 drivers/gpu/drm/exynos/Kconfig                     |   12 +
 drivers/gpu/drm/exynos/Makefile                    |    2 +
 drivers/gpu/drm/exynos/exynos_drm_buf.c            |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c           |    4 +
 drivers/gpu/drm/exynos/exynos_drm_crtc.h           |    4 +
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |  272 +
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.h         |   39 +
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |   43 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   17 +
 drivers/gpu/drm/exynos/exynos_drm_fb.c             |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |  937 ++
 drivers/gpu/drm/exynos/exynos_drm_g2d.h            |   36 +
 drivers/gpu/drm/exynos/exynos_drm_gem.c            |   89 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.h            |   12 +
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |   77 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h           |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.c          |   10 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  429 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |  401 +-
 drivers/gpu/drm/exynos/regs-hdmi.h                 |    6 +-
 drivers/gpu/drm/gma500/Makefile                    |    5 +-
 drivers/gpu/drm/gma500/cdv_device.c                |  231 +-
 drivers/gpu/drm/gma500/cdv_intel_crt.c             |   30 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |  697 +-
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c            |    7 -
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   76 +-
 drivers/gpu/drm/gma500/framebuffer.c               |   57 +-
 drivers/gpu/drm/gma500/gem.c                       |    2 +
 drivers/gpu/drm/gma500/gtt.c                       |   32 +-
 drivers/gpu/drm/gma500/intel_bios.c                |  274 +-
 drivers/gpu/drm/gma500/intel_bios.h                |  161 +-
 drivers/gpu/drm/gma500/mdfld_device.c              |  452 +-
 drivers/gpu/drm/gma500/mdfld_dsi_dpi.c             |    1 -
 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c      |   24 +-
 drivers/gpu/drm/gma500/mdfld_intel_display.c       |  330 +-
 drivers/gpu/drm/gma500/mid_bios.c                  |  295 +-
 drivers/gpu/drm/gma500/oaktrail.h                  |   25 +-
 drivers/gpu/drm/gma500/oaktrail_crtc.c             |  134 +-
 drivers/gpu/drm/gma500/oaktrail_device.c           |  138 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   66 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |    2 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    4 +-
 drivers/gpu/drm/gma500/opregion.c                  |  344 +
 .../drm/gma500/{intel_opregion.c => opregion.h}    |   64 +-
 drivers/gpu/drm/gma500/psb_device.c                |   75 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |   66 +-
 drivers/gpu/drm/gma500/psb_drv.h                   |  208 +-
 drivers/gpu/drm/gma500/psb_intel_display.c         |  348 +-
 drivers/gpu/drm/gma500/psb_intel_drv.h             |    9 +-
 drivers/gpu/drm/gma500/psb_intel_reg.h             |   35 +-
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |    9 +-
 drivers/gpu/drm/gma500/psb_irq.c                   |   36 +-
 drivers/gpu/drm/gma500/psb_lid.c                   |   14 +-
 drivers/gpu/drm/i915/Makefile                      |    7 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  383 +-
 drivers/gpu/drm/i915/i915_dma.c                    | 1160 +--
 drivers/gpu/drm/i915/i915_drv.c                    |  277 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  245 +-
 drivers/gpu/drm/i915/i915_gem.c                    | 1920 ++---
 drivers/gpu/drm/i915/i915_gem_debug.c              |   16 -
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |  171 +
 drivers/gpu/drm/i915/i915_gem_evict.c              |   38 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  200 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   96 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |  202 +
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   18 +-
 drivers/gpu/drm/i915/i915_ioc32.c                  |    5 +-
 drivers/gpu/drm/i915/i915_irq.c                    | 1794 +++--
 drivers/gpu/drm/i915/i915_reg.h                    |  488 +-
 drivers/gpu/drm/i915/i915_suspend.c                |   18 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |  111 +
 drivers/gpu/drm/i915/i915_trace_points.c           |    2 +
 drivers/gpu/drm/i915/intel_acpi.c                  |    3 +-
 drivers/gpu/drm/i915/intel_bios.c                  |   45 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   76 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  755 ++
 drivers/gpu/drm/i915/intel_display.c               |10088 ++++++++------------
 drivers/gpu/drm/i915/intel_dp.c                    |   46 +-
 drivers/gpu/drm/i915/intel_drv.h                   |  105 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |    6 +-
 drivers/gpu/drm/i915/intel_fb.c                    |    2 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  310 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |  384 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   11 +-
 drivers/gpu/drm/i915/intel_modes.c                 |    3 +-
 drivers/gpu/drm/i915/intel_opregion.c              |   71 +-
 drivers/gpu/drm/i915/intel_overlay.c               |  209 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   29 +-
 drivers/gpu/drm/i915/intel_pm.c                    | 3796 ++++++++
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  726 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   23 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  107 +-
 drivers/gpu/drm/i915/intel_sprite.c                |  102 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   16 +-
 drivers/gpu/drm/mgag200/Kconfig                    |   15 +
 drivers/gpu/drm/mgag200/Makefile                   |    5 +
 drivers/gpu/drm/mgag200/mgag200_drv.c              |  116 +
 drivers/gpu/drm/mgag200/mgag200_drv.h              |  276 +
 drivers/gpu/drm/mgag200/mgag200_fb.c               |  294 +
 drivers/gpu/drm/mgag200/mgag200_i2c.c              |  156 +
 drivers/gpu/drm/mgag200/mgag200_main.c             |  388 +
 drivers/gpu/drm/mgag200/mgag200_mode.c             | 1533 +++
 drivers/gpu/drm/mgag200/mgag200_reg.h              |  661 ++
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |  452 +
 drivers/gpu/drm/nouveau/Makefile                   |   11 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |    3 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |   51 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  385 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c          |   88 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    8 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |    2 -
 drivers/gpu/drm/nouveau/nouveau_display.c          |   40 +-
 drivers/gpu/drm/nouveau/nouveau_dma.h              |   35 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |   21 +
 drivers/gpu/drm/nouveau/nouveau_drv.c              |   23 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |  176 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   34 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |  578 +-
 drivers/gpu/drm/nouveau/nouveau_fence.h            |   52 +
 drivers/gpu/drm/nouveau/nouveau_fifo.h             |   32 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   11 +-
 drivers/gpu/drm/nouveau/nouveau_gpio.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_grctx.h            |    4 -
 drivers/gpu/drm/nouveau/nouveau_hw.c               |    5 -
 drivers/gpu/drm/nouveau/nouveau_mem.c              |   19 +-
 drivers/gpu/drm/nouveau/nouveau_object.c           |  215 +-
 drivers/gpu/drm/nouveau/nouveau_perf.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_pm.h               |    4 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |  163 +
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |    9 +-
 drivers/gpu/drm/nouveau/nouveau_software.h         |   69 +
 drivers/gpu/drm/nouveau/nouveau_state.c            |  270 +-
 drivers/gpu/drm/nouveau/nouveau_vm.c               |   57 +
 drivers/gpu/drm/nouveau/nouveau_vm.h               |    6 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c                |    2 +-
 drivers/gpu/drm/nouveau/nv04_display.c             |   11 +
 drivers/gpu/drm/nouveau/nv04_fbcon.c               |   48 +-
 drivers/gpu/drm/nouveau/nv04_fence.c               |  140 +
 drivers/gpu/drm/nouveau/nv04_fifo.c                |  419 +-
 drivers/gpu/drm/nouveau/nv04_graph.c               |   39 +-
 drivers/gpu/drm/nouveau/nv04_instmem.c             |   23 +-
 drivers/gpu/drm/nouveau/nv04_software.c            |  147 +
 drivers/gpu/drm/nouveau/nv10_fence.c               |  214 +
 drivers/gpu/drm/nouveau/nv10_fifo.c                |  278 +-
 drivers/gpu/drm/nouveau/nv10_graph.c               |   13 +-
 drivers/gpu/drm/nouveau/nv17_fifo.c                |  177 +
 drivers/gpu/drm/nouveau/nv20_graph.c               |    8 +-
 drivers/gpu/drm/nouveau/nv31_mpeg.c                |    4 +-
 drivers/gpu/drm/nouveau/nv40_fifo.c                |  351 +-
 drivers/gpu/drm/nouveau/nv40_graph.c               |   37 +-
 drivers/gpu/drm/nouveau/nv40_grctx.c               |   32 +-
 drivers/gpu/drm/nouveau/nv40_pm.c                  |    1 +
 drivers/gpu/drm/nouveau/nv50_crtc.c                |  102 +-
 drivers/gpu/drm/nouveau/nv50_cursor.c              |   12 +-
 drivers/gpu/drm/nouveau/nv50_dac.c                 |    6 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |   75 +-
 drivers/gpu/drm/nouveau/nv50_display.h             |    1 +
 drivers/gpu/drm/nouveau/nv50_evo.c                 |    4 +-
 drivers/gpu/drm/nouveau/nv50_fb.c                  |    4 +-
 drivers/gpu/drm/nouveau/nv50_fbcon.c               |   59 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c                |  596 +-
 drivers/gpu/drm/nouveau/nv50_graph.c               |  229 +-
 drivers/gpu/drm/nouveau/nv50_grctx.c               |   33 +-
 drivers/gpu/drm/nouveau/nv50_instmem.c             |    2 +-
 drivers/gpu/drm/nouveau/nv50_mpeg.c                |   19 +-
 drivers/gpu/drm/nouveau/nv50_software.c            |  214 +
 drivers/gpu/drm/nouveau/nv50_sor.c                 |    6 +-
 drivers/gpu/drm/nouveau/nv50_vm.c                  |    2 -
 drivers/gpu/drm/nouveau/nv84_fence.c               |  177 +
 drivers/gpu/drm/nouveau/nv84_fifo.c                |  241 +
 drivers/gpu/drm/nouveau/nv98_crypt.c               |  166 +-
 drivers/gpu/drm/nouveau/nv98_crypt.fuc             |  698 ++
 drivers/gpu/drm/nouveau/nv98_crypt.fuc.h           |  584 ++
 drivers/gpu/drm/nouveau/nva3_copy.c                |   31 +-
 drivers/gpu/drm/nouveau/nva3_pm.c                  |  290 +-
 drivers/gpu/drm/nouveau/nvc0_fbcon.c               |   54 +-
 drivers/gpu/drm/nouveau/nvc0_fence.c               |  184 +
 drivers/gpu/drm/nouveau/nvc0_fifo.c                |  310 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c               |    4 +-
 drivers/gpu/drm/nouveau/nvc0_pm.c                  |  189 +
 drivers/gpu/drm/nouveau/nvc0_software.c            |  153 +
 drivers/gpu/drm/nouveau/nvd0_display.c             |   16 +-
 drivers/gpu/drm/nouveau/nve0_fifo.c                |  423 +
 drivers/gpu/drm/nouveau/nve0_graph.c               |  831 ++
 drivers/gpu/drm/nouveau/nve0_graph.h               |   89 +
 drivers/gpu/drm/nouveau/nve0_grctx.c               | 2777 ++++++
 drivers/gpu/drm/radeon/Makefile                    |    5 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |    7 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |   27 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   20 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  155 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c        |    3 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   10 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |  216 +
 drivers/gpu/drm/radeon/evergreen_reg.h             |    2 -
 drivers/gpu/drm/radeon/evergreend.h                |  220 +
 drivers/gpu/drm/radeon/ni.c                        |   41 +-
 drivers/gpu/drm/radeon/r100.c                      |  121 +-
 drivers/gpu/drm/radeon/r200.c                      |    2 +-
 drivers/gpu/drm/radeon/r300.c                      |   34 +-
 drivers/gpu/drm/radeon/r420.c                      |    7 +-
 drivers/gpu/drm/radeon/r520.c                      |    8 +-
 drivers/gpu/drm/radeon/r600.c                      |  191 +-
 drivers/gpu/drm/radeon/r600_audio.c                |  215 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c             |  101 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   22 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  464 +-
 drivers/gpu/drm/radeon/r600_reg.h                  |   45 +-
 drivers/gpu/drm/radeon/r600d.h                     |  233 +
 drivers/gpu/drm/radeon/radeon.h                    |  235 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   44 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   27 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c          |    4 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |   66 +
 drivers/gpu/drm/radeon/radeon_connectors.c         |   56 +
 drivers/gpu/drm/radeon/radeon_cs.c                 |  143 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   42 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  113 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   18 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |  621 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |   26 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |   20 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    3 +
 drivers/gpu/drm/radeon/radeon_kms.c                |    2 -
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |    1 +
 drivers/gpu/drm/radeon/radeon_mode.h               |   15 +-
 drivers/gpu/drm/radeon/radeon_object.c             |    6 +-
 drivers/gpu/drm/radeon/radeon_object.h             |   30 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |   18 +-
 drivers/gpu/drm/radeon/radeon_prime.c              |  176 +
 drivers/gpu/drm/radeon/radeon_ring.c               |  396 +-
 drivers/gpu/drm/radeon/radeon_sa.c                 |  325 +-
 drivers/gpu/drm/radeon/radeon_semaphore.c          |  187 +-
 drivers/gpu/drm/radeon/radeon_test.c               |    8 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   67 +-
 drivers/gpu/drm/radeon/rs400.c                     |    7 +-
 drivers/gpu/drm/radeon/rs600.c                     |   48 +-
 drivers/gpu/drm/radeon/rs600d.h                    |   14 +
 drivers/gpu/drm/radeon/rs690.c                     |    7 +-
 drivers/gpu/drm/radeon/rv515.c                     |    8 +-
 drivers/gpu/drm/radeon/rv770.c                     |   12 +-
 drivers/gpu/drm/radeon/rv770d.h                    |  191 +
 drivers/gpu/drm/radeon/si.c                        |   30 +-
 drivers/gpu/drm/savage/savage_bci.c                |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   17 +-
 drivers/gpu/drm/udl/udl_drv.c                      |    8 +-
 drivers/gpu/drm/udl/udl_drv.h                      |    3 +
 drivers/gpu/drm/udl/udl_fb.c                       |    9 +
 drivers/gpu/drm/udl/udl_gem.c                      |   75 +
 drivers/gpu/drm/udl/udl_modeset.c                  |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |    2 +-
 drivers/gpu/vga/Kconfig                            |    1 +
 drivers/gpu/vga/vga_switcheroo.c                   |  284 +-
 drivers/gpu/vga/vgaarb.c                           |    9 +
 drivers/pci/pci-sysfs.c                            |    5 +
 drivers/staging/omapdrm/omap_crtc.c                |    7 -
 drivers/staging/omapdrm/omap_drv.c                 |    4 +-
 drivers/video/efifb.c                              |   79 +-
 include/drm/drm.h                                  |    6 +
 include/drm/drmP.h                                 |   19 +-
 include/drm/drm_crtc.h                             |   86 +-
 include/drm/drm_crtc_helper.h                      |   23 +-
 include/drm/drm_dp_helper.h                        |    8 +
 include/drm/drm_edid.h                             |   26 +-
 include/drm/drm_fixed.h                            |    1 +
 include/drm/drm_mode.h                             |   16 +
 include/drm/exynos_drm.h                           |   99 +-
 include/drm/i915_drm.h                             |    3 +-
 include/drm/radeon_drm.h                           |    1 -
 include/drm/ttm/ttm_bo_api.h                       |    9 +-
 include/drm/ttm/ttm_bo_driver.h                    |    2 +
 include/linux/pagemap.h                            |   64 +-
 include/linux/vga_switcheroo.h                     |   19 +-
 include/linux/vgaarb.h                             |    7 +
 323 files changed, 44702 insertions(+), 17684 deletions(-)
 create mode 100644 drivers/gpu/drm/ast/Kconfig
 create mode 100644 drivers/gpu/drm/ast/Makefile
 create mode 100644 drivers/gpu/drm/ast/ast_dram_tables.h
 create mode 100644 drivers/gpu/drm/ast/ast_drv.c
 create mode 100644 drivers/gpu/drm/ast/ast_drv.h
 create mode 100644 drivers/gpu/drm/ast/ast_fb.c
 create mode 100644 drivers/gpu/drm/ast/ast_main.c
 create mode 100644 drivers/gpu/drm/ast/ast_mode.c
 create mode 100644 drivers/gpu/drm/ast/ast_post.c
 create mode 100644 drivers/gpu/drm/ast/ast_tables.h
 create mode 100644 drivers/gpu/drm/ast/ast_ttm.c
 create mode 100644 drivers/gpu/drm/cirrus/Kconfig
 create mode 100644 drivers/gpu/drm/cirrus/Makefile
 create mode 100644 drivers/gpu/drm/cirrus/cirrus_drv.c
 create mode 100644 drivers/gpu/drm/cirrus/cirrus_drv.h
 create mode 100644 drivers/gpu/drm/cirrus/cirrus_fbdev.c
 create mode 100644 drivers/gpu/drm/cirrus/cirrus_main.c
 create mode 100644 drivers/gpu/drm/cirrus/cirrus_mode.c
 create mode 100644 drivers/gpu/drm/cirrus/cirrus_ttm.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_dmabuf.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_g2d.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_g2d.h
 create mode 100644 drivers/gpu/drm/gma500/opregion.c
 rename drivers/gpu/drm/gma500/{intel_opregion.c => opregion.h} (51%)
 create mode 100644 drivers/gpu/drm/i915/i915_gem_dmabuf.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_stolen.c
 create mode 100644 drivers/gpu/drm/i915/i915_sysfs.c
 create mode 100644 drivers/gpu/drm/i915/intel_ddi.c
 create mode 100644 drivers/gpu/drm/i915/intel_pm.c
 create mode 100644 drivers/gpu/drm/mgag200/Kconfig
 create mode 100644 drivers/gpu/drm/mgag200/Makefile
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_drv.c
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_drv.h
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_fb.c
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_i2c.c
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_main.c
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_mode.c
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_reg.h
 create mode 100644 drivers/gpu/drm/mgag200/mgag200_ttm.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_fence.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_fifo.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_prime.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_software.h
 create mode 100644 drivers/gpu/drm/nouveau/nv04_fence.c
 create mode 100644 drivers/gpu/drm/nouveau/nv04_software.c
 create mode 100644 drivers/gpu/drm/nouveau/nv10_fence.c
 create mode 100644 drivers/gpu/drm/nouveau/nv17_fifo.c
 create mode 100644 drivers/gpu/drm/nouveau/nv50_software.c
 create mode 100644 drivers/gpu/drm/nouveau/nv84_fence.c
 create mode 100644 drivers/gpu/drm/nouveau/nv84_fifo.c
 create mode 100644 drivers/gpu/drm/nouveau/nv98_crypt.fuc
 create mode 100644 drivers/gpu/drm/nouveau/nv98_crypt.fuc.h
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_fence.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_software.c
 create mode 100644 drivers/gpu/drm/nouveau/nve0_fifo.c
 create mode 100644 drivers/gpu/drm/nouveau/nve0_graph.c
 create mode 100644 drivers/gpu/drm/nouveau/nve0_graph.h
 create mode 100644 drivers/gpu/drm/nouveau/nve0_grctx.c
 create mode 100644 drivers/gpu/drm/radeon/evergreen_hdmi.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_prime.c
--29444707-1107782847-1337880771=:9794--
