Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab1ISV0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:26:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab1ISV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:43 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ImV9DXRzE20A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=E3jOJWIN1im_akGFpxAA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110919212641.302263742@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 19 Sep 2011 17:20:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: [RFC][PATCH 4/5] printk: Have wake_up_klogd() use __this_cpu_write()
References: <20110919212040.745370781@goodmis.org>
Content-Disposition: inline; filename=0004-printk-Have-wake_up_klogd-use-__this_cpu_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The wake up code that triggers klogd does not really matter which
CPU it enables the wake up on. Every CPU will be doing a printk_tick()
and check the current CPU. As long as one of the CPUs triggers the
wakeup we are fine. Use __this_cpu_write() instead of this_cpu_write()
to show that we do not care.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 28a40d8..e221fec 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1225,7 +1225,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		this_cpu_write(printk_pending, 1);
+		__this_cpu_write(printk_pending, 1);
 }
 
 /**
-- 
1.7.5.4


