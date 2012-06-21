Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab2FUNiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 09:38:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31256 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655Ab2FUNiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 09:38:00 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=SYZXsXtXtp0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=_gxSTfL8AAAA:8 a=q_P3M2LLXzLKraMRUOgA:9 a=PUjeQqilurYA:10 a=Sya1ZFHK3KgA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340285878.27036.138.camel@gandalf.stny.rr.com>
Subject: [PATCH][RT] spinlock: Add include for BUG() in spinlock_rt.h
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        leroy christophe <christophe.leroy@c-s.fr>,
        Iratxo Pichel Ortiz <ipichel@albentia.com>,
        David Garcia <dgarcia@albentia.com>
Date: Thu, 21 Jun 2012 09:37:58 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spinlock_rt.h references BUG(), but it does not include bug.h, and on
some architectures (powerpc) this can cause a build failure.

Reported-by: Iratxo Pichel Ortiz <ipichel@albentia.com>
Reported-by: leroy christophe <christophe.leroy@c-s.fr>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
----
[ Thomas, can you add this patch to your queue so that I can add it to
stable. Please, let me know when you have. Thanks! ]

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
 


