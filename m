Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2BBQCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:02:24 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41902 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab2BBQCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:02:23 -0500
Date: Thu, 2 Feb 2012 16:02:21 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon + nouveau fixes
Message-ID: <alpine.DEB.2.00.1202021559400.873@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-301432545-1328198541=:873"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-301432545-1328198541=:873
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

A set of fixes from nouveau and radeon, one reported regression about 
reading BIOS roms on certain dual-gpu laptops is fixed (use after free),
along with a s/r black screen fix, and a GPU hang fix.

Dave.


The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: fix TRAVIS panel setup

Ben Skeggs (4):
      drm/nouveau/disp: check that panel power gpio is enabled at init time
      drm/nouveau/mxm: pretend to succeed, even if we can't shadow the MXM-SIS
      drm/nouveau: fix typo on mxmdcb option
      drm/nouveau/gem: fix fence_sync race / oops

Dan Carpenter (1):
      drm/nv50/pm: signedness bug in nv50_pm_clocks_pre()

Dave Airlie (2):
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      drm/radeon: fix use after free in ATRM bios reading code.

Ilija Hadzic (1):
      drm/radeon/kms/blit: fix blit copy for very large buffers

Jean Delvare (1):
      drm/radeon/kms: Fix device tree linkage of DP i2c buses too

Michel Dänzer (1):
      drm/radeon: Set DESKTOP_HEIGHT register to the framebuffer (not mode) height.

Seth Forshee (1):
      drm/radeon/kms: disable output polling when suspended

 drivers/gpu/drm/nouveau/nouveau_bios.h       |    5 ++-
 drivers/gpu/drm/nouveau/nouveau_display.c    |   10 +++++++
 drivers/gpu/drm/nouveau/nouveau_drv.c        |    2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c        |   23 +++++++++++++++-
 drivers/gpu/drm/nouveau/nouveau_mxm.c        |    9 ++++++
 drivers/gpu/drm/nouveau/nv50_pm.c            |    4 +-
 drivers/gpu/drm/radeon/atombios_crtc.c       |    4 +-
 drivers/gpu/drm/radeon/atombios_dp.c         |   18 +++++++++++--
 drivers/gpu/drm/radeon/r600_blit_kms.c       |   35 ++++++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    3 +-
 drivers/gpu/drm/radeon/radeon_device.c       |    4 +++
 drivers/gpu/drm/radeon/radeon_i2c.c          |    1 +
 12 files changed, 95 insertions(+), 23 deletions(-)
--29444707-301432545-1328198541=:873--
