Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2KPRPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:15:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61341 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2KPRPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:15:46 -0500
Date: Fri, 16 Nov 2012 18:17:02 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [pull] drm-intel-next
Message-ID: <20121116171702.GB5854@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux phenom 3.7.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Highlights of this -next round:
- ivb fdi B/C fixes
- hsw sprite/plane offset fixes from Damien
- unified dp/hdmi encoder for hsw, finally external dp support on hsw
  (Paulo)
- kill-agp and some other prep work in the gtt code from Ben
- some fb handling fixes from Ville
- massive pile of patches to align hsw VGA with the spec and make it
  actually work (Paulo)
- pile of workarounds from Jesse, mostly for vlv, but also some other
  related platforms
- start of a dev_priv reorg, that thing grew out of bounds and chaotic
- small bits&pieces all over the place, down to better error handling for
  load-detect on gen2 (Chris, Jani, Mika, Zhenyu, ...)

On top of the previous pile (just copypasta):
- tons of hsw dp prep patches form Paulo
- round scheduled work items and timers to nearest second (Chris)
- some hw workarounds (Jesse&Damien)
- vlv dp support and related fixups (Vijay et al.)
- basic haswell dp support, not yet wired up for external ports (Paulo)
- edp support (Paulo)
- tons of refactorings to prepare for the above (Paulo)
- panel rework, unifiying code between lvds and edp panels (Jani)
- panel fitter scaling modes (Jani + Yuly Novikov)
- panel power improvements, should now work without the BIOS setting it up
- extracting some dp helpers from radeon/i915 and move them to
  drm_dp_helper.c
- randome pile of workarounds (Damien, Ben, ...)
- some cleanups for the register restore code for suspend/resume
- secure batchbuffer support, should enable tear-free blits on gen6+
  Chris)
- random smaller fixlets and cleanups.

Note that I've done a tiny bit of history rectifying on this -next pull
(just to make a debug dmesg output correct), and applied a bugfix for a
regression that Chris caught (introduced much earlier in this patch-pile).

Cheers, Daniel


The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel for-airlied

for you to fetch changes up to 6b8294a4d392c2c9f8867e8505511f3fc9419ba7:

  drm/i915: Restore physical HWS_PGA after resume (2012-11-16 13:47:40 +0100)

----------------------------------------------------------------
Adam Jackson (6):
      drm: Export drm_probe_ddc()
      drm/dp: Update DPCD defines
      drm/i915/dp: Fetch downstream port info if needed during DPCD fetch
      drm/i915/dp: Be smarter about connection sense for branch devices
      drm/dp: Document DP spec versions for various DPCD registers
      drm/dp: Make sink count DP 1.2 aware

Ben Widawsky (16):
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

Chris Wilson (11):
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

Damien Lespiau (15):
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

Daniel Vetter (48):
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

Gajanan Bhat (1):
      drm/i915: Add eDP support for Valleyview

Jani Nikula (18):
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

Mika Kuoppala (2):
      drm/i915: remove unused mem_block struct definition
      drm/i915/ringbuffer: exclude last 2 cachelines on 845g on all callpaths

Paulo Zanoni (83):
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

Vijay Purushothaman (6):
      drm/i915: Set aux clk to 100MHz for Valleyview
      drm/i915: Fix SDVO IER and status bits for Valleyview
      drm/i915: Add Valleyview lane control definitions
      drm/i915: Program correct m n tu register for Valleyview
      drm/i915: Enable DisplayPort in Valleyview
      drm/i915: Fixup HDMI output on Valleyview

Ville Syrjälä (7):
      drm/i915: Fix display pixel format handling
      drm/i915: Check framebuffer stride more thoroughly
      drm/i915: Check the framebuffer offset
      drm/i915: pixel_size == cpp
      drm/i915: Bad pixel formats can't reach the sprite code
      drm/i915: Introduce intel_crtc_update_sarea_pos()
      drm/i915: Add SURFLIVE register definitions

Wei Yongjun (1):
      drm/i915: remove duplicated include from intel_modes.c

Yuly Novikov (2):
      drm/i915/dp: allow configuring eDP panel fitting scaling mode
      drm/i915/dp: change eDP default scaling mode to respect aspect ratio

Zhenyu Wang (1):
      drm/i915: Fix HSW power well control state read

 drivers/char/agp/intel-agp.h                       |   91 --
 drivers/char/agp/intel-gtt.c                       |  320 +---
 drivers/gpu/drm/Makefile                           |    2 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |   18 +
 .../drm/{drm_dp_i2c_helper.c => drm_dp_helper.c}   |  125 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   52 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   86 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  105 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  443 +++---
 drivers/gpu/drm/i915/i915_gem.c                    |   94 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   27 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  418 ++++-
 drivers/gpu/drm/i915/i915_irq.c                    |   80 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  293 ++--
 drivers/gpu/drm/i915/i915_suspend.c                |  763 +++++-----
 drivers/gpu/drm/i915/i915_sysfs.c                  |   43 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   10 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   47 +-
 drivers/gpu/drm/i915/intel_ddi.c                   | 1063 ++++++++++---
 drivers/gpu/drm/i915/intel_display.c               | 1592 +++++++++++++++-----
 drivers/gpu/drm/i915/intel_dp.c                    |  959 +++++++-----
 drivers/gpu/drm/i915/intel_drv.h                   |  113 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |  131 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |    9 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  215 +--
 drivers/gpu/drm/i915/intel_modes.c                 |    7 +-
 drivers/gpu/drm/i915/intel_opregion.c              |    2 +
 drivers/gpu/drm/i915/intel_panel.c                 |   52 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  464 +++---
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  119 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |    6 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   33 +-
 drivers/gpu/drm/i915/intel_sprite.c                |  101 +-
 drivers/gpu/drm/i915/intel_tv.c                    |    7 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |  149 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |    2 +-
 include/drm/drm_crtc_helper.h                      |    2 +
 include/drm/drm_dp_helper.h                        |   31 +
 include/drm/intel-gtt.h                            |    7 +-
 include/uapi/drm/i915_drm.h                        |    6 +
 41 files changed, 5120 insertions(+), 2969 deletions(-)
 rename drivers/gpu/drm/{drm_dp_i2c_helper.c => drm_dp_helper.c} (64%)
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
