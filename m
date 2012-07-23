Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2GWUXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:23:02 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59682 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab2GWUXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:23:00 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] time: Fix casting issue in tk_set_xtime and tk_xtime_add
Date: Mon, 23 Jul 2012 16:22:37 -0400
Message-Id: <1343074957-16541-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072320-7182-0000-0000-0000020F1B70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing casts that can cause boot problems on 32bit systems,
most easily observed with Xen systems. This issue was introduced
w/ 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f045cc5..cf364db 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -108,13 +108,13 @@ static struct timespec tk_xtime(struct timekeeper *tk)
 static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
 {
 	tk->xtime_sec = ts->tv_sec;
-	tk->xtime_nsec = ts->tv_nsec << tk->shift;
+	tk->xtime_nsec = (u64)ts->tv_nsec << tk->shift;
 }
 
 static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
 {
 	tk->xtime_sec += ts->tv_sec;
-	tk->xtime_nsec += ts->tv_nsec << tk->shift;
+	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
 }
 
 /**
-- 
1.7.9.5

