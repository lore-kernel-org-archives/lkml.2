Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0L3TBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:01:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:19667 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab0L3TBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 14:01:38 -0500
Message-Id: <0d30dc$kjvpke@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,251,1291622400"; 
   d="scan'208";a="692053646"
Date: Thu, 30 Dec 2010 19:01:34 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] i915 fixes
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Dave asked to me send this pull request directly to you as he is on
holiday over the New Year. In this batch, there are a few regression
fixes. The most notable being the revert of the SSC frequency switch,
along with a use-before-initialisation introduced much earlier in the
sdvo/hdmi audio enabling and a fix for the loss of correct modesetting on
one particular DVO chipset. Eric also found another instance where we were
not adhering to the specs when setting up Ironlake. The impact is not
conclusively known but we did find a few scenarios where it delayed a
hang.
-Chris

The following changes since commit 387c31c7e5c9805b0aef8833d1731a5fe7bdea14:

  Linux 2.6.37-rc8 (2010-12-28 17:05:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes

Chris Wilson (4):
      drm/i915/sdvo: Add hdmi connector properties after initing the connector
      drm/i915: Verify Ironlake eDP presence on DP_A using the capability fuse
      Revert "drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks"
      drm/i915/dvo: Report LVDS attached to ch701x as connected

Eric Anholt (2):
      drm/i915: Set the required VFMUNIT clock gating disable on Ironlake.
      drm/i915, intel_ips: When i915 loads after IPS, make IPS relink to i915.

 drivers/gpu/drm/i915/dvo_ch7017.c    |    2 +-
 drivers/gpu/drm/i915/i915_dma.c      |   23 +++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h      |   10 +++++++++
 drivers/gpu/drm/i915/intel_bios.c    |    2 +-
 drivers/gpu/drm/i915/intel_display.c |   21 ++++++++++++++++++-
 drivers/gpu/drm/i915/intel_sdvo.c    |    3 +-
 drivers/platform/x86/intel_ips.c     |   36 +++++++++++++++++++++++++++++++--
 drivers/platform/x86/intel_ips.h     |   21 +++++++++++++++++++
 8 files changed, 111 insertions(+), 7 deletions(-)
 create mode 100644 drivers/platform/x86/intel_ips.h

-- 
Chris Wilson, Intel Open Source Technology Centre
