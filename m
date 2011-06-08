Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab1FHWuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:50:00 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:18929 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1FHWt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:49:57 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1307573314!7390803!9
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] cpuinfo_op: consolidate extern declaration
Date: Wed, 8 Jun 2011 15:49:29 -0700
User-Agent: KMail/1.9.9
CC: <monstr@monstr.eu>, <lethal@linux-sh.org>, <davem@davemloft.net>,
        <cmetcalf@tilera.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <damm@opensource.se>, <arnd@arndb.de>,
        <hans.rosenfeld@amd.com>, <len.brown@intel.com>,
        <borislav.petkov@amd.com>, <tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106081549.30843.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the architectures supported by the kernel also support
/proc/cpuinfo. Only a couple actually declare the seq_operations
as extern. All the others will produce a sparse warning like:

warning: symbol 'cpuinfo_op' was not declared. Should it be static?

Fix all the warnings and consolidate the declaration by putting it
in <linux/seq_file.h>.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Tested-by: Michal Simek <monstr@monstr.eu>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Tejun Heo <tj@kernel.org>

---

v2: updated to latest linux-next and added sign offs
      original patch was posted Jan 14, 2010

diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index aed2a6b..9ded678 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -18,8 +18,6 @@
 #include <asm/current.h>
 
 # ifndef __ASSEMBLY__
-/* from kernel/cpu/mb.c */
-extern const struct seq_operations cpuinfo_op;
 
 # define cpu_relax()		barrier()
 # define cpu_sleep()		do {} while (0)
diff --git a/arch/sh/include/asm/processor.h b/arch/sh/include/asm/processor.h
index 9c7bdfc..ba300ee 100644
--- a/arch/sh/include/asm/processor.h
+++ b/arch/sh/include/asm/processor.h
@@ -127,7 +127,6 @@ extern unsigned int mem_init_done;
 
 /* arch/sh/kernel/setup.c */
 const char *get_cpu_subtype(struct sh_cpuinfo *c);
-extern const struct seq_operations cpuinfo_op;
 
 /* thread_struct flags */
 #define SH_THREAD_UAC_NOPRINT	(1 << 0)
diff --git a/arch/sparc/include/asm/cpudata_64.h b/arch/sparc/include/asm/cpudata_64.h
index 050ef35..ac3996b 100644
--- a/arch/sparc/include/asm/cpudata_64.h
+++ b/arch/sparc/include/asm/cpudata_64.h
@@ -35,8 +35,6 @@ DECLARE_PER_CPU(cpuinfo_sparc, __cpu_data);
 #define cpu_data(__cpu)		per_cpu(__cpu_data, (__cpu))
 #define local_cpu_data()	__get_cpu_var(__cpu_data)
 
-extern const struct seq_operations cpuinfo_op;
-
 #endif /* !(__ASSEMBLY__) */
 
 #include <asm/trap_block.h>
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 34c1e01..d95fcc7 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -257,10 +257,6 @@ static inline void cpu_relax(void)
 	barrier();
 }
 
-/* Info on this processor (see fs/proc/cpuinfo.c) */
-struct seq_operations;
-extern const struct seq_operations cpuinfo_op;
-
 /* Provide information about the chip model. */
 extern char chip_model[64];
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2193715..98eb12d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -142,8 +142,6 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		boot_cpu_data
 #endif
 
-extern const struct seq_operations cpuinfo_op;
-
 static inline int hlt_works(int cpu)
 {
 #ifdef CONFIG_X86_32
diff --git a/fs/proc/cpuinfo.c b/fs/proc/cpuinfo.c
index 5a1e539..f8eea8e 100644
--- a/fs/proc/cpuinfo.c
+++ b/fs/proc/cpuinfo.c
@@ -3,7 +3,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
-extern const struct seq_operations cpuinfo_op;
 static int cpuinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &cpuinfo_op);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 03c0232..ef11a13 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -33,6 +33,12 @@ struct seq_operations {
 	int (*show) (struct seq_file *m, void *v);
 };
 
+/*
+ * All architectures support /proc/cpuinfo
+ * Define the seq_operations here to keep things clean.
+ */
+extern const seq_operations cpuinfo_op;
+
 #define SEQ_SKIP 1
 
 /**
