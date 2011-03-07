Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab1CGVdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:33:09 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35547 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab1CGVdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:33:08 -0500
Date: Mon, 7 Mar 2011 21:32:38 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm final fixes
Message-ID: <alpine.DEB.2.00.1103072130050.17490@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nouveau and Intel,

The two from Ben fixes regressions in since 2.6.38-rc1,

Chris has a revert + hopefully a more correct fix, along with an overflow 
fix, and disabling the GPU semaphores which seemed to be causing hangs.

I'm just passing these on since I'm stuck at home today and can't do much 
more than read the patches and build them.

Dave.

The following changes since commit fb62c00a6d8942775abc23d1621db1252e2d93d1:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2011-03-05 10:43:22 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Ben Skeggs (2):
      drm/nouveau: fix regression causing ttm to not be able to evict vram
      drm/nv50-nvc0: prevent multiple vm/bar flushes occuring simultanenously

Chris Wilson (4):
      Revert "drm/i915: fix corruptions on i8xx due to relaxed fencing"
      drm/i915: Do not overflow the MMADDR write FIFO
      drm/i915: Disable GPU semaphores by default
      drm/i915: Rebind the buffer if its alignment constraints changes with tiling

Dave Airlie (1):
      Merge remote branch 'ickle/drm-intel-fixes' into drm-fixes

 drivers/gpu/drm/i915/i915_debugfs.c        |    4 +-
 drivers/gpu/drm/i915/i915_drv.c            |   17 +++++++++++-
 drivers/gpu/drm/i915/i915_drv.h            |   24 ++++++++++++++----
 drivers/gpu/drm/i915/i915_gem.c            |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    4 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c     |   37 +++++++++++++--------------
 drivers/gpu/drm/i915/i915_reg.h            |    2 +
 drivers/gpu/drm/i915/intel_display.c       |    8 +++---
 drivers/gpu/drm/i915/intel_ringbuffer.h    |   13 +++++----
 drivers/gpu/drm/nouveau/nouveau_mem.c      |    6 +++-
 drivers/gpu/drm/nouveau/nouveau_mm.c       |    2 +-
 drivers/gpu/drm/nouveau/nv50_instmem.c     |    8 ++++++
 drivers/gpu/drm/nouveau/nv50_vm.c          |    4 +++
 13 files changed, 87 insertions(+), 44 deletions(-)
