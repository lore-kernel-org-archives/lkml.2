Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1KDMLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:11:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23338 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab1KDMJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:09:55 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-0b-4eb3d6106de2
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Subject: [PATCH 03/10] drm/exynos: fixed connector flag with hpd and interlace
 scan for hdmi
Date: Fri, 04 Nov 2011 21:09:52 +0900
Message-id: <1320408599-7475-4-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
References: <1320408599-7475-1-git-send-email-sw0312.kim@samsung.com>
X-OriginalArrivalTime: 04 Nov 2011 12:09:38.0153 (UTC)
 FILETIME=[9FD60590:01CC9AEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdmi display in exynos supports hotplug event and interlace scan mode

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_connector.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_connector.c b/drivers/gpu/drm/exynos/exynos_drm_connector.c
index 985d9e7..d1a459f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_connector.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_connector.c
@@ -254,6 +254,8 @@ struct drm_connector *exynos_drm_connector_create(struct drm_device *dev,
 	switch (manager->display->type) {
 	case EXYNOS_DISPLAY_TYPE_HDMI:
 		type = DRM_MODE_CONNECTOR_HDMIA;
+		connector->interlace_allowed = true;
+		connector->polled = DRM_CONNECTOR_POLL_HPD;
 		break;
 	default:
 		type = DRM_MODE_CONNECTOR_Unknown;
-- 
1.7.4.1

