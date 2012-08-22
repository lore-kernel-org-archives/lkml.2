Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2HVAb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 20:31:28 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41403 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2HVAbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 20:31:02 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 1/4] time: Ensure we normalize the timekeeper in tk_xtime_add
Date: Tue, 21 Aug 2012 20:30:46 -0400
Message-Id: <1345595449-34965-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082200-6078-0000-0000-00000E833257
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas noticed problems with resume on specific hardware
after commit 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
combined with commit b44d50dcacea0d485ca2ff9140f8cc28ee22f28d

After some digging I realized we aren't normalizing
the timekeeper after the add. This patch to correct this
resolved the issue.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Tested-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 898bef0..258164a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -115,6 +115,7 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
 {
 	tk->xtime_sec += ts->tv_sec;
 	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
+	tk_normalize_xtime(tk);
 }
 
 static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
-- 
1.7.9.5

