Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab2HVIvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:51:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40022 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab2HVIu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:50:58 -0400
Date: Wed, 22 Aug 2012 01:50:13 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-784ffcbb96c3a97b4c64fd48b1dfe12ef3fcbcda@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, schwab@linux-m68k.org, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        schwab@linux-m68k.org, prarit@redhat.com
In-Reply-To: <1345595449-34965-2-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-2-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time:
  Ensure we normalize the timekeeper in tk_xtime_add
Git-Commit-ID: 784ffcbb96c3a97b4c64fd48b1dfe12ef3fcbcda
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 01:50:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  784ffcbb96c3a97b4c64fd48b1dfe12ef3fcbcda
Gitweb:     http://git.kernel.org/tip/784ffcbb96c3a97b4c64fd48b1dfe12ef3fcbcda
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Tue, 21 Aug 2012 20:30:46 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Aug 2012 10:42:12 +0200

time: Ensure we normalize the timekeeper in tk_xtime_add

Andreas noticed problems with resume on specific hardware after commit
1e75fa8b (time: Condense timekeeper.xtime into xtime_sec) combined
with commit b44d50dca (time: Fix casting issue in tk_set_xtime and
tk_xtime_add)

After some digging I realized we aren't normalizing the timekeeper
after the add. Add the missing normalize call.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Tested-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1345595449-34965-2-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
