Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0JOUKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:10:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab0JOUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:37 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=ZSxEIDLo8QMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=mkBMUuqLQEF-4Qm-a2gA:9 a=IYX8qphYRydIe9zf5dAA:7 a=DzOSSYF02Z6paAQLvlQ_0giVh2cA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015201036.166812670@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 16:09:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/9] tracing/x86: No need to disable interrupts when calling arch_init_ideal_nop5
References: <20101015200949.134732894@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-x86-No-need-to-disable-interrupts-when-calli.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function arch_init_ideal_nop5() is taken from the original
ftrace_dyn_arch_init() that originally had interrupts disabled
when calling it. This was due to the old way that mcounts were converted
to nops. The disabling of interrupts is no longer needed for the
work that is done.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 65fb077..1ce8f24 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2795,15 +2795,13 @@ extern unsigned long __stop_mcount_loc[];
 
 void __init ftrace_init(void)
 {
-	unsigned long count, addr, flags;
+	unsigned long count, addr;
 	int ret;
 
 	/* Keep the ftrace pointer to the stub */
 	addr = (unsigned long)ftrace_stub;
 
-	local_irq_save(flags);
 	ftrace_dyn_arch_init(&addr);
-	local_irq_restore(flags);
 
 	/* ftrace_dyn_arch_init places the return code in addr */
 	if (addr)
-- 
1.7.1


