Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967Ab2FHIx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:53:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33101 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab2FHIxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:53:25 -0400
Date: Fri, 8 Jun 2012 09:53:23 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel + exynos fixes
Message-ID: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1411466495-1339145603=:15272"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1411466495-1339145603=:15272
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

a bunch of fixes for Intel and exynos, nothing too major, a new intel PCI 
Id, and a fix for CRT detection.

Dave.

The following changes since commit 7aaa61b3476462b69f1ac7669fcca8d608ce3cb5:

  drm/radeon/kms: add new SI PCI ids (2012-06-05 15:11:12 +0100)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 2d5c7cd35f1addb812e0b1709b3c727f1a58ca9c:

  Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-samsung into drm-fixes (2012-06-08 09:42:51 +0100)

----------------------------------------------------------------

Adam Jackson (1):
      drm/i915: pch_irq_handler -> {ibx, cpt}_irq_handler

Chris Wilson (3):
      drm/i915: Reset last_retired_head when resetting ring
      drm/i915/crt: Do not rely upon the HPD presence pin
      drm/i915: Mark the ringbuffers as being in the GTT domain

Daniel Vetter (2):
      drm/i915: hold forcewake around ring hw init
      drm/i915: fix up ivb plane 3 pageflips

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-samsung into drm-fixes

Eugeni Dodonov (1):
      char/agp: add another Ironlake host bridge

Inki Dae (1):
      drm/exynos: fixed size type.

Laurent Pinchart (4):
      drm/exynos: DRIVER_BUS_PLATFORM is not a driver feature
      drm/exynos: Don't cast GEM object to Exynos GEM object when not needed
      drm/exynos: Keep a reference to frame buffer GEM objects
      drm/exynos: Remove dummy encoder get_crtc operation implementation

Seung-Woo Kim (1):
      drm/exynos: fixed blending for hdmi graphic layer

Ville Syrjälä (1):
      drm/exynos: Use DRM_FORMAT_{NV12, YUV420} instead of DRM_FORMAT_{NV12M, YUV420M}

 drivers/char/agp/intel-agp.c                |    1 +
 drivers/char/agp/intel-agp.h                |    1 +
 drivers/gpu/drm/exynos/exynos_drm_drv.c     |    4 +--
 drivers/gpu/drm/exynos/exynos_drm_encoder.c |    7 -----
 drivers/gpu/drm/exynos/exynos_drm_fb.c      |   19 ++++++++----
 drivers/gpu/drm/exynos/exynos_drm_fb.h      |    4 +--
 drivers/gpu/drm/exynos/exynos_drm_gem.c     |    9 ++----
 drivers/gpu/drm/exynos/exynos_mixer.c       |   12 ++++----
 drivers/gpu/drm/i915/i915_drv.c             |   13 +++++---
 drivers/gpu/drm/i915/i915_drv.h             |    3 ++
 drivers/gpu/drm/i915/i915_irq.c             |   38 +++++++++++++++++++++--
 drivers/gpu/drm/i915/i915_reg.h             |   43 +++++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_crt.c            |    8 +++--
 drivers/gpu/drm/i915/intel_display.c        |   19 +++++++++++-
 drivers/gpu/drm/i915/intel_ringbuffer.c     |   21 +++++++++++--
 include/drm/exynos_drm.h                    |    4 ++-
 16 files changed, 161 insertions(+), 45 deletions(-)
--29444707-1411466495-1339145603=:15272--
