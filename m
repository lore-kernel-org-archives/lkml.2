Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1FJNa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:30:58 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50772 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab1FJNad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Pju2DG/ROOqVxbkI8aWJ1GHIz4Kuf/4+uhhfE7FhSg5Mlw0PbiK0bPLRRTxmcAHh92
         aiDl1lythvMhwEHSQl68t9INun9vDza/zlX3A5IZJUbmQKuQBhi9bCUE9tlagTqYmaAm
         FNWYjyuTNsNWBOuMdiojFLzXIfzdjhYWrIM4U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] sched: Make sleeping inside spinlock detection working in !CONFIG_PREEMPT
Date: Fri, 10 Jun 2011 15:30:21 +0200
Message-Id: <1307712622-11104-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select CONFIG_PREEMPT_COUNT when we enable the sleeping inside
spinlock detection, so that the preempt offset gets correctly
incremented/decremented from preempt_disable()/preempt_enable().

This makes the preempt count eventually working in !CONFIG_PREEMPT
when that debug option is set and thus fixes the detection of explicit
preemption disabled sections under such config. Code that sleeps
in explicitly preempt disabled section can be finally spotted
in non-preemptible kernels.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 lib/Kconfig.debug |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28afa4c..a7dd7b5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -650,6 +650,7 @@ config TRACE_IRQFLAGS
 
 config DEBUG_SPINLOCK_SLEEP
 	bool "Spinlock debugging: sleep-inside-spinlock checking"
+	select PREEMPT_COUNT
 	depends on DEBUG_KERNEL
 	help
 	  If you say Y here, various routines which may sleep will become very
-- 
1.7.5.4

