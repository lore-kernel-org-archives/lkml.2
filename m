Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab2FWDHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 23:07:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6148 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2FWDHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 23:07:04 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=vLUcVJZjORYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=7wB4DI0-MH4oMTfR_rEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120623030638.813391214@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 22 Jun 2012 23:05:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 1/3] spinlock/rt: Include bug.h in spinlock_rt.h to satisfy BUG() usage
References: <20120623030548.500374594@goodmis.org>
Content-Disposition: inline; filename=0001-spinlock-rt-Include-bug.h-in-spinlock_rt.h-to-satisf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Some archs (powerpc) failed to compile because of the reference to
BUG() in spinlock_rt.h. Although bug.h is included in many headers,
if spinlock.h is included in a C file before that, it will fail to
compile.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/spinlock_rt.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 3b555b4..0618387 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -5,6 +5,8 @@
 #error Do not include directly. Use spinlock.h
 #endif
 
+#include <linux/bug.h>
+
 extern void
 __rt_spin_lock_init(spinlock_t *lock, char *name, struct lock_class_key *key);
 
-- 
1.7.10


