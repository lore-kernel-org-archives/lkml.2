Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0LHFtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:49:09 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34280 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab0LHFtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:49:08 -0500
Date: Wed, 8 Dec 2010 05:48:49 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1012080543010.10719@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Mostly Intel based fixes, including the fix you were waiting for the panel 
power up/down symmetry, also from Chris : "there is a fix to clear the 
registers after the BIOS or grub2 messes them up, handling SDVO panels on 
Ironlake, more Ironlake workarounds and a regression fix for a hanging 
mesa"

The radeon fix from Jerome has been shown to fix actual problems, and one 
trivial and one real fix from Alex.

The core vblank fix should plug a possible leak, and the encoder one fixes 
an oops.

and yes I'm probably sending this a bit close to having pushed the last 
change which just removed some code that did nothing, but I've booted and 
done some basic testing on some intel and radeon hw.

I'm stuck bisecting an APIC crash on my main test box in 2.6.37-rcX which 
hopefully I'll figure out tomorrow.

Dave.

The following changes since commit 81e8d2162566379adcf4b3700f03845c62577145:

  Merge branch 'irq-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-07 08:14:28 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: fix formatting of vram and gtt info
      drm/radeon/kms: fix vram base calculation on rs780/rs880

Chris Wilson (9):
      drm/i915: Clean conflicting modesetting registers upon init
      drm/i915: Death to the unnecessary 64bit divide
      drm/i915: Factor in pixel-repeat in FDI M/N calculation
      drm/i915/ringbuffer: Only print an error on the second attempt to reset head
      drm/i915/lvds: Always restore panel-fitter when enabling the LVDS
      drm/i915: Emit a request to clear a flushed and idle ring for unbusy bo
      drm/i915/dp: Only apply the workaround if the select is still active
      drm: Add missing drm_vblank_put() along queue vblank error path
      drm: Don't try and disable an encoder that was never enabled

Daniel Vetter (1):
      drm/i915: announce to userspace that the bsd ring is coherent

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://git.kernel.org/.../ickle/drm-intel into drm-fixes
      drm/i915: i915 cannot provide switcher services.

Eric Anholt (2):
      drm/i915: Always set the DP transcoder config to 8BPC.
      drm/i915: Apply a workaround for transitioning from DP on pipe B to HDMI.

Jerome Glisse (1):
      drm/radeon/kms: forbid big bo allocation (fdo 31708) v3

Takashi Iwai (1):
      agp/intel: Fix wrong kunmap in i830_cleanup()

 drivers/char/agp/intel-gtt.c            |    6 +-
 drivers/gpu/drm/drm_crtc_helper.c       |    2 +-
 drivers/gpu/drm/drm_irq.c               |   19 +++++--
 drivers/gpu/drm/i915/i915_dma.c         |    3 +
 drivers/gpu/drm/i915/i915_gem.c         |   12 ++++-
 drivers/gpu/drm/i915/i915_reg.h         |    1 +
 drivers/gpu/drm/i915/intel_acpi.c       |   34 -----------
 drivers/gpu/drm/i915/intel_display.c    |   76 +++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_dp.c         |   25 ++++++++
 drivers/gpu/drm/i915/intel_lvds.c       |   98 +++++++++++++++++--------------
 drivers/gpu/drm/i915/intel_ringbuffer.c |   30 +++++-----
 drivers/gpu/drm/radeon/r600.c           |    6 +-
 drivers/gpu/drm/radeon/radeon_device.c  |    4 +-
 drivers/gpu/drm/radeon/radeon_object.c  |   13 ++++-
 include/drm/i915_drm.h                  |    2 +
 15 files changed, 210 insertions(+), 121 deletions(-)
