Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab2CAJbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:31:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37834 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758566Ab2CAJbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:31:11 -0500
Date: Thu, 1 Mar 2012 09:31:09 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1203010928530.7663@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1295758537-1330594269=:7663"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1295758537-1330594269=:7663
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

intel: fixes for output regression on 965GM, an oops and a machine hang
radeon: uninitialised var (that gcc didn't warn about for some reason) + 
a couple of correctness fixes.
exynos: fixes for various things, drop some chunks of unused code.

Dave.

The following changes since commit 500dd2370e77c9551ba298bdeeb91b02d8402199:

  Merge tag 'stable/for-linus-fixes-3.3-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2012-02-26 21:03:16 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alban Browaeys (1):
      drm/i915: Prevent a machine hang by checking crtc->active before loading lut

Alex Deucher (1):
      drm/radeon/kms: fix radeon_dp_get_modes for LVDS bridges (v2)

Chris Wilson (1):
      drm/i915: Remove use of the autoreported ringbuffer HEAD position

Christian König (1):
      drm/radeon: fix uninitialized variable

Dave Airlie (3):
      drm/i915: fix mode set on load pipe. (v2)
      Merge branch 'drm-intel-fixes' of git://git.kernel.org/.../jbarnes/drm-intel into HEAD
      Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-2.6-samsung into HEAD

Eugeni Dodonov (1):
      drm/i915: fix operator precedence when enabling RC6p

Eun-Chul Kim (1):
      drm/exynos: added panel physical size.

Hai Lan (1):
      drm/i915: fix a sprite watermark computation to avoid divide by zero if xpos<0

Inki Dae (4):
      drm/exynos: added possible_clones setup function.
      drm/exynos: fixed page flip issue.
      drm/exynos: removed exynos_drm_fbdev_recreate function.
      drm/exynos: added postclose to release resource.

Joonyoung Shim (2):
      drm/exynos: changed priority of mixer layers.
      drm/exynos: removed pageflip_event_list init code when closed.

Kamil Debski (1):
      drm/exynos: exynos_drm.h header file fixes

Masanari Iida (1):
      drm/exynos: Fix typo in exynos_mixer.c

Sebastian Biemueller (1):
      drm/radeon/kms/vm: fix possible bug in radeon_vm_bo_rmv()

 drivers/gpu/drm/exynos/exynos_drm_connector.c |   16 ++++++++++----
 drivers/gpu/drm/exynos/exynos_drm_drv.h       |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      |   27 +++++++++++++------------
 drivers/gpu/drm/i915/intel_display.c          |   15 +++++++++++--
 drivers/gpu/drm/i915/intel_ringbuffer.c       |   14 +------------
 drivers/gpu/drm/radeon/r600_cs.c              |    1 +
 drivers/gpu/drm/radeon/radeon_connectors.c    |   25 +++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_gart.c          |    2 +-
 include/drm/Kbuild                            |    1 +
 include/drm/exynos_drm.h                      |   22 +++++++++++++++++--
 10 files changed, 79 insertions(+), 48 deletions(-)
--29444707-1295758537-1330594269=:7663--
