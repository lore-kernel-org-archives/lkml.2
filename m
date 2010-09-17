Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0IQJeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:34:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab0IQJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:34:07 -0400
Message-Id: <20100917093009.252867712@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 17 Sep 2010 11:28:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/6] percpu: {get,put}_cpu_ptr
References: <20100917092844.651383640@chello.nl>
Content-Disposition: inline; filename=percpu-get-cpu-ptr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to {get,put}_cpu_var() except for dynamically allocated per-cpu memory.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h
+++ linux-2.6/include/linux/percpu.h
@@ -39,6 +39,15 @@
 	preempt_enable();				\
 } while (0)
 
+#define get_cpu_ptr(var) ({				\
+	preempt_disable();				\
+	this_cpu_ptr(var); })
+
+#define put_cpu_ptr(var) do {				\
+	(void)(var);					\
+	preempt_enable();				\
+} while (0)
+
 #ifdef CONFIG_SMP
 
 /* minimum unit size, also is the maximum supported allocation size */


