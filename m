Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2GCKte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:49:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44996 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2GCKtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:49:32 -0400
Date: Tue, 3 Jul 2012 11:49:31 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1207031148060.16871@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

one regression fix, two radeon fixes (one for an oops), and an i915 fix
to unload framebuffers earlier.

We originally were going to leave the i915 fix until -next, but grub2 in 
some situations causes vesafb/efifb to be loaded now, and this causes big 
slowdowns, and I have reports in rawhide I'd like to have fixed.

Dave.

The following changes since commit 9acc7bde23ebb19a704395f76490685e1513e422:

  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging (2012-06-28 12:38:51 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 9f846a16d213523fbe6daea17e20df6b8ac5a1e5:

  drm/i915: kick any firmware framebuffers before claiming the gtt (2012-07-03 11:18:48 +0100)

----------------------------------------------------------------
Alex Deucher (1):
      drm/radeon: fix VM page table setup on SI

Daniel Vetter (1):
      drm/i915: kick any firmware framebuffers before claiming the gtt

Jerome Glisse (1):
      drm/radeon: fix rare segfault

Takashi Iwai (1):
      drm: edid: Don't add inferred modes with higher resolution

 drivers/gpu/drm/drm_edid.c           |   27 ++++++++++++++++++++++---
 drivers/gpu/drm/i915/i915_dma.c      |   37 +++++++++++++++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_gart.c |   13 ++++++++++--
 drivers/gpu/drm/radeon/radeon_gem.c  |   10 +++++----
 drivers/gpu/drm/radeon/si.c          |    4 ++--
 5 files changed, 73 insertions(+), 18 deletions(-)
