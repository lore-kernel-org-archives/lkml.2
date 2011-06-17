Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1FQAjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:39:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38557 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab1FQAjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:39:02 -0400
Date: Fri, 17 Jun 2011 01:38:23 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.1106170133410.18960@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Slightly larger than I'd like, but Alex is still bringing up some variants 
of the llano hardware platform with different output configurations, so 
displaying something is nicer than just black screening. I've done some 
testing on pre-llano systems and haven't seen any problems with it, so I'm 
happy to push it.

Otherwise there is one i915 revert, the GMBUS code was causing some 
problems with the core i2c and needs a rework, one regression fix for UMS 
drivers since I split the pci/platform/usb code out, a couple of minor radeon 
fixes, and one radeon fix for a bug with some floating i2c lines on 
certain family of motherboards.

Dave.

The following changes since commit 21c5977a836e399fc710ff2c5367845ed5c2527f:

  alpha: fix several security issues (2011-06-15 20:04:02 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (13):
      drm/radeon/kms: signed fix for evergreen thermal
      drm/radeon/kms: be more pedantic about the g5 quirk (v2)
      drm/radeon/kms: clear wb memory by default
      drm/radeon/kms: fix num crtcs for Cedar and Caicos
      drm/radeon/kms: rework atombios_get_encoder_mode()
      drm/radeon/kms: add missing external encoder action
      drm/radeon/kms: add support for load detection on dp bridges
      drm/radeon/kms: fix support for DDC on dp bridges
      drm/radeon/kms: issue blank/unblank commands for ext encoders
      drm/radeon/kms: fix handling of DP to LVDS bridges
      drm/radeon/kms/atom: AdjustPixelClock fixes for DP bridges
      drm/radeon/kms: set DP link config properly for DP bridges
      drm/radeon/kms: use helper functions for fence read/write

Christian Dietrich (1):
      drivers/gpu/drm: use printk_ratelimited instead of printk_ratelimit

Dave Airlie (2):
      drm: make debug levels match in edid failure code.
      drm/radeon: workaround a hw bug on some radeon chipsets with all-0 EDIDs.

Jean Delvare (1):
      Revert "drm/i915: Enable GMBUS for post-gen2 chipsets"

Wolfram Sang (1):
      drm: populate irq_by_busid-member for pci

 drivers/gpu/drm/drm_edid.c                 |   19 ++++-
 drivers/gpu/drm/drm_ioc32.c                |    9 +-
 drivers/gpu/drm/drm_pci.c                  |    3 +-
 drivers/gpu/drm/i915/intel_i2c.c           |    3 +-
 drivers/gpu/drm/radeon/atombios.h          |    1 +
 drivers/gpu/drm/radeon/atombios_crtc.c     |    7 ++
 drivers/gpu/drm/radeon/evergreen.c         |    3 +-
 drivers/gpu/drm/radeon/radeon_asic.c       |   31 +++++---
 drivers/gpu/drm/radeon/radeon_combios.c    |    9 ++-
 drivers/gpu/drm/radeon/radeon_connectors.c |   58 ++++++++++++--
 drivers/gpu/drm/radeon/radeon_device.c     |    2 +
 drivers/gpu/drm/radeon/radeon_encoders.c   |  112 +++++++++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_fence.c      |   51 +++++++++----
 drivers/gpu/drm/radeon/radeon_mode.h       |    2 +
 include/drm/drm_crtc.h                     |    2 +
 15 files changed, 237 insertions(+), 75 deletions(-)
