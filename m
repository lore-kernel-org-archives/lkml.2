Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2EVGHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:07:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41605 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2EVGHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:07:39 -0400
From: Arvydas Sidorenko <asido4@gmail.com>
To: airlied@linux.ie
Cc: bskeggs@redhat.com, maximlevitsky@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        asido4@gmail.com
Subject: [PATCH] nouveau_drv.c: notify when KMS is disabled
Date: Tue, 22 May 2012 08:06:14 +0200
Message-Id: <1337666774-4514-1-git-send-email-asido4@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On nouveau init whenever VGA fallback is used no notification is given
in dmesg.

Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_drv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 4f2030b..ea90d60 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -473,8 +473,10 @@ static int __init nouveau_init(void)
 			nouveau_modeset = 1;
 	}
 
-	if (!nouveau_modeset)
+	if (!nouveau_modeset) {
+		DRM_INFO("nouveau KMS disabled");
 		return 0;
+	}
 
 	nouveau_register_dsm_handler();
 	return drm_pci_init(&driver, &nouveau_pci_driver);
-- 
1.7.8.6

