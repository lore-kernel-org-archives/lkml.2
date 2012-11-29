Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2K2KV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:21:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52436 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2K2KVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:21:25 -0500
Date: Thu, 29 Nov 2012 11:22:49 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] last drm-intel-next for 3.8
Message-ID: <20121129102249.GG3202@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20121129101200.GF3202@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129101200.GF3202@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.7.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:12:00AM +0100, Daniel Vetter wrote:
> Besides the big item of lifting the "preliminary hw support" tag from the
> Haswell code, just small bits&pieces all over:
> - Leftover Haswell patches and some fixes from Paulo
> - LyncPoint PCH support (for hsw)
> - OOM handling improvements from Chris Wilson
> - connector property and send_vblank_event refactorings from Rob Clark
> - random pile of small fixes
> 
> Note that the send_vblank refactorings will cause some locking WARNs to
> show up. Imre has fixed that up, but since all the driver changes outside
> of the drm core have been for exonys, those four patches are merged
> through the exonys-next tree.

Meh, I've forgotten to cherry-pick an important fix from Ben for a
regression in the 3.8 gen6+ gtt code. New pull request below. While I'm at
it, the hdmi VIC patch for the drm edid code is still in my queue, I'll
send you that in the next 3.8-fixes pull.

Yours, Daniel


The following changes since commit bf6f036848ab2151c2498f11cb7d31a52a95dd5c:

  drm/vmwgfx: Make vmw_dmabuf_unreference handle NULL objects (2012-11-20 16:19:59 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel for-airlied

for you to fetch changes up to 2ff4aeac39dbdcac934694413767f09a27965e11:

  drm/i915: Fix pte updates in ggtt clear range (2012-11-29 11:14:44 +0100)

----------------------------------------------------------------
Ben Widawsky (3):
      drm/i915: Fix warning in i915_gem_chipset_flush
      drm/i915: Use pci_resource functions for BARs.
      drm/i915: Fix pte updates in ggtt clear range

Chris Wilson (11):
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

Damien Lespiau (1):
      drm/i915: Only check for valid PP_{ON, OFF}_DELAYS on pre ILK hardware

Daniel Vetter (2):
      drm/i915: drop buggy write to FDI_RX_CHICKEN register
      drm/i915: resurrect panel lid handling

Jani Nikula (1):
      drm/i915/sdvo: kfree the intel_sdvo_connector, not drm_connector, on destroy

Jean Delvare (1):
      drm/i915: Optimize DIV_ROUND_CLOSEST call

Paulo Zanoni (10):
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

Rob Clark (2):
      drm/i915: use drm_send_vblank_event() helper
      drm/i915: drm_connector_property -> drm_object_property

Takashi Iwai (1):
      drm/i915: Enable DP audio for Haswell

Wei Shun Chang (1):
      drm/i915: add LynxPoint-LP PCH ID

 drivers/gpu/drm/i915/i915_drv.c            |   26 ++++---
 drivers/gpu/drm/i915/i915_drv.h            |   13 +++-
 drivers/gpu/drm/i915/i915_gem.c            |  102 ++++++++++++++++------------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    9 ---
 drivers/gpu/drm/i915/i915_gem_gtt.c        |   14 ++--
 drivers/gpu/drm/i915/i915_reg.h            |    4 ++
 drivers/gpu/drm/i915/i915_suspend.c        |    8 ---
 drivers/gpu/drm/i915/intel_bios.c          |    3 +-
 drivers/gpu/drm/i915/intel_crt.c           |    2 +-
 drivers/gpu/drm/i915/intel_ddi.c           |   11 +++
 drivers/gpu/drm/i915/intel_display.c       |   80 +++++++++++-----------
 drivers/gpu/drm/i915/intel_dp.c            |    2 +-
 drivers/gpu/drm/i915/intel_drv.h           |    4 +-
 drivers/gpu/drm/i915/intel_hdmi.c          |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c          |   24 ++++---
 drivers/gpu/drm/i915/intel_modes.c         |    4 +-
 drivers/gpu/drm/i915/intel_panel.c         |   25 +++----
 drivers/gpu/drm/i915/intel_pm.c            |   25 ++++++-
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    7 +-
 drivers/gpu/drm/i915/intel_sdvo.c          |   64 +++++++++++++----
 drivers/gpu/drm/i915/intel_tv.c            |   14 ++--
 21 files changed, 264 insertions(+), 179 deletions(-)
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
