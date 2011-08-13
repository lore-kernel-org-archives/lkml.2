Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1HMEVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 00:21:48 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:57243 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab1HMEVp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 00:21:45 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Date: Fri, 12 Aug 2011 21:19:57 -0700
Subject: [PATCH] power: max17042: do not lose accuracy calculating
 current_now 
Thread-Topic: [PATCH] power: max17042: do not lose accuracy calculating
 current_now 
Thread-Index: AcxZcELl10m/TLTFQUqgTD9XyBUAOA==
Message-ID: <D8CE7665-74C6-4717-B377-EE17D3DA5F91@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PROP_CURRENT_NOW value is first divided then multiplied up
causing a lose of accuracy.  Use the same method as
PROP_CURRENT_AVG to do the calculation.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/power/max17042_battery.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 4245806..7b7762a 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -153,8 +153,7 @@ static int max17042_get_property(struct power_supply *psy,
 				val->intval++;
 				val->intval *= -1;
 			}
-			val->intval >>= 4;
-			val->intval *= 1000000 * 25 / chip->pdata->r_sns;
+			val->intval *= 1562500 / chip->pdata->r_sns;
 		} else {
 			return -EINVAL;
 		}
-- 
1.7.0.4


