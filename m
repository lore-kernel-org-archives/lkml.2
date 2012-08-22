Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab2HVIv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:51:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40041 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2HVIvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:51:50 -0400
Date: Wed, 22 Aug 2012 01:51:09 -0700
From: tip-bot for Andreas Schwab <schwab@linux-m68k.org>
Message-ID: <tip-85dc8f05c93c8105987de9d7e7cebf15a72ff4ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, schwab@linux-m68k.org, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        schwab@linux-m68k.org, prarit@redhat.com
In-Reply-To: <1345595449-34965-3-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-3-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time:
  Fix casting issue in timekeeping_forward_now
Git-Commit-ID: 85dc8f05c93c8105987de9d7e7cebf15a72ff4ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 01:51:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85dc8f05c93c8105987de9d7e7cebf15a72ff4ec
Gitweb:     http://git.kernel.org/tip/85dc8f05c93c8105987de9d7e7cebf15a72ff4ec
Author:     Andreas Schwab <schwab@linux-m68k.org>
AuthorDate: Tue, 21 Aug 2012 20:30:47 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Aug 2012 10:42:13 +0200

time: Fix casting issue in timekeeping_forward_now

arch_gettimeoffset returns a u32 value which when shifted by tk->shift
can overflow. This issue was introduced with 1e75fa8be (time: Condense
timekeeper.xtime into xtime_sec)

Cast it to u64 first.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1345595449-34965-3-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
 
