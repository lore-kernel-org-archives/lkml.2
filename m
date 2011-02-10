Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1BJAii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 19:38:38 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:16017 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab1BJAig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 19:38:36 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_can: fix tseg1/tseg2 setting issue
Date: Thu, 10 Feb 2011 09:39:59 +0900
Message-Id: <1297298399-6250-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch "[PATCH 1/3] pch_can: fix 800k comms issue" is wrong.
I should have modified tseg1_min not tseg2_min.
This patch reverts tseg2_min to 1 and set tseg1_min to 2.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 7d8bc12..e54712b 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -185,9 +185,9 @@ struct pch_can_priv {
 
 static struct can_bittiming_const pch_can_bittiming_const = {
 	.name = KBUILD_MODNAME,
-	.tseg1_min = 1,
+	.tseg1_min = 2,
 	.tseg1_max = 16,
-	.tseg2_min = 2,
+	.tseg2_min = 1,
 	.tseg2_max = 8,
 	.sjw_max = 4,
 	.brp_min = 1,
-- 
1.7.3.4

