Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1CWNte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:49:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab1CWNtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:49:32 -0400
Date: Wed, 23 Mar 2011 13:48:44 GMT
From: tip-bot for Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110323123828.GB4244@swordfish.minsk.epam.com>
References: <20110323123828.GB4244@swordfish.minsk.epam.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Remove unused 'factor' variable from lockdep_stats_show()
Message-ID: <tip-dec2960827c85253d76938dbfa909df3be34958b@git.kernel.org>
Git-Commit-ID: dec2960827c85253d76938dbfa909df3be34958b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Mar 2011 13:48:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dec2960827c85253d76938dbfa909df3be34958b
Gitweb:     http://git.kernel.org/tip/dec2960827c85253d76938dbfa909df3be34958b
Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
AuthorDate: Wed, 23 Mar 2011 14:38:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Mar 2011 13:54:47 +0100

lockdep: Remove unused 'factor' variable from lockdep_stats_show()

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110323123828.GB4244@swordfish.minsk.epam.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep_proc.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 1969d2f..71edd2f 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -225,7 +225,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		      nr_irq_read_safe = 0, nr_irq_read_unsafe = 0,
 		      nr_softirq_read_safe = 0, nr_softirq_read_unsafe = 0,
 		      nr_hardirq_read_safe = 0, nr_hardirq_read_unsafe = 0,
-		      sum_forward_deps = 0, factor = 0;
+		      sum_forward_deps = 0;
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
 
@@ -283,13 +283,6 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_hardirq_unsafe * nr_hardirq_safe +
 			nr_list_entries);
 
-	/*
-	 * Estimated factor between direct and indirect
-	 * dependencies:
-	 */
-	if (nr_list_entries)
-		factor = sum_forward_deps / nr_list_entries;
-
 #ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " dependency chains:             %11lu [max: %lu]\n",
 			nr_lock_chains, MAX_LOCKDEP_CHAINS);
