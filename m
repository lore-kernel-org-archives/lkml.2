Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1BHJ1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:27:33 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30961 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287Ab1BHJ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:27:31 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/3] pch_can: fix 800k comms issue
Date: Tue,  8 Feb 2011 18:29:01 +0900
Message-Id: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, 800k comms fails since prop_seg set zero.
(EG20T PCH CAN register of prop_seg must be set more than 1)
To prevent prop_seg set to zero, change tseg2_min 1 to 2.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index c42e972..9b171d1 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -187,7 +187,7 @@ static struct can_bittiming_const pch_can_bittiming_const = {
 	.name = KBUILD_MODNAME,
 	.tseg1_min = 1,
 	.tseg1_max = 16,
-	.tseg2_min = 1,
+	.tseg2_min = 2,
 	.tseg2_max = 8,
 	.sjw_max = 4,
 	.brp_min = 1,
-- 
1.7.3.4

