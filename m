Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2DQPhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:37:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2DQPh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:37:29 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Kevin Tian <kevin.tian@intel.com>, Fengzhe Zhang <fengzhe.zhang@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH 1/3] Added new Proc entry to display per-cpu interrupts
Date: Tue, 17 Apr 2012 21:10:03 +0530
Message-Id: <1334677205-2623-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the number of cores increases the output of the /proc/interrupts losing the readability.

I think instead of showing complete information of all cores in a single proc file spliting the 
information based on per-CPU will be more useful (especially for people who wants to track
per-cpu information in real-time systems).

It is just a base version and works only for X86  (Copy pasted the output below)

Please let me know your opinions on this (Based on that I will try to make it work for all arch).

On a 24-core machine output of /proc/interrupts is not readable.

root@localhost:~# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7       CPU8       CPU9       CPU10      CPU11      CPU12      CPU13      CPU14      CPU15      CPU16      CPU17      CPU18      CPU19      CPU20      CPU21      CPU22      CPU23
  0:       1305          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      timer
  4:       3077          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      serial
  8:          1          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   acpi
 14:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      ata_piix


Newly added proc entries output.

[sasikantha@localhost Desktop]$ cat /proc/cpu/
0/ 1/
[sasikantha@localhost Desktop]$ cat /proc/cpu/0/interrupts
           CPU0
  0:    1122723   IO-APIC-edge      timer
  1:      45534   IO-APIC-edge      i8042
  4:          2   IO-APIC-edge
  7:          0   IO-APIC-edge      parport0
  8:          0   IO-APIC-edge      rtc0
  9:          0   IO-APIC-fasteoi   acpi
 12:     444699   IO-APIC-edge      i8042
 14:     223211   IO-APIC-edge      ata_piix
 15:          0   IO-APIC-edge      ata_piix
 16:         10   IO-APIC-fasteoi   uhci_hcd:usb3, uhci_hcd:usb8, eth1
 18:          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7
 19:          0   IO-APIC-fasteoi   uhci_hcd:usb6
 21:          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5
 42:      95394   PCI-MSI-edge      i915
 43:          0   PCI-MSI-edge      eth0
 44:        253   PCI-MSI-edge      snd_hda_intel
NMI:          0   Non-maskable interrupts
LOC:   10618394   Local timer interrupts
SPU:          0   Spurious interrupts
PMI:          0   Performance monitoring interrupts
IWI:          0   IRQ work interrupts
RTR:          0   APIC ICR read retries
RES:    1108550   Rescheduling interrupts
CAL:        223   Function call interrupts
TLB:      20763   TLB shootdowns
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
MCE:          0   Machine check exceptions
MCP:         54   Machine check polls
ERR:          0
MIS:          0
[sasikantha@localhost Desktop]$ cat /proc/cpu/1/interrupts
           CPU1
  0:    1101722   IO-APIC-edge      timer
  1:         15   IO-APIC-edge      i8042
  4:          1   IO-APIC-edge
  7:          0   IO-APIC-edge      parport0
  8:          1   IO-APIC-edge      rtc0
  9:          0   IO-APIC-fasteoi   acpi
 12:         65   IO-APIC-edge      i8042
 14:     200909   IO-APIC-edge      ata_piix
 15:          0   IO-APIC-edge      ata_piix
 16:    2875246   IO-APIC-fasteoi   uhci_hcd:usb3, uhci_hcd:usb8, eth1
 18:          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7
 19:          0   IO-APIC-fasteoi   uhci_hcd:usb6
 21:          0   IO-APIC-fasteoi   uhci_hcd:usb4
 42:         26   PCI-MSI-edge      i915
 43:          0   PCI-MSI-edge      eth0
 44:      72904   PCI-MSI-edge      snd_hda_intel
NMI:          0   Non-maskable interrupts
LOC:    9635490   Local timer interrupts
SPU:          0   Spurious interrupts
PMI:          0   Performance monitoring interrupts
IWI:          0   IRQ work interrupts
RTR:          0   APIC ICR read retries
RES:    1216863   Rescheduling interrupts
CAL:        412   Function call interrupts
TLB:      21671   TLB shootdowns
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
MCE:          0   Machine check exceptions
MCP:         54   Machine check polls
ERR:          0
MIS:          0


Did not touch the existing /proc/ininterrupts

[sasikantha@localhost Desktop]$ cat /proc/interrupts
           CPU0       CPU1
  0:    1122889    1101729   IO-APIC-edge      timer
  1:      45700         15   IO-APIC-edge      i8042
  4:          2          1   IO-APIC-edge
  7:          0          0   IO-APIC-edge      parport0
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:     444699         65   IO-APIC-edge      i8042
 14:     223560     200967   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:         10    2908377   IO-APIC-fasteoi   uhci_hcd:usb3, uhci_hcd:usb8, eth1
 18:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5
 42:      95409         26   PCI-MSI-edge      i915
 43:          0          0   PCI-MSI-edge      eth0
 44:        253      72929   PCI-MSI-edge      snd_hda_intel
NMI:          0          0   Non-maskable interrupts
LOC:   10627890    9640400   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RTR:          0          0   APIC ICR read retries
RES:    1113218    1220968   Rescheduling interrupts
CAL:        224        412   Function call interrupts
TLB:      20763      21671   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:         54         54   Machine check polls
ERR:          0
MIS:          0


Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 fs/proc/Makefile |    1 +
 fs/proc/percpu.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 0 deletions(-)
 create mode 100644 fs/proc/percpu.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index c1c7293..3615c72 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -21,6 +21,7 @@ proc-y	+= uptime.o
 proc-y	+= version.o
 proc-y	+= softirqs.o
 proc-y	+= namespaces.o
+proc-y	+= percpu.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff --git a/fs/proc/percpu.c b/fs/proc/percpu.c
new file mode 100644
index 0000000..da1d05c
--- /dev/null
+++ b/fs/proc/percpu.c
@@ -0,0 +1,115 @@
+/*
+ *   Per CPU-based information
+ *   Licensed under the GPL-2 or later
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irqnr.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+
+static struct proc_dir_entry *cpu_base_dir;
+static struct proc_dir_entry *cpu_dir[NR_CPUS];
+
+/*
+   Interrupts proc is based on /proc/interrupts 
+*/
+
+/*
+ * /proc/cpu/<number>/interrupts 
+ */
+
+static void *int_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos <= nr_irqs) ? pos : NULL;
+}
+
+static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos > nr_irqs)
+		return NULL;
+	return pos;
+}
+
+static void int_seq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+static const struct seq_operations int_seq_ops = {
+	.start = int_seq_start,
+	.next  = int_seq_next,
+	.stop  = int_seq_stop,
+	.show  = show_interrupts
+};
+
+static int interrupts_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+	ret =  seq_open(filp, &int_seq_ops);
+
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+		m->private = PDE(inode)->data;
+	}
+	return ret;
+
+}
+
+static const struct file_operations proc_intr_ops = {
+	.open		= interrupts_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+
+static void __exit proc_per_cpu_exit (void)
+{
+	int cpu = 0;
+        char name [10];
+
+        for_each_present_cpu (cpu) {
+		if  (cpu_dir[cpu]) {
+	                sprintf(name, "%d", cpu);
+			remove_proc_entry ("interrupts", cpu_dir[cpu]);
+			remove_proc_entry (name, cpu_base_dir);
+		}
+        }
+	remove_proc_entry ("cpu", NULL);
+}
+
+static int __init proc_per_cpu_init (void)
+{
+	int cpu;
+        char name [10];
+
+        cpu_base_dir = proc_mkdir("cpu", NULL);
+
+        if (!cpu_base_dir)
+		return -1;
+
+	for_each_present_cpu (cpu) {
+		sprintf(name, "%d", cpu);
+		cpu_dir[cpu] = proc_mkdir(name, cpu_base_dir);
+		if (!cpu_dir[cpu])
+			goto out_remove_dir;
+		/*XXX:Storing the CPU number as private data for simplicty,
+ 		 I may be wrong ?*/
+	        proc_create_data ("interrupts", 0, cpu_dir[cpu], &proc_intr_ops, 
+				  (void *)(cpu + 1));
+	}
+
+        return 0;
+
+out_remove_dir:
+	proc_per_cpu_exit ();
+	return -1;
+}
+
+module_exit(proc_per_cpu_exit);
+module_init(proc_per_cpu_init);
-- 
1.7.3.4

