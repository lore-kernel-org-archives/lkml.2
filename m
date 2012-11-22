Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab2KVUEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:04:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60186 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab2KVUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:04:06 -0500
X-AuditID: cbfee61b-b7f616d00000319b-92-50adda1742e8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2 2/3] charger-manager: Fix bug when check dropped voltage
 after fullbatt event
Date: Thu, 22 Nov 2012 16:53:51 +0900
Message-id: <1353570831-19439-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zLV3xW2sDDDb2Gllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MOZtfsRas4K64f3MqUwPjNs4uRk4OCQETidv9p9khbDGJC/fW
	s3UxcnEICSxjlFh07SgbTNGW9/dYIBKLGCWufHkNVbWUSWLXiwawdjYBLYn9L26AdYgIyEm8
	XvuXCcRmFqiV2HetibWLkYNDWCBJYs6TapAwi4CqxLzPX1hAbF4BV4mLkz4xQyxTkGhddogd
	okZA4tvkQywgrRICshKbDjCDrJUQ2MEmcfsLyEiQekmJgytusExgFFzAyLCKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIySkpHcwrmqwOMQowMGoxMObYbA2QIg1say4MvcQowQHs5II76IC
	oBBvSmJlVWpRfnxRaU5q8SFGH6BLJjJLiSbnA8M9ryTe0NjA2NDQ0tDM1NLUAIewkjhvs0dK
	gJBAemJJanZqakFqEcw4Jg5OqQbG7Oe6bz5aRpsacTy/Gc7J/ue1l6Ri01nmhYurlS3qFt3p
	Kt3772yweo3o77hLZZ/Sj06tCfC/svcB4+LGf8+8TXq/X/8cv/ZFrJeE5aqpJ9nW6TA4TV/k
	PeVDmvmEtRnyq5KnTf+S2rLY2eh2zaGmh2u8H9428lzg9tdkXf6ElQmXkpWX53MVK7EUZyQa
	ajEXFScCADOAFDxWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jAV3xW2sDDBZ+VrO4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGXM2v2ItWMFdcf/mVKYG
	xm2cXYycHBICJhJb3t9jgbDFJC7cW8/WxcjFISSwiFHiypfXUM5SJoldLxrYQarYBLQk9r+4
	wQZiiwjISbxe+5cJxGYWqJXYd62JtYuRg0NYIElizpNqkDCLgKrEvM9fwBbwCrhKXJz0iRli
	mYJE67JD7BMYuRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7YZ9I7GFc1WBxiFOBg
	VOLhzTBYGyDEmlhWXJl7iFGCg1lJhHdRAVCINyWxsiq1KD++qDQntfgQow/Q9onMUqLJ+cBo
	yiuJNzQ2MTOyNDIzNjE3NsYhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0VbDc9EU949s
	7Am+L1iX3GbUqfvScm/Wuie7V75nmZf6cNmnnZbWJ3j5RXiYDG2/vzp6yq/dLpQzzPzy7gMr
	bkhUiaeFbSu4ONf4n/gv/riJotcW/Vvfo6avH8A202qWpOZRnfhL3Ruver/okH+2T/bafccL
	jrcKPVU3BidulJ7zuyqf14qlXImlOCPRUIu5qDgRADJZe0yFAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch check difference value between current voltage of battery
and desc->fullbatt_uV whether positve or negative number. If difference
value is negative number when current voltage of battery is larger than
desc->fullbatt_uV, charger-manager return immediately because battery
is fully charged.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index ee039b9..17130c7 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -468,7 +468,9 @@ static void fullbatt_vchk(struct work_struct *work)
 	struct charger_manager *cm = container_of(dwork,
 			struct charger_manager, fullbatt_vchk_work);
 	struct charger_desc *desc = cm->desc;
-	int batt_uV, err, diff;
+	int batt_uV;
+	int err;
+	int diff;
 
 	/* remove the appointment for fullbatt_vchk */
 	cm->fullbatt_vchk_jiffies_at = 0;
@@ -482,8 +484,9 @@ static void fullbatt_vchk(struct work_struct *work)
 		return;
 	}
 
-	diff = desc->fullbatt_uV;
-	diff -= batt_uV;
+	diff = desc->fullbatt_uV - batt_uV;
+	if (diff < 0)
+		return;
 
 	dev_info(cm->dev, "VBATT dropped %duV after full-batt.\n", diff);
 
-- 
1.7.0.4

