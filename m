Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2JITvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:51:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2JITvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:51:01 -0400
Date: Tue, 9 Oct 2012 12:50:46 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-5b3900cd409466c0070b234d941650685ad0c791@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20121009071823.GA19159@elgon.mountain>
References: <20121009071823.GA19159@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping:
  Cast raw_interval to u64 to avoid shift overflow
Git-Commit-ID: 5b3900cd409466c0070b234d941650685ad0c791
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 12:50:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b3900cd409466c0070b234d941650685ad0c791
Gitweb:     http://git.kernel.org/tip/5b3900cd409466c0070b234d941650685ad0c791
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Tue, 9 Oct 2012 10:18:23 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 9 Oct 2012 21:27:14 +0200

timekeeping: Cast raw_interval to u64 to avoid shift overflow

We fixed a bunch of integer overflows in timekeeping code during the 3.6
cycle.  I did an audit based on that and found this potential overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/20121009071823.GA19159@elgon.mountain
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 kernel/time/timekeeping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 16280ff..3eb3fc7c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1045,7 +1045,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	accumulate_nsecs_to_secs(tk);
 
 	/* Accumulate raw time */
-	raw_nsecs = tk->raw_interval << shift;
+	raw_nsecs = (u64)tk->raw_interval << shift;
 	raw_nsecs += tk->raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;
