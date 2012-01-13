Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2AMKef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 05:34:35 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37947 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab2AMKed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 05:34:33 -0500
Date: Fri, 13 Jan 2012 10:34:32 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] some fixes for -rc1
Message-ID: <alpine.DEB.2.00.1201131032290.5736@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-259696568-1326450872=:5736"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-259696568-1326450872=:5736
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

misc fixes for -rc1, fix the dma-buf Kconfig, two nouveau fixes I've 
tested locally on optimus laptop and they seem to fix the problem off 
turning the GPU off properly when asked.

I've booted this specifc tree only as far as the autofs hang I've 
mentioned, but the gpu driver comes up fine, and there is nothing really 
scary in this lot.

Dave.

The following changes since commit 099469502f62fbe0d7e4f0b83a2f22538367f734:

  Merge branch 'akpm' (aka "Andrew's patch-bomb, take two") (2012-01-12 20:42:54 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alan Cox (1):
      gma500: Discard modes that don't fit in stolen memory

Alex Deucher (1):
      drm/radeon/kms/ni: fix packet2 handling for VM IB parser

Ben Skeggs (1):
      drm: bump DRM_CONNECTOR_MAX_ENCODER from 2 to 3

Dave Airlie (1):
      dma-buf: drop option text so users don't select it.

Jean Delvare (1):
      drm/radeon/kms: Fix module parameter description format

Konrad Rzeszutek Wilk (1):
      ttm/dma: Remove the WARN() which is not useful.

Michel Dänzer (1):
      radeon: Call pci_clear_master() instead of open-coding it.

Peter Lekensteyn (2):
      nouveau: properly check for _DSM function support
      nouveau: Support Optimus models for vga_switcheroo

Sumit Semwal (1):
      dma-buf: Documentation update for Kconfig select

 Documentation/dma-buf-sharing.txt        |    4 ++
 drivers/base/Kconfig                     |    2 +-
 drivers/gpu/drm/gma500/cdv_intel_crt.c   |    6 ++
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c  |   14 ++---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c   |    6 ++
 drivers/gpu/drm/gma500/psb_intel_sdvo.c  |    6 ++
 drivers/gpu/drm/nouveau/nouveau_acpi.c   |   79 +++++++++++++++++++++++-------
 drivers/gpu/drm/nouveau/nouveau_drv.h    |    2 +
 drivers/gpu/drm/nouveau/nouveau_state.c  |    1 +
 drivers/gpu/drm/radeon/evergreen_cs.c    |    3 +-
 drivers/gpu/drm/radeon/r100.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_drv.c      |    2 +-
 drivers/gpu/drm/radeon/rs600.c           |   13 +----
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    5 +-
 include/drm/drm_crtc.h                   |    2 +-
 15 files changed, 102 insertions(+), 47 deletions(-)
--29444707-259696568-1326450872=:5736--
