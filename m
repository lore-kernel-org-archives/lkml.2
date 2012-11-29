Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2K2KHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:07:18 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34695 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2K2KHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:07:15 -0500
Date: Thu, 29 Nov 2012 10:07:12 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1211291004440.27480@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus

just driver fixes, nothing major, except maybe ilk rc6 disable.

intel: revert ironlake rc6 - we still have one ilk regression, but this 
gets rid of one big one, turn off cloning, and a directed fix for Apple 
edp
radeon: one modesetting fix
exynos: minor fixes

Dave.

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to e548a83c34806b8bc2c55f52d3bc481a13a3829e:

  Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux (2012-11-28 16:51:10 +1000)

----------------------------------------------------------------

Chris Wilson (1):
      Revert "drm/i915: enable rc6 on ilk again"

Daniel Vetter (1):
      drm/i915: disable cloning on sdvo

Dave Airlie (3):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos
      Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux

Inki Dae (3):
      drm/exynos: fix linux framebuffer address setting.
      drm/exynos: remove unnecessary code.
      drm/exynos: fix overlay updating issue

Jani Nikula (1):
      drm/i915: do not default to 18 bpp for eDP if missing from VBT

Jerome Glisse (1):
      radeon: fix pll/ctrc mapping on dce2 and dce3 hardware

Sachin Kamat (2):
      drm/exynos: Make exynos4/5_fimd_driver_data static
      drm/exynos: Fix potential NULL pointer dereference in exynos_drm_encoder.c

 drivers/gpu/drm/exynos/exynos_drm_encoder.c |  8 ++++-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c   |  3 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c    |  4 +--
 drivers/gpu/drm/exynos/exynos_drm_plane.c   |  1 -
 drivers/gpu/drm/i915/intel_bios.c           | 11 ++-----
 drivers/gpu/drm/i915/intel_display.c        |  2 +-
 drivers/gpu/drm/i915/intel_pm.c             | 12 ++------
 drivers/gpu/drm/i915/intel_sdvo.c           | 17 +++++-----
 drivers/gpu/drm/radeon/atombios_crtc.c      | 48 +++++++++--------------------
 9 files changed, 41 insertions(+), 65 deletions(-)
