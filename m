Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0JCKdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 06:33:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:28108 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab0JCKdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 06:33:40 -0400
Message-Id: <8u3s94$gm76dr@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,274,1283756400"; 
   d="scan'208";a="560175547"
Date: Sun, 03 Oct 2010 11:33:36 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] i915 regressions
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

  still a fair few regressions popping up in the i915 driver. Julia
spotted an old bug in our error handling that could cause the aperture to
be consumed with unpinnable buffers, Keith found that the wait-for-vblank
handling changes were not correct for DP, Jesse failed at basic math (and
nobody spotted the mistake!) and I introduced a refleak during eviction if
we were interrupted by a signal.
-Chris

The following changes since commit c6ea21e35bf3691cad59647c771e6606067f627d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2010-10-01 15:03:37 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes

Chris Wilson (1):
      drm/i915: Fix refleak during eviction.

Jesse Barnes (1):
      drm/i915: fix GMCH power reporting

Julia Lawall (1):
      drivers/gpu/drm/i915/i915_gem.c: Add missing error handling code

Keith Packard (2):
      drm/i915: vblank status not valid while training display port
      drm/i915: Use pipe state to tell when pipe is off

 drivers/gpu/drm/i915/i915_dma.c       |    6 ++--
 drivers/gpu/drm/i915/i915_gem.c       |    2 +
 drivers/gpu/drm/i915/i915_gem_evict.c |   45 ++++++++++-------------
 drivers/gpu/drm/i915/intel_display.c  |   62 ++++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_dp.c       |   19 +++++-----
 drivers/gpu/drm/i915/intel_drv.h      |    1 -
 6 files changed, 72 insertions(+), 63 deletions(-)

-- 
Chris Wilson, Intel Open Source Technology Centre
