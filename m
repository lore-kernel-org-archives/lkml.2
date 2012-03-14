Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504Ab2CNBFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:05:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab2CNBFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:05:11 -0400
Date: Wed, 14 Mar 2012 05:05:09 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Subject: [PATCH 3/6] ab8500_fg: Get rid of 'struct v_to_cap'
Message-ID: <20120314010509.GC10798@oksana.dev.rtsoft.ru>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct is duplicated, plus when used it causes the following
warnings:

  CHECK   drivers/power/ab8500_fg.c
ab8500_fg.c:818:13: warning: incorrect type in assignment (different base types)
ab8500_fg.c:818:13:    expected struct v_to_cap *tbl
ab8500_fg.c:818:13:    got struct abx500_v_to_cap *const v_to_cap_tbl
  CC      drivers/power/ab8500_fg.o
ab8500_fg.c: In function 'ab8500_fg_volt_to_capacity':
ab8500_fg.c:818:6: warning: assignment from incompatible pointer type [enabled by default]

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/power/ab8500_fg.c            |    2 +-
 include/linux/mfd/abx500/ab8500-bm.h |   10 ----------
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 41ccb70..180c21a 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -812,7 +812,7 @@ static int ab8500_fg_bat_voltage(struct ab8500_fg *di)
 static int ab8500_fg_volt_to_capacity(struct ab8500_fg *di, int voltage)
 {
 	int i, tbl_size;
-	struct v_to_cap *tbl;
+	struct abx500_v_to_cap *tbl;
 	int cap = 0;
 
 	tbl = di->bat->bat_type[di->bat->batt_id].v_to_cap_tbl,
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index f61b7b9..44d8620 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -255,16 +255,6 @@ struct batres_vs_temp {
 	int resist;
 };
 
-/**
- * struct v_to_cap - Table for translating voltage to capacity
- * @voltage:		Voltage in mV
- * @capacity:		Capacity in percent
- */
-struct v_to_cap {
-	int voltage;
-	int capacity;
-};
-
 /* Forward declaration */
 struct ab8500_fg;
 
-- 
1.7.9

