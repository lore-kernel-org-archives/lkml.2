Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2ASKNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:13:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13212 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab2ASKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:13:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Jan 2012 02:12:44 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: swarren@nvidia.com, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 3/3] rtc: twl: Return correct RTC event from ISR
Date: Thu, 19 Jan 2012 15:42:29 +0530
Message-Id: <1326967949-8248-4-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1326967949-8248-1-git-send-email-vbyravarasu@nvidia.com>
References: <1326967949-8248-1-git-send-email-vbyravarasu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venu Byravarasu <vbyravarasu@nvidia.com>

Following changes are made as part of this change:
1. As TWL RTC supports periodic interrupt, the correct event
should be RTC_PF instead of RTC_UF.
2. No need to initialize variable "events" to 0 & then OR it
with the event values. Hence fixing it.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/rtc/rtc-twl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 1c85443..a0236a0 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -357,7 +357,7 @@ out:
 
 static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 {
-	unsigned long events = 0;
+	unsigned long events;
 	int ret = IRQ_NONE;
 	int res;
 	u8 rd_reg;
@@ -372,9 +372,9 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	 * by reading RTS_INTERRUPTS_REGISTER[IT_TIMER,IT_ALARM]
 	 */
 	if (rd_reg & BIT_RTC_STATUS_REG_ALARM_M)
-		events |= RTC_IRQF | RTC_AF;
+		events = RTC_IRQF | RTC_AF;
 	else
-		events |= RTC_IRQF | RTC_UF;
+		events = RTC_IRQF | RTC_PF;
 
 	res = twl_rtc_write_u8(BIT_RTC_STATUS_REG_ALARM_M,
 				   REG_RTC_STATUS_REG);
-- 
1.7.1.1

