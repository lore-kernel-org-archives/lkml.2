Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0ENQNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:13:07 -0400
Received: from landau.phys.spbu.ru ([195.19.235.38]:48633 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0ENQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:12:58 -0400
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: David Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 1/2] drm/radeon: "unregistered panic notifier" printk is redundant
Date: Fri, 14 May 2010 19:45:15 +0400
Message-Id: <377e5122466e1f0b8ff48f50aea027135685d736.1273851443.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.7.1.87.gcc8c60.dirty
In-Reply-To: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
References: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
In-Reply-To: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
References: <cover.1273851443.git.kirr@landau.phys.spbu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because drm_fb_helper_free() prints the same.

This redundant printk seems to be a forgotten leftover after 785b93ef
(drm/kms: move driver specific fb common code to helper functions (v2))
-- let's remove it.

Cc: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
---
 drivers/gpu/drm/radeon/radeon_fb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 9ac57a0..2a161d8 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -365,8 +365,6 @@ int radeonfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
 		framebuffer_release(info);
 	}
 
-	printk(KERN_INFO "unregistered panic notifier\n");
-
 	return 0;
 }
 EXPORT_SYMBOL(radeonfb_remove);
-- 
1.7.1.87.gcc8c60.dirty
