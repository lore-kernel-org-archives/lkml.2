Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab2BVT4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:56:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37568 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab2BVT4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:56:38 -0500
Date: Wed, 22 Feb 2012 19:56:36 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1202221952430.18534@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1788486740-1329940596=:18534"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1788486740-1329940596=:18534
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Intel, radeon, exynos fixes.

Intel: fixes a few Ivybridge hangs, along with fixing RC6 on SNB (still 
not on, but at least allows for distros to patch it on easily).
radeon: oops reading some files in debugfs that weren't meant to appear,
a fix that touches a lot of files, so looks worse than it is, it fixes an
oops if a GPU reset fails and userspace keeps submitting more data, along 
with a minor BIOS fix for newer boards.

exynos: a group of fixes for exynos, they've sent me a few more but these 
were all I got through, and its no hw vanilla kernel users see a lot off 
yet.

Dave.

The following changes since commit b7f5b7dec3d539a84734f2bcb7e53fbb1532a40b:

  drm/radeon/kms: fix MSI re-arm on rv370+ (2012-02-14 13:36:23 +0000)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms/atom: dpms bios scratch reg updates

Dave Airlie (1):
      Merge branch 'drm-intel-fixes' of git://git.kernel.org/.../jbarnes/drm-intel into drm-fixes

Eugeni Dodonov (4):
      drm/i915: gen7: implement rczunit workaround
      drm/i915: gen7: Implement an L3 caching workaround.
      drm/i915: gen7: work around a system hang on IVB
      drm/i915: do not enable RC6p on Sandy Bridge

Inki Dae (4):
      drm/exynos: added possible_clones setup function.
      drm/exynos: fixed page flip issue.
      drm/exynos: removed exynos_drm_fbdev_recreate function.
      drm/exynos: added postclose to release resource.

Jerome Glisse (1):
      drm/radeon/kms: properly set accel working flag and bailout when false

Joonyoung Shim (2):
      drm/exynos: changed priority of mixer layers.
      drm/exynos: removed pageflip_event_list init code when closed.

Kenneth Graunke (1):
      drm/i915: gen7: Disable the RHWO optimization as it can cause GPU hangs.

Masanari Iida (1):
      drm/exynos: Fix typo in exynos_mixer.c

Michel Dänzer (1):
      drm/radeon: Only create additional ring debugfs files on Cayman or newer.

 drivers/gpu/drm/exynos/exynos_drm_core.c    |    3 +
 drivers/gpu/drm/exynos/exynos_drm_crtc.c    |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c     |   26 +++++++---
 drivers/gpu/drm/exynos/exynos_drm_encoder.c |   34 +++++++++++++
 drivers/gpu/drm/exynos/exynos_drm_encoder.h |    1 +
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c   |   70 ++-------------------------
 drivers/gpu/drm/exynos/exynos_drm_fimd.c    |    7 ++-
 drivers/gpu/drm/exynos/exynos_mixer.c       |   19 +++++---
 drivers/gpu/drm/i915/i915_reg.h             |   15 ++++++
 drivers/gpu/drm/i915/intel_display.c        |   24 ++++++++-
 drivers/gpu/drm/radeon/evergreen.c          |    1 +
 drivers/gpu/drm/radeon/ni.c                 |    1 +
 drivers/gpu/drm/radeon/r100.c               |    8 +++-
 drivers/gpu/drm/radeon/r300.c               |    8 +++-
 drivers/gpu/drm/radeon/r420.c               |    8 +++-
 drivers/gpu/drm/radeon/r520.c               |    8 +++-
 drivers/gpu/drm/radeon/r600.c               |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |    3 +
 drivers/gpu/drm/radeon/radeon_cs.c          |    4 ++
 drivers/gpu/drm/radeon/radeon_ring.c        |    7 ++-
 drivers/gpu/drm/radeon/rs400.c              |    8 +++-
 drivers/gpu/drm/radeon/rs600.c              |    8 +++-
 drivers/gpu/drm/radeon/rs690.c              |    8 +++-
 drivers/gpu/drm/radeon/rv515.c              |    8 +++-
 drivers/gpu/drm/radeon/rv770.c              |    1 +
 25 files changed, 190 insertions(+), 97 deletions(-)
--29444707-1788486740-1329940596=:18534--
