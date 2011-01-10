Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1AJXAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:00:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50606 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab1AJXAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:00:16 -0500
Date: Mon, 10 Jan 2011 22:59:52 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm for rc1
Message-ID: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1432887436-1294700392=:15019"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1432887436-1294700392=:15019
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

non-drm changes:
one kref change we needed that went on list with no comments

New hardware:
radeon: add support for Fusion APUs and Radeon HD6xxx chipsets
nouveau: Fermi acceleration support (requires external fw for now)

Highlights:
core/drivers: add support for high precision vblank timestamps
radeon: pageflipping support, Gen2 PCIE support
nouveau: reworked VRAM and VM support
intel: better ILK/SNB powersaving support, Full GTT support

There are also some switcheroo patches to further improve it, though I 
have a later patch blocking on an x86 platform driver for the nvidia/intel 
switcher.

Dave.

The following changes since commit 989d873fc5b6a96695b97738dea8d9f02a60f8ab:

  Merge master.kernel.org:/home/rmk/linux-2.6-arm (2011-01-03 16:37:01 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Alex Deucher (63):
      drm/radeon/kms: add pageflip ioctl support (v3)
      drm/radeon/kms: setup mc chremap properly on r7xx/evergreen
      drm/radeon/kms: upstream ObjectID.h updates
      drm/radeon/kms: upstream atombios.h updates
      drm/radeon/kms: upstream power table updates
      drm/radeon/kms: add new family id for AMD Ontario APUs
      drm/radeon/kms: atom changes for DCE4.1 devices
      drm/radeon/kms: Add support for external encoders on fusion APUs
      drm/radeon/kms: add support for ss overrides on Fusion APUs
      drm/radeon/kms: move r7xx/evergreen to its own vram_gtt setup function
      drm/radeon/kms: MC setup changes for fusion APUs
      drm/radeon/kms: evergreen.c updates for fusion
      drm/radeon/kms: add radeon_asic struct for AMD Ontario fusion APUs
      drm/radeon/kms: fill in GPU init for AMD Ontario Fusion APUs
      drm/radeon/kms: add thermal sensor support for fusion APUs
      drm/radeon/kms: add bo blit support for Ontario fusion APUs
      drm/radeon/kms: refactor atombios power state fetching
      drm/radeon/kms: add power table parsing support for Ontario fusion APUs
      drm/radeon/kms: enable MSIs on fusion APUs
      drm/radeon/kms: add Ontario Fusion APU pci ids
      drm/radeon/kms: add Ontario APU ucode loading support
      drm/radeon/kms: improve pflip precision on r1xx-r4xx
      drm/radeon/kms: fix vram start calculation on ontario (v2)
      drm/radeon/kms: properly print ontario chip id
      drm/radeon/kms: fix DCE4.1 dig routing (v2)
      drm/radeon/kms/atom: clean up op_mask handler
      drm/radeon/kms: use LCD physical size from vbios tables if available
      drm/radeon/kms: parse the extended LCD info block
      drm/radeon/kms: disable bo moves using the blitter
      drm/radeon/kms: implement gpu lockup check for evergreen
      drm/radeon/kms: adjust quirk for acer laptop
      drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
      drm/radeon/kms: add pcie get/set lane support for r6xx/r7xx/evergreen
      drm/radeon/kms: add support for gen2 pcie link speeds
      drm/radeon/kms: set the MSB of the HDP slice size
      drm/radeon/kms: fix some typos in evergreen pm4 defines
      drm/radeon/kms: clean up ASIC_IS_DCE41() macro
      drm/radeon/kms: add NI chip families
      drm/radeon/kms: update display watermark calculations for DCE5
      drm/radeon/kms: DCE5 supports 16k display surfaces
      drm/radeon/kms: DCE5 atom SetPixelClock updates
      drm/radeon/kms: DCE5 atom spread spectrum updates
      drm/radeon/kms: DCE5 atom transmitter control updates
      drm/radeon/kms: DCE5 atom dig encoder updates
      drm/radeon/kms: dac dpms updates for DCE5
      drm/radeon/kms: dvo dpms updates for DCE5
      drm/radeon/kms: parse DCE5 encoder caps when setting up encoders
      drm/radeon/kms: handle NI thermal controller
      drm/radeon/kms: add disabled vbios accessor for NI asics
      drm/radeon/kms: fill gpu init for NI asics
      drm/radeon/kms: add backend map workaround for barts
      drm/radeon/kms: adjust default clock/vddc tracking for pm on DCE5
      drm/radeon/kms: always use writeback/events for fences on NI
      drm/radeon/kms: add bo blit support for NI
      drm/radeon/kms: add ni_reg.h
      drm/radeon/kms: add support for DCE5 display LUTs
      drm/radeon/kms: add ucode loader for NI
      drm/radeon/kms/ni: load default sclk/mclk/vddc at pm init
      drm/radeon/kms: add radeon_asic struct for NI asics
      drm/radeon/kms: don't enable pcie gen2 on NI yet
      drm/radeon/kms: add NI pci ids
      drm/radeon/kms: only enable hdmi features if the monitor supports audio
      drm/radeon/kms: disable underscan by default

Ben Hutchings (1):
      drm/nouveau: Only select ACPI_VIDEO if its dependencies are met

Ben Skeggs (91):
      drm/nouveau: tidy fifo swmthd handler a little
      drm/nouveau: disallow fbcon accel if running in interrupt context
      drm/nouveau: add per-channel mutex, use to lock access to drm's channel
      drm/nouveau: add more fine-grained locking to channel list + structures
      drm/nouveau: switch to unlocked ioctls
      drm/nouveau: remove cpu_writers lock
      drm/nouveau: fix thinko in channel locking in semaphore path
      drm/nouveau: use interruptible waits during pushbuf validation
      drm/nouveau: return error from nouveau_ramht_remove() if not found
      drm/nouveau: hook up acpi power supply change tracking
      drm/nouveau: fallback to sw fbcon if we can't get mutex immediately
      drm/nv50: remove some unnecessary PDISPLAY init
      drm/nouveau: pass gpuobj alignment request down into backing allocator
      drm/nouveau: store engine type in gpuobj class structs
      drm/nouveau: use object class structs more extensively
      drm/nouveau: only expose the object classes that are supported by the chipset
      drm/nv84: add support for the PCRYPT engine
      drm/nv50: remove excessive alignment of graph/crypt contexts
      drm/nv50: create graph and crypt contexts on demand
      drm/nv50: clearer separation of the stages of evo init
      drm/nv50: move evo handling to nv50_evo.c
      drm/nv50: initial work to allow multiple evo channels
      drm/nv50: rework evo init to match nvidia more closely
      drm/nv50: improve evo error handler when more than just channel 0 active
      drm/nv50: fix evo instmem alignment
      drm/nv10: fix thinko and let nv17 do 3d again :)
      drm/nouveau: add support for MSI
      drm/nv50: regression fix, point NVAA/NVAC at correct PM functions
      drm/nv50: fix compute object class
      drm/nv50: 0x50c0 apparently works on NVA3+ too, so lets allow it
      drm/nouveau: allow irq handlers to be installed by engine-specific code
      drm/nv84: move PCRYPT ISR out of nouveau_irq.c
      drm/nv50: move GPIO ISR to nv50_gpio.c
      drm/nv50: use register/unregister functionality for PDISPLAY ISR
      drm/nouveau: move bitfield/enum helpers to nouveau_util.c
      drm/nv04-nv40: register vblank isr
      drm/nouveau: move PFIFO ISR into nv04_fifo.c
      drm/nouveau: tidy+move PGRAPH ISRs to their respective *_graph.c files
      drm/nv04-nv40: unregister irq handler on destroy
      drm/nv50: rework PGPIO IRQ handling and hotplug detection
      drm/nouveau: simplify gpuobj suspend/resume
      drm/nouveau: rework gpu-specific instmem interfaces
      drm/nv50: allocate page for unknown PFB object in nv50_fb.c
      drm/nv50: fix 0x100c90 init for NVAF
      drm/nouveau: remove dummy page use from PCI(E)GART, use PTE present instead
      drm/nv84: fix minor issues in PCRYPT implementation
      drm/nouveau: remove some useless GETPARAMs
      drm/nouveau: tidy up and extend dma object creation interfaces
      drm/nouveau: make fifo.create_context() responsible for mapping control regs
      drm/nouveau: implicitly insert non-DMA objects into RAMHT
      drm/nouveau: introduce a util function to wait on reg != val
      drm/nouveau: no need to zero dma objects, we fill them completely anyway
      drm/nouveau: wrap calls to ttm_bo_validate()
      drm/nouveau: fix use of drm_mm_node in semaphore object
      drm/nv50: implement custom vram mm
      drm/nv50: import new vm code
      drm/nv50: implement BAR1/BAR3 management on top of new VM code
      drm/nv50: implement global channel address space on new VM code
      drm/nv50: enable 4KiB pages for small vram allocations
      drm/nv50: enable non-contig vram allocations where requested
      drm/nv50: tidy up PCIEGART implementation
      drm/nouveau: allow gpuobj vinst to be a virtual address when necessary
      drm/nouveau: kick vram functions out into an "engine"
      drm/ttm: delay freeing of old node during move_memcpy until after iounmap
      drm/nv50: fix smatch warning in nv50_vram.c
      drm/nv50: add missing license header to nv50_fbcon.c
      drm/nouveau: modify vm to accomodate dual page tables for nvc0
      drm/nvc0: import initial vm backend
      drm/nvc0: initial vm implementation, use for bar1/bar3 management
      drm/nvc0: create shared channel vm
      drm/nvc0: reject the notifier_alloc ioctl
      drm/nvc0: gpuobj_new need only check validity and init the relevant engine
      drm/nvc0: implement channel structure initialisation
      drm/nvc0: skip dma object creation for drm channel
      drm/nvc0: fix channel dma init paths
      drm/nvc0: implement fencing
      drm/nvc0: implement pfifo engine hooks
      drm/nvc0: implement pgraph engine hooks
      drm/nvc0: implement fbcon acceleration
      drm/nvc0: initial support for tiled buffer objects
      drm/nvc0: accelerate ttm buffer moves
      drm/nvc0: kill off a couple more magics
      drm/nvc0: nuke left-over debug messages
      drm/nvc0: parse a couple more PGRAPH_INTR
      drm/nv50: sync up gr data error names with rnn, use for nvc0 also
      drm/nvc0: reserve only subc 0 for kernel use
      drm/nvc0/pfifo: support for chipsets with only one PSUBFIFO (0xc1)
      drm/nvc0/pgraph: more unit names
      drm/nvc0/pgraph: fix 0x406028/0x405870 init
      drm/nvc0: fix init without firmware present
      drm/nouveau: create grctx on the fly on all chipsets

Chris Wilson (135):
      drm/i915/ringbuffer: Drop the redundant dev from the vfunc interface
      drm/i915: Propagate errors from writing to ringbuffer
      drm/i915: Move object to GPU domains after dispatching execbuffer
      drm/i915: Fix hangcheck to handle multiple rings
      drm/i915/debugfs: Include info for the other rings
      drm/i915: Remove the confusing global waiting/irq seqno
      drm/i915: Propagate error from failing to queue a request
      drm/i915: Bail early if we try to mmap an object too large to be mapped.
      drm/i915: Use the agp_size determined from the GTT
      drm/i915: Capture ERROR register on Sandybridge hangs
      drm/i915: Use pci_iomap for remapping the MMIO registers.
      drm/i915/ringbuffer: Check that we setup the ringbuffer
      drm/i915: Make the inactive object shrinker per-device
      drm/i915: Remove mmap_offset
      drm/i915: Eliminate nested get/put pages
      drm/i915: Kill GTT mappings when moving from GTT domain
      drm/i915: Do not return -1 from shrinker when nr_to_scan == 0
      drm/i915: Convert BUG_ON(pin_count) from an impossible condition
      drm/i915: Only enforce fence limits inside the GTT.
      drm/i915: Remove the duplicate domain-change tracepoint for GPU flush
      drm/i915/ringbuffer: Disable the ringbuffer on cleanup.
      drm/i915: Record BLT engine error state
      drm/i915/ringbuffer: Remove duplicate initialisation of ring control
      agp/intel: Sandybridge doesn't require GMCH enabling
      drm/i915/debugfs: Display the contents of the BLT and BSD status pages
      drm/i915: Switch to using pci_iounmap in conjunction with pci_iomap
      drm/i915: Check if the GPU hung whilst waiting for the ring to clear
      drm/i915/ringbuffer: Use the HEAD auto-reporting mechanism
      drm/i915: Record BSD engine error state
      drm/i915: Fix typo from e5281ccd in i915_gem_attach_phys_object()
      drm/i915: Evict just the purgeable GTT entries on the first pass
      agp/intel: the GMCH is always enabled for integrated processor graphics
      drm/i915/debugfs: Report ring in error state
      drm/i915: Apply big hammer to serialise buffer access between rings
      drm/i915: Move the invalidate|flush information out of the device struct
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Revert "drm/i915: add MMIO debug output"
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Drop the iomem accessors when writing to the kmapped blt batch
      drm/i915: Ensure that if we ever try to pin+fence it is mappable.
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Handle GPU hangs during fault gracefully.
      drm/i915/ringbuffer: Be consistent in use of ring->size when initialising
      drm/i915/ringbuffer: Ignore failure to setup the ring on Sandybridge
      drm/i915: POSTING_READs are simply flushes and so irrelevant to tracing
      drm/i915: Fix unload after failed initialisation
      drm/i915: Unconditionally get the fence reg when pinning scanout
      drm/i915: Only add the lazy request if we end up waiting for it.
      drm/i915: Remove the global irq wait queue
      Revert "drm/i915/ringbuffer: Ignore failure to setup the ring on Sandybridge"
      drm/i915: Remove the definitions for Primary Ring Buffer
      drm/i915: Fix current tiling check for relaxed fencing
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Convert (void)I915_READ to POSTING_READ
      drm/i915/crt: Introduce struct intel_crt
      drm/i915: Capture pinned buffers on error
      drm/i915: Capture interesting display registers on error
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-next' of arrandale:git/linux-2.6 into drm-intel-next
      drm/i915: Avoid oops when capturing NULL ring for inactive pinned buffers
      drm/i915/panel: Restore saved value of BLC_PWM_CTL
      drm/i915: Compute physical addresses from base of stolen memory
      agp/intel: Remove the artificial cap on stolen size
      agp/intel: Remove confusion of stolen entries not stolen memory
      drm/i915: Contract the magic IPS constants into a direct LUT
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Use drm_i915_gem_object as the preferred type
      drm/i915: Not all mappable regions require GTT fence regions
      agp/intel: Remove duplicate const
      drm/i915: Record fence registers on error.
      drm/i915: Move the implementation details of PIPE_CONTROL to the ringbuffer
      drm/i915: Remove a defunct BUG_ON
      drm/i915: Extend hangcheck timeout
      drm/i915: Thread the pipelining ring through the callers.
      drm/i915: Rework execbuffer pinning
      drm/i915: More accurately track last fence usage by the GPU
      drm/i915: Only save and restore fences for UMS
      drm/i915: Tweak on-error bbaddr parsing for clarity
      drm/i915: Mark a few functions as __must_check
      drm/i915: Defer accounting until read from debugfs
      drm/i915: Split i915_gem_execbuffer into its own file.
      drm/i915: Avoid allocation for execbuffer object list
      drm/i915/execbuffer: On error, starting unwinding from the previous object
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Release fenced GTT mapping on suspend
      drm/i915: Move instruction state invalidation from execbuffer to flush
      drm/i915/ringbuffer: Handle cliprects in the caller
      drm/i915/lvds: Disable panel-fitter on gen4 for 1:1 scale factors
      drm/i915: Prevent stalling for a GTT read back from a read-only GPU target
      drm/i915: Pipelined fencing [infrastructure]
      drm/i915: Remove inactive LRU tracking from set_domain_ioctl
      drm/i915: Kill the get_fence tracepoint
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915/lvds: Connect the PWM to the LVDS pipe
      drm/i915: Explain why we need to write DPLL twice
      drm/i915: Enable CB tuning of the Display PLL
      drm/i915: Re-enable RC6 for power-savings.
      drm/i915: Allow LVDS to be on pipe A for Ironlake+
      drm/i915: Be paranoid and bail on resetting if we can't take the lock.
      drm/i915: Implement GPU semaphores for inter-ring synchronisation on SNB
      drm/i915: Enable self-refresh for Ironlake
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915/dp: Trivial code tidy
      drm/i915: Avoid using PIPE_CONTROL on Ironlake
      drm/i915: Power Context register is only available for gen4 mobiles
      drm/i915: caps.has_rc6 is no longer used, remove it.
      drm/i915: Ignore fenced commands for gpu access on gen4
      drm/i915: Uncouple render/power ctx before suspending
      drm/i915: Completely disable fence pipelining.
      drm/i915: Only emit a flush if there is an outstanding gpu write
      drm/i915: Wait for the bo if a display flip is pipelined on the other ring
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Disable renderctx powersaving support for Ironlake
      drm/i915: Re-arm the idle timers if the device is still busy
      drm/i915: Eliminate drm_gem_object_lookup during relocation
      drm/i915: Mark the user reloc error paths as unlikely
      drm/i915: driver.suspend and .resume are always set
      drm/i915: Restore GTT mapping first upon resume
      drm/i915/gtt: Clear the cachelines upon resume
      drm/i915: Terminate the FORCE WAKE after we have finished reading
      drm/i915: Enable RC6 autodownclocking on Sandybridge
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915/ringbuffer: Make IRQ refcnting atomic
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Poll for seqno completion if IRQ is disabled
      drm/i915: Pass clock limits down to PLL matcher
      Revert "drm/i915: Avoid using PIPE_CONTROL on Ironlake"
      drm/i915: Wait for vblank before unpinning old fb
      Merge remote branch 'airlied/drm-core-next' into drm-intel-next
      drm/i915/sdvo: Border and stall select became test bits in gen5
      drm/i915: Enable EI mode for RCx decision making on Sandybridge
      drm/i915: Allow the application to choose the constant addressing mode
      drm/i915: Undo "Uncouple render/power ctx before suspending"
      drm: Restore the old_fb upon modeset failure

Dan Carpenter (2):
      drm/nouveau: sizeof() vs ARRAY_SIZE()
      vga_switcheroo: comparing too few characters in strncmp()

Daniel Vetter (29):
      drm_mm: add support for range-restricted fair-lru scans
      drm/i915: range-restricted eviction support
      drm/i915: range-restricted bind_to_gtt
      drm/i915: unbind unmappable objects on fault/pin
      drm/i915: use the complete gtt
      intel-gtt: save PGETBL_CTL later in the setup process
      intel-gtt: maximize ggtt size on platforms that support this
      drm/i915: add mappable to gem_object_bind tracepoint
      drm/i915: add accounting for mappable objects in gtt v2
      drm/i915: revert pageflip/mappable related abi breakage
      drm/i915: kill mappable/fenceable disdinction
      drm/i915: fix relaxed tiling for gen <= 3 && !g33
      intel-gtt: drop dcache support for i830 and later
      intel-gtt: kill unneeded sandybridge memory types
      intel-gtt: switch i81x to the write_entry helpers
      intel-gtt: switch i81x to the common initialization helpers
      intel-gtt: fold i81x-only dcache support into the generic driver
      drm/i915|intel-gtt: consolidate intel-gtt.h headers
      drm/i915/gtt: call chipset flush directly
      drm: kill drm_agp_chipset_flush
      agp: kill agp_flush_chipset and corresponding ioctl
      drm/i915: track objects in the gtt
      drm/i915: restore gtt on resume in the drm instead of in intel-gtt.ko
      agp: kill agp_rebind_memory
      drm/i915: move gtt handling to i915_gem_gtt.c
      intel-gtt: export api for drm/i915
      drm/i915: no more agp for gem
      drm/i915: Add a mechanism for pipelining fence register updates
      radeon: consolidate asic-specific function decls for pre-r600

Dave Airlie (20):
      drm/ttm: Add a bo list reserve fastpath (v2)
      Merge branch 'drm-ttm-next' into drm-core-next
      Merge branch 'drm-radeon-next' of ../drm-radeon-next into drm-core-next
      Merge branch 'drm-radeon-fusion' of ../drm-radeon-next into drm-core-next
      drm/radeon: add initial tracepoint support.
      Merge remote branch 'nouveau/drm-nouveau-next' of ../drm-nouveau-next into drm-core-next
      Merge remote branch 'nouveau/drm-nouveau-next' of /ssd/git/drm-nouveau-next into drm-core-next
      Merge remote branch 'intel/drm-intel-next' of /ssd/git/drm-next into drm-core-next
      Merge branch 'master' of /home/airlied/kernel/linux-2.6 into drm-core-next
      vga_switcheroo: print the IGD/DIS flag in the debugfs output.
      vga_switcheroo: make power switch handler optional
      vga_switcheroo: add debugging mux switch option.
      drm/nouveau: add delayed switch complete callback.
      nouveau/acpi: improve detection of what is IGD and what is DIS.
      vga_switcheroo: add reprobe hook for fbcon to recheck connected outputs.
      drm/switcheroo: track state of switch in drivers.
      vga_switcheroo: split switching into two stages.
      vga_switcheroo: fix build with non switcheroo enabled path.
      Merge remote branch 'nouveau/drm-nouveau-next' of ../drm-nouveau-next into drm-core-next
      Merge branch 'drm-radeon-ni' of ../drm-radeon-next into drm-core-next

David Fries (1):
      drm/kms: load fbcon from drm_kms_helper

Eric Anholt (5):
      drm/i915: Apply B-spec mandated workaround for read flushes on Ironlake.
      drm/i915: Apply display workaround required according to the B-Spec.
      drm/i915: Correct a comment about the use of the workqueue.
      drm/i915: Also reinit the BSD and BLT rings after a GPU reset.
      drm/i915: Add support for GPU reset on gen6.

Francisco Jerez (29):
      drm/nouveau: Leave BO eviction synchronization for later.
      drm/nouveau: Use lazy fence waits when doing software interchannel sync.
      drm/nouveau: Refactor context destruction to avoid a lock ordering issue.
      drm/nouveau: Fix race condition in channel refcount handling.
      drm/nouveau: Add unlocked variants of nouveau_channel_get/put.
      drm/nouveau: Fix lock unbalance on card take down.
      drm/nouveau: Implement weak channel references.
      drm/nouveau: Make fences take a weak channel reference.
      drm/nouveau: Avoid race in the interchannel sync code.
      drm/nouveau: Take fence spinlock in nouveau_fence_channel_fini().
      drm/nv40: Ignore sync-to-vblank active when waiting for idle.
      drm/nv04: Make CRTC base changes effective in the next hsync.
      drm/nouveau: Implement the vblank DRM hooks.
      drm/nouveau: Implement the pageflip ioctl.
      drm/nouveau: Call drm_vblank_pre/post_modeset() around mode setting.
      drm/nv50: Keep track of the head a channel is vsync'ing to.
      drm/nouveau: Add a separate class for the kernel channel mutex.
      drm/nouveau: Rework tile region handling.
      drm/nv20: Add Z compression support.
      drm/nouveau: Fix sleep while atomic in nouveau_bo_fence().
      drm/nouveau: fabricate DCB encoder table for iMac G4
      drm/nv04-nv40: Give "gpuobj->cinst" the same meaning as on nv50.
      drm/nv04-nv10: Don't re-enable FIFO access multiple times after IRQ dispatch.
      drm/nouveau: Synchronize with the user channel before GPU object destruction.
      drm/nouveau: Use WC memory on the AGP GART.
      drm/nouveau: Spin for a bit in nouveau_fence_wait() before yielding the CPU.
      drm/nouveau: Avoid potential race between nouveau_fence_update() and context takedown.
      drm/nv04-nv40: Fix up PCI(E) GART DMA object bus address calculation.
      drm/nv50: fix a couple of vm init issues

James Simmons (2):
      drm/fb: Don't expose mmio for fbdev emulation layer
      drm: Update fbdev fb_fix_screeninfo

Jesse Barnes (1):
      drm/i915: dynamic render p-state support for Sandy Bridge

Keith Packard (2):
      drm/i915: Take advantage of auto-polling CRT hotplug detection on PCH hardware
      drm/i915: Fix restore of 965 fence regs since the register tracing change.

Lucas Stach (1):
      drm/nouveau: fix hwmon device binding

Marcin Slusarz (1):
      drm/nouveau: fix annoying nouveau_fence type issue

Marek Ol¨ák (3):
      drm/radeon/kms: allow r500 US_FORMAT regs in the CS checker
      drm/radeon/kms: add ARGB2101010 colorbuffer support for r500
      drm/radeon/kms: manage r300 CMASK RAM access and allow CMASK clear

Mario Kleiner (7):
      drm/vblank: Add support for precise vblank timestamping.
      drm/kms/radeon: Add support for precise vblank timestamping.
      drm/kms/radeon: Reorder vblank and pageflip interrupt handling.
      drm/kms/radeon: Use high precision timestamps for pageflip completion events.
      drm/i915: Add support for precise vblank timestamping (v2)
      drm/i915: Add Guess-o-matic for pageflip timestamping.
      drm-vblank: Always return true vblank count of scheduled vblank event.

Michel Hermier (1):
      drm/nouveau: Validate channel indices passed from userspace.

Tejun Heo (1):
      drm/radeon: use system_wq instead of dev_priv->wq

Thomas Hellstrom (9):
      kref: Add a kref_sub function
      drm/ttm: Use kref_sub instead of repeatedly calling kref_put
      drm/ttm: Optimize ttm_eu_backoff_reservation
      drm/ttm: Don't deadlock on recursive multi-bo reservations
      drm/ttm/radeon/nouveau: Kill the bo lock in favour of a bo device fence_lock
      drm/ttm: Improved fencing of buffer object lists
      drm/ttm/vmwgfx: Have TTM manage the validation sequence.
      drm/ttm: Fix up io_mem_reserve / io_mem_free calling
      drm/radeon: Use the ttm execbuf utilities

Tijl Coosemans (1):
      drm/radeon: Definition of R_0003C2_GENMO_WT seems wrong

Yuanhan Liu (5):
      drm/i915: trace down all the register write and read
      drm/i915: Add untraced register read/write interface
      drm/i915: filter out the read/write of GPIO registers from debug tracing
      drm/i915: Add self-refresh support on Sandybridge
      drm/i915: Add frame buffer compression on Sandybridge

Zhenyu Wang (2):
      agp/intel: fix cache control for sandybridge
      agp/intel: restore cache behavior on sandybridge

Zou Nan hai (2):
      drm/i915: SNB BLT workaround
      drm/i915/ringbuffer: set FORCE_WAKE bit before reading ring register

 drivers/char/agp/agp.h                       |    1 -
 drivers/char/agp/compat_ioctl.c              |    1 -
 drivers/char/agp/compat_ioctl.h              |    1 -
 drivers/char/agp/frontend.c                  |    8 -
 drivers/char/agp/generic.c                   |   27 -
 drivers/char/agp/intel-agp.c                 |    5 -
 drivers/char/agp/intel-agp.h                 |   14 +-
 drivers/char/agp/intel-gtt.c                 |  778 +++---
 drivers/gpu/drm/drm_agpsupport.c             |    6 -
 drivers/gpu/drm/drm_crtc_helper.c            |   18 +-
 drivers/gpu/drm/drm_fb_helper.c              |   61 +-
 drivers/gpu/drm/drm_fops.c                   |    2 +
 drivers/gpu/drm/drm_irq.c                    |  566 ++++-
 drivers/gpu/drm/drm_mm.c                     |   40 +-
 drivers/gpu/drm/drm_stub.c                   |   10 +
 drivers/gpu/drm/i915/Makefile                |    2 +
 drivers/gpu/drm/i915/i915_debugfs.c          |  471 +++-
 drivers/gpu/drm/i915/i915_dma.c              |  794 +++---
 drivers/gpu/drm/i915/i915_drv.c              |   80 +-
 drivers/gpu/drm/i915/i915_drv.h              |  605 +++--
 drivers/gpu/drm/i915/i915_gem.c              | 3764 +++++++++-----------------
 drivers/gpu/drm/i915/i915_gem_debug.c        |   23 +-
 drivers/gpu/drm/i915/i915_gem_evict.c        |  125 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c   | 1343 +++++++++
 drivers/gpu/drm/i915/i915_gem_gtt.c          |   99 +
 drivers/gpu/drm/i915/i915_gem_tiling.c       |  139 +-
 drivers/gpu/drm/i915/i915_irq.c              |  724 ++++--
 drivers/gpu/drm/i915/i915_reg.h              |  193 ++-
 drivers/gpu/drm/i915/i915_suspend.c          |  104 +-
 drivers/gpu/drm/i915/i915_trace.h            |   91 +-
 drivers/gpu/drm/i915/intel_display.c         |  999 ++++++--
 drivers/gpu/drm/i915/intel_dp.c              |    3 +-
 drivers/gpu/drm/i915/intel_drv.h             |   22 +-
 drivers/gpu/drm/i915/intel_fb.c              |   32 +-
 drivers/gpu/drm/i915/intel_i2c.c             |   21 +-
 drivers/gpu/drm/i915/intel_lvds.c            |   43 +-
 drivers/gpu/drm/i915/intel_opregion.c        |    8 +-
 drivers/gpu/drm/i915/intel_overlay.c         |  116 +-
 drivers/gpu/drm/i915/intel_panel.c           |   52 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c      | 1007 ++++---
 drivers/gpu/drm/i915/intel_ringbuffer.h      |  136 +-
 drivers/gpu/drm/i915/intel_sdvo.c            |    7 +-
 drivers/gpu/drm/i915/intel_tv.c              |   14 +-
 drivers/gpu/drm/nouveau/Kconfig              |    2 +-
 drivers/gpu/drm/nouveau/Makefile             |   17 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c       |   11 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c       |  102 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c         |  319 ++-
 drivers/gpu/drm/nouveau/nouveau_channel.c    |  383 ++--
 drivers/gpu/drm/nouveau/nouveau_connector.c  |   54 +-
 drivers/gpu/drm/nouveau/nouveau_display.c    |  207 ++
 drivers/gpu/drm/nouveau/nouveau_dma.c        |   32 +-
 drivers/gpu/drm/nouveau/nouveau_dma.h        |    9 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c         |    6 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c        |   58 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h        |  425 ++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c      |  189 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.h      |   18 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c      |  117 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c        |  171 +-
 drivers/gpu/drm/nouveau/nouveau_hw.c         |   11 +-
 drivers/gpu/drm/nouveau/nouveau_irq.c        | 1210 +--------
 drivers/gpu/drm/nouveau/nouveau_mem.c        |  426 ++--
 drivers/gpu/drm/nouveau/nouveau_mm.c         |  271 ++
 drivers/gpu/drm/nouveau/nouveau_mm.h         |   67 +
 drivers/gpu/drm/nouveau/nouveau_notifier.c   |   44 +-
 drivers/gpu/drm/nouveau/nouveau_object.c     |  754 +++---
 drivers/gpu/drm/nouveau/nouveau_pm.c         |   33 +-
 drivers/gpu/drm/nouveau/nouveau_ramht.c      |   11 +-
 drivers/gpu/drm/nouveau/nouveau_ramht.h      |    2 +-
 drivers/gpu/drm/nouveau/nouveau_reg.h        |   75 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c      |  212 +-
 drivers/gpu/drm/nouveau/nouveau_state.c      |  300 ++-
 drivers/gpu/drm/nouveau/nouveau_util.c       |   69 +
 drivers/gpu/drm/nouveau/nouveau_util.h       |   45 +
 drivers/gpu/drm/nouveau/nouveau_vm.c         |  439 +++
 drivers/gpu/drm/nouveau/nouveau_vm.h         |  113 +
 drivers/gpu/drm/nouveau/nv04_crtc.c          |    8 +-
 drivers/gpu/drm/nouveau/nv04_dac.c           |   12 +-
 drivers/gpu/drm/nouveau/nv04_display.c       |   21 +
 drivers/gpu/drm/nouveau/nv04_fbcon.c         |  102 +-
 drivers/gpu/drm/nouveau/nv04_fifo.c          |  240 ++-
 drivers/gpu/drm/nouveau/nv04_graph.c         |  645 +++--
 drivers/gpu/drm/nouveau/nv04_instmem.c       |   50 +-
 drivers/gpu/drm/nouveau/nv10_fb.c            |  124 +-
 drivers/gpu/drm/nouveau/nv10_fifo.c          |   19 +-
 drivers/gpu/drm/nouveau/nv10_graph.c         |  203 +-
 drivers/gpu/drm/nouveau/nv20_graph.c         |  244 ++-
 drivers/gpu/drm/nouveau/nv30_fb.c            |   23 +-
 drivers/gpu/drm/nouveau/nv40_fb.c            |   22 +-
 drivers/gpu/drm/nouveau/nv40_fifo.c          |   20 +-
 drivers/gpu/drm/nouveau/nv40_graph.c         |  205 ++-
 drivers/gpu/drm/nouveau/nv50_crtc.c          |   27 +-
 drivers/gpu/drm/nouveau/nv50_display.c       |  422 +---
 drivers/gpu/drm/nouveau/nv50_display.h       |    2 -
 drivers/gpu/drm/nouveau/nv50_evo.c           |  345 +++
 drivers/gpu/drm/nouveau/nv50_evo.h           |   10 +
 drivers/gpu/drm/nouveau/nv50_fb.c            |   71 +-
 drivers/gpu/drm/nouveau/nv50_fbcon.c         |  114 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c          |   42 +-
 drivers/gpu/drm/nouveau/nv50_gpio.c          |  198 ++-
 drivers/gpu/drm/nouveau/nv50_graph.c         |  677 +++++-
 drivers/gpu/drm/nouveau/nv50_instmem.c       |  375 ++--
 drivers/gpu/drm/nouveau/nv50_vm.c            |  180 ++
 drivers/gpu/drm/nouveau/nv50_vram.c          |  190 ++
 drivers/gpu/drm/nouveau/nv84_crypt.c         |  140 +
 drivers/gpu/drm/nouveau/nvc0_fbcon.c         |  269 ++
 drivers/gpu/drm/nouveau/nvc0_fifo.c          |  365 +++
 drivers/gpu/drm/nouveau/nvc0_graph.c         |  705 +++++-
 drivers/gpu/drm/nouveau/nvc0_graph.h         |   64 +
 drivers/gpu/drm/nouveau/nvc0_grctx.c         | 2874 ++++++++++++++++++++
 drivers/gpu/drm/nouveau/nvc0_instmem.c       |  317 ++--
 drivers/gpu/drm/nouveau/nvc0_vm.c            |  123 +
 drivers/gpu/drm/nouveau/nvc0_vram.c          |   99 +
 drivers/gpu/drm/nouveau/nvreg.h              |    3 +-
 drivers/gpu/drm/radeon/Makefile              |    5 +-
 drivers/gpu/drm/radeon/ObjectID.h            |   48 +
 drivers/gpu/drm/radeon/atom.c                |   14 +-
 drivers/gpu/drm/radeon/atombios.h            |  997 +++++++-
 drivers/gpu/drm/radeon/atombios_crtc.c       |   57 +-
 drivers/gpu/drm/radeon/evergreen.c           |  806 +++++--
 drivers/gpu/drm/radeon/evergreen_blit_kms.c  |   92 +-
 drivers/gpu/drm/radeon/evergreen_reg.h       |    6 +
 drivers/gpu/drm/radeon/evergreend.h          |   53 +-
 drivers/gpu/drm/radeon/ni.c                  |  316 +++
 drivers/gpu/drm/radeon/ni_reg.h              |   86 +
 drivers/gpu/drm/radeon/nid.h                 |   41 +
 drivers/gpu/drm/radeon/r100.c                |   78 +-
 drivers/gpu/drm/radeon/r100d.h               |    2 +-
 drivers/gpu/drm/radeon/r300.c                |   21 +-
 drivers/gpu/drm/radeon/r300d.h               |    1 +
 drivers/gpu/drm/radeon/r500_reg.h            |    4 +
 drivers/gpu/drm/radeon/r600.c                |  357 ++-
 drivers/gpu/drm/radeon/r600d.h               |   48 +
 drivers/gpu/drm/radeon/radeon.h              |  151 +-
 drivers/gpu/drm/radeon/radeon_asic.c         |  153 +-
 drivers/gpu/drm/radeon/radeon_asic.h         |   65 +-
 drivers/gpu/drm/radeon/radeon_atombios.c     | 1246 ++++++----
 drivers/gpu/drm/radeon/radeon_bios.c         |   41 +
 drivers/gpu/drm/radeon/radeon_combios.c      |    3 +-
 drivers/gpu/drm/radeon/radeon_connectors.c   |    9 +-
 drivers/gpu/drm/radeon/radeon_cs.c           |   17 +-
 drivers/gpu/drm/radeon/radeon_device.c       |   35 +-
 drivers/gpu/drm/radeon/radeon_display.c      |  391 +++-
 drivers/gpu/drm/radeon/radeon_drv.c          |   11 +-
 drivers/gpu/drm/radeon/radeon_encoders.c     |  205 ++-
 drivers/gpu/drm/radeon/radeon_family.h       |    4 +
 drivers/gpu/drm/radeon/radeon_fb.c           |    4 -
 drivers/gpu/drm/radeon/radeon_fence.c        |    4 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c      |   46 +-
 drivers/gpu/drm/radeon/radeon_kms.c          |   64 +-
 drivers/gpu/drm/radeon/radeon_mode.h         |   16 +-
 drivers/gpu/drm/radeon/radeon_object.c       |   57 +-
 drivers/gpu/drm/radeon/radeon_object.h       |    7 +-
 drivers/gpu/drm/radeon/radeon_pm.c           |   94 +-
 drivers/gpu/drm/radeon/radeon_reg.h          |   13 +
 drivers/gpu/drm/radeon/radeon_trace.h        |   82 +
 drivers/gpu/drm/radeon/radeon_trace_points.c |    9 +
 drivers/gpu/drm/radeon/reg_srcs/rv515        |   16 +
 drivers/gpu/drm/radeon/rs600.c               |  118 +-
 drivers/gpu/drm/radeon/rv770.c               |  196 ++-
 drivers/gpu/drm/radeon/rv770d.h              |   47 +
 drivers/gpu/drm/ttm/ttm_bo.c                 |  156 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c            |  138 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c              |   29 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c       |  169 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h          |    1 -
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c      |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c           |    3 -
 drivers/gpu/vga/vga_switcheroo.c             |   78 +-
 include/drm/drmP.h                           |  102 +-
 include/drm/drm_crtc.h                       |    9 +
 include/drm/drm_fb_helper.h                  |    3 -
 include/drm/drm_mm.h                         |    7 +
 include/drm/drm_pciids.h                     |   40 +
 include/drm/i915_drm.h                       |   12 +
 include/drm/intel-gtt.h                      |   35 +-
 include/drm/nouveau_drm.h                    |    5 +-
 include/drm/radeon_drm.h                     |    1 +
 include/drm/ttm/ttm_bo_api.h                 |   50 +-
 include/drm/ttm/ttm_bo_driver.h              |  152 +-
 include/drm/ttm/ttm_execbuf_util.h           |   11 +-
 include/linux/agp_backend.h                  |    2 -
 include/linux/intel-gtt.h                    |   20 -
 include/linux/kref.h                         |    2 +
 include/linux/vga_switcheroo.h               |    2 +
 lib/kref.c                                   |   30 +
 187 files changed, 24781 insertions(+), 10722 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_gem_execbuffer.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_gtt.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_mm.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_mm.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_util.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_util.h
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_vm.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_vm.h
 create mode 100644 drivers/gpu/drm/nouveau/nv50_evo.c
 create mode 100644 drivers/gpu/drm/nouveau/nv50_vm.c
 create mode 100644 drivers/gpu/drm/nouveau/nv50_vram.c
 create mode 100644 drivers/gpu/drm/nouveau/nv84_crypt.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_fbcon.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_graph.h
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_grctx.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_vm.c
 create mode 100644 drivers/gpu/drm/nouveau/nvc0_vram.c
 create mode 100644 drivers/gpu/drm/radeon/ni.c
 create mode 100644 drivers/gpu/drm/radeon/ni_reg.h
 create mode 100644 drivers/gpu/drm/radeon/nid.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_trace.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_trace_points.c
 delete mode 100644 include/linux/intel-gtt.h
--29444707-1432887436-1294700392=:15019--
