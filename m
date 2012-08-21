Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2HUIH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:07:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33826 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2HUIGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:06:33 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-76-50334187c11b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/5] charger-manager: Use replacement variable to check state
 of battery
Date: Tue, 21 Aug 2012 17:06:45 +0900
Message-id: <1345536405-25846-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jAd12R+MAgykPuCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGQ/9c9oIbvBX7775ia2A8yN3FyMkhIWAicXruZUYIW0ziwr31
	bF2MXBxCAosYJRqmzGeCcJYySbTt+c8KUsUmoCWx/8UNNhBbREBO4vXav2BFzAKnGCUeXTzB
	DJIQFoiSWHCuG6yBRUBV4u63NrAVvAKuEp+mzWOFWKcg0brsEPsERu4FjAyrGEVTC5ILipPS
	cw31ihNzi0vz0vWS83M3MYK9+ExqB+PKBotDjAIcjEo8vD8WGQUIsSaWFVfmHmKU4GBWEuGt
	1jcOEOJNSaysSi3Kjy8qzUktPsQozcGiJM7L32cYICSQnliSmp2aWpBaBJNl4uCUamBcKDLR
	OqBCoSgyNF/4JIvR5XOXYi/OKf+3XvFoZq1ImEeVO/+kp5nvJ012OuF8/rnJ02/Rl3dEl4iF
	n/+77DvPoaj/zPX/c3Qn/90Su/1RgVTxhbfnBYWNa9JrU6ys7R97fI2YtIH9U+6u6BQj5fao
	0qbK99xf+r6p1xWGrp/mPMW/fYn97DYlluKMREMt5qLiRAB9p9Og3gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary variable(cm->fullbatt_vchk_uV) by using
'desc->fullbatt_uV' field directly in fullbatt_handler() function
to check the state of battery.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c       |    2 +-
 include/linux/power/charger-manager.h |    3 ---
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index f968301..bee010e 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -417,7 +417,7 @@ static void fullbatt_vchk(struct work_struct *work)
 		return;
 	}
 
-	diff = cm->fullbatt_vchk_uV;
+	diff = desc->fullbatt_uV;
 	diff -= batt_uV;
 
 	dev_dbg(cm->dev, "VBATT dropped %duV after full-batt.\n", diff);
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index cd22029..7d7b90f 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -194,8 +194,6 @@ struct charger_desc {
  * @charger_enabled: the state of charger
  * @fullbatt_vchk_jiffies_at:
  *	jiffies at the time full battery check will occur.
- * @fullbatt_vchk_uV: voltage in microvolt
- *	criteria for full battery
  * @fullbatt_vchk_work: work queue for full battery check
  * @emergency_stop:
  *	When setting true, stop charging
@@ -218,7 +216,6 @@ struct charger_manager {
 	bool charger_enabled;
 
 	unsigned long fullbatt_vchk_jiffies_at;
-	unsigned int fullbatt_vchk_uV;
 	struct delayed_work fullbatt_vchk_work;
 
 	int emergency_stop;
-- 
1.7.0.4

