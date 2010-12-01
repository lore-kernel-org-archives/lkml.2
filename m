Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0LADjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 22:39:43 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56365 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0LADjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 22:39:37 -0500
Date: Wed, 1 Dec 2010 03:39:21 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1012010334080.20976@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

lots of regression fixes, I delayed sending this until I tracked down why 
37-rc wouldn't show anything on my newly acquired HP 2540p when 2.6.36 
worked, some eDP changes to fix some Sony's regressed the HPs so we've just reverted it and 
hopefully jbarnes can work out what he did wrong when get he gets back. So 
anyone who's Sony magically started to work in -rc1 will be disappointed 
but at least we don't have a regression since .36.

Otherwise there are regression fixes for Intel and Radeon hw, with the 
biggest change being the pagefault handling fixes in i915.

Dave.

The following changes since commit 3561d43fd289f590fdae672e5eb831b8d5cf0bf6:

  Linux 2.6.37-rc3 (2010-11-21 15:18:56 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (6):
      drm/radeon/kms: fix regression in rs4xx i2c setup
      drm/radeon/kms: fix resume regression for some r5xx laptops
      Revert "drm/radeon/kms: fix typo in r600 cs checker"
      drm/radeon/kms: fix typos in disabled vbios code
      drm/radeon/kms: fix interlaced and doublescan handling
      drm/radeon/kms: add workaround for dce3 ddc line vbios bug

Chris Wilson (9):
      drm/i915: Prevent integer overflow when validating the execbuffer
      drm/i915: Only save/restore cursor regs if !KMS
      Merge remote branch 'linus' into drm-intel-fixes
      drm/i915/sdvo: Only enable HDMI encodings only if the commandset is supported
      drm/i915: Handle pagefaults in execbuffer user relocations
      drm/i915/sdvo: Always fallback to querying the shared DDC line
      drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable
      drm/i915: Clear pfit registers when not used by any outputs
      Revert "drm/i915/dp: use VBT provided eDP params if available"

Daniel Vetter (1):
      drm/i915: fix regression due to ba3d8d749b01548b9

Dave Airlie (2):
      Merge remote branch 'intel/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes
      Merge remote branch 'intel/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes

Joe Perches (1):
      MAINTAINERS: INTEL DRM DRIVERS list (intel-gfx) is subscribers-only

Keith Packard (2):
      drm: Set connector DPMS status to ON in drm_crtc_helper_set_config
      drm: record monitor status in output_poll_execute

 MAINTAINERS                                |    2 +-
 drivers/gpu/drm/drm_crtc_helper.c          |   14 +-
 drivers/gpu/drm/i915/i915_gem.c            |  513 +++++++++++++++++-----------
 drivers/gpu/drm/i915/i915_suspend.c        |   40 ++--
 drivers/gpu/drm/i915/intel_display.c       |    7 +-
 drivers/gpu/drm/i915/intel_dp.c            |  146 +++-----
 drivers/gpu/drm/i915/intel_drv.h           |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c          |   19 +-
 drivers/gpu/drm/i915/intel_sdvo.c          |   84 ++----
 drivers/gpu/drm/radeon/atom.c              |    1 +
 drivers/gpu/drm/radeon/r600_cs.c           |    2 +-
 drivers/gpu/drm/radeon/r600_reg.h          |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c   |   16 +
 drivers/gpu/drm/radeon/radeon_bios.c       |   13 +-
 drivers/gpu/drm/radeon/radeon_combios.c    |    2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |   34 ++
 16 files changed, 511 insertions(+), 385 deletions(-)
