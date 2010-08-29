Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0H2PGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:06:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61224 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab0H2PGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gd+9mXv/gBsCe+JjWzCfVfJEfy1tYFuLmC1btDlN34dQ3yZPIwwjHi/JZpXlAQeqV7
         Z9KoUz7tc5t6fl06pYQ3GmRJFHodX0Donu+LBeueR9hHhgqITQXwMZvj7PUvMVZf9zLV
         I+JZy7X6NxxsrA2W62UZvv3gROFfxYG7CD85w=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl, tj@kernel.org,
        oleg@redhat.com
Subject: [RFC PATCH 5/6] hrtimer: record more real start_site for timer_stats
Date: Sun, 29 Aug 2010 23:05:08 +0800
Message-Id: <1283094309-6635-6-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
References: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Most call sites are showed as hrtimer_start_range_ns(). This gives us
not enough info about the start_site. Then call
timer_stats_hrtimer_set_start_info() in hrtimer_start*() to
record the upper caller.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2b79ab4..1820a83 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1014,6 +1014,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		unsigned long delta_ns, const enum hrtimer_mode mode)
 {
+	timer_stats_hrtimer_set_start_info(timer);
 	return __hrtimer_start_range_ns(timer, tim, delta_ns, mode, 1);
 }
 EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
@@ -1031,6 +1032,7 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
 int
 hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 {
+	timer_stats_hrtimer_set_start_info(timer);
 	return __hrtimer_start_range_ns(timer, tim, 0, mode, 1);
 }
 EXPORT_SYMBOL_GPL(hrtimer_start);
-- 
1.7.0.4

