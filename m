Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0KSKC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:02:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:50296 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab0KSKC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:02:26 -0500
Message-Id: <5b55a1$in84he@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,221,1288594800"; 
   d="scan'208";a="628363822"
Date: Fri, 19 Nov 2010 10:02:18 +0000
To: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org
Subject: Re: [git pull] drm fixes
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1011190118480.8681@skynet.skynet.ie>
References: <alpine.DEB.2.00.1011190118480.8681@skynet.skynet.ie>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave and Linus,

with travel I was a bit late in getting this pull request sent. It
contains a fix for Linus' machine, an i2c initialisation failure and a fix
from Keith to stop VGA flashing during polling on recent hardware. As well
as a patch that should hopefully prevent all of our indefinite GPU waits
on mode setting.

Note it also contains a couple of fluff fallout patches from the recent
drm-fixes rebase. (I thought it would be wise to include any core drm
changes in our testing before sending the request...)
-Chris

The following changes since commit 164bcb94bc821fcbac752e809b4ac7c6f15d13b5:

  drm/radeon/kms: i2c s/sprintf/snprintf/g for safety (2010-11-19 09:27:48 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes

Alex Deucher (1):
      drm/radeon/kms: fix and unify tiled buffer alignment checking for r6xx/7xx

Alex Shi (1):
      drm/i915: Disable FBC on Ironlake to save 1W

Chris Wilson (4):
      drm/i915: Retire any pending operations on the old scanout when switching
      Merge remote branch 'airlied/drm-fixes' into drm-intel-fixes
      drm/i915: Do not hold mutex when faulting in user addresses
      drm/i915/crt: Introduce struct intel_crt

Jean Delvare (1):
      drm/i915: Fix I2C adapter registration

Keith Packard (1):
      drm/i915: Take advantage of auto-polling CRT hotplug detection on PCH hardware

Vasiliy Kulikov (1):
      drm: radeon: fix error value sign

 drivers/gpu/drm/i915/i915_drv.c      |    3 +-
 drivers/gpu/drm/i915/i915_drv.h      |    2 +
 drivers/gpu/drm/i915/i915_gem.c      |   77 +++++----
 drivers/gpu/drm/i915/intel_crt.c     |  159 ++++++++++-------
 drivers/gpu/drm/i915/intel_display.c |   12 ++
 drivers/gpu/drm/i915/intel_i2c.c     |   11 +-
 drivers/gpu/drm/radeon/r600_cs.c     |  309 +++++++++++++++++++++-------------
 drivers/gpu/drm/radeon/r600d.h       |    6 +
 drivers/gpu/drm/radeon/radeon_irq.c  |    4 +-
 9 files changed, 358 insertions(+), 225 deletions(-)

-- 
Chris Wilson, Intel Open Source Technology Centre
