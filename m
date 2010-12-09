Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0LIIH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:07:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47919 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab0LIIH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:07:28 -0500
Date: Thu, 9 Dec 2010 08:07:10 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1012090804470.22839@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

didn't see much point in queueing these up for a longer period of time, 
they are all fairly small and make sense.

The use after free is from the vblank leak fixing, so since nobody noticed 
we probably don't hit the error path so often, the AGP fix is 
reported/tested in k.org, and the output renames has no userspace 
effect in case anyone wonders.

Dave.

The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e83937b6:

  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/kms: remove spaces from connector names (v2)
      drm/radeon/kms: don't apply 7xx HDP flush workaround on AGP

Dan Carpenter (1):
      drm: use after free in drm_queue_vblank_event()

 drivers/gpu/drm/drm_crtc.c    |   10 +++++-----
 drivers/gpu/drm/drm_irq.c     |    4 ++--
 drivers/gpu/drm/radeon/r600.c |   11 ++++++++---
 3 files changed, 15 insertions(+), 10 deletions(-)
