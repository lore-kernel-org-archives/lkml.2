Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab2KBJXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:23:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52103 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917Ab2KBJXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:23:12 -0400
Date: Fri, 2 Nov 2012 10:24:18 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [pull] drm-intel-next for 3.8
Message-ID: <20121102092418.GI5755@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.7.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Quite a pile since this is 4 weeks worth of patches:
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
  (Chris)
- random smaller fixlets and cleanups.

For Haswell display support, this is not yet everything, big things still
missing are:
- hdmi/dp encoder unification, otherwise we can't enable non-eDP outputs
- vga fixes (which essentially required forking all the fdi/pch code)

Both are already in -next-queued, so for the next pull I plan to move
Haswell out of experimental support.

Note that this also contains a -rc2 backmerge, which I've botched up
slightly:( Luckily Jani caught me and fixed things up, his patch is
included on top of what QA beat on.

For drm core stuff I have two series outstanding:
- kerneldoc/DocBook patches demanded by Lauren Pinchart. Note that the
  last patch in that series depends upon the dp helper refactoring
  included in here.
- relaunched hpd rework, requested&reviewed by Alex Deucher.
Can you please look into slurping these into drm-next, too?

Yours, Daniel

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel for-airlied

for you to fetch changes up to c8241969b44438c9335b59d375b627214bc36483:

  drm/i915: pass adjusted_mode to intel_choose_pipe_bpp_dither(), again (2012-11-02 09:57:28 +0100)

----------------------------------------------------------------
Adam Jackson (6):
      drm: Export drm_probe_ddc()
      drm/dp: Update DPCD defines
      drm/i915/dp: Fetch downstream port info if needed during DPCD fetch
      drm/i915/dp: Be smarter about connection sense for branch devices
      drm/dp: Document DP spec versions for various DPCD registers
      drm/dp: Make sink count DP 1.2 aware

Ben Widawsky (3):
      drm/i915: Extract PCU communication
      drm/i915: Workaround to bump rc6 voltage to 450
      drm/i915: Add rc6vids to debugfs

Chris Wilson (5):
      drm/i915: Align the hangcheck wakeup to the nearest second
      drm/i915: Align the retire_requests worker to the nearest second
      drm/i915: Allow DRM_ROOT_ONLY|DRM_MASTER to submit privileged batchbuffers
      drm/i915: Document the multi-threaded FORCEWAKE bits
      drm/i915: Clear FORCEWAKE when taking over from BIOS

Damien Lespiau (9):
      drm/i915: Remove the disabling of VHR unit clock gating for HSW
      drm/i915: Document that we are implementing WaDisableBackToBackFlipFix
      drm/i915: Remove the WaDisableBackToBackFlipFix w/a for Haswell
      drm/i915: Fix the SCC/SSC typo in the SPLL bits definition
      drm/i915: Consolidate ILK_DSPCLK_GATE and PCH_DSPCLK_GATE
      drm/i915: Program DSPCLK_GATE_D only once on Ironlake
      drm/i915: Don't program DSPCLK_GATE_D twice on IVB and VLV
      drm/i915: Don't try to use SPR_SCALE when we don't have a sprite scaler
      drm/i915: VLV does not have a sprite scaler

Daniel Vetter (24):
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

Gajanan Bhat (1):
      drm/i915: Add eDP support for Valleyview

Jani Nikula (17):
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

Jesse Barnes (3):
      drm/i915: limit VLV IRQ enables to those we use
      drm/i915: implement WaForceL3Serialization on VLV and IVB
      drm/i915: implement WaDisableEarlyCull for VLV and IVB

Mika Kuoppala (1):
      drm/i915: remove unused mem_block struct definition

Paulo Zanoni (49):
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

Vijay Purushothaman (6):
      drm/i915: Set aux clk to 100MHz for Valleyview
      drm/i915: Fix SDVO IER and status bits for Valleyview
      drm/i915: Add Valleyview lane control definitions
      drm/i915: Program correct m n tu register for Valleyview
      drm/i915: Enable DisplayPort in Valleyview
      drm/i915: Fixup HDMI output on Valleyview

Wei Yongjun (1):
      drm/i915: remove duplicated include from intel_modes.c

Yuly Novikov (2):
      drm/i915/dp: allow configuring eDP panel fitting scaling mode
      drm/i915/dp: change eDP default scaling mode to respect aspect ratio

 drivers/gpu/drm/Makefile                           |    2 +-
 .../drm/{drm_dp_i2c_helper.c => drm_dp_helper.c}   |  125 ++-
 drivers/gpu/drm/i915/i915_debugfs.c                |   22 +-
 drivers/gpu/drm/i915/i915_dma.c                    |    3 +
 drivers/gpu/drm/i915/i915_drv.c                    |    3 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   32 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   12 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   25 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   70 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  184 ++--
 drivers/gpu/drm/i915/i915_suspend.c                |  153 +--
 drivers/gpu/drm/i915/i915_trace.h                  |   10 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   38 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  755 ++++++++++++---
 drivers/gpu/drm/i915/intel_display.c               |  994 +++++++++++++++-----
 drivers/gpu/drm/i915/intel_dp.c                    |  754 +++++++++------
 drivers/gpu/drm/i915/intel_drv.h                   |   63 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |    2 +
 drivers/gpu/drm/i915/intel_lvds.c                  |  215 +++--
 drivers/gpu/drm/i915/intel_modes.c                 |    7 +-
 drivers/gpu/drm/i915/intel_opregion.c              |    2 +
 drivers/gpu/drm/i915/intel_panel.c                 |   32 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  255 ++---
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   48 +-
 drivers/gpu/drm/i915/intel_ringbuffer.h            |    4 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   33 +-
 drivers/gpu/drm/i915/intel_sprite.c                |   21 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |  149 +--
 drivers/gpu/drm/radeon/radeon_mode.h               |    2 +-
 include/drm/drm_dp_helper.h                        |   31 +
 include/uapi/drm/i915_drm.h                        |    6 +
 31 files changed, 2799 insertions(+), 1253 deletions(-)
 rename drivers/gpu/drm/{drm_dp_i2c_helper.c => drm_dp_helper.c} (64%)
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
