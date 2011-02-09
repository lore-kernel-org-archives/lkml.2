Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1BIXy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:54:58 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:47202 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab1BIXy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:54:57 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/3 v2] pch_can: fix 800k comms issue
Date: Thu, 10 Feb 2011 08:56:16 +0900
Message-Id: <1297295776-3735-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch "[PATCH 1/3] pch_can: fix 800k comms issue" is wrong.
I should have modified tseg1_min not tseg2_min.
Please discard previous patch and use this patch.

Currently, 800k comms fails since prop_seg set zero.
(EG20T PCH CAN register of prop_seg must be set more than 1)
To prevent prop_seg set to zero, change tseg2_min 1 to 2.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index c42e972..0534eed 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -185,7 +185,7 @@ struct pch_can_priv {
 
 static struct can_bittiming_const pch_can_bittiming_const = {
 	.name = KBUILD_MODNAME,
-	.tseg1_min = 1,
+	.tseg1_min = 2,
 	.tseg1_max = 16,
 	.tseg2_min = 1,
 	.tseg2_max = 8,
-- 
1.7.3.4

