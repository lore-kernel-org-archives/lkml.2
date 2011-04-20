Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1DTAcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:32:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34575 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab1DTAcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:32:21 -0400
Date: Wed, 20 Apr 2011 01:31:24 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes (radeon + nouveau)
Message-ID: <alpine.DEB.2.00.1104200129240.13453@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Couple of radeon fixes and a few nouveau fixes, one for a memory 
corruption due to how the notifier was allocated.

Dave.

The following changes since commit 2582b6efceb43dce63b4a1090d289934067a972d:

  Revert "i915: restore only the mode of this driver on lastclose" (2011-04-13 09:20:24 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (4):
      drm/radeon/kms: fix bad shift in atom iio table parser
      drm/radeon/kms: add connectors even if i2c fails
      drm/radeon/kms: adjust evergreen display watermark setup
      drm/radeon/kms: pll tweaks for r7xx

Ben Skeggs (4):
      drm/nouveau: split ramin_lock into two locks, one hardirq safe
      drm/nouveau: fix nv30 pcie boards
      drm/nouveau: populate ttm_alloced with false, when it's not
      drm/nouveau: fix pinning of notifier block

Dave Airlie (1):
      Merge remote branch 'nouveau/drm-nouveau-fixes' of /ssd/git/drm-nouveau-next into drm-fixes

Marcin Slusarz (2):
      drm/nouveau: fix notifier memory corruption bug
      drm/nouveau: fix allocation of notifier object

 drivers/gpu/drm/nouveau/nouveau_dma.c      |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h      |    3 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c    |    4 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c      |    2 +-
 drivers/gpu/drm/nouveau/nouveau_notifier.c |   11 ++-
 drivers/gpu/drm/nouveau/nouveau_object.c   |   10 ++-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c    |    5 +-
 drivers/gpu/drm/nouveau/nouveau_state.c    |    1 +
 drivers/gpu/drm/nouveau/nv50_instmem.c     |   10 ++-
 drivers/gpu/drm/nouveau/nv50_vm.c          |    5 +-
 drivers/gpu/drm/nouveau/nvc0_vm.c          |    5 +-
 drivers/gpu/drm/radeon/atom.c              |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c     |    6 +--
 drivers/gpu/drm/radeon/evergreen.c         |   89 ++++++++++++++--------------
 drivers/gpu/drm/radeon/radeon_connectors.c |   29 ++++-----
 drivers/gpu/drm/radeon/radeon_i2c.c        |    6 ++
 16 files changed, 102 insertions(+), 92 deletions(-)
