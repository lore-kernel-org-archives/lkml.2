Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab1BUXz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:55:56 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43790 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab1BUXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:55:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 06/10] RTC: Include information about UIE and PIE in RTC driver proc.
Date: Mon, 21 Feb 2011 15:55:34 -0800
Message-Id: <1298332538-31216-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

Generic RTC code is always able to provide the necessary information
about update and periodic interrupts. This patch add such information to
the proc interface.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-proc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index 242bbf8..0a59fda 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -69,6 +69,14 @@ static int rtc_proc_show(struct seq_file *seq, void *offset)
 				alrm.enabled ? "yes" : "no");
 		seq_printf(seq, "alrm_pending\t: %s\n",
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
 
 	seq_printf(seq, "24hr\t\t: yes\n");
-- 
1.7.3.2.146.gca209

