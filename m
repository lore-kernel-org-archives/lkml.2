Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3AHXdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:33:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44316 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab3AHXdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:33:18 -0500
Date: Tue, 8 Jan 2013 23:33:07 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1301082331030.4053@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

exynos and radeon mostly, with a dma-buf and ttm fix thrown in

Its a bit big but its mostly exynos license fix ups and I'd rather not 
hold those up since its legally stuff.

radeon has a couple of fixes from dma engine work,
ttm is just a locking fix
and dma-buf fix has been hanging around and I finally got a chance to 
review it.

Dave.


The following changes since commit eda85d6ad490923152544fba0473798b6cc0edf6:

  drm/nouveau: fix init with agpgart-uninorth (2013-01-04 16:04:33 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to e8e89622ed361c46bf90ba4828e685a8b603f7e5:

  drm/ttm: fix fence locking in ttm_buffer_object_transfer (2013-01-08 18:35:31 +1000)

----------------------------------------------------------------
Alex Deucher (2):
      drm/radeon: split r6xx and r7xx copy_dma functions
      drm/radeon: fix DMA CS parser for r6xx linear copy packet

Daniel Vetter (1):
      drm/ttm: fix fence locking in ttm_buffer_object_transfer

Dave Airlie (2):
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'drm-fixes-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next

Eunchul Kim (6):
      drm/exynos: change member variable name.
      drm/exynos: remove needless error handling to property.
      drm/exynos: consider both case of vflip and hflip.
      drm/exynos: fix build warning.
      drm/exynos: correct some comments to abbreviation.
      drm/exynos: remove needless parenthesis.

Inki Dae (4):
      drm/exynos: consider no iommu support to console framebuffer
      drm/exynos: change file license to GPL
      drm/exynos: consider buffer allocation without iommu
      drm/exynos: fix gem buffer allocation type checking

Jinyoung Jeon (1):
      drm/exynos: fix incorrect interrupt induced by m2m operation.

JoongMock Shin (1):
      drm/exynos: remove color bar pattern operation.

Maarten Lankhorst (1):
      drm/radeon: add quirk for d3 delay during switcheroo poweron for apple macbooks

Prathyush K (1):
      drm/exynos: fimd: modify condition in fimd resume

Rahul Sharma (1):
      drm/exynos: move finish page flip to a common place

Sachin Kamat (10):
      drm/exynos: Use devm_kzalloc in exynos_drm_ipp.c
      drm/exynos: Remove explicit freeing using devm_* APIs in exynos_drm_fimc.c
      drm/exynos: Remove redundant NULL check
      drm/exynos: Use devm_clk_get in exynos_drm_fimc.c
      drm/exynos: Remove unnecessary devm_* freeing APIs in exynos_drm_rotator.c
      drm/exynos: Remove redundant NULL check in exynos_drm_rotator.c
      drm/exynos: Use devm_clk_get in exynos_drm_rotator.c
      drm/exynos: Remove explicit freeing using devm_* APIs in exynos_drm_gsc.c
      drm/exynos: Remove redundant NULL check in exynos_drm_gsc.c
      drm/exynos: Use devm_clk_get in exynos_drm_gsc.c

Seung-Woo Kim (2):
      drm/exynos: fix flags in dma buf exporting
      drm/prime: drop reference on imported dma-buf come from gem

 drivers/gpu/drm/exynos/exynos_drm_buf.c       |  79 ++++++++++------
 drivers/gpu/drm/exynos/exynos_drm_buf.h       |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_connector.c |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_connector.h |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_core.c      |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_crtc.c      |  52 +++++++----
 drivers/gpu/drm/exynos/exynos_drm_crtc.h      |  23 ++---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c    |  29 +++---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.h    |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_drv.c       |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_drv.h       |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_encoder.c   |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_encoder.h   |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_fb.c        |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_fb.h        |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c     |  44 ++++-----
 drivers/gpu/drm/exynos/exynos_drm_fbdev.h     |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_fimc.c      | 124 ++++++++------------------
 drivers/gpu/drm/exynos/exynos_drm_fimc.h      |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      |  32 +------
 drivers/gpu/drm/exynos/exynos_drm_gem.c       |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_gem.h       |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_gsc.c       |  56 +++---------
 drivers/gpu/drm/exynos/exynos_drm_gsc.h       |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h      |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_iommu.c     |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_iommu.h     |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_ipp.c       |  22 ++---
 drivers/gpu/drm/exynos/exynos_drm_ipp.h       |  26 ++----
 drivers/gpu/drm/exynos/exynos_drm_rotator.c   |  28 ++----
 drivers/gpu/drm/exynos/exynos_drm_rotator.h   |  22 +----
 drivers/gpu/drm/exynos/exynos_drm_vidi.c      |  30 +------
 drivers/gpu/drm/exynos/exynos_drm_vidi.h      |  22 +----
 drivers/gpu/drm/exynos/exynos_hdmi.h          |  22 +----
 drivers/gpu/drm/exynos/exynos_mixer.c         |  33 +------
 drivers/gpu/drm/i915/i915_gem_dmabuf.c        |   5 ++
 drivers/gpu/drm/nouveau/nouveau_prime.c       |   1 +
 drivers/gpu/drm/radeon/r600.c                 |  10 +--
 drivers/gpu/drm/radeon/r600_cs.c              |  31 +++++--
 drivers/gpu/drm/radeon/radeon_asic.c          |   4 +-
 drivers/gpu/drm/radeon/radeon_asic.h          |   4 +
 drivers/gpu/drm/radeon/radeon_device.c        |  28 ++++++
 drivers/gpu/drm/radeon/radeon_prime.c         |   1 +
 drivers/gpu/drm/radeon/rv770.c                |  74 +++++++++++++++
 drivers/gpu/drm/ttm/ttm_bo_util.c             |   4 +-
 drivers/staging/omapdrm/omap_gem_dmabuf.c     |   5 ++
 include/drm/exynos_drm.h                      |  22 +----
 include/uapi/drm/exynos_drm.h                 |  24 ++---
 48 files changed, 447 insertions(+), 828 deletions(-)
