Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2HDF6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 01:58:19 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:48232 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2HDF6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 01:58:17 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJbAGK5HFBV5qoUPGdsb2JhbABFhRIiAYUArwgZAQEBATc0gn0TAQ8YEXEKGhOIEbx2FIs9hnsDmzSNBIFU
X-IronPort-AV: E=Sophos;i="4.77,711,1336341600"; 
   d="scan'208";a="168481409"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Dave Airlie <airlied@gmail.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] nouveau: Do not use nva3 engine for 0xaf chipset
Date: Sat,  4 Aug 2012 08:00:45 +0200
Message-Id: <1344060045-784-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nva3 copy engine exhibits random memory corruption in at least one
case, the GeForce 320M (nv50, 0xaf) in the MacBookAir3,1.  This patch
omits creating the engine for the specific chipset, falling back to
M2MF, which kills the symptoms.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Ben,

this patch is still needed in 3.6-rc1, so perhaps we should apply it
after all. I have been running it without problems for a long time
now.

Thanks,
Henrik

 drivers/gpu/drm/nouveau/nouveau_state.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index 1cdfd6e..1866dbb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -731,7 +731,6 @@ nouveau_card_init(struct drm_device *dev)
 			case 0xa3:
 			case 0xa5:
 			case 0xa8:
-			case 0xaf:
 				nva3_copy_create(dev);
 				break;
 			}
-- 
1.7.11.4

