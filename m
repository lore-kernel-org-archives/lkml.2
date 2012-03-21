Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab2CURbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:31:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34349 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2CURbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
Date: Thu, 22 Mar 2012 02:31:42 +0900
Message-ID: <CAAQKjZOG7c3OjCVCzwF2qWRNQdmj=DdQSAgnX5sFPAL5JuinBg@mail.gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
From: InKi Dae <daeinki@gmail.com>
To: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

now mainline has a duplicated patch set for exynos drm driver so
please revert the patch below from mainline before merging with
drm-next to avoid conflict.
subject: drm exynos: use drm_fb_helper_set_par directly
commit id: 34418c25d64844625118b5eedc493f7904d77659

this patch had already been included in Dave's drm-next. I am sorry to trouble.

Thanks,
Inki Dae

2012년 3월 21일 오후 7:47, Dave Airlie <airlied@linux.ie>님의 말:
>
> Hi Linus,
>
> This is the main drm pull request, I'm probably going to send two more
> smaller ones, will explain below.
>
> This contains a patch that is also in the fbdev tree, but it should be the
> same patch, it added an API for hot unplugging framebuffer devices, and I
> need that API for a new driver.
>
> It also contains some changes to the i2c tree which Jean has acked, and
> one change to moorestown platform stuff in x86.
>
> Highlights:
> new drivers: UDL driver for USB displaylink devices, kms only, should
> support correct hotplug operations.
> core: i2c speedups + better hotplug support, EDID overriding via firmware
> interface - allows user to load a firmware for a broken monitor/kvm from
> userspace, it even has documentation for it.
> exynos: new HDMI audio + hdmi 1.4 + virtual output driver
> gma500: code cleanup
> radeon: cleanups, CS optimisations, streamout support and pageflip fix
> nouveau: NVD9 displayport support + more reclocking work
> i915: re-enabling GMBUS, finish gpu patch (might help hibernation who
> knows), missed irq fixes, stencil tiling fixes, interlaced support,
> aliasesd PPGTT support for SNB/IVB, swizzling for SNB/IVB, semaphore fixes
>
> As well as the usual bunch of cleanups and fixes all over the place.
>
> I've got two things I'd like to merge a bit later:
>
> a) AMD support for all their new radeonhd 7000 series GPU and APUs. AMD
> dropped this a bit late due to insane internal review processes, (please
> AMD just follow Intel and let open source guys ship stuff early) however I
> don't want to penalise people who own this hardware (since its been on
> sale for 3-4 months and GPU hw doesn't exactly have a lifetime in years)
> and consign them to using closed drivers for longer than necessary. The
> changes are well contained and just plug into the driver new gpu
> functionality so they should be fairly regression proof. I just want to
> give them a bit of a run on the hw AMD kindly sent me.
>
> b) drm prime/dma-buf interface code. This is just infrastructure code to
> expose the dma-buf stuff to drm drivers and to userspace. I'm not planning
> on pushing any driver support in this cycle (except maybe exynos), but I'd
> like to get the infrastructure code in so for the next cycle I can start
> getting the driver support into the individual drivers. We have started
> driver support for i915, nouveau and udl along with I think exynos and
> omap in staging. However this code relies on the dma-buf tree being pulled
> into your tree first since it needs the latest interfaces from that tree.
> I'll push to get that tree sent asap.
>
> (oh and any warnings you see in i915 are gcc's fault from what anyone can
> see).
>
> Regards,
> Dave.
>
> The following changes since commit fde7d9049e55ab85a390be7f415d74c9f62dd0f9:
>
>  Linux 3.3-rc7 (2012-03-10 13:49:52 -0800)
>
> are available in the git repository at:
>  git://people.freedesktop.org/~airlied/linux drm-next
>
> Adam Jackson (7):
>      drm/i915: Silence _DSM errors
>      drm/i915: Implement plane-disabled assertion for PCH too
>      drm/i915: Fix assert_pch_hdmi_disabled to mention HDMI (not DP)
>      drm/i915: Remove a comment about PCH from the non-PCH path
>      drm/i915/dp: Tweak auxch clock divider for PCH
>      drm/i915/dp: Use auxch precharge value of 5 everywhere
>      drm/i915/dp: Check for AUXCH error before checking for success
>
> Alan Cox (8):
>      gma500: plug in more of the gamma functionality
>      gma500: clean up some of the struct fields we no longer use
>      gma500: now move the Oaktrail save state into its own structure
>      gma500: Kconfig documentation tweak
>      gma500: re-order calling on the fix setup so we set up after the DRM layer
>      gma500: rework register stuff sanely
>      gma500: Fix resume paths
>      gma500: suspend/resume support for Cedartrail
>
> Alex Deucher (19):
>      drm/radeon/kms/dce3+: add support for hw i2c using atom
>      drm/radeon/kms: add r1xx/r2xx support for CS_KEEP_TILING_FLAGS
>      drm/radeon/kms: add r1xx/r2xx CS support for tiled textures
>      drm/radeon/kms: add wait_for_vblank asic callback
>      drm/radeon/kms: add a radeon asic callback for mc idle
>      drm/radeon/kms: reorganize hpd callbacks
>      drm/radeon/kms: reorganize page flip callbacks
>      drm/radeon/kms: reorganize pm callbacks
>      drm/radeon/kms: reorganize copy callbacks
>      drm/radeon/kms: reorganize irq callbacks
>      drm/radeon/kms: remove unused cp callbacks from radeon_asic
>      drm/radeon/kms: make ring_start, ring_test, and ib_test per ring
>      drm/radeon/kms: reorganize gart callbacks
>      drm/radeon/kms: reorganize display callbacks
>      drm/radeon/kms: move clock/pcie setting callbacks into pm struct
>      drm/radeon/kms: reorganize surface callbacks
>      drm/radeon/kms: clean up radeon_asic struct (v2)
>      drm/radeon/kms: fix analog load detection on DVI-I connectors
>      drm/radeon/kms: add connector quirk for Fujitsu D3003-S2 board
>
> Axel Lin (1):
>      drm: Fix kcalloc parameters swapped
>
> Ben Skeggs (45):
>      drm/nouveau: move vram detection funcs to chipset-specific fb code
>      drm/nouveau: memory type detection for the really old chipsets
>      drm/nv20: split PFB code out of nv10_fb.c
>      drm/nv20-nv40: add memory type detection
>      drm/nv50: add memory type detection
>      drm/nv50: hopefully handle the DDR2/DDR3 memtype detection somewhat better
>      drm/nvc0: add initial memory type detection
>      drm/nouveau: rework the init/takedown ordering
>      drm/nouveau/pm: avoid potential divide-by-zero
>      drm/nouveau/pm: restructure bios table parsing
>      drm/nouveau/pm: readback boot perflvl *before* parsing vbios
>      drm/nouveau/pm: calculate memory timings at perflvl creation time
>      drm/nouveau/pm: embed timings into perflvl structs
>      drm/nouveau/pm: introduce ram reclocking helper
>      drm/nv50/pm: initial work towards proper memory reclocking, with timings
>      drm/nv50/disp: more accurate function to determine active crtcs
>      drm/nv50/pm: use hwsq for engine reclocking too
>      drm/nouveau/pm: track mr2 for gddr3
>      drm/nv50: fix detection of second vram rank
>      drm/nouveau/pm: detect when we need dll disabled for gddr3
>      drm/nouveau/pm: fix dll off -> dll on transitions
>      drm/nouveau/pm: rework to allow selecting separate profiles for ac/battery
>      drm/nouveau/pm: extend profile interface for destroy/init/fini
>      drm/nouveau/mem: handle dll_off for ddr2/ddr3
>      drm/nouveau: recognise DCB connector type for DP+DVI+VGA DMS-59
>      drm/nv50-nvc0/vm: support unsnooped system memory
>      drm/nvc0/fb: detect presense of second rank
>      drm/nouveau/pm: init only after display subsystem has been created
>      drm/nouveau/mxm: call mxmi to determine revision before calling mxms
>      drm/nvc0/pm: restrict pll mode to clocks that can actually use it
>      drm/nv40/pm: fix fanspeed regression
>      drm/nvc0/vram: get part count from PUNITS
>      drm/nvd0/disp: attempt to handle more than 2 crtcs if possible
>      drm/nouveau/bios: attempt acpi rom fetch before pcirom
>      drm/nouveau/bios: rework vbios shadowing
>      drm/nouveau/pm: fix oops if chipset has no pm support at all
>      drm/nouveau/dp: make functions for executing various bios tables
>      drm/nouveau/dp: move all nv50/sor-specific code out of nouveau_dp.c
>      drm/nouveau/dp: make dp dpms function common, call from sor code instead
>      drm/nvd0/disp: initial implementation of displayport
>      drm/nvd0/disp: fix dcb sor link matching in supervisor handler
>      drm/nouveau/dp: account for channel coding overhead in link training
>      drm/nvd0/disp: move syncs/magic setup to or mode_set
>      drm/nvd0/disp: disconnect encoders before reprogramming them
>      drm/nouveau: map first page of mmio early and determine chipset earlier
>
> Ben Widawsky (7):
>      agp/intel: Add pci id for hostbridge from has/qemu
>      drm/i915: argument to control retiring behavior
>      drm/i915: drm/i915: Fix recursive calls to unmap
>      drm/i915: correct lock type in destroy
>      drm/i915: use gtfifodbg
>      drm/i915: catch gtfifo errors on forcewake_put
>      drm/i915: check gtfifodbg after possibly failed writes
>
> Benson Leung (1):
>      drm/i915: Fix single msg gmbus_xfers writes
>
> Carsten Emde (1):
>      drm: allow loading an EDID as firmware to override broken monitor
>
> Chris Wilson (13):
>      drm/i915: Check that plane/pipe is disabled before removing the fb
>      drm/i915: Separate fence pin counting from normal bind pin counting
>      drm/i915: Remove the upper limit on the bo size for mapping into the CPU domain
>      drm/i915: Handle unmappable buffers during error state capture
>      drm/i915: Record the tail at each request and use it to estimate the head
>      drm/i915: Record the in-flight requests at the time of a hang
>      drm/i915: Record the position of the request upon error
>      drm/i915/lvds: Always use the presence pin for LVDS on PCH
>      drm/i915/bios: Downgrade the "signature missing" DRM_ERROR to debug
>      drm/i915: Only bump refcnt on objects scheduled for eviction
>      drm/i915: No need to search again after retiring requests
>      drm/i915: Silence the error message from i915_wait_request()
>      drm/i915: Only clear the GPU domains upon a successful finish
>
> Christian König (4):
>      drm/radeon: move ring syncing after bo validation
>      drm/radeon/kms: no need to align IB like this
>      drm/radeon: also make the cs_parse function per ring
>      drm/radeon: fix IB debugfs files for multiple cards
>
> Christoph Bumiller (1):
>      drm/nv50/display: expose color vibrance control
>
> Dan Carpenter (1):
>      drm/radeon/evergreen: make texdw[] array larger
>
> Daniel Vetter (54):
>      drm/i915: kill i915_mem.c
>      drm/i915: clarify gen2 pageflip cmd
>      drm/i915: fixup assert_pipe to take the pipe A quirk into account
>      drm/i915: switch ring->id to be a real id
>      drm/i915: refactor ring error state capture to use arrays
>      drm/i915: collect more per ring error state
>      drm/i915/ringbuffer: kill snb blt workaround
>      drm/i915: don't trash the gtt when running out of fences
>      drm/i915: refactor debugfs open function
>      drm/i915: refactor debugfs create functions
>      drm/i915: capture error_state also for stuck rings
>      drm/i915: remove the i915_batchbuffer_info debugfs file
>      drm/i915: reject GTT domain in relocations
>      drm/i915: add per-ring fault reg to error_state
>      drm/i915: fix swizzle detection for gen3
>      drm/i915: add debugfs file for swizzling information
>      drm/i915: fall through pwrite_gtt_slow to the shmem slow path
>      drm/i915: rewrite shmem_pwrite_slow to use copy_from_user
>      drm/i915: rewrite shmem_pread_slow to use copy_to_user
>      drm/i915: swizzling support for snb/ivb
>      drm/i915: consolidate swizzling control bit frobbing
>      drm/i915: add gen6+ registers to i915_swizzle_info
>      drm/i915: s/DRM_ERROR/DRM_DEBUG in i915_gem_execbuffer.c
>      drm/i915: dump even more into the error_state
>      agp/intel-gtt: export the scratch page dma address
>      agp/intel-gtt: export the gtt pagetable iomapping
>      drm/i915: initialization/teardown for the aliasing ppgtt
>      drm/i915: ppgtt binding/unbinding support
>      drm/i915: ppgtt register definitions
>      drm/i915: ppgtt debugfs info
>      drm/i915: enable ppgtt
>      Merge remote-tracking branch 'airlied/drm-fixes' into drm-intel-next-queued
>      drm/i915: clean up interlaced pipeconf bit definitions
>      drm/i915: fixup interlaced vertical timings confusion, part 1
>      drm/i915: fixup interlaced vertical timings confusion, part 2
>      drm/i915: fixup interlaced support on ilk+
>      drm/i915: don't allow interlaced pipeconf on gen2
>      drm/i915: correctly program the VSYNCSHIFT register
>      drm/i915: fixup overlay checks for interlaced modes
>      drm/i915: outstanding_lazy_request is a u32
>      drm/i915: fixup seqno allocation logic for lazy_request
>      drm/i915: enable forcewake voodoo also for gen6
>      drm/i915: fix up locking inconsistency around gem_do_init
>      drm/modes: do not enforce an odd vtotal for interlaced modes
>      Merge remote-tracking branch 'airlied/drm-next' into for-airlied
>      drm/i915: use the new hdmi_force_audio enum more
>      drm/i915: error_buffer->ring should be signed
>      drm/i915: add dev_priv to intel_gmbus
>      drm/nouveau: do a better job at hiding the NIH i2c bit-banging algo
>      i2c: export bit-banging algo functions
>      drm/i915: merge struct intel_gpio into struct intel_gmbus
>      drm/i915: merge gmbus and gpio i2c adpater into one
>      drm/i915: i2c: unconditionally set up gpio fallback
>      drm/i915: reenable gmbus on gen3+ again
>
> Danny Kukawka (1):
>      Revert "drivers/gpu/drm/i915/intel_overlay.c needs seq_file.h"
>
> Dave Airlie (19):
>      Merge branch 'for-airlied' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next
>      Merge branch 'drm-vmware-next' into drm-core-next
>      Merge tag 'drm-intel-next-2012-02-07' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next
>      drm: move pci bus master enable into driver.
>      drm: add some caps for userspace to discover more info for dumb KMS driver (v2)
>      Merge tag 'drm-intel-next-2012-02-16-merge-resolved' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next
>      drm: drop setting vm_file to filp
>      Merge branch 'drm-gma500-alanc' into drm-core-next
>      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next
>      drm/nouveau: add userspace fallback hints.
>      drm: Merge tag 'v3.3-rc7' into drm-core-next
>      drm/sysfs: protect sysfs removal code against being run twice.
>      drm/modeset: add helper to unplug all connectors from sysfs
>      drm: add core support for unplugging a device (v2)
>      drm/udl: initial UDL driver (v4)
>      drm: fix build with UDL if USB is a module
>      drm/usb: move usb support into a separate module
>      drm/radeon: dp only enable enhanced framing if sink supports.
>      Merge tag 'drm-intel-next-2012-03-01' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
>
> Eric Anholt (2):
>      drm/i915: Remove the MI_FLUSH_ENABLE setting.
>      drm/i915: Correct the bit number for the MI_FLUSH_ENABLE.
>
> Eugeni Dodonov (5):
>      drm/i915: there is no pipe CxSR on ironlake
>      drm/i915: fix typo in function name
>      drm/i915: add a LLC feature flag in device description
>      drm/i915: print out which pixel format we do not support
>      drm: give up on edid retries when i2c bus is not responding
>
> Eunchul Kim (1):
>      drm/exynos: add default pixel format for plane
>
> Felix Kuehling (1):
>      drm/radeon: fix deferred page-flip detection logic on Avivo-based ASICs
>
> Ilija Hadzic (2):
>      drm/radeon/kms: common definitions for blit copy code
>      drm/radeon/kms: remove benchmarks shorter than one page
>
> Inki Dae (4):
>      drm/exynos: added mode_fixup feature and code clean.
>      drm/exynos: update gem and buffer framework.
>      drm/exynos: added new funtion to get/put dma address.
>      drm/exynos: added virtual display driver.
>
> Jakob Bornecrantz (5):
>      vmwgfx: Rework fence event action
>      vmwgfx: Make it possible to get fence from execbuf
>      vmwgfx: Pipe fence out of screen object dirty functions
>      vmwgfx: Add page flip support
>      vmwgfx: Pick up the initial size from the width and height regs
>
> Jean Delvare (3):
>      drm/kms: Make i2c buses faster
>      drm/radeon/kms: Use the standard VESA timeout for DDC channels
>      drm/nouveau: Fix module parameter description formats
>
> Jerome Glisse (1):
>      drm/radeon: add support for evergreen/ni tiling informations v11
>
> Jesper Juhl (1):
>      intel, gma500, lvds: Fix use after free and mem leak in psb_intel_lvds_init()
>
> Jesse Barnes (3):
>      drm/i915: split 9xx refclk & sdvo tv code out
>      drm/i915: split out pll divider code
>      drm/i915: properly mask and or watermark values for sprites
>
> Joe Perches (1):
>      drm/ttm: Use pr_fmt and pr_<level>
>
> Joonyoung Shim (7):
>      drm/exynos: remove exynos_mixer.h
>      drm/exynos: add HDMI version 1.4 support
>      drm/exynos: release pending pageflip events when closed
>      drm/exynos: remove module of exynos drm subdrv
>      drm/exynos: add subdrv open/close functions
>      drm/exynos: add is_local member in exynos_drm_subdrv struct
>      drm/exynos: cleanup exynos_hdmi.h
>
> Julia Lawall (2):
>      drivers/gpu/drm/radeon/radeon_cs.c: eliminate possible double free
>      drivers/gpu/drm/savage/savage_state.c: add missing kfree
>
> Kay Sievers (1):
>      udlfb: remove sysfs framebuffer device with USB .disconnect()
>
> Kirill A. Shutemov (40):
>      gma500: make init_pm callback in struct psb_op optional
>      gma500: initial medfield merge
>      gma500: psbfb_create(): move depth initialization out of loop
>      gma500: mdfld_dsi_output_init() drop unused parameter
>      gma500: medfield: drop a bit of dead code
>      gma500: gem_glue: add missing include
>      gma500: drop unused psbfb_suspend()/psbfb_resume()
>      gma500: mark psb_fbdev_destroy() and psb_fbdev_fini() as static
>      gma500: gtt: mark psb_gtt_entry() and psb_gtt_alloc() as static
>      gma500: mmu: drop unused psb_get_default_pd_addr()
>      gma500: mmu: mark psb_mmu_free_pt() and psb_mmu_pt_alloc_map_lock() as static
>      gma500: use DRM_IOCTL_DEF_DRV instead of custom PSB_IOCTL_DEF
>      gma500: fix ioctl confict
>      gma500: psb_driver_load(): drop unused variables
>      gma500: mark psb_driver_device_is_agp() and psb_driver_preclose() as static
>      gma500: fix two -Wmissing-field-initializers warnings
>      gma500: fix cdv_intel_wait_for_vblank() prototype
>      gma500: cdv_intel_crt: add missing include
>      gma500: cdv_intel_crt: drop dead code
>      gma500: cdv_intel_crt: drop unused variables
>      gma500: cdv_intel_crt: mark few functions as static
>      gma500: cdv_intel_hdmi: add missing include
>      gma500: cdv_intel_lvds: mark few functions as static
>      gma500: cdv_intel_lvds: #if 0 currently unused functions
>      gma500: mdfld_device: mark few functions as static
>      gma500: mdfld_dsi_dpi: drop unused variables
>      gma500: mdfld_dsi_pkg_sender: fix -Wtype-limits warning
>      gma500: mdfld_intel_display: drop unused variables
>      gma500: oaktrail_crtc: mark few functions as static
>      gma500: oaktrail_crtc: drop unused variables
>      gma500: oaktrail_hdmi: drop dead code
>      gma500: oaktrail_hdmi: fix -Wmissing-field-initializers warning
>      gma500: mark oaktrail_backlight_init() as static
>      gma500: oaktrail_hdmi_i2c_access() drop unused variable
>      gma500: oaktrail_lvds_init() drop unused variable
>      gma500: drop unused psb_intel_modeset_cleanup()
>      gma500: mark psb_intel_pipe_set_base() as static
>      gma500: psb_intel_display: drop unused variables
>      gma500: mark psb_intel_sdvo_hdmi_sink_detect() as static
>      gma500: psb_irq: mark mid_{enable, disable}_pipe_event() as static
>
> Mandeep Singh Baines (1):
>      drm: remove master fd restriction on mode setting getters
>
> Marc Gariepy (1):
>      drm/i915: Ignore LVDS on hp t5745 and hp st5747 thin client
>
> Marek Olšák (9):
>      drm/radeon/kms: add support for streamout v7
>      drm/radeon/kms: skip cb/db checking if SX_MISC is 1 on r600+
>      drm/radeon/kms: make some DRM errors more informative
>      drm/radeon/kms: compute GPU addresses correctly on evergreen
>      drm/radeon/kms: optimize streamout checking for evergreen
>      drm/radeon/kms: skip db/cb/streamout checking when possible on evergreen
>      drm/radeon/kms: remove some unused variables in evergreen_cs_track
>      drm/radeon/kms: compute GPU addresses correctly on r600
>      drm/radeon/kms: skip db/cb/streamout checking when possible on r600
>
> Martin Peres (6):
>      drm/nouveau/pm: style fixes
>      drm/nouveau/pm: restore fan speed after suspend
>      drm/nouveau: move pwm_divisor to the nouveau_pm_fan struct
>      drm/nouveau/pm: improve the reclocking logs' readability
>      drm/nv50/pm: wait for all fifo-connected engines to idle before reclocking
>      drm/nv50/hwsq: some nv92 fixes
>
> Matt Turner (3):
>      drm: remove unneeded redefinition of DDC_ADDR
>      drm/radeon: use DDC_ADDR instead of hard-coding it
>      drm/i915: use DDC_ADDR instead of hard-coding it
>
> Michel Dänzer (3):
>      drm/radeon: Restrict offset for legacy hardware cursor.
>      drm/radeon: Restrict offset for legacy display engine.
>      drm/radeon: Drop radeon_gem_object_(un)pin.
>
> Paulo Zanoni (2):
>      drm/i915: set interlaced bits for TRANSCONF
>      drm/i915: add missing SDVO bits for interlaced modes on ILK
>
> Peter Ross (2):
>      drm/i915: allow interlaced mode output on the SDVO connector
>      drm/i915: allow interlaced mode output on the HDMI connector
>
> Philipp Grete (1):
>      drm/i915: Fixes distorted external screen image on HP 2730p
>
> Rob Clark (1):
>      drm: cope with platformdev->id == -1
>
> Roy Spliet (3):
>      drm/nouveau/pm: improve memory timing generation
>      drm/nouveau/pm: implement DDR2/DDR3/GDDR3/GDDR5 MR generation and validation
>      drm/nouveau/pm: several fixes for nvc0 memory timings
>
> Sascha Hauer (15):
>      drm crtc: add forgotten idr cleanup functions
>      drm/edid: drm modes have to be free with drm_mode_destroy
>      drm crtc: use drm_mode_destroy instead of kfree in drm_mode_remove
>      drm drm_fb_helper: destroy modes
>      drm: add proper return value for drm_mode_crtc_set_gamma_size
>      drm fb helper: use drm_helper_connector_dpms to do dpms
>      drm fb helper: remove unused variable conn_limit
>      drm fb helper: remove unused variable crtc_id
>      drm crtc: Fix locking comments
>      drm crtc_helper: use list_for_each_entry
>      drm exynos: use drm_fb_helper_set_par directly
>      drm: add convenience function to create an enum property
>      drm: add convenience function to create an range property
>      drm: do not set fb_info->pixmap fields
>      drm: remove unused code
>
> Sean Paul (2):
>      drm/i915: Only look for matching clocks for LVDS downclock
>      drm/i915: Don't lock panel registers when downclocking
>
> Seung-Woo Kim (1):
>      drm/exynos: enable hdmi audio feature
>
> Simon Que (1):
>      drivers: i915: Fix BLC PWM register setup
>
> Thomas Hellstrom (4):
>      vmwgfx: Clean up pending event references to struct drm_file objects on close
>      drm/vmwgfx: Treat out-of-range initial width and height as host errors
>      vmwgfx: Move function declaration to correct header
>      drm/vmwgfx: Bump driver minor
>
> Thomas Meyer (1):
>      drm/i915: Use kcalloc instead of kzalloc to allocate array
>
> Tvrtko Ursulin (1):
>      drm/radeon/kms: reduce probe latency on digital connectors
>
> Ville Syrjälä (13):
>      drm: Reject mode set with current fb if no current fb is bound
>      drm: Change drm_display_mode::type to unsigned
>      drm: Warn if mode to umode conversion overflows the destination types
>      drm: Check crtc x and y coordinates
>      drm: Make drm_mode_attachmode() void
>      drm: Fix memory leak in drm_mode_setcrtc()
>      drm: Check user mode against overflows
>      drm: Check CRTC viewport against framebuffer size
>      drm: Fix drm_mode_attachmode_crtc()
>      drm: Make drm_crtc_convert_{umode, to_umode} static and constify their params
>      drm: Handle drm_object_get() failures
>      drm: Use a flexible array member for blob property data
>      drm: Add drm_mode_copy()
>
> Wu Fengguang (2):
>      drm/i915: set AUD_CONFIG N_value_index for DisplayPort
>      drm/i915: add a "force-dvi" HDMI audio mode
>
> Xi Wang (1):
>      drm/nouveau/dp: fix bad comparison in dp_link_train_commit()
>
> Yoichi Yuasa (1):
>      gma500: Fix mmap frambuffer
>
> Yufeng Shen (1):
>      drm/i915: Fix race condition in accessing GMBUS
>
>  Documentation/EDID/1024x768.S                 |   44 +
>  Documentation/EDID/1280x1024.S                |   44 +
>  Documentation/EDID/1680x1050.S                |   44 +
>  Documentation/EDID/1920x1080.S                |   44 +
>  Documentation/EDID/HOWTO.txt                  |   39 +
>  Documentation/EDID/Makefile                   |   26 +
>  Documentation/EDID/edid.S                     |  261 ++++
>  Documentation/EDID/hex                        |    1 +
>  Documentation/kernel-parameters.txt           |   15 +
>  arch/x86/platform/mrst/mrst.c                 |   16 +
>  drivers/char/agp/intel-agp.c                  |    1 +
>  drivers/char/agp/intel-gtt.c                  |   10 +-
>  drivers/gpu/drm/Kconfig                       |   18 +
>  drivers/gpu/drm/Makefile                      |    7 +-
>  drivers/gpu/drm/drm_crtc.c                    |  448 +++++---
>  drivers/gpu/drm/drm_crtc_helper.c             |   22 +-
>  drivers/gpu/drm/drm_drv.c                     |   16 +-
>  drivers/gpu/drm/drm_edid.c                    |   12 +-
>  drivers/gpu/drm/drm_edid_load.c               |  250 ++++
>  drivers/gpu/drm/drm_fb_helper.c               |   88 +--
>  drivers/gpu/drm/drm_fops.c                    |    8 +
>  drivers/gpu/drm/drm_gem.c                     |    4 +-
>  drivers/gpu/drm/drm_ioctl.c                   |    8 +
>  drivers/gpu/drm/drm_irq.c                     |    4 +-
>  drivers/gpu/drm/drm_memory.c                  |   19 -
>  drivers/gpu/drm/drm_modes.c                   |   30 +-
>  drivers/gpu/drm/drm_pci.c                     |    2 -
>  drivers/gpu/drm/drm_platform.c                |   12 +-
>  drivers/gpu/drm/drm_stub.c                    |   26 +
>  drivers/gpu/drm/drm_sysfs.c                   |    7 +-
>  drivers/gpu/drm/drm_usb.c                     |    2 -
>  drivers/gpu/drm/drm_vm.c                      |    5 +-
>  drivers/gpu/drm/exynos/Kconfig                |   14 +-
>  drivers/gpu/drm/exynos/Makefile               |   11 +-
>  drivers/gpu/drm/exynos/exynos_ddc.c           |    1 -
>  drivers/gpu/drm/exynos/exynos_drm_buf.c       |  191 +++-
>  drivers/gpu/drm/exynos/exynos_drm_buf.h       |   22 +-
>  drivers/gpu/drm/exynos/exynos_drm_connector.c |   35 +-
>  drivers/gpu/drm/exynos/exynos_drm_core.c      |  140 +--
>  drivers/gpu/drm/exynos/exynos_drm_crtc.c      |   12 +-
>  drivers/gpu/drm/exynos/exynos_drm_drv.c       |   94 ++-
>  drivers/gpu/drm/exynos/exynos_drm_drv.h       |   38 +-
>  drivers/gpu/drm/exynos/exynos_drm_encoder.c   |   24 +-
>  drivers/gpu/drm/exynos/exynos_drm_fb.c        |    6 -
>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c     |  118 +--
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c      |   20 +-
>  drivers/gpu/drm/exynos/exynos_drm_gem.c       |  364 ++++++-
>  drivers/gpu/drm/exynos/exynos_drm_gem.h       |   29 +-
>  drivers/gpu/drm/exynos/exynos_drm_hdmi.c      |  115 +--
>  drivers/gpu/drm/exynos/exynos_drm_hdmi.h      |    5 +
>  drivers/gpu/drm/exynos/exynos_drm_plane.c     |    8 +-
>  drivers/gpu/drm/exynos/exynos_drm_vidi.c      |  676 +++++++++++
>  drivers/gpu/drm/exynos/exynos_drm_vidi.h      |   36 +
>  drivers/gpu/drm/exynos/exynos_hdmi.c          | 1437 +++++++++++++++++++++--
>  drivers/gpu/drm/exynos/exynos_hdmi.h          |   50 -
>  drivers/gpu/drm/exynos/exynos_mixer.c         |   57 +-
>  drivers/gpu/drm/exynos/exynos_mixer.h         |   92 --
>  drivers/gpu/drm/exynos/regs-hdmi.h            |  488 +++++++-
>  drivers/gpu/drm/gma500/Kconfig                |   10 +-
>  drivers/gpu/drm/gma500/Makefile               |   10 +
>  drivers/gpu/drm/gma500/cdv_device.c           |  169 +++-
>  drivers/gpu/drm/gma500/cdv_device.h           |    2 +-
>  drivers/gpu/drm/gma500/cdv_intel_crt.c        |    1 +
>  drivers/gpu/drm/gma500/cdv_intel_display.c    |   91 +--
>  drivers/gpu/drm/gma500/cdv_intel_hdmi.c       |    1 +
>  drivers/gpu/drm/gma500/cdv_intel_lvds.c       |   16 +-
>  drivers/gpu/drm/gma500/framebuffer.c          |   64 +-
>  drivers/gpu/drm/gma500/gem_glue.c             |    1 +
>  drivers/gpu/drm/gma500/gtt.c                  |    4 +-
>  drivers/gpu/drm/gma500/intel_gmbus.c          |    2 +-
>  drivers/gpu/drm/gma500/mdfld_device.c         |  691 +++++++++++
>  drivers/gpu/drm/gma500/mdfld_dsi_dpi.c        | 1017 ++++++++++++++++
>  drivers/gpu/drm/gma500/mdfld_dsi_dpi.h        |   79 ++
>  drivers/gpu/drm/gma500/mdfld_dsi_output.c     |  618 ++++++++++
>  drivers/gpu/drm/gma500/mdfld_dsi_output.h     |  378 ++++++
>  drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c |  694 +++++++++++
>  drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.h |   92 ++
>  drivers/gpu/drm/gma500/mdfld_intel_display.c  | 1180 ++++++++++++++++++
>  drivers/gpu/drm/gma500/mdfld_output.c         |   74 ++
>  drivers/gpu/drm/gma500/mdfld_output.h         |   77 ++
>  drivers/gpu/drm/gma500/mdfld_tmd_vid.c        |  201 ++++
>  drivers/gpu/drm/gma500/mdfld_tpo_vid.c        |  124 ++
>  drivers/gpu/drm/gma500/mmu.c                  |   13 +-
>  drivers/gpu/drm/gma500/oaktrail_crtc.c        |   18 +-
>  drivers/gpu/drm/gma500/oaktrail_device.c      |  211 ++--
>  drivers/gpu/drm/gma500/oaktrail_hdmi.c        |  401 +------
>  drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c    |    6 +-
>  drivers/gpu/drm/gma500/oaktrail_lvds.c        |    5 +-
>  drivers/gpu/drm/gma500/power.c                |   17 +-
>  drivers/gpu/drm/gma500/psb_device.c           |   34 +-
>  drivers/gpu/drm/gma500/psb_drv.c              |   65 +-
>  drivers/gpu/drm/gma500/psb_drv.h              |  435 ++++----
>  drivers/gpu/drm/gma500/psb_intel_display.c    |   50 +-
>  drivers/gpu/drm/gma500/psb_intel_lvds.c       |   21 +-
>  drivers/gpu/drm/gma500/psb_intel_reg.h        |    9 +
>  drivers/gpu/drm/gma500/psb_intel_sdvo.c       |   30 +-
>  drivers/gpu/drm/gma500/psb_irq.c              |   62 +-
>  drivers/gpu/drm/gma500/psb_irq.h              |    2 +
>  drivers/gpu/drm/gma500/tc35876x-dsi-lvds.c    |  829 +++++++++++++
>  drivers/gpu/drm/gma500/tc35876x-dsi-lvds.h    |   38 +
>  drivers/gpu/drm/i2c/ch7006_drv.c              |    5 +-
>  drivers/gpu/drm/i810/i810_dma.c               |    3 +-
>  drivers/gpu/drm/i915/Makefile                 |    2 +-
>  drivers/gpu/drm/i915/i915_debugfs.c           |  324 +++---
>  drivers/gpu/drm/i915/i915_dma.c               |   66 +-
>  drivers/gpu/drm/i915/i915_drv.c               |   49 +-
>  drivers/gpu/drm/i915/i915_drv.h               |  164 ++-
>  drivers/gpu/drm/i915/i915_gem.c               |  528 +++++----
>  drivers/gpu/drm/i915/i915_gem_evict.c         |   21 +-
>  drivers/gpu/drm/i915/i915_gem_execbuffer.c    |  205 ++--
>  drivers/gpu/drm/i915/i915_gem_gtt.c           |  275 +++++-
>  drivers/gpu/drm/i915/i915_gem_tiling.c        |   23 +-
>  drivers/gpu/drm/i915/i915_irq.c               |  197 ++--
>  drivers/gpu/drm/i915/i915_mem.c               |  387 ------
>  drivers/gpu/drm/i915/i915_reg.h               |  132 ++-
>  drivers/gpu/drm/i915/intel_acpi.c             |    2 +-
>  drivers/gpu/drm/i915/intel_bios.c             |    4 +-
>  drivers/gpu/drm/i915/intel_crt.c              |    5 +-
>  drivers/gpu/drm/i915/intel_display.c          |  388 ++++---
>  drivers/gpu/drm/i915/intel_dp.c               |   23 +-
>  drivers/gpu/drm/i915/intel_drv.h              |    1 +
>  drivers/gpu/drm/i915/intel_dvo.c              |    1 -
>  drivers/gpu/drm/i915/intel_fb.c               |    6 +-
>  drivers/gpu/drm/i915/intel_hdmi.c             |   23 +-
>  drivers/gpu/drm/i915/intel_i2c.c              |  210 ++--
>  drivers/gpu/drm/i915/intel_lvds.c             |   31 +
>  drivers/gpu/drm/i915/intel_modes.c            |   34 +-
>  drivers/gpu/drm/i915/intel_overlay.c          |   18 +-
>  drivers/gpu/drm/i915/intel_panel.c            |    6 +-
>  drivers/gpu/drm/i915/intel_ringbuffer.c       |  210 ++--
>  drivers/gpu/drm/i915/intel_ringbuffer.h       |   35 +-
>  drivers/gpu/drm/i915/intel_sdvo.c             |   43 +-
>  drivers/gpu/drm/i915/intel_sprite.c           |    4 +-
>  drivers/gpu/drm/i915/intel_tv.c               |    2 +-
>  drivers/gpu/drm/mga/mga_dma.c                 |    2 +
>  drivers/gpu/drm/nouveau/Makefile              |    3 +-
>  drivers/gpu/drm/nouveau/nouveau_bios.c        |  275 +++--
>  drivers/gpu/drm/nouveau/nouveau_bios.h        |    6 +-
>  drivers/gpu/drm/nouveau/nouveau_connector.c   |   29 +-
>  drivers/gpu/drm/nouveau/nouveau_crtc.h        |    3 +
>  drivers/gpu/drm/nouveau/nouveau_display.c     |   37 +-
>  drivers/gpu/drm/nouveau/nouveau_dp.c          |  314 ++----
>  drivers/gpu/drm/nouveau/nouveau_drv.c         |   18 +-
>  drivers/gpu/drm/nouveau/nouveau_drv.h         |  150 ++-
>  drivers/gpu/drm/nouveau/nouveau_encoder.h     |   18 +
>  drivers/gpu/drm/nouveau/nouveau_fbcon.c       |    6 +-
>  drivers/gpu/drm/nouveau/nouveau_i2c.c         |    8 +-
>  drivers/gpu/drm/nouveau/nouveau_mem.c         |  809 +++++++++----
>  drivers/gpu/drm/nouveau/nouveau_mxm.c         |   39 +-
>  drivers/gpu/drm/nouveau/nouveau_perf.c        |  409 ++++---
>  drivers/gpu/drm/nouveau/nouveau_pm.c          |  235 +++-
>  drivers/gpu/drm/nouveau/nouveau_pm.h          |   22 +
>  drivers/gpu/drm/nouveau/nouveau_state.c       |  232 ++--
>  drivers/gpu/drm/nouveau/nv04_fb.c             |   34 +
>  drivers/gpu/drm/nouveau/nv10_fb.c             |  126 +--
>  drivers/gpu/drm/nouveau/nv20_fb.c             |  148 +++
>  drivers/gpu/drm/nouveau/nv40_fb.c             |   45 +
>  drivers/gpu/drm/nouveau/nv50_crtc.c           |   42 +-
>  drivers/gpu/drm/nouveau/nv50_dac.c            |    7 +-
>  drivers/gpu/drm/nouveau/nv50_display.c        |   27 +-
>  drivers/gpu/drm/nouveau/nv50_display.h        |    2 +
>  drivers/gpu/drm/nouveau/nv50_evo.h            |    3 +-
>  drivers/gpu/drm/nouveau/nv50_pm.c             |  397 ++++---
>  drivers/gpu/drm/nouveau/nv50_sor.c            |  213 +++-
>  drivers/gpu/drm/nouveau/nv50_vm.c             |   29 +-
>  drivers/gpu/drm/nouveau/nv50_vram.c           |   17 +
>  drivers/gpu/drm/nouveau/nvc0_pm.c             |    2 +-
>  drivers/gpu/drm/nouveau/nvc0_vm.c             |    4 +-
>  drivers/gpu/drm/nouveau/nvc0_vram.c           |   33 +-
>  drivers/gpu/drm/nouveau/nvd0_display.c        |  336 ++++--
>  drivers/gpu/drm/r128/r128_drv.c               |    1 +
>  drivers/gpu/drm/radeon/Makefile               |    2 +-
>  drivers/gpu/drm/radeon/atombios_crtc.c        |   20 +-
>  drivers/gpu/drm/radeon/atombios_dp.c          |    3 +-
>  drivers/gpu/drm/radeon/atombios_i2c.c         |  139 +++
>  drivers/gpu/drm/radeon/evergreen.c            |   56 +-
>  drivers/gpu/drm/radeon/evergreen_blit_kms.c   |   12 +-
>  drivers/gpu/drm/radeon/evergreen_cs.c         | 1178 +++++++++++++++++--
>  drivers/gpu/drm/radeon/evergreen_reg.h        |    1 +
>  drivers/gpu/drm/radeon/evergreend.h           |  377 ++++++
>  drivers/gpu/drm/radeon/ni.c                   |    6 +-
>  drivers/gpu/drm/radeon/r100.c                 |  109 ++-
>  drivers/gpu/drm/radeon/r200.c                 |   29 +-
>  drivers/gpu/drm/radeon/r300.c                 |    9 +-
>  drivers/gpu/drm/radeon/r420.c                 |    2 +-
>  drivers/gpu/drm/radeon/r500_reg.h             |    2 +
>  drivers/gpu/drm/radeon/r520.c                 |    4 +-
>  drivers/gpu/drm/radeon/r600.c                 |   26 +-
>  drivers/gpu/drm/radeon/r600_blit_kms.c        |   15 +-
>  drivers/gpu/drm/radeon/r600_cs.c              |  629 +++++++---
>  drivers/gpu/drm/radeon/r600d.h                |   20 +
>  drivers/gpu/drm/radeon/radeon.h               |  241 +++--
>  drivers/gpu/drm/radeon/radeon_asic.c          | 1579 +++++++++++++++----------
>  drivers/gpu/drm/radeon/radeon_asic.h          |   24 +-
>  drivers/gpu/drm/radeon/radeon_atombios.c      |   14 +
>  drivers/gpu/drm/radeon/radeon_benchmark.c     |   24 +-
>  drivers/gpu/drm/radeon/radeon_blit_common.h   |   44 +
>  drivers/gpu/drm/radeon/radeon_clocks.c        |    2 +-
>  drivers/gpu/drm/radeon/radeon_connectors.c    |   31 +
>  drivers/gpu/drm/radeon/radeon_cp.c            |    2 +
>  drivers/gpu/drm/radeon/radeon_cs.c            |   39 +-
>  drivers/gpu/drm/radeon/radeon_cursor.c        |   20 +-
>  drivers/gpu/drm/radeon/radeon_display.c       |   90 +-
>  drivers/gpu/drm/radeon/radeon_drv.c           |    5 +-
>  drivers/gpu/drm/radeon/radeon_fb.c            |   11 +-
>  drivers/gpu/drm/radeon/radeon_gem.c           |   26 -
>  drivers/gpu/drm/radeon/radeon_i2c.c           |   32 +-
>  drivers/gpu/drm/radeon/radeon_kms.c           |    2 +
>  drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |    4 +-
>  drivers/gpu/drm/radeon/radeon_object.c        |   64 +-
>  drivers/gpu/drm/radeon/radeon_object.h        |    2 +
>  drivers/gpu/drm/radeon/radeon_pm.c            |    6 +-
>  drivers/gpu/drm/radeon/radeon_reg.h           |    2 +
>  drivers/gpu/drm/radeon/radeon_ring.c          |    8 +-
>  drivers/gpu/drm/radeon/radeon_ttm.c           |   15 +-
>  drivers/gpu/drm/radeon/reg_srcs/cayman        |   24 +-
>  drivers/gpu/drm/radeon/reg_srcs/evergreen     |   24 +-
>  drivers/gpu/drm/radeon/reg_srcs/r600          |   20 +-
>  drivers/gpu/drm/radeon/rs400.c                |    2 +-
>  drivers/gpu/drm/radeon/rs600.c                |   23 +-
>  drivers/gpu/drm/radeon/rs690.c                |    4 +-
>  drivers/gpu/drm/radeon/rv515.c                |    5 +-
>  drivers/gpu/drm/radeon/rv770.c                |    4 +-
>  drivers/gpu/drm/savage/savage_state.c         |    5 +-
>  drivers/gpu/drm/sis/sis_drv.c                 |    2 +
>  drivers/gpu/drm/ttm/ttm_agp_backend.c         |    4 +-
>  drivers/gpu/drm/ttm/ttm_bo.c                  |   72 +-
>  drivers/gpu/drm/ttm/ttm_bo_vm.c               |    5 +-
>  drivers/gpu/drm/ttm/ttm_memory.c              |   12 +-
>  drivers/gpu/drm/ttm/ttm_object.c              |    5 +-
>  drivers/gpu/drm/ttm/ttm_page_alloc.c          |   55 +-
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c      |   60 +-
>  drivers/gpu/drm/ttm/ttm_tt.c                  |    8 +-
>  drivers/gpu/drm/udl/Kconfig                   |   12 +
>  drivers/gpu/drm/udl/Makefile                  |    6 +
>  drivers/gpu/drm/udl/udl_connector.c           |  141 +++
>  drivers/gpu/drm/udl/udl_drv.c                 |   99 ++
>  drivers/gpu/drm/udl/udl_drv.h                 |  141 +++
>  drivers/gpu/drm/udl/udl_encoder.c             |   80 ++
>  drivers/gpu/drm/udl/udl_fb.c                  |  611 ++++++++++
>  drivers/gpu/drm/udl/udl_gem.c                 |  227 ++++
>  drivers/gpu/drm/udl/udl_main.c                |  338 ++++++
>  drivers/gpu/drm/udl/udl_modeset.c             |  414 +++++++
>  drivers/gpu/drm/udl/udl_transfer.c            |  253 ++++
>  drivers/gpu/drm/via/via_map.c                 |    2 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c           |   55 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h           |   10 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c       |   15 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_fb.c            |   22 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_fence.c         |  252 +++--
>  drivers/gpu/drm/vmwgfx/vmwgfx_fence.h         |    9 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c           |   91 ++-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.h           |    8 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c           |    4 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c          |   38 +-
>  drivers/i2c/algos/i2c-algo-bit.c              |    3 +-
>  drivers/video/fbmem.c                         |   18 +-
>  drivers/video/udlfb.c                         |    2 +-
>  include/drm/drm.h                             |    2 +
>  include/drm/drmP.h                            |   25 +-
>  include/drm/drm_crtc.h                        |   48 +-
>  include/drm/drm_edid.h                        |    1 +
>  include/drm/drm_fb_helper.h                   |    2 -
>  include/drm/exynos_drm.h                      |   26 +
>  include/drm/gma_drm.h                         |    2 +-
>  include/drm/i915_drm.h                        |    1 +
>  include/drm/intel-gtt.h                       |    4 +
>  include/drm/radeon_drm.h                      |   24 +-
>  include/linux/fb.h                            |    1 +
>  include/linux/i2c-algo-bit.h                  |    1 +
>  include/linux/i2c/tc35876x.h                  |   11 +
>  271 files changed, 22737 insertions(+), 6488 deletions(-)
>  create mode 100644 Documentation/EDID/1024x768.S
>  create mode 100644 Documentation/EDID/1280x1024.S
>  create mode 100644 Documentation/EDID/1680x1050.S
>  create mode 100644 Documentation/EDID/1920x1080.S
>  create mode 100644 Documentation/EDID/HOWTO.txt
>  create mode 100644 Documentation/EDID/Makefile
>  create mode 100644 Documentation/EDID/edid.S
>  create mode 100644 Documentation/EDID/hex
>  create mode 100644 drivers/gpu/drm/drm_edid_load.c
>  create mode 100644 drivers/gpu/drm/exynos/exynos_drm_vidi.c
>  create mode 100644 drivers/gpu/drm/exynos/exynos_drm_vidi.h
>  delete mode 100644 drivers/gpu/drm/exynos/exynos_mixer.h
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_device.c
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_dsi_dpi.c
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_dsi_dpi.h
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_dsi_output.c
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_dsi_output.h
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.h
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_intel_display.c
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_output.c
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_output.h
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_tmd_vid.c
>  create mode 100644 drivers/gpu/drm/gma500/mdfld_tpo_vid.c
>  create mode 100644 drivers/gpu/drm/gma500/tc35876x-dsi-lvds.c
>  create mode 100644 drivers/gpu/drm/gma500/tc35876x-dsi-lvds.h
>  delete mode 100644 drivers/gpu/drm/i915/i915_mem.c
>  create mode 100644 drivers/gpu/drm/nouveau/nv20_fb.c
>  create mode 100644 drivers/gpu/drm/radeon/atombios_i2c.c
>  create mode 100644 drivers/gpu/drm/radeon/radeon_blit_common.h
>  create mode 100644 drivers/gpu/drm/udl/Kconfig
>  create mode 100644 drivers/gpu/drm/udl/Makefile
>  create mode 100644 drivers/gpu/drm/udl/udl_connector.c
>  create mode 100644 drivers/gpu/drm/udl/udl_drv.c
>  create mode 100644 drivers/gpu/drm/udl/udl_drv.h
>  create mode 100644 drivers/gpu/drm/udl/udl_encoder.c
>  create mode 100644 drivers/gpu/drm/udl/udl_fb.c
>  create mode 100644 drivers/gpu/drm/udl/udl_gem.c
>  create mode 100644 drivers/gpu/drm/udl/udl_main.c
>  create mode 100644 drivers/gpu/drm/udl/udl_modeset.c
>  create mode 100644 drivers/gpu/drm/udl/udl_transfer.c
>  create mode 100644 include/linux/i2c/tc35876x.h
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
