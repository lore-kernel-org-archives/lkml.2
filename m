Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1CRI0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:26:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50231 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab1CRI0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:26:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] rtc-bfin: add missing "return 0" in new alarm func
Date: Fri, 18 Mar 2011 04:26:24 -0400
Message-Id: <1300436784-26543-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new bfin_rtc_alarm_irq_enable function forgot to add a "return 0" to
the end leading to the build warning:
	drivers/rtc/rtc-bfin.c: In function 'bfin_rtc_alarm_irq_enable':
	drivers/rtc/rtc-bfin.c:253: warning: control reaches end of non-void function

CC: stable@kernel.org
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/rtc/rtc-bfin.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 17971d9..0e61e2d 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -276,6 +276,8 @@ static int bfin_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 		bfin_rtc_int_set_alarm(rtc);
 	else
 		bfin_rtc_int_clear(~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+
+	return 0;
 }
 
 static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)
-- 
1.7.4.1

