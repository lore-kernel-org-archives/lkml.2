Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2IQXIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 19:08:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42018 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab2IQXId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 19:08:33 -0400
Date: Tue, 18 Sep 2012 01:09:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [pull] drm-intel-next
Message-ID: <20120917230909.GE5522@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120913141841.GC5693@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913141841.GC5693@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 04:18:41PM +0200, Daniel Vetter wrote:
> Hi Dave,
> 
> The big ticket item here is the new i915 modeset infrastructure.
> Shockingly it didn't not blow up all over the place (i.e. I've managed to
> fix the ugly issues before merging). 1-2 smaller corner cases broke, but
> we have patches. Also, there's tons of patches on top of this that clean
> out cruft and fix a few bugs that couldn't be fixed with the crtc helper
> based stuff. So more stuff to come ;-)
> 
> Also a few other things:
> - Tiny fix in the fb helper to go through the official dpms interface
>   instead of calling the crtc helper code.
> - forcewake code frobbery from Ben, code should be more in-line with
>   what Windows does now.
> - fixes for the render ring flush on hsw (Paulo)
> - gpu frequency tracepoint
> - vlv forcewake changes to better align it with our understanding of the
>   forcewake magic.
> - a few smaller cleanups

Updated pull request with the 2 bugfixers cherry-picked from my -next
queue on top. Since I'll be travelling around for the next two weeks,
rebasing things around will take a bit longer.

Cheers, Daniel
The following changes since commit 85f9e50d815a70780699752c4f2dc1198c2c0b61:

  drm/i915: move i915_get_extra_insdone out of CONFIG_DEBUG_FS block (2012-09-03 18:06:37 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel for-airlied

for you to fetch changes up to 3b7a89fce3e3dc96b549d6d829387b4439044d0d:

  drm/i915: fix OOPS in lid_notify (2012-09-18 00:59:37 +0200)

----------------------------------------------------------------
Ben Widawsky (5):
      drm/i915: Extract forcewake ack timeout
      drm/i915: use cpu_relax() in wait_for_atomic
      drm/i915: Change forcewake timeout to 2ms
      drm/i915: Never read FORCEWAKE
      drm/i915: Enable some sysfs stuff without CONFIG_PM

Chris Wilson (1):
      drm/i915: Convert remaining debugfs iterators over rings to for_each_ring()

Daniel Vetter (68):
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

Jani Nikula (2):
      drm/i915: only enable sdvo hotplug irq if needed
      drm/i915: fix sdvo hotplug support check and activation

Paulo Zanoni (3):
      drm/i915: add gen7_render_ring_flush
      drm/i915: add workarounds directly to gen6_render_ring_flush
      drm/i915: add workarounds to gen7_render_ring_flush

 drivers/gpu/drm/drm_fb_helper.c         |    2 +-
 drivers/gpu/drm/i915/dvo.h              |    6 +
 drivers/gpu/drm/i915/dvo_ch7017.c       |   13 +
 drivers/gpu/drm/i915/dvo_ch7xxx.c       |   13 +
 drivers/gpu/drm/i915/dvo_ivch.c         |   15 +
 drivers/gpu/drm/i915/dvo_ns2501.c       |   15 +
 drivers/gpu/drm/i915/dvo_sil164.c       |   16 +
 drivers/gpu/drm/i915/dvo_tfp410.c       |   14 +
 drivers/gpu/drm/i915/i915_debugfs.c     |   54 +-
 drivers/gpu/drm/i915/i915_drv.c         |    9 +-
 drivers/gpu/drm/i915/i915_drv.h         |   36 +-
 drivers/gpu/drm/i915/i915_irq.c         |   20 +-
 drivers/gpu/drm/i915/i915_reg.h         |    2 +
 drivers/gpu/drm/i915/i915_sysfs.c       |   15 +-
 drivers/gpu/drm/i915/i915_trace.h       |   15 +
 drivers/gpu/drm/i915/intel_crt.c        |  136 ++-
 drivers/gpu/drm/i915/intel_ddi.c        |   59 +-
 drivers/gpu/drm/i915/intel_display.c    | 1535 ++++++++++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_dp.c         |  144 ++-
 drivers/gpu/drm/i915/intel_drv.h        |   67 +-
 drivers/gpu/drm/i915/intel_dvo.c        |   94 +-
 drivers/gpu/drm/i915/intel_hdmi.c       |  151 ++-
 drivers/gpu/drm/i915/intel_lvds.c       |   97 +-
 drivers/gpu/drm/i915/intel_pm.c         |  138 +--
 drivers/gpu/drm/i915/intel_ringbuffer.c |   82 +-
 drivers/gpu/drm/i915/intel_sdvo.c       |  206 +++--
 drivers/gpu/drm/i915/intel_tv.c         |   61 +-
 27 files changed, 2315 insertions(+), 700 deletions(-)
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
