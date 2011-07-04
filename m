Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1GDXSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:18:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48523 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1GDXR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:17:57 -0400
Subject: [PATCH 3/4] async: warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Viresh Kumar <viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 02:17:54 +0300
Message-ID: <1309821474.4527.8.camel@vitaliy-Vostro-1400>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 320556649fca1e021e50570832358cb5fc3e7fcf Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Tue, 5 Jul 2011 02:06:41 +0300
Subject: [PATCH 3/4] async: warning corrections
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kernel/async.c: In function ‘async_synchronize_cookie_domain’:
kernel/async.c:270:10: warning: ‘starttime.tv64’ may be used uninitialized in this function
kernel/async.c: In function ‘async_run_entry_fn’:
kernel/async.c:122:10: warning: ‘calltime.tv64’ may be used uninitialized in this function

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
1.7.4.1



