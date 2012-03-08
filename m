Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab2CHUNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:13:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43536 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2CHUNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:13:20 -0500
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        John Kacur <jkacur@redhat.com>, Clark Williams <williams@redhat.com>
Subject: [PATCH-RT] preempt.h: Fix implicit declaration of 'preempt_check_resched_rt'
Date: Thu,  8 Mar 2012 21:13:11 +0100
Message-Id: <1331237591-4406-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a non-preempt kernel where CONFIG_PREEMPT_COUNT is not
defined the following build break occurs.

/home/jkacur/linux-rt/block/blk-softirq.c: In function ‘trigger_softirq’:
/home/jkacur/linux-rt/block/blk-softirq.c:54: error: implicit declaration of function ‘preempt_check_resched_rt’
make[2]: *** [block/blk-softirq.o] Error 1
make[1]: *** [block/blk-softirq.o] Error 2
make: *** [sub-make] Error 2

This patch fixes the build error by adding a define to the
!CONFIG_PREEMPT_COUNT section.

Signed-off-by: Clark Williams <williams@redhat.com>
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/preempt.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index fa40695..58d8982 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -107,6 +107,7 @@ do { \
 #define preempt_disable_notrace()		do { } while (0)
 #define preempt_enable_no_resched_notrace()	do { } while (0)
 #define preempt_enable_notrace()		do { } while (0)
+#define preempt_check_resched_rt()	do { } while (0)
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
-- 
1.7.2.3

