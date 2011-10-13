Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1JMJTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:19:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58649 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1JMJTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:19:21 -0400
Date: Thu, 13 Oct 2011 17:19:09 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH -rt] harirq.h: Define softirq_count() as OUL to kill build
 warning
Message-ID: <20111013091909.GA32739@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/lockdep.c: In function ‘print_bad_irq_dependency’:
kernel/lockdep.c:1476:3: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 7 has type ‘unsigned int’
kernel/lockdep.c: In function ‘print_usage_bug’:
kernel/lockdep.c:2193:3: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 7 has type ‘unsigned int’

kernel/lockdep.i show this:
 printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
  curr->comm, task_pid_nr(curr),
  curr->hardirq_context, ((current_thread_info()->preempt_count) & (((1UL << (10))-1) << ((0 + 8) + 8))) >> ((0 + 8) + 8),
  curr->softirq_context, (0U) >> (0 + 8),
  curr->hardirqs_enabled,
  curr->softirqs_enabled);

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 include/linux/hardirq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index a3892c2..2711055 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -84,7 +84,7 @@
 # define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
 # define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
 #else
-# define softirq_count()	(0U)
+# define softirq_count()	(0UL)
 extern int in_serving_softirq(void);
 #endif
 
-- 
1.7.4.1

