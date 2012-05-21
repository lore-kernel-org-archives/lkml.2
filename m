Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2EURBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:01:00 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:35159 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2EURAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:00:55 -0400
Date: Mon, 21 May 2012 19:00:48 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.5 merge window
Message-ID: <20120521190048.7d6073a5@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12052117-1948-0000-0000-000001DC78AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the s390 patches for the 3.5 merge window. Just a random
collection of bug-fixes and cleanups, nothing new in this merge request.

Christian Borntraeger (1):
      s390/kvm: bad rss-counter state

Gerald Schaefer (1):
      s390/hugepages: clear page table for sw large page emulation

Heiko Carstens (19):
      s390/compat: select COMPAT_BINFMT_ELF only if BINFMT_ELF is set
      s390/crypto des: add missing select statement
      s390/smp: get rid of compile warning
      s390/crash dump: add missing SMP dependency
      s390/tape: remove tape block leftovers
      s390/ipl: remove builtin tape ipl code
      s390: add various .gitignore files.
      s390/time: always use stckf instead of stck if available
      s390/pfault: fix task state race
      s390/pfault: always search for task with reported pid
      s390/pfault: use __set_task_state
      s390/pfault: add sanity check
      s390/entry64: avoid SPP code duplication
      s390/Kconfig: add HAVE_MARCH_[ARCH]_FEATURES Kconfig symbols
      s390/time: simply Kconfig dependency
      s390/memory hotplug: initialize storage keys
      s390/claw: remove "eieio" calls
      s390/barrier: cleanup barrier functions
      s390/barrier: make use of fast-bcr facility

Holger Dengler (2):
      s390/ap: move receive callback to message struct
      s390/ap: Fix wrong or missing comments

Jan Glauber (1):
      s390/qdio: Cleanup error handling to drivers

Martin Schwidefsky (5):
      s390: remove superfluous tpi from wait_cons_dev
      s390: make sie intercept independent of thread_info
      s390: replace TIF_SIE with PF_VCPU
      s390: remove dead code from signal handler
      s390: fix race on TIF_MCCK_PENDING

Michael Holzheu (2):
      s390: initialize backchain for ext_int_handler()
      s390: allow absolute memory access for /dev/mem

Sebastian Ott (13):
      s390/ccwgroup: introduce ccwgroup_create_dev
      s390/ccwgroup: exploit ccwdev_by_dev_id
      s390/ctcm: switch to ccwgroup_create_dev
      s390/lcs: switch to ccwgroup_create_dev
      s390/claw: switch to ccwgroup_create_dev
      s390/qeth: switch to ccwgroup_create_dev
      s390/qeth: stop using struct ccwgroup driver for discipline callbacks
      s390/ccwgroup: remove ccwgroup_create_from_string
      s390/ctc: cleanup drv attr usage
      s390/lcs: cleanup drv attr usage
      s390/claw: cleanup drv attr usage
      s390/qeth: cleanup drv attr usage
      s390/qeth: reshuffle initialization

Stefan Haberland (1):
      s390/dasd: re-prioritize partition detection message

Steffen Maier (1):
      s390/qdio: remove duplicate defines of data div bits

 arch/s390/Kconfig                    |   55 +++++------
 arch/s390/boot/.gitignore            |    2 +
 arch/s390/boot/compressed/.gitignore |    3 +
 arch/s390/defconfig                  |    1 -
 arch/s390/include/asm/barrier.h      |   37 +++----
 arch/s390/include/asm/ccwgroup.h     |   14 +--
 arch/s390/include/asm/io.h           |    7 +-
 arch/s390/include/asm/qdio.h         |   19 ++--
 arch/s390/include/asm/setup.h        |    3 -
 arch/s390/include/asm/thread_info.h  |    2 -
 arch/s390/include/asm/timex.h        |   17 +---
 arch/s390/kernel/.gitignore          |    1 +
 arch/s390/kernel/compat_signal.c     |    7 --
 arch/s390/kernel/early.c             |    2 -
 arch/s390/kernel/entry.S             |   21 ++--
 arch/s390/kernel/entry64.S           |   51 +++++-----
 arch/s390/kernel/head.S              |  123 -----------------------
 arch/s390/kernel/signal.c            |   16 ---
 arch/s390/kernel/smp.c               |    4 +
 arch/s390/kernel/vdso32/.gitignore   |    1 +
 arch/s390/kernel/vdso64/.gitignore   |    1 +
 arch/s390/mm/fault.c                 |   45 +++++----
 arch/s390/mm/hugetlbpage.c           |    2 +
 arch/s390/mm/maccess.c               |   67 +++++++++++++
 arch/s390/mm/pgtable.c               |    2 +
 block/partitions/ibm.c               |    2 +-
 drivers/crypto/Kconfig               |    1 +
 drivers/s390/char/sclp_cmd.c         |   12 ++-
 drivers/s390/char/tape.h             |   43 --------
 drivers/s390/char/tape_34xx.c        |  136 --------------------------
 drivers/s390/char/tape_3590.c        |  105 --------------------
 drivers/s390/char/tape_char.c        |   13 ---
 drivers/s390/char/tape_core.c        |   16 +--
 drivers/s390/cio/ccwgroup.c          |  112 ++++++++-------------
 drivers/s390/cio/cio.c               |   73 ++++----------
 drivers/s390/cio/device.c            |   13 ++-
 drivers/s390/cio/device.h            |    1 +
 drivers/s390/cio/qdio_main.c         |   47 ++++-----
 drivers/s390/crypto/ap_bus.c         |   24 +++--
 drivers/s390/crypto/ap_bus.h         |    7 +-
 drivers/s390/crypto/zcrypt_cex2a.c   |    3 +-
 drivers/s390/crypto/zcrypt_pcica.c   |    3 +-
 drivers/s390/crypto/zcrypt_pcicc.c   |    3 +-
 drivers/s390/crypto/zcrypt_pcixcc.c  |    5 +-
 drivers/s390/net/claw.c              |  165 ++++++++++++-------------------
 drivers/s390/net/ctcm_main.c         |   52 +++-------
 drivers/s390/net/ctcm_main.h         |    8 +-
 drivers/s390/net/ctcm_sysfs.c        |   37 ++-----
 drivers/s390/net/lcs.c               |   52 +++++-----
 drivers/s390/net/qeth_core.h         |   24 +++--
 drivers/s390/net/qeth_core_main.c    |  178 +++++++++++++++-------------------
 drivers/s390/net/qeth_core_sys.c     |   49 +++-------
 drivers/s390/net/qeth_l2_main.c      |   16 ++-
 drivers/s390/net/qeth_l3_main.c      |   16 ++-
 54 files changed, 592 insertions(+), 1127 deletions(-)
 create mode 100644 arch/s390/boot/.gitignore
 create mode 100644 arch/s390/boot/compressed/.gitignore
 create mode 100644 arch/s390/kernel/.gitignore
 create mode 100644 arch/s390/kernel/vdso32/.gitignore
 create mode 100644 arch/s390/kernel/vdso64/.gitignore

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9015060..b42f286 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -217,7 +217,7 @@ config COMPAT
 	def_bool y
 	prompt "Kernel support for 31 bit emulation"
 	depends on 64BIT
-	select COMPAT_BINFMT_ELF
+	select COMPAT_BINFMT_ELF if BINFMT_ELF
 	select ARCH_WANT_OLD_COMPAT_IPC
 	help
 	  Select this option if you want to enable your system kernel to
@@ -234,6 +234,25 @@ config KEYS_COMPAT
 config AUDIT_ARCH
 	def_bool y
 
+config HAVE_MARCH_Z900_FEATURES
+	def_bool n
+
+config HAVE_MARCH_Z990_FEATURES
+	def_bool n
+	select HAVE_MARCH_Z900_FEATURES
+
+config HAVE_MARCH_Z9_109_FEATURES
+	def_bool n
+	select HAVE_MARCH_Z990_FEATURES
+
+config HAVE_MARCH_Z10_FEATURES
+	def_bool n
+	select HAVE_MARCH_Z9_109_FEATURES
+
+config HAVE_MARCH_Z196_FEATURES
+	def_bool n
+	select HAVE_MARCH_Z10_FEATURES
+
 comment "Code generation options"
 
 choice
@@ -249,6 +268,7 @@ config MARCH_G5
 
 config MARCH_Z900
 	bool "IBM zSeries model z800 and z900"
+	select HAVE_MARCH_Z900_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for model z800/z900 (2064 and
 	  2066 series). This will enable some optimizations that are not
@@ -256,6 +276,7 @@ config MARCH_Z900
 
 config MARCH_Z990
 	bool "IBM zSeries model z890 and z990"
+	select HAVE_MARCH_Z990_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for model z890/z990 (2084 and
 	  2086 series). The kernel will be slightly faster but will not work
@@ -263,6 +284,7 @@ config MARCH_Z990
 
 config MARCH_Z9_109
 	bool "IBM System z9"
+	select HAVE_MARCH_Z9_109_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for IBM System z9 (2094 and
 	  2096 series). The kernel will be slightly faster but will not work
@@ -270,6 +292,7 @@ config MARCH_Z9_109
 
 config MARCH_Z10
 	bool "IBM System z10"
+	select HAVE_MARCH_Z10_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for IBM System z10 (2097 and
 	  2098 series). The kernel will be slightly faster but will not work
@@ -277,6 +300,7 @@ config MARCH_Z10
 
 config MARCH_Z196
 	bool "IBM zEnterprise 114 and 196"
+	select HAVE_MARCH_Z196_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for IBM zEnterprise 114 and 196
 	  (2818 and 2817 series). The kernel will be slightly faster but will
@@ -406,33 +430,6 @@ config CHSC_SCH
 
 comment "Misc"
 
-config IPL
-	def_bool y
-	prompt "Builtin IPL record support"
-	help
-	  If you want to use the produced kernel to IPL directly from a
-	  device, you have to merge a bootsector specific to the device
-	  into the first bytes of the kernel. You will have to select the
-	  IPL device.
-
-choice
-	prompt "IPL method generated into head.S"
-	depends on IPL
-	default IPL_VM
-	help
-	  Select "tape" if you want to IPL the image from a Tape.
-
-	  Select "vm_reader" if you are running under VM/ESA and want
-	  to IPL the image from the emulated card reader.
-
-config IPL_TAPE
-	bool "tape"
-
-config IPL_VM
-	bool "vm_reader"
-
-endchoice
-
 source "fs/Kconfig.binfmt"
 
 config FORCE_MAX_ZONEORDER
@@ -569,7 +566,7 @@ config KEXEC
 
 config CRASH_DUMP
 	bool "kernel crash dumps"
-	depends on 64BIT
+	depends on 64BIT && SMP
 	select KEXEC
 	help
 	  Generate crash dump after being started by kexec.
diff --git a/arch/s390/boot/.gitignore b/arch/s390/boot/.gitignore
new file mode 100644
index 0000000..017d591
--- /dev/null
+++ b/arch/s390/boot/.gitignore
@@ -0,0 +1,2 @@
+image
+bzImage
diff --git a/arch/s390/boot/compressed/.gitignore b/arch/s390/boot/compressed/.gitignore
new file mode 100644
index 0000000..ae06b9b
--- /dev/null
+++ b/arch/s390/boot/compressed/.gitignore
@@ -0,0 +1,3 @@
+sizes.h
+vmlinux
+vmlinux.lds
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 1957a9d..37d2bf2 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -155,7 +155,6 @@ CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_DES=m
 CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SALSA20=m
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
index 451273a..10a5088 100644
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -11,25 +11,28 @@
  * Force strict CPU ordering.
  * And yes, this is required on UP too when we're talking
  * to devices.
- *
- * This is very similar to the ppc eieio/sync instruction in that is
- * does a checkpoint syncronisation & makes sure that 
- * all memory ops have completed wrt other CPU's ( see 7-15 POP  DJB ).
  */
 
-#define eieio()	asm volatile("bcr 15,0" : : : "memory")
-#define SYNC_OTHER_CORES(x)   eieio()
-#define mb()    eieio()
-#define rmb()   eieio()
-#define wmb()   eieio()
-#define read_barrier_depends() do { } while(0)
-#define smp_mb()       mb()
-#define smp_rmb()      rmb()
-#define smp_wmb()      wmb()
-#define smp_read_barrier_depends()    read_barrier_depends()
-#define smp_mb__before_clear_bit()     smp_mb()
-#define smp_mb__after_clear_bit()      smp_mb()
+static inline void mb(void)
+{
+#ifdef CONFIG_HAVE_MARCH_Z196_FEATURES
+	/* Fast-BCR without checkpoint synchronization */
+	asm volatile("bcr 14,0" : : : "memory");
+#else
+	asm volatile("bcr 15,0" : : : "memory");
+#endif
+}
+
+#define rmb()				mb()
+#define wmb()				mb()
+#define read_barrier_depends()		do { } while(0)
+#define smp_mb()			mb()
+#define smp_rmb()			rmb()
+#define smp_wmb()			wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
+#define smp_mb__before_clear_bit()	smp_mb()
+#define smp_mb__after_clear_bit()	smp_mb()
 
-#define set_mb(var, value)      do { var = value; mb(); } while (0)
+#define set_mb(var, value)		do { var = value; mb(); } while (0)
 
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index f2ea2c5..f2ef34f 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -29,9 +29,7 @@ struct ccwgroup_device {
 
 /**
  * struct ccwgroup_driver - driver for ccw group devices
- * @max_slaves: maximum number of slave devices
- * @driver_id: unique id
- * @probe: function called on probe
+ * @setup: function called during device creation to setup the device
  * @remove: function called on remove
  * @set_online: function called when device is set online
  * @set_offline: function called when device is set offline
@@ -44,10 +42,7 @@ struct ccwgroup_device {
  * @driver: embedded driver structure
  */
 struct ccwgroup_driver {
-	int max_slaves;
-	unsigned long driver_id;
-
-	int (*probe) (struct ccwgroup_device *);
+	int (*setup) (struct ccwgroup_device *);
 	void (*remove) (struct ccwgroup_device *);
 	int (*set_online) (struct ccwgroup_device *);
 	int (*set_offline) (struct ccwgroup_device *);
@@ -63,9 +58,8 @@ struct ccwgroup_driver {
 
 extern int  ccwgroup_driver_register   (struct ccwgroup_driver *cdriver);
 extern void ccwgroup_driver_unregister (struct ccwgroup_driver *cdriver);
-int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
-				struct ccw_driver *cdrv, int num_devices,
-				const char *buf);
+int ccwgroup_create_dev(struct device *root, struct ccwgroup_driver *gdrv,
+			int num_devices, const char *buf);
 
 extern int ccwgroup_probe_ccwdev(struct ccw_device *cdev);
 extern void ccwgroup_remove_ccwdev(struct ccw_device *cdev);
diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index b7ff6af..27216d3 100644
--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -38,11 +38,8 @@ static inline void * phys_to_virt(unsigned long address)
 	return (void *) address;
 }
 
-/*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
+void *xlate_dev_mem_ptr(unsigned long phys);
+void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
 
 /*
  * Convert a virtual cached pointer to an uncached pointer
diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index d75c8e7..f039d86 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -258,11 +258,6 @@ struct slsb {
 	u8 val[QDIO_MAX_BUFFERS_PER_Q];
 } __attribute__ ((packed, aligned(256)));
 
-#define CHSC_AC2_MULTI_BUFFER_AVAILABLE	0x0080
-#define CHSC_AC2_MULTI_BUFFER_ENABLED	0x0040
-#define CHSC_AC2_DATA_DIV_AVAILABLE	0x0010
-#define CHSC_AC2_DATA_DIV_ENABLED	0x0002
-
 /**
  * struct qdio_outbuf_state - SBAL related asynchronous operation information
  *   (for communication with upper layer programs)
@@ -293,6 +288,8 @@ struct qdio_outbuf_state {
 #define AC1_SC_QEBSM_AVAILABLE		0x02	/* available for subchannel */
 #define AC1_SC_QEBSM_ENABLED		0x01	/* enabled for subchannel */
 
+#define CHSC_AC2_MULTI_BUFFER_AVAILABLE	0x0080
+#define CHSC_AC2_MULTI_BUFFER_ENABLED	0x0040
 #define CHSC_AC2_DATA_DIV_AVAILABLE	0x0010
 #define CHSC_AC2_DATA_DIV_ENABLED	0x0002
 
@@ -328,11 +325,13 @@ typedef void qdio_handler_t(struct ccw_device *, unsigned int, int,
 			    int, int, unsigned long);
 
 /* qdio errors reported to the upper-layer program */
-#define QDIO_ERROR_SIGA_TARGET			0x02
-#define QDIO_ERROR_SIGA_ACCESS_EXCEPTION	0x10
-#define QDIO_ERROR_SIGA_BUSY			0x20
-#define QDIO_ERROR_ACTIVATE_CHECK_CONDITION	0x40
-#define QDIO_ERROR_SLSB_STATE			0x80
+#define QDIO_ERROR_ACTIVATE			0x0001
+#define QDIO_ERROR_GET_BUF_STATE		0x0002
+#define QDIO_ERROR_SET_BUF_STATE		0x0004
+#define QDIO_ERROR_SLSB_STATE			0x0100
+
+#define QDIO_ERROR_FATAL			0x00ff
+#define QDIO_ERROR_TEMPORARY			0xff00
 
 /* for qdio_cleanup */
 #define QDIO_FLAG_CLEANUP_USING_CLEAR		0x01
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index b21e46e..7244e1f 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -82,7 +82,6 @@ extern unsigned int user_mode;
 #define MACHINE_FLAG_LPAR	(1UL << 12)
 #define MACHINE_FLAG_SPP	(1UL << 13)
 #define MACHINE_FLAG_TOPOLOGY	(1UL << 14)
-#define MACHINE_FLAG_STCKF	(1UL << 15)
 
 #define MACHINE_IS_VM		(S390_lowcore.machine_flags & MACHINE_FLAG_VM)
 #define MACHINE_IS_KVM		(S390_lowcore.machine_flags & MACHINE_FLAG_KVM)
@@ -101,7 +100,6 @@ extern unsigned int user_mode;
 #define MACHINE_HAS_PFMF	(0)
 #define MACHINE_HAS_SPP		(0)
 #define MACHINE_HAS_TOPOLOGY	(0)
-#define MACHINE_HAS_STCKF	(0)
 #else /* __s390x__ */
 #define MACHINE_HAS_IEEE	(1)
 #define MACHINE_HAS_CSP		(1)
@@ -113,7 +111,6 @@ extern unsigned int user_mode;
 #define MACHINE_HAS_PFMF	(S390_lowcore.machine_flags & MACHINE_FLAG_PFMF)
 #define MACHINE_HAS_SPP		(S390_lowcore.machine_flags & MACHINE_FLAG_SPP)
 #define MACHINE_HAS_TOPOLOGY	(S390_lowcore.machine_flags & MACHINE_FLAG_TOPOLOGY)
-#define MACHINE_HAS_STCKF	(S390_lowcore.machine_flags & MACHINE_FLAG_STCKF)
 #endif /* __s390x__ */
 
 #define ZFCPDUMP_HSA_SIZE	(32UL<<20)
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index a730381..003b04e 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -95,7 +95,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing active */
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_SYSCALL_TRACEPOINT	11	/* syscall tracepoint instrumentation */
-#define TIF_SIE			12	/* guest execution active */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_31BIT		17	/* 32bit process */
@@ -114,7 +113,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
-#define _TIF_SIE		(1<<TIF_SIE)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
 #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index c447a27..239ece9 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -73,11 +73,15 @@ static inline void local_tick_enable(unsigned long long comp)
 
 typedef unsigned long long cycles_t;
 
-static inline unsigned long long get_clock (void)
+static inline unsigned long long get_clock(void)
 {
 	unsigned long long clk;
 
+#ifdef CONFIG_HAVE_MARCH_Z9_109_FEATURES
+	asm volatile(".insn s,0xb27c0000,%0" : "=Q" (clk) : : "cc");
+#else
 	asm volatile("stck %0" : "=Q" (clk) : : "cc");
+#endif
 	return clk;
 }
 
@@ -86,17 +90,6 @@ static inline void get_clock_ext(char *clk)
 	asm volatile("stcke %0" : "=Q" (*clk) : : "cc");
 }
 
-static inline unsigned long long get_clock_fast(void)
-{
-	unsigned long long clk;
-
-	if (MACHINE_HAS_STCKF)
-		asm volatile(".insn	s,0xb27c0000,%0" : "=Q" (clk) : : "cc");
-	else
-		clk = get_clock();
-	return clk;
-}
-
 static inline unsigned long long get_clock_xt(void)
 {
 	unsigned char clk[16];
diff --git a/arch/s390/kernel/.gitignore b/arch/s390/kernel/.gitignore
new file mode 100644
index 0000000..c5f676c
--- /dev/null
+++ b/arch/s390/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 28040fd..377c096 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -437,13 +437,6 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
-	/* This is the legacy signal stack switching. */
-	else if (!user_mode(regs) &&
-		 !(ka->sa.sa_flags & SA_RESTORER) &&
-		 ka->sa.sa_restorer) {
-		sp = (unsigned long) ka->sa.sa_restorer;
-	}
-
 	return (void __user *)((sp - frame_size) & -8ul);
 }
 
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 9475e68..d84181f 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -374,8 +374,6 @@ static __init void detect_machine_facilities(void)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_MVCOS;
 	if (test_facility(40))
 		S390_lowcore.machine_flags |= MACHINE_FLAG_SPP;
-	if (test_facility(25))
-		S390_lowcore.machine_flags |= MACHINE_FLAG_STCKF;
 #endif
 }
 
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 74ee563..1ae93b5 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -145,22 +145,23 @@ STACK_SIZE  = 1 << STACK_SHIFT
  *  gpr2 = prev
  */
 ENTRY(__switch_to)
+	stm	%r6,%r15,__SF_GPRS(%r15)	# store gprs of prev task
+	st	%r15,__THREAD_ksp(%r2)		# store kernel stack of prev
 	l	%r4,__THREAD_info(%r2)		# get thread_info of prev
 	l	%r5,__THREAD_info(%r3)		# get thread_info of next
+	lr	%r15,%r5
+	ahi	%r15,STACK_SIZE			# end of kernel stack of next
+	st	%r3,__LC_CURRENT		# store task struct of next
+	st	%r5,__LC_THREAD_INFO		# store thread info of next
+	st	%r15,__LC_KERNEL_STACK		# store end of kernel stack
+	lctl	%c4,%c4,__TASK_pid(%r3)		# load pid to control reg. 4
+	mvc	__LC_CURRENT_PID(4,%r0),__TASK_pid(%r3)	# store pid of next
+	l	%r15,__THREAD_ksp(%r3)		# load kernel stack of next
 	tm	__TI_flags+3(%r4),_TIF_MCCK_PENDING # machine check pending?
 	jz	0f
 	ni	__TI_flags+3(%r4),255-_TIF_MCCK_PENDING	# clear flag in prev
 	oi	__TI_flags+3(%r5),_TIF_MCCK_PENDING	# set it in next
-0:	stm	%r6,%r15,__SF_GPRS(%r15)	# store gprs of prev task
-	st	%r15,__THREAD_ksp(%r2)		# store kernel stack of prev
-	l	%r15,__THREAD_ksp(%r3)		# load kernel stack of next
-	lctl	%c4,%c4,__TASK_pid(%r3)		# load pid to control reg. 4
-	lm	%r6,%r15,__SF_GPRS(%r15)	# load gprs of next task
-	st	%r3,__LC_CURRENT		# store task struct of next
-	mvc	__LC_CURRENT_PID(4,%r0),__TASK_pid(%r3)	# store pid of next
-	st	%r5,__LC_THREAD_INFO		# store thread info of next
-	ahi	%r5,STACK_SIZE			# end of kernel stack of next
-	st	%r5,__LC_KERNEL_STACK		# store end of kernel stack
+0:	lm	%r6,%r15,__SF_GPRS(%r15)	# load gprs of next task
 	br	%r14
 
 __critical_start:
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 4e1c292..229fe1d 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -81,16 +81,14 @@ _TIF_EXIT_SIE = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | _TIF_MCCK_PENDING)
 
 	.macro	HANDLE_SIE_INTERCEPT scratch
 #if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
-	tm	__TI_flags+6(%r12),_TIF_SIE>>8
-	jz	.+42
-	tm	__LC_MACHINE_FLAGS+6,0x20	# MACHINE_FLAG_SPP
-	jz	.+8
-	.insn	s,0xb2800000,BASED(.Lhost_id)	# set host id
+	tmhh	%r8,0x0001		# interrupting from user ?
+	jnz	.+42
 	lgr	\scratch,%r9
 	slg	\scratch,BASED(.Lsie_loop)
 	clg	\scratch,BASED(.Lsie_length)
-	jhe	.+10
+	jhe	.+22
 	lg	%r9,BASED(.Lsie_loop)
+	SPP	BASED(.Lhost_id)	# set host id
 #endif
 	.endm
 
@@ -148,6 +146,14 @@ _TIF_EXIT_SIE = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | _TIF_MCCK_PENDING)
 	ssm	__LC_RETURN_PSW
 	.endm
 
+	.macro STCK savearea
+#ifdef CONFIG_HAVE_MARCH_Z9_109_FEATURES
+	.insn	s,0xb27c0000,\savearea		# store clock fast
+#else
+	.insn	s,0xb2050000,\savearea		# store clock
+#endif
+	.endm
+
 	.section .kprobes.text, "ax"
 
 /*
@@ -158,22 +164,23 @@ _TIF_EXIT_SIE = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | _TIF_MCCK_PENDING)
  *  gpr2 = prev
  */
 ENTRY(__switch_to)
+	stmg	%r6,%r15,__SF_GPRS(%r15)	# store gprs of prev task
+	stg	%r15,__THREAD_ksp(%r2)		# store kernel stack of prev
 	lg	%r4,__THREAD_info(%r2)		# get thread_info of prev
 	lg	%r5,__THREAD_info(%r3)		# get thread_info of next
+	lgr	%r15,%r5
+	aghi	%r15,STACK_SIZE			# end of kernel stack of next
+	stg	%r3,__LC_CURRENT		# store task struct of next
+	stg	%r5,__LC_THREAD_INFO		# store thread info of next
+	stg	%r15,__LC_KERNEL_STACK		# store end of kernel stack
+	lctl	%c4,%c4,__TASK_pid(%r3)		# load pid to control reg. 4
+	mvc	__LC_CURRENT_PID+4(4,%r0),__TASK_pid(%r3) # store pid of next
+	lg	%r15,__THREAD_ksp(%r3)		# load kernel stack of next
 	tm	__TI_flags+7(%r4),_TIF_MCCK_PENDING # machine check pending?
 	jz	0f
 	ni	__TI_flags+7(%r4),255-_TIF_MCCK_PENDING	# clear flag in prev
 	oi	__TI_flags+7(%r5),_TIF_MCCK_PENDING	# set it in next
-0:	stmg	%r6,%r15,__SF_GPRS(%r15)	# store gprs of prev task
-	stg	%r15,__THREAD_ksp(%r2)		# store kernel stack of prev
-	lg	%r15,__THREAD_ksp(%r3)		# load kernel stack of next
-	lctl	%c4,%c4,__TASK_pid(%r3)		# load pid to control reg. 4
-	lmg	%r6,%r15,__SF_GPRS(%r15)	# load gprs of next task
-	stg	%r3,__LC_CURRENT		# store task struct of next
-	mvc	__LC_CURRENT_PID+4(4,%r0),__TASK_pid(%r3) # store pid of next
-	stg	%r5,__LC_THREAD_INFO		# store thread info of next
-	aghi	%r5,STACK_SIZE			# end of kernel stack of next
-	stg	%r5,__LC_KERNEL_STACK		# store end of kernel stack
+0:	lmg	%r6,%r15,__SF_GPRS(%r15)	# load gprs of next task
 	br	%r14
 
 __critical_start:
@@ -458,7 +465,7 @@ pgm_svcper:
  * IO interrupt handler routine
  */
 ENTRY(io_int_handler)
-	stck	__LC_INT_CLOCK
+	STCK	__LC_INT_CLOCK
 	stpt	__LC_ASYNC_ENTER_TIMER
 	stmg	%r8,%r15,__LC_SAVE_AREA_ASYNC
 	lg	%r10,__LC_LAST_BREAK
@@ -604,7 +611,7 @@ io_notify_resume:
  * External interrupt handler routine
  */
 ENTRY(ext_int_handler)
-	stck	__LC_INT_CLOCK
+	STCK	__LC_INT_CLOCK
 	stpt	__LC_ASYNC_ENTER_TIMER
 	stmg	%r8,%r15,__LC_SAVE_AREA_ASYNC
 	lg	%r10,__LC_LAST_BREAK
@@ -622,6 +629,7 @@ ext_skip:
 	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA_ASYNC
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	TRACE_IRQS_OFF
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lghi	%r1,4096
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	llgf	%r3,__LC_EXT_CPU_ADDR	# get cpu address + interruption code
@@ -638,7 +646,7 @@ ENTRY(psw_idle)
 	larl	%r1,psw_idle_lpsw+4
 	stg	%r1,__SF_EMPTY+8(%r15)
 	larl	%r1,.Lvtimer_max
-	stck	__IDLE_ENTER(%r2)
+	STCK	__IDLE_ENTER(%r2)
 	ltr	%r5,%r5
 	stpt	__VQ_IDLE_ENTER(%r3)
 	jz	psw_idle_lpsw
@@ -654,7 +662,7 @@ __critical_end:
  * Machine check handler routines
  */
 ENTRY(mcck_int_handler)
-	stck	__LC_MCCK_CLOCK
+	STCK	__LC_MCCK_CLOCK
 	la	%r1,4095		# revalidate r1
 	spt	__LC_CPU_TIMER_SAVE_AREA-4095(%r1)	# revalidate cpu timer
 	lmg	%r0,%r15,__LC_GPREGS_SAVE_AREA-4095(%r1)# revalidate gprs
@@ -967,7 +975,6 @@ ENTRY(sie64a)
 	xc	__SF_EMPTY+16(8,%r15),__SF_EMPTY+16(%r15) # host id == 0
 	lmg	%r0,%r13,0(%r3)			# load guest gprs 0-13
 	lg	%r14,__LC_THREAD_INFO		# pointer thread_info struct
-	oi	__TI_flags+6(%r14),_TIF_SIE>>8
 sie_loop:
 	lg	%r14,__LC_THREAD_INFO		# pointer thread_info struct
 	tm	__TI_flags+7(%r14),_TIF_EXIT_SIE
@@ -985,7 +992,6 @@ sie_done:
 	lg	%r14,__LC_THREAD_INFO		# pointer thread_info struct
 sie_exit:
 	lctlg	%c1,%c1,__LC_USER_ASCE		# load primary asce
-	ni	__TI_flags+6(%r14),255-(_TIF_SIE>>8)
 	lg	%r14,__SF_EMPTY+8(%r15)		# load guest register save area
 	stmg	%r0,%r13,0(%r14)		# save guest gprs 0-13
 	lmg	%r6,%r14,__SF_GPRS(%r15)	# restore kernel registers
@@ -994,7 +1000,6 @@ sie_exit:
 sie_fault:
 	lctlg	%c1,%c1,__LC_USER_ASCE		# load primary asce
 	lg	%r14,__LC_THREAD_INFO		# pointer thread_info struct
-	ni	__TI_flags+6(%r14),255-(_TIF_SIE>>8)
 	lg	%r14,__SF_EMPTY+8(%r15)		# load guest register save area
 	stmg	%r0,%r13,0(%r14)		# save guest gprs 0-13
 	lmg	%r6,%r14,__SF_GPRS(%r15)	# restore kernel registers
diff --git a/arch/s390/kernel/head.S b/arch/s390/kernel/head.S
index adccd90..4939d15 100644
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -34,125 +34,7 @@
 #endif
 
 __HEAD
-#ifndef CONFIG_IPL
-	.org   0
-	.long  0x00080000,0x80000000+startup	# Just a restart PSW
-#else
-#ifdef CONFIG_IPL_TAPE
-#define IPL_BS 1024
-	.org   0
-	.long  0x00080000,0x80000000+iplstart	# The first 24 bytes are loaded
-	.long  0x27000000,0x60000001		# by ipl to addresses 0-23.
-	.long  0x02000000,0x20000000+IPL_BS	# (a PSW and two CCWs).
-	.long  0x00000000,0x00000000		# external old psw
-	.long  0x00000000,0x00000000		# svc old psw
-	.long  0x00000000,0x00000000		# program check old psw
-	.long  0x00000000,0x00000000		# machine check old psw
-	.long  0x00000000,0x00000000		# io old psw
-	.long  0x00000000,0x00000000
-	.long  0x00000000,0x00000000
-	.long  0x00000000,0x00000000
-	.long  0x000a0000,0x00000058		# external new psw
-	.long  0x000a0000,0x00000060		# svc new psw
-	.long  0x000a0000,0x00000068		# program check new psw
-	.long  0x000a0000,0x00000070		# machine check new psw
-	.long  0x00080000,0x80000000+.Lioint	# io new psw
 
-	.org   0x100
-#
-# subroutine for loading from tape
-# Parameters:
-#  R1 = device number
-#  R2 = load address
-.Lloader:
-	st	%r14,.Lldret
-	la	%r3,.Lorbread		# r3 = address of orb
-	la	%r5,.Lirb		# r5 = address of irb
-	st	%r2,.Lccwread+4 	# initialize CCW data addresses
-	lctl	%c6,%c6,.Lcr6
-	slr	%r2,%r2
-.Lldlp:
-	la	%r6,3			# 3 retries
-.Lssch:
-	ssch	0(%r3)			# load chunk of IPL_BS bytes
-	bnz	.Llderr
-.Lw4end:
-	bas	%r14,.Lwait4io
-	tm	8(%r5),0x82		# do we have a problem ?
-	bnz	.Lrecov
-	slr	%r7,%r7
-	icm	%r7,3,10(%r5)		# get residual count
-	lcr	%r7,%r7
-	la	%r7,IPL_BS(%r7) 	# IPL_BS-residual=#bytes read
-	ar	%r2,%r7 		# add to total size
-	tm	8(%r5),0x01		# found a tape mark ?
-	bnz	.Ldone
-	l	%r0,.Lccwread+4 	# update CCW data addresses
-	ar	%r0,%r7
-	st	%r0,.Lccwread+4
-	b	.Lldlp
-.Ldone:
-	l	%r14,.Lldret
-	br	%r14			# r2 contains the total size
-.Lrecov:
-	bas	%r14,.Lsense		# do the sensing
-	bct	%r6,.Lssch		# dec. retry count & branch
-	b	.Llderr
-#
-# Sense subroutine
-#
-.Lsense:
-	st	%r14,.Lsnsret
-	la	%r7,.Lorbsense
-	ssch	0(%r7)			# start sense command
-	bnz	.Llderr
-	bas	%r14,.Lwait4io
-	l	%r14,.Lsnsret
-	tm	8(%r5),0x82		# do we have a problem ?
-	bnz	.Llderr
-	br	%r14
-#
-# Wait for interrupt subroutine
-#
-.Lwait4io:
-	lpsw	.Lwaitpsw
-.Lioint:
-	c	%r1,0xb8		# compare subchannel number
-	bne	.Lwait4io
-	tsch	0(%r5)
-	slr	%r0,%r0
-	tm	8(%r5),0x82		# do we have a problem ?
-	bnz	.Lwtexit
-	tm	8(%r5),0x04		# got device end ?
-	bz	.Lwait4io
-.Lwtexit:
-	br	%r14
-.Llderr:
-	lpsw	.Lcrash
-
-	.align	8
-.Lorbread:
-	.long	0x00000000,0x0080ff00,.Lccwread
-	.align	8
-.Lorbsense:
-	.long	0x00000000,0x0080ff00,.Lccwsense
-	.align	8
-.Lccwread:
-	.long	0x02200000+IPL_BS,0x00000000
-.Lccwsense:
-	.long	0x04200001,0x00000000
-.Lwaitpsw:
-	.long	0x020a0000,0x80000000+.Lioint
-
-.Lirb:	.long	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
-.Lcr6:	.long	0xff000000
-	.align	8
-.Lcrash:.long	0x000a0000,0x00000000
-.Lldret:.long	0
-.Lsnsret: .long 0
-#endif	/* CONFIG_IPL_TAPE */
-
-#ifdef CONFIG_IPL_VM
 #define IPL_BS	0x730
 	.org	0
 	.long	0x00080000,0x80000000+iplstart	# The first 24 bytes are loaded
@@ -256,7 +138,6 @@ __HEAD
 	.long	0x02600050,0x00000000
 	.endr
 	.long	0x02200050,0x00000000
-#endif	/* CONFIG_IPL_VM */
 
 iplstart:
 	lh	%r1,0xb8		# test if subchannel number
@@ -325,7 +206,6 @@ iplstart:
 	clc	0(3,%r2),.L_eof
 	bz	.Lagain2
 
-#ifdef CONFIG_IPL_VM
 #
 # reset files in VM reader
 #
@@ -358,7 +238,6 @@ iplstart:
 	.long	0x00080000,0x80000000+.Lrdrint
 .Lrdrwaitpsw:
 	.long	0x020a0000,0x80000000+.Lrdrint
-#endif
 
 #
 # everything loaded, go for it
@@ -376,8 +255,6 @@ iplstart:
 .L_eof: .long	0xc5d6c600	 /* C'EOF' */
 .L_hdr: .long	0xc8c4d900	 /* C'HDR' */
 
-#endif	/* CONFIG_IPL */
-
 #
 # SALIPL loader support. Based on a patch by Rob van der Heij.
 # This entry point is called directly from the SALIPL loader and
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index f7582b2..8a4e2b7 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -235,13 +235,6 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
-	/* This is the legacy signal stack switching. */
-	else if (!user_mode(regs) &&
-		 !(ka->sa.sa_flags & SA_RESTORER) &&
-		 ka->sa.sa_restorer) {
-		sp = (unsigned long) ka->sa.sa_restorer;
-	}
-
 	return (void __user *)((sp - frame_size) & -8ul);
 }
 
@@ -414,15 +407,6 @@ void do_signal(struct pt_regs *regs)
 	struct k_sigaction ka;
 	sigset_t *oldset;
 
-	/*
-	 * We want the common case to go fast, which
-	 * is why we may in certain cases get here from
-	 * kernel mode. Just return without doing anything
-	 * if so.
-	 */
-	if (!user_mode(regs))
-		return;
-
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
 		oldset = &current->saved_sigmask;
 	else
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 1f77227..e505458 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -226,6 +226,8 @@ out:
 	return -ENOMEM;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
 static void pcpu_free_lowcore(struct pcpu *pcpu)
 {
 	pcpu_sigp_retry(pcpu, sigp_set_prefix, 0);
@@ -247,6 +249,8 @@ static void pcpu_free_lowcore(struct pcpu *pcpu)
 	}
 }
 
+#endif /* CONFIG_HOTPLUG_CPU */
+
 static void pcpu_prepare_secondary(struct pcpu *pcpu, int cpu)
 {
 	struct _lowcore *lc = pcpu->lowcore;
diff --git a/arch/s390/kernel/vdso32/.gitignore b/arch/s390/kernel/vdso32/.gitignore
new file mode 100644
index 0000000..e45fba9
--- /dev/null
+++ b/arch/s390/kernel/vdso32/.gitignore
@@ -0,0 +1 @@
+vdso32.lds
diff --git a/arch/s390/kernel/vdso64/.gitignore b/arch/s390/kernel/vdso64/.gitignore
new file mode 100644
index 0000000..3fd18cf
--- /dev/null
+++ b/arch/s390/kernel/vdso64/.gitignore
@@ -0,0 +1 @@
+vdso64.lds
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 46ef3fd..72cec9e 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -294,7 +294,7 @@ static inline int do_exception(struct pt_regs *regs, int access)
 	down_read(&mm->mmap_sem);
 
 #ifdef CONFIG_PGSTE
-	if (test_tsk_thread_flag(current, TIF_SIE) && S390_lowcore.gmap) {
+	if ((current->flags & PF_VCPU) && S390_lowcore.gmap) {
 		address = __gmap_fault(address,
 				     (struct gmap *) S390_lowcore.gmap);
 		if (address == -EFAULT) {
@@ -549,19 +549,15 @@ static void pfault_interrupt(struct ext_code ext_code,
 	if ((subcode & 0xff00) != __SUBCODE_MASK)
 		return;
 	kstat_cpu(smp_processor_id()).irqs[EXTINT_PFL]++;
-	if (subcode & 0x0080) {
-		/* Get the token (= pid of the affected task). */
-		pid = sizeof(void *) == 4 ? param32 : param64;
-		rcu_read_lock();
-		tsk = find_task_by_pid_ns(pid, &init_pid_ns);
-		if (tsk)
-			get_task_struct(tsk);
-		rcu_read_unlock();
-		if (!tsk)
-			return;
-	} else {
-		tsk = current;
-	}
+	/* Get the token (= pid of the affected task). */
+	pid = sizeof(void *) == 4 ? param32 : param64;
+	rcu_read_lock();
+	tsk = find_task_by_pid_ns(pid, &init_pid_ns);
+	if (tsk)
+		get_task_struct(tsk);
+	rcu_read_unlock();
+	if (!tsk)
+		return;
 	spin_lock(&pfault_lock);
 	if (subcode & 0x0080) {
 		/* signal bit is set -> a page has been swapped in by VM */
@@ -574,6 +570,7 @@ static void pfault_interrupt(struct ext_code ext_code,
 			tsk->thread.pfault_wait = 0;
 			list_del(&tsk->thread.list);
 			wake_up_process(tsk);
+			put_task_struct(tsk);
 		} else {
 			/* Completion interrupt was faster than initial
 			 * interrupt. Set pfault_wait to -1 so the initial
@@ -585,24 +582,35 @@ static void pfault_interrupt(struct ext_code ext_code,
 			if (tsk->state == TASK_RUNNING)
 				tsk->thread.pfault_wait = -1;
 		}
-		put_task_struct(tsk);
 	} else {
 		/* signal bit not set -> a real page is missing. */
-		if (tsk->thread.pfault_wait == -1) {
+		if (WARN_ON_ONCE(tsk != current))
+			goto out;
+		if (tsk->thread.pfault_wait == 1) {
+			/* Already on the list with a reference: put to sleep */
+			__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			set_tsk_need_resched(tsk);
+		} else if (tsk->thread.pfault_wait == -1) {
 			/* Completion interrupt was faster than the initial
 			 * interrupt (pfault_wait == -1). Set pfault_wait
 			 * back to zero and exit. */
 			tsk->thread.pfault_wait = 0;
 		} else {
 			/* Initial interrupt arrived before completion
-			 * interrupt. Let the task sleep. */
+			 * interrupt. Let the task sleep.
+			 * An extra task reference is needed since a different
+			 * cpu may set the task state to TASK_RUNNING again
+			 * before the scheduler is reached. */
+			get_task_struct(tsk);
 			tsk->thread.pfault_wait = 1;
 			list_add(&tsk->thread.list, &pfault_list);
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 			set_tsk_need_resched(tsk);
 		}
 	}
+out:
 	spin_unlock(&pfault_lock);
+	put_task_struct(tsk);
 }
 
 static int __cpuinit pfault_cpu_notify(struct notifier_block *self,
@@ -620,6 +628,7 @@ static int __cpuinit pfault_cpu_notify(struct notifier_block *self,
 			list_del(&thread->list);
 			tsk = container_of(thread, struct task_struct, thread);
 			wake_up_process(tsk);
+			put_task_struct(tsk);
 		}
 		spin_unlock_irq(&pfault_lock);
 		break;
diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index 597bb2d..900de2b 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -58,6 +58,8 @@ void arch_release_hugepage(struct page *page)
 	ptep = (pte_t *) page[1].index;
 	if (!ptep)
 		return;
+	clear_table((unsigned long *) ptep, _PAGE_TYPE_EMPTY,
+		    PTRS_PER_PTE * sizeof(pte_t));
 	page_table_free(&init_mm, (unsigned long *) ptep);
 	page[1].index = 0;
 }
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index e1335dc..795a0a9 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/gfp.h>
+#include <linux/cpu.h>
 #include <asm/ctl_reg.h>
 
 /*
@@ -166,3 +167,69 @@ out:
 	free_page((unsigned long) buf);
 	return rc;
 }
+
+/*
+ * Check if physical address is within prefix or zero page
+ */
+static int is_swapped(unsigned long addr)
+{
+	unsigned long lc;
+	int cpu;
+
+	if (addr < sizeof(struct _lowcore))
+		return 1;
+	for_each_online_cpu(cpu) {
+		lc = (unsigned long) lowcore_ptr[cpu];
+		if (addr > lc + sizeof(struct _lowcore) - 1 || addr < lc)
+			continue;
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Return swapped prefix or zero page address
+ */
+static unsigned long get_swapped(unsigned long addr)
+{
+	unsigned long prefix = store_prefix();
+
+	if (addr < sizeof(struct _lowcore))
+		return addr + prefix;
+	if (addr >= prefix && addr < prefix + sizeof(struct _lowcore))
+		return addr - prefix;
+	return addr;
+}
+
+/*
+ * Convert a physical pointer for /dev/mem access
+ *
+ * For swapped prefix pages a new buffer is returned that contains a copy of
+ * the absolute memory. The buffer size is maximum one page large.
+ */
+void *xlate_dev_mem_ptr(unsigned long addr)
+{
+	void *bounce = (void *) addr;
+	unsigned long size;
+
+	get_online_cpus();
+	preempt_disable();
+	if (is_swapped(addr)) {
+		size = PAGE_SIZE - (addr & ~PAGE_MASK);
+		bounce = (void *) __get_free_page(GFP_ATOMIC);
+		if (bounce)
+			memcpy_real(bounce, (void *) get_swapped(addr), size);
+	}
+	preempt_enable();
+	put_online_cpus();
+	return bounce;
+}
+
+/*
+ * Free converted buffer for /dev/mem access (if necessary)
+ */
+void unxlate_dev_mem_ptr(unsigned long addr, void *buf)
+{
+	if ((void *) addr != buf)
+		free_page((unsigned long) buf);
+}
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 6e765bf..a3db5a3 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -822,6 +822,8 @@ int s390_enable_sie(void)
 
 	/* we copy the mm and let dup_mm create the page tables with_pgstes */
 	tsk->mm->context.alloc_pgste = 1;
+	/* make sure that both mms have a correct rss state */
+	sync_mm_rss(tsk->mm);
 	mm = dup_mm(tsk);
 	tsk->mm->context.alloc_pgste = 0;
 	if (!mm)
diff --git a/block/partitions/ibm.c b/block/partitions/ibm.c
index d513a07..1104aca 100644
--- a/block/partitions/ibm.c
+++ b/block/partitions/ibm.c
@@ -253,7 +253,7 @@ int ibm_partition(struct parsed_partitions *state)
 				/* Are we not supposed to report this ? */
 				goto out_readerr;
 		} else
-			printk(KERN_WARNING "Warning, expected Label VOL1 not "
+			printk(KERN_INFO "Expected Label VOL1 not "
 			       "found, treating as CDL formated Disk");
 
 	}
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ab9abb4..faf6c7c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -111,6 +111,7 @@ config CRYPTO_DES_S390
 	depends on S390
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_DES
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 231a1d8..3650636 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -352,7 +352,17 @@ out:
 
 static int sclp_assign_storage(u16 rn)
 {
-	return do_assign_storage(0x000d0001, rn);
+	unsigned long long start, address;
+	int rc;
+
+	rc = do_assign_storage(0x000d0001, rn);
+	if (rc)
+		goto out;
+	start = address = rn2addr(rn);
+	for (; address < start + rzm; address += PAGE_SIZE)
+		page_set_storage_key(address, PAGE_DEFAULT_KEY, 0);
+out:
+	return rc;
 }
 
 static int sclp_unassign_storage(u16 rn)
diff --git a/drivers/s390/char/tape.h b/drivers/s390/char/tape.h
index 267b54e..bc6c7cf 100644
--- a/drivers/s390/char/tape.h
+++ b/drivers/s390/char/tape.h
@@ -154,12 +154,6 @@ struct tape_discipline {
 	struct tape_request *(*read_block)(struct tape_device *, size_t);
 	struct tape_request *(*write_block)(struct tape_device *, size_t);
 	void (*process_eov)(struct tape_device*);
-#ifdef CONFIG_S390_TAPE_BLOCK
-	/* Block device stuff. */
-	struct tape_request *(*bread)(struct tape_device *, struct request *);
-	void (*check_locate)(struct tape_device *, struct tape_request *);
-	void (*free_bread)(struct tape_request *);
-#endif
 	/* ioctl function for additional ioctls. */
 	int (*ioctl_fn)(struct tape_device *, unsigned int, unsigned long);
 	/* Array of tape commands with TAPE_NR_MTOPS entries */
@@ -182,26 +176,6 @@ struct tape_char_data {
 	int block_size;			/*   of size block_size. */
 };
 
-#ifdef CONFIG_S390_TAPE_BLOCK
-/* Block Frontend Data */
-struct tape_blk_data
-{
-	struct tape_device *	device;
-	/* Block device request queue. */
-	struct request_queue *	request_queue;
-	spinlock_t		request_queue_lock;
-
-	/* Task to move entries from block request to CCS request queue. */
-	struct work_struct	requeue_task;
-	atomic_t		requeue_scheduled;
-
-	/* Current position on the tape. */
-	long			block_position;
-	int			medium_changed;
-	struct gendisk *	disk;
-};
-#endif
-
 /* Tape Info */
 struct tape_device {
 	/* entry in tape_device_list */
@@ -248,10 +222,6 @@ struct tape_device {
 
 	/* Character device frontend data */
 	struct tape_char_data		char_data;
-#ifdef CONFIG_S390_TAPE_BLOCK
-	/* Block dev frontend data */
-	struct tape_blk_data		blk_data;
-#endif
 
 	/* Function to start or stop the next request later. */
 	struct delayed_work		tape_dnr;
@@ -313,19 +283,6 @@ extern void tapechar_exit(void);
 extern int  tapechar_setup_device(struct tape_device *);
 extern void tapechar_cleanup_device(struct tape_device *);
 
-/* Externals from tape_block.c */
-#ifdef CONFIG_S390_TAPE_BLOCK
-extern int tapeblock_init (void);
-extern void tapeblock_exit(void);
-extern int tapeblock_setup_device(struct tape_device *);
-extern void tapeblock_cleanup_device(struct tape_device *);
-#else
-static inline int tapeblock_init (void) {return 0;}
-static inline void tapeblock_exit (void) {;}
-static inline int tapeblock_setup_device(struct tape_device *t) {return 0;}
-static inline void tapeblock_cleanup_device (struct tape_device *t) {;}
-#endif
-
 /* tape initialisation functions */
 #ifdef CONFIG_PROC_FS
 extern void tape_proc_init (void);
diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
index 934ef33..b28de80 100644
--- a/drivers/s390/char/tape_34xx.c
+++ b/drivers/s390/char/tape_34xx.c
@@ -323,20 +323,6 @@ tape_34xx_unit_check(struct tape_device *device, struct tape_request *request,
 	inhibit_cu_recovery = (*device->modeset_byte & 0x80) ? 1 : 0;
 	sense = irb->ecw;
 
-#ifdef CONFIG_S390_TAPE_BLOCK
-	if (request->op == TO_BLOCK) {
-		/*
-		 * Recovery for block device requests. Set the block_position
-		 * to something invalid and retry.
-		 */
-		device->blk_data.block_position = -1;
-		if (request->retries-- <= 0)
-			return tape_34xx_erp_failed(request, -EIO);
-		else
-			return tape_34xx_erp_retry(request);
-	}
-#endif
-
 	if (
 		sense[0] & SENSE_COMMAND_REJECT &&
 		sense[1] & SENSE_WRITE_PROTECT
@@ -1129,123 +1115,6 @@ tape_34xx_mtseek(struct tape_device *device, int mt_count)
 	return tape_do_io_free(device, request);
 }
 
-#ifdef CONFIG_S390_TAPE_BLOCK
-/*
- * Tape block read for 34xx.
- */
-static struct tape_request *
-tape_34xx_bread(struct tape_device *device, struct request *req)
-{
-	struct tape_request *request;
-	struct ccw1 *ccw;
-	int count = 0;
-	unsigned off;
-	char *dst;
-	struct bio_vec *bv;
-	struct req_iterator iter;
-	struct tape_34xx_block_id *	start_block;
-
-	DBF_EVENT(6, "xBREDid:");
-
-	/* Count the number of blocks for the request. */
-	rq_for_each_segment(bv, req, iter)
-		count += bv->bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
-
-	/* Allocate the ccw request. */
-	request = tape_alloc_request(3+count+1, 8);
-	if (IS_ERR(request))
-		return request;
-
-	/* Setup ccws. */
-	request->op = TO_BLOCK;
-	start_block = (struct tape_34xx_block_id *) request->cpdata;
-	start_block->block = blk_rq_pos(req) >> TAPEBLOCK_HSEC_S2B;
-	DBF_EVENT(6, "start_block = %i\n", start_block->block);
-
-	ccw = request->cpaddr;
-	ccw = tape_ccw_cc(ccw, MODE_SET_DB, 1, device->modeset_byte);
-
-	/*
-	 * We always setup a nop after the mode set ccw. This slot is
-	 * used in tape_std_check_locate to insert a locate ccw if the
-	 * current tape position doesn't match the start block to be read.
-	 * The second nop will be filled with a read block id which is in
-	 * turn used by tape_34xx_free_bread to populate the segment bid
-	 * table.
-	 */
-	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
-	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
-
-	rq_for_each_segment(bv, req, iter) {
-		dst = kmap(bv->bv_page) + bv->bv_offset;
-		for (off = 0; off < bv->bv_len; off += TAPEBLOCK_HSEC_SIZE) {
-			ccw->flags = CCW_FLAG_CC;
-			ccw->cmd_code = READ_FORWARD;
-			ccw->count = TAPEBLOCK_HSEC_SIZE;
-			set_normalized_cda(ccw, (void*) __pa(dst));
-			ccw++;
-			dst += TAPEBLOCK_HSEC_SIZE;
-		}
-	}
-
-	ccw = tape_ccw_end(ccw, NOP, 0, NULL);
-	DBF_EVENT(6, "xBREDccwg\n");
-	return request;
-}
-
-static void
-tape_34xx_free_bread (struct tape_request *request)
-{
-	struct ccw1* ccw;
-
-	ccw = request->cpaddr;
-	if ((ccw + 2)->cmd_code == READ_BLOCK_ID) {
-		struct {
-			struct tape_34xx_block_id	cbid;
-			struct tape_34xx_block_id	dbid;
-		} __attribute__ ((packed)) *rbi_data;
-
-		rbi_data = request->cpdata;
-
-		if (request->device)
-			tape_34xx_add_sbid(request->device, rbi_data->cbid);
-	}
-
-	/* Last ccw is a nop and doesn't need clear_normalized_cda */
-	for (; ccw->flags & CCW_FLAG_CC; ccw++)
-		if (ccw->cmd_code == READ_FORWARD)
-			clear_normalized_cda(ccw);
-	tape_free_request(request);
-}
-
-/*
- * check_locate is called just before the tape request is passed to
- * the common io layer for execution. It has to check the current
- * tape position and insert a locate ccw if it doesn't match the
- * start block for the request.
- */
-static void
-tape_34xx_check_locate(struct tape_device *device, struct tape_request *request)
-{
-	struct tape_34xx_block_id *	start_block;
-
-	start_block = (struct tape_34xx_block_id *) request->cpdata;
-	if (start_block->block == device->blk_data.block_position)
-		return;
-
-	DBF_LH(4, "Block seek(%06d+%06d)\n", start_block->block, device->bof);
-	start_block->wrap    = 0;
-	start_block->segment = 1;
-	start_block->format  = (*device->modeset_byte & 0x08) ?
-				TAPE34XX_FMT_3480_XF :
-				TAPE34XX_FMT_3480;
-	start_block->block   = start_block->block + device->bof;
-	tape_34xx_merge_sbid(device, start_block);
-	tape_ccw_cc(request->cpaddr + 1, LOCATE, 4, request->cpdata);
-	tape_ccw_cc(request->cpaddr + 2, READ_BLOCK_ID, 8, request->cpdata);
-}
-#endif
-
 /*
  * List of 3480/3490 magnetic tape commands.
  */
@@ -1295,11 +1164,6 @@ static struct tape_discipline tape_discipline_34xx = {
 	.irq = tape_34xx_irq,
 	.read_block = tape_std_read_block,
 	.write_block = tape_std_write_block,
-#ifdef CONFIG_S390_TAPE_BLOCK
-	.bread = tape_34xx_bread,
-	.free_bread = tape_34xx_free_bread,
-	.check_locate = tape_34xx_check_locate,
-#endif
 	.ioctl_fn = tape_34xx_ioctl,
 	.mtop_array = tape_34xx_mtop
 };
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index 49c6aab..a5c6614 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -670,92 +670,6 @@ tape_3590_schedule_work(struct tape_device *device, enum tape_op op)
 	return 0;
 }
 
-#ifdef CONFIG_S390_TAPE_BLOCK
-/*
- * Tape Block READ
- */
-static struct tape_request *
-tape_3590_bread(struct tape_device *device, struct request *req)
-{
-	struct tape_request *request;
-	struct ccw1 *ccw;
-	int count = 0, start_block;
-	unsigned off;
-	char *dst;
-	struct bio_vec *bv;
-	struct req_iterator iter;
-
-	DBF_EVENT(6, "xBREDid:");
-	start_block = blk_rq_pos(req) >> TAPEBLOCK_HSEC_S2B;
-	DBF_EVENT(6, "start_block = %i\n", start_block);
-
-	rq_for_each_segment(bv, req, iter)
-		count += bv->bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
-
-	request = tape_alloc_request(2 + count + 1, 4);
-	if (IS_ERR(request))
-		return request;
-	request->op = TO_BLOCK;
-	*(__u32 *) request->cpdata = start_block;
-	ccw = request->cpaddr;
-	ccw = tape_ccw_cc(ccw, MODE_SET_DB, 1, device->modeset_byte);
-
-	/*
-	 * We always setup a nop after the mode set ccw. This slot is
-	 * used in tape_std_check_locate to insert a locate ccw if the
-	 * current tape position doesn't match the start block to be read.
-	 */
-	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
-
-	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
-		for (off = 0; off < bv->bv_len; off += TAPEBLOCK_HSEC_SIZE) {
-			ccw->flags = CCW_FLAG_CC;
-			ccw->cmd_code = READ_FORWARD;
-			ccw->count = TAPEBLOCK_HSEC_SIZE;
-			set_normalized_cda(ccw, (void *) __pa(dst));
-			ccw++;
-			dst += TAPEBLOCK_HSEC_SIZE;
-		}
-		BUG_ON(off > bv->bv_len);
-	}
-	ccw = tape_ccw_end(ccw, NOP, 0, NULL);
-	DBF_EVENT(6, "xBREDccwg\n");
-	return request;
-}
-
-static void
-tape_3590_free_bread(struct tape_request *request)
-{
-	struct ccw1 *ccw;
-
-	/* Last ccw is a nop and doesn't need clear_normalized_cda */
-	for (ccw = request->cpaddr; ccw->flags & CCW_FLAG_CC; ccw++)
-		if (ccw->cmd_code == READ_FORWARD)
-			clear_normalized_cda(ccw);
-	tape_free_request(request);
-}
-
-/*
- * check_locate is called just before the tape request is passed to
- * the common io layer for execution. It has to check the current
- * tape position and insert a locate ccw if it doesn't match the
- * start block for the request.
- */
-static void
-tape_3590_check_locate(struct tape_device *device, struct tape_request *request)
-{
-	__u32 *start_block;
-
-	start_block = (__u32 *) request->cpdata;
-	if (*start_block != device->blk_data.block_position) {
-		/* Add the start offset of the file to get the real block. */
-		*start_block += device->bof;
-		tape_ccw_cc(request->cpaddr + 1, LOCATE, 4, request->cpdata);
-	}
-}
-#endif
-
 static void tape_3590_med_state_set(struct tape_device *device,
 				    struct tape_3590_med_sense *sense)
 {
@@ -1423,20 +1337,6 @@ tape_3590_unit_check(struct tape_device *device, struct tape_request *request,
 {
 	struct tape_3590_sense *sense;
 
-#ifdef CONFIG_S390_TAPE_BLOCK
-	if (request->op == TO_BLOCK) {
-		/*
-		 * Recovery for block device requests. Set the block_position
-		 * to something invalid and retry.
-		 */
-		device->blk_data.block_position = -1;
-		if (request->retries-- <= 0)
-			return tape_3590_erp_failed(device, request, irb, -EIO);
-		else
-			return tape_3590_erp_retry(device, request, irb);
-	}
-#endif
-
 	sense = (struct tape_3590_sense *) irb->ecw;
 
 	DBF_EVENT(6, "Unit Check: RQC = %x\n", sense->rc_rqc);
@@ -1729,11 +1629,6 @@ static struct tape_discipline tape_discipline_3590 = {
 	.irq = tape_3590_irq,
 	.read_block = tape_std_read_block,
 	.write_block = tape_std_write_block,
-#ifdef CONFIG_S390_TAPE_BLOCK
-	.bread = tape_3590_bread,
-	.free_bread = tape_3590_free_bread,
-	.check_locate = tape_3590_check_locate,
-#endif
 	.ioctl_fn = tape_3590_ioctl,
 	.mtop_array = tape_3590_mtop
 };
diff --git a/drivers/s390/char/tape_char.c b/drivers/s390/char/tape_char.c
index 87cd0ab..46886a7 100644
--- a/drivers/s390/char/tape_char.c
+++ b/drivers/s390/char/tape_char.c
@@ -161,11 +161,6 @@ tapechar_read(struct file *filp, char __user *data, size_t count, loff_t *ppos)
 	if (rc)
 		return rc;
 
-#ifdef CONFIG_S390_TAPE_BLOCK
-	/* Changes position. */
-	device->blk_data.medium_changed = 1;
-#endif
-
 	DBF_EVENT(6, "TCHAR:nbytes: %lx\n", block_size);
 	/* Let the discipline build the ccw chain. */
 	request = device->discipline->read_block(device, block_size);
@@ -218,11 +213,6 @@ tapechar_write(struct file *filp, const char __user *data, size_t count, loff_t
 	if (rc)
 		return rc;
 
-#ifdef CONFIG_S390_TAPE_BLOCK
-	/* Changes position. */
-	device->blk_data.medium_changed = 1;
-#endif
-
 	DBF_EVENT(6,"TCHAR:nbytes: %lx\n", block_size);
 	DBF_EVENT(6, "TCHAR:nblocks: %x\n", nblocks);
 	/* Let the discipline build the ccw chain. */
@@ -379,9 +369,6 @@ __tapechar_ioctl(struct tape_device *device,
 			case MTBSFM:
 			case MTFSFM:
 			case MTSEEK:
-#ifdef CONFIG_S390_TAPE_BLOCK
-				device->blk_data.medium_changed = 1;
-#endif
 				if (device->required_tapemarks)
 					tape_std_terminate_write(device);
 			default:
diff --git a/drivers/s390/char/tape_core.c b/drivers/s390/char/tape_core.c
index b3a3e8e..5856186 100644
--- a/drivers/s390/char/tape_core.c
+++ b/drivers/s390/char/tape_core.c
@@ -401,9 +401,6 @@ tape_generic_online(struct tape_device *device,
 	rc = tapechar_setup_device(device);
 	if (rc)
 		goto out_minor;
-	rc = tapeblock_setup_device(device);
-	if (rc)
-		goto out_char;
 
 	tape_state_set(device, TS_UNUSED);
 
@@ -411,8 +408,6 @@ tape_generic_online(struct tape_device *device,
 
 	return 0;
 
-out_char:
-	tapechar_cleanup_device(device);
 out_minor:
 	tape_remove_minor(device);
 out_discipline:
@@ -426,7 +421,6 @@ out:
 static void
 tape_cleanup_device(struct tape_device *device)
 {
-	tapeblock_cleanup_device(device);
 	tapechar_cleanup_device(device);
 	device->discipline->cleanup_device(device);
 	module_put(device->discipline->owner);
@@ -785,10 +779,6 @@ __tape_start_io(struct tape_device *device, struct tape_request *request)
 {
 	int rc;
 
-#ifdef CONFIG_S390_TAPE_BLOCK
-	if (request->op == TO_BLOCK)
-		device->discipline->check_locate(device, request);
-#endif
 	rc = ccw_device_start(
 		device->cdev,
 		request->cpaddr,
@@ -1253,7 +1243,7 @@ __tape_do_irq (struct ccw_device *cdev, unsigned long intparm, struct irb *irb)
 }
 
 /*
- * Tape device open function used by tape_char & tape_block frontends.
+ * Tape device open function used by tape_char frontend.
  */
 int
 tape_open(struct tape_device *device)
@@ -1283,7 +1273,7 @@ tape_open(struct tape_device *device)
 }
 
 /*
- * Tape device release function used by tape_char & tape_block frontends.
+ * Tape device release function used by tape_char frontend.
  */
 int
 tape_release(struct tape_device *device)
@@ -1344,7 +1334,6 @@ tape_init (void)
 	DBF_EVENT(3, "tape init\n");
 	tape_proc_init();
 	tapechar_init ();
-	tapeblock_init ();
 	return 0;
 }
 
@@ -1358,7 +1347,6 @@ tape_exit(void)
 
 	/* Get rid of the frontends */
 	tapechar_exit();
-	tapeblock_exit();
 	tape_proc_cleanup();
 	debug_unregister (TAPE_DBF_AREA);
 }
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 5f1dc6f..731470e 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -1,7 +1,7 @@
 /*
  *  bus driver for ccwgroup
  *
- *  Copyright IBM Corp. 2002, 2009
+ *  Copyright IBM Corp. 2002, 2012
  *
  *  Author(s): Arnd Bergmann (arndb@de.ibm.com)
  *	       Cornelia Huck (cornelia.huck@de.ibm.com)
@@ -15,10 +15,13 @@
 #include <linux/ctype.h>
 #include <linux/dcache.h>
 
+#include <asm/cio.h>
 #include <asm/ccwdev.h>
 #include <asm/ccwgroup.h>
 
-#define CCW_BUS_ID_SIZE		20
+#include "device.h"
+
+#define CCW_BUS_ID_SIZE		10
 
 /* In Linux 2.4, we had a channel device layer called "chandev"
  * that did all sorts of obscure stuff for networking devices.
@@ -27,19 +30,6 @@
  * to devices that use multiple subchannels.
  */
 
-/* a device matches a driver if all its slave devices match the same
- * entry of the driver */
-static int ccwgroup_bus_match(struct device *dev, struct device_driver * drv)
-{
-	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
-	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(drv);
-
-	if (gdev->creator_id == gdrv->driver_id)
-		return 1;
-
-	return 0;
-}
-
 static struct bus_type ccwgroup_bus_type;
 
 static void __ccwgroup_remove_symlinks(struct ccwgroup_device *gdev)
@@ -254,9 +244,10 @@ static int __ccwgroup_create_symlinks(struct ccwgroup_device *gdev)
 	return 0;
 }
 
-static int __get_next_bus_id(const char **buf, char *bus_id)
+static int __get_next_id(const char **buf, struct ccw_dev_id *id)
 {
-	int rc, len;
+	unsigned int cssid, ssid, devno;
+	int ret = 0, len;
 	char *start, *end;
 
 	start = (char *)*buf;
@@ -271,49 +262,40 @@ static int __get_next_bus_id(const char **buf, char *bus_id)
 		len = end - start + 1;
 		end++;
 	}
-	if (len < CCW_BUS_ID_SIZE) {
-		strlcpy(bus_id, start, len);
-		rc = 0;
+	if (len <= CCW_BUS_ID_SIZE) {
+		if (sscanf(start, "%2x.%1x.%04x", &cssid, &ssid, &devno) != 3)
+			ret = -EINVAL;
 	} else
-		rc = -EINVAL;
-	*buf = end;
-	return rc;
-}
-
-static int __is_valid_bus_id(char bus_id[CCW_BUS_ID_SIZE])
-{
-	int cssid, ssid, devno;
+		ret = -EINVAL;
 
-	/* Must be of form %x.%x.%04x */
-	if (sscanf(bus_id, "%x.%1x.%04x", &cssid, &ssid, &devno) != 3)
-		return 0;
-	return 1;
+	if (!ret) {
+		id->ssid = ssid;
+		id->devno = devno;
+	}
+	*buf = end;
+	return ret;
 }
 
 /**
- * ccwgroup_create_from_string() - create and register a ccw group device
- * @root: parent device for the new device
- * @creator_id: identifier of creating driver
- * @cdrv: ccw driver of slave devices
+ * ccwgroup_create_dev() - create and register a ccw group device
+ * @parent: parent device for the new device
+ * @gdrv: driver for the new group device
  * @num_devices: number of slave devices
  * @buf: buffer containing comma separated bus ids of slave devices
  *
- * Create and register a new ccw group device as a child of @root. Slave
- * devices are obtained from the list of bus ids given in @buf and must all
- * belong to @cdrv.
+ * Create and register a new ccw group device as a child of @parent. Slave
+ * devices are obtained from the list of bus ids given in @buf.
  * Returns:
  *  %0 on success and an error code on failure.
  * Context:
  *  non-atomic
  */
-int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
-				struct ccw_driver *cdrv, int num_devices,
-				const char *buf)
+int ccwgroup_create_dev(struct device *parent, struct ccwgroup_driver *gdrv,
+			int num_devices, const char *buf)
 {
 	struct ccwgroup_device *gdev;
+	struct ccw_dev_id dev_id;
 	int rc, i;
-	char tmp_bus_id[CCW_BUS_ID_SIZE];
-	const char *curr_buf;
 
 	gdev = kzalloc(sizeof(*gdev) + num_devices * sizeof(gdev->cdev[0]),
 		       GFP_KERNEL);
@@ -323,29 +305,24 @@ int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
 	atomic_set(&gdev->onoff, 0);
 	mutex_init(&gdev->reg_mutex);
 	mutex_lock(&gdev->reg_mutex);
-	gdev->creator_id = creator_id;
 	gdev->count = num_devices;
 	gdev->dev.bus = &ccwgroup_bus_type;
-	gdev->dev.parent = root;
+	gdev->dev.parent = parent;
 	gdev->dev.release = ccwgroup_release;
 	device_initialize(&gdev->dev);
 
-	curr_buf = buf;
-	for (i = 0; i < num_devices && curr_buf; i++) {
-		rc = __get_next_bus_id(&curr_buf, tmp_bus_id);
+	for (i = 0; i < num_devices && buf; i++) {
+		rc = __get_next_id(&buf, &dev_id);
 		if (rc != 0)
 			goto error;
-		if (!__is_valid_bus_id(tmp_bus_id)) {
-			rc = -EINVAL;
-			goto error;
-		}
-		gdev->cdev[i] = get_ccwdev_by_busid(cdrv, tmp_bus_id);
+		gdev->cdev[i] = get_ccwdev_by_dev_id(&dev_id);
 		/*
 		 * All devices have to be of the same type in
 		 * order to be grouped.
 		 */
-		if (!gdev->cdev[i]
-		    || gdev->cdev[i]->id.driver_info !=
+		if (!gdev->cdev[i] || !gdev->cdev[i]->drv ||
+		    gdev->cdev[i]->drv != gdev->cdev[0]->drv ||
+		    gdev->cdev[i]->id.driver_info !=
 		    gdev->cdev[0]->id.driver_info) {
 			rc = -EINVAL;
 			goto error;
@@ -361,18 +338,25 @@ int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
 		spin_unlock_irq(gdev->cdev[i]->ccwlock);
 	}
 	/* Check for sufficient number of bus ids. */
-	if (i < num_devices && !curr_buf) {
+	if (i < num_devices) {
 		rc = -EINVAL;
 		goto error;
 	}
 	/* Check for trailing stuff. */
-	if (i == num_devices && strlen(curr_buf) > 0) {
+	if (i == num_devices && strlen(buf) > 0) {
 		rc = -EINVAL;
 		goto error;
 	}
 
 	dev_set_name(&gdev->dev, "%s", dev_name(&gdev->cdev[0]->dev));
 	gdev->dev.groups = ccwgroup_attr_groups;
+
+	if (gdrv) {
+		gdev->dev.driver = &gdrv->driver;
+		rc = gdrv->setup ? gdrv->setup(gdev) : 0;
+		if (rc)
+			goto error;
+	}
 	rc = device_add(&gdev->dev);
 	if (rc)
 		goto error;
@@ -397,7 +381,7 @@ error:
 	put_device(&gdev->dev);
 	return rc;
 }
-EXPORT_SYMBOL(ccwgroup_create_from_string);
+EXPORT_SYMBOL(ccwgroup_create_dev);
 
 static int ccwgroup_notifier(struct notifier_block *nb, unsigned long action,
 			     void *data)
@@ -440,14 +424,6 @@ module_exit(cleanup_ccwgroup);
 
 /************************** driver stuff ******************************/
 
-static int ccwgroup_probe(struct device *dev)
-{
-	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
-	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(dev->driver);
-
-	return gdrv->probe ? gdrv->probe(gdev) : -ENODEV;
-}
-
 static int ccwgroup_remove(struct device *dev)
 {
 	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
@@ -542,8 +518,6 @@ static const struct dev_pm_ops ccwgroup_pm_ops = {
 
 static struct bus_type ccwgroup_bus_type = {
 	.name   = "ccwgroup",
-	.match  = ccwgroup_bus_match,
-	.probe  = ccwgroup_probe,
 	.remove = ccwgroup_remove,
 	.shutdown = ccwgroup_shutdown,
 	.pm = &ccwgroup_pm_ops,
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index a49c46c..a6ddaed 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -656,51 +656,34 @@ static struct io_subchannel_private console_priv;
 static int console_subchannel_in_use;
 
 /*
- * Use cio_tpi to get a pending interrupt and call the interrupt handler.
- * Return non-zero if an interrupt was processed, zero otherwise.
+ * Use cio_tsch to update the subchannel status and call the interrupt handler
+ * if status had been pending. Called with the console_subchannel lock.
  */
-static int cio_tpi(void)
+static void cio_tsch(struct subchannel *sch)
 {
-	struct tpi_info *tpi_info;
-	struct subchannel *sch;
 	struct irb *irb;
 	int irq_context;
 
-	tpi_info = (struct tpi_info *)&S390_lowcore.subchannel_id;
-	if (tpi(NULL) != 1)
-		return 0;
-	kstat_cpu(smp_processor_id()).irqs[IO_INTERRUPT]++;
-	if (tpi_info->adapter_IO) {
-		do_adapter_IO(tpi_info->isc);
-		return 1;
-	}
 	irb = (struct irb *)&S390_lowcore.irb;
 	/* Store interrupt response block to lowcore. */
-	if (tsch(tpi_info->schid, irb) != 0) {
+	if (tsch(sch->schid, irb) != 0)
 		/* Not status pending or not operational. */
-		kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
-		return 1;
-	}
-	sch = (struct subchannel *)(unsigned long)tpi_info->intparm;
-	if (!sch) {
-		kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
-		return 1;
-	}
+		return;
+	memcpy(&sch->schib.scsw, &irb->scsw, sizeof(union scsw));
+	/* Call interrupt handler with updated status. */
 	irq_context = in_interrupt();
-	if (!irq_context)
+	if (!irq_context) {
 		local_bh_disable();
-	irq_enter();
-	spin_lock(sch->lock);
-	memcpy(&sch->schib.scsw, &irb->scsw, sizeof(union scsw));
+		irq_enter();
+	}
 	if (sch->driver && sch->driver->irq)
 		sch->driver->irq(sch);
 	else
 		kstat_cpu(smp_processor_id()).irqs[IOINT_CIO]++;
-	spin_unlock(sch->lock);
-	irq_exit();
-	if (!irq_context)
+	if (!irq_context) {
+		irq_exit();
 		_local_bh_enable();
-	return 1;
+	}
 }
 
 void *cio_get_console_priv(void)
@@ -712,34 +695,16 @@ void *cio_get_console_priv(void)
  * busy wait for the next interrupt on the console
  */
 void wait_cons_dev(void)
-	__releases(console_subchannel.lock)
-	__acquires(console_subchannel.lock)
 {
-	unsigned long cr6      __attribute__ ((aligned (8)));
-	unsigned long save_cr6 __attribute__ ((aligned (8)));
-
-	/* 
-	 * before entering the spinlock we may already have
-	 * processed the interrupt on a different CPU...
-	 */
 	if (!console_subchannel_in_use)
 		return;
 
-	/* disable all but the console isc */
-	__ctl_store (save_cr6, 6, 6);
-	cr6 = 1UL << (31 - CONSOLE_ISC);
-	__ctl_load (cr6, 6, 6);
-
-	do {
-		spin_unlock(console_subchannel.lock);
-		if (!cio_tpi())
-			cpu_relax();
-		spin_lock(console_subchannel.lock);
-	} while (console_subchannel.schib.scsw.cmd.actl != 0);
-	/*
-	 * restore previous isc value
-	 */
-	__ctl_load (save_cr6, 6, 6);
+	while (1) {
+		cio_tsch(&console_subchannel);
+		if (console_subchannel.schib.scsw.cmd.actl == 0)
+			break;
+		udelay_simple(100);
+	}
 }
 
 static int
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 02d0152..f8f952d 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -695,7 +695,17 @@ static int match_dev_id(struct device *dev, void *data)
 	return ccw_dev_id_is_equal(&cdev->private->dev_id, dev_id);
 }
 
-static struct ccw_device *get_ccwdev_by_dev_id(struct ccw_dev_id *dev_id)
+/**
+ * get_ccwdev_by_dev_id() - obtain device from a ccw device id
+ * @dev_id: id of the device to be searched
+ *
+ * This function searches all devices attached to the ccw bus for a device
+ * matching @dev_id.
+ * Returns:
+ *  If a device is found its reference count is increased and returned;
+ *  else %NULL is returned.
+ */
+struct ccw_device *get_ccwdev_by_dev_id(struct ccw_dev_id *dev_id)
 {
 	struct device *dev;
 
@@ -703,6 +713,7 @@ static struct ccw_device *get_ccwdev_by_dev_id(struct ccw_dev_id *dev_id)
 
 	return dev ? to_ccwdev(dev) : NULL;
 }
+EXPORT_SYMBOL_GPL(get_ccwdev_by_dev_id);
 
 static void ccw_device_do_unbind_bind(struct ccw_device *cdev)
 {
diff --git a/drivers/s390/cio/device.h b/drivers/s390/cio/device.h
index 179824b..6bace69 100644
--- a/drivers/s390/cio/device.h
+++ b/drivers/s390/cio/device.h
@@ -101,6 +101,7 @@ int ccw_device_test_sense_data(struct ccw_device *);
 void ccw_device_schedule_sch_unregister(struct ccw_device *);
 int ccw_purge_blacklisted(void);
 void ccw_device_sched_todo(struct ccw_device *cdev, enum cdev_todo todo);
+struct ccw_device *get_ccwdev_by_dev_id(struct ccw_dev_id *dev_id);
 
 /* Function prototypes for device status and basic sense stuff. */
 void ccw_device_accumulate_irb(struct ccw_device *, struct irb *);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 35c685c..7493efa 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -63,7 +63,7 @@ static inline int do_siga_input(unsigned long schid, unsigned int mask,
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
 		: "=d" (cc)
-		: "d" (__fc), "d" (__schid), "d" (__mask) : "cc", "memory");
+		: "d" (__fc), "d" (__schid), "d" (__mask) : "cc");
 	return cc;
 }
 
@@ -74,7 +74,7 @@ static inline int do_siga_input(unsigned long schid, unsigned int mask,
  * @bb: busy bit indicator, set only if SIGA-w/wt could not access a buffer
  * @fc: function code to perform
  *
- * Returns cc or QDIO_ERROR_SIGA_ACCESS_EXCEPTION.
+ * Returns condition code.
  * Note: For IQDC unicast queues only the highest priority queue is processed.
  */
 static inline int do_siga_output(unsigned long schid, unsigned long mask,
@@ -85,18 +85,16 @@ static inline int do_siga_output(unsigned long schid, unsigned long mask,
 	register unsigned long __schid asm("1") = schid;
 	register unsigned long __mask asm("2") = mask;
 	register unsigned long __aob asm("3") = aob;
-	int cc = QDIO_ERROR_SIGA_ACCESS_EXCEPTION;
+	int cc;
 
 	asm volatile(
 		"	siga	0\n"
-		"0:	ipm	%0\n"
+		"	ipm	%0\n"
 		"	srl	%0,28\n"
-		"1:\n"
-		EX_TABLE(0b, 1b)
-		: "+d" (cc), "+d" (__fc), "+d" (__schid), "+d" (__mask),
-		  "+d" (__aob)
-		: : "cc", "memory");
-	*bb = ((unsigned int) __fc) >> 31;
+		: "=d" (cc), "+d" (__fc), "+d" (__aob)
+		: "d" (__schid), "d" (__mask)
+		: "cc");
+	*bb = __fc >> 31;
 	return cc;
 }
 
@@ -167,7 +165,7 @@ again:
 
 	DBF_ERROR("%4x EQBS ERROR", SCH_NO(q));
 	DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
-	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
+	q->handler(q->irq_ptr->cdev, QDIO_ERROR_GET_BUF_STATE,
 		   q->nr, q->first_to_kick, count, q->irq_ptr->int_parm);
 	return 0;
 }
@@ -215,7 +213,7 @@ again:
 
 	DBF_ERROR("%4x SQBS ERROR", SCH_NO(q));
 	DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
-	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
+	q->handler(q->irq_ptr->cdev, QDIO_ERROR_SET_BUF_STATE,
 		   q->nr, q->first_to_kick, count, q->irq_ptr->int_parm);
 	return 0;
 }
@@ -313,7 +311,7 @@ static inline int qdio_siga_sync(struct qdio_q *q, unsigned int output,
 	cc = do_siga_sync(schid, output, input, fc);
 	if (unlikely(cc))
 		DBF_ERROR("%4x SIGA-S:%2d", SCH_NO(q), cc);
-	return cc;
+	return (cc) ? -EIO : 0;
 }
 
 static inline int qdio_siga_sync_q(struct qdio_q *q)
@@ -384,7 +382,7 @@ static inline int qdio_siga_input(struct qdio_q *q)
 	cc = do_siga_input(schid, q->mask, fc);
 	if (unlikely(cc))
 		DBF_ERROR("%4x SIGA-R:%2d", SCH_NO(q), cc);
-	return cc;
+	return (cc) ? -EIO : 0;
 }
 
 #define qdio_siga_sync_out(q) qdio_siga_sync(q, ~0U, 0)
@@ -443,7 +441,7 @@ static void process_buffer_error(struct qdio_q *q, int count)
 	unsigned char state = (q->is_input_q) ? SLSB_P_INPUT_NOT_INIT :
 					SLSB_P_OUTPUT_NOT_INIT;
 
-	q->qdio_error |= QDIO_ERROR_SLSB_STATE;
+	q->qdio_error = QDIO_ERROR_SLSB_STATE;
 
 	/* special handling for no target buffer empty */
 	if ((!q->is_input_q &&
@@ -519,7 +517,7 @@ static int get_inbound_buffer_frontier(struct qdio_q *q)
 	int count, stop;
 	unsigned char state = 0;
 
-	q->timestamp = get_clock_fast();
+	q->timestamp = get_clock();
 
 	/*
 	 * Don't check 128 buffers, as otherwise qdio_inbound_q_moved
@@ -575,7 +573,7 @@ static int qdio_inbound_q_moved(struct qdio_q *q)
 
 	bufnr = get_inbound_buffer_frontier(q);
 
-	if ((bufnr != q->last_move) || q->qdio_error) {
+	if (bufnr != q->last_move) {
 		q->last_move = bufnr;
 		if (!is_thinint_irq(q->irq_ptr) && MACHINE_IS_LPAR)
 			q->u.in.timestamp = get_clock();
@@ -790,7 +788,7 @@ static int get_outbound_buffer_frontier(struct qdio_q *q)
 	int count, stop;
 	unsigned char state = 0;
 
-	q->timestamp = get_clock_fast();
+	q->timestamp = get_clock();
 
 	if (need_siga_sync(q))
 		if (((queue_type(q) != QDIO_IQDIO_QFMT) &&
@@ -863,7 +861,7 @@ static inline int qdio_outbound_q_moved(struct qdio_q *q)
 
 	bufnr = get_outbound_buffer_frontier(q);
 
-	if ((bufnr != q->last_move) || q->qdio_error) {
+	if (bufnr != q->last_move) {
 		q->last_move = bufnr;
 		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "out moved:%1d", q->nr);
 		return 1;
@@ -894,13 +892,16 @@ retry:
 				goto retry;
 			}
 			DBF_ERROR("%4x cc2 BBC:%1d", SCH_NO(q), q->nr);
-			cc |= QDIO_ERROR_SIGA_BUSY;
-		} else
+			cc = -EBUSY;
+		} else {
 			DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "siga-w cc2:%1d", q->nr);
+			cc = -ENOBUFS;
+		}
 		break;
 	case 1:
 	case 3:
 		DBF_ERROR("%4x SIGA-W:%1d", SCH_NO(q), cc);
+		cc = -EIO;
 		break;
 	}
 	if (retries) {
@@ -1090,7 +1091,7 @@ static void qdio_handle_activate_check(struct ccw_device *cdev,
 	}
 
 	count = sub_buf(q->first_to_check, q->first_to_kick);
-	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
+	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE,
 		   q->nr, q->first_to_kick, count, irq_ptr->int_parm);
 no_handler:
 	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_STOPPED);
@@ -1691,7 +1692,7 @@ int do_QDIO(struct ccw_device *cdev, unsigned int callflags,
 		      "do%02x b:%02x c:%02x", callflags, bufnr, count);
 
 	if (irq_ptr->state != QDIO_IRQ_STATE_ACTIVE)
-		return -EBUSY;
+		return -EIO;
 	if (!count)
 		return 0;
 	if (callflags & QDIO_FLAG_SYNC_INPUT)
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 7e9a72e..b987d46 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -215,7 +215,7 @@ ap_queue_interruption_control(ap_qid_t qid, void *ind)
 	register struct ap_queue_status reg1_out asm ("1");
 	register void *reg2 asm ("2") = ind;
 	asm volatile(
-		".long 0xb2af0000"		/* PQAP(RAPQ) */
+		".long 0xb2af0000"		/* PQAP(AQIC) */
 		: "+d" (reg0), "+d" (reg1_in), "=d" (reg1_out), "+d" (reg2)
 		:
 		: "cc" );
@@ -232,7 +232,7 @@ __ap_query_functions(ap_qid_t qid, unsigned int *functions)
 	register unsigned long reg2 asm ("2");
 
 	asm volatile(
-		".long 0xb2af0000\n"
+		".long 0xb2af0000\n"		/* PQAP(TAPQ) */
 		"0:\n"
 		EX_TABLE(0b, 0b)
 		: "+d" (reg0), "+d" (reg1), "=d" (reg2)
@@ -391,7 +391,7 @@ __ap_send(ap_qid_t qid, unsigned long long psmid, void *msg, size_t length,
 		reg0 |= 0x400000UL;
 
 	asm volatile (
-		"0: .long 0xb2ad0042\n"		/* DQAP */
+		"0: .long 0xb2ad0042\n"		/* NQAP */
 		"   brc   2,0b"
 		: "+d" (reg0), "=d" (reg1), "+d" (reg2), "+d" (reg3)
 		: "d" (reg4), "d" (reg5), "m" (*(msgblock *) msg)
@@ -450,7 +450,7 @@ __ap_recv(ap_qid_t qid, unsigned long long *psmid, void *msg, size_t length)
 
 
 	asm volatile(
-		"0: .long 0xb2ae0064\n"
+		"0: .long 0xb2ae0064\n"		/* DQAP */
 		"   brc   6,0b\n"
 		: "+d" (reg0), "=d" (reg1), "+d" (reg2),
 		"+d" (reg4), "+d" (reg5), "+d" (reg6), "+d" (reg7),
@@ -836,12 +836,12 @@ static void __ap_flush_queue(struct ap_device *ap_dev)
 	list_for_each_entry_safe(ap_msg, next, &ap_dev->pendingq, list) {
 		list_del_init(&ap_msg->list);
 		ap_dev->pendingq_count--;
-		ap_dev->drv->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
+		ap_msg->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
 	}
 	list_for_each_entry_safe(ap_msg, next, &ap_dev->requestq, list) {
 		list_del_init(&ap_msg->list);
 		ap_dev->requestq_count--;
-		ap_dev->drv->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
+		ap_msg->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
 	}
 }
 
@@ -1329,7 +1329,7 @@ static int ap_poll_read(struct ap_device *ap_dev, unsigned long *flags)
 				continue;
 			list_del_init(&ap_msg->list);
 			ap_dev->pendingq_count--;
-			ap_dev->drv->receive(ap_dev, ap_msg, ap_dev->reply);
+			ap_msg->receive(ap_dev, ap_msg, ap_dev->reply);
 			break;
 		}
 		if (ap_dev->queue_count > 0)
@@ -1450,10 +1450,10 @@ static int __ap_queue_message(struct ap_device *ap_dev, struct ap_message *ap_ms
 			return -EBUSY;
 		case AP_RESPONSE_REQ_FAC_NOT_INST:
 		case AP_RESPONSE_MESSAGE_TOO_BIG:
-			ap_dev->drv->receive(ap_dev, ap_msg, ERR_PTR(-EINVAL));
+			ap_msg->receive(ap_dev, ap_msg, ERR_PTR(-EINVAL));
 			return -EINVAL;
 		default:	/* Device is gone. */
-			ap_dev->drv->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
+			ap_msg->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
 			return -ENODEV;
 		}
 	} else {
@@ -1471,6 +1471,10 @@ void ap_queue_message(struct ap_device *ap_dev, struct ap_message *ap_msg)
 	unsigned long flags;
 	int rc;
 
+	/* For asynchronous message handling a valid receive-callback
+	 * is required. */
+	BUG_ON(!ap_msg->receive);
+
 	spin_lock_bh(&ap_dev->lock);
 	if (!ap_dev->unregistered) {
 		/* Make room on the queue by polling for finished requests. */
@@ -1482,7 +1486,7 @@ void ap_queue_message(struct ap_device *ap_dev, struct ap_message *ap_msg)
 		if (rc == -ENODEV)
 			ap_dev->unregistered = 1;
 	} else {
-		ap_dev->drv->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
+		ap_msg->receive(ap_dev, ap_msg, ERR_PTR(-ENODEV));
 		rc = -ENODEV;
 	}
 	spin_unlock_bh(&ap_dev->lock);
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index d960a63..726fc65 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -136,9 +136,6 @@ struct ap_driver {
 
 	int (*probe)(struct ap_device *);
 	void (*remove)(struct ap_device *);
-	/* receive is called from tasklet context */
-	void (*receive)(struct ap_device *, struct ap_message *,
-			struct ap_message *);
 	int request_timeout;		/* request timeout in jiffies */
 };
 
@@ -183,6 +180,9 @@ struct ap_message {
 
 	void *private;			/* ap driver private pointer. */
 	unsigned int special:1;		/* Used for special commands. */
+	/* receive is called from tasklet context */
+	void (*receive)(struct ap_device *, struct ap_message *,
+			struct ap_message *);
 };
 
 #define AP_DEVICE(dt)					\
@@ -199,6 +199,7 @@ static inline void ap_init_message(struct ap_message *ap_msg)
 	ap_msg->psmid = 0;
 	ap_msg->length = 0;
 	ap_msg->special = 0;
+	ap_msg->receive = NULL;
 }
 
 /*
diff --git a/drivers/s390/crypto/zcrypt_cex2a.c b/drivers/s390/crypto/zcrypt_cex2a.c
index 0842867..4681244 100644
--- a/drivers/s390/crypto/zcrypt_cex2a.c
+++ b/drivers/s390/crypto/zcrypt_cex2a.c
@@ -77,7 +77,6 @@ static void zcrypt_cex2a_receive(struct ap_device *, struct ap_message *,
 static struct ap_driver zcrypt_cex2a_driver = {
 	.probe = zcrypt_cex2a_probe,
 	.remove = zcrypt_cex2a_remove,
-	.receive = zcrypt_cex2a_receive,
 	.ids = zcrypt_cex2a_ids,
 	.request_timeout = CEX2A_CLEANUP_TIME,
 };
@@ -349,6 +348,7 @@ static long zcrypt_cex2a_modexpo(struct zcrypt_device *zdev,
 		ap_msg.message = kmalloc(CEX3A_MAX_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_cex2a_receive;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	ap_msg.private = &work;
@@ -390,6 +390,7 @@ static long zcrypt_cex2a_modexpo_crt(struct zcrypt_device *zdev,
 		ap_msg.message = kmalloc(CEX3A_MAX_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_cex2a_receive;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	ap_msg.private = &work;
diff --git a/drivers/s390/crypto/zcrypt_pcica.c b/drivers/s390/crypto/zcrypt_pcica.c
index 0effca9..ad7951c 100644
--- a/drivers/s390/crypto/zcrypt_pcica.c
+++ b/drivers/s390/crypto/zcrypt_pcica.c
@@ -67,7 +67,6 @@ static void zcrypt_pcica_receive(struct ap_device *, struct ap_message *,
 static struct ap_driver zcrypt_pcica_driver = {
 	.probe = zcrypt_pcica_probe,
 	.remove = zcrypt_pcica_remove,
-	.receive = zcrypt_pcica_receive,
 	.ids = zcrypt_pcica_ids,
 	.request_timeout = PCICA_CLEANUP_TIME,
 };
@@ -284,6 +283,7 @@ static long zcrypt_pcica_modexpo(struct zcrypt_device *zdev,
 	ap_msg.message = kmalloc(PCICA_MAX_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_pcica_receive;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	ap_msg.private = &work;
@@ -322,6 +322,7 @@ static long zcrypt_pcica_modexpo_crt(struct zcrypt_device *zdev,
 	ap_msg.message = kmalloc(PCICA_MAX_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_pcica_receive;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	ap_msg.private = &work;
diff --git a/drivers/s390/crypto/zcrypt_pcicc.c b/drivers/s390/crypto/zcrypt_pcicc.c
index f9523c0..e5dd335 100644
--- a/drivers/s390/crypto/zcrypt_pcicc.c
+++ b/drivers/s390/crypto/zcrypt_pcicc.c
@@ -79,7 +79,6 @@ static void zcrypt_pcicc_receive(struct ap_device *, struct ap_message *,
 static struct ap_driver zcrypt_pcicc_driver = {
 	.probe = zcrypt_pcicc_probe,
 	.remove = zcrypt_pcicc_remove,
-	.receive = zcrypt_pcicc_receive,
 	.ids = zcrypt_pcicc_ids,
 	.request_timeout = PCICC_CLEANUP_TIME,
 };
@@ -488,6 +487,7 @@ static long zcrypt_pcicc_modexpo(struct zcrypt_device *zdev,
 	ap_msg.message = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_pcicc_receive;
 	ap_msg.length = PAGE_SIZE;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
@@ -527,6 +527,7 @@ static long zcrypt_pcicc_modexpo_crt(struct zcrypt_device *zdev,
 	ap_msg.message = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_pcicc_receive;
 	ap_msg.length = PAGE_SIZE;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
diff --git a/drivers/s390/crypto/zcrypt_pcixcc.c b/drivers/s390/crypto/zcrypt_pcixcc.c
index cf1cbd4..f7cc434 100644
--- a/drivers/s390/crypto/zcrypt_pcixcc.c
+++ b/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -89,7 +89,6 @@ static void zcrypt_pcixcc_receive(struct ap_device *, struct ap_message *,
 static struct ap_driver zcrypt_pcixcc_driver = {
 	.probe = zcrypt_pcixcc_probe,
 	.remove = zcrypt_pcixcc_remove,
-	.receive = zcrypt_pcixcc_receive,
 	.ids = zcrypt_pcixcc_ids,
 	.request_timeout = PCIXCC_CLEANUP_TIME,
 };
@@ -698,6 +697,7 @@ static long zcrypt_pcixcc_modexpo(struct zcrypt_device *zdev,
 	ap_msg.message = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_pcixcc_receive;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	ap_msg.private = &resp_type;
@@ -738,6 +738,7 @@ static long zcrypt_pcixcc_modexpo_crt(struct zcrypt_device *zdev,
 	ap_msg.message = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_pcixcc_receive;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	ap_msg.private = &resp_type;
@@ -778,6 +779,7 @@ static long zcrypt_pcixcc_send_cprb(struct zcrypt_device *zdev,
 	ap_msg.message = kmalloc(PCIXCC_MAX_XCRB_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_pcixcc_receive;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	ap_msg.private = &resp_type;
@@ -818,6 +820,7 @@ static long zcrypt_pcixcc_rng(struct zcrypt_device *zdev,
 	ap_msg.message = kmalloc(PCIXCC_MAX_XCRB_MESSAGE_SIZE, GFP_KERNEL);
 	if (!ap_msg.message)
 		return -ENOMEM;
+	ap_msg.receive = zcrypt_pcixcc_receive;
 	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
 				atomic_inc_return(&zcrypt_step);
 	ap_msg.private = &resp_type;
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index b41fae3..6b1ff90 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -136,7 +136,6 @@ static inline void
 claw_set_busy(struct net_device *dev)
 {
  ((struct claw_privbk *)dev->ml_priv)->tbusy = 1;
- eieio();
 }
 
 static inline void
@@ -144,13 +143,11 @@ claw_clear_busy(struct net_device *dev)
 {
 	clear_bit(0, &(((struct claw_privbk *) dev->ml_priv)->tbusy));
 	netif_wake_queue(dev);
-	eieio();
 }
 
 static inline int
 claw_check_busy(struct net_device *dev)
 {
-	eieio();
 	return ((struct claw_privbk *) dev->ml_priv)->tbusy;
 }
 
@@ -233,8 +230,6 @@ static ssize_t claw_rbuff_show(struct device *dev,
 static ssize_t claw_rbuff_write(struct device *dev,
 	struct device_attribute *attr,
 	const char *buf, size_t count);
-static int claw_add_files(struct device *dev);
-static void claw_remove_files(struct device *dev);
 
 /*   Functions for System Validate  */
 static int claw_process_control( struct net_device *dev, struct ccwbk * p_ccw);
@@ -267,12 +262,10 @@ static struct ccwgroup_driver claw_group_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "claw",
 	},
-        .max_slaves  = 2,
-        .driver_id   = 0xC3D3C1E6,
-        .probe       = claw_probe,
-        .remove      = claw_remove_device,
-        .set_online  = claw_new_device,
-        .set_offline = claw_shutdown_device,
+	.setup	     = claw_probe,
+	.remove      = claw_remove_device,
+	.set_online  = claw_new_device,
+	.set_offline = claw_shutdown_device,
 	.prepare     = claw_pm_prepare,
 };
 
@@ -293,30 +286,24 @@ static struct ccw_driver claw_ccw_driver = {
 	.int_class = IOINT_CLW,
 };
 
-static ssize_t
-claw_driver_group_store(struct device_driver *ddrv, const char *buf,
-			size_t count)
+static ssize_t claw_driver_group_store(struct device_driver *ddrv,
+				       const char *buf,	size_t count)
 {
 	int err;
-	err = ccwgroup_create_from_string(claw_root_dev,
-					  claw_group_driver.driver_id,
-					  &claw_ccw_driver, 2, buf);
+	err = ccwgroup_create_dev(claw_root_dev, &claw_group_driver, 2, buf);
 	return err ? err : count;
 }
-
 static DRIVER_ATTR(group, 0200, NULL, claw_driver_group_store);
 
-static struct attribute *claw_group_attrs[] = {
+static struct attribute *claw_drv_attrs[] = {
 	&driver_attr_group.attr,
 	NULL,
 };
-
-static struct attribute_group claw_group_attr_group = {
-	.attrs = claw_group_attrs,
+static struct attribute_group claw_drv_attr_group = {
+	.attrs = claw_drv_attrs,
 };
-
-static const struct attribute_group *claw_group_attr_groups[] = {
-	&claw_group_attr_group,
+static const struct attribute_group *claw_drv_attr_groups[] = {
+	&claw_drv_attr_group,
 	NULL,
 };
 
@@ -324,60 +311,6 @@ static const struct attribute_group *claw_group_attr_groups[] = {
 *       Key functions
 */
 
-/*----------------------------------------------------------------*
- *   claw_probe                                                   *
- *      this function is called for each CLAW device.             *
- *----------------------------------------------------------------*/
-static int
-claw_probe(struct ccwgroup_device *cgdev)
-{
-	int  		rc;
-	struct claw_privbk *privptr=NULL;
-
-	CLAW_DBF_TEXT(2, setup, "probe");
-	if (!get_device(&cgdev->dev))
-		return -ENODEV;
-	privptr = kzalloc(sizeof(struct claw_privbk), GFP_KERNEL);
-	dev_set_drvdata(&cgdev->dev, privptr);
-	if (privptr == NULL) {
-		probe_error(cgdev);
-		put_device(&cgdev->dev);
-		CLAW_DBF_TEXT_(2, setup, "probex%d", -ENOMEM);
-		return -ENOMEM;
-	}
-	privptr->p_mtc_envelope= kzalloc( MAX_ENVELOPE_SIZE, GFP_KERNEL);
-	privptr->p_env = kzalloc(sizeof(struct claw_env), GFP_KERNEL);
-        if ((privptr->p_mtc_envelope==NULL) || (privptr->p_env==NULL)) {
-                probe_error(cgdev);
-		put_device(&cgdev->dev);
-		CLAW_DBF_TEXT_(2, setup, "probex%d", -ENOMEM);
-                return -ENOMEM;
-        }
-	memcpy(privptr->p_env->adapter_name,WS_NAME_NOT_DEF,8);
-	memcpy(privptr->p_env->host_name,WS_NAME_NOT_DEF,8);
-	memcpy(privptr->p_env->api_type,WS_NAME_NOT_DEF,8);
-	privptr->p_env->packing = 0;
-	privptr->p_env->write_buffers = 5;
-	privptr->p_env->read_buffers = 5;
-	privptr->p_env->read_size = CLAW_FRAME_SIZE;
-	privptr->p_env->write_size = CLAW_FRAME_SIZE;
-	rc = claw_add_files(&cgdev->dev);
-	if (rc) {
-		probe_error(cgdev);
-		put_device(&cgdev->dev);
-		dev_err(&cgdev->dev, "Creating the /proc files for a new"
-		" CLAW device failed\n");
-		CLAW_DBF_TEXT_(2, setup, "probex%d", rc);
-		return rc;
-	}
-	privptr->p_env->p_priv = privptr;
-        cgdev->cdev[0]->handler = claw_irq_handler;
-	cgdev->cdev[1]->handler = claw_irq_handler;
-	CLAW_DBF_TEXT(2, setup, "prbext 0");
-
-        return 0;
-}  /*  end of claw_probe       */
-
 /*-------------------------------------------------------------------*
  *   claw_tx                                                         *
  *-------------------------------------------------------------------*/
@@ -3093,7 +3026,6 @@ claw_remove_device(struct ccwgroup_device *cgdev)
 	dev_info(&cgdev->dev, " will be removed.\n");
 	if (cgdev->state == CCWGROUP_ONLINE)
 		claw_shutdown_device(cgdev);
-	claw_remove_files(&cgdev->dev);
 	kfree(priv->p_mtc_envelope);
 	priv->p_mtc_envelope=NULL;
 	kfree(priv->p_env);
@@ -3321,7 +3253,6 @@ claw_rbuff_write(struct device *dev, struct device_attribute *attr,
 	CLAW_DBF_TEXT_(2, setup, "RB=%d", p_env->read_buffers);
 	return count;
 }
-
 static DEVICE_ATTR(read_buffer, 0644, claw_rbuff_show, claw_rbuff_write);
 
 static struct attribute *claw_attr[] = {
@@ -3332,40 +3263,73 @@ static struct attribute *claw_attr[] = {
 	&dev_attr_host_name.attr,
 	NULL,
 };
-
 static struct attribute_group claw_attr_group = {
 	.attrs = claw_attr,
 };
+static const struct attribute_group *claw_attr_groups[] = {
+	&claw_attr_group,
+	NULL,
+};
+static const struct device_type claw_devtype = {
+	.name = "claw",
+	.groups = claw_attr_groups,
+};
 
-static int
-claw_add_files(struct device *dev)
+/*----------------------------------------------------------------*
+ *   claw_probe 						  *
+ *	this function is called for each CLAW device.		  *
+ *----------------------------------------------------------------*/
+static int claw_probe(struct ccwgroup_device *cgdev)
 {
-	CLAW_DBF_TEXT(2, setup, "add_file");
-	return sysfs_create_group(&dev->kobj, &claw_attr_group);
-}
+	struct claw_privbk *privptr = NULL;
 
-static void
-claw_remove_files(struct device *dev)
-{
-	CLAW_DBF_TEXT(2, setup, "rem_file");
-	sysfs_remove_group(&dev->kobj, &claw_attr_group);
-}
+	CLAW_DBF_TEXT(2, setup, "probe");
+	if (!get_device(&cgdev->dev))
+		return -ENODEV;
+	privptr = kzalloc(sizeof(struct claw_privbk), GFP_KERNEL);
+	dev_set_drvdata(&cgdev->dev, privptr);
+	if (privptr == NULL) {
+		probe_error(cgdev);
+		put_device(&cgdev->dev);
+		CLAW_DBF_TEXT_(2, setup, "probex%d", -ENOMEM);
+		return -ENOMEM;
+	}
+	privptr->p_mtc_envelope = kzalloc(MAX_ENVELOPE_SIZE, GFP_KERNEL);
+	privptr->p_env = kzalloc(sizeof(struct claw_env), GFP_KERNEL);
+	if ((privptr->p_mtc_envelope == NULL) || (privptr->p_env == NULL)) {
+		probe_error(cgdev);
+		put_device(&cgdev->dev);
+		CLAW_DBF_TEXT_(2, setup, "probex%d", -ENOMEM);
+		return -ENOMEM;
+	}
+	memcpy(privptr->p_env->adapter_name, WS_NAME_NOT_DEF, 8);
+	memcpy(privptr->p_env->host_name, WS_NAME_NOT_DEF, 8);
+	memcpy(privptr->p_env->api_type, WS_NAME_NOT_DEF, 8);
+	privptr->p_env->packing = 0;
+	privptr->p_env->write_buffers = 5;
+	privptr->p_env->read_buffers = 5;
+	privptr->p_env->read_size = CLAW_FRAME_SIZE;
+	privptr->p_env->write_size = CLAW_FRAME_SIZE;
+	privptr->p_env->p_priv = privptr;
+	cgdev->cdev[0]->handler = claw_irq_handler;
+	cgdev->cdev[1]->handler = claw_irq_handler;
+	cgdev->dev.type = &claw_devtype;
+	CLAW_DBF_TEXT(2, setup, "prbext 0");
+
+	return 0;
+}  /*  end of claw_probe       */
 
 /*--------------------------------------------------------------------*
 *    claw_init  and cleanup                                           *
 *---------------------------------------------------------------------*/
 
-static void __exit
-claw_cleanup(void)
+static void __exit claw_cleanup(void)
 {
-	driver_remove_file(&claw_group_driver.driver,
-			   &driver_attr_group);
 	ccwgroup_driver_unregister(&claw_group_driver);
 	ccw_driver_unregister(&claw_ccw_driver);
 	root_device_unregister(claw_root_dev);
 	claw_unregister_debug_facility();
 	pr_info("Driver unloaded\n");
-
 }
 
 /**
@@ -3374,8 +3338,7 @@ claw_cleanup(void)
  *
  * @return 0 on success, !0 on error.
  */
-static int __init
-claw_init(void)
+static int __init claw_init(void)
 {
 	int ret = 0;
 
@@ -3394,7 +3357,7 @@ claw_init(void)
 	ret = ccw_driver_register(&claw_ccw_driver);
 	if (ret)
 		goto ccw_err;
-	claw_group_driver.driver.groups = claw_group_attr_groups;
+	claw_group_driver.driver.groups = claw_drv_attr_groups;
 	ret = ccwgroup_driver_register(&claw_group_driver);
 	if (ret)
 		goto ccwgroup_err;
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 11f3b07..3cd2554 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1296,6 +1296,11 @@ static void ctcm_irq_handler(struct ccw_device *cdev,
 
 }
 
+static const struct device_type ctcm_devtype = {
+	.name = "ctcm",
+	.groups = ctcm_attr_groups,
+};
+
 /**
  * Add ctcm specific attributes.
  * Add ctcm private data.
@@ -1307,7 +1312,6 @@ static void ctcm_irq_handler(struct ccw_device *cdev,
 static int ctcm_probe_device(struct ccwgroup_device *cgdev)
 {
 	struct ctcm_priv *priv;
-	int rc;
 
 	CTCM_DBF_TEXT_(SETUP, CTC_DBF_INFO,
 			"%s %p",
@@ -1324,17 +1328,11 @@ static int ctcm_probe_device(struct ccwgroup_device *cgdev)
 		put_device(&cgdev->dev);
 		return -ENOMEM;
 	}
-
-	rc = ctcm_add_files(&cgdev->dev);
-	if (rc) {
-		kfree(priv);
-		put_device(&cgdev->dev);
-		return rc;
-	}
 	priv->buffer_size = CTCM_BUFSIZE_DEFAULT;
 	cgdev->cdev[0]->handler = ctcm_irq_handler;
 	cgdev->cdev[1]->handler = ctcm_irq_handler;
 	dev_set_drvdata(&cgdev->dev, priv);
+	cgdev->dev.type = &ctcm_devtype;
 
 	return 0;
 }
@@ -1611,11 +1609,6 @@ static int ctcm_new_device(struct ccwgroup_device *cgdev)
 		goto out_dev;
 	}
 
-	if (ctcm_add_attributes(&cgdev->dev)) {
-		result = -ENODEV;
-		goto out_unregister;
-	}
-
 	strlcpy(priv->fsm->name, dev->name, sizeof(priv->fsm->name));
 
 	dev_info(&dev->dev,
@@ -1629,8 +1622,6 @@ static int ctcm_new_device(struct ccwgroup_device *cgdev)
 			priv->channel[CTCM_WRITE]->id, priv->protocol);
 
 	return 0;
-out_unregister:
-	unregister_netdev(dev);
 out_dev:
 	ctcm_free_netdevice(dev);
 out_ccw2:
@@ -1669,7 +1660,6 @@ static int ctcm_shutdown_device(struct ccwgroup_device *cgdev)
 		/* Close the device */
 		ctcm_close(dev);
 		dev->flags &= ~IFF_RUNNING;
-		ctcm_remove_attributes(&cgdev->dev);
 		channel_free(priv->channel[CTCM_READ]);
 	} else
 		dev = NULL;
@@ -1711,7 +1701,6 @@ static void ctcm_remove_device(struct ccwgroup_device *cgdev)
 
 	if (cgdev->state == CCWGROUP_ONLINE)
 		ctcm_shutdown_device(cgdev);
-	ctcm_remove_files(&cgdev->dev);
 	dev_set_drvdata(&cgdev->dev, NULL);
 	kfree(priv);
 	put_device(&cgdev->dev);
@@ -1778,9 +1767,7 @@ static struct ccwgroup_driver ctcm_group_driver = {
 		.owner	= THIS_MODULE,
 		.name	= CTC_DRIVER_NAME,
 	},
-	.max_slaves  = 2,
-	.driver_id   = 0xC3E3C3D4,	/* CTCM */
-	.probe       = ctcm_probe_device,
+	.setup	     = ctcm_probe_device,
 	.remove      = ctcm_remove_device,
 	.set_online  = ctcm_new_device,
 	.set_offline = ctcm_shutdown_device,
@@ -1789,31 +1776,25 @@ static struct ccwgroup_driver ctcm_group_driver = {
 	.restore     = ctcm_pm_resume,
 };
 
-static ssize_t
-ctcm_driver_group_store(struct device_driver *ddrv, const char *buf,
-			size_t count)
+static ssize_t ctcm_driver_group_store(struct device_driver *ddrv,
+				       const char *buf,	size_t count)
 {
 	int err;
 
-	err = ccwgroup_create_from_string(ctcm_root_dev,
-					  ctcm_group_driver.driver_id,
-					  &ctcm_ccw_driver, 2, buf);
+	err = ccwgroup_create_dev(ctcm_root_dev, &ctcm_group_driver, 2, buf);
 	return err ? err : count;
 }
-
 static DRIVER_ATTR(group, 0200, NULL, ctcm_driver_group_store);
 
-static struct attribute *ctcm_group_attrs[] = {
+static struct attribute *ctcm_drv_attrs[] = {
 	&driver_attr_group.attr,
 	NULL,
 };
-
-static struct attribute_group ctcm_group_attr_group = {
-	.attrs = ctcm_group_attrs,
+static struct attribute_group ctcm_drv_attr_group = {
+	.attrs = ctcm_drv_attrs,
 };
-
-static const struct attribute_group *ctcm_group_attr_groups[] = {
-	&ctcm_group_attr_group,
+static const struct attribute_group *ctcm_drv_attr_groups[] = {
+	&ctcm_drv_attr_group,
 	NULL,
 };
 
@@ -1829,7 +1810,6 @@ static const struct attribute_group *ctcm_group_attr_groups[] = {
  */
 static void __exit ctcm_exit(void)
 {
-	driver_remove_file(&ctcm_group_driver.driver, &driver_attr_group);
 	ccwgroup_driver_unregister(&ctcm_group_driver);
 	ccw_driver_unregister(&ctcm_ccw_driver);
 	root_device_unregister(ctcm_root_dev);
@@ -1867,7 +1847,7 @@ static int __init ctcm_init(void)
 	ret = ccw_driver_register(&ctcm_ccw_driver);
 	if (ret)
 		goto ccw_err;
-	ctcm_group_driver.driver.groups = ctcm_group_attr_groups;
+	ctcm_group_driver.driver.groups = ctcm_drv_attr_groups;
 	ret = ccwgroup_driver_register(&ctcm_group_driver);
 	if (ret)
 		goto ccwgroup_err;
diff --git a/drivers/s390/net/ctcm_main.h b/drivers/s390/net/ctcm_main.h
index 24d5215..b9056a5 100644
--- a/drivers/s390/net/ctcm_main.h
+++ b/drivers/s390/net/ctcm_main.h
@@ -225,13 +225,7 @@ struct ctcm_priv {
 int ctcm_open(struct net_device *dev);
 int ctcm_close(struct net_device *dev);
 
-/*
- * prototypes for non-static sysfs functions
- */
-int ctcm_add_attributes(struct device *dev);
-void ctcm_remove_attributes(struct device *dev);
-int ctcm_add_files(struct device *dev);
-void ctcm_remove_files(struct device *dev);
+extern const struct attribute_group *ctcm_attr_groups[];
 
 /*
  * Compatibility macros for busy handling
diff --git a/drivers/s390/net/ctcm_sysfs.c b/drivers/s390/net/ctcm_sysfs.c
index 650aec1..0c27ae7 100644
--- a/drivers/s390/net/ctcm_sysfs.c
+++ b/drivers/s390/net/ctcm_sysfs.c
@@ -13,6 +13,7 @@
 #define KMSG_COMPONENT "ctcm"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/device.h>
 #include <linux/sysfs.h>
 #include <linux/slab.h>
 #include "ctcm_main.h"
@@ -108,10 +109,12 @@ static void ctcm_print_statistics(struct ctcm_priv *priv)
 }
 
 static ssize_t stats_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
+			  struct device_attribute *attr, char *buf)
 {
+	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
 	struct ctcm_priv *priv = dev_get_drvdata(dev);
-	if (!priv)
+
+	if (!priv || gdev->state != CCWGROUP_ONLINE)
 		return -ENODEV;
 	ctcm_print_statistics(priv);
 	return sprintf(buf, "0\n");
@@ -190,34 +193,14 @@ static struct attribute *ctcm_attr[] = {
 	&dev_attr_protocol.attr,
 	&dev_attr_type.attr,
 	&dev_attr_buffer.attr,
+	&dev_attr_stats.attr,
 	NULL,
 };
 
 static struct attribute_group ctcm_attr_group = {
 	.attrs = ctcm_attr,
 };
-
-int ctcm_add_attributes(struct device *dev)
-{
-	int rc;
-
-	rc = device_create_file(dev, &dev_attr_stats);
-
-	return rc;
-}
-
-void ctcm_remove_attributes(struct device *dev)
-{
-	device_remove_file(dev, &dev_attr_stats);
-}
-
-int ctcm_add_files(struct device *dev)
-{
-	return sysfs_create_group(&dev->kobj, &ctcm_attr_group);
-}
-
-void ctcm_remove_files(struct device *dev)
-{
-	sysfs_remove_group(&dev->kobj, &ctcm_attr_group);
-}
-
+const struct attribute_group *ctcm_attr_groups[] = {
+	&ctcm_attr_group,
+	NULL,
+};
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 687efe4..b082920 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -2051,10 +2051,17 @@ static struct attribute * lcs_attrs[] = {
 	&dev_attr_recover.attr,
 	NULL,
 };
-
 static struct attribute_group lcs_attr_group = {
 	.attrs = lcs_attrs,
 };
+static const struct attribute_group *lcs_attr_groups[] = {
+	&lcs_attr_group,
+	NULL,
+};
+static const struct device_type lcs_devtype = {
+	.name = "lcs",
+	.groups = lcs_attr_groups,
+};
 
 /**
  * lcs_probe_device is called on establishing a new ccwgroup_device.
@@ -2063,7 +2070,6 @@ static int
 lcs_probe_device(struct ccwgroup_device *ccwgdev)
 {
 	struct lcs_card *card;
-	int ret;
 
 	if (!get_device(&ccwgdev->dev))
 		return -ENODEV;
@@ -2075,12 +2081,6 @@ lcs_probe_device(struct ccwgroup_device *ccwgdev)
 		put_device(&ccwgdev->dev);
                 return -ENOMEM;
         }
-	ret = sysfs_create_group(&ccwgdev->dev.kobj, &lcs_attr_group);
-	if (ret) {
-		lcs_free_card(card);
-		put_device(&ccwgdev->dev);
-		return ret;
-        }
 	dev_set_drvdata(&ccwgdev->dev, card);
 	ccwgdev->cdev[0]->handler = lcs_irq;
 	ccwgdev->cdev[1]->handler = lcs_irq;
@@ -2089,7 +2089,9 @@ lcs_probe_device(struct ccwgroup_device *ccwgdev)
 	card->thread_start_mask = 0;
 	card->thread_allowed_mask = 0;
 	card->thread_running_mask = 0;
-        return 0;
+	ccwgdev->dev.type = &lcs_devtype;
+
+	return 0;
 }
 
 static int
@@ -2323,9 +2325,9 @@ lcs_remove_device(struct ccwgroup_device *ccwgdev)
 	}
 	if (card->dev)
 		unregister_netdev(card->dev);
-	sysfs_remove_group(&ccwgdev->dev.kobj, &lcs_attr_group);
 	lcs_cleanup_card(card);
 	lcs_free_card(card);
+	dev_set_drvdata(&ccwgdev->dev, NULL);
 	put_device(&ccwgdev->dev);
 }
 
@@ -2410,9 +2412,7 @@ static struct ccwgroup_driver lcs_group_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "lcs",
 	},
-	.max_slaves  = 2,
-	.driver_id   = 0xD3C3E2,
-	.probe       = lcs_probe_device,
+	.setup	     = lcs_probe_device,
 	.remove      = lcs_remove_device,
 	.set_online  = lcs_new_device,
 	.set_offline = lcs_shutdown_device,
@@ -2423,30 +2423,24 @@ static struct ccwgroup_driver lcs_group_driver = {
 	.restore     = lcs_restore,
 };
 
-static ssize_t
-lcs_driver_group_store(struct device_driver *ddrv, const char *buf,
-		       size_t count)
+static ssize_t lcs_driver_group_store(struct device_driver *ddrv,
+				      const char *buf, size_t count)
 {
 	int err;
-	err = ccwgroup_create_from_string(lcs_root_dev,
-					  lcs_group_driver.driver_id,
-					  &lcs_ccw_driver, 2, buf);
+	err = ccwgroup_create_dev(lcs_root_dev, &lcs_group_driver, 2, buf);
 	return err ? err : count;
 }
-
 static DRIVER_ATTR(group, 0200, NULL, lcs_driver_group_store);
 
-static struct attribute *lcs_group_attrs[] = {
+static struct attribute *lcs_drv_attrs[] = {
 	&driver_attr_group.attr,
 	NULL,
 };
-
-static struct attribute_group lcs_group_attr_group = {
-	.attrs = lcs_group_attrs,
+static struct attribute_group lcs_drv_attr_group = {
+	.attrs = lcs_drv_attrs,
 };
-
-static const struct attribute_group *lcs_group_attr_groups[] = {
-	&lcs_group_attr_group,
+static const struct attribute_group *lcs_drv_attr_groups[] = {
+	&lcs_drv_attr_group,
 	NULL,
 };
 
@@ -2470,7 +2464,7 @@ __init lcs_init_module(void)
 	rc = ccw_driver_register(&lcs_ccw_driver);
 	if (rc)
 		goto ccw_err;
-	lcs_group_driver.driver.groups = lcs_group_attr_groups;
+	lcs_group_driver.driver.groups = lcs_drv_attr_groups;
 	rc = ccwgroup_driver_register(&lcs_group_driver);
 	if (rc)
 		goto ccwgroup_err;
@@ -2496,8 +2490,6 @@ __exit lcs_cleanup_module(void)
 {
 	pr_info("Terminating lcs module.\n");
 	LCS_DBF_TEXT(0, trace, "cleanup");
-	driver_remove_file(&lcs_group_driver.driver,
-			   &driver_attr_group);
 	ccwgroup_driver_unregister(&lcs_group_driver);
 	ccw_driver_unregister(&lcs_ccw_driver);
 	root_device_unregister(lcs_root_dev);
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index ec7921b..5686955 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -711,7 +711,16 @@ struct qeth_discipline {
 	qdio_handler_t *input_handler;
 	qdio_handler_t *output_handler;
 	int (*recover)(void *ptr);
-	struct ccwgroup_driver *ccwgdriver;
+	int (*setup) (struct ccwgroup_device *);
+	void (*remove) (struct ccwgroup_device *);
+	int (*set_online) (struct ccwgroup_device *);
+	int (*set_offline) (struct ccwgroup_device *);
+	void (*shutdown)(struct ccwgroup_device *);
+	int (*prepare) (struct ccwgroup_device *);
+	void (*complete) (struct ccwgroup_device *);
+	int (*freeze)(struct ccwgroup_device *);
+	int (*thaw) (struct ccwgroup_device *);
+	int (*restore)(struct ccwgroup_device *);
 };
 
 struct qeth_vlan_vid {
@@ -775,7 +784,7 @@ struct qeth_card {
 	struct qeth_perf_stats perf_stats;
 	int read_or_write_problem;
 	struct qeth_osn_info osn_info;
-	struct qeth_discipline discipline;
+	struct qeth_discipline *discipline;
 	atomic_t force_alloc_skb;
 	struct service_level qeth_service_level;
 	struct qdio_ssqd_desc ssqd;
@@ -841,16 +850,15 @@ static inline int qeth_is_diagass_supported(struct qeth_card *card,
 	return card->info.diagass_support & (__u32)cmd;
 }
 
-extern struct ccwgroup_driver qeth_l2_ccwgroup_driver;
-extern struct ccwgroup_driver qeth_l3_ccwgroup_driver;
+extern struct qeth_discipline qeth_l2_discipline;
+extern struct qeth_discipline qeth_l3_discipline;
+extern const struct attribute_group *qeth_generic_attr_groups[];
+extern const struct attribute_group *qeth_osn_attr_groups[];
+
 const char *qeth_get_cardname_short(struct qeth_card *);
 int qeth_realloc_buffer_pool(struct qeth_card *, int);
 int qeth_core_load_discipline(struct qeth_card *, enum qeth_discipline_id);
 void qeth_core_free_discipline(struct qeth_card *);
-int qeth_core_create_device_attributes(struct device *);
-void qeth_core_remove_device_attributes(struct device *);
-int qeth_core_create_osn_attributes(struct device *);
-void qeth_core_remove_osn_attributes(struct device *);
 void qeth_buffer_reclaim_work(struct work_struct *);
 
 /* exports for qeth discipline device drivers */
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 8334dad..739e856 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1365,7 +1365,7 @@ static void qeth_start_kernel_thread(struct work_struct *work)
 	    card->write.state != CH_STATE_UP)
 		return;
 	if (qeth_do_start_thread(card, QETH_RECOVER_THREAD)) {
-		ts = kthread_run(card->discipline.recover, (void *)card,
+		ts = kthread_run(card->discipline->recover, (void *)card,
 				"qeth_recover");
 		if (IS_ERR(ts)) {
 			qeth_clear_thread_start_bit(card, QETH_RECOVER_THREAD);
@@ -3339,7 +3339,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 	if (rc) {
 		queue->card->stats.tx_errors += count;
 		/* ignore temporary SIGA errors without busy condition */
-		if (rc == QDIO_ERROR_SIGA_TARGET)
+		if (rc == -ENOBUFS)
 			return;
 		QETH_CARD_TEXT(queue->card, 2, "flushbuf");
 		QETH_CARD_TEXT_(queue->card, 2, " q%d", queue->queue_no);
@@ -3533,7 +3533,7 @@ void qeth_qdio_output_handler(struct ccw_device *ccwdev,
 	int i;
 
 	QETH_CARD_TEXT(card, 6, "qdouhdl");
-	if (qdio_error & QDIO_ERROR_ACTIVATE_CHECK_CONDITION) {
+	if (qdio_error & QDIO_ERROR_FATAL) {
 		QETH_CARD_TEXT(card, 2, "achkcond");
 		netif_stop_queue(card->dev);
 		qeth_schedule_recovery(card);
@@ -4629,7 +4629,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 		goto out_free_in_sbals;
 	}
 	for (i = 0; i < card->qdio.no_in_queues; ++i)
-		queue_start_poll[i] = card->discipline.start_poll;
+		queue_start_poll[i] = card->discipline->start_poll;
 
 	qeth_qdio_establish_cq(card, in_sbal_ptrs, queue_start_poll);
 
@@ -4653,8 +4653,8 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	init_data.qib_param_field        = qib_param_field;
 	init_data.no_input_qs            = card->qdio.no_in_queues;
 	init_data.no_output_qs           = card->qdio.no_out_queues;
-	init_data.input_handler          = card->discipline.input_handler;
-	init_data.output_handler         = card->discipline.output_handler;
+	init_data.input_handler 	 = card->discipline->input_handler;
+	init_data.output_handler	 = card->discipline->output_handler;
 	init_data.queue_start_poll_array = queue_start_poll;
 	init_data.int_parm               = (unsigned long) card;
 	init_data.input_sbal_addr_array  = (void **) in_sbal_ptrs;
@@ -4739,13 +4739,6 @@ static struct ccw_driver qeth_ccw_driver = {
 	.remove = ccwgroup_remove_ccwdev,
 };
 
-static int qeth_core_driver_group(const char *buf, struct device *root_dev,
-				unsigned long driver_id)
-{
-	return ccwgroup_create_from_string(root_dev, driver_id,
-					   &qeth_ccw_driver, 3, buf);
-}
-
 int qeth_core_hardsetup_card(struct qeth_card *card)
 {
 	int retries = 0;
@@ -5046,17 +5039,15 @@ int qeth_core_load_discipline(struct qeth_card *card,
 	mutex_lock(&qeth_mod_mutex);
 	switch (discipline) {
 	case QETH_DISCIPLINE_LAYER3:
-		card->discipline.ccwgdriver = try_then_request_module(
-			symbol_get(qeth_l3_ccwgroup_driver),
-			"qeth_l3");
+		card->discipline = try_then_request_module(
+			symbol_get(qeth_l3_discipline), "qeth_l3");
 		break;
 	case QETH_DISCIPLINE_LAYER2:
-		card->discipline.ccwgdriver = try_then_request_module(
-			symbol_get(qeth_l2_ccwgroup_driver),
-			"qeth_l2");
+		card->discipline = try_then_request_module(
+			symbol_get(qeth_l2_discipline), "qeth_l2");
 		break;
 	}
-	if (!card->discipline.ccwgdriver) {
+	if (!card->discipline) {
 		dev_err(&card->gdev->dev, "There is no kernel module to "
 			"support discipline %d\n", discipline);
 		rc = -EINVAL;
@@ -5068,12 +5059,21 @@ int qeth_core_load_discipline(struct qeth_card *card,
 void qeth_core_free_discipline(struct qeth_card *card)
 {
 	if (card->options.layer2)
-		symbol_put(qeth_l2_ccwgroup_driver);
+		symbol_put(qeth_l2_discipline);
 	else
-		symbol_put(qeth_l3_ccwgroup_driver);
-	card->discipline.ccwgdriver = NULL;
+		symbol_put(qeth_l3_discipline);
+	card->discipline = NULL;
 }
 
+static const struct device_type qeth_generic_devtype = {
+	.name = "qeth_generic",
+	.groups = qeth_generic_attr_groups,
+};
+static const struct device_type qeth_osn_devtype = {
+	.name = "qeth_osn",
+	.groups = qeth_osn_attr_groups,
+};
+
 static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card;
@@ -5128,18 +5128,17 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	}
 
 	if (card->info.type == QETH_CARD_TYPE_OSN)
-		rc = qeth_core_create_osn_attributes(dev);
+		gdev->dev.type = &qeth_osn_devtype;
 	else
-		rc = qeth_core_create_device_attributes(dev);
-	if (rc)
-		goto err_dbf;
+		gdev->dev.type = &qeth_generic_devtype;
+
 	switch (card->info.type) {
 	case QETH_CARD_TYPE_OSN:
 	case QETH_CARD_TYPE_OSM:
 		rc = qeth_core_load_discipline(card, QETH_DISCIPLINE_LAYER2);
 		if (rc)
-			goto err_attr;
-		rc = card->discipline.ccwgdriver->probe(card->gdev);
+			goto err_dbf;
+		rc = card->discipline->setup(card->gdev);
 		if (rc)
 			goto err_disc;
 	case QETH_CARD_TYPE_OSD:
@@ -5157,11 +5156,6 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 
 err_disc:
 	qeth_core_free_discipline(card);
-err_attr:
-	if (card->info.type == QETH_CARD_TYPE_OSN)
-		qeth_core_remove_osn_attributes(dev);
-	else
-		qeth_core_remove_device_attributes(dev);
 err_dbf:
 	debug_unregister(card->debug);
 err_card:
@@ -5178,14 +5172,8 @@ static void qeth_core_remove_device(struct ccwgroup_device *gdev)
 
 	QETH_DBF_TEXT(SETUP, 2, "removedv");
 
-	if (card->info.type == QETH_CARD_TYPE_OSN) {
-		qeth_core_remove_osn_attributes(&gdev->dev);
-	} else {
-		qeth_core_remove_device_attributes(&gdev->dev);
-	}
-
-	if (card->discipline.ccwgdriver) {
-		card->discipline.ccwgdriver->remove(gdev);
+	if (card->discipline) {
+		card->discipline->remove(gdev);
 		qeth_core_free_discipline(card);
 	}
 
@@ -5205,7 +5193,7 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 	int rc = 0;
 	int def_discipline;
 
-	if (!card->discipline.ccwgdriver) {
+	if (!card->discipline) {
 		if (card->info.type == QETH_CARD_TYPE_IQD)
 			def_discipline = QETH_DISCIPLINE_LAYER3;
 		else
@@ -5213,11 +5201,11 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 		rc = qeth_core_load_discipline(card, def_discipline);
 		if (rc)
 			goto err;
-		rc = card->discipline.ccwgdriver->probe(card->gdev);
+		rc = card->discipline->setup(card->gdev);
 		if (rc)
 			goto err;
 	}
-	rc = card->discipline.ccwgdriver->set_online(gdev);
+	rc = card->discipline->set_online(gdev);
 err:
 	return rc;
 }
@@ -5225,58 +5213,52 @@ err:
 static int qeth_core_set_offline(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	return card->discipline.ccwgdriver->set_offline(gdev);
+	return card->discipline->set_offline(gdev);
 }
 
 static void qeth_core_shutdown(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline.ccwgdriver &&
-	    card->discipline.ccwgdriver->shutdown)
-		card->discipline.ccwgdriver->shutdown(gdev);
+	if (card->discipline && card->discipline->shutdown)
+		card->discipline->shutdown(gdev);
 }
 
 static int qeth_core_prepare(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline.ccwgdriver &&
-	    card->discipline.ccwgdriver->prepare)
-		return card->discipline.ccwgdriver->prepare(gdev);
+	if (card->discipline && card->discipline->prepare)
+		return card->discipline->prepare(gdev);
 	return 0;
 }
 
 static void qeth_core_complete(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline.ccwgdriver &&
-	    card->discipline.ccwgdriver->complete)
-		card->discipline.ccwgdriver->complete(gdev);
+	if (card->discipline && card->discipline->complete)
+		card->discipline->complete(gdev);
 }
 
 static int qeth_core_freeze(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline.ccwgdriver &&
-	    card->discipline.ccwgdriver->freeze)
-		return card->discipline.ccwgdriver->freeze(gdev);
+	if (card->discipline && card->discipline->freeze)
+		return card->discipline->freeze(gdev);
 	return 0;
 }
 
 static int qeth_core_thaw(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline.ccwgdriver &&
-	    card->discipline.ccwgdriver->thaw)
-		return card->discipline.ccwgdriver->thaw(gdev);
+	if (card->discipline && card->discipline->thaw)
+		return card->discipline->thaw(gdev);
 	return 0;
 }
 
 static int qeth_core_restore(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline.ccwgdriver &&
-	    card->discipline.ccwgdriver->restore)
-		return card->discipline.ccwgdriver->restore(gdev);
+	if (card->discipline && card->discipline->restore)
+		return card->discipline->restore(gdev);
 	return 0;
 }
 
@@ -5285,8 +5267,7 @@ static struct ccwgroup_driver qeth_core_ccwgroup_driver = {
 		.owner = THIS_MODULE,
 		.name = "qeth",
 	},
-	.driver_id = 0xD8C5E3C8,
-	.probe = qeth_core_probe_device,
+	.setup = qeth_core_probe_device,
 	.remove = qeth_core_remove_device,
 	.set_online = qeth_core_set_online,
 	.set_offline = qeth_core_set_offline,
@@ -5298,21 +5279,30 @@ static struct ccwgroup_driver qeth_core_ccwgroup_driver = {
 	.restore = qeth_core_restore,
 };
 
-static ssize_t
-qeth_core_driver_group_store(struct device_driver *ddrv, const char *buf,
-			   size_t count)
+static ssize_t qeth_core_driver_group_store(struct device_driver *ddrv,
+					    const char *buf, size_t count)
 {
 	int err;
-	err = qeth_core_driver_group(buf, qeth_core_root_dev,
-					qeth_core_ccwgroup_driver.driver_id);
-	if (err)
-		return err;
-	else
-		return count;
-}
 
+	err = ccwgroup_create_dev(qeth_core_root_dev,
+				  &qeth_core_ccwgroup_driver, 3, buf);
+
+	return err ? err : count;
+}
 static DRIVER_ATTR(group, 0200, NULL, qeth_core_driver_group_store);
 
+static struct attribute *qeth_drv_attrs[] = {
+	&driver_attr_group.attr,
+	NULL,
+};
+static struct attribute_group qeth_drv_attr_group = {
+	.attrs = qeth_drv_attrs,
+};
+static const struct attribute_group *qeth_drv_attr_groups[] = {
+	&qeth_drv_attr_group,
+	NULL,
+};
+
 static struct {
 	const char str[ETH_GSTRING_LEN];
 } qeth_ethtool_stats_keys[] = {
@@ -5550,49 +5540,41 @@ static int __init qeth_core_init(void)
 	rc = qeth_register_dbf_views();
 	if (rc)
 		goto out_err;
-	rc = ccw_driver_register(&qeth_ccw_driver);
-	if (rc)
-		goto ccw_err;
-	rc = ccwgroup_driver_register(&qeth_core_ccwgroup_driver);
-	if (rc)
-		goto ccwgroup_err;
-	rc = driver_create_file(&qeth_core_ccwgroup_driver.driver,
-				&driver_attr_group);
-	if (rc)
-		goto driver_err;
 	qeth_core_root_dev = root_device_register("qeth");
 	rc = IS_ERR(qeth_core_root_dev) ? PTR_ERR(qeth_core_root_dev) : 0;
 	if (rc)
 		goto register_err;
-
 	qeth_core_header_cache = kmem_cache_create("qeth_hdr",
 			sizeof(struct qeth_hdr) + ETH_HLEN, 64, 0, NULL);
 	if (!qeth_core_header_cache) {
 		rc = -ENOMEM;
 		goto slab_err;
 	}
-
 	qeth_qdio_outbuf_cache = kmem_cache_create("qeth_buf",
 			sizeof(struct qeth_qdio_out_buffer), 0, 0, NULL);
 	if (!qeth_qdio_outbuf_cache) {
 		rc = -ENOMEM;
 		goto cqslab_err;
 	}
+	rc = ccw_driver_register(&qeth_ccw_driver);
+	if (rc)
+		goto ccw_err;
+	qeth_core_ccwgroup_driver.driver.groups = qeth_drv_attr_groups;
+	rc = ccwgroup_driver_register(&qeth_core_ccwgroup_driver);
+	if (rc)
+		goto ccwgroup_err;
 
 	return 0;
+
+ccwgroup_err:
+	ccw_driver_unregister(&qeth_ccw_driver);
+ccw_err:
+	kmem_cache_destroy(qeth_qdio_outbuf_cache);
 cqslab_err:
 	kmem_cache_destroy(qeth_core_header_cache);
 slab_err:
 	root_device_unregister(qeth_core_root_dev);
 register_err:
-	driver_remove_file(&qeth_core_ccwgroup_driver.driver,
-			   &driver_attr_group);
-driver_err:
-	ccwgroup_driver_unregister(&qeth_core_ccwgroup_driver);
-ccwgroup_err:
-	ccw_driver_unregister(&qeth_ccw_driver);
-ccw_err:
-	QETH_DBF_MESSAGE(2, "Initialization failed with code %d\n", rc);
 	qeth_unregister_dbf_views();
 out_err:
 	pr_err("Initializing the qeth device driver failed\n");
@@ -5601,13 +5583,11 @@ out_err:
 
 static void __exit qeth_core_exit(void)
 {
-	root_device_unregister(qeth_core_root_dev);
-	driver_remove_file(&qeth_core_ccwgroup_driver.driver,
-			   &driver_attr_group);
 	ccwgroup_driver_unregister(&qeth_core_ccwgroup_driver);
 	ccw_driver_unregister(&qeth_ccw_driver);
 	kmem_cache_destroy(qeth_qdio_outbuf_cache);
 	kmem_cache_destroy(qeth_core_header_cache);
+	root_device_unregister(qeth_core_root_dev);
 	qeth_unregister_dbf_views();
 	pr_info("core functions removed\n");
 }
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 0a8e86c..f163af5 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -434,8 +434,8 @@ static ssize_t qeth_dev_layer2_store(struct device *dev,
 		goto out;
 	else {
 		card->info.mac_bits  = 0;
-		if (card->discipline.ccwgdriver) {
-			card->discipline.ccwgdriver->remove(card->gdev);
+		if (card->discipline) {
+			card->discipline->remove(card->gdev);
 			qeth_core_free_discipline(card);
 		}
 	}
@@ -444,7 +444,7 @@ static ssize_t qeth_dev_layer2_store(struct device *dev,
 	if (rc)
 		goto out;
 
-	rc = card->discipline.ccwgdriver->probe(card->gdev);
+	rc = card->discipline->setup(card->gdev);
 out:
 	mutex_unlock(&card->discipline_mutex);
 	return rc ? rc : count;
@@ -693,7 +693,6 @@ static struct attribute *qeth_blkt_device_attrs[] = {
 	&dev_attr_inter_jumbo.attr,
 	NULL,
 };
-
 static struct attribute_group qeth_device_blkt_group = {
 	.name = "blkt",
 	.attrs = qeth_blkt_device_attrs,
@@ -716,11 +715,16 @@ static struct attribute *qeth_device_attrs[] = {
 	&dev_attr_hw_trap.attr,
 	NULL,
 };
-
 static struct attribute_group qeth_device_attr_group = {
 	.attrs = qeth_device_attrs,
 };
 
+const struct attribute_group *qeth_generic_attr_groups[] = {
+	&qeth_device_attr_group,
+	&qeth_device_blkt_group,
+	NULL,
+};
+
 static struct attribute *qeth_osn_device_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_chpid.attr,
@@ -730,37 +734,10 @@ static struct attribute *qeth_osn_device_attrs[] = {
 	&dev_attr_recover.attr,
 	NULL,
 };
-
 static struct attribute_group qeth_osn_device_attr_group = {
 	.attrs = qeth_osn_device_attrs,
 };
-
-int qeth_core_create_device_attributes(struct device *dev)
-{
-	int ret;
-	ret = sysfs_create_group(&dev->kobj, &qeth_device_attr_group);
-	if (ret)
-		return ret;
-	ret = sysfs_create_group(&dev->kobj, &qeth_device_blkt_group);
-	if (ret)
-		sysfs_remove_group(&dev->kobj, &qeth_device_attr_group);
-
-	return 0;
-}
-
-void qeth_core_remove_device_attributes(struct device *dev)
-{
-	sysfs_remove_group(&dev->kobj, &qeth_device_attr_group);
-	sysfs_remove_group(&dev->kobj, &qeth_device_blkt_group);
-}
-
-int qeth_core_create_osn_attributes(struct device *dev)
-{
-	return sysfs_create_group(&dev->kobj, &qeth_osn_device_attr_group);
-}
-
-void qeth_core_remove_osn_attributes(struct device *dev)
-{
-	sysfs_remove_group(&dev->kobj, &qeth_osn_device_attr_group);
-	return;
-}
+const struct attribute_group *qeth_osn_attr_groups[] = {
+	&qeth_osn_device_attr_group,
+	NULL,
+};
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 0e7c29d..4269865 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -882,12 +882,6 @@ static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
 	INIT_LIST_HEAD(&card->mc_list);
 	card->options.layer2 = 1;
 	card->info.hwtrap = 0;
-	card->discipline.start_poll = qeth_qdio_start_poll;
-	card->discipline.input_handler = (qdio_handler_t *)
-		qeth_qdio_input_handler;
-	card->discipline.output_handler = (qdio_handler_t *)
-		qeth_qdio_output_handler;
-	card->discipline.recover = qeth_l2_recover;
 	return 0;
 }
 
@@ -1227,8 +1221,12 @@ out:
 	return rc;
 }
 
-struct ccwgroup_driver qeth_l2_ccwgroup_driver = {
-	.probe = qeth_l2_probe_device,
+struct qeth_discipline qeth_l2_discipline = {
+	.start_poll = qeth_qdio_start_poll,
+	.input_handler = (qdio_handler_t *) qeth_qdio_input_handler,
+	.output_handler = (qdio_handler_t *) qeth_qdio_output_handler,
+	.recover = qeth_l2_recover,
+	.setup = qeth_l2_probe_device,
 	.remove = qeth_l2_remove_device,
 	.set_online = qeth_l2_set_online,
 	.set_offline = qeth_l2_set_offline,
@@ -1237,7 +1235,7 @@ struct ccwgroup_driver qeth_l2_ccwgroup_driver = {
 	.thaw = qeth_l2_pm_resume,
 	.restore = qeth_l2_pm_resume,
 };
-EXPORT_SYMBOL_GPL(qeth_l2_ccwgroup_driver);
+EXPORT_SYMBOL_GPL(qeth_l2_discipline);
 
 static int qeth_osn_send_control_data(struct qeth_card *card, int len,
 			   struct qeth_cmd_buffer *iob)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index f859216..03535ac 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -3376,12 +3376,6 @@ static int qeth_l3_probe_device(struct ccwgroup_device *gdev)
 	qeth_l3_create_device_attributes(&gdev->dev);
 	card->options.layer2 = 0;
 	card->info.hwtrap = 0;
-	card->discipline.start_poll = qeth_qdio_start_poll;
-	card->discipline.input_handler = (qdio_handler_t *)
-		qeth_qdio_input_handler;
-	card->discipline.output_handler = (qdio_handler_t *)
-		qeth_qdio_output_handler;
-	card->discipline.recover = qeth_l3_recover;
 	return 0;
 }
 
@@ -3656,8 +3650,12 @@ out:
 	return rc;
 }
 
-struct ccwgroup_driver qeth_l3_ccwgroup_driver = {
-	.probe = qeth_l3_probe_device,
+struct qeth_discipline qeth_l3_discipline = {
+	.start_poll = qeth_qdio_start_poll,
+	.input_handler = (qdio_handler_t *) qeth_qdio_input_handler,
+	.output_handler = (qdio_handler_t *) qeth_qdio_output_handler,
+	.recover = qeth_l3_recover,
+	.setup = qeth_l3_probe_device,
 	.remove = qeth_l3_remove_device,
 	.set_online = qeth_l3_set_online,
 	.set_offline = qeth_l3_set_offline,
@@ -3666,7 +3664,7 @@ struct ccwgroup_driver qeth_l3_ccwgroup_driver = {
 	.thaw = qeth_l3_pm_resume,
 	.restore = qeth_l3_pm_resume,
 };
-EXPORT_SYMBOL_GPL(qeth_l3_ccwgroup_driver);
+EXPORT_SYMBOL_GPL(qeth_l3_discipline);
 
 static int qeth_l3_ip_event(struct notifier_block *this,
 			    unsigned long event, void *ptr)

