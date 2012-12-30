Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2L3S4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 13:56:31 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:58929 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2L3S4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 13:56:30 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        rtc-linux@googlegroups.com, Tony Prisk <linux@prisktech.co.nz>,
        Edgar Toernig <froese@gmx.de>
Subject: [PATCH] rtc: vt8500: Fix year field in vt8500_rtc_set_time
Date: Mon, 31 Dec 2012 07:56:33 +1300
Message-Id: <1356893793-29537-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

year field is incorrectly masked when setting the date. If the year
is beyond 2099, the year field will be incorrectly updated in hardware.

This patch masks the year field correctly.

Signed-off-by: Edgar Toernig <froese@gmx.de>
Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
Patch based on 3.8-rc1

 drivers/rtc/rtc-vt8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index 14e2d8c..37b42a4 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -137,7 +137,7 @@ static int vt8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		return -EINVAL;
 	}
 
-	writel((bin2bcd(tm->tm_year - 100) << DATE_YEAR_S)
+	writel((bin2bcd(tm->tm_year % 100) << DATE_YEAR_S)
 		| (bin2bcd(tm->tm_mon) << DATE_MONTH_S)
 		| (bin2bcd(tm->tm_mday)),
 		vt8500_rtc->regbase + VT8500_RTC_DS);
-- 
1.7.9.5

