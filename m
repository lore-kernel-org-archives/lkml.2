Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1KDMJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:09:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23338 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1KDMJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:53 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-04-4eb3d61070c3
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 00/10] drm/exynos: prepare multiple display controllers
Date: Fri, 04 Nov 2011 21:09:49 +0900
Message-id: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0106 (UTC)
 FILETIME=[9FCED9A0:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparing multiple display controllers, FIMD and HDMI.
- added padding into ioctl structure to be 64 bit align
- added kms poll to handle hpd event
- fixed converting between display mode and timing
- fixed connector and crtc callbacks to call proper display driver
- code clean

based git repository is below:
git://people.freedesktop.org/~airlied/linux.git
branch name: drm-core-next
base commit-id: 1717c0e23f411147490c7a3312b894f0ea9a5fb1

Inki Dae (3):
  drm/exynos: added padding to be 64-bit align.
  drm/exynos: added manager object to connector
  drm/exynos: changed exynos_drm_display to exynos_drm_display_ops

Joonyoung Shim (1):
  drm/exynos: restored kernel_fb_list when reiniting fb_helper

Seung-Woo Kim (6):
  drm/exynos: added kms poll for handling hpd event
  drm/exynos: fixed connector flag with hpd and interlace scan for hdmi
  drm/exynos: fixed converting between display mode and timing
  drm/exynos: removed meaningless parameter from fbdev update
  drm/exynos: added crtc dpms for disable crtc
  drm/exynos: checked for null pointer

 drivers/gpu/drm/exynos/exynos_drm_connector.c |   78 ++++++++++++++++++-------
 drivers/gpu/drm/exynos/exynos_drm_crtc.c      |   16 ++++-
 drivers/gpu/drm/exynos/exynos_drm_drv.c       |    5 ++
 drivers/gpu/drm/exynos/exynos_drm_drv.h       |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_encoder.c   |   64 +++++++++++++++++----
 drivers/gpu/drm/exynos/exynos_drm_encoder.h   |    1 +
 drivers/gpu/drm/exynos/exynos_drm_fb.c        |   12 ++++
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c     |   29 ++++++---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      |    4 +-
 include/drm/exynos_drm.h                      |    2 +
 10 files changed, 165 insertions(+), 50 deletions(-)

-- 
1.7.4.1

