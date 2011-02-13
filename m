Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1BMBej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 20:34:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:36990 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab1BMBef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 20:34:35 -0500
Date: Sun, 13 Feb 2011 01:34:06 GMT
From: tip-bot for Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, johnstul@us.ibm.com,
        drosenberg@vsecurity.com, kees.cook@canonical.com,
        eugeneteo@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: drosenberg@vsecurity.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        torvalds@linux-foundation.org, kees.cook@canonical.com,
        eugeneteo@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110212032125.GA23571@outflux.net>
References: <20110212032125.GA23571@outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timer debug: Hide kernel addresses via %pK in /proc/timer_list
Message-ID: <tip-f590308536db432e4747f562b29e5858123938e9@git.kernel.org>
Git-Commit-ID: f590308536db432e4747f562b29e5858123938e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Feb 2011 01:34:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f590308536db432e4747f562b29e5858123938e9
Gitweb:     http://git.kernel.org/tip/f590308536db432e4747f562b29e5858123938e9
Author:     Kees Cook <kees.cook@canonical.com>
AuthorDate: Fri, 11 Feb 2011 19:21:25 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 12 Feb 2011 14:11:56 +0100

timer debug: Hide kernel addresses via %pK in /proc/timer_list

In the continuing effort to avoid kernel addresses leaking to
unprivileged users, this patch switches to %pK for
/proc/timer_list reporting.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Eugene Teo <eugeneteo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20110212032125.GA23571@outflux.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/timer_list.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 32a19f9..3258455 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -41,7 +41,7 @@ static void print_name_offset(struct seq_file *m, void *sym)
 	char symname[KSYM_NAME_LEN];
 
 	if (lookup_symbol_name((unsigned long)sym, symname) < 0)
-		SEQ_printf(m, "<%p>", sym);
+		SEQ_printf(m, "<%pK>", sym);
 	else
 		SEQ_printf(m, "%s", symname);
 }
@@ -112,7 +112,7 @@ next_one:
 static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
-	SEQ_printf(m, "  .base:       %p\n", base);
+	SEQ_printf(m, "  .base:       %pK\n", base);
 	SEQ_printf(m, "  .index:      %d\n",
 			base->index);
 	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
