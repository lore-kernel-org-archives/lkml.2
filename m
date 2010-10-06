Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab0JFDft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:35:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595Ab0JFDfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:35:47 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=0s3T7Di9ZokA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=mkBMUuqLQEF-4Qm-a2gA:9 a=IYX8qphYRydIe9zf5dAA:7 a=mSan-g2_I5sl-JaV0ZMiHL6dMFUA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101006033545.365867366@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Oct 2010 23:34:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/9] tracing/x86: No need to disable interrupts when calling arch_init_ideal_nop5
References: <20101006033445.465428951@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-x86-No-need-to-disable-interrupts-when-calli.patch
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
index ebd80d5..13955a1 100644
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


