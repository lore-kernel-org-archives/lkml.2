Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0H2PHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:07:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61224 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0H2PHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Jra9c0f+0oi0SRWd7tJGlHLyt2sAe9QoYj1h7wOsAr9dR+7JSqGYweOvhZMFNlIGQF
         vHdeWs5yVc1+hUrVQ/5x7U/N6CLt/Ki7GQ6xE82NlpvDmSWRDDS/4swxXConZf125jhq
         hSTi9Wc6KQBURjwtdCk37jqMXWXhAisJDHNXI=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl, tj@kernel.org,
        oleg@redhat.com
Subject: [RFC PATCH 6/6] timer_stats: make output more readable
Date: Sun, 29 Aug 2010 23:05:09 +0800
Message-Id: <1283094309-6635-7-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
References: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

When running timer_stats for a little long time, the output
will be not aligned anymore because the volume of sample count
and pid will expand.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/timer_stats.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 2f3b585..da85b3e 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -307,10 +307,10 @@ static int tstats_show(struct seq_file *m, void *v)
 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
  		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
-			seq_printf(m, "%4luD, %5d %-16s ",
+			seq_printf(m, "%10luD, %10d %-16s ",
 				entry->count, entry->pid, entry->comm);
 		} else {
-			seq_printf(m, " %4lu, %5d %-16s ",
+			seq_printf(m, " %10lu, %10d %-16s ",
 				entry->count, entry->pid, entry->comm);
 		}
 
-- 
1.7.0.4

