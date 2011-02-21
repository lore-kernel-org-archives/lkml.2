Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1BUX4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:56:01 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53374 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1BUX4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:56:00 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 07/10] RTC: Remove UIE and PIE information from the sa1100 driver proc.
Date: Mon, 21 Feb 2011 15:55:35 -0800
Message-Id: <1298332538-31216-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

This patch removes the UIE and PIE information that is now being
supplied directly in the generic RTC code.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-sa1100.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index e52e1f5..9ece7be 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -340,15 +340,8 @@ static int sa1100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int sa1100_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	struct rtc_device *rtc = (struct rtc_device *)dev;
-
-	seq_printf(seq, "trim/divider\t: 0x%08x\n", (u32) RTTR);
-	seq_printf(seq, "update_IRQ\t: %s\n",
-			(RTSR & RTSR_HZE) ? "yes" : "no");
-	seq_printf(seq, "periodic_IRQ\t: %s\n",
-			(OIER & OIER_E1) ? "yes" : "no");
-	seq_printf(seq, "periodic_freq\t: %d\n", rtc->irq_freq);
-	seq_printf(seq, "RTSR\t\t: 0x%08x\n", (u32)RTSR);
+	seq_printf(seq, "trim/divider\t\t: 0x%08x\n", (u32) RTTR);
+	seq_printf(seq, "RTSR\t\t\t: 0x%08x\n", (u32)RTSR);
 
 	return 0;
 }
-- 
1.7.3.2.146.gca209

