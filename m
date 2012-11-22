Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322Ab2KVUEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:04:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60172 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab2KVUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:03:58 -0500
X-AuditID: cbfee61b-b7f616d00000319b-79-50adda129ac7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2 1/3] charger-manager: Fix bug related to checking fully
 charged state of battery
Date: Thu, 22 Nov 2012 16:53:46 +0900
Message-id: <1353570826-19404-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zLV2hW2sDDA5/4be4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZp6ZsYS54LVjxb9FrxgbGqXxdjJwcEgImEtdfTWGCsMUkLtxb
	z9bFyMUhJLCMUeLo2ecsMEVfZ69mhUgsYpRovrwXqmopk8SOW7tYQarYBLQk9r+4wQZiiwjI
	Sbxe+xdsLLNArcS+a01gNcICqRIrJ98Gm8oioCqx7+gGsDivgKvE4i9T2SG2KUi0LjvEDlEj
	IPFt8iGgeg6guKzEpgPMECVb2CROfjCHsCUlDq64wTKBUXABI8MqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjJCQkt7BuKrB4hCjAAejEg9vhsHaACHWxLLiytxDjBIczEoivIsKgEK8KYmV
	ValF+fFFpTmpxYcYfYAOmcgsJZqcDwz3vJJ4Q2MDY0NDS0MzU0tTAxzCSuK8zR4pAUIC6Ykl
	qdmpqQWpRTDjmDg4pRoYGU6U7teaxSY9PWNl34KjXyULdpdliCbcPCjXO3/h9eLbXo+NTjO9
	fXBkfxdfMdtm95VV1zWupCxueHxZwef1xa8F0tdsPLb5sjgGbWIwM2JK2Gs562C0wv0tWlN7
	l1+JkNE/EKl15cjvdcnHBY+ohMm23jp3ULb/99LC+26pk7grevsjblw9oMRSnJFoqMVcVJwI
	AJOJHXZWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jAV2hW2sDDC6e57S4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGaembGEueC1Y8W/Ra8YG
	xql8XYycHBICJhJfZ69mhbDFJC7cW8/WxcjFISSwiFGi+fJeKGcpk8SOW7vAqtgEtCT2v7jB
	BmKLCMhJvF77lwnEZhaoldh3rQmsRlggVWLl5NssIDaLgKrEvqMbwOK8Aq4Si79MZYfYpiDR
	uuwQ+wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgkP2mfQOxlUNFocYBTgYlXh4
	MwzWBgixJpYVV+YeYpTgYFYS4V1UABTiTUmsrEotyo8vKs1JLT7E6AO0fSKzlGhyPjCe8kri
	DY1NzIwsjcyMTcyNjXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg1OKoLe8I3/pkm+Tq
	ZW7z/iyV1fMWuRCjH/z5yAuOxy5VVRUq5mu2nRLzy0jcpM0rfy5F/Yir/5VPzn88W1Z9EfSQ
	9eZpmBstfDPf5MkJ7sjFd1IYXMudS6Pvp305bD4xKKujefG9N/8+zmY2PbM48MqZi7vf56pP
	C9//WD76Iu9jhwezJKbJKLEUZyQaajEXFScCAEPBhd2GAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug related to checking fully charged state of battery
when charger-manager call is_full_charged() function. After reading
property of charger/fuel-gauge through power_supply API, val.intval is
more than 1. So, is_full_charged() function always return true. If true,
battery means fully charged state.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c |   33 +++++++++++++--------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 8a0aca6..ee039b9 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -239,44 +239,37 @@ static bool is_full_charged(struct charger_manager *cm)
 	int uV;
 
 	/* If there is no battery, it cannot be charged */
-	if (!is_batt_present(cm)) {
-		val.intval = 0;
-		goto out;
-	}
+	if (!is_batt_present(cm))
+		return false;
 
 	if (cm->fuel_gauge && desc->fullbatt_full_capacity > 0) {
+		val.intval = 0;
+
 		/* Not full if capacity of fuel gauge isn't full */
 		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
 				POWER_SUPPLY_PROP_CHARGE_FULL, &val);
-		if (!ret && val.intval > desc->fullbatt_full_capacity) {
-			val.intval = 1;
-			goto out;
-		}
+		if (!ret && val.intval > desc->fullbatt_full_capacity)
+			return true;
 	}
 
 	/* Full, if it's over the fullbatt voltage */
 	if (desc->fullbatt_uV > 0) {
 		ret = get_batt_uV(cm, &uV);
-		if (!ret && uV >= desc->fullbatt_uV) {
-			val.intval = 1;
-			goto out;
-		}
+		if (!ret && uV >= desc->fullbatt_uV)
+			return true;
 	}
 
 	/* Full, if the capacity is more than fullbatt_soc */
 	if (cm->fuel_gauge && desc->fullbatt_soc > 0) {
+		val.intval = 0;
+
 		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
 				POWER_SUPPLY_PROP_CAPACITY, &val);
-		if (!ret && val.intval >= desc->fullbatt_soc) {
-			val.intval = 1;
-			goto out;
-		}
+		if (!ret && val.intval >= desc->fullbatt_soc)
+			return true;
 	}
 
-	val.intval = 0;
-
-out:
-	return val.intval ? true : false;
+	return false;
 }
 
 /**
-- 
1.7.0.4

