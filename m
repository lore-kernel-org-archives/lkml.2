Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab1D3Pcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:32:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab1D3PcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:14 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=a16VIDRRhsoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=CreP_BVduvc56c4kok0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153210.615627637@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/8] ftrace: Remove unnecessary disabling of irqs
References: <20110430153040.354378898@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Remove-unnecessary-disabling-of-irqs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The disabling of interrupts around ftrace_update_code() was used
to protect against the evil ftrace daemon from years past. But that
daemon has long been killed. It is safe to keep interrupts enabled
while updating the initial mcount into nops.

The ftrace_mutex is also held which keeps other users at bay.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4ff6559..f199fb2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2707,7 +2707,6 @@ static int ftrace_process_locs(struct module *mod,
 {
 	unsigned long *p;
 	unsigned long addr;
-	unsigned long flags;
 
 	mutex_lock(&ftrace_lock);
 	p = start;
@@ -2724,10 +2723,7 @@ static int ftrace_process_locs(struct module *mod,
 		ftrace_record_ip(addr);
 	}
 
-	/* disable interrupts to prevent kstop machine */
-	local_irq_save(flags);
 	ftrace_update_code(mod);
-	local_irq_restore(flags);
 	mutex_unlock(&ftrace_lock);
 
 	return 0;
-- 
1.7.2.3


