Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1KMAal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 19:30:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62978 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1KMAak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 19:30:40 -0500
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH] Compile error with allmodconfig and CONFIG_PREEMPT_RT_FULL=y
Date: Sun, 13 Nov 2011 01:30:29 +0100
Message-Id: <1321144229-6108-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "in_serving_softirq" [net/sched/cls_cgroup.ko] undefined!

The above can be fixed by exporting in_serving_softirq

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/softirq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index e8756aa..026a283 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -447,6 +447,7 @@ int in_serving_softirq(void)
 	preempt_enable();
 	return res;
 }
+EXPORT_SYMBOL(in_serving_softirq);
 
 /*
  * Called with bh and local interrupts disabled. For full RT cpu must
-- 
1.7.2.3

