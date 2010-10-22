Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0JVQVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:21:51 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:31069 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab0JVQVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:21:49 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: rtc: enable built-in RTC in Kconfig for at91sam9g45 family
Date: Fri, 22 Oct 2010 19:29:01 +0200
Message-Id: <1287768546-18513-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
References: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable built-in RTC IP in Kconfig and modify comments and help messages.
RTT as RTC is still available but should not be selected in common case.

Reported-by: Yegor Yefremov <yegor_sub1@visionsystems.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/rtc/Kconfig |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 48ca713..2785a0f 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -765,15 +765,15 @@ config RTC_DRV_AT32AP700X
 	  AT32AP700x family processors.
 
 config RTC_DRV_AT91RM9200
-	tristate "AT91RM9200 or AT91SAM9RL"
-	depends on ARCH_AT91RM9200 || ARCH_AT91SAM9RL
+	tristate "AT91RM9200 or some AT91SAM9 RTC"
+	depends on ARCH_AT91RM9200 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
 	help
 	  Driver for the internal RTC (Realtime Clock) module found on
-	  Atmel AT91RM9200's and AT91SAM9RL chips. On SAM9RL chips
+	  Atmel AT91RM9200's and some  AT91SAM9 chips. On AT91SAM9 chips
 	  this is powered by the backup power supply.
 
 config RTC_DRV_AT91SAM9
-	tristate "AT91SAM9x/AT91CAP9"
+	tristate "AT91SAM9x/AT91CAP9 RTT as RTC"
 	depends on ARCH_AT91 && !(ARCH_AT91RM9200 || ARCH_AT91X40)
 	help
 	  RTC driver for the Atmel AT91SAM9x and AT91CAP9 internal RTT
@@ -781,8 +781,8 @@ config RTC_DRV_AT91SAM9
 	  supply (such as a small coin cell battery), but do not need to
 	  be used as RTCs.
 
-	  (On AT91SAM9rl chips you probably want to use the dedicated RTC
-	  module and leave the RTT available for other uses.)
+	  (On AT91SAM9rl and AT91SAM9G45 chips you probably want to use the
+	  dedicated RTC module and leave the RTT available for other uses.)
 
 config RTC_DRV_AT91SAM9_RTT
 	int
-- 
1.7.3

