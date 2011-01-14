Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1ANHOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:14:19 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54108 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250Ab1ANHOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:14:14 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] kernel/async.c: fixing compilation warnings
Date: Fri, 14 Jan 2011 12:44:06 +0530
Message-ID: <1294989246-1621-1-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following compilation warnings:
270:10: warning: ‘starttime.tv64’ may be used uninitialized in this function
122:10: warning: ‘calltime.tv64’ may be used uninitialized in this function

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 kernel/async.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index cd9dbb9..9c06931 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -119,7 +119,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
-	ktime_t calltime, delta, rettime;
+	ktime_t calltime = {0}, delta, rettime;
 
 	/* 1) move self to the running queue */
 	spin_lock_irqsave(&async_lock, flags);
@@ -267,7 +267,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 void async_synchronize_cookie_domain(async_cookie_t cookie,
 				     struct list_head *running)
 {
-	ktime_t starttime, delta, endtime;
+	ktime_t starttime = {0}, delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk("async_waiting @ %i\n", task_pid_nr(current));
-- 
1.7.2.2

