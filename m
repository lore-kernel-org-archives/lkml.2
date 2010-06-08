Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0FHSJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 14:09:00 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:38058 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab0FHSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 14:08:58 -0400
Date: Tue, 8 Jun 2010 20:08:55 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.35-rc2
Message-ID: <20100608200855.3a62e837@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following three bug fixes and a defconfig update:

Heiko Carstens (1):
      [S390] appldata/extmem/kvm: add missing GFP_KERNEL flag

Hendrik Brueckner (1):
      [S390] kprobes: add parameter check to module_free()

Julia Lawall (1):
      [S390] arch/s390/kvm: Use GFP_ATOMIC when a lock is held

Martin Schwidefsky (1):
      [S390] Update default configuration.

 arch/s390/appldata/appldata_os.c |    2 +-
 arch/s390/defconfig              |   23 +++++++++++++----------
 arch/s390/kernel/module.c        |    6 ++++--
 arch/s390/kvm/kvm-s390.c         |    2 +-
 arch/s390/kvm/sigp.c             |    2 +-
 arch/s390/mm/extmem.c            |   19 ++++++++++---------
 drivers/s390/cio/itcw.c          |    2 +-
 7 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 55c80ff..92f1cb7 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -181,7 +181,7 @@ static int __init appldata_os_init(void)
 		goto out;
 	}
 
-	appldata_os_data = kzalloc(max_size, GFP_DMA);
+	appldata_os_data = kzalloc(max_size, GFP_KERNEL | GFP_DMA);
 	if (appldata_os_data == NULL) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index bcd6884..253f158 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.34-rc3
-# Fri Apr  9 09:57:10 2010
+# Linux kernel version: 2.6.35-rc1
+# Fri Jun  4 11:32:40 2010
 #
 CONFIG_SCHED_MC=y
 CONFIG_MMU=y
@@ -35,11 +35,13 @@ CONFIG_CONSTRUCTORS=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_CROSS_COMPILE=""
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_HAVE_KERNEL_GZIP=y
 CONFIG_HAVE_KERNEL_BZIP2=y
 CONFIG_HAVE_KERNEL_LZMA=y
+CONFIG_HAVE_KERNEL_LZO=y
 CONFIG_KERNEL_GZIP=y
 # CONFIG_KERNEL_BZIP2 is not set
 # CONFIG_KERNEL_LZMA is not set
@@ -77,6 +79,7 @@ CONFIG_CGROUP_NS=y
 # CONFIG_CGROUP_CPUACCT is not set
 # CONFIG_RESOURCE_COUNTERS is not set
 # CONFIG_CGROUP_SCHED is not set
+# CONFIG_BLK_CGROUP is not set
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_RELAY is not set
@@ -157,7 +160,6 @@ CONFIG_STOP_MACHINE=y
 CONFIG_BLOCK=y
 CONFIG_BLK_DEV_BSG=y
 # CONFIG_BLK_DEV_INTEGRITY is not set
-# CONFIG_BLK_CGROUP is not set
 CONFIG_BLOCK_COMPAT=y
 
 #
@@ -166,7 +168,6 @@ CONFIG_BLOCK_COMPAT=y
 CONFIG_IOSCHED_NOOP=y
 CONFIG_IOSCHED_DEADLINE=y
 CONFIG_IOSCHED_CFQ=y
-# CONFIG_CFQ_GROUP_IOSCHED is not set
 CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
@@ -247,7 +248,6 @@ CONFIG_64BIT=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=32
 CONFIG_HOTPLUG_CPU=y
-# CONFIG_SCHED_BOOK is not set
 CONFIG_COMPAT=y
 CONFIG_SYSVIPC_COMPAT=y
 CONFIG_AUDIT_ARCH=y
@@ -320,7 +320,6 @@ CONFIG_COMPAT_BINFMT_ELF=y
 # CONFIG_HAVE_AOUT is not set
 CONFIG_BINFMT_MISC=m
 CONFIG_FORCE_MAX_ZONEORDER=9
-# CONFIG_PROCESS_DEBUG is not set
 CONFIG_PFAULT=y
 # CONFIG_SHARED_KERNEL is not set
 # CONFIG_CMM is not set
@@ -457,6 +456,7 @@ CONFIG_NF_CONNTRACK=m
 # CONFIG_IP6_NF_IPTABLES is not set
 # CONFIG_IP_DCCP is not set
 CONFIG_IP_SCTP=m
+# CONFIG_NET_SCTPPROBE is not set
 # CONFIG_SCTP_DBG_MSG is not set
 # CONFIG_SCTP_DBG_OBJCNT is not set
 # CONFIG_SCTP_HMAC_NONE is not set
@@ -465,6 +465,7 @@ CONFIG_SCTP_HMAC_MD5=y
 # CONFIG_RDS is not set
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
+# CONFIG_L2TP is not set
 # CONFIG_BRIDGE is not set
 # CONFIG_VLAN_8021Q is not set
 # CONFIG_DECNET is not set
@@ -525,6 +526,7 @@ CONFIG_NET_ACT_NAT=m
 # CONFIG_NET_CLS_IND is not set
 CONFIG_NET_SCH_FIFO=y
 # CONFIG_DCB is not set
+CONFIG_RPS=y
 
 #
 # Network testing
@@ -546,6 +548,7 @@ CONFIG_CAN_VCAN=m
 # CONFIG_WIMAX is not set
 # CONFIG_RFKILL is not set
 # CONFIG_NET_9P is not set
+# CONFIG_CAIF is not set
 # CONFIG_PCMCIA is not set
 CONFIG_CCW=y
 
@@ -728,6 +731,7 @@ CONFIG_VIRTIO_NET=m
 # Character devices
 #
 CONFIG_DEVKMEM=y
+# CONFIG_N_GSM is not set
 CONFIG_UNIX98_PTYS=y
 # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 CONFIG_LEGACY_PTYS=y
@@ -775,6 +779,7 @@ CONFIG_S390_TAPE_34XX=m
 # CONFIG_MONREADER is not set
 CONFIG_MONWRITER=m
 CONFIG_S390_VMUR=m
+# CONFIG_RAMOOPS is not set
 
 #
 # PPS support
@@ -788,10 +793,6 @@ CONFIG_S390_VMUR=m
 # CONFIG_NEW_LEDS is not set
 CONFIG_ACCESSIBILITY=y
 # CONFIG_AUXDISPLAY is not set
-
-#
-# TI VLYNQ
-#
 # CONFIG_STAGING is not set
 
 #
@@ -976,6 +977,7 @@ CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
 # CONFIG_LKDTM is not set
+# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
@@ -1010,6 +1012,7 @@ CONFIG_BRANCH_PROFILE_NONE=y
 CONFIG_KPROBE_EVENT=y
 # CONFIG_RING_BUFFER_BENCHMARK is not set
 # CONFIG_DYNAMIC_DEBUG is not set
+# CONFIG_ATOMIC64_SELFTEST is not set
 CONFIG_SAMPLES=y
 # CONFIG_SAMPLE_TRACEPOINTS is not set
 # CONFIG_SAMPLE_TRACE_EVENTS is not set
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 639380a..22cfd63 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -55,8 +55,10 @@ void *module_alloc(unsigned long size)
 /* Free memory returned from module_alloc */
 void module_free(struct module *mod, void *module_region)
 {
-	vfree(mod->arch.syminfo);
-	mod->arch.syminfo = NULL;
+	if (mod) {
+		vfree(mod->arch.syminfo);
+		mod->arch.syminfo = NULL;
+	}
 	vfree(module_region);
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8093e6f..ae37058 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -761,7 +761,7 @@ static int __init kvm_s390_init(void)
 	 * to hold the maximum amount of facilites. On the other hand, we
 	 * only set facilities that are known to work in KVM.
 	 */
-	facilities = (unsigned long long *) get_zeroed_page(GFP_DMA);
+	facilities = (unsigned long long *) get_zeroed_page(GFP_KERNEL|GFP_DMA);
 	if (!facilities) {
 		kvm_exit();
 		return -ENOMEM;
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index eff3c59..702276f 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -113,7 +113,7 @@ static int __inject_sigp_stop(struct kvm_s390_local_interrupt *li, int action)
 {
 	struct kvm_s390_interrupt_info *inti;
 
-	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	inti = kzalloc(sizeof(*inti), GFP_ATOMIC);
 	if (!inti)
 		return -ENOMEM;
 	inti->type = KVM_S390_SIGP_STOP;
diff --git a/arch/s390/mm/extmem.c b/arch/s390/mm/extmem.c
index 6409fd5..3cc95dd 100644
--- a/arch/s390/mm/extmem.c
+++ b/arch/s390/mm/extmem.c
@@ -105,7 +105,7 @@ static int
 dcss_set_subcodes(void)
 {
 #ifdef CONFIG_64BIT
-	char *name = kmalloc(8 * sizeof(char), GFP_DMA);
+	char *name = kmalloc(8 * sizeof(char), GFP_KERNEL | GFP_DMA);
 	unsigned long rx, ry;
 	int rc;
 
@@ -252,12 +252,13 @@ dcss_diag_translate_rc (int vm_rc) {
 static int
 query_segment_type (struct dcss_segment *seg)
 {
-	struct qin64  *qin = kmalloc (sizeof(struct qin64), GFP_DMA);
-	struct qout64 *qout = kmalloc (sizeof(struct qout64), GFP_DMA);
-
-	int diag_cc, rc, i;
 	unsigned long dummy, vmrc;
+	int diag_cc, rc, i;
+	struct qout64 *qout;
+	struct qin64 *qin;
 
+	qin = kmalloc(sizeof(*qin), GFP_KERNEL | GFP_DMA);
+	qout = kmalloc(sizeof(*qout), GFP_KERNEL | GFP_DMA);
 	if ((qin == NULL) || (qout == NULL)) {
 		rc = -ENOMEM;
 		goto out_free;
@@ -286,7 +287,7 @@ query_segment_type (struct dcss_segment *seg)
 	   copy data for the new format. */
 	if (segext_scode == DCSS_SEGEXT) {
 		struct qout64_old *qout_old;
-		qout_old = kzalloc(sizeof(struct qout64_old), GFP_DMA);
+		qout_old = kzalloc(sizeof(*qout_old), GFP_KERNEL | GFP_DMA);
 		if (qout_old == NULL) {
 			rc = -ENOMEM;
 			goto out_free;
@@ -407,11 +408,11 @@ segment_overlaps_others (struct dcss_segment *seg)
 static int
 __segment_load (char *name, int do_nonshared, unsigned long *addr, unsigned long *end)
 {
-	struct dcss_segment *seg = kmalloc(sizeof(struct dcss_segment),
-			GFP_DMA);
-	int rc, diag_cc;
 	unsigned long start_addr, end_addr, dummy;
+	struct dcss_segment *seg;
+	int rc, diag_cc;
 
+	seg = kmalloc(sizeof(*seg), GFP_KERNEL | GFP_DMA);
 	if (seg == NULL) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/drivers/s390/cio/itcw.c b/drivers/s390/cio/itcw.c
index 17da9ab..a0ae295 100644
--- a/drivers/s390/cio/itcw.c
+++ b/drivers/s390/cio/itcw.c
@@ -42,7 +42,7 @@
  * size_t size;
  *
  * size = itcw_calc_size(1, 2, 0);
- * buffer = kmalloc(size, GFP_DMA);
+ * buffer = kmalloc(size, GFP_KERNEL | GFP_DMA);
  * if (!buffer)
  *	return -ENOMEM;
  * itcw = itcw_init(buffer, size, ITCW_OP_READ, 1, 2, 0);
