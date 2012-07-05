Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2GEGbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:31:00 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:53977 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2GEGa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:30:59 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao5YAIAz9U9V5qg+PGdsb2JhbABFihqpM4NaGQEBAQEeAxYNJ4J1IxgRcQoaiCK6CxSLLoY1A5scjH+BVA
X-IronPort-AV: E=Sophos;i="4.77,528,1336341600"; 
   d="scan'208";a="74886831"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Dave Airlie <airlied@gmail.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [REGRESSION] nouveau: Memory corruption using nva3 engine for 0xaf
Date: Thu,  5 Jul 2012 08:31:13 +0200
Message-Id: <1341469873-1582-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Dave,

Since 3.5-rc0, I have been experiencing occasional screen corruption
on my MacBookAir3,1, using a GeForce 320M (nv50, 0xaf). The X driver
version is xf86-video-nouvea-1.0.1-1 (arch).

I do not know what the root problem is, but I have been able to
isolate the symptoms to the usage of nva3_copy.c. The patch below is
the least intrusive way I could find which kills the symptoms.

Hopefully this will sched some light on the true problem, such that a
fix can be found for 3.5.

Thanks,
Henrik

The nva3 copy engine exhibits random memory corruption in at least one
case, the GeForce 320M (nv50, 0xaf) in the MacBookAir3,1.  This patch
omits creating the engine for the specific chipset, falling back to
M2MF, which kills the symptoms.
---
 drivers/gpu/drm/nouveau/nouveau_state.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index 19706f0..b466937 100644
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

