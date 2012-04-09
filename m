Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2DIGea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 02:34:30 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:46604 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2DIGe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 02:34:29 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av5VAM2Cgk9V5qnhPGdsb2JhbABFiiivBhkBAQEBNzSCNy8TAQ8YgQIKGhOIErlYE4sKhT0Em22NHoFSFg
X-IronPort-AV: E=Sophos;i="4.75,393,1330902000"; 
   d="scan'208";a="84803301"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dave Airlie <airlied@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] nouveau: Set special lane map for the right chipset
Date: Mon,  9 Apr 2012 08:36:22 +0200
Message-Id: <1333953382-2545-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The refactoring of the nv50 logic, introduced in 8663bc7c, modified the
test for the special lane map used on some Apple computers with Nvidia
chipsets. The tested MBA3,1 would still boot, but resume from suspend
stopped working. This patch restores the old test, which fixes the problem.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/gpu/drm/nouveau/nv50_sor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_sor.c b/drivers/gpu/drm/nouveau/nv50_sor.c
index a7844ab..2746402 100644
--- a/drivers/gpu/drm/nouveau/nv50_sor.c
+++ b/drivers/gpu/drm/nouveau/nv50_sor.c
@@ -42,7 +42,7 @@ nv50_sor_dp_lane_map(struct drm_device *dev, struct dcb_entry *dcb, u8 lane)
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	static const u8 nvaf[] = { 24, 16, 8, 0 }; /* thanks, apple.. */
 	static const u8 nv50[] = { 16, 8, 0, 24 };
-	if (dev_priv->card_type == 0xaf)
+	if (dev_priv->chipset == 0xaf)
 		return nvaf[lane];
 	return nv50[lane];
 }
-- 
1.7.9.5

