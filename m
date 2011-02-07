Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1BGVRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:17:10 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49315 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1BGVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:17:07 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk
Cc: john.stultz@linaro.org, tglx@linutronix.de, a.zummo@towertech.it,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH 1/4] RTC: Include information about UIE and PIE in RTC driver proc.
Date: Mon,  7 Feb 2011 19:16:05 -0200
Message-Id: <1297113368-27174-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic RTC code is always able to provide the necessary information
about update and periodic interrupts. This patch add such information to
the proc interface.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/rtc-proc.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index c086fc3..b4ecec0 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -30,15 +30,15 @@ static int rtc_proc_show(struct seq_file *seq, void *offset)
 	err = rtc_read_time(rtc, &tm);
 	if (err == 0) {
 		seq_printf(seq,
-			"rtc_time\t: %02d:%02d:%02d\n"
-			"rtc_date\t: %04d-%02d-%02d\n",
+			"rtc_time\t\t: %02d:%02d:%02d\n"
+			"rtc_date\t\t: %04d-%02d-%02d\n",
 			tm.tm_hour, tm.tm_min, tm.tm_sec,
 			tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday);
 	}
 
 	err = rtc_read_alarm(rtc, &alrm);
 	if (err == 0) {
-		seq_printf(seq, "alrm_time\t: ");
+		seq_printf(seq, "alrm_time\t\t: ");
 		if ((unsigned int)alrm.time.tm_hour <= 24)
 			seq_printf(seq, "%02d:", alrm.time.tm_hour);
 		else
@@ -52,7 +52,7 @@ static int rtc_proc_show(struct seq_file *seq, void *offset)
 		else
 			seq_printf(seq, "**\n");
 
-		seq_printf(seq, "alrm_date\t: ");
+		seq_printf(seq, "alrm_date\t\t: ");
 		if ((unsigned int)alrm.time.tm_year <= 200)
 			seq_printf(seq, "%04d-", alrm.time.tm_year + 1900);
 		else
@@ -65,13 +65,21 @@ static int rtc_proc_show(struct seq_file *seq, void *offset)
 			seq_printf(seq, "%02d\n", alrm.time.tm_mday);
 		else
 			seq_printf(seq, "**\n");
-		seq_printf(seq, "alarm_IRQ\t: %s\n",
+		seq_printf(seq, "alarm IRQ enabled\t: %s\n",
 				alrm.enabled ? "yes" : "no");
-		seq_printf(seq, "alrm_pending\t: %s\n",
+		seq_printf(seq, "alarm pending\t\t: %s\n",
 				alrm.pending ? "yes" : "no");
+		seq_printf(seq, "update IRQ enabled\t: %s\n",
+			(rtc->uie_rtctimer.enabled) ? "yes" : "no");
+		seq_printf(seq, "periodic IRQ enabled\t: %s\n",
+			(rtc->pie_enabled) ? "yes" : "no");
+		seq_printf(seq, "periodic IRQ frequency\t: %d\n",
+			rtc->irq_freq);
+		seq_printf(seq, "max user IRQ frequency\t: %d\n",
+			rtc->max_user_freq);
 	}
 
-	seq_printf(seq, "24hr\t\t: yes\n");
+	seq_printf(seq, "24hr\t\t\t: yes\n");
 
 	if (ops->proc)
 		ops->proc(rtc->dev.parent, seq);
-- 
1.7.3.4

