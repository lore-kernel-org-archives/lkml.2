Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1BBV67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:58:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:50534 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab1BBV66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:58:58 -0500
Date: Wed, 2 Feb 2011 21:58:40 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.422446502@linutronix.de>
References: <20110201134418.422446502@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-cpu-timers: Remove the stub nanosleep functions
Message-ID: <tip-79c9da0d0539fb341a1b48a2a5a23d974726de90@git.kernel.org>
Git-Commit-ID: 79c9da0d0539fb341a1b48a2a5a23d974726de90
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:58:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79c9da0d0539fb341a1b48a2a5a23d974726de90
Gitweb:     http://git.kernel.org/tip/79c9da0d0539fb341a1b48a2a5a23d974726de90
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:14 +0100

posix-cpu-timers: Remove the stub nanosleep functions

CLOCK_THREAD_CPUTIME_ID implements stub functions for nanosleep and
nanosleep_restart, which return -EINVAL. That return value is
wrong. The correct return value is -ENOTSUP.

Remove the stubs and let the new dispatch code return the correct
error code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.422446502@linutronix.de>
---
 kernel/posix-cpu-timers.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9e617b0..8dc4cd7 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1586,15 +1586,6 @@ static int thread_cpu_timer_create(struct k_itimer *timer)
 	timer->it_clock = THREAD_CLOCK;
 	return posix_cpu_timer_create(timer);
 }
-static int thread_cpu_nsleep(const clockid_t which_clock, int flags,
-			      struct timespec *rqtp, struct timespec __user *rmtp)
-{
-	return -EINVAL;
-}
-static long thread_cpu_nsleep_restart(struct restart_block *restart_block)
-{
-	return -EINVAL;
-}
 
 struct k_clock clock_posix_cpu = {
 	.clock_getres	= posix_cpu_clock_getres,
@@ -1623,8 +1614,6 @@ static __init int init_posix_cpu_timers(void)
 		.clock_get	= thread_cpu_clock_get,
 		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= thread_cpu_timer_create,
-		.nsleep		= thread_cpu_nsleep,
-		.nsleep_restart	= thread_cpu_nsleep_restart,
 	};
 	struct timespec ts;
 
