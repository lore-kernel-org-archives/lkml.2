Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab0ENEOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:14:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38306 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab0ENEOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:14:11 -0400
Date: Fri, 14 May 2010 14:14:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: linux-next: manual merge of the tip tree with the kgdb tree
Message-Id: <20100514141406.68a6bf6f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/Makefile between commit 7d63ecbc5ce463c8ba60e357eafaf47774521f1a
("Move kernel/kgdb.c to kernel/debug/debug_core.c") from the kgdb tree
and commit 58687acba59266735adb8ccd9b5b9aa2c7cd205b ("lockup_detector:
Combine nmi_watchdog and softlockup detector") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/Makefile
index 4313d0e,34d123b..0000000
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@@ -68,17 -68,16 +68,17 @@@ obj-$(CONFIG_USER_NS) += user_namespace
  obj-$(CONFIG_PID_NS) += pid_namespace.o
  obj-$(CONFIG_IKCONFIG) += configs.o
  obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
- obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
+ obj-$(CONFIG_SMP) += stop_machine.o
  obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 -obj-$(CONFIG_AUDIT) += audit.o auditfilter.o audit_watch.o
 +obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
  obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 -obj-$(CONFIG_GCOV_KERNEL) += gcov/
 +obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o
  obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 +obj-$(CONFIG_GCOV_KERNEL) += gcov/
  obj-$(CONFIG_KPROBES) += kprobes.o
 -obj-$(CONFIG_KGDB) += kgdb.o
 +obj-$(CONFIG_KGDB) += debug/
- obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
  obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
+ obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
  obj-$(CONFIG_SECCOMP) += seccomp.o
  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
