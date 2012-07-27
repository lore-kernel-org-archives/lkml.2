Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2G0FBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 01:01:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23648 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2G0FBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 01:01:41 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-bf-501220b2a6f9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] charger-manager: Use replacement variable to check state
 of battery
Date: Fri, 27 Jul 2012 14:01:37 +0900
Message-id: <1343365297-3530-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd3NCkIBBl2n2Cwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGooUXWQtu8Fa8mPuEsYHxIHcXIyeHhICJxJf9H9kgbDGJC/fW
	A9lcHEICixgl7m2cxwqSEBJYyiTx5W8+iM0moCWx/8UNsAYRATmJ12v/MoE0MAucYpR4dPEE
	M0hCWCBK4vGVdWBFLAKqErv/fmUBsXkFXCQm7OtmhdimING67BD7BEbuBYwMqxhFUwuSC4qT
	0nMN9YoTc4tL89L1kvNzNzGCffhMagfjygaLQ4wCHIxKPLwTeYUChFgTy4orcw8xSnAwK4nw
	PucDCvGmJFZWpRblxxeV5qQWH2KU5mBREuc19v7qLySQnliSmp2aWpBaBJNl4uCUamD0KXye
	4FVybb7g7sS12sX75ZgtL/QyxsXotS2wjhA96KOcw3ik9nymVkPryxOZf1USE5X+vzj5siDm
	ZlOXdNmJrj5nHrn6awl2Nntv7Niyz8FmrY1oz8E011uNjVPPL/vMNkEzVZn1TMdb/ckPsxks
	fAU+/k75uj9nJderbdtV23Q4WHJb7iqxFGckGmoxFxUnAgAYpXOU3QEAAA==
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
index 240de49..cdf29d2 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -415,7 +415,7 @@ static void fullbatt_vchk(struct work_struct *work)
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

