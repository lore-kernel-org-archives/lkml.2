Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1GGP0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:26:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52179 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab1GGP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:26:51 -0400
Subject: [TRIVIAL][PATCH v2 1/2] async: uninitialized warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Vitaliy Ivanov <vitaliy@toroki.com>, LKML <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, vitalivanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 18:28:29 +0300
Message-ID: <1310052509.3528.42.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f1b40c42cf269366a97775852234641cbf966f5a Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Thu, 7 Jul 2011 14:10:40 +0300
Subject: [PATCH 1/2] async: uninitialized warning corrections

The variables here are really not used uninitialized.

kernel/async.c: In function 'async_synchronize_cookie_domain':
kernel/async.c:270:10: warning: 'starttime.tv64' may be used uninitialized in this function
kernel/async.c: In function 'async_run_entry_fn':
kernel/async.c:122:10: warning: 'calltime.tv64' may be used uninitialized in this function

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 kernel/async.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index cd9dbb9..3ff777b 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -119,7 +119,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
-	ktime_t calltime, delta, rettime;
+	ktime_t uninitialized_var(calltime), delta, rettime;
 
 	/* 1) move self to the running queue */
 	spin_lock_irqsave(&async_lock, flags);
@@ -267,7 +267,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 void async_synchronize_cookie_domain(async_cookie_t cookie,
 				     struct list_head *running)
 {
-	ktime_t starttime, delta, endtime;
+	ktime_t uninitialized_var(starttime), delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk("async_waiting @ %i\n", task_pid_nr(current));
-- 
1.7.0.4



