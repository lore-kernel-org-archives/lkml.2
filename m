Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab2KVT4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:56:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28352 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab2KVTy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:54:27 -0500
X-AuditID: cbfee61b-b7f616d00000319b-0a-50add7db3c51
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/3] charger-manager: Fix bug related to checking fully charged
 state of battery
Date: Thu, 22 Nov 2012 16:44:15 +0900
Message-id: <1353570255-18954-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zLd3b19cGGFxYwGFxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyTk3ZwlzwWrDi36LXjA2MU/m6GDk5JARMJPYfWMcOYYtJXLi3
	ng3EFhJYxijxbLIHTM2+d3NZuhi5gOLTGSWOHLrHDuEsZZK4fmA/WDebgJbE/hc3wLpFBOQk
	Xq/9ywRiMwvUSuy71sQKYgsLJElsWH6GBcRmEVCV2DH/I1gNr4CrxJSTe5khtilItC47xA5R
	IyDxbfIhoHoOoLisxKYDUCU72CSWdvtA2JISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRkhASe9gXNVgcYhRgINRiYc3w2BtgBBrYllxZe4hRgkOZiUR3kUFQCHelMTK
	qtSi/Pii0pzU4kOMPkCHTGSWEk3OBwZ7Xkm8obGBsaGhpaGZqaWpAQ5hJXHeZo+UACGB9MSS
	1OzU1ILUIphxTBycUg2Msw0+X0retrF2vsjTjRn18evXXYoLe9vJX5LpyOc+35Etaqv70v/e
	ZoqtrBtZtXWal3z+lftEYkPD9ewDm9W2VtudecituIC59EzeHPc4lXrz8Meqv310b/1QusvY
	4vUr5tnmqnfzs1XKJoh951nCGX5kQ9gRi74y8+nK/6/meDMdljSzKvqtxFKckWioxVxUnAgA
	8NiAjVUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQd1b19cGGJzcZGlxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM05N2cJc8Fqw4t+i14wN
	jFP5uhg5OSQETCT2vZvLAmGLSVy4t56ti5GLQ0hgOqPEkUP32CGcpUwS1w/sZwepYhPQktj/
	4gYbiC0iICfxeu1fJhCbWaBWYt+1JlYQW1ggSWLD8jNgU1kEVCV2zP8IVsMr4Cox5eReZoht
	ChKtyw6xT2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOGSfSe9gXNVgcYhRgINR
	iYc3w2BtgBBrYllxZe4hRgkOZiUR3kUFQCHelMTKqtSi/Pii0pzU4kOMPkDbJzJLiSbnA+Mp
	ryTe0NjEzMjSyMzYxNzYGIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQZGF1+FM79uhKb6
	Hp3YYJ3wJtzFK6b7fmzbzne6ZpVvm1zWGwpO7ozc9MiP69ZuvsWPb5y6Z7r/q/TB503/F68+
	I3+06nXnmdPuK1Z4mK3tm5oX8IJph/2DugUHs97OY9hw3vpcZKdJk5j+/klGZ5Y8+P770Xvn
	VzY2T28uFM8/+vqasN3ey6ay3UosxRmJhlrMRcWJAO2IT/CGAgAA
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

