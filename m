Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2HVAbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 20:31:35 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37636 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab2HVAbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 20:31:15 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/4] time: Fix casting issue in timekeeping_forward_now
Date: Tue, 21 Aug 2012 20:30:47 -0400
Message-Id: <1345595449-34965-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082200-3534-0000-0000-00000BBA96FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Schwab <schwab@linux-m68k.org>

arch_gettimeoffset returns a u32 value which when shifted by tk->shift can
overflow.  Cast it to u64 first.

This issue was introduced with 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 258164a..1dbf80e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -277,7 +277,7 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 	tk->xtime_nsec += cycle_delta * tk->mult;
 
 	/* If arch requires, add in gettimeoffset() */
-	tk->xtime_nsec += arch_gettimeoffset() << tk->shift;
+	tk->xtime_nsec += (u64)arch_gettimeoffset() << tk->shift;
 
 	tk_normalize_xtime(tk);
 
-- 
1.7.9.5

