Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab1GEM5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:57:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:59539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab1GEM5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:57:22 -0400
Date: Tue, 5 Jul 2011 12:56:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-m4onxn0sxnyn5iz9o88eskc3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, ncrao@google.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, alex.shi@intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de, tom.leiming@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ncrao@google.com,
        torvalds@linux-foundation.org, efault@gmx.de, alex.shi@intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de, tom.leiming@gmail.com,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Disable (revert) SCHED_LOAD_SCALE increase
Git-Commit-ID: e4c2fb0d5776b58049d2556b456144a4db3fe5a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:56:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4c2fb0d5776b58049d2556b456144a4db3fe5a9
Gitweb:     http://git.kernel.org/tip/e4c2fb0d5776b58049d2556b456144a4db3fe5a9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Jul 2011 10:56:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 Jul 2011 11:28:18 +0200

sched: Disable (revert) SCHED_LOAD_SCALE increase

Alex reported that commit c8b281161df ("sched: Increase
SCHED_LOAD_SCALE resolution") caused a power usage regression
under light load as it increases the number of load-balance
operations and keeps idle cpus from staying idle.

Time has run out to find the root cause for this release so
disable the feature for v3.0 until we can figure out what
causes the problem.

Reported-by: "Alex, Shi" <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-m4onxn0sxnyn5iz9o88eskc3@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a837b20..496770a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -808,7 +808,7 @@ enum cpu_idle_type {
  * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
  * increased costs.
  */
-#if BITS_PER_LONG > 32
+#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */
 # define SCHED_LOAD_RESOLUTION	10
 # define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
 # define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
