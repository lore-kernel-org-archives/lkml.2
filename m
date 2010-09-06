Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0IFWVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 18:21:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37298 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0IFWV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 18:21:28 -0400
Date: Mon, 6 Sep 2010 23:21:14 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1009062319170.4265@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I sent a pull req last week you can ignore in favour of this one.

radeon + nouveau + a couple of core fixes. Important radeon evergreen fix, 
which allows accel to run without locking up the gpu, also a fix for 
r700 AGP, and a couple of bkl removal fixes for nouveau.

Dave.


The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (9):
      drm/radeon/kms: use tracked values for sclk and mclk
      drm/radeon/kms: fix a regression on r7xx AGP due to the HDP flush fix
      drm/radeon/kms: remove useless clock code
      drm/radeon/kms: force legacy pll algo for RV515 LVDS
      drm/radeon/kms: fix tv module parameter
      drm/radeon/kms: properly set crtc high base on r7xx
      drm/radeon/kms/evergreen: work around bad data in some i2c tables
      drm/radeon/kms/evergreen: fix gpu hangs in userspace accel code
      drm/radeon/kms: fix tv-out on avivo asics

Chris Wilson (2):
      drm/kms: Add a module parameter to disable polling
      drm: Do not force 1024x768 modes on unknown connectors

Dave Airlie (1):
      Merge remote branch 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next into drm-fixes

Francisco Jerez (2):
      drm/nouveau: Take fence spinlock before reading the last sequence.
      drm/nouveau: Don't take struct_mutex around the pushbuf IOCTL.

Marcin Slusarz (1):
      drm/nv50: initialize ramht_refs list for faked 0 channel

 drivers/gpu/drm/drm_crtc_helper.c          |   24 ++++++--
 drivers/gpu/drm/nouveau/nouveau_fence.c    |    6 ++-
 drivers/gpu/drm/nouveau/nouveau_gem.c      |    7 +--
 drivers/gpu/drm/nouveau/nv50_instmem.c     |    2 +
 drivers/gpu/drm/radeon/atombios_crtc.c     |   48 +++++++++++++++---
 drivers/gpu/drm/radeon/evergreen.c         |   48 +++++++++++++----
 drivers/gpu/drm/radeon/r600.c              |   16 +-----
 drivers/gpu/drm/radeon/radeon.h            |    8 ++-
 drivers/gpu/drm/radeon/radeon_asic.c       |   18 ------
 drivers/gpu/drm/radeon/radeon_atombios.c   |   27 ++++++++++
 drivers/gpu/drm/radeon/radeon_clocks.c     |   58 +++------------------
 drivers/gpu/drm/radeon/radeon_connectors.c |   78 +++++++++++++++------------
 drivers/gpu/drm/radeon/radeon_device.c     |   28 +++-------
 drivers/gpu/drm/radeon/radeon_i2c.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 -
 drivers/gpu/drm/radeon/rv770.c             |   61 ++++++++++++++++++---
 16 files changed, 253 insertions(+), 179 deletions(-)
