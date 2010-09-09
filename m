Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0IIWCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:02:00 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51417 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab0IIWB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:01:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/1] softirq: improve preempt count error message
Date: Fri, 10 Sep 2010 00:01:17 +0200
Message-Id: <1284069677-16215-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* add a space after the action
* print function name instead of address of action (%p->%pf)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/softirq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index be3ec11..60c864f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -219,8 +219,8 @@ restart:
 			h->action(h);
 			trace_softirq_exit(h, softirq_vec);
 			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %td %s %p"
-				       "with preempt_count %08x,"
+				printk(KERN_ERR "huh, entered softirq %td %s "
+				       "%pf with preempt_count %08x,"
 				       " exited with %08x?\n", h - softirq_vec,
 				       softirq_to_name[h - softirq_vec],
 				       h->action, prev_count, preempt_count());
-- 
1.7.2.2


