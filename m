Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1CXLey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:34:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49527 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1CXLex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:34:53 -0400
Date: Thu, 24 Mar 2011 11:34:22 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes for -rc1
Message-ID: <alpine.DEB.2.00.1103241132001.12023@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

this replaces the pull I sent yesterday that I don't see in your tree yet.

It should have the fix for your i915 in the intel patches, along with
a couple of radeon fixes, and the vblank change + fix.

Dave.

The following changes since commit c87a8d8dcd2587c203f3dd8a3c5c15d1e128ec0d:

  drm/radeon: fixup refcounts in radeon dumb create ioctl. (2011-03-17 13:58:34 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Alex Deucher (2):
      drm/radeon/kms: prefer legacy pll algo for tv-out
      drm/radeon/kms: fix hardcoded EDID handling

Chris Wilson (10):
      drm: Fix use-after-free in drm_gem_vm_close()
      drm/i915: Remove surplus POSTING_READs before wait_for_vblank
      drm/i915: skip redundant operations whilst enabling pipes and planes
      drm/i915: Fix tiling corruption from pipelined fencing
      drm/i915: Fix computation of pitch for dumb bo creator
      drm/i915: Disable pagefaults along execbuffer relocation fast path
      drm/i915: Restore missing command flush before interrupt on BLT ring
      drm/i915: Fix use after free within tracepoint
      drm/i915: Avoid unmapping pages from a NULL address space
      Revert "drm/i915: Don't save/restore hardware status page address register"

Dave Airlie (3):
      drm: check for modesetting on modeset ioctls
      Merge remote branch 'intel/drm-intel-fixes' of ../drm-next into drm-core-next
      drm/vblank: update recently added vbl interface to be more future proof.

Herton Ronaldo Krzesinski (1):
      drm/i915: Prevent racy removal of request from client list

Ilija Hadzic (1):
      drm/kernel: vblank wait on crtc > 1

Jesse Barnes (1):
      drm/i915: report correct render clock frequencies on SNB

Takashi Iwai (1):
      drm/i915/dp: Correct the order of deletion for ghost eDP devices

Thomas Renninger (1):
      drm radeon: Return -EINVAL on wrong pm sysfs access

Yuanhan Liu (1):
      drm/i915: Re-enable self-refresh

 drivers/gpu/drm/drm_crtc.c                 |   51 +++++++++++++
 drivers/gpu/drm/drm_gem.c                  |    5 +-
 drivers/gpu/drm/drm_ioctl.c                |    3 +
 drivers/gpu/drm/drm_irq.c                  |   15 +++--
 drivers/gpu/drm/i915/i915_debugfs.c        |    8 +-
 drivers/gpu/drm/i915/i915_drv.h            |    1 +
 drivers/gpu/drm/i915/i915_gem.c            |   70 +++++++++---------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   21 +++++-
 drivers/gpu/drm/i915/i915_suspend.c        |    6 ++
 drivers/gpu/drm/i915/intel_display.c       |   39 +++++------
 drivers/gpu/drm/i915/intel_dp.c            |    4 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c    |  109 +++++++++++++---------------
 drivers/gpu/drm/radeon/atombios_crtc.c     |    6 ++-
 drivers/gpu/drm/radeon/radeon_combios.c    |   21 ++++--
 drivers/gpu/drm/radeon/radeon_connectors.c |   30 +++++++-
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 +
 drivers/gpu/drm/radeon/radeon_pm.c         |    8 ++-
 include/drm/drm.h                          |    4 +
 18 files changed, 257 insertions(+), 145 deletions(-)
