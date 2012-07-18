Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2GRWmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:42:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2GRWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:40:00 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=oFz6bgFAR-QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=hz37Oi2auKnw-Zy3hsgA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120718223959.345484946@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 18 Jul 2012 18:39:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 09/12] cpu/rt: Fix cpu_hotplug variable initialization
References: <20120718223910.898476857@goodmis.org>
Content-Disposition: inline; filename=0009-cpu-rt-Fix-cpu_hotplug-variable-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The commit "cpu/rt: Rework cpu down for PREEMPT_RT" changed the double
meaning of the cpu_hotplug.lock, where it was a spinlock for RT and a
mutex for non-RT, to just a mutex for both.  But the initialization of
the variable was not updated to reflect this change.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/cpu.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 11e6e9a..3bcbf99 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -54,11 +54,7 @@ static struct {
 	int refcount;
 } cpu_hotplug = {
 	.active_writer = NULL,
-#ifdef CONFIG_PREEMPT_RT_FULL
-	.lock = __SPIN_LOCK_UNLOCKED(cpu_hotplug.lock),
-#else
 	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
-#endif
 	.refcount = 0,
 };
 
-- 
1.7.10.4


