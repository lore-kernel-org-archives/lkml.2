Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2CIPVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:21:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab2CIPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:20:58 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=3QI3vz3AAAAA:8 a=JNwax6YOdLsiRjP8cvoA:9 a=aD4xO676F1BnQqq-lU8A:7 a=PUjeQqilurYA:10 a=0kPLrQdw3YYA:10 a=4uJhtw2GlkcA:10 a=UMlipf24oYsrYVKS:21 a=TelEYDcD29ZYyN1V:21 a=k8N6HN7qN4aVDHmYRyAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331306445.25686.577.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.23-rt39
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 09 Mar 2012 10:20:45 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DknHYn0s8Jn3do/SVJFd"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DknHYn0s8Jn3do/SVJFd
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.23-rt39 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: abced2ac3332f6c70005c462c6bab6157f17f04b


Or to build 3.0.23-rt39 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.23.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.23-rt39.=
patch.xz


You can also build from 3.0.23-rt38 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.23-=
rt38-rt39.patch.xz



Enjoy,

-- Steve


Changes from 3.0.23-rt38:

---

Andy Lutomirski (2):
      x86-64-remove-vsyscall-number-3
      x86-64-emulate-legacy-vsyscalls

Steven Rostedt (11):
      revert-convert-xtime_lock-to-raw_seqlock
      revert-seqlock-create-raw_seqlock
      revert-seqlock-use-seqcount
      revert-seqlock-remove-unused-functions
      timer: Fix hotplug for -rt
      futex/rt: Fix possible lockup when taking pi_lock in proxy handler
      ring-buffer/rt: Check for irqs disabled before grabbing reader lock
      sched/rt: Fix wait_task_interactive() to test rt_spin_lock state
      lglock/rt: Use non-rt for_each_cpu() in -rt code
      cpu: Make hotplug.lock a "sleeping" spinlock on RT
      Linux 3.0.23-rt39

Thomas Gleixner (12):
      x86: vdso: Remove bogus locking in update_vsyscall_tz()
      x86: vdso: Use seqcount instead of seqlock
      ia64: vsyscall: Use seqcount instead of seqlock
      seqlock: Remove unused functions
      seqlock: Use seqcount
      seqlock: Provide seq_spin_* functions
      fs: fs_struct use seqlock
      fs: dentry use seqlock
      timekeeping: Split xtime_lock
      seqlock: Prevent rt starvation
      fs: Protect open coded isize seqcount
      net: u64_stat: Protect seqcount

----
 arch/ia64/kernel/asm-offsets.c            |    4 +-
 arch/ia64/kernel/fsys.S                   |    2 +-
 arch/ia64/kernel/fsyscall_gtod_data.h     |    2 +-
 arch/ia64/kernel/time.c                   |   10 +-
 arch/powerpc/platforms/cell/spufs/inode.c |    6 +-
 arch/x86/include/asm/irq_vectors.h        |    6 +-
 arch/x86/include/asm/traps.h              |    4 +
 arch/x86/include/asm/vgtod.h              |    2 +-
 arch/x86/include/asm/vsyscall.h           |   12 ++
 arch/x86/kernel/Makefile                  |    1 +
 arch/x86/kernel/entry_64.S                |    2 +
 arch/x86/kernel/traps.c                   |    6 +
 arch/x86/kernel/vmlinux.lds.S             |    4 -
 arch/x86/kernel/vsyscall_64.c             |  289 ++++++++++++-------------=
----
 arch/x86/kernel/vsyscall_emu_64.S         |   27 +++
 arch/x86/vdso/vclock_gettime.c            |   16 +-
 drivers/infiniband/hw/ipath/ipath_fs.c    |    6 +-
 drivers/infiniband/hw/qib/qib_fs.c        |    6 +-
 drivers/usb/core/inode.c                  |   12 +-
 fs/9p/vfs_dir.c                           |    4 +-
 fs/afs/dir.c                              |    4 +-
 fs/autofs4/autofs_i.h                     |   24 ++--
 fs/autofs4/expire.c                       |   44 +++---
 fs/autofs4/root.c                         |   38 ++--
 fs/btrfs/export.c                         |    4 +-
 fs/ceph/caps.c                            |    8 +-
 fs/ceph/debugfs.c                         |    8 +-
 fs/ceph/dir.c                             |   26 ++--
 fs/ceph/inode.c                           |   20 +-
 fs/ceph/mds_client.c                      |   16 +-
 fs/cifs/dir.c                             |    6 +-
 fs/coda/cache.c                           |    4 +-
 fs/configfs/configfs_internal.h           |    4 +-
 fs/configfs/inode.c                       |    6 +-
 fs/dcache.c                               |  269 +++++++++++++------------=
--
 fs/dcookies.c                             |    8 +-
 fs/exec.c                                 |    4 +-
 fs/exportfs/expfs.c                       |   12 +-
 fs/fat/inode.c                            |    4 +-
 fs/fat/namei_vfat.c                       |    4 +-
 fs/fhandle.c                              |    4 +-
 fs/fs-writeback.c                         |    4 +-
 fs/fs_struct.c                            |   46 ++---
 fs/fuse/inode.c                           |    4 +-
 fs/gfs2/export.c                          |    4 +-
 fs/isofs/export.c                         |    4 +-
 fs/libfs.c                                |   36 ++--
 fs/namei.c                                |   56 +++---
 fs/namespace.c                            |    8 +-
 fs/ncpfs/dir.c                            |    6 +-
 fs/ncpfs/ncplib_kernel.h                  |    8 +-
 fs/nfs/dir.c                              |    6 +-
 fs/nfs/getroot.c                          |   12 +-
 fs/nfs/namespace.c                        |   16 +-
 fs/nfs/unlink.c                           |   20 +-
 fs/nilfs2/namei.c                         |    4 +-
 fs/notify/fsnotify.c                      |    8 +-
 fs/notify/vfsmount_mark.c                 |   24 ++--
 fs/ocfs2/dcache.c                         |    6 +-
 fs/ocfs2/export.c                         |    4 +-
 fs/reiserfs/inode.c                       |    4 +-
 fs/udf/namei.c                            |    4 +-
 fs/xfs/linux-2.6/xfs_export.c             |    8 +-
 include/linux/dcache.h                    |   15 +-
 include/linux/fs.h                        |    6 +-
 include/linux/fs_struct.h                 |   16 +-
 include/linux/fsnotify_backend.h          |    6 +-
 include/linux/lglock.h                    |   35 ++++-
 include/linux/seccomp.h                   |   10 +
 include/linux/seqlock.h                   |  142 +++++++++------
 include/linux/u64_stats_sync.h            |    2 +
 include/net/neighbour.h                   |    2 +-
 kernel/cgroup.c                           |   22 +-
 kernel/cpu.c                              |   35 +++-
 kernel/fork.c                             |   10 +-
 kernel/rtmutex.c                          |    6 +-
 kernel/sched.c                            |    6 +-
 kernel/time/jiffies.c                     |    4 +-
 kernel/time/ntp.c                         |   24 ++-
 kernel/time/tick-common.c                 |   10 +-
 kernel/time/tick-internal.h               |    3 +-
 kernel/time/tick-sched.c                  |   16 +-
 kernel/time/timekeeping.c                 |   89 +++++----
 kernel/timer.c                            |   16 +-
 kernel/trace/ring_buffer.c                |    2 +-
 localversion-rt                           |    2 +-
 net/sunrpc/rpc_pipe.c                     |    6 +-
 security/selinux/selinuxfs.c              |   14 +-
 88 files changed, 919 insertions(+), 810 deletions(-)
---------------------------
diff --git a/arch/ia64/kernel/asm-offsets.c b/arch/ia64/kernel/asm-offsets.=
c
index af56501..106aeb6 100644
--- a/arch/ia64/kernel/asm-offsets.c
+++ b/arch/ia64/kernel/asm-offsets.c
@@ -269,8 +269,8 @@ void foo(void)
 	BLANK();
=20
 	/* used by fsys_gettimeofday in arch/ia64/kernel/fsys.S */
-	DEFINE(IA64_GTOD_LOCK_OFFSET,
-		offsetof (struct fsyscall_gtod_data_t, lock));
+	DEFINE(IA64_GTOD_SEQ_OFFSET,
+		offsetof (struct fsyscall_gtod_data_t, seq);
 	DEFINE(IA64_GTOD_WALL_TIME_OFFSET,
 		offsetof (struct fsyscall_gtod_data_t, wall_time));
 	DEFINE(IA64_GTOD_MONO_TIME_OFFSET,
diff --git a/arch/ia64/kernel/fsys.S b/arch/ia64/kernel/fsys.S
index 331d42b..fa77de7 100644
--- a/arch/ia64/kernel/fsys.S
+++ b/arch/ia64/kernel/fsys.S
@@ -174,7 +174,7 @@ ENTRY(fsys_set_tid_address)
 	FSYS_RETURN
 END(fsys_set_tid_address)
=20
-#if IA64_GTOD_LOCK_OFFSET !=3D0
+#if IA64_GTOD_SEQ_OFFSET !=3D0
 #error fsys_gettimeofday incompatible with changes to struct fsyscall_gtod=
_data_t
 #endif
 #if IA64_ITC_JITTER_OFFSET !=3D0
diff --git a/arch/ia64/kernel/fsyscall_gtod_data.h b/arch/ia64/kernel/fsysc=
all_gtod_data.h
index 57d2ee6..146b15b 100644
--- a/arch/ia64/kernel/fsyscall_gtod_data.h
+++ b/arch/ia64/kernel/fsyscall_gtod_data.h
@@ -6,7 +6,7 @@
  */
=20
 struct fsyscall_gtod_data_t {
-	seqlock_t	lock;
+	seqcount_t	seq;
 	struct timespec	wall_time;
 	struct timespec monotonic_time;
 	cycle_t		clk_mask;
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 604a636..15823ed 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -35,9 +35,7 @@
=20
 static cycle_t itc_get_cycles(struct clocksource *cs);
=20
-struct fsyscall_gtod_data_t fsyscall_gtod_data =3D {
-	.lock =3D __RAW_SEQLOCK_UNLOCKED(fsyscall_gtod_data.lock),
-};
+struct fsyscall_gtod_data_t fsyscall_gtod_data;
=20
 struct itc_jitter_data_t itc_jitter_data;
=20
@@ -460,9 +458,7 @@ void update_vsyscall_tz(void)
 void update_vsyscall(struct timespec *wall, struct timespec *wtm,
 			struct clocksource *c, u32 mult)
 {
-        unsigned long flags;
-
-	raw_write_seqlock_irqsave(&fsyscall_gtod_data.lock, flags);
+	write_seqcount_begin(&fsyscall_gtod_data.seq);
=20
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask =3D c->mask;
@@ -485,6 +481,6 @@ void update_vsyscall(struct timespec *wall, struct time=
spec *wtm,
 		fsyscall_gtod_data.monotonic_time.tv_sec++;
 	}
=20
-	raw_write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, flags);
+	write_seqcount_end(&fsyscall_gtod_data.seq);
 }
=20
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platf=
orms/cell/spufs/inode.c
index 856e9c3..1baf322 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -165,18 +165,18 @@ static void spufs_prune_dir(struct dentry *dir)
=20
 	mutex_lock(&dir->d_inode->i_mutex);
 	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
 			dget_dlock(dentry);
 			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
 			/* XXX: what was dcache_lock protecting here? Other
 			 * filesystems (IB, configfs) release dcache_lock
 			 * before unlink */
 			dput(dentry);
 		} else {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 		}
 	}
 	shrink_dcache_parent(dir);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_=
vectors.h
index 6e976ee..a563c50 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -17,7 +17,8 @@
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
  *  Vectors  32 ... 127 : device interrupts
  *  Vector  128         : legacy int80 syscall interface
- *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts
+ *  Vector  204         : legacy x86_64 vsyscall emulation
+ *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 except 204 : device inte=
rrupts
  *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
  *
  * 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
@@ -50,6 +51,9 @@
 #ifdef CONFIG_X86_32
 # define SYSCALL_VECTOR			0x80
 #endif
+#ifdef CONFIG_X86_64
+# define VSYSCALL_EMU_VECTOR		0xcc
+#endif
=20
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0310da6..2bae0a5 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_TRAPS_H
 #define _ASM_X86_TRAPS_H
=20
+#include <linux/kprobes.h>
+
 #include <asm/debugreg.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
=20
@@ -38,6 +40,7 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
+asmlinkage void emulate_vsyscall(void);
=20
 dotraplinkage void do_divide_error(struct pt_regs *, long);
 dotraplinkage void do_debug(struct pt_regs *, long);
@@ -64,6 +67,7 @@ dotraplinkage void do_alignment_check(struct pt_regs *, l=
ong);
 dotraplinkage void do_machine_check(struct pt_regs *, long);
 #endif
 dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
+dotraplinkage void do_emulate_vsyscall(struct pt_regs *, long);
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *, long);
 #endif
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 4f72846..10e09fc 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -5,7 +5,7 @@
 #include <linux/clocksource.h>
=20
 struct vsyscall_gtod_data {
-	raw_seqlock_t	lock;
+	seqcount_t	seq;
=20
 	/* open coded 'struct timespec' */
 	time_t		wall_time_sec;
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscal=
l.h
index d555973..bb710cb 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -31,6 +31,18 @@ extern struct timezone sys_tz;
=20
 extern void map_vsyscall(void);
=20
+/* Emulation */
+
+static inline bool is_vsyscall_entry(unsigned long addr)
+{
+	return (addr & ~0xC00UL) =3D=3D VSYSCALL_START;
+}
+
+static inline int vsyscall_entry_nr(unsigned long addr)
+{
+	return (addr & 0xC00UL) >> 10;
+}
+
 #endif /* __KERNEL__ */
=20
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 90b06d4..cc0469a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -44,6 +44,7 @@ obj-y			+=3D probe_roms.o
 obj-$(CONFIG_X86_32)	+=3D sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+=3D sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+=3D syscall_64.o vsyscall_64.o vread_tsc_64.o
+obj-$(CONFIG_X86_64)	+=3D vsyscall_emu_64.o
 obj-y			+=3D bootflag.o e820.o
 obj-y			+=3D pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+=3D alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1689be7..eb7fa5c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1121,6 +1121,8 @@ zeroentry spurious_interrupt_bug do_spurious_interrup=
t_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
+zeroentry emulate_vsyscall do_emulate_vsyscall
+
=20
 	/* Reload gs selector with exception handling */
 	/* edi:  new selector */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d343009..25c0dd4 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -895,6 +895,12 @@ void __init trap_init(void)
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
=20
+#ifdef CONFIG_X86_64
+	BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
+	set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall);
+	set_bit(VSYSCALL_EMU_VECTOR, used_vectors);
+#endif
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 89aed99..85d4a06 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -188,10 +188,6 @@ SECTIONS
 		*(.vsyscall_2)
 	}
=20
-	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
-		*(.vsyscall_3)
-	}
-
 #define __VVAR_KERNEL_LDS
 #include <asm/vvar.h>
 #undef __VVAR_KERNEL_LDS
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index bbcbaaa..c1fe684 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -2,6 +2,8 @@
  *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
  *  Copyright 2003 Andi Kleen, SuSE Labs.
  *
+ *  [ NOTE: this mechanism is now deprecated in favor of the vDSO. ]
+ *
  *  Thanks to hpa@transmeta.com for some useful hint.
  *  Special thanks to Ingo Molnar for his early experience with
  *  a different vsyscall implementation for Linux/IA32 and for the name.
@@ -11,10 +13,9 @@
  *  vsyscalls. One vsyscall can reserve more than 1 slot to avoid
  *  jumping out of line if necessary. We cannot add more with this
  *  mechanism because older kernels won't return -ENOSYS.
- *  If we want more than four we need a vDSO.
  *
- *  Note: the concept clashes with user mode linux. If you use UML and
- *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
+ *  Note: the concept clashes with user mode linux.  UML users should
+ *  use the vDSO.
  */
=20
 /* Disable profiling for userspace code: */
@@ -32,6 +33,8 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/notifier.h>
+#include <linux/syscalls.h>
+#include <linux/ratelimit.h>
=20
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
@@ -44,187 +47,138 @@
 #include <asm/desc.h>
 #include <asm/topology.h>
 #include <asm/vgtod.h>
-
-#define __vsyscall(nr) \
-		__attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
-#define __syscall_clobber "r11","cx","memory"
+#include <asm/traps.h>
=20
 DEFINE_VVAR(int, vgetcpu_mode);
-DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =3D
-{
-	.lock =3D __RAW_SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
-	.sysctl_enabled =3D 1,
-};
+DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
=20
 void update_vsyscall_tz(void)
 {
-	unsigned long flags;
-
-	raw_write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
-	/* sys_tz has changed */
 	vsyscall_gtod_data.sys_tz =3D sys_tz;
-	raw_write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
=20
 void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 			struct clocksource *clock, u32 mult)
 {
-	unsigned long flags;
+	write_seqcount_begin(&vsyscall_gtod_data.seq);
+
=20
-	raw_write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 	/* copy vsyscall data */
-	vsyscall_gtod_data.clock.vread =3D clock->vread;
-	vsyscall_gtod_data.clock.cycle_last =3D clock->cycle_last;
-	vsyscall_gtod_data.clock.mask =3D clock->mask;
-	vsyscall_gtod_data.clock.mult =3D mult;
-	vsyscall_gtod_data.clock.shift =3D clock->shift;
-	vsyscall_gtod_data.wall_time_sec =3D wall_time->tv_sec;
-	vsyscall_gtod_data.wall_time_nsec =3D wall_time->tv_nsec;
-	vsyscall_gtod_data.wall_to_monotonic =3D *wtm;
-	vsyscall_gtod_data.wall_time_coarse =3D __current_kernel_time();
-	raw_write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
+	vsyscall_gtod_data.clock.vread		=3D clock->vread;
+	vsyscall_gtod_data.clock.cycle_last	=3D clock->cycle_last;
+	vsyscall_gtod_data.clock.mask		=3D clock->mask;
+	vsyscall_gtod_data.clock.mult		=3D mult;
+	vsyscall_gtod_data.clock.shift		=3D clock->shift;
+	vsyscall_gtod_data.wall_time_sec	=3D wall_time->tv_sec;
+	vsyscall_gtod_data.wall_time_nsec	=3D wall_time->tv_nsec;
+	vsyscall_gtod_data.wall_to_monotonic	=3D *wtm;
+	vsyscall_gtod_data.wall_time_coarse	=3D __current_kernel_time();
+
+	write_seqcount_end(&vsyscall_gtod_data.seq);
 }
=20
-/* RED-PEN may want to readd seq locking, but then the variable should be
- * write-once.
- */
-static __always_inline void do_get_tz(struct timezone * tz)
+static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
+			      const char *message)
 {
-	*tz =3D VVAR(vsyscall_gtod_data).sys_tz;
-}
+	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RAT=
ELIMIT_BURST);
+	struct task_struct *tsk;
=20
-static __always_inline int gettimeofday(struct timeval *tv, struct timezon=
e *tz)
-{
-	int ret;
-	asm volatile("syscall"
-		: "=3Da" (ret)
-		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
-		: __syscall_clobber );
-	return ret;
-}
+	if (!show_unhandled_signals || !__ratelimit(&rs))
+		return;
=20
-static __always_inline long time_syscall(long *t)
-{
-	long secs;
-	asm volatile("syscall"
-		: "=3Da" (secs)
-		: "0" (__NR_time),"D" (t) : __syscall_clobber);
-	return secs;
-}
+	tsk =3D current;
=20
-static __always_inline void do_vgettimeofday(struct timeval * tv)
-{
-	cycle_t now, base, mask, cycle_delta;
-	unsigned seq;
-	unsigned long mult, shift, nsec;
-	cycle_t (*vread)(void);
-	do {
-		seq =3D read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
-
-		vread =3D VVAR(vsyscall_gtod_data).clock.vread;
-		if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled ||
-			     !vread)) {
-			gettimeofday(tv,NULL);
-			return;
-		}
-
-		now =3D vread();
-		base =3D VVAR(vsyscall_gtod_data).clock.cycle_last;
-		mask =3D VVAR(vsyscall_gtod_data).clock.mask;
-		mult =3D VVAR(vsyscall_gtod_data).clock.mult;
-		shift =3D VVAR(vsyscall_gtod_data).clock.shift;
-
-		tv->tv_sec =3D VVAR(vsyscall_gtod_data).wall_time_sec;
-		nsec =3D VVAR(vsyscall_gtod_data).wall_time_nsec;
-	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
-
-	/* calculate interval: */
-	cycle_delta =3D (now - base) & mask;
-	/* convert to nsecs: */
-	nsec +=3D (cycle_delta * mult) >> shift;
-
-	while (nsec >=3D NSEC_PER_SEC) {
-		tv->tv_sec +=3D 1;
-		nsec -=3D NSEC_PER_SEC;
-	}
-	tv->tv_usec =3D nsec / NSEC_PER_USEC;
+	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	       level, tsk->comm, task_pid_nr(tsk),
+	       message, regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
 }
=20
-int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
+void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_co=
de)
 {
-	if (tv)
-		do_vgettimeofday(tv);
-	if (tz)
-		do_get_tz(tz);
-	return 0;
-}
-
-/* This will break when the xtime seconds get inaccurate, but that is
- * unlikely */
-time_t __vsyscall(1) vtime(time_t *t)
-{
-	unsigned seq;
-	time_t result;
-	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
-		return time_syscall(t);
+	const char *vsyscall_name;
+	struct task_struct *tsk;
+	unsigned long caller;
+	int vsyscall_nr;
+	long ret;
+
+	/* Kernel code must never get here. */
+	BUG_ON(!user_mode(regs));
+
+	local_irq_enable();
+
+	/*
+	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
+	 * and int 0xcc is two bytes long.
+	 */
+	if (!is_vsyscall_entry(regs->ip - 2)) {
+		warn_bad_vsyscall(KERN_WARNING, regs, "illegal int 0xcc (exploit attempt=
?)");
+		goto sigsegv;
+	}
+	vsyscall_nr =3D vsyscall_entry_nr(regs->ip - 2);
=20
-	do {
-		seq =3D read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
+	if (get_user(caller, (unsigned long __user *)regs->sp) !=3D 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit =
attempt?)");
+		goto sigsegv;
+	}
=20
-		result =3D VVAR(vsyscall_gtod_data).wall_time_sec;
+	tsk =3D current;
+	if (seccomp_mode(&tsk->seccomp))
+		do_exit(SIGKILL);
+
+	switch (vsyscall_nr) {
+	case 0:
+		vsyscall_name =3D "gettimeofday";
+		ret =3D sys_gettimeofday(
+			(struct timeval __user *)regs->di,
+			(struct timezone __user *)regs->si);
+		break;
+
+	case 1:
+		vsyscall_name =3D "time";
+		ret =3D sys_time((time_t __user *)regs->di);
+		break;
+
+	case 2:
+		vsyscall_name =3D "getcpu";
+		ret =3D sys_getcpu((unsigned __user *)regs->di,
+				 (unsigned __user *)regs->si,
+				 0);
+		break;
+
+	default:
+		/*
+		 * If we get here, then vsyscall_nr indicates that int 0xcc
+		 * happened at an address in the vsyscall page that doesn't
+		 * contain int 0xcc.  That can't happen.
+		 */
+		BUG();
+	}
=20
-	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
+	if (ret =3D=3D -EFAULT) {
+		/*
+		 * Bad news -- userspace fed a bad pointer to a vsyscall.
+		 *
+		 * With a real vsyscall, that would have caused SIGSEGV.
+		 * To make writing reliable exploits using the emulated
+		 * vsyscalls harder, generate SIGSEGV here as well.
+		 */
+		warn_bad_vsyscall(KERN_INFO, regs,
+				  "vsyscall fault (exploit attempt?)");
+		goto sigsegv;
+	}
=20
-	if (t)
-		*t =3D result;
-	return result;
-}
+	regs->ax =3D ret;
=20
-/* Fast way to get current CPU and node.
-   This helps to do per node and per CPU caches in user space.
-   The result is not guaranteed without CPU affinity, but usually
-   works out because the scheduler tries to keep a thread on the same
-   CPU.
+	/* Emulate a ret instruction. */
+	regs->ip =3D caller;
+	regs->sp +=3D 8;
=20
-   tcache must point to a two element sized long array.
-   All arguments can be NULL. */
-long __vsyscall(2)
-vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
-{
-	unsigned int p;
-	unsigned long j =3D 0;
-
-	/* Fast cache - only recompute value once per jiffies and avoid
-	   relatively costly rdtscp/cpuid otherwise.
-	   This works because the scheduler usually keeps the process
-	   on the same CPU and this syscall doesn't guarantee its
-	   results anyways.
-	   We do this here because otherwise user space would do it on
-	   its own in a likely inferior way (no access to jiffies).
-	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] =3D=3D (j =3D VVAR(jiffies))) {
-		p =3D tcache->blob[1];
-	} else if (VVAR(vgetcpu_mode) =3D=3D VGETCPU_RDTSCP) {
-		/* Load per CPU data from RDTSCP */
-		native_read_tscp(&p);
-	} else {
-		/* Load per CPU data from GDT */
-		asm("lsl %1,%0" : "=3Dr" (p) : "r" (__PER_CPU_SEG));
-	}
-	if (tcache) {
-		tcache->blob[0] =3D j;
-		tcache->blob[1] =3D p;
-	}
-	if (cpu)
-		*cpu =3D p & 0xfff;
-	if (node)
-		*node =3D p >> 12;
-	return 0;
-}
+	local_irq_disable();
+	return;
=20
-static long __vsyscall(3) venosys_1(void)
-{
-	return -ENOSYS;
+sigsegv:
+	regs->ip -=3D 2;  /* The faulting instruction should be the int 0xcc. */
+	force_sig(SIGSEGV, current);
 }
=20
 #ifdef CONFIG_SYSCTL
@@ -243,8 +197,10 @@ static ctl_table kernel_root_table2[] =3D {
 };
 #endif
=20
-/* Assume __initcall executes before all user space. Hopefully kmod
-   doesn't violate that. We'll find out if it does. */
+/*
+ * Assume __initcall executes before all user space. Hopefully kmod
+ * doesn't violate that. We'll find out if it does.
+ */
 static void __cpuinit vsyscall_set_cpu(int cpu)
 {
 	unsigned long d;
@@ -255,13 +211,15 @@ static void __cpuinit vsyscall_set_cpu(int cpu)
 	if (cpu_has(&cpu_data(cpu), X86_FEATURE_RDTSCP))
 		write_rdtscp_aux((node << 12) | cpu);
=20
-	/* Store cpu number in limit so that it can be loaded quickly
-	   in user space in vgetcpu.
-	   12 bits for the CPU and 8 bits for the node. */
+	/*
+	 * Store cpu number in limit so that it can be loaded quickly
+	 * in user space in vgetcpu. (12 bits for the CPU and 8 bits for the node=
)
+	 */
 	d =3D 0x0f40000000000ULL;
 	d |=3D cpu;
 	d |=3D (node & 0xf) << 12;
 	d |=3D (node >> 4) << 48;
+
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S=
);
 }
=20
@@ -275,8 +233,10 @@ static int __cpuinit
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void=
 *arg)
 {
 	long cpu =3D (long)arg;
+
 	if (action =3D=3D CPU_ONLINE || action =3D=3D CPU_ONLINE_FROZEN)
 		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
+
 	return NOTIFY_DONE;
 }
=20
@@ -291,18 +251,15 @@ void __init map_vsyscall(void)
=20
 static int __init vsyscall_init(void)
 {
-	BUG_ON(((unsigned long) &vgettimeofday !=3D
-			VSYSCALL_ADDR(__NR_vgettimeofday)));
-	BUG_ON((unsigned long) &vtime !=3D VSYSCALL_ADDR(__NR_vtime));
-	BUG_ON((VSYSCALL_ADDR(0) !=3D __fix_to_virt(VSYSCALL_FIRST_PAGE)));
-	BUG_ON((unsigned long) &vgetcpu !=3D VSYSCALL_ADDR(__NR_vgetcpu));
+	BUG_ON(VSYSCALL_ADDR(0) !=3D __fix_to_virt(VSYSCALL_FIRST_PAGE));
+
 #ifdef CONFIG_SYSCTL
 	register_sysctl_table(kernel_root_table2);
 #endif
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	/* notifier priority > KVM */
 	hotcpu_notifier(cpu_vsyscall_notifier, 30);
+
 	return 0;
 }
-
 __initcall(vsyscall_init);
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_e=
mu_64.S
new file mode 100644
index 0000000..ffa845e
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -0,0 +1,27 @@
+/*
+ * vsyscall_emu_64.S: Vsyscall emulation page
+ *
+ * Copyright (c) 2011 Andy Lutomirski
+ *
+ * Subject to the GNU General Public License, version 2
+ */
+
+#include <linux/linkage.h>
+#include <asm/irq_vectors.h>
+
+/* The unused parts of the page are filled with 0xcc by the linker script.=
 */
+
+.section .vsyscall_0, "a"
+ENTRY(vsyscall_0)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_0)
+
+.section .vsyscall_1, "a"
+ENTRY(vsyscall_1)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_1)
+
+.section .vsyscall_2, "a"
+ENTRY(vsyscall_2)
+	int $VSYSCALL_EMU_VECTOR
+END(vsyscall_2)
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.=
c
index a724905..117e6cf 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -46,11 +46,11 @@ notrace static noinline int do_realtime(struct timespec=
 *ts)
 {
 	unsigned long seq, ns;
 	do {
-		seq =3D read_seqbegin(&gtod->lock);
+		seq =3D read_seqcount_begin(&gtod->seq);
 		ts->tv_sec =3D gtod->wall_time_sec;
 		ts->tv_nsec =3D gtod->wall_time_nsec;
 		ns =3D vgetns();
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	timespec_add_ns(ts, ns);
 	return 0;
 }
@@ -59,12 +59,12 @@ notrace static noinline int do_monotonic(struct timespe=
c *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
-		seq =3D read_seqbegin(&gtod->lock);
+		seq =3D read_seqcount_begin(&gtod->seq);
 		secs =3D gtod->wall_time_sec;
 		ns =3D gtod->wall_time_nsec + vgetns();
 		secs +=3D gtod->wall_to_monotonic.tv_sec;
 		ns +=3D gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
=20
 	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
 	 * are all guaranteed to be nonnegative.
@@ -83,10 +83,10 @@ notrace static noinline int do_realtime_coarse(struct t=
imespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq =3D read_seqbegin(&gtod->lock);
+		seq =3D read_seqcount_begin(&gtod->seq);
 		ts->tv_sec =3D gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec =3D gtod->wall_time_coarse.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	return 0;
 }
=20
@@ -94,12 +94,12 @@ notrace static noinline int do_monotonic_coarse(struct =
timespec *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
-		seq =3D read_seqbegin(&gtod->lock);
+		seq =3D read_seqcount_begin(&gtod->seq);
 		secs =3D gtod->wall_time_coarse.tv_sec;
 		ns =3D gtod->wall_time_coarse.tv_nsec;
 		secs +=3D gtod->wall_to_monotonic.tv_sec;
 		ns +=3D gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
=20
 	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
 	 * guaranteed to be between 0 and NSEC_PER_SEC.
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw=
/ipath/ipath_fs.c
index 31ae1b1..21319f7 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -277,14 +277,14 @@ static int remove_file(struct dentry *parent, char *n=
ame)
 		goto bail;
 	}
=20
-	spin_lock(&tmp->d_lock);
+	seq_spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_dlock(tmp);
 		__d_drop(tmp);
-		spin_unlock(&tmp->d_lock);
+		seq_spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
 	} else
-		spin_unlock(&tmp->d_lock);
+		seq_spin_unlock(&tmp->d_lock);
=20
 	ret =3D 0;
 bail:
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib=
/qib_fs.c
index df7fa25..b20c7f8 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -453,14 +453,14 @@ static int remove_file(struct dentry *parent, char *n=
ame)
 		goto bail;
 	}
=20
-	spin_lock(&tmp->d_lock);
+	seq_spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_dlock(tmp);
 		__d_drop(tmp);
-		spin_unlock(&tmp->d_lock);
+		seq_spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
 	} else {
-		spin_unlock(&tmp->d_lock);
+		seq_spin_unlock(&tmp->d_lock);
 	}
=20
 	ret =3D 0;
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 2278dad..731f03f 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -343,19 +343,19 @@ static int usbfs_empty (struct dentry *dentry)
 {
 	struct list_head *list;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	list_for_each(list, &dentry->d_subdirs) {
 		struct dentry *de =3D list_entry(list, struct dentry, d_u.d_child);
=20
-		spin_lock_nested(&de->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&de->d_lock, DENTRY_D_LOCK_NESTED);
 		if (usbfs_positive(de)) {
-			spin_unlock(&de->d_lock);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&de->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			return 0;
 		}
-		spin_unlock(&de->d_lock);
+		seq_spin_unlock(&de->d_lock);
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return 1;
 }
=20
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 9c2bdda..0ca9433 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -107,7 +107,7 @@ static int v9fs_alloc_rdir_buf(struct file *filp, int b=
uflen)
 			err =3D -ENOMEM;
 			goto exit;
 		}
-		spin_lock(&filp->f_dentry->d_lock);
+		seq_spin_lock(&filp->f_dentry->d_lock);
 		if (!fid->rdir) {
 			rdir->buf =3D (uint8_t *)rdir + sizeof(struct p9_rdir);
 			mutex_init(&rdir->mutex);
@@ -115,7 +115,7 @@ static int v9fs_alloc_rdir_buf(struct file *filp, int b=
uflen)
 			fid->rdir =3D (void *) rdir;
 			rdir =3D NULL;
 		}
-		spin_unlock(&filp->f_dentry->d_lock);
+		seq_spin_unlock(&filp->f_dentry->d_lock);
 		kfree(rdir);
 	}
 exit:
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 1b0b195..84f6bf6 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -705,9 +705,9 @@ out_skip:
=20
 	/* the dirent, if it exists, now points to a different vnode */
 not_found:
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_flags |=3D DCACHE_NFSFS_RENAMED;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 out_bad:
 	if (dentry->d_inode) {
diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 475f9c5..b620114 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -207,9 +207,9 @@ static inline void __managed_dentry_set_automount(struc=
t dentry *dentry)
=20
 static inline void managed_dentry_set_automount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_set_automount(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 static inline void __managed_dentry_clear_automount(struct dentry *dentry)
@@ -219,9 +219,9 @@ static inline void __managed_dentry_clear_automount(str=
uct dentry *dentry)
=20
 static inline void managed_dentry_clear_automount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_clear_automount(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 static inline void __managed_dentry_set_transit(struct dentry *dentry)
@@ -231,9 +231,9 @@ static inline void __managed_dentry_set_transit(struct =
dentry *dentry)
=20
 static inline void managed_dentry_set_transit(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_set_transit(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 static inline void __managed_dentry_clear_transit(struct dentry *dentry)
@@ -243,9 +243,9 @@ static inline void __managed_dentry_clear_transit(struc=
t dentry *dentry)
=20
 static inline void managed_dentry_clear_transit(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_clear_transit(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 static inline void __managed_dentry_set_managed(struct dentry *dentry)
@@ -255,9 +255,9 @@ static inline void __managed_dentry_set_managed(struct =
dentry *dentry)
=20
 static inline void managed_dentry_set_managed(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_set_managed(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 static inline void __managed_dentry_clear_managed(struct dentry *dentry)
@@ -267,9 +267,9 @@ static inline void __managed_dentry_clear_managed(struc=
t dentry *dentry)
=20
 static inline void managed_dentry_clear_managed(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_clear_managed(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 /* Initializing function */
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 450f529..d8b6184 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -99,7 +99,7 @@ static struct dentry *get_next_positive_subdir(struct den=
try *prev,
 	spin_lock(&sbi->lookup_lock);
=20
 	if (prev =3D=3D NULL) {
-		spin_lock(&root->d_lock);
+		seq_spin_lock(&root->d_lock);
 		prev =3D dget_dlock(root);
 		next =3D prev->d_subdirs.next;
 		p =3D prev;
@@ -107,12 +107,12 @@ static struct dentry *get_next_positive_subdir(struct=
 dentry *prev,
 	}
=20
 	p =3D prev;
-	spin_lock(&p->d_lock);
+	seq_spin_lock(&p->d_lock);
 again:
 	next =3D p->d_u.d_child.next;
 start:
 	if (next =3D=3D &root->d_subdirs) {
-		spin_unlock(&p->d_lock);
+		seq_spin_unlock(&p->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		dput(prev);
 		return NULL;
@@ -120,16 +120,16 @@ start:
=20
 	q =3D list_entry(next, struct dentry, d_u.d_child);
=20
-	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
 	if (!simple_positive(q)) {
-		spin_unlock(&p->d_lock);
+		seq_spin_unlock(&p->d_lock);
 		p =3D q;
 		goto again;
 	}
 	dget_dlock(q);
-	spin_unlock(&q->d_lock);
-	spin_unlock(&p->d_lock);
+	seq_spin_unlock(&q->d_lock);
+	seq_spin_unlock(&p->d_lock);
 	spin_unlock(&sbi->lookup_lock);
=20
 	dput(prev);
@@ -153,7 +153,7 @@ static struct dentry *get_next_positive_dentry(struct d=
entry *prev,
 	spin_lock(&sbi->lookup_lock);
 relock:
 	p =3D prev;
-	spin_lock(&p->d_lock);
+	seq_spin_lock(&p->d_lock);
 again:
 	next =3D p->d_subdirs.next;
 	if (next =3D=3D &p->d_subdirs) {
@@ -161,19 +161,19 @@ again:
 			struct dentry *parent;
=20
 			if (p =3D=3D root) {
-				spin_unlock(&p->d_lock);
+				seq_spin_unlock(&p->d_lock);
 				spin_unlock(&sbi->lookup_lock);
 				dput(prev);
 				return NULL;
 			}
=20
 			parent =3D p->d_parent;
-			if (!spin_trylock(&parent->d_lock)) {
-				spin_unlock(&p->d_lock);
+			if (!seq_spin_trylock(&parent->d_lock)) {
+				seq_spin_unlock(&p->d_lock);
 				cpu_relax();
 				goto relock;
 			}
-			spin_unlock(&p->d_lock);
+			seq_spin_unlock(&p->d_lock);
 			next =3D p->d_u.d_child.next;
 			p =3D parent;
 			if (next !=3D &parent->d_subdirs)
@@ -182,16 +182,16 @@ again:
 	}
 	ret =3D list_entry(next, struct dentry, d_u.d_child);
=20
-	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
 	if (!simple_positive(ret)) {
-		spin_unlock(&p->d_lock);
+		seq_spin_unlock(&p->d_lock);
 		p =3D ret;
 		goto again;
 	}
 	dget_dlock(ret);
-	spin_unlock(&ret->d_lock);
-	spin_unlock(&p->d_lock);
+	seq_spin_unlock(&ret->d_lock);
+	seq_spin_unlock(&p->d_lock);
 	spin_unlock(&sbi->lookup_lock);
=20
 	dput(prev);
@@ -462,11 +462,11 @@ found:
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&expired->d_parent->d_lock);
-	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock(&expired->d_parent->d_lock);
+	seq_spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
 	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
-	spin_unlock(&expired->d_lock);
-	spin_unlock(&expired->d_parent->d_lock);
+	seq_spin_unlock(&expired->d_lock);
+	seq_spin_unlock(&expired->d_parent->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 	return expired;
 }
@@ -556,7 +556,7 @@ int autofs4_do_expire_multi(struct super_block *sb, str=
uct vfsmount *mnt,
=20
 		spin_lock(&sbi->fs_lock);
 		ino->flags &=3D ~AUTOFS_INF_EXPIRING;
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (!ret) {
 			if ((IS_ROOT(dentry) ||
 			    (autofs_type_indirect(sbi->type) &&
@@ -564,7 +564,7 @@ int autofs4_do_expire_multi(struct super_block *sb, str=
uct vfsmount *mnt,
 			    !(dentry->d_flags & DCACHE_NEED_AUTOMOUNT))
 				__managed_dentry_set_automount(dentry);
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index f55ae23..4a52674 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -124,13 +124,13 @@ static int autofs4_dir_open(struct inode *inode, stru=
ct file *file)
 	 * it.
 	 */
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOENT;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	spin_unlock(&sbi->lookup_lock);
=20
 out:
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_active(struct dent=
ry *dentry)
 		ino =3D list_entry(p, struct autofs_info, active);
 		active =3D ino->dentry;
=20
-		spin_lock(&active->d_lock);
+		seq_spin_lock(&active->d_lock);
=20
 		/* Already gone? */
 		if (active->d_count =3D=3D 0)
@@ -199,12 +199,12 @@ static struct dentry *autofs4_lookup_active(struct de=
ntry *dentry)
=20
 		if (d_unhashed(active)) {
 			dget_dlock(active);
-			spin_unlock(&active->d_lock);
+			seq_spin_unlock(&active->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			return active;
 		}
 next:
-		spin_unlock(&active->d_lock);
+		seq_spin_unlock(&active->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
=20
@@ -231,7 +231,7 @@ static struct dentry *autofs4_lookup_expiring(struct de=
ntry *dentry)
 		ino =3D list_entry(p, struct autofs_info, expiring);
 		expiring =3D ino->dentry;
=20
-		spin_lock(&expiring->d_lock);
+		seq_spin_lock(&expiring->d_lock);
=20
 		/* Bad luck, we've already been dentry_iput */
 		if (!expiring->d_inode)
@@ -251,12 +251,12 @@ static struct dentry *autofs4_lookup_expiring(struct =
dentry *dentry)
=20
 		if (d_unhashed(expiring)) {
 			dget_dlock(expiring);
-			spin_unlock(&expiring->d_lock);
+			seq_spin_unlock(&expiring->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			return expiring;
 		}
 next:
-		spin_unlock(&expiring->d_lock);
+		seq_spin_unlock(&expiring->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
=20
@@ -382,12 +382,12 @@ static struct vfsmount *autofs4_d_automount(struct pa=
th *path)
 			if (have_submounts(dentry))
 				goto done;
 		} else {
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			if (!list_empty(&dentry->d_subdirs)) {
-				spin_unlock(&dentry->d_lock);
+				seq_spin_unlock(&dentry->d_lock);
 				goto done;
 			}
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 		}
 		ino->flags |=3D AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
@@ -410,12 +410,12 @@ done:
 		 * an actual mount so ->d_automount() won't be called during
 		 * the follow.
 		 */
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if ((!d_mountpoint(dentry) &&
 		    !list_empty(&dentry->d_subdirs)) ||
 		    (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)))
 			__managed_dentry_clear_automount(dentry);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&sbi->fs_lock);
=20
@@ -597,9 +597,9 @@ static int autofs4_dir_unlink(struct inode *dir, struct=
 dentry *dentry)
=20
 	spin_lock(&sbi->lookup_lock);
 	__autofs4_add_expiring(dentry);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	spin_unlock(&sbi->lookup_lock);
=20
 	return 0;
@@ -670,15 +670,15 @@ static int autofs4_dir_rmdir(struct inode *dir, struc=
t dentry *dentry)
 		return -EACCES;
=20
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOTEMPTY;
 	}
 	__autofs4_add_expiring(dentry);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	spin_unlock(&sbi->lookup_lock);
=20
 	if (sbi->version < 5)
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 1b8dc33..c473324 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -40,14 +40,14 @@ static int btrfs_encode_fh(struct dentry *dentry, u32 *=
fh, int *max_len,
 		struct inode *parent;
 		u64 parent_root_id;
=20
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
=20
 		parent =3D dentry->d_parent->d_inode;
 		fid->parent_objectid =3D BTRFS_I(parent)->location.objectid;
 		fid->parent_gen =3D parent->i_generation;
 		parent_root_id =3D BTRFS_I(parent)->root->objectid;
=20
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
=20
 		if (parent_root_id !=3D fid->root_objectid) {
 			fid->parent_root_objectid =3D parent_root_id;
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f605753..2c2ac3a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3065,14 +3065,14 @@ int ceph_encode_dentry_release(void **p, struct den=
try *dentry,
 	 * doesn't have to be perfect; the mds will revoke anything we don't
 	 * release.
 	 */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (di->lease_session && di->lease_session->s_mds =3D=3D mds)
 		force =3D 1;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	ret =3D ceph_encode_inode_release(p, dir, mds, drop, unless, force);
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (ret && di->lease_session && di->lease_session->s_mds =3D=3D mds) {
 		dout("encode_dentry_release %p mds%d seq %d\n",
 		     dentry, mds, (int)di->lease_seq);
@@ -3082,6 +3082,6 @@ int ceph_encode_dentry_release(void **p, struct dentr=
y *dentry,
 		rel->dname_seq =3D cpu_to_le32(di->lease_seq);
 		__ceph_mdsc_drop_dentry_lease(dentry);
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return ret;
 }
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 0dba691..0ecffe2 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -82,13 +82,13 @@ static int mdsc_show(struct seq_file *s, void *p)
 						    &pathbase, 0);
 			if (IS_ERR(path))
 				path =3D NULL;
-			spin_lock(&req->r_dentry->d_lock);
+			seq_spin_lock(&req->r_dentry->d_lock);
 			seq_printf(s, " #%llx/%.*s (%s)",
 				   ceph_ino(req->r_dentry->d_parent->d_inode),
 				   req->r_dentry->d_name.len,
 				   req->r_dentry->d_name.name,
 				   path ? path : "");
-			spin_unlock(&req->r_dentry->d_lock);
+			seq_spin_unlock(&req->r_dentry->d_lock);
 			kfree(path);
 		} else if (req->r_path1) {
 			seq_printf(s, " #%llx/%s", req->r_ino1.ino,
@@ -100,13 +100,13 @@ static int mdsc_show(struct seq_file *s, void *p)
 						    &pathbase, 0);
 			if (IS_ERR(path))
 				path =3D NULL;
-			spin_lock(&req->r_old_dentry->d_lock);
+			seq_spin_lock(&req->r_old_dentry->d_lock);
 			seq_printf(s, " #%llx/%.*s (%s)",
 			   ceph_ino(req->r_old_dentry->d_parent->d_inode),
 				   req->r_old_dentry->d_name.len,
 				   req->r_old_dentry->d_name.name,
 				   path ? path : "");
-			spin_unlock(&req->r_old_dentry->d_lock);
+			seq_spin_unlock(&req->r_old_dentry->d_lock);
 			kfree(path);
 		} else if (req->r_path2) {
 			if (req->r_ino2.ino)
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index ef8f08c..f0f6efd 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -52,7 +52,7 @@ int ceph_init_dentry(struct dentry *dentry)
 	if (!di)
 		return -ENOMEM;          /* oh well */
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_fsdata) {
 		/* lost a race */
 		kmem_cache_free(ceph_dentry_cachep, di);
@@ -64,7 +64,7 @@ int ceph_init_dentry(struct dentry *dentry)
 	dentry->d_time =3D jiffies;
 	ceph_dentry_lru_add(dentry);
 out_unlock:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return 0;
 }
=20
@@ -112,7 +112,7 @@ static int __dcache_readdir(struct file *filp,
 	dout("__dcache_readdir %p at %llu (last %p)\n", dir, filp->f_pos,
 	     last);
=20
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
=20
 	/* start at beginning? */
 	if (filp->f_pos =3D=3D 2 || last =3D=3D NULL ||
@@ -136,7 +136,7 @@ more:
 			fi->at_end =3D 1;
 			goto out_unlock;
 		}
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (!d_unhashed(dentry) && dentry->d_inode &&
 		    ceph_snap(dentry->d_inode) !=3D CEPH_SNAPDIR &&
 		    ceph_ino(dentry->d_inode) !=3D CEPH_INO_CEPH &&
@@ -146,15 +146,15 @@ more:
 		     dentry->d_name.len, dentry->d_name.name, di->offset,
 		     filp->f_pos, d_unhashed(dentry) ? " unhashed" : "",
 		     !dentry->d_inode ? " null" : "");
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		p =3D p->prev;
 		dentry =3D list_entry(p, struct dentry, d_u.d_child);
 		di =3D ceph_dentry(dentry);
 	}
=20
 	dget_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&parent->d_lock);
=20
 	dout(" %llu (%llu) dentry %p %.*s %p\n", di->offset, filp->f_pos,
 	     dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
@@ -187,12 +187,12 @@ more:
 		goto out;
 	}
=20
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	p =3D p->prev;	/* advance to next dentry */
 	goto more;
=20
 out_unlock:
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 out:
 	if (last)
 		dput(last);
@@ -917,10 +917,10 @@ static int ceph_rename(struct inode *old_dir, struct =
dentry *old_dentry,
  */
 void ceph_invalidate_dentry_lease(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_time =3D jiffies;
 	ceph_dentry(dentry)->lease_shared_gen =3D 0;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 /*
@@ -938,7 +938,7 @@ static int dentry_lease_is_valid(struct dentry *dentry)
 	struct inode *dir =3D NULL;
 	u32 seq =3D 0;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	di =3D ceph_dentry(dentry);
 	if (di && di->lease_session) {
 		s =3D di->lease_session;
@@ -962,7 +962,7 @@ static int dentry_lease_is_valid(struct dentry *dentry)
 			}
 		}
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	if (session) {
 		ceph_mdsc_lease_send_msg(session, dir, dentry,
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d8858e9..11f11ed 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -804,7 +804,7 @@ static void update_dentry_lease(struct dentry *dentry,
 	if (dentry->d_op !=3D &ceph_dentry_ops)
 		return;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dout("update_dentry_lease %p mask %d duration %lu ms ttl %lu\n",
 	     dentry, le16_to_cpu(lease->mask), duration, ttl);
=20
@@ -832,7 +832,7 @@ static void update_dentry_lease(struct dentry *dentry,
 	di->lease_renew_from =3D 0;
 	dentry->d_time =3D ttl;
 out_unlock:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return;
 }
=20
@@ -858,13 +858,13 @@ static void ceph_set_dentry_offset(struct dentry *dn)
 	di->offset =3D ceph_inode(inode)->i_max_offset++;
 	spin_unlock(&inode->i_lock);
=20
-	spin_lock(&dir->d_lock);
-	spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock(&dir->d_lock);
+	seq_spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 	list_move(&dn->d_u.d_child, &dir->d_subdirs);
 	dout("set_dentry_offset %p %lld (%p %p)\n", dn, di->offset,
 	     dn->d_u.d_child.prev, dn->d_u.d_child.next);
-	spin_unlock(&dn->d_lock);
-	spin_unlock(&dir->d_lock);
+	seq_spin_unlock(&dn->d_lock);
+	seq_spin_unlock(&dir->d_lock);
 }
=20
 /*
@@ -1248,11 +1248,11 @@ retry_lookup:
 			goto retry_lookup;
 		} else {
 			/* reorder parent's d_subdirs */
-			spin_lock(&parent->d_lock);
-			spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
+			seq_spin_lock(&parent->d_lock);
+			seq_spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 			list_move(&dn->d_u.d_child, &parent->d_subdirs);
-			spin_unlock(&dn->d_lock);
-			spin_unlock(&parent->d_lock);
+			seq_spin_unlock(&dn->d_lock);
+			seq_spin_unlock(&parent->d_lock);
 		}
=20
 		di =3D dn->d_fsdata;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0c1d917..da64709 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1476,7 +1476,7 @@ retry:
 	for (temp =3D dentry; !IS_ROOT(temp) && pos !=3D 0; ) {
 		struct inode *inode;
=20
-		spin_lock(&temp->d_lock);
+		seq_spin_lock(&temp->d_lock);
 		inode =3D temp->d_inode;
 		if (inode && ceph_snap(inode) =3D=3D CEPH_SNAPDIR) {
 			dout("build_path path+%d: %p SNAPDIR\n",
@@ -1487,13 +1487,13 @@ retry:
 		} else {
 			pos -=3D temp->d_name.len;
 			if (pos < 0) {
-				spin_unlock(&temp->d_lock);
+				seq_spin_unlock(&temp->d_lock);
 				break;
 			}
 			strncpy(path + pos, temp->d_name.name,
 				temp->d_name.len);
 		}
-		spin_unlock(&temp->d_lock);
+		seq_spin_unlock(&temp->d_lock);
 		if (pos)
 			path[--pos] =3D '/';
 		temp =3D temp->d_parent;
@@ -2758,7 +2758,7 @@ static void handle_lease(struct ceph_mds_client *mdsc=
,
 	if (!dentry)
 		goto release;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	di =3D ceph_dentry(dentry);
 	switch (h->action) {
 	case CEPH_MDS_LEASE_REVOKE:
@@ -2786,7 +2786,7 @@ static void handle_lease(struct ceph_mds_client *mdsc=
,
 		}
 		break;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	dput(dentry);
=20
 	if (!release)
@@ -2861,7 +2861,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *=
mdsc, struct inode *inode,
 	BUG_ON(mask =3D=3D 0);
=20
 	/* is dentry lease valid? */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	di =3D ceph_dentry(dentry);
 	if (!di || !di->lease_session ||
 	    di->lease_session->s_mds < 0 ||
@@ -2870,7 +2870,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *=
mdsc, struct inode *inode,
 		dout("lease_release inode %p dentry %p -- "
 		     "no lease on %d\n",
 		     inode, dentry, mask);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		return;
 	}
=20
@@ -2878,7 +2878,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *=
mdsc, struct inode *inode,
 	session =3D ceph_get_mds_session(di->lease_session);
 	seq =3D di->lease_seq;
 	__ceph_mdsc_drop_dentry_lease(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	dout("lease_release inode %p dentry %p mask %d to mds%d\n",
 	     inode, dentry, mask, session->s_mds);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 16cdd6d..337abab 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -88,10 +88,10 @@ cifs_bp_rename_retry:
 	full_path[namelen] =3D 0;	/* trailing null */
 	rcu_read_lock();
 	for (temp =3D direntry; !IS_ROOT(temp);) {
-		spin_lock(&temp->d_lock);
+		seq_spin_lock(&temp->d_lock);
 		namelen -=3D 1 + temp->d_name.len;
 		if (namelen < 0) {
-			spin_unlock(&temp->d_lock);
+			seq_spin_unlock(&temp->d_lock);
 			break;
 		} else {
 			full_path[namelen] =3D dirsep;
@@ -99,7 +99,7 @@ cifs_bp_rename_retry:
 				temp->d_name.len);
 			cFYI(0, "name: %s", full_path + namelen);
 		}
-		spin_unlock(&temp->d_lock);
+		seq_spin_unlock(&temp->d_lock);
 		temp =3D temp->d_parent;
 		if (temp =3D=3D NULL) {
 			cERROR(1, "corrupt dentry");
diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 6901578..93b5810 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -92,7 +92,7 @@ static void coda_flag_children(struct dentry *parent, int=
 flag)
 	struct list_head *child;
 	struct dentry *de;
=20
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	list_for_each(child, &parent->d_subdirs)
 	{
 		de =3D list_entry(child, struct dentry, d_u.d_child);
@@ -101,7 +101,7 @@ static void coda_flag_children(struct dentry *parent, i=
nt flag)
 			continue;
 		coda_flag_inode(de->d_inode, flag);
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 	return;=20
 }
=20
diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_interna=
l.h
index 82bda8f..2ebef5e 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -121,7 +121,7 @@ static inline struct config_item *configfs_get_config_i=
tem(struct dentry *dentry
 {
 	struct config_item * item =3D NULL;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (!d_unhashed(dentry)) {
 		struct configfs_dirent * sd =3D dentry->d_fsdata;
 		if (sd->s_type & CONFIGFS_ITEM_LINK) {
@@ -130,7 +130,7 @@ static inline struct config_item *configfs_get_config_i=
tem(struct dentry *dentry
 		} else
 			item =3D config_item_get(sd->s_element);
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	return item;
 }
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index c83f476..84d7e95 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -250,14 +250,14 @@ void configfs_drop_dentry(struct configfs_dirent * sd=
, struct dentry * parent)
 	struct dentry * dentry =3D sd->s_dentry;
=20
 	if (dentry) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
 			dget_dlock(dentry);
 			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			simple_unlink(parent->d_inode, dentry);
 		} else
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 	}
 }
=20
diff --git a/fs/dcache.c b/fs/dcache.c
index f598b98..10580be 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -171,9 +171,9 @@ static void d_free(struct dentry *dentry)
  */
 static inline void dentry_rcuwalk_barrier(struct dentry *dentry)
 {
-	assert_spin_locked(&dentry->d_lock);
+	assert_seq_spin_locked(&dentry->d_lock);
 	/* Go through a barrier */
-	write_seqcount_barrier(&dentry->d_seq);
+	write_seqlock_barrier(&dentry->d_lock);
 }
=20
 /*
@@ -189,7 +189,7 @@ static void dentry_iput(struct dentry * dentry)
 	if (inode) {
 		dentry->d_inode =3D NULL;
 		list_del_init(&dentry->d_alias);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
@@ -198,7 +198,7 @@ static void dentry_iput(struct dentry * dentry)
 		else
 			iput(inode);
 	} else {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 }
=20
@@ -214,7 +214,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	dentry->d_inode =3D NULL;
 	list_del_init(&dentry->d_alias);
 	dentry_rcuwalk_barrier(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
 	if (!inode->i_nlink)
 		fsnotify_inoderemove(inode);
@@ -292,7 +292,7 @@ static struct dentry *d_kill(struct dentry *dentry, str=
uct dentry *parent)
 	 */
 	dentry->d_flags |=3D DCACHE_DISCONNECTED;
 	if (parent)
-		spin_unlock(&parent->d_lock);
+		seq_spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
 	/*
 	 * dentry_iput drops the locks, at which point nobody (except
@@ -338,9 +338,9 @@ EXPORT_SYMBOL(__d_drop);
=20
 void d_drop(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 EXPORT_SYMBOL(d_drop);
=20
@@ -359,7 +359,7 @@ static inline struct dentry *dentry_kill(struct dentry =
*dentry, int ref)
 	inode =3D dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		cpu_relax();
 		return dentry; /* try again with same dentry */
 	}
@@ -367,7 +367,7 @@ relock:
 		parent =3D NULL;
 	else
 		parent =3D dentry->d_parent;
-	if (parent && !spin_trylock(&parent->d_lock)) {
+	if (parent && !seq_spin_trylock(&parent->d_lock)) {
 		if (inode)
 			spin_unlock(&inode->i_lock);
 		goto relock;
@@ -416,11 +416,11 @@ void dput(struct dentry *dentry)
 repeat:
 	if (dentry->d_count =3D=3D 1)
 		might_sleep();
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	BUG_ON(!dentry->d_count);
 	if (dentry->d_count > 1) {
 		dentry->d_count--;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		return;
 	}
=20
@@ -438,7 +438,7 @@ repeat:
 	dentry_lru_add(dentry);
=20
 	dentry->d_count--;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return;
=20
 kill_it:
@@ -465,9 +465,9 @@ int d_invalidate(struct dentry * dentry)
 	/*
 	 * If it's already been dropped, return OK.
 	 */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		return 0;
 	}
 	/*
@@ -475,9 +475,9 @@ int d_invalidate(struct dentry * dentry)
 	 * to get rid of unused child entries.
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		shrink_dcache_parent(dentry);
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 	}
=20
 	/*
@@ -492,13 +492,13 @@ int d_invalidate(struct dentry * dentry)
 	 */
 	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			return -EBUSY;
 		}
 	}
=20
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return 0;
 }
 EXPORT_SYMBOL(d_invalidate);
@@ -511,9 +511,9 @@ static inline void __dget_dlock(struct dentry *dentry)
=20
 static inline void __dget(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__dget_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 struct dentry *dget_parent(struct dentry *dentry)
@@ -531,16 +531,16 @@ repeat:
 		rcu_read_unlock();
 		goto out;
 	}
-	spin_lock(&ret->d_lock);
+	seq_spin_lock(&ret->d_lock);
 	if (unlikely(ret !=3D dentry->d_parent)) {
-		spin_unlock(&ret->d_lock);
+		seq_spin_unlock(&ret->d_lock);
 		rcu_read_unlock();
 		goto repeat;
 	}
 	rcu_read_unlock();
 	BUG_ON(!ret->d_count);
 	ret->d_count++;
-	spin_unlock(&ret->d_lock);
+	seq_spin_unlock(&ret->d_lock);
 out:
 	return ret;
 }
@@ -569,31 +569,31 @@ static struct dentry *__d_find_alias(struct inode *in=
ode, int want_discon)
 again:
 	discon_alias =3D NULL;
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
-		spin_lock(&alias->d_lock);
+		seq_spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
 				discon_alias =3D alias;
 			} else if (!want_discon) {
 				__dget_dlock(alias);
-				spin_unlock(&alias->d_lock);
+				seq_spin_unlock(&alias->d_lock);
 				return alias;
 			}
 		}
-		spin_unlock(&alias->d_lock);
+		seq_spin_unlock(&alias->d_lock);
 	}
 	if (discon_alias) {
 		alias =3D discon_alias;
-		spin_lock(&alias->d_lock);
+		seq_spin_lock(&alias->d_lock);
 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
 				__dget_dlock(alias);
-				spin_unlock(&alias->d_lock);
+				seq_spin_unlock(&alias->d_lock);
 				return alias;
 			}
 		}
-		spin_unlock(&alias->d_lock);
+		seq_spin_unlock(&alias->d_lock);
 		goto again;
 	}
 	return NULL;
@@ -622,16 +622,16 @@ void d_prune_aliases(struct inode *inode)
 restart:
 	spin_lock(&inode->i_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_dlock(dentry);
 			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			spin_unlock(&inode->i_lock);
 			dput(dentry);
 			goto restart;
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&inode->i_lock);
 }
@@ -668,10 +668,10 @@ static void try_prune_one_dentry(struct dentry *dentr=
y)
 	/* Prune ancestors. */
 	dentry =3D parent;
 	while (dentry) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (dentry->d_count > 1) {
 			dentry->d_count--;
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			return;
 		}
 		dentry =3D dentry_kill(dentry, 1);
@@ -687,9 +687,9 @@ static void shrink_dentry_list(struct list_head *list)
 		dentry =3D list_entry_rcu(list->prev, struct dentry, d_lru);
 		if (&dentry->d_lru =3D=3D list)
 			break; /* empty */
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (dentry !=3D list_entry(list->prev, struct dentry, d_lru)) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			continue;
 		}
=20
@@ -700,7 +700,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 */
 		if (dentry->d_count) {
 			dentry_lru_del(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			continue;
 		}
=20
@@ -736,7 +736,7 @@ relock:
 				struct dentry, d_lru);
 		BUG_ON(dentry->d_sb !=3D sb);
=20
-		if (!spin_trylock(&dentry->d_lock)) {
+		if (!seq_spin_trylock(&dentry->d_lock)) {
 			spin_unlock(&dcache_lru_lock);
 			cpu_relax();
 			goto relock;
@@ -751,11 +751,11 @@ relock:
 				dentry->d_flags & DCACHE_REFERENCED) {
 			dentry->d_flags &=3D ~DCACHE_REFERENCED;
 			list_move(&dentry->d_lru, &referenced);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 		} else {
 			list_move_tail(&dentry->d_lru, &tmp);
 			dentry->d_flags |=3D DCACHE_SHRINK_LIST;
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			if (!--cnt)
 				break;
 		}
@@ -880,10 +880,10 @@ static void shrink_dcache_for_umount_subtree(struct d=
entry *dentry)
 	BUG_ON(!IS_ROOT(dentry));
=20
 	/* detach this root from the system */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry_lru_del(dentry);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	for (;;) {
 		/* descend to the first leaf in the current subtree */
@@ -892,16 +892,16 @@ static void shrink_dcache_for_umount_subtree(struct d=
entry *dentry)
=20
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				spin_lock_nested(&loop->d_lock,
+				seq_spin_lock_nested(&loop->d_lock,
 						DENTRY_D_LOCK_NESTED);
 				dentry_lru_del(loop);
 				__d_drop(loop);
-				spin_unlock(&loop->d_lock);
+				seq_spin_unlock(&loop->d_lock);
 			}
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
=20
 			/* move to the first child */
 			dentry =3D list_entry(dentry->d_subdirs.next,
@@ -933,10 +933,10 @@ static void shrink_dcache_for_umount_subtree(struct d=
entry *dentry)
 				list_del(&dentry->d_u.d_child);
 			} else {
 				parent =3D dentry->d_parent;
-				spin_lock(&parent->d_lock);
+				seq_spin_lock(&parent->d_lock);
 				parent->d_count--;
 				list_del(&dentry->d_u.d_child);
-				spin_unlock(&parent->d_lock);
+				seq_spin_unlock(&parent->d_lock);
 			}
=20
 			detached++;
@@ -985,9 +985,9 @@ void shrink_dcache_for_umount(struct super_block *sb)
=20
 	dentry =3D sb->s_root;
 	sb->s_root =3D NULL;
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_count--;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	shrink_dcache_for_umount_subtree(dentry);
=20
 	while (!hlist_bl_empty(&sb->s_anon)) {
@@ -1007,8 +1007,8 @@ static struct dentry *try_to_ascend(struct dentry *ol=
d, int locked, unsigned seq
 	struct dentry *new =3D old->d_parent;
=20
 	rcu_read_lock();
-	spin_unlock(&old->d_lock);
-	spin_lock(&new->d_lock);
+	seq_spin_unlock(&old->d_lock);
+	seq_spin_lock(&new->d_lock);
=20
 	/*
 	 * might go back up the wrong parent if we have had a rename
@@ -1017,7 +1017,7 @@ static struct dentry *try_to_ascend(struct dentry *ol=
d, int locked, unsigned seq
 	if (new !=3D old->d_parent ||
 		 (old->d_flags & DCACHE_DISCONNECTED) ||
 		 (!locked && read_seqretry(&rename_lock, seq))) {
-		spin_unlock(&new->d_lock);
+		seq_spin_unlock(&new->d_lock);
 		new =3D NULL;
 	}
 	rcu_read_unlock();
@@ -1051,7 +1051,7 @@ again:
=20
 	if (d_mountpoint(parent))
 		goto positive;
-	spin_lock(&this_parent->d_lock);
+	seq_spin_lock(&this_parent->d_lock);
 repeat:
 	next =3D this_parent->d_subdirs.next;
 resume:
@@ -1060,21 +1060,21 @@ resume:
 		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_u.d_child);
 		next =3D tmp->next;
=20
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		/* Have we found a mount point ? */
 		if (d_mountpoint(dentry)) {
-			spin_unlock(&dentry->d_lock);
-			spin_unlock(&this_parent->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&this_parent->d_lock);
 			goto positive;
 		}
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			seq_spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.lock.dep_map, 1, _RET_IP_);
 			this_parent =3D dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&this_parent->d_lock.lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
@@ -1087,7 +1087,7 @@ resume:
 		next =3D child->d_u.d_child.next;
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
+	seq_spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
@@ -1132,7 +1132,7 @@ static int select_parent(struct dentry * parent)
 	seq =3D read_seqbegin(&rename_lock);
 again:
 	this_parent =3D parent;
-	spin_lock(&this_parent->d_lock);
+	seq_spin_lock(&this_parent->d_lock);
 repeat:
 	next =3D this_parent->d_subdirs.next;
 resume:
@@ -1141,7 +1141,7 @@ resume:
 		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_u.d_child);
 		next =3D tmp->next;
=20
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
=20
 		/*=20
 		 * move only zero ref count dentries to the end=20
@@ -1164,7 +1164,7 @@ resume:
 		 * the rest.
 		 */
 		if (found && need_resched()) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			goto out;
 		}
=20
@@ -1172,14 +1172,14 @@ resume:
 		 * Descend a level if the d_subdirs list is non-empty.
 		 */
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			seq_spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.lock.dep_map, 1, _RET_IP_);
 			this_parent =3D dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&this_parent->d_lock.lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
=20
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
@@ -1193,7 +1193,7 @@ resume:
 		goto resume;
 	}
 out:
-	spin_unlock(&this_parent->d_lock);
+	seq_spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
@@ -1294,8 +1294,7 @@ struct dentry *d_alloc(struct dentry * parent, const =
struct qstr *name)
=20
 	dentry->d_count =3D 1;
 	dentry->d_flags =3D 0;
-	spin_lock_init(&dentry->d_lock);
-	seqcount_init(&dentry->d_seq);
+	seqlock_init(&dentry->d_lock);
 	dentry->d_inode =3D NULL;
 	dentry->d_parent =3D NULL;
 	dentry->d_sb =3D NULL;
@@ -1308,7 +1307,7 @@ struct dentry *d_alloc(struct dentry * parent, const =
struct qstr *name)
 	INIT_LIST_HEAD(&dentry->d_u.d_child);
=20
 	if (parent) {
-		spin_lock(&parent->d_lock);
+		seq_spin_lock(&parent->d_lock);
 		/*
 		 * don't need child lock because it is not subject
 		 * to concurrency here
@@ -1318,7 +1317,7 @@ struct dentry *d_alloc(struct dentry * parent, const =
struct qstr *name)
 		dentry->d_sb =3D parent->d_sb;
 		d_set_d_op(dentry, dentry->d_sb->s_d_op);
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
-		spin_unlock(&parent->d_lock);
+		seq_spin_unlock(&parent->d_lock);
 	}
=20
 	this_cpu_inc(nr_dentry);
@@ -1375,7 +1374,7 @@ EXPORT_SYMBOL(d_set_d_op);
=20
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (inode) {
 		if (unlikely(IS_AUTOMOUNT(inode)))
 			dentry->d_flags |=3D DCACHE_NEED_AUTOMOUNT;
@@ -1383,7 +1382,7 @@ static void __d_instantiate(struct dentry *dentry, st=
ruct inode *inode)
 	}
 	dentry->d_inode =3D inode;
 	dentry_rcuwalk_barrier(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	fsnotify_d_instantiate(dentry, inode);
 }
=20
@@ -1589,7 +1588,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	}
=20
 	/* attach a disconnected dentry */
-	spin_lock(&tmp->d_lock);
+	seq_spin_lock(&tmp->d_lock);
 	tmp->d_sb =3D inode->i_sb;
 	d_set_d_op(tmp, tmp->d_sb->s_d_op);
 	tmp->d_inode =3D inode;
@@ -1598,7 +1597,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	hlist_bl_lock(&tmp->d_sb->s_anon);
 	hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
 	hlist_bl_unlock(&tmp->d_sb->s_anon);
-	spin_unlock(&tmp->d_lock);
+	seq_spin_unlock(&tmp->d_lock);
 	spin_unlock(&inode->i_lock);
 	security_d_instantiate(tmp, inode);
=20
@@ -1810,7 +1809,7 @@ struct dentry *__d_lookup_rcu(struct dentry *parent, =
struct qstr *name,
 			continue;
=20
 seqretry:
-		*seq =3D read_seqcount_begin(&dentry->d_seq);
+		*seq =3D read_seqbegin(&dentry->d_lock);
 		if (dentry->d_parent !=3D parent)
 			continue;
 		if (d_unhashed(dentry))
@@ -1825,7 +1824,7 @@ seqretry:
 		 * edge of memory when walking. If we could load this
 		 * atomically some other way, we could drop this check.
 		 */
-		if (read_seqcount_retry(&dentry->d_seq, *seq))
+		if (read_seqretry(&dentry->d_lock, *seq))
 			goto seqretry;
 		if (parent->d_flags & DCACHE_OP_COMPARE) {
 			if (parent->d_op->d_compare(parent, *inode,
@@ -1928,7 +1927,7 @@ struct dentry *__d_lookup(struct dentry *parent, stru=
ct qstr *name)
 		if (dentry->d_name.hash !=3D hash)
 			continue;
=20
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (dentry->d_parent !=3D parent)
 			goto next;
 		if (d_unhashed(dentry))
@@ -1952,10 +1951,10 @@ struct dentry *__d_lookup(struct dentry *parent, st=
ruct qstr *name)
=20
 		dentry->d_count++;
 		found =3D dentry;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		break;
 next:
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
  	}
  	rcu_read_unlock();
=20
@@ -2003,17 +2002,17 @@ int d_validate(struct dentry *dentry, struct dentry=
 *dparent)
 {
 	struct dentry *child;
=20
-	spin_lock(&dparent->d_lock);
+	seq_spin_lock(&dparent->d_lock);
 	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
 		if (dentry =3D=3D child) {
-			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+			seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 			__dget_dlock(dentry);
-			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dparent->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dparent->d_lock);
 			return 1;
 		}
 	}
-	spin_unlock(&dparent->d_lock);
+	seq_spin_unlock(&dparent->d_lock);
=20
 	return 0;
 }
@@ -2048,12 +2047,12 @@ void d_delete(struct dentry * dentry)
 	 * Are we the only user?
 	 */
 again:
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	inode =3D dentry->d_inode;
 	isdir =3D S_ISDIR(inode->i_mode);
 	if (dentry->d_count =3D=3D 1) {
 		if (inode && !spin_trylock(&inode->i_lock)) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			cpu_relax();
 			goto again;
 		}
@@ -2066,7 +2065,7 @@ again:
 	if (!d_unhashed(dentry))
 		__d_drop(dentry);
=20
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -2095,9 +2094,9 @@ static void _d_rehash(struct dentry * entry)
 =20
 void d_rehash(struct dentry * entry)
 {
-	spin_lock(&entry->d_lock);
+	seq_spin_lock(&entry->d_lock);
 	_d_rehash(entry);
-	spin_unlock(&entry->d_lock);
+	seq_spin_unlock(&entry->d_lock);
 }
 EXPORT_SYMBOL(d_rehash);
=20
@@ -2120,11 +2119,9 @@ void dentry_update_name_case(struct dentry *dentry, =
struct qstr *name)
 	BUG_ON(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex));
 	BUG_ON(dentry->d_name.len !=3D name->len); /* d_lookup gives this */
=20
-	spin_lock(&dentry->d_lock);
-	write_seqcount_begin(&dentry->d_seq);
+	write_seqlock(&dentry->d_lock);
 	memcpy((unsigned char *)dentry->d_name.name, name->name, name->len);
-	write_seqcount_end(&dentry->d_seq);
-	spin_unlock(&dentry->d_lock);
+	write_sequnlock(&dentry->d_lock);
 }
 EXPORT_SYMBOL(dentry_update_name_case);
=20
@@ -2175,24 +2172,24 @@ static void dentry_lock_for_move(struct dentry *den=
try, struct dentry *target)
 	 * XXXX: do we really need to take target->d_lock?
 	 */
 	if (IS_ROOT(dentry) || dentry->d_parent =3D=3D target->d_parent)
-		spin_lock(&target->d_parent->d_lock);
+		seq_spin_lock(&target->d_parent->d_lock);
 	else {
 		if (d_ancestor(dentry->d_parent, target->d_parent)) {
-			spin_lock(&dentry->d_parent->d_lock);
-			spin_lock_nested(&target->d_parent->d_lock,
-						DENTRY_D_LOCK_NESTED);
+			seq_spin_lock(&dentry->d_parent->d_lock);
+			seq_spin_lock_nested(&target->d_parent->d_lock,
+					    DENTRY_D_LOCK_NESTED);
 		} else {
-			spin_lock(&target->d_parent->d_lock);
-			spin_lock_nested(&dentry->d_parent->d_lock,
-						DENTRY_D_LOCK_NESTED);
+			seq_spin_lock(&target->d_parent->d_lock);
+			seq_spin_lock_nested(&dentry->d_parent->d_lock,
+					    DENTRY_D_LOCK_NESTED);
 		}
 	}
 	if (target < dentry) {
-		spin_lock_nested(&target->d_lock, 2);
-		spin_lock_nested(&dentry->d_lock, 3);
+		seq_spin_lock_nested(&target->d_lock, 2);
+		seq_spin_lock_nested(&dentry->d_lock, 3);
 	} else {
-		spin_lock_nested(&dentry->d_lock, 2);
-		spin_lock_nested(&target->d_lock, 3);
+		seq_spin_lock_nested(&dentry->d_lock, 2);
+		seq_spin_lock_nested(&target->d_lock, 3);
 	}
 }
=20
@@ -2200,9 +2197,9 @@ static void dentry_unlock_parents_for_move(struct den=
try *dentry,
 					struct dentry *target)
 {
 	if (target->d_parent !=3D dentry->d_parent)
-		spin_unlock(&dentry->d_parent->d_lock);
+		seq_spin_unlock(&dentry->d_parent->d_lock);
 	if (target->d_parent !=3D target)
-		spin_unlock(&target->d_parent->d_lock);
+		seq_spin_unlock(&target->d_parent->d_lock);
 }
=20
 /*
@@ -2235,8 +2232,8 @@ static void __d_move(struct dentry * dentry, struct d=
entry * target)
=20
 	dentry_lock_for_move(dentry, target);
=20
-	write_seqcount_begin(&dentry->d_seq);
-	write_seqcount_begin(&target->d_seq);
+	write_seqlock_begin(&dentry->d_lock);
+	write_seqlock_begin(&target->d_lock);
=20
 	/* __d_drop does write_seqcount_barrier, but they're OK to nest. */
=20
@@ -2271,13 +2268,13 @@ static void __d_move(struct dentry * dentry, struct=
 dentry * target)
=20
 	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
=20
-	write_seqcount_end(&target->d_seq);
-	write_seqcount_end(&dentry->d_seq);
+	write_seqlock_end(&target->d_lock);
+	write_seqlock_end(&dentry->d_lock);
=20
 	dentry_unlock_parents_for_move(dentry, target);
-	spin_unlock(&target->d_lock);
+	seq_spin_unlock(&target->d_lock);
 	fsnotify_d_move(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 /*
@@ -2365,8 +2362,8 @@ static void __d_materialise_dentry(struct dentry *den=
try, struct dentry *anon)
=20
 	dentry_lock_for_move(anon, dentry);
=20
-	write_seqcount_begin(&dentry->d_seq);
-	write_seqcount_begin(&anon->d_seq);
+	write_seqlock_begin(&dentry->d_lock);
+	write_seqlock_begin(&anon->d_lock);
=20
 	dparent =3D dentry->d_parent;
 	aparent =3D anon->d_parent;
@@ -2388,11 +2385,11 @@ static void __d_materialise_dentry(struct dentry *d=
entry, struct dentry *anon)
 	else
 		INIT_LIST_HEAD(&anon->d_u.d_child);
=20
-	write_seqcount_end(&dentry->d_seq);
-	write_seqcount_end(&anon->d_seq);
+	write_seqlock_end(&dentry->d_lock);
+	write_seqlock_end(&anon->d_lock);
=20
 	dentry_unlock_parents_for_move(anon, dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	/* anon->d_lock still locked, returns locked */
 	anon->d_flags &=3D ~DCACHE_DISCONNECTED;
@@ -2459,10 +2456,10 @@ struct dentry *d_materialise_unique(struct dentry *=
dentry, struct inode *inode)
 	else
 		BUG_ON(!d_unhashed(actual));
=20
-	spin_lock(&actual->d_lock);
+	seq_spin_lock(&actual->d_lock);
 found:
 	_d_rehash(actual);
-	spin_unlock(&actual->d_lock);
+	seq_spin_unlock(&actual->d_lock);
 	spin_unlock(&inode->i_lock);
 out_nolock:
 	if (actual =3D=3D dentry) {
@@ -2523,9 +2520,9 @@ static int prepend_path(const struct path *path,
 		}
 		parent =3D dentry->d_parent;
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		error =3D prepend_name(buffer, buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		if (!error)
 			error =3D prepend(buffer, buflen, "/", 1);
 		if (error)
@@ -2750,9 +2747,9 @@ static char *__dentry_path(struct dentry *dentry, cha=
r *buf, int buflen)
 		int error;
=20
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		error =3D prepend_name(&end, &buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		if (error !=3D 0 || prepend(&end, &buflen, "/", 1) !=3D 0)
 			goto Elong;
=20
@@ -2942,7 +2939,7 @@ void d_genocide(struct dentry *root)
 	seq =3D read_seqbegin(&rename_lock);
 again:
 	this_parent =3D root;
-	spin_lock(&this_parent->d_lock);
+	seq_spin_lock(&this_parent->d_lock);
 repeat:
 	next =3D this_parent->d_subdirs.next;
 resume:
@@ -2951,23 +2948,23 @@ resume:
 		struct dentry *dentry =3D list_entry(tmp, struct dentry, d_u.d_child);
 		next =3D tmp->next;
=20
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (d_unhashed(dentry) || !dentry->d_inode) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			continue;
 		}
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			seq_spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.lock.dep_map, 1, _RET_IP_);
 			this_parent =3D dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&this_parent->d_lock.lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
 			dentry->d_flags |=3D DCACHE_GENOCIDE;
 			dentry->d_count--;
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent !=3D root) {
 		struct dentry *child =3D this_parent;
@@ -2981,7 +2978,7 @@ resume:
 		next =3D child->d_u.d_child.next;
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
+	seq_spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
diff --git a/fs/dcookies.c b/fs/dcookies.c
index dda0dc7..3805e33 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -98,9 +98,9 @@ static struct dcookie_struct *alloc_dcookie(struct path *=
path)
 		return NULL;
=20
 	d =3D path->dentry;
-	spin_lock(&d->d_lock);
+	seq_spin_lock(&d->d_lock);
 	d->d_flags |=3D DCACHE_COOKIE;
-	spin_unlock(&d->d_lock);
+	seq_spin_unlock(&d->d_lock);
=20
 	dcs->path =3D *path;
 	path_get(path);
@@ -267,9 +267,9 @@ static void free_dcookie(struct dcookie_struct * dcs)
 {
 	struct dentry *d =3D dcs->path.dentry;
=20
-	spin_lock(&d->d_lock);
+	seq_spin_lock(&d->d_lock);
 	d->d_flags &=3D ~DCACHE_COOKIE;
-	spin_unlock(&d->d_lock);
+	seq_spin_unlock(&d->d_lock);
=20
 	path_put(&dcs->path);
 	kmem_cache_free(dcookie_cache, dcs);
diff --git a/fs/exec.c b/fs/exec.c
index 709557e..3116940 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1230,7 +1230,7 @@ int check_unsafe_exec(struct linux_binprm *bprm)
 	bprm->unsafe =3D tracehook_unsafe_exec(p);
=20
 	n_fs =3D 1;
-	spin_lock(&p->fs->lock);
+	seq_spin_lock(&p->fs->lock);
 	rcu_read_lock();
 	for (t =3D next_thread(p); t !=3D p; t =3D next_thread(t)) {
 		if (t->fs =3D=3D p->fs)
@@ -1247,7 +1247,7 @@ int check_unsafe_exec(struct linux_binprm *bprm)
 			res =3D 1;
 		}
 	}
-	spin_unlock(&p->fs->lock);
+	seq_spin_unlock(&p->fs->lock);
=20
 	return res;
 }
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index b05acb7..4515886 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -114,15 +114,15 @@ reconnect_path(struct vfsmount *mnt, struct dentry *t=
arget_dir, char *nbuf)
=20
 		if (!IS_ROOT(pd)) {
 			/* must have found a connected parent - great */
-			spin_lock(&pd->d_lock);
+			seq_spin_lock(&pd->d_lock);
 			pd->d_flags &=3D ~DCACHE_DISCONNECTED;
-			spin_unlock(&pd->d_lock);
+			seq_spin_unlock(&pd->d_lock);
 			noprogress =3D 0;
 		} else if (pd =3D=3D mnt->mnt_sb->s_root) {
 			printk(KERN_ERR "export: Eeek filesystem root is not connected, impossi=
ble\n");
-			spin_lock(&pd->d_lock);
+			seq_spin_lock(&pd->d_lock);
 			pd->d_flags &=3D ~DCACHE_DISCONNECTED;
-			spin_unlock(&pd->d_lock);
+			seq_spin_unlock(&pd->d_lock);
 			noprogress =3D 0;
 		} else {
 			/*
@@ -335,11 +335,11 @@ static int export_encode_fh(struct dentry *dentry, st=
ruct fid *fid,
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
=20
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		parent =3D dentry->d_parent->d_inode;
 		fid->i32.parent_ino =3D parent->i_ino;
 		fid->i32.parent_gen =3D parent->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		len =3D 4;
 		type =3D FILEID_INO32_GEN_PARENT;
 	}
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 44ab357..6df880d 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -770,9 +770,9 @@ fat_encode_fh(struct dentry *de, __u32 *fh, int *lenp, =
int connectable)
 	fh[1] =3D inode->i_generation;
 	fh[2] =3D ipos_h;
 	fh[3] =3D ipos_m | MSDOS_I(inode)->i_logstart;
-	spin_lock(&de->d_lock);
+	seq_spin_lock(&de->d_lock);
 	fh[4] =3D ipos_l | MSDOS_I(de->d_parent->d_inode)->i_logstart;
-	spin_unlock(&de->d_lock);
+	seq_spin_unlock(&de->d_lock);
 	return 3;
 }
=20
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 20b4ea5..74a0c20 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -34,10 +34,10 @@
 static int vfat_revalidate_shortname(struct dentry *dentry)
 {
 	int ret =3D 1;
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_time !=3D dentry->d_parent->d_inode->i_version)
 		ret =3D 0;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return ret;
 }
=20
diff --git a/fs/fhandle.c b/fs/fhandle.c
index 6b08864..9f437ac 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -115,10 +115,10 @@ static struct vfsmount *get_vfsmount_from_fd(int fd)
=20
 	if (fd =3D=3D AT_FDCWD) {
 		struct fs_struct *fs =3D current->fs;
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		path =3D fs->pwd;
 		mntget(path.mnt);
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 	} else {
 		int fput_needed;
 		struct file *file =3D fget_light(fd, &fput_needed);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fe190a8..50aed02 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -985,7 +985,7 @@ static noinline void block_dump___mark_inode_dirty(stru=
ct inode *inode)
=20
 		dentry =3D d_find_alias(inode);
 		if (dentry) {
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			name =3D (const char *) dentry->d_name.name;
 		}
 		printk(KERN_DEBUG
@@ -993,7 +993,7 @@ static noinline void block_dump___mark_inode_dirty(stru=
ct inode *inode)
 		       current->comm, task_pid_nr(current), inode->i_ino,
 		       name, inode->i_sb->s_id);
 		if (dentry) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			dput(dentry);
 		}
 	}
diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 78b519c..84db5f1 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -26,13 +26,11 @@ void set_fs_root(struct fs_struct *fs, struct path *pat=
h)
 {
 	struct path old_root;
=20
-	spin_lock(&fs->lock);
-	write_seqcount_begin(&fs->seq);
+	write_seqlock(&fs->lock);
 	old_root =3D fs->root;
 	fs->root =3D *path;
 	path_get_longterm(path);
-	write_seqcount_end(&fs->seq);
-	spin_unlock(&fs->lock);
+	write_sequnlock(&fs->lock);
 	if (old_root.dentry)
 		path_put_longterm(&old_root);
 }
@@ -45,13 +43,11 @@ void set_fs_pwd(struct fs_struct *fs, struct path *path=
)
 {
 	struct path old_pwd;
=20
-	spin_lock(&fs->lock);
-	write_seqcount_begin(&fs->seq);
+	write_seqlock(&fs->lock);
 	old_pwd =3D fs->pwd;
 	fs->pwd =3D *path;
 	path_get_longterm(path);
-	write_seqcount_end(&fs->seq);
-	spin_unlock(&fs->lock);
+	write_sequnlock(&fs->lock);
=20
 	if (old_pwd.dentry)
 		path_put_longterm(&old_pwd);
@@ -68,8 +64,7 @@ void chroot_fs_refs(struct path *old_root, struct path *n=
ew_root)
 		task_lock(p);
 		fs =3D p->fs;
 		if (fs) {
-			spin_lock(&fs->lock);
-			write_seqcount_begin(&fs->seq);
+			write_seqlock(&fs->lock);
 			if (fs->root.dentry =3D=3D old_root->dentry
 			    && fs->root.mnt =3D=3D old_root->mnt) {
 				path_get_longterm(new_root);
@@ -82,8 +77,7 @@ void chroot_fs_refs(struct path *old_root, struct path *n=
ew_root)
 				fs->pwd =3D *new_root;
 				count++;
 			}
-			write_seqcount_end(&fs->seq);
-			spin_unlock(&fs->lock);
+			write_sequnlock(&fs->lock);
 		}
 		task_unlock(p);
 	} while_each_thread(g, p);
@@ -106,12 +100,10 @@ void exit_fs(struct task_struct *tsk)
 	if (fs) {
 		int kill;
 		task_lock(tsk);
-		spin_lock(&fs->lock);
-		write_seqcount_begin(&fs->seq);
+		write_seqlock(&fs->lock);
 		tsk->fs =3D NULL;
 		kill =3D !--fs->users;
-		write_seqcount_end(&fs->seq);
-		spin_unlock(&fs->lock);
+		write_sequnlock(&fs->lock);
 		task_unlock(tsk);
 		if (kill)
 			free_fs_struct(fs);
@@ -125,16 +117,15 @@ struct fs_struct *copy_fs_struct(struct fs_struct *ol=
d)
 	if (fs) {
 		fs->users =3D 1;
 		fs->in_exec =3D 0;
-		spin_lock_init(&fs->lock);
-		seqcount_init(&fs->seq);
+		seqlock_init(&fs->lock);
 		fs->umask =3D old->umask;
=20
-		spin_lock(&old->lock);
+		seq_spin_lock(&old->lock);
 		fs->root =3D old->root;
 		path_get_longterm(&fs->root);
 		fs->pwd =3D old->pwd;
 		path_get_longterm(&fs->pwd);
-		spin_unlock(&old->lock);
+		seq_spin_unlock(&old->lock);
 	}
 	return fs;
 }
@@ -149,10 +140,10 @@ int unshare_fs_struct(void)
 		return -ENOMEM;
=20
 	task_lock(current);
-	spin_lock(&fs->lock);
+	seq_spin_lock(&fs->lock);
 	kill =3D !--fs->users;
 	current->fs =3D new_fs;
-	spin_unlock(&fs->lock);
+	seq_spin_unlock(&fs->lock);
 	task_unlock(current);
=20
 	if (kill)
@@ -171,8 +162,7 @@ EXPORT_SYMBOL(current_umask);
 /* to be mentioned only in INIT_TASK */
 struct fs_struct init_fs =3D {
 	.users		=3D 1,
-	.lock		=3D __SPIN_LOCK_UNLOCKED(init_fs.lock),
-	.seq		=3D SEQCNT_ZERO,
+	.lock		=3D __SEQLOCK_UNLOCKED(init_fs.lock),
 	.umask		=3D 0022,
 };
=20
@@ -185,14 +175,14 @@ void daemonize_fs_struct(void)
=20
 		task_lock(current);
=20
-		spin_lock(&init_fs.lock);
+		seq_spin_lock(&init_fs.lock);
 		init_fs.users++;
-		spin_unlock(&init_fs.lock);
+		seq_spin_unlock(&init_fs.lock);
=20
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		current->fs =3D &init_fs;
 		kill =3D !--fs->users;
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
=20
 		task_unlock(current);
 		if (kill)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 38f84cd..77e6c1c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -652,11 +652,11 @@ static int fuse_encode_fh(struct dentry *dentry, u32 =
*fh, int *max_len,
 	if (encode_parent) {
 		struct inode *parent;
=20
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		parent =3D dentry->d_parent->d_inode;
 		nodeid =3D get_fuse_inode(parent)->nodeid;
 		generation =3D parent->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
=20
 		fh[3] =3D (u32)(nodeid >> 32);
 		fh[4] =3D (u32)(nodeid & 0xffffffff);
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index fe9945f..dcc2f5a 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -53,11 +53,11 @@ static int gfs2_encode_fh(struct dentry *dentry, __u32 =
*p, int *len,
 	if (!connectable || inode =3D=3D sb->s_root->d_inode)
 		return *len;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	inode =3D dentry->d_parent->d_inode;
 	ip =3D GFS2_I(inode);
 	igrab(inode);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	fh[4] =3D cpu_to_be32(ip->i_no_formal_ino >> 32);
 	fh[5] =3D cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index dd4687f..378505b 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -139,13 +139,13 @@ isofs_export_encode_fh(struct dentry *dentry,
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
 		struct iso_inode_info *eparent;
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		parent =3D dentry->d_parent->d_inode;
 		eparent =3D ISOFS_I(parent);
 		fh32[3] =3D eparent->i_iget5_block;
 		fh16[3] =3D (__u16)eparent->i_iget5_offset;  /* fh16 [sic] */
 		fh32[4] =3D parent->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		len =3D 5;
 		type =3D 2;
 	}
diff --git a/fs/libfs.c b/fs/libfs.c
index 275ca474..b06c1a0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -100,21 +100,21 @@ loff_t dcache_dir_lseek(struct file *file, loff_t off=
set, int origin)
 			struct dentry *cursor =3D file->private_data;
 			loff_t n =3D file->f_pos - 2;
=20
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			/* d_lock not required for cursor */
 			list_del(&cursor->d_u.d_child);
 			p =3D dentry->d_subdirs.next;
 			while (n && p !=3D &dentry->d_subdirs) {
 				struct dentry *next;
 				next =3D list_entry(p, struct dentry, d_u.d_child);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				seq_spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				if (simple_positive(next))
 					n--;
-				spin_unlock(&next->d_lock);
+				seq_spin_unlock(&next->d_lock);
 				p =3D p->next;
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -157,35 +157,35 @@ int dcache_readdir(struct file * filp, void * dirent,=
 filldir_t filldir)
 			i++;
 			/* fallthrough */
 		default:
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			if (filp->f_pos =3D=3D 2)
 				list_move(q, &dentry->d_subdirs);
=20
 			for (p=3Dq->next; p !=3D &dentry->d_subdirs; p=3Dp->next) {
 				struct dentry *next;
 				next =3D list_entry(p, struct dentry, d_u.d_child);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				seq_spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				if (!simple_positive(next)) {
-					spin_unlock(&next->d_lock);
+					seq_spin_unlock(&next->d_lock);
 					continue;
 				}
=20
-				spin_unlock(&next->d_lock);
-				spin_unlock(&dentry->d_lock);
+				seq_spin_unlock(&next->d_lock);
+				seq_spin_unlock(&dentry->d_lock);
 				if (filldir(dirent, next->d_name.name,=20
 					    next->d_name.len, filp->f_pos,=20
 					    next->d_inode->i_ino,=20
 					    dt_type(next->d_inode)) < 0)
 					return 0;
-				spin_lock(&dentry->d_lock);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				seq_spin_lock(&dentry->d_lock);
+				seq_spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				/* next is still alive */
 				list_move(q, p);
-				spin_unlock(&next->d_lock);
+				seq_spin_unlock(&next->d_lock);
 				p =3D q;
 				filp->f_pos++;
 			}
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 	}
 	return 0;
 }
@@ -281,18 +281,18 @@ int simple_empty(struct dentry *dentry)
 	struct dentry *child;
 	int ret =3D 0;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
-		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 		if (simple_positive(child)) {
-			spin_unlock(&child->d_lock);
+			seq_spin_unlock(&child->d_lock);
 			goto out;
 		}
-		spin_unlock(&child->d_lock);
+		seq_spin_unlock(&child->d_lock);
 	}
 	ret =3D 1;
 out:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return ret;
 }
=20
diff --git a/fs/namei.c b/fs/namei.c
index f7593c0..4993e8f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -424,12 +424,12 @@ static int unlazy_walk(struct nameidata *nd, struct d=
entry *dentry)
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 	if (nd->root.mnt && !(nd->flags & LOOKUP_ROOT)) {
 		want_root =3D 1;
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		if (nd->root.mnt !=3D fs->root.mnt ||
 				nd->root.dentry !=3D fs->root.dentry)
 			goto err_root;
 	}
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	if (!dentry) {
 		if (!__d_rcu_to_refcount(parent, nd->seq))
 			goto err_parent;
@@ -437,7 +437,7 @@ static int unlazy_walk(struct nameidata *nd, struct den=
try *dentry)
 	} else {
 		if (dentry->d_parent !=3D parent)
 			goto err_parent;
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (!__d_rcu_to_refcount(dentry, nd->seq))
 			goto err_child;
 		/*
@@ -449,12 +449,12 @@ static int unlazy_walk(struct nameidata *nd, struct d=
entry *dentry)
 		BUG_ON(!IS_ROOT(dentry) && dentry->d_parent !=3D parent);
 		BUG_ON(!parent->d_count);
 		parent->d_count++;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 	if (want_root) {
 		path_get(&nd->root);
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 	}
 	mntget(nd->path.mnt);
=20
@@ -464,12 +464,12 @@ static int unlazy_walk(struct nameidata *nd, struct d=
entry *dentry)
 	return 0;
=20
 err_child:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 err_parent:
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 err_root:
 	if (want_root)
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 	return -ECHILD;
 }
=20
@@ -535,15 +535,15 @@ static int complete_walk(struct nameidata *nd)
 		nd->flags &=3D ~LOOKUP_RCU;
 		if (!(nd->flags & LOOKUP_ROOT))
 			nd->root.mnt =3D NULL;
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (unlikely(!__d_rcu_to_refcount(dentry, nd->seq))) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
 			br_read_unlock(vfsmount_lock);
 			return -ECHILD;
 		}
 		BUG_ON(nd->inode !=3D dentry->d_inode);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		mntget(nd->path.mnt);
 		rcu_read_unlock();
 		br_read_unlock(vfsmount_lock);
@@ -619,10 +619,10 @@ static __always_inline void set_root_rcu(struct namei=
data *nd)
 		unsigned seq;
=20
 		do {
-			seq =3D read_seqcount_begin(&fs->seq);
+			seq =3D read_seqbegin(&fs->lock);
 			nd->root =3D fs->root;
-			nd->seq =3D __read_seqcount_begin(&nd->root.dentry->d_seq);
-		} while (read_seqcount_retry(&fs->seq, seq));
+			nd->seq =3D __read_seqbegin(&nd->root.dentry->d_lock);
+		} while (read_seqretry(&fs->lock, seq));
 	}
 }
=20
@@ -959,7 +959,7 @@ static bool __follow_mount_rcu(struct nameidata *nd, st=
ruct path *path,
 		path->mnt =3D mounted;
 		path->dentry =3D mounted->mnt_root;
 		nd->flags |=3D LOOKUP_JUMPED;
-		nd->seq =3D read_seqcount_begin(&path->dentry->d_seq);
+		nd->seq =3D read_seqbegin(&path->dentry->d_lock);
 		/*
 		 * Update the inode too. We don't need to re-check the
 		 * dentry sequence number here after this d_inode read,
@@ -979,7 +979,7 @@ static void follow_mount_rcu(struct nameidata *nd)
 			break;
 		nd->path.mnt =3D mounted;
 		nd->path.dentry =3D mounted->mnt_root;
-		nd->seq =3D read_seqcount_begin(&nd->path.dentry->d_seq);
+		nd->seq =3D read_seqbegin(&nd->path.dentry->d_lock);
 	}
 }
=20
@@ -997,8 +997,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			struct dentry *parent =3D old->d_parent;
 			unsigned seq;
=20
-			seq =3D read_seqcount_begin(&parent->d_seq);
-			if (read_seqcount_retry(&old->d_seq, nd->seq))
+			seq =3D read_seqbegin(&parent->d_lock);
+			if (read_seqretry(&old->d_lock, nd->seq))
 				goto failed;
 			nd->path.dentry =3D parent;
 			nd->seq =3D seq;
@@ -1006,7 +1006,7 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 		}
 		if (!follow_up_rcu(&nd->path))
 			break;
-		nd->seq =3D read_seqcount_begin(&nd->path.dentry->d_seq);
+		nd->seq =3D read_seqbegin(&nd->path.dentry->d_lock);
 	}
 	follow_mount_rcu(nd);
 	nd->inode =3D nd->path.dentry->d_inode;
@@ -1166,7 +1166,7 @@ static int do_lookup(struct nameidata *nd, struct qst=
r *name,
 			goto unlazy;
=20
 		/* Memory barrier in read_seqcount_begin of child is enough */
-		if (__read_seqcount_retry(&parent->d_seq, nd->seq))
+		if (__read_seqretry(&parent->d_lock, nd->seq))
 			return -ECHILD;
 		nd->seq =3D seq;
=20
@@ -1473,7 +1473,7 @@ static int path_init(int dfd, const char *name, unsig=
ned int flags,
 		if (flags & LOOKUP_RCU) {
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
-			nd->seq =3D __read_seqcount_begin(&nd->path.dentry->d_seq);
+			nd->seq =3D __read_seqbegin(&nd->path.dentry->d_lock);
 		} else {
 			path_get(&nd->path);
 		}
@@ -1501,10 +1501,10 @@ static int path_init(int dfd, const char *name, uns=
igned int flags,
 			rcu_read_lock();
=20
 			do {
-				seq =3D read_seqcount_begin(&fs->seq);
+				seq =3D read_seqbegin(&fs->lock);
 				nd->path =3D fs->pwd;
-				nd->seq =3D __read_seqcount_begin(&nd->path.dentry->d_seq);
-			} while (read_seqcount_retry(&fs->seq, seq));
+				nd->seq =3D __read_seqbegin(&nd->path.dentry->d_lock);
+			} while (read_seqretry(&fs->lock, seq));
 		} else {
 			get_fs_pwd(current->fs, &nd->path);
 		}
@@ -1532,7 +1532,7 @@ static int path_init(int dfd, const char *name, unsig=
ned int flags,
 		if (flags & LOOKUP_RCU) {
 			if (fput_needed)
 				*fp =3D file;
-			nd->seq =3D __read_seqcount_begin(&nd->path.dentry->d_seq);
+			nd->seq =3D __read_seqbegin(&nd->path.dentry->d_lock);
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
 		} else {
@@ -2591,10 +2591,10 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathnam=
e, int, mode)
 void dentry_unhash(struct dentry *dentry)
 {
 	shrink_dcache_parent(dentry);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_count =3D=3D 1)
 		__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
diff --git a/fs/namespace.c b/fs/namespace.c
index 472caea..c563781 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -564,9 +564,9 @@ static void dentry_reset_mounted(struct vfsmount *mnt, =
struct dentry *dentry)
 				return;
 		}
 	}
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_flags &=3D ~DCACHE_MOUNTED;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 /*
@@ -591,9 +591,9 @@ void mnt_set_mountpoint(struct vfsmount *mnt, struct de=
ntry *dentry,
 {
 	child_mnt->mnt_parent =3D mntget(mnt);
 	child_mnt->mnt_mountpoint =3D dget(dentry);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_flags |=3D DCACHE_MOUNTED;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 /*
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 9c51f62..3c7d069 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -388,7 +388,7 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *par=
ent, unsigned long fpos)
 	}
=20
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	next =3D parent->d_subdirs.next;
 	while (next !=3D &parent->d_subdirs) {
 		dent =3D list_entry(next, struct dentry, d_u.d_child);
@@ -397,12 +397,12 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *p=
arent, unsigned long fpos)
 				dget(dent);
 			else
 				dent =3D NULL;
-			spin_unlock(&parent->d_lock);
+			seq_spin_unlock(&parent->d_lock);
 			goto out;
 		}
 		next =3D next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 	return NULL;
=20
 out:
diff --git a/fs/ncpfs/ncplib_kernel.h b/fs/ncpfs/ncplib_kernel.h
index 09881e6..d9ac5e5 100644
--- a/fs/ncpfs/ncplib_kernel.h
+++ b/fs/ncpfs/ncplib_kernel.h
@@ -191,7 +191,7 @@ ncp_renew_dentries(struct dentry *parent)
 	struct list_head *next;
 	struct dentry *dentry;
=20
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	next =3D parent->d_subdirs.next;
 	while (next !=3D &parent->d_subdirs) {
 		dentry =3D list_entry(next, struct dentry, d_u.d_child);
@@ -203,7 +203,7 @@ ncp_renew_dentries(struct dentry *parent)
=20
 		next =3D next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 }
=20
 static inline void
@@ -213,7 +213,7 @@ ncp_invalidate_dircache_entries(struct dentry *parent)
 	struct list_head *next;
 	struct dentry *dentry;
=20
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	next =3D parent->d_subdirs.next;
 	while (next !=3D &parent->d_subdirs) {
 		dentry =3D list_entry(next, struct dentry, d_u.d_child);
@@ -221,7 +221,7 @@ ncp_invalidate_dircache_entries(struct dentry *parent)
 		ncp_age_dentry(server, dentry);
 		next =3D next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 }
=20
 struct ncp_cache_head {
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 462a006..e0ce566 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1813,9 +1813,9 @@ static int nfs_unlink(struct inode *dir, struct dentr=
y *dentry)
 	dfprintk(VFS, "NFS: unlink(%s/%ld, %s)\n", dir->i_sb->s_id,
 		dir->i_ino, dentry->d_name.name);
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_count > 1) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		/* Start asynchronous writeout of the inode */
 		write_inode_now(dentry->d_inode, 0);
 		error =3D nfs_sillyrename(dir, dentry);
@@ -1825,7 +1825,7 @@ static int nfs_unlink(struct inode *dir, struct dentr=
y *dentry)
 		__d_drop(dentry);
 		need_rehash =3D 1;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	error =3D nfs_safe_remove(dentry);
 	if (!error || error =3D=3D -ENOENT) {
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index dcb6154..02ecd4d 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -64,9 +64,9 @@ static int nfs_superblock_set_dummy_root(struct super_blo=
ck *sb, struct inode *i
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
 		spin_lock(&sb->s_root->d_inode->i_lock);
-		spin_lock(&sb->s_root->d_lock);
+		seq_spin_lock(&sb->s_root->d_lock);
 		list_del_init(&sb->s_root->d_alias);
-		spin_unlock(&sb->s_root->d_lock);
+		seq_spin_unlock(&sb->s_root->d_lock);
 		spin_unlock(&sb->s_root->d_inode->i_lock);
 	}
 	return 0;
@@ -126,12 +126,12 @@ struct dentry *nfs_get_root(struct super_block *sb, s=
truct nfs_fh *mntfh,
 	}
=20
 	security_d_instantiate(ret, inode);
-	spin_lock(&ret->d_lock);
+	seq_spin_lock(&ret->d_lock);
 	if (IS_ROOT(ret) && !(ret->d_flags & DCACHE_NFSFS_RENAMED)) {
 		ret->d_fsdata =3D name;
 		name =3D NULL;
 	}
-	spin_unlock(&ret->d_lock);
+	seq_spin_unlock(&ret->d_lock);
 out:
 	if (name)
 		kfree(name);
@@ -250,12 +250,12 @@ struct dentry *nfs4_get_root(struct super_block *sb, =
struct nfs_fh *mntfh,
 	}
=20
 	security_d_instantiate(ret, inode);
-	spin_lock(&ret->d_lock);
+	seq_spin_lock(&ret->d_lock);
 	if (IS_ROOT(ret) && !(ret->d_flags & DCACHE_NFSFS_RENAMED)) {
 		ret->d_fsdata =3D name;
 		name =3D NULL;
 	}
-	spin_unlock(&ret->d_lock);
+	seq_spin_unlock(&ret->d_lock);
 out:
 	if (name)
 		kfree(name);
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 1f063ba..4b3ffaa 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -60,7 +60,7 @@ rename_retry:
 	seq =3D read_seqbegin(&rename_lock);
 	rcu_read_lock();
 	while (1) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (IS_ROOT(dentry))
 			break;
 		namelen =3D dentry->d_name.len;
@@ -70,17 +70,17 @@ rename_retry:
 		end -=3D namelen;
 		memcpy(end, dentry->d_name.name, namelen);
 		*--end =3D '/';
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		dentry =3D dentry->d_parent;
 	}
 	if (read_seqretry(&rename_lock, seq)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		rcu_read_unlock();
 		goto rename_retry;
 	}
 	if (*end !=3D '/') {
 		if (--buflen < 0) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
 			goto Elong;
 		}
@@ -89,7 +89,7 @@ rename_retry:
 	*p =3D end;
 	base =3D dentry->d_fsdata;
 	if (!base) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		rcu_read_unlock();
 		WARN_ON(1);
 		return end;
@@ -100,17 +100,17 @@ rename_retry:
 		namelen--;
 	buflen -=3D namelen;
 	if (buflen < 0) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		rcu_read_unlock();
 		goto Elong;
 	}
 	end -=3D namelen;
 	memcpy(end, base, namelen);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	rcu_read_unlock();
 	return end;
 Elong_unlock:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 8d6864c..5d2740d 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -155,7 +155,7 @@ static int nfs_do_call_unlink(struct dentry *parent, st=
ruct inode *dir, struct n
 		 * the sillyrename information to the aliased dentry.
 		 */
 		nfs_free_dname(data);
-		spin_lock(&alias->d_lock);
+		seq_spin_lock(&alias->d_lock);
 		if (alias->d_inode !=3D NULL &&
 		    !(alias->d_flags & DCACHE_NFSFS_RENAMED)) {
 			devname_garbage =3D alias->d_fsdata;
@@ -163,7 +163,7 @@ static int nfs_do_call_unlink(struct dentry *parent, st=
ruct inode *dir, struct n
 			alias->d_flags |=3D DCACHE_NFSFS_RENAMED;
 			ret =3D 1;
 		}
-		spin_unlock(&alias->d_lock);
+		seq_spin_unlock(&alias->d_lock);
 		nfs_dec_sillycount(dir);
 		dput(alias);
 		/*
@@ -275,13 +275,13 @@ nfs_async_unlink(struct inode *dir, struct dentry *de=
ntry)
 	data->res.dir_attr =3D &data->dir_attr;
=20
 	status =3D -EBUSY;
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED)
 		goto out_unlock;
 	dentry->d_flags |=3D DCACHE_NFSFS_RENAMED;
 	devname_garbage =3D dentry->d_fsdata;
 	dentry->d_fsdata =3D data;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	/*
 	 * If we'd displaced old cached devname, free it.  At that
 	 * point dentry is definitely not a root, so we won't need
@@ -291,7 +291,7 @@ nfs_async_unlink(struct inode *dir, struct dentry *dent=
ry)
 		kfree(devname_garbage);
 	return 0;
 out_unlock:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	put_rpccred(data->cred);
 out_free:
 	kfree(data);
@@ -313,13 +313,13 @@ nfs_complete_unlink(struct dentry *dentry, struct ino=
de *inode)
 {
 	struct nfs_unlinkdata	*data =3D NULL;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
 		dentry->d_flags &=3D ~DCACHE_NFSFS_RENAMED;
 		data =3D dentry->d_fsdata;
 		dentry->d_fsdata =3D NULL;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
=20
 	if (data !=3D NULL && (NFS_STALE(inode) || !nfs_call_unlink(dentry, data)=
))
 		nfs_free_unlinkdata(data);
@@ -329,17 +329,17 @@ nfs_complete_unlink(struct dentry *dentry, struct ino=
de *inode)
 static void
 nfs_cancel_async_unlink(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
 		struct nfs_unlinkdata *data =3D dentry->d_fsdata;
=20
 		dentry->d_flags &=3D ~DCACHE_NFSFS_RENAMED;
 		dentry->d_fsdata =3D NULL;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		nfs_free_unlinkdata(data);
 		return;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 struct nfs_renamedata {
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 546849b..e068a66 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -543,11 +543,11 @@ static int nilfs_encode_fh(struct dentry *dentry, __u=
32 *fh, int *lenp,
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
=20
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		parent =3D dentry->d_parent->d_inode;
 		fid->parent_ino =3D parent->i_ino;
 		fid->parent_gen =3D parent->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
=20
 		type =3D FILEID_NILFS_WITH_PARENT;
 		*lenp =3D NILFS_FID_SIZE_CONNECTABLE;
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 79b47cb..f3c5bd5 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -68,19 +68,19 @@ void __fsnotify_update_child_dentry_flags(struct inode =
*inode)
 		/* run all of the children of the original inode and fix their
 		 * d_flags to indicate parental interest (their parent is the
 		 * original inode) */
-		spin_lock(&alias->d_lock);
+		seq_spin_lock(&alias->d_lock);
 		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
 			if (!child->d_inode)
 				continue;
=20
-			spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+			seq_spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 			if (watched)
 				child->d_flags |=3D DCACHE_FSNOTIFY_PARENT_WATCHED;
 			else
 				child->d_flags &=3D ~DCACHE_FSNOTIFY_PARENT_WATCHED;
-			spin_unlock(&child->d_lock);
+			seq_spin_unlock(&child->d_lock);
 		}
-		spin_unlock(&alias->d_lock);
+		seq_spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&inode->i_lock);
 }
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index e86577d..2384a34 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -35,13 +35,13 @@ void fsnotify_clear_marks_by_mount(struct vfsmount *mnt=
)
 	struct hlist_node *pos, *n;
 	LIST_HEAD(free_list);
=20
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
 	hlist_for_each_entry_safe(mark, pos, n, &mnt->mnt_fsnotify_marks, m.m_lis=
t) {
 		list_add(&mark->m.free_m_list, &free_list);
 		hlist_del_init_rcu(&mark->m.m_list);
 		fsnotify_get_mark(mark);
 	}
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
=20
 	list_for_each_entry_safe(mark, lmark, &free_list, m.free_m_list) {
 		fsnotify_destroy_mark(mark);
@@ -63,7 +63,7 @@ static void fsnotify_recalc_vfsmount_mask_locked(struct v=
fsmount *mnt)
 	struct hlist_node *pos;
 	__u32 new_mask =3D 0;
=20
-	assert_spin_locked(&mnt->mnt_root->d_lock);
+	assert_seq_spin_locked(&mnt->mnt_root->d_lock);
=20
 	hlist_for_each_entry(mark, pos, &mnt->mnt_fsnotify_marks, m.m_list)
 		new_mask |=3D mark->mask;
@@ -76,9 +76,9 @@ static void fsnotify_recalc_vfsmount_mask_locked(struct v=
fsmount *mnt)
  */
 void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
 {
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
 }
=20
 void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
@@ -88,14 +88,14 @@ void fsnotify_destroy_vfsmount_mark(struct fsnotify_mar=
k *mark)
 	assert_spin_locked(&mark->lock);
 	assert_spin_locked(&mark->group->mark_lock);
=20
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
=20
 	hlist_del_init_rcu(&mark->m.m_list);
 	mark->m.mnt =3D NULL;
=20
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
=20
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
 }
=20
 static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsn=
otify_group *group,
@@ -104,7 +104,7 @@ static struct fsnotify_mark *fsnotify_find_vfsmount_mar=
k_locked(struct fsnotify_
 	struct fsnotify_mark *mark;
 	struct hlist_node *pos;
=20
-	assert_spin_locked(&mnt->mnt_root->d_lock);
+	assert_seq_spin_locked(&mnt->mnt_root->d_lock);
=20
 	hlist_for_each_entry(mark, pos, &mnt->mnt_fsnotify_marks, m.m_list) {
 		if (mark->group =3D=3D group) {
@@ -124,9 +124,9 @@ struct fsnotify_mark *fsnotify_find_vfsmount_mark(struc=
t fsnotify_group *group,
 {
 	struct fsnotify_mark *mark;
=20
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
 	mark =3D fsnotify_find_vfsmount_mark_locked(group, mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
=20
 	return mark;
 }
@@ -149,7 +149,7 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *ma=
rk,
 	assert_spin_locked(&mark->lock);
 	assert_spin_locked(&group->mark_lock);
=20
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
=20
 	mark->m.mnt =3D mnt;
=20
@@ -184,7 +184,7 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *ma=
rk,
 	hlist_add_after_rcu(last, &mark->m.m_list);
 out:
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
=20
 	return ret;
 }
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index e5ba348..d59a4c7 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -177,16 +177,16 @@ struct dentry *ocfs2_find_local_alias(struct inode *i=
node,
 	list_for_each(p, &inode->i_dentry) {
 		dentry =3D list_entry(p, struct dentry, d_alias);
=20
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
 			trace_ocfs2_find_local_alias(dentry->d_name.len,
 						     dentry->d_name.name);
=20
 			dget_dlock(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			break;
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
=20
 		dentry =3D NULL;
 	}
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 745db42..b48fa52 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -214,7 +214,7 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *=
fh_in, int *max_len,
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
=20
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
=20
 		parent =3D dentry->d_parent->d_inode;
 		blkno =3D OCFS2_I(parent)->ip_blkno;
@@ -224,7 +224,7 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *=
fh_in, int *max_len,
 		fh[4] =3D cpu_to_le32((u32)(blkno & 0xffffffff));
 		fh[5] =3D cpu_to_le32(generation);
=20
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
=20
 		len =3D 6;
 		type =3D 2;
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 4fd5bb3..8307f15 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1609,7 +1609,7 @@ int reiserfs_encode_fh(struct dentry *dentry, __u32 *=
 data, int *lenp,
 	if (maxlen < 5 || !need_parent)
 		return 3;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	inode =3D dentry->d_parent->d_inode;
 	data[3] =3D inode->i_ino;
 	data[4] =3D le32_to_cpu(INODE_PKEY(inode)->k_dir_id);
@@ -1618,7 +1618,7 @@ int reiserfs_encode_fh(struct dentry *dentry, __u32 *=
 data, int *lenp,
 		data[5] =3D inode->i_generation;
 		*lenp =3D 6;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return *lenp;
 }
=20
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index f1dce84..e2487a0 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1300,13 +1300,13 @@ static int udf_encode_fh(struct dentry *de, __u32 *=
fh, int *lenp,
 	fid->udf.generation =3D inode->i_generation;
=20
 	if (connectable && !S_ISDIR(inode->i_mode)) {
-		spin_lock(&de->d_lock);
+		seq_spin_lock(&de->d_lock);
 		inode =3D de->d_parent->d_inode;
 		location =3D UDF_I(inode)->i_location;
 		fid->udf.parent_block =3D location.logicalBlockNum;
 		fid->udf.parent_partref =3D location.partitionReferenceNum;
 		fid->udf.parent_generation =3D inode->i_generation;
-		spin_unlock(&de->d_lock);
+		seq_spin_unlock(&de->d_lock);
 		*lenp =3D 5;
 		type =3D FILEID_UDF_WITH_PARENT;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index fed3f3c..0470488 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -97,20 +97,20 @@ xfs_fs_encode_fh(
=20
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		fid->i32.parent_ino =3D XFS_I(dentry->d_parent->d_inode)->i_ino;
 		fid->i32.parent_gen =3D dentry->d_parent->d_inode->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN:
 		fid->i32.ino =3D XFS_I(inode)->i_ino;
 		fid->i32.gen =3D inode->i_generation;
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		fid64->parent_ino =3D XFS_I(dentry->d_parent->d_inode)->i_ino;
 		fid64->parent_gen =3D dentry->d_parent->d_inode->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
 		fid64->ino =3D XFS_I(inode)->i_ino;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index f13bb6d..92e23a0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -116,7 +116,7 @@ full_name_hash(const unsigned char *name, unsigned int =
len)
 struct dentry {
 	/* RCU lookup touched fields */
 	unsigned int d_flags;		/* protected by d_lock */
-	seqcount_t d_seq;		/* per dentry seqlock */
+	seqlock_t d_lock;		/* per dentry seqlock */
 	struct hlist_bl_node d_hash;	/* lookup hash list */
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
@@ -126,7 +126,6 @@ struct dentry {
=20
 	/* Ref lookup also touches following */
 	unsigned int d_count;		/* protected by d_lock */
-	spinlock_t d_lock;		/* per dentry lock */
 	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
 	unsigned long d_time;		/* used by d_revalidate */
@@ -324,8 +323,8 @@ static inline int __d_rcu_to_refcount(struct dentry *de=
ntry, unsigned seq)
 {
 	int ret =3D 0;
=20
-	assert_spin_locked(&dentry->d_lock);
-	if (!read_seqcount_retry(&dentry->d_seq, seq)) {
+	assert_seq_spin_locked(&dentry->d_lock);
+	if (!read_seqretry(&dentry->d_lock, seq)) {
 		ret =3D 1;
 		dentry->d_count++;
 	}
@@ -368,9 +367,9 @@ static inline struct dentry *dget_dlock(struct dentry *=
dentry)
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		dget_dlock(dentry);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	return dentry;
 }
@@ -401,9 +400,9 @@ static inline int cant_mount(struct dentry *dentry)
=20
 static inline void dont_mount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_flags |=3D DCACHE_CANT_MOUNT;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 extern void dput(struct dentry *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 223bdde..c7984a5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -876,9 +876,11 @@ static inline loff_t i_size_read(const struct inode *i=
node)
 static inline void i_size_write(struct inode *inode, loff_t i_size)
 {
 #if BITS_PER_LONG=3D=3D32 && defined(CONFIG_SMP)
+	preempt_disable_rt();
 	write_seqcount_begin(&inode->i_size_seqcount);
 	inode->i_size =3D i_size;
 	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable_rt();
 #elif BITS_PER_LONG=3D=3D32 && defined(CONFIG_PREEMPT)
 	preempt_disable();
 	inode->i_size =3D i_size;
@@ -2500,9 +2502,9 @@ static inline ino_t parent_ino(struct dentry *dentry)
 	 * Don't strictly need d_lock here? If the parent ino could change
 	 * then surely we'd have a deeper race in the caller?
 	 */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	res =3D dentry->d_parent->d_inode->i_ino;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return res;
 }
=20
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 003dc0f..f748403 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -2,13 +2,11 @@
 #define _LINUX_FS_STRUCT_H
=20
 #include <linux/path.h>
-#include <linux/spinlock.h>
 #include <linux/seqlock.h>
=20
 struct fs_struct {
 	int users;
-	spinlock_t lock;
-	seqcount_t seq;
+	seqlock_t lock;
 	int umask;
 	int in_exec;
 	struct path root, pwd;
@@ -26,29 +24,29 @@ extern int unshare_fs_struct(void);
=20
 static inline void get_fs_root(struct fs_struct *fs, struct path *root)
 {
-	spin_lock(&fs->lock);
+	seq_spin_lock(&fs->lock);
 	*root =3D fs->root;
 	path_get(root);
-	spin_unlock(&fs->lock);
+	seq_spin_unlock(&fs->lock);
 }
=20
 static inline void get_fs_pwd(struct fs_struct *fs, struct path *pwd)
 {
-	spin_lock(&fs->lock);
+	seq_spin_lock(&fs->lock);
 	*pwd =3D fs->pwd;
 	path_get(pwd);
-	spin_unlock(&fs->lock);
+	seq_spin_unlock(&fs->lock);
 }
=20
 static inline void get_fs_root_and_pwd(struct fs_struct *fs, struct path *=
root,
 				       struct path *pwd)
 {
-	spin_lock(&fs->lock);
+	seq_spin_lock(&fs->lock);
 	*root =3D fs->root;
 	path_get(root);
 	*pwd =3D fs->pwd;
 	path_get(pwd);
-	spin_unlock(&fs->lock);
+	seq_spin_unlock(&fs->lock);
 }
=20
 #endif /* _LINUX_FS_STRUCT_H */
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_back=
end.h
index 69ad89b..82d6939 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -329,7 +329,7 @@ static inline void __fsnotify_update_dcache_flags(struc=
t dentry *dentry)
 {
 	struct dentry *parent;
=20
-	assert_spin_locked(&dentry->d_lock);
+	assert_seq_spin_locked(&dentry->d_lock);
=20
 	/*
 	 * Serialisation of setting PARENT_WATCHED on the dentries is provided
@@ -353,9 +353,9 @@ static inline void __fsnotify_d_instantiate(struct dent=
ry *dentry, struct inode
 	if (!inode)
 		return;
=20
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__fsnotify_update_dcache_flags(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 /* called from fsnotify listeners, such as fanotify or dnotify */
diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index d8acbcc..9cfab36 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -204,9 +204,31 @@
 #else /* !PREEMPT_RT_FULL */
 #define DEFINE_LGLOCK(name)						\
 									\
- DEFINE_PER_CPU(struct rt_mutex, name##_lock);					\
+ DEFINE_PER_CPU(struct rt_mutex, name##_lock);				\
+ DEFINE_SPINLOCK(name##_cpu_lock);					\
+ cpumask_t name##_cpus __read_mostly;					\
  DEFINE_LGLOCK_LOCKDEP(name);						\
 									\
+ static int								\
+ name##_lg_cpu_callback(struct notifier_block *nb,			\
+				unsigned long action, void *hcpu)	\
+ {									\
+	switch (action & ~CPU_TASKS_FROZEN) {				\
+	case CPU_UP_PREPARE:						\
+		spin_lock(&name##_cpu_lock);				\
+		cpu_set((unsigned long)hcpu, name##_cpus);		\
+		spin_unlock(&name##_cpu_lock);				\
+		break;							\
+	case CPU_UP_CANCELED: case CPU_DEAD:				\
+		spin_lock(&name##_cpu_lock);				\
+		cpu_clear((unsigned long)hcpu, name##_cpus);		\
+		spin_unlock(&name##_cpu_lock);				\
+	}								\
+	return NOTIFY_OK;						\
+ }									\
+ static struct notifier_block name##_lg_cpu_notifier =3D {		\
+	.notifier_call =3D name##_lg_cpu_callback,			\
+ };									\
  void name##_lock_init(void) {						\
 	int i;								\
 	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
@@ -215,6 +237,11 @@
 		lock =3D &per_cpu(name##_lock, i);			\
 		rt_mutex_init(lock);					\
 	}								\
+	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
+	get_online_cpus();						\
+	for_each_online_cpu(i)						\
+		cpu_set(i, name##_cpus);				\
+	put_online_cpus();						\
  }									\
  EXPORT_SYMBOL(name##_lock_init);					\
 									\
@@ -255,7 +282,8 @@
  void name##_global_lock_online(void) {					\
 	int i;								\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	spin_lock(&name##_cpu_lock);					\
+	for_each_cpu(i, &name##_cpus) {					\
 		struct rt_mutex *lock;					\
 		lock =3D &per_cpu(name##_lock, i);			\
 		__rt_spin_lock(lock);					\
@@ -266,11 +294,12 @@
  void name##_global_unlock_online(void) {				\
 	int i;								\
 	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_cpu(i, &name##_cpus) {					\
 		struct rt_mutex *lock;					\
 		lock =3D &per_cpu(name##_lock, i);			\
 		__rt_spin_unlock(lock);					\
 	}								\
+	spin_unlock(&name##_cpu_lock);					\
  }									\
  EXPORT_SYMBOL(name##_global_unlock_online);				\
 									\
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..cc7a4e9 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -19,6 +19,11 @@ static inline void secure_computing(int this_syscall)
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long);
=20
+static inline int seccomp_mode(seccomp_t *s)
+{
+	return s->mode;
+}
+
 #else /* CONFIG_SECCOMP */
=20
 #include <linux/errno.h>
@@ -37,6 +42,11 @@ static inline long prctl_set_seccomp(unsigned long arg2)
 	return -EINVAL;
 }
=20
+static inline int seccomp_mode(seccomp_t *s)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SECCOMP */
=20
 #endif /* _LINUX_SECCOMP_H */
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e262353..29ffd4f 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -152,11 +152,6 @@ static inline void write_seqcount_barrier(seqcount_t *=
s)
=20
 typedef struct {
 	struct seqcount seqcount;
-	raw_spinlock_t lock;
-} raw_seqlock_t;
-
-typedef struct {
-	struct seqcount seqcount;
 	spinlock_t lock;
 } seqlock_t;
=20
@@ -164,21 +159,6 @@ typedef struct {
  * These macros triggered gcc-3.x compile-time problems.  We think these a=
re
  * OK now.  Be cautious.
  */
-#define __RAW_SEQLOCK_UNLOCKED(lockname)			\
-	{							\
-		.seqcount =3D SEQCNT_ZERO,			\
-		.lock =3D	__RAW_SPIN_LOCK_UNLOCKED(lockname)	\
-	}
-
-#define raw_seqlock_init(x)					\
-	do {							\
-		seqcount_init(&(x)->seqcount);			\
-		raw_spin_lock_init(&(x)->lock);			\
-	} while (0)
-
-#define DEFINE_RAW_SEQLOCK(x) \
-		raw_seqlock_t x =3D __RAW_SEQLOCK_UNLOCKED(x)
-
 #define __SEQLOCK_UNLOCKED(lockname)			\
 	{						\
 		.seqcount =3D SEQCNT_ZERO,		\
@@ -194,57 +174,60 @@ typedef struct {
 #define DEFINE_SEQLOCK(x) \
 		seqlock_t x =3D __SEQLOCK_UNLOCKED(x)
=20
-#define read_seqbegin(sl)		read_seqcount_begin(&(sl)->seqcount)
-#define read_seqretry(sl, start)	read_seqcount_retry(&(sl)->seqcount, star=
t)
-
 /*
- * Lock out other writers and update the count.
- * Acts like a normal spin_lock/unlock.
- * Don't need preempt_disable() because that is in the spin_lock already.
+ * Read side functions for starting and finalizing a read side section.
  */
-static inline void raw_write_seqlock(raw_seqlock_t *sl)
+#ifndef CONFIG_PREEMPT_RT_FULL
+static inline unsigned read_seqbegin(const seqlock_t *sl)
 {
-	raw_spin_lock(&sl->lock);
-	write_seqcount_begin(&sl->seqcount);
+	return read_seqcount_begin(&sl->seqcount);
 }
-
-static inline void raw_write_sequnlock(raw_seqlock_t *sl)
+#else
+/*
+ * Starvation safe read side for RT
+ */
+static inline unsigned read_seqbegin(seqlock_t *sl)
 {
-	write_seqcount_end(&sl->seqcount);
-	raw_spin_unlock(&sl->lock);
-}
+	unsigned ret;
=20
-static inline void raw_write_seqlock_irq(raw_seqlock_t *sl)
-{
-	raw_spin_lock_irq(&sl->lock);
-	write_seqcount_begin(&sl->seqcount);
+repeat:
+	ret =3D sl->seqcount.sequence;
+	if (unlikely(ret & 1)) {
+		/*
+		 * Take the lock and let the writer proceed (i.e. evtl
+		 * boost it), otherwise we could loop here forever.
+		 */
+		spin_lock(&sl->lock);
+		spin_unlock(&sl->lock);
+		goto repeat;
+	}
+	return ret;
 }
+#endif
=20
-static inline void raw_write_sequnlock_irq(raw_seqlock_t *sl)
+static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
 {
-	write_seqcount_end(&sl->seqcount);
-	raw_spin_unlock_irq(&sl->lock);
+	return read_seqcount_retry(&sl->seqcount, start);
 }
=20
-static inline unsigned long __raw_write_seqlock_irqsave(raw_seqlock_t *sl)
+/*
+ * Ditto w/o barriers
+ */
+static inline unsigned __read_seqbegin(const seqlock_t *sl)
 {
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sl->lock, flags);
-	write_seqcount_begin(&sl->seqcount);
-	return flags;
+	return __read_seqcount_begin(&sl->seqcount);
 }
=20
-#define raw_write_seqlock_irqsave(lock, flags)				\
-	do { flags =3D __raw_write_seqlock_irqsave(lock); } while (0)
-
-static inline void
-raw_write_sequnlock_irqrestore(raw_seqlock_t *sl, unsigned long flags)
+static inline unsigned __read_seqretry(const seqlock_t *sl, unsigned start=
)
 {
-	write_seqcount_end(&sl->seqcount);
-	raw_spin_unlock_irqrestore(&sl->lock, flags);
+	return __read_seqcount_retry(&sl->seqcount, start);
 }
=20
+/*
+ * Lock out other writers and update the count.
+ * Acts like a normal spin_lock/unlock.
+ * Don't need preempt_disable() because that is in the spin_lock already.
+ */
 static inline void write_seqlock(seqlock_t *sl)
 {
 	spin_lock(&sl->lock);
@@ -300,4 +283,55 @@ write_sequnlock_irqrestore(seqlock_t *sl, unsigned lon=
g flags)
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
=20
+/*
+ * Instead of open coding a spinlock and a seqcount, the following
+ * functions allow to serialize on the seqlock w/o touching seqcount.
+ */
+static inline void seq_spin_lock(seqlock_t *sl)
+{
+	spin_lock(&sl->lock);
+}
+
+static inline int seq_spin_trylock(seqlock_t *sl)
+{
+	return spin_trylock(&sl->lock);
+}
+
+static inline void seq_spin_unlock(seqlock_t *sl)
+{
+	spin_unlock(&sl->lock);
+}
+
+static inline void assert_seq_spin_locked(seqlock_t *sl)
+{
+	assert_spin_locked(&sl->lock);
+}
+
+static inline void seq_spin_lock_nested(seqlock_t *sl, int subclass)
+{
+	spin_lock_nested(&sl->lock, subclass);
+}
+
+/*
+ * For writers which need to take/release the lock w/o updating seqcount f=
or
+ * whatever reasons the following functions allow to update the count
+ * after the lock has been acquired or before it is released.
+ */
+static inline void write_seqlock_begin(seqlock_t *sl)
+{
+	assert_spin_locked(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_seqlock_end(seqlock_t *sl)
+{
+	assert_spin_locked(&sl->lock);
+	write_seqcount_end(&sl->seqcount);
+}
+
+static inline void write_seqlock_barrier(seqlock_t *sl)
+{
+	write_seqcount_barrier(&sl->seqcount);
+}
+
 #endif /* __LINUX_SEQLOCK_H */
diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.=
h
index 8da8c4e..b39549f 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -70,6 +70,7 @@ struct u64_stats_sync {
 static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
 #if BITS_PER_LONG=3D=3D32 && defined(CONFIG_SMP)
+	preempt_disable_rt();
 	write_seqcount_begin(&syncp->seq);
 #endif
 }
@@ -78,6 +79,7 @@ static inline void u64_stats_update_end(struct u64_stats_=
sync *syncp)
 {
 #if BITS_PER_LONG=3D=3D32 && defined(CONFIG_SMP)
 	write_seqcount_end(&syncp->seq);
+	preempt_enable_rt();
 #endif
 }
=20
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 4014b62..9c1cb97 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -377,7 +377,7 @@ struct neighbour_cb {
=20
 #define NEIGH_CB(skb)	((struct neighbour_cb *)(skb)->cb)
=20
-static inline void neigh_ha_snapshot(char *dst, const struct neighbour *n,
+static inline void neigh_ha_snapshot(char *dst, struct neighbour *n,
 				     const struct net_device *dev)
 {
 	unsigned int seq;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index feb47ec..761816c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -868,29 +868,29 @@ static void cgroup_clear_directory(struct dentry *den=
try)
 	struct list_head *node;
=20
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	node =3D dentry->d_subdirs.next;
 	while (node !=3D &dentry->d_subdirs) {
 		struct dentry *d =3D list_entry(node, struct dentry, d_u.d_child);
=20
-		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
 		if (d->d_inode) {
 			/* This should never be called on a cgroup
 			 * directory with child cgroups */
 			BUG_ON(d->d_inode->i_mode & S_IFDIR);
 			dget_dlock(d);
-			spin_unlock(&d->d_lock);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&d->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			d_delete(d);
 			simple_unlink(dentry->d_inode, d);
 			dput(d);
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 		} else
-			spin_unlock(&d->d_lock);
+			seq_spin_unlock(&d->d_lock);
 		node =3D dentry->d_subdirs.next;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
=20
 /*
@@ -903,11 +903,11 @@ static void cgroup_d_remove_dir(struct dentry *dentry=
)
 	cgroup_clear_directory(dentry);
=20
 	parent =3D dentry->d_parent;
-	spin_lock(&parent->d_lock);
-	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock(&parent->d_lock);
+	seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 	list_del_init(&dentry->d_u.d_child);
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 	remove_dir(dentry);
 }
=20
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b2de274..21c8380 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -46,7 +46,12 @@ static int cpu_hotplug_disabled;
=20
 static struct {
 	struct task_struct *active_writer;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/* Makes the lock keep the task's state */
+	spinlock_t lock;
+#else
 	struct mutex lock; /* Synchronizes accesses to refcount, */
+#endif
 	/*
 	 * Also blocks the new readers during
 	 * an ongoing cpu hotplug operation.
@@ -54,10 +59,22 @@ static struct {
 	int refcount;
 } cpu_hotplug =3D {
 	.active_writer =3D NULL,
+#ifdef CONFIG_PREEMPT_RT_FULL
+	.lock =3D __SPIN_LOCK_UNLOCKED(cpu_hotplug.lock),
+#else
 	.lock =3D __MUTEX_INITIALIZER(cpu_hotplug.lock),
+#endif
 	.refcount =3D 0,
 };
=20
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define hotplug_lock() rt_spin_lock(&cpu_hotplug.lock)
+# define hotplug_unlock() rt_spin_unlock(&cpu_hotplug.lock)
+#else
+# define hotplug_lock() mutex_lock(&cpu_hotplug.lock)
+# define hotplug_unlock() mutex_unlock(&cpu_hotplug.lock)
+#endif
+
 struct hotplug_pcp {
 	struct task_struct *unplug;
 	int refcount;
@@ -87,8 +104,8 @@ retry:
 		return;
 	}
 	preempt_enable();
-	mutex_lock(&cpu_hotplug.lock);
-	mutex_unlock(&cpu_hotplug.lock);
+	hotplug_lock();
+	hotplug_unlock();
 	preempt_disable();
 	goto retry;
 }
@@ -161,9 +178,9 @@ void get_online_cpus(void)
 	might_sleep();
 	if (cpu_hotplug.active_writer =3D=3D current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
+	hotplug_lock();
 	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
+	hotplug_unlock();
=20
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
@@ -172,10 +189,10 @@ void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer =3D=3D current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
+	hotplug_lock();
 	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
 		wake_up_process(cpu_hotplug.active_writer);
-	mutex_unlock(&cpu_hotplug.lock);
+	hotplug_unlock();
=20
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
@@ -207,11 +224,11 @@ static void cpu_hotplug_begin(void)
 	cpu_hotplug.active_writer =3D current;
=20
 	for (;;) {
-		mutex_lock(&cpu_hotplug.lock);
+		hotplug_lock();
 		if (likely(!cpu_hotplug.refcount))
 			break;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&cpu_hotplug.lock);
+		hotplug_unlock();
 		schedule();
 	}
 }
@@ -219,7 +236,7 @@ static void cpu_hotplug_begin(void)
 static void cpu_hotplug_done(void)
 {
 	cpu_hotplug.active_writer =3D NULL;
-	mutex_unlock(&cpu_hotplug.lock);
+	hotplug_unlock();
 }
=20
 #else /* #if CONFIG_HOTPLUG_CPU */
diff --git a/kernel/fork.c b/kernel/fork.c
index 0429130..1643f63 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -856,13 +856,13 @@ static int copy_fs(unsigned long clone_flags, struct =
task_struct *tsk)
 	struct fs_struct *fs =3D current->fs;
 	if (clone_flags & CLONE_FS) {
 		/* tsk->fs is already what we want */
-		spin_lock(&fs->lock);
+		seq_spin_lock(&fs->lock);
 		if (fs->in_exec) {
-			spin_unlock(&fs->lock);
+			seq_spin_unlock(&fs->lock);
 			return -EAGAIN;
 		}
 		fs->users++;
-		spin_unlock(&fs->lock);
+		seq_spin_unlock(&fs->lock);
 		return 0;
 	}
 	tsk->fs =3D copy_fs_struct(fs);
@@ -1729,13 +1729,13 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_fla=
gs)
=20
 		if (new_fs) {
 			fs =3D current->fs;
-			spin_lock(&fs->lock);
+			seq_spin_lock(&fs->lock);
 			current->fs =3D new_fs;
 			if (--fs->users)
 				new_fs =3D NULL;
 			else
 				new_fs =3D fs;
-			spin_unlock(&fs->lock);
+			seq_spin_unlock(&fs->lock);
 		}
=20
 		if (new_fd) {
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 789744a..a02fbd9 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1365,14 +1365,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock=
,
 	 * PI_REQUEUE_INPROGRESS, so that if the task is waking up
 	 * it will know that we are in the process of requeuing it.
 	 */
-	raw_spin_lock(&task->pi_lock);
+	raw_spin_lock_irq(&task->pi_lock);
 	if (task->pi_blocked_on) {
-		raw_spin_unlock(&task->pi_lock);
+		raw_spin_unlock_irq(&task->pi_lock);
 		raw_spin_unlock(&lock->wait_lock);
 		return -EAGAIN;
 	}
 	task->pi_blocked_on =3D PI_REQUEUE_INPROGRESS;
-	raw_spin_unlock(&task->pi_lock);
+	raw_spin_unlock_irq(&task->pi_lock);
 #endif
=20
 	ret =3D task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
diff --git a/kernel/sched.c b/kernel/sched.c
index e5ef7a8..df30481 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2284,7 +2284,8 @@ unsigned long wait_task_inactive(struct task_struct *=
p, long match_state)
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state !=3D match_state))
+			if (match_state && unlikely(p->state !=3D match_state)
+			    && unlikely(p->saved_state !=3D match_state))
 				return 0;
 			cpu_relax();
 		}
@@ -2299,7 +2300,8 @@ unsigned long wait_task_inactive(struct task_struct *=
p, long match_state)
 		running =3D task_running(rq, p);
 		on_rq =3D p->on_rq;
 		ncsw =3D 0;
-		if (!match_state || p->state =3D=3D match_state)
+		if (!match_state || p->state =3D=3D match_state
+		    || p->saved_state =3D=3D match_state)
 			ncsw =3D p->nvcsw | LONG_MIN; /* sets MSB */
 		task_rq_unlock(rq, p, &flags);
=20
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index a470154..21940eb 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -74,9 +74,9 @@ u64 get_jiffies_64(void)
 	u64 ret;
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
 		ret =3D jiffies_64;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 	return ret;
 }
 EXPORT_SYMBOL(get_jiffies_64);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index b510ba9..c465e88 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -358,7 +358,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrti=
mer *timer)
 {
 	enum hrtimer_restart res =3D HRTIMER_NORESTART;
=20
-	raw_write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
=20
 	switch (time_state) {
 	case TIME_OK:
@@ -388,7 +389,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrti=
mer *timer)
 		break;
 	}
=20
-	raw_write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
=20
 	return res;
 }
@@ -663,7 +665,8 @@ int do_adjtimex(struct timex *txc)
=20
 	getnstimeofday(&ts);
=20
-	raw_write_seqlock_irq(&xtime_lock);
+	raw_spin_lock_irq(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
=20
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust =3D time_adjust;
@@ -705,7 +708,8 @@ int do_adjtimex(struct timex *txc)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
=20
-	raw_write_sequnlock_irq(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irq(&xtime_lock);
=20
 	txc->time.tv_sec =3D ts.tv_sec;
 	txc->time.tv_usec =3D ts.tv_nsec;
@@ -903,7 +907,8 @@ void hardpps(const struct timespec *phase_ts, const str=
uct timespec *raw_ts)
=20
 	pts_norm =3D pps_normalize_ts(*phase_ts);
=20
-	raw_write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
=20
 	/* clear the error bits, they will be set again if needed */
 	time_status &=3D ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
@@ -916,7 +921,8 @@ void hardpps(const struct timespec *phase_ts, const str=
uct timespec *raw_ts)
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec =3D=3D 0)) {
 		pps_fbase =3D *raw_ts;
-		raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_seqcount_end(&xtime_seq);
+		raw_spin_unlock_irqrestore(&xtime_lock, flags);
 		return;
 	}
=20
@@ -931,7 +937,8 @@ void hardpps(const struct timespec *phase_ts, const str=
uct timespec *raw_ts)
 		time_status |=3D STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase =3D *raw_ts;
-		raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_seqcount_end(&xtime_seq);
+		raw_spin_unlock_irqrestore(&xtime_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -948,7 +955,8 @@ void hardpps(const struct timespec *phase_ts, const str=
uct timespec *raw_ts)
=20
 	hardpps_update_phase(pts_norm.nsec);
=20
-	raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
=20
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 174dba1..25fb6ad 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -63,13 +63,15 @@ int tick_is_oneshot_available(void)
 static void tick_periodic(int cpu)
 {
 	if (tick_do_timer_cpu =3D=3D cpu) {
-		raw_write_seqlock(&xtime_lock);
+		raw_spin_lock(&xtime_lock);
+		write_seqcount_begin(&xtime_seq);
=20
 		/* Keep track of the next tick event */
 		tick_next_period =3D ktime_add(tick_next_period, tick_period);
=20
 		do_timer(1);
-		raw_write_sequnlock(&xtime_lock);
+		write_seqcount_end(&xtime_seq);
+		raw_spin_unlock(&xtime_lock);
 	}
=20
 	update_process_times(user_mode(get_irq_regs()));
@@ -130,9 +132,9 @@ void tick_setup_periodic(struct clock_event_device *dev=
, int broadcast)
 		ktime_t next;
=20
 		do {
-			seq =3D read_seqbegin(&xtime_lock);
+			seq =3D read_seqcount_begin(&xtime_seq);
 			next =3D tick_next_period;
-		} while (read_seqretry(&xtime_lock, seq));
+		} while (read_seqcount_retry(&xtime_seq, seq));
=20
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
=20
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index dbda970..116e861 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -143,4 +143,5 @@ static inline int tick_device_is_functional(struct cloc=
k_event_device *dev)
 #endif
=20
 extern void do_timer(unsigned long ticks);
-extern raw_seqlock_t xtime_lock;
+extern raw_spinlock_t xtime_lock;
+extern seqcount_t xtime_seq;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 411fabc..5f620b0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -56,7 +56,8 @@ static void tick_do_update_jiffies64(ktime_t now)
 		return;
=20
 	/* Reevalute with xtime_lock held */
-	raw_write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
=20
 	delta =3D ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >=3D tick_period.tv64) {
@@ -79,7 +80,8 @@ static void tick_do_update_jiffies64(ktime_t now)
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period =3D ktime_add(last_jiffies_update, tick_period);
 	}
-	raw_write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
 }
=20
 /*
@@ -89,12 +91,14 @@ static ktime_t tick_init_jiffy_update(void)
 {
 	ktime_t period;
=20
-	raw_write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 	/* Did we start the jiffies update yet ? */
 	if (last_jiffies_update.tv64 =3D=3D 0)
 		last_jiffies_update =3D tick_next_period;
 	period =3D last_jiffies_update;
-	raw_write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
 	return period;
 }
=20
@@ -311,11 +315,11 @@ void tick_nohz_stop_sched_tick(int inidle)
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
 		last_update =3D last_jiffies_update;
 		last_jiffies =3D jiffies;
 		time_delta =3D timekeeping_max_deferment();
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
 	    arch_needs_cpu(cpu)) {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d040f93..6ac6438 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -139,7 +139,8 @@ static inline s64 timekeeping_get_ns_raw(void)
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime.
  */
-__cacheline_aligned_in_smp DEFINE_RAW_SEQLOCK(xtime_lock);
+__cacheline_aligned_in_smp DEFINE_RAW_SPINLOCK(xtime_lock);
+seqcount_t xtime_seq;
=20
 /*
  * The current time
@@ -221,7 +222,7 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
=20
 		*ts =3D xtime;
 		nsecs =3D timekeeping_get_ns();
@@ -229,7 +230,7 @@ void getnstimeofday(struct timespec *ts)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs +=3D arch_gettimeoffset();
=20
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	timespec_add_ns(ts, nsecs);
 }
@@ -244,14 +245,14 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
 		secs =3D xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs =3D xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs +=3D timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs +=3D arch_gettimeoffset();
=20
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -277,14 +278,14 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
 		*ts =3D xtime;
 		tomono =3D wall_to_monotonic;
 		nsecs =3D timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs +=3D arch_gettimeoffset();
=20
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec + nsecs);
@@ -312,7 +313,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, st=
ruct timespec *ts_real)
 	do {
 		u32 arch_offset;
=20
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
=20
 		*ts_raw =3D raw_time;
 		*ts_real =3D xtime;
@@ -325,7 +326,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, st=
ruct timespec *ts_real)
 		nsecs_raw +=3D arch_offset;
 		nsecs_real +=3D arch_offset;
=20
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -364,7 +365,8 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >=3D NSEC_PER_SEC)
 		return -EINVAL;
=20
-	raw_write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
=20
 	timekeeping_forward_now();
=20
@@ -380,7 +382,8 @@ int do_settimeofday(const struct timespec *tv)
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
=20
-	raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
=20
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -404,7 +407,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	if ((unsigned long)ts->tv_nsec >=3D NSEC_PER_SEC)
 		return -EINVAL;
=20
-	raw_write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
=20
 	timekeeping_forward_now();
=20
@@ -417,7 +421,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
=20
-	raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
=20
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -489,11 +494,11 @@ void getrawmonotonic(struct timespec *ts)
 	s64 nsecs;
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
 		nsecs =3D timekeeping_get_ns_raw();
 		*ts =3D raw_time;
=20
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	timespec_add_ns(ts, nsecs);
 }
@@ -509,11 +514,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
=20
 		ret =3D timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
=20
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	return ret;
 }
@@ -571,7 +576,8 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
=20
-	raw_write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
=20
 	ntp_init();
=20
@@ -592,7 +598,8 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	total_sleep_time.tv_sec =3D 0;
 	total_sleep_time.tv_nsec =3D 0;
-	raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 }
=20
 /* time in seconds when suspend began */
@@ -633,7 +640,8 @@ void timekeeping_inject_sleeptime(struct timespec *delt=
a)
 	if (!(ts.tv_sec =3D=3D 0 && ts.tv_nsec =3D=3D 0))
 		return;
=20
-	raw_write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 	timekeeping_forward_now();
=20
 	__timekeeping_inject_sleeptime(delta);
@@ -643,7 +651,8 @@ void timekeeping_inject_sleeptime(struct timespec *delt=
a)
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
=20
-	raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
=20
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -666,7 +675,8 @@ static void timekeeping_resume(void)
=20
 	clocksource_resume();
=20
-	raw_write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
=20
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts =3D timespec_sub(ts, timekeeping_suspend_time);
@@ -676,7 +686,8 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last =3D timekeeper.clock->read(timekeeper.clock)=
;
 	timekeeper.ntp_error =3D 0;
 	timekeeping_suspended =3D 0;
-	raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
=20
 	touch_softlockup_watchdog();
=20
@@ -692,10 +703,12 @@ static int timekeeping_suspend(void)
=20
 	read_persistent_clock(&timekeeping_suspend_time);
=20
-	raw_write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 	timekeeping_forward_now();
 	timekeeping_suspended =3D 1;
-	raw_write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
=20
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -986,13 +999,13 @@ void get_monotonic_boottime(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
 		*ts =3D xtime;
 		tomono =3D wall_to_monotonic;
 		sleep =3D total_sleep_time;
 		nsecs =3D timekeeping_get_ns();
=20
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
 			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
@@ -1043,10 +1056,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
=20
 		now =3D xtime;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	return now;
 }
@@ -1058,11 +1071,11 @@ struct timespec get_monotonic_coarse(void)
 	unsigned long seq;
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
=20
 		now =3D xtime;
 		mono =3D wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
=20
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1094,11 +1107,11 @@ void get_xtime_and_monotonic_and_sleep_offset(struc=
t timespec *xtim,
 	unsigned long seq;
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
 		*xtim =3D xtime;
 		*wtom =3D wall_to_monotonic;
 		*sleep =3D total_sleep_time;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 }
=20
 /**
@@ -1110,9 +1123,9 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
=20
 	do {
-		seq =3D read_seqbegin(&xtime_lock);
+		seq =3D read_seqcount_begin(&xtime_seq);
 		wtom =3D wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 	return timespec_to_ktime(wtom);
 }
=20
@@ -1124,7 +1137,9 @@ ktime_t ktime_get_monotonic_offset(void)
  */
 void xtime_update(unsigned long ticks)
 {
-	raw_write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 	do_timer(ticks);
-	raw_write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
 }
diff --git a/kernel/timer.c b/kernel/timer.c
index 937799f..a319c6a 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1743,21 +1743,17 @@ static void __cpuinit migrate_timers(int cpu)
 {
 	struct tvec_base *old_base;
 	struct tvec_base *new_base;
-	unsigned long flags;
 	int i;
=20
 	BUG_ON(cpu_online(cpu));
 	old_base =3D per_cpu(tvec_bases, cpu);
-	new_base =3D get_cpu_var(tvec_bases);
+	new_base =3D get_local_var(tvec_bases);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
 	 */
-	local_irq_save(flags);
-	while (!spin_trylock(&new_base->lock))
-		cpu_relax();
-	while (!spin_trylock(&old_base->lock))
-		cpu_relax();
+	spin_lock_irq(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
=20
 	BUG_ON(old_base->running_timer);
=20
@@ -1771,10 +1767,8 @@ static void __cpuinit migrate_timers(int cpu)
 	}
=20
 	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
-	local_irq_restore(flags);
-
-	put_cpu_var(tvec_bases);
+	spin_unlock_irq(&new_base->lock);
+	put_local_var(tvec_bases);
 }
 #endif /* CONFIG_HOTPLUG_CPU */
=20
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2467714..2ffbb9d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1045,7 +1045,7 @@ static inline int ok_to_lock(void)
 	if (in_nmi())
 		return 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
-	if (in_atomic())
+	if (in_atomic() || irqs_disabled())
 		return 0;
 #endif
 	return 1;
diff --git a/localversion-rt b/localversion-rt
index 49bae8d..5498386 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt38
+-rt39
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 72bc536..aeb9960 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -377,14 +377,14 @@ rpc_info_open(struct inode *inode, struct file *file)
 	if (!ret) {
 		struct seq_file *m =3D file->private_data;
=20
-		spin_lock(&file->f_path.dentry->d_lock);
+		seq_spin_lock(&file->f_path.dentry->d_lock);
 		if (!d_unhashed(file->f_path.dentry))
 			clnt =3D RPC_I(inode)->private;
 		if (clnt !=3D NULL && atomic_inc_not_zero(&clnt->cl_count)) {
-			spin_unlock(&file->f_path.dentry->d_lock);
+			seq_spin_unlock(&file->f_path.dentry->d_lock);
 			m->private =3D clnt;
 		} else {
-			spin_unlock(&file->f_path.dentry->d_lock);
+			seq_spin_unlock(&file->f_path.dentry->d_lock);
 			single_release(inode, file);
 			ret =3D -EINVAL;
 		}
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 3545934..f188c79 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1197,28 +1197,28 @@ static void sel_remove_entries(struct dentry *de)
 {
 	struct list_head *node;
=20
-	spin_lock(&de->d_lock);
+	seq_spin_lock(&de->d_lock);
 	node =3D de->d_subdirs.next;
 	while (node !=3D &de->d_subdirs) {
 		struct dentry *d =3D list_entry(node, struct dentry, d_u.d_child);
=20
-		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
=20
 		if (d->d_inode) {
 			dget_dlock(d);
-			spin_unlock(&de->d_lock);
-			spin_unlock(&d->d_lock);
+			seq_spin_unlock(&de->d_lock);
+			seq_spin_unlock(&d->d_lock);
 			d_delete(d);
 			simple_unlink(de->d_inode, d);
 			dput(d);
-			spin_lock(&de->d_lock);
+			seq_spin_lock(&de->d_lock);
 		} else
-			spin_unlock(&d->d_lock);
+			seq_spin_unlock(&d->d_lock);
 		node =3D de->d_subdirs.next;
 	}
=20
-	spin_unlock(&de->d_lock);
+	seq_spin_unlock(&de->d_lock);
 }
=20
 #define BOOL_DIR_NAME "booleans"


--=-DknHYn0s8Jn3do/SVJFd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPWh/NAAoJEIy3vGnGbaoA6t4QAIk7pJE+L2lEGtUVW8YLIBxn
bH4BN5QUmvf9OellwFUAg+mjzdfKGTFrbHw8PyqdDFD5gJZGdd86jSScKKMZEwtk
1PcSyprNjmEeRDr18ewnleXVoWzJ+z7Q0rz/knt4Gr2vLZEjW2jMcoL/p0an5N3X
m9so6O6jAiYE1PSt7DLkkDdbaWihc/XIswtOcDV+Sy9fJmfiHQzMrNR5LN9VhWCK
JkgKFNa2mhikS8oc0LhTGP2+N9Lq+37/Du6Q+BD3ga+ybATRhy0D+swC5dNhcSLk
QFgbn3GIQHm3+sk1E/rvzUEMAV3VLs+lUEuwU8MbByAiTIcINi/CKU+MIehekeQd
P/jVNoSDcnxyPSoxYp9yfuPiklf0dv24OxxQ/lTv3UoNWbQfBKyLGwtodOH6niSV
Rj1A0EzRGO6WMzbnmf95h7mlUZ3z2FdsnZHHxBdo8OTkpp+szQ7e0JieGIC4HXo6
DO9dRnAZDL26KFI7L8/+UInMikEUaVjRVylkdzXpjUiCZjpkovNW1tMBFCueM0zs
3zsFwlxGGI4W31NzZAsPF0llyKPy7Bt8p8CTq5doSyCMR2Yh+xpycCqbB4HsiF6P
vQaIPJiAGK5dU2YBsRCMtguy+ZaVGB5QlYQtNAA8ZYYXvqa5R5ZAU3ACst7OycXD
S5fU6JNHUibOUYqgUwL7
=+Fle
-----END PGP SIGNATURE-----

--=-DknHYn0s8Jn3do/SVJFd--

