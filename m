Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab0KJVc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:32:26 -0500
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:62276 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756993Ab0KJVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:32:25 -0500
X-AuditID: 12074423-b7bd0ae000000a00-be-4cdb0f683e2a
From: Andy Lutomirski <luto@MIT.EDU>
To: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/2] Use existing defines for NV50 hotplug registers
Date: Wed, 10 Nov 2010 16:32:04 -0500
Message-Id: <8055e8485f28491fe6219c512e379b4b89bcd465.1289423199.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <cover.1289423299.git.luto@mit.edu>
References: <cover.1289423299.git.luto@mit.edu>
In-Reply-To: <cover.1289423299.git.luto@mit.edu>
References: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com> <cover.1289423299.git.luto@mit.edu>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't change code at all, but it makes it a lot easier
to understand.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: <stable@kernel.org>
---
 drivers/gpu/drm/nouveau/nv50_display.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
index 612fa6d..83a7d27 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -453,8 +453,8 @@ static int nv50_display_disable(struct drm_device *dev)
 	nv_wr32(dev, NV50_PDISPLAY_INTR_EN, 0x00000000);
 
 	/* disable hotplug interrupts */
-	nv_wr32(dev, 0xe054, 0xffffffff);
-	nv_wr32(dev, 0xe050, 0x00000000);
+	nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, 0xffffffff);
+	nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_INTR, 0x00000000);
 	if (dev_priv->chipset >= 0x90) {
 		nv_wr32(dev, 0xe074, 0xffffffff);
 		nv_wr32(dev, 0xe070, 0x00000000);
@@ -1014,7 +1014,7 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
 	uint32_t unplug_mask, plug_mask, change_mask;
 	uint32_t hpd0, hpd1 = 0;
 
-	hpd0 = nv_rd32(dev, 0xe054) & nv_rd32(dev, 0xe050);
+	hpd0 = nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL) & nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_INTR);
 	if (dev_priv->chipset >= 0x90)
 		hpd1 = nv_rd32(dev, 0xe074) & nv_rd32(dev, 0xe070);
 
@@ -1058,7 +1058,7 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
 			helper->dpms(connector->encoder, DRM_MODE_DPMS_OFF);
 	}
 
-	nv_wr32(dev, 0xe054, nv_rd32(dev, 0xe054));
+	nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL));
 	if (dev_priv->chipset >= 0x90)
 		nv_wr32(dev, 0xe074, nv_rd32(dev, 0xe074));
 
-- 
1.7.3.2

