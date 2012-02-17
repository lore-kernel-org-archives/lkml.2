Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2BQVVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:21:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62525 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2BQVVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:21:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.196.234 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 17 Feb 2012 13:20:31 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH next] rcu: stop spurious warnings from
 synchronize_sched_expedited
Message-ID: <alpine.LSU.2.00.1202171318010.5994@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

synchronize_sched_expedited() is spamming CONFIG_DEBUG_PREEMPT=y
users with an unintended warning from the cpu_is_offline() check:
use raw_smp_processor_id() instead of smp_processor_id() there.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 kernel/rcutree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next/kernel/rcutree.c	2012-02-17 08:02:15.680065066 -0800
+++ linux/kernel/rcutree.c	2012-02-17 10:41:18.764003566 -0800
@@ -2014,7 +2014,7 @@ void synchronize_sched_expedited(void)
 	/* Note that atomic_inc_return() implies full memory barrier. */
 	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
 	get_online_cpus();
-	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
+	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
 
 	/*
 	 * Each pass through the following loop attempts to force a
