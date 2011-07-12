Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1GLWio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:38:44 -0400
Received: from ev1s-66-98-244-53.theplanet.com ([66.98.244.53]:2129 "EHLO
	relay.fireflyinternet.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754087Ab1GLWin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:38:43 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Dave Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedestop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Konstantin Belousov <kostikbel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] agp/intel: Fix typo in G4x_GMCH_SIZE_VT_2M
Date: Tue, 12 Jul 2011 23:38:18 +0100
Message-Id: <1310510298-16360-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.5.4
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Belousov found an error in the define of G4x_GMCH_SIZE_VT_2M
relative to the GMCH specs, and confirmed that indeed one of his users
with a Q45 reports 0xb not 0xc for a 2/2MiB GATT.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Konstantin Belousov <kostikbel@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/char/agp/intel-agp.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index 999803c..5da67f1 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -90,9 +90,10 @@
 #define G4x_GMCH_SIZE_MASK	(0xf << 8)
 #define G4x_GMCH_SIZE_1M	(0x1 << 8)
 #define G4x_GMCH_SIZE_2M	(0x3 << 8)
-#define G4x_GMCH_SIZE_VT_1M	(0x9 << 8)
-#define G4x_GMCH_SIZE_VT_1_5M	(0xa << 8)
-#define G4x_GMCH_SIZE_VT_2M	(0xc << 8)
+#define G4x_GMCH_SIZE_VT_EN	(0x8 << 8)
+#define G4x_GMCH_SIZE_VT_1M	(G4x_GMCH_SIZE_1M | G4x_GMCH_SIZE_VT_EN)
+#define G4x_GMCH_SIZE_VT_1_5M	((0x2 << 8) | G4x_GMCH_SIZE_VT_EN)
+#define G4x_GMCH_SIZE_VT_2M	(G4x_GMCH_SIZE_2M | G4x_GMCH_SIZE_VT_EN)
 
 #define GFX_FLSH_CNTL		0x2170 /* 915+ */
 
-- 
1.7.5.4

