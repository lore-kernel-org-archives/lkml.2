Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab0EUGZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:25:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54587 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab0EUGZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:25:18 -0400
Date: Fri, 21 May 2010 07:24:58 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [git pull] drm for 2.6.35-rc1 (revised)
In-Reply-To: <alpine.DEB.2.00.1005190310010.1205@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1005210718460.16929@skynet.skynet.ie>
References: <alpine.DEB.2.00.1005190310010.1205@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1065480061-1274423098=:16929"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1065480061-1274423098=:16929
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Original pull details below: note new branch name, I didn't mean to use 
drm-next branch though the contents were totally correct.

Changes since prev req: I missed a nouveau fixes tree from Ben, its mainly 
displayport + i2c fixes for a bunch of Dell laptops we have them all in 
F13 already I think. there are also a few radeon kms fixes + another drm 
mode typo fix that came in over the last few days.

I'm on holidays until next week so let me know if there is anything wrong 
on your end as I'm really not meant to be compiling kernels instead of 
playing with my daughter.

Dave.

> This is a combined drm/agp tree.
> 
> Highlights:
> core: initial dev docs, agp scratch page support
> kms: framebuffer cleanup + improved disconnected monitor at boot handling, 
> lots of edid parser updates to bring us in line with the X.org code, 
> improved fbdev handover mechanism.
> 
> ttm: add AGP page pool support to increase AGP speed.
> 
> radeon kms: initial powermanagement support - for all radeon GPU families, 
> this needs more work but it really needs to be upstream so we can get some 
> feedback now. PM on GPUs is a very complex task. There are two modes of 
> operation a profile driven mode and a dynamic mode, the dynamic mode can 
> potentially save more power but is also more likely to glitch on screen.
> evergreen irq/basic accel hw setup code.
> full access to VRAM beyond PCI BAR
> 
> Intel kms:
> split intel agp driver into two drivers, one for AGP, one for GTT.
> move intel sdvo to proper encoder/connector organisation
> Intel Cougarpoint support
> 
> This merge has one patch in x86 land which is acked on the list by the 
> proper people.
> 
> Dave.
> 

The following changes since commit 722154e4cacf015161efe60009ae9be23d492296:
  Linus Torvalds (1):
        Merge branch 'zerolen' of git://git.kernel.org/.../jgarzik/misc-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-for-2.6.35

Adam Jackson (25):
      drm/edid: Fix secondary block fetch.
      drm/edid: Remove some misleading comments
      drm/edid: Remove a redundant check
      drm/edid: Reshuffle mode list construction to closer match the spec
      drm/edid: Add modes for Established Timings III section
      drm/edid: Remove arbitrary EDID extension limit
      drm/edid: Remove some silly comments
      drm/edid: Fix preferred mode parse for EDID 1.4
      drm/edid: Add test for monitor reduced blanking support.
      drm/edid: Extend range-based mode addition for EDID 1.4
      drm/edid: Fix the HDTV hack.
      drm/edid: Strengthen the algorithm for standard mode codes
      drm/edid: Add secondary GTF curve support
      drm/modes: Fix interlaced mode names
      drm/edid: Fix sync polarity for secondary GTF curve
      drm/edid: When checking duplicate standard modes, walked the probed list
      drm/i915: Allow LVDS on pipe A on gen4+
      drm/i915: Un-magic a DPCD register write
      drm/i915: Set sync polarity correctly on DisplayPort
      drm/i915/pch: Use minimal number of FDI lanes (v2)
      drm/i915: Use spatio-temporal dithering on PCH
      drm/i915: Make fbc control wrapper functions
      drm/i915: Fix DDC bus selection for multifunction SDVO
      drm/i915: Be extra careful about A/D matching for multifunction SDVO
      drm/edid: Fix 1024x768@85Hz

Alex Deucher (42):
      drm/radeon/kms: update atombios.h power tables for evergreen
      drm/radeon/kms: add support for evergreen power tables
      drm/radeon/kms/evergreen: add gart support
      drm/radeon/kms/evergreen: add soft reset function
      drm/radeon/kms/evergreen: implement gfx init
      drm/radeon/kms/evergreen: setup and enable the CP
      drm/radeon/kms/evergreen: implement irq support
      drm/radeon/kms/evergreen: add hpd support
      drm/radeon/kms/atom: disable the encoders in encoder_disable
      drm/radeon/kms: fix copy pasto in disable encoders patch
      drm/radeon/kms/atom: fix typo in LVDS panel info parsing
      drm/radeon/kms/combios: match lvds panel info parsing to ddx
      drm/radeon/kms: add gui_idle callback
      drm/radeon/kms: add support for gui idle interrupts (v4)
      drm/radeon/kms: wait for gpu idle before changing power mode
      drm/radeon/kms/atom/pm: rework power mode parsing
      drm/radeon/kms/pm: interate across crtcs for vblank
      drm/radeon/kms/pm: move pm state update to crtc functions
      drm/radeon/kms/pm: add asic specific callbacks for setting power state (v2)
      drm/radeon/kms/pm: add asic specific callbacks for getting power state (v2)
      drm/radeon/kms/pm: update display watermarks with power state changes
      drm/radeon/kms/atom: load hwmon drivers
      drm/radeon/kms/pm: don't enable pm if there is only on power state
      drm/radeon/kms/pm: clean power state printing
      drm/radeon/kms: minor pm cleanups
      drm/radeon/kms/pm: restore default power state on exit
      drm/radeon/kms/pm: add additional asic callbacks
      drm/radeon/kms/pm: rework power management
      drm/radeon/kms: more pm fixes
      drm/radeon/kms: re-enable gui idle interrupts on r6xx+
      drm/radeon/kms: enable misc pm power state features on r5xx, rs6xx
      drm/radeon/kms: enable misc pm power state features on r1xx-r4xx
      drm/radeon/kms: fix lock ordering in ring, ib handling
      drm/radeon/kms/pm: add support for no display power states
      drm/radeon/kms/pm: rework power management
      drm/radeon/kms/pm: make pm spam debug only
      drm/radeon/kms/pm: fix r6xx+ profile setup
      drm/radeon/kms: reset ddc_bus in object header parsing
      drm/radeon/kms: hpd cleanup
      drm/edid: fix typo in 1600x1200@75 mode
      drm/radeon/kms: don't default display priority to high on rs4xx
      drm/radeon/kms/pm/r600: select the mid clock mode for single head low profile

Ben Hutchings (2):
      sis-agp: Remove SIS 760, handled by amd64-agp
      amd64-agp: Probe unknown AGP devices the right way

Ben Skeggs (15):
      drm: move radeon_fixed.h to shared drm_fixed.h header
      drm/nv40: remove some completed ctxprog TODOs
      drm/nouveau: fix a nouveau_bo dereference after it's been destroyed
      drm/nouveau: bios parser fixes for eDP boards
      drm/nouveau: dump pll limits entries when debugging is on
      drm/nv50: output calculated crtc pll when debugging on
      drm/nv50: fix suspend/resume with DP outputs
      drm/nv50: store full dcb i2c entry from vbios
      drm/nv50: fix monitor detection on certain chipsets
      drm/nv50: support fractional feedback divider on newer chips
      drm/nouveau: fix init table handlers to return proper error codes
      drm/nouveau: display error message for any failed init table opcode
      drm/nouveau: ensure we've parsed i2c table entry for INIT_*I2C* handlers
      drm/nouveau: support init table i2c device identifier 0x81
      drm/nouveau: fix i2c-related init table handlers

Carl Worth (1):
      drm/i915: Don't enable pipe/plane/VCO early (wait for DPMS on).

Chris Wilson (1):
      drm/i915: Wait for the GPU whilst shrinking, if truly desperate.

Christian Koenig (1):
      drm/radeon/kms: HDMI irq support

Christian König (1):
      drm/radeon/kms: rework audio polling timer

Dan Carpenter (3):
      drm/edid: remove an unneeded variable
      drm_edid: There should be 6 Standard Timings
      drm: off by one in drm_edid.c

Daniel Vetter (15):
      agp/intel: introduce intel-agp.h header file
      agp/intel: split out the GTT support
      agp/intel: uncoditionally reconfigure driver on resume
      agp/intel: kill mutli_gmch_chip
      agp/intel: split out gmch/gtt probe, part 1
      agp/intel-gtt: kill intel_i830_tlbflush
      agp/intel-gtt: kill previous_size assignments
      drm: extract drm_gem_object_init
      drm: free core gem object from driver callbacks
      drm/i915: introduce i915_gem_alloc_object
      drm/i915: embed the gem object into drm_i915_gem_object
      drm/i915: don't use ->driver_private anymore
      drm/i915: drop pointer to drm_gem_object
      drm/i915: don't allow tiling changes on pinned buffers v2
      drm/i915: move fence lru to struct drm_i915_fence_reg

Dave Airlie (24):
      drm/fb: fix fbdev object model + cleanup properly.
      drm/kms/fb: move to using fb helper crtc grouping instead of core crtc list
      drm/kms/fb: separate fbdev connector list from core drm connectors
      drm/kms/fb: provide a 1024x768 fbcon if no outputs found.
      drm/kms/fb: add polling support for when nothing is connected.
      drm/kms/fb: use slow work mechanism for normal hotplug also.
      drm/radeon: fix cypress firmware typo.
      Merge remote branch 'anholt/drm-intel-next' of /home/airlied/kernel/drm-next into drm-core-next
      Merge branch 'drm-ttm-pool' into drm-core-next
      Merge branch 'drm-edid-fixes' into drm-core-next
      Merge branch 'drm-radeon-lockup' into drm-core-next
      Merge branch 'drm-fbdev-cleanup' into drm-core-next
      Merge branch 'drm-radeon-evergreen-accel' into drm-core-next
      Merge branch 'drm-ttm-unmappable' into drm-core-next
      Revert "drm/i915: Configure the TV sense state correctly on GM45 to make TV detection reliable"
      agp/intel: put back check that we have a driver for the bridge.
      drm/fbdev: rework output polling to be back in the core. (v4)
      drm/fbdev: fix cloning on fbcon
      drm/radeon/kms: take vram mutex pointer before derefing object.
      drm/radeon/pm: fix device_create_file return value checks.
      Merge remote branch 'anholt/drm-intel-next' into drm-next
      drm/radeon: fix hdmi offset bug reported by smatch.
      drm/radeon: fix power supply kconfig interaction.
      Merge remote branch 'nouveau/for-airlied' into drm-next

Eric Anholt (3):
      drm/i915: Remove dead KMS encoder save/restore code.
      drm/i915: Clear the LVDS pipe B select bit when moving the LVDS to pipe A.
      Merge remote branch 'origin/master' into drm-intel-next

James Simmons (1):
      drm/fb: remove drm_fb_helper_setcolreg

Jerome Glisse (15):
      drm/radeon/kms: fence cleanup + more reliable GPU lockup detection V4
      drm/radeon/kms: rename gpu_reset to asic_reset
      drm/radeon/kms: simplify & improve GPU reset V2
      drm/ttm: split no_wait argument in 2 GPU or reserve wait
      drm/ttm: ttm_fault callback to allow driver to handle bo placement V6
      drm/radeon/kms: add support for new fault callback V7
      drm/nouveau/kms: add support for new TTM fault callback V5
      drm/vmwgfx: add support for new TTM fault callback V5
      drm/ttm: remove io_ field from TTM V6
      drm/radeon/kms: enable use of unmappable VRAM V2
      agp: use scratch page on memory remove and at GATT creation V4
      drm/radeon/kms: R3XX-R4XX fix GPU reset code
      drm/ttm: fix, avoid iomapping system memory
      drm/radeon/kms: add query for crtc hw id from crtc id to get info V2
      drm/radeon/kms: record object that have been list reserved

Jesse Barnes (2):
      drm: add initial DRM developer documentation
      drm/i915: cleanup mode setting before unmapping registers

Julia Lawall (2):
      drivers/gpu/drm: Use kmemdup
      drivers/gpu/drm: Use kzalloc

Karsten Wiese (1):
      drm/i915: Don't touch PORT_HOTPLUG_EN in intel_dp_detect()

Kirill Smelkov (1):
      drm: Prefix info printk about registering panic notifier with 'drm'

Li Zefan (1):
      drm/i915: Convert some trace events to DEFINE_TRACE

Luca Tettamanti (1):
      drm/i915: do not read uninitialized ->dev_private

Marcin Ko¶cielnicki (2):
      drm/nouveau: Use 0x5f instead of 0x9f as imageblit on original NV10.
      drm/nv04: Implement missing nv04 PGRAPH methods in software.

Marcin Slusarz (3):
      fbdev: allow passing more than one aperture for handoff
      fbmem, drm/nouveau: kick firmware framebuffers as soon as possible
      vga16fb, drm: vga16fb->drm handoff

Matt Turner (1):
      drm/ttm: include linux/seq_file.h for seq_printf

Matthew Garrett (12):
      radeon: Unify PM entry paths
      radeon: Unmap vram pages when reclocking
      radeon: Take drm struct_mutex over reclocking
      ttm: Provide an API for starting and stopping the delayed workqueue
      radeon: Stop the ttm workqueue while reclocking
      radeon: Enable memory reclockong on r600
      radeon: Make sure that we determine the correct PM state before transition
      radeon: Fix locking in power management paths
      radeon: Try harder to ensure we reclock in vblank
      radeon: Enable memory reclocking on r100-500
      radeon: Split out ring locking and allocation
      radeon: Use fences to gate entry to reclocking on <r600

Michel Dänzer (1):
      drm/radeon: AGP memory is only I/O if the aperture can be mapped by the CPU.

Pauli Nieminen (7):
      drm/ttm: add pool wc/uc page allocator V3
      drm/ttm: Add debugfs output entry to pool allocator.
      drm/radeon/kms: Add ttm page pool debugfs file.
      drm/nouveau: Add ttm page pool debugfs file.
      arch/x86: Add array variants for setting memory to wc caching.
      drm/ttm: Use set_pages_array_wc instead of set_memory_wc.
      drm/ttm: Add sysfs interface to control pool allocator.

Peter Clifton (1):
      drm/i915: Fix out of tree builds

Randy Dunlap (1):
      vga: fix kconfig text typos

Stephen Rothwell (1):
      drm/ttm: using kmalloc/kfree requires including slab.h

Zhao Yakui (6):
      drm/i915: Configure the TV sense state correctly on GM45 to make TV detection reliable
      drm/i915: Fix legacy BLC event for pipe A
      drm/i915: Add support of SDVO on Ibexpeak PCH
      drm/i915: Fix the incorrect argument for SDVO SET_TV_format command
      drm/i915: Only save/restore FBC on the platform that supports FBC
      drm/i915: Move Pineview CxSR and watermark code into update_wm hook.

Zhenyu Wang (25):
      drm/i915: use encoder_list for hotplug callback
      drm/i915: more conversion from connector_list walk to encoder_list
      drm/i915: Add new 'intel_connector' structure
      drm/i915: Add new helper to return current attached encoder for connector
      drm/i915: passing drm connector param for load detection
      drm/i915: change intel_ddc_get_modes() function parameters
      drm/i915: Sandybridge has no integrated TV
      drm/i915: Probe for PCH chipset type
      drm/i915: Support for Cougarpoint PCH display pipeline
      drm/i915: Fix CRT force detect on Cougarpoint
      drm/i915: enable LVDS on Cougarpoint
      drm/i915: enable HDMI on Cougarpoint
      drm/i915: enable DP/eDP for Sandybridge/Cougarpoint
      drm/i915: convert VGA driver to new encoder/connector structure
      drm/i915: convert LVDS driver to new encoder/connector structure
      drm/i915: convert HDMI driver to new encoder/connector structure
      drm/i915: convert DP/eDP driver to new encoder/connector structure
      drm/i915: convert DVO driver to new encoder/connector structure
      drm/i915: convert SDVO driver to new encoder/connector structure
      drm/i915: convert TV driver to new encoder/connector structure
      drm/i915: remove connector object in old output structure
      drm/i915: remove unused intel_pipe_get_connector()
      drm/i915: implement multifunction SDVO device support
      Revert "drm/i915: Use a dmi quirk to skip a broken SDVO TV output."
      drm/i915: Add the support of memory self-refresh on Ironlake

 Documentation/DocBook/Makefile                     |    2 +-
 Documentation/DocBook/drm.tmpl                     |  839 +++++++++
 arch/x86/include/asm/cacheflush.h                  |    2 +
 arch/x86/mm/pageattr.c                             |   53 +-
 drivers/char/agp/agp.h                             |   80 -
 drivers/char/agp/ali-agp.c                         |    1 +
 drivers/char/agp/amd-k7-agp.c                      |    9 +
 drivers/char/agp/amd64-agp.c                       |   28 +-
 drivers/char/agp/ati-agp.c                         |    8 +
 drivers/char/agp/efficeon-agp.c                    |    1 +
 drivers/char/agp/intel-agp.c                       | 1883 ++------------------
 drivers/char/agp/intel-agp.h                       |  239 +++
 drivers/char/agp/intel-gtt.c                       | 1516 ++++++++++++++++
 drivers/char/agp/nvidia-agp.c                      |    1 +
 drivers/char/agp/sis-agp.c                         |    9 +-
 drivers/char/agp/uninorth-agp.c                    |   16 +-
 drivers/char/agp/via-agp.c                         |    2 +
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/drm_auth.c                         |    3 +-
 drivers/gpu/drm/drm_crtc.c                         |    9 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |  490 +----
 drivers/gpu/drm/drm_dma.c                          |    4 +-
 drivers/gpu/drm/drm_edid.c                         |  802 ++++++---
 drivers/gpu/drm/drm_fb_helper.c                    |  908 +++++++---
 drivers/gpu/drm/drm_fops.c                         |    3 +-
 drivers/gpu/drm/drm_gem.c                          |   49 +-
 drivers/gpu/drm/drm_modes.c                        |  105 +-
 drivers/gpu/drm/drm_sysfs.c                        |    2 +-
 drivers/gpu/drm/i915/Makefile                      |    2 +
 drivers/gpu/drm/i915/dvo.h                         |   10 -
 drivers/gpu/drm/i915/dvo_ch7017.c                  |   46 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |   44 +-
 drivers/gpu/drm/i915/dvo_ivch.c                    |   21 -
 drivers/gpu/drm/i915/dvo_sil164.c                  |   38 -
 drivers/gpu/drm/i915/dvo_tfp410.c                  |   32 -
 drivers/gpu/drm/i915/i915_debugfs.c                |   28 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   15 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   29 +
 drivers/gpu/drm/i915/i915_drv.h                    |   38 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  154 ++-
 drivers/gpu/drm/i915/i915_gem_debug.c              |    2 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |    5 +
 drivers/gpu/drm/i915/i915_irq.c                    |   23 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  143 ++-
 drivers/gpu/drm/i915/i915_suspend.c                |   41 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   88 +-
 drivers/gpu/drm/i915/intel_bios.c                  |    1 +
 drivers/gpu/drm/i915/intel_crt.c                   |   93 +-
 drivers/gpu/drm/i915/intel_display.c               | 1064 ++++++++----
 drivers/gpu/drm/i915/intel_dp.c                    |  256 ++-
 drivers/gpu/drm/i915/intel_drv.h                   |   31 +-
 drivers/gpu/drm/i915/intel_dvo.c                   |  103 +-
 drivers/gpu/drm/i915/intel_fb.c                    |  217 ++--
 drivers/gpu/drm/i915/intel_hdmi.c                  |   71 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  111 +-
 drivers/gpu/drm/i915/intel_modes.c                 |   21 +-
 drivers/gpu/drm/i915/intel_overlay.c               |    8 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  | 1009 +++++------
 drivers/gpu/drm/i915/intel_tv.c                    |  185 +--
 drivers/gpu/drm/nouveau/Makefile                   |    3 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |  500 ++++--
 drivers/gpu/drm/nouveau/nouveau_bios.h             |    1 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  116 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   12 +
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |    3 +
 drivers/gpu/drm/nouveau/nouveau_display.c          |   42 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c              |   19 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |   10 +
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |    2 +
 drivers/gpu/drm/nouveau/nouveau_fb.h               |    6 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |  259 ++--
 drivers/gpu/drm/nouveau/nouveau_fbcon.h            |   19 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    5 +-
 drivers/gpu/drm/nouveau/nouveau_grctx.c            |    6 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.c              |   21 +-
 drivers/gpu/drm/nouveau/nouveau_irq.c              |   10 +-
 drivers/gpu/drm/nouveau/nouveau_reg.h              |    1 +
 drivers/gpu/drm/nouveau/nouveau_state.c            |   58 +-
 drivers/gpu/drm/nouveau/nv04_fbcon.c               |   18 +-
 drivers/gpu/drm/nouveau/nv04_graph.c               |  566 ++++++-
 drivers/gpu/drm/nouveau/nv40_grctx.c               |    5 -
 drivers/gpu/drm/nouveau/nv50_calc.c                |   87 +
 drivers/gpu/drm/nouveau/nv50_crtc.c                |   46 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |   36 +
 drivers/gpu/drm/nouveau/nv50_fbcon.c               |   16 +-
 drivers/gpu/drm/nouveau/nv50_sor.c                 |   15 +-
 drivers/gpu/drm/radeon/atombios.h                  |   76 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   22 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |    2 +-
 drivers/gpu/drm/radeon/evergreen.c                 | 1549 ++++++++++++++++-
 drivers/gpu/drm/radeon/evergreen_reg.h             |    4 +
 drivers/gpu/drm/radeon/evergreend.h                |  556 ++++++
 drivers/gpu/drm/radeon/r100.c                      |  729 ++++++---
 drivers/gpu/drm/radeon/r100d.h                     |  164 ++
 drivers/gpu/drm/radeon/r300.c                      |  151 +-
 drivers/gpu/drm/radeon/r300d.h                     |   47 +-
 drivers/gpu/drm/radeon/r420.c                      |   36 +-
 drivers/gpu/drm/radeon/r500_reg.h                  |    3 +
 drivers/gpu/drm/radeon/r520.c                      |    7 +-
 drivers/gpu/drm/radeon/r600.c                      |  600 ++++++-
 drivers/gpu/drm/radeon/r600_audio.c                |   58 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c             |    3 +
 drivers/gpu/drm/radeon/r600_hdmi.c                 |   65 +-
 drivers/gpu/drm/radeon/r600_reg.h                  |   57 +-
 drivers/gpu/drm/radeon/radeon.h                    |  258 ++-
 drivers/gpu/drm/radeon/radeon_asic.c               |  140 ++-
 drivers/gpu/drm/radeon/radeon_asic.h               |   44 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |  242 ++-
 drivers/gpu/drm/radeon/radeon_bios.c               |    3 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |   64 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   63 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    4 -
 drivers/gpu/drm/radeon/radeon_device.c             |   61 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  129 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |    7 +-
 drivers/gpu/drm/radeon/radeon_encoders.c           |   44 +-
 drivers/gpu/drm/radeon/radeon_fb.c                 |  358 +++--
 drivers/gpu/drm/radeon/radeon_fence.c              |  107 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |    2 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |    6 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    5 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   18 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |   14 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |   15 -
 drivers/gpu/drm/radeon/radeon_mode.h               |   49 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   44 +-
 drivers/gpu/drm/radeon/radeon_object.h             |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  814 ++++++---
 drivers/gpu/drm/radeon/radeon_reg.h                |    4 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   66 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |  122 +-
 drivers/gpu/drm/radeon/rs400.c                     |    9 +-
 drivers/gpu/drm/radeon/rs600.c                     |  231 +++-
 drivers/gpu/drm/radeon/rs600d.h                    |   80 +
 drivers/gpu/drm/radeon/rs690.c                     |  289 ++--
 drivers/gpu/drm/radeon/rv515.c                     |  287 +--
 drivers/gpu/drm/radeon/rv515d.h                    |   46 +
 drivers/gpu/drm/radeon/rv770.c                     |   28 +-
 drivers/gpu/drm/savage/savage_bci.c                |    3 +-
 drivers/gpu/drm/ttm/Makefile                       |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   98 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |  122 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   41 +-
 drivers/gpu/drm/ttm/ttm_memory.c                   |    7 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |  845 +++++++++
 drivers/gpu/drm/ttm/ttm_tt.c                       |   44 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |   50 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |   14 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    6 -
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |    2 +-
 drivers/gpu/vga/Kconfig                            |    6 +-
 drivers/video/efifb.c                              |   11 +-
 drivers/video/fbmem.c                              |   74 +-
 drivers/video/fbsysfs.c                            |    1 +
 drivers/video/offb.c                               |   28 +-
 drivers/video/vesafb.c                             |   11 +-
 drivers/video/vga16fb.c                            |   26 +-
 include/drm/drmP.h                                 |    3 +
 include/drm/drm_crtc.h                             |   43 +-
 include/drm/drm_crtc_helper.h                      |    9 +-
 include/drm/drm_edid.h                             |    5 +-
 include/drm/drm_fb_helper.h                        |   67 +-
 .../radeon_fixed.h => include/drm/drm_fixed.h      |   40 +-
 include/drm/radeon_drm.h                           |    1 +
 include/drm/ttm/ttm_bo_api.h                       |   46 +-
 include/drm/ttm/ttm_bo_driver.h                    |   57 +-
 include/drm/ttm/ttm_page_alloc.h                   |   74 +
 include/linux/fb.h                                 |   19 +-
 169 files changed, 15168 insertions(+), 7252 deletions(-)
 create mode 100644 Documentation/DocBook/drm.tmpl
 create mode 100644 drivers/char/agp/intel-agp.h
 create mode 100644 drivers/char/agp/intel-gtt.c
 create mode 100644 drivers/gpu/drm/nouveau/nv50_calc.c
 create mode 100644 drivers/gpu/drm/radeon/evergreend.h
 create mode 100644 drivers/gpu/drm/ttm/ttm_page_alloc.c
 rename drivers/gpu/drm/radeon/radeon_fixed.h => include/drm/drm_fixed.h (60%)
 create mode 100644 include/drm/ttm/ttm_page_alloc.h
--29444707-1065480061-1274423098=:16929--
