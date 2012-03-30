Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915Ab2C3Og5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:36:57 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:46595 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174Ab2C3Ogv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:36:51 -0400
Date: Fri, 30 Mar 2012 16:36:15 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 build error patch
Message-ID: <20120330163615.5f35c4df@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12033014-0542-0000-0000-0000016AFDB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to fix the fallout from Davids system.h disintegration

Heiko Carstens (1):
      [S390] Fix build errors (fallout from system.h disintegration)

 arch/s390/include/asm/cpu_mf.h  |    2 ++
 arch/s390/include/asm/mmu.h     |    2 ++
 arch/s390/kernel/lgr.c          |    1 +
 arch/s390/kernel/perf_cpum_cf.c |    2 +-
 arch/s390/kernel/perf_event.c   |    1 -
 arch/s390/kernel/setup.c        |    1 +
 arch/s390/kernel/smp.c          |    2 ++
 7 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/cpu_mf.h b/arch/s390/include/asm/cpu_mf.h
index e49db5d..a3afecd 100644
--- a/arch/s390/include/asm/cpu_mf.h
+++ b/arch/s390/include/asm/cpu_mf.h
@@ -12,6 +12,8 @@
 #ifndef _ASM_S390_CPU_MF_H
 #define _ASM_S390_CPU_MF_H
 
+#include <asm/facility.h>
+
 #define CPU_MF_INT_SF_IAE	(1 << 31)	/* invalid entry address */
 #define CPU_MF_INT_SF_ISE	(1 << 30)	/* incorrect SDBT entry */
 #define CPU_MF_INT_SF_PRA	(1 << 29)	/* program request alert */
diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index 1c7d6ce..6340178 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -1,6 +1,8 @@
 #ifndef __MMU_H
 #define __MMU_H
 
+#include <linux/errno.h>
+
 typedef struct {
 	atomic_t attach_count;
 	unsigned int flush_mm;
diff --git a/arch/s390/kernel/lgr.c b/arch/s390/kernel/lgr.c
index ac39e7a..87f080b 100644
--- a/arch/s390/kernel/lgr.c
+++ b/arch/s390/kernel/lgr.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <asm/facility.h>
 #include <asm/sysinfo.h>
 #include <asm/ebcdic.h>
 #include <asm/debug.h>
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 8481ecf..4640508 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -18,7 +18,7 @@
 #include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/export.h>
-#include <asm/system.h>
+#include <asm/ctl_reg.h>
 #include <asm/irq.h>
 #include <asm/cpu_mf.h>
 
diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
index 609f985..f58f37f 100644
--- a/arch/s390/kernel/perf_event.c
+++ b/arch/s390/kernel/perf_event.c
@@ -15,7 +15,6 @@
 #include <linux/perf_event.h>
 #include <linux/percpu.h>
 #include <linux/export.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/cpu_mf.h>
 #include <asm/lowcore.h>
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 1581ea2..06264ae 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -50,6 +50,7 @@
 
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
+#include <asm/facility.h>
 #include <asm/smp.h>
 #include <asm/mmu_context.h>
 #include <asm/cpcmd.h>
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index a8bf999..1f77227 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -32,6 +32,8 @@
 #include <linux/slab.h>
 #include <linux/crash_dump.h>
 #include <asm/asm-offsets.h>
+#include <asm/switch_to.h>
+#include <asm/facility.h>
 #include <asm/ipl.h>
 #include <asm/setup.h>
 #include <asm/irq.h>

