Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1BGVRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:17:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34309 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1BGVRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:17:10 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk
Cc: john.stultz@linaro.org, tglx@linutronix.de, a.zummo@towertech.it,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH 2/4] RTC: Remove UIE and PIE information from the sa1100 driver proc.
Date: Mon,  7 Feb 2011 19:16:06 -0200
Message-Id: <1297113368-27174-3-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the UIE and PIE information that is now being
supplied directly in the generic RTC code.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/rtc-sa1100.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index df1804f..6c8c74a 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -358,15 +358,8 @@ static int sa1100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
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
1.7.3.4

