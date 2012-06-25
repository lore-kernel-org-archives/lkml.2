Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2FYOIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:08:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2389 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab2FYOIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:08:20 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=KUwhHYEArcovGaLp2DcA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340633298.27036.315.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.4.3-rt12
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Mon, 25 Jun 2012 10:08:18 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.3-rt12 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 590df7f02f97aa7acf2fe3a4d1f588534862c32d


Or to build 3.4.3-rt12 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.3.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.3-rt12.patch.xz


You can also build from 3.4.3-rt11 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.3-rt11-rt12.patch.xz



Enjoy,

-- Steve


Changes from 3.4.3-rt11:

---

Steven Rostedt (2):
      spinlock/rt: Include bug.h in spinlock_rt.h to satisfy BUG() usage
      Linux 3.4.3-rt12

Thomas Gleixner (1):
      Subject: powerpc: Mark low level irq handlers NO_THREAD

----
 arch/powerpc/platforms/8xx/m8xx_setup.c |    1 +
 arch/powerpc/sysdev/cpm1.c              |    1 +
 include/linux/spinlock_rt.h             |    2 ++
 localversion-rt                         |    2 +-
 4 files changed, 5 insertions(+), 1 deletion(-)
---------------------------
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 1e12108..806cbbd 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -43,6 +43,7 @@ static irqreturn_t timebase_interrupt(int irq, void *dev)
 
 static struct irqaction tbint_irqaction = {
 	.handler = timebase_interrupt,
+	.flags = IRQF_NO_THREAD,
 	.name = "tbint",
 };
 
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index d4fa03f..5e6ff38 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -120,6 +120,7 @@ static irqreturn_t cpm_error_interrupt(int irq, void *dev)
 
 static struct irqaction cpm_error_irqaction = {
 	.handler = cpm_error_interrupt,
+	.flags = IRQF_NO_THREAD,
 	.name = "error",
 };
 
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
 
diff --git a/localversion-rt b/localversion-rt
index 05c35cb..6e44e54 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt11
+-rt12


