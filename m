Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2AYTFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:05:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45615 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab2AYTFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:05:12 -0500
Date: Wed, 25 Jan 2012 19:05:10 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1201251902590.12477@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

bunch of regression fixes since TTM rework and radeon initialisation, 
modesetting fixes for Alex to fix some black screens on kms start type 
issues, and two radeon ACPI fixes that make some laptops no oops on 
startup.

I think Intel have some -fixes coming soon which I'll send in a separate 
pull.

Dave.

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alan Cox (1):
      gma500: Fix shmem mapping

Alex Deucher (7):
      drm/radeon/kms: Add an MSI quirk for Dell RS690
      drm/radeon/kms: add some missing semaphore init
      drm/radeon/kms: move disp eng pll setup to init path
      drm/radeon/kms: move panel mode setup into encoder mode set
      drm/radeon/kms: rework modeset sequence for DCE41 and DCE5
      drm/radeon/kms: use drm_detect_hdmi_monitor for picking encoder mode
      drm/radeon/kms: refine TMDS dual link checks

Ben Skeggs (1):
      drm/ttm: fix two regressions since move_notify changes

Igor Murzov (2):
      drm/radeon: fix invalid memory access in radeon_atrm_get_bios()
      drm/radeon: finish getting bios earlier

Jerome Glisse (2):
      drm/radeon: silence out possible lock dependency warning
      drm/radeon: avoid deadlock if GPU lockup is detected in ib_pool_get

Jesper Juhl (1):
      gpu, drm, sis: Don't return uninitialized variable from sis_driver_load()

Thomas Hellstrom (1):
      drm: Fix authentication kernel crash

 drivers/gpu/drm/drm_auth.c                   |    6 ++-
 drivers/gpu/drm/drm_fops.c                   |    5 ++
 drivers/gpu/drm/gma500/gtt.c                 |    5 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c         |    4 +
 drivers/gpu/drm/radeon/atombios_crtc.c       |   60 +++++++++---------
 drivers/gpu/drm/radeon/atombios_dp.c         |   22 +++----
 drivers/gpu/drm/radeon/atombios_encoders.c   |   89 +++++++++++++-------------
 drivers/gpu/drm/radeon/evergreen.c           |    1 +
 drivers/gpu/drm/radeon/evergreend.h          |    1 +
 drivers/gpu/drm/radeon/ni.c                  |    1 +
 drivers/gpu/drm/radeon/nid.h                 |    1 +
 drivers/gpu/drm/radeon/radeon.h              |   84 ++++++++++++------------
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    4 +-
 drivers/gpu/drm/radeon/radeon_bios.c         |    2 +-
 drivers/gpu/drm/radeon/radeon_device.c       |    8 ++-
 drivers/gpu/drm/radeon/radeon_display.c      |    6 +-
 drivers/gpu/drm/radeon/radeon_encoders.c     |   77 ++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_irq_kms.c      |    6 ++
 drivers/gpu/drm/radeon/radeon_mode.h         |    8 ++
 drivers/gpu/drm/radeon/radeon_ring.c         |   37 ++++++-----
 drivers/gpu/drm/sis/sis_drv.c                |    3 +-
 drivers/gpu/drm/ttm/ttm_bo.c                 |   17 ++++-
 include/drm/drmP.h                           |    1 +
 23 files changed, 285 insertions(+), 163 deletions(-)
