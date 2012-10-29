Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405Ab2J2Xqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:46:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2J2Xqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:46:35 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=hXI3I0BFXWwNMd0WAfAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351554393.8467.79.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.4.15-rt25
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Mon, 29 Oct 2012 19:46:33 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.15-rt25 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 7fe212b3cf8cb2ba4dda85345130f7d3b0412e0f


Or to build 3.4.15-rt25 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.15.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.15-rt25.patch.xz


You can also build from 3.4.15-rt24 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.15-rt24-rt25.patch.xz



Enjoy,

-- Steve


Changes from 3.4.15-rt24:

---

Steven Rostedt (1):
      Linux 3.4.15-rt25

Thomas Gleixner (1):
      rcu: rcutiny: Prevent RCU stall

----
 kernel/rcutiny_plugin.h |    2 +-
 localversion-rt         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
---------------------------
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 22ecea0..97e359b 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -572,7 +572,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		rcu_preempt_cpu_qs();
 
 	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
+	if (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET)) {
 		local_irq_restore(flags);
 		return;
 	}
diff --git a/localversion-rt b/localversion-rt
index b2111a2..c5b71f9 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt24
+-rt25


