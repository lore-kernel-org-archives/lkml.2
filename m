Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2E1Dhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:37:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52597 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754923Ab2E1Dhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:37:43 -0400
Message-ID: <1338176239.20487.159.camel@deadeye>
Subject: Re: [ 000/117] 3.2.19-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Mon, 28 May 2012 04:37:19 +0100
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
References: <20120528031202.829379252@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fYpoxokc9qiwXwcfoPKR"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fYpoxokc9qiwXwcfoPKR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index f7ade3b..59c080f 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -218,16 +218,16 @@ The development process
 Linux kernel development process currently consists of a few different
 main kernel "branches" and lots of different subsystem-specific kernel
 branches.  These different branches are:
-  - main 2.6.x kernel tree
-  - 2.6.x.y -stable kernel tree
-  - 2.6.x -git kernel patches
+  - main 3.x kernel tree
+  - 3.x.y -stable kernel tree
+  - 3.x -git kernel patches
   - subsystem specific kernel trees and patches
-  - the 2.6.x -next kernel tree for integration tests
+  - the 3.x -next kernel tree for integration tests
=20
-2.6.x kernel tree
+3.x kernel tree
 -----------------
-2.6.x kernels are maintained by Linus Torvalds, and can be found on
-kernel.org in the pub/linux/kernel/v2.6/ directory.  Its development
+3.x kernels are maintained by Linus Torvalds, and can be found on
+kernel.org in the pub/linux/kernel/v3.x/ directory.  Its development
 process is as follows:
   - As soon as a new kernel is released a two weeks window is open,
     during this period of time maintainers can submit big diffs to
@@ -262,20 +262,20 @@ mailing list about kernel releases:
 	released according to perceived bug status, not according to a
 	preconceived timeline."
=20
-2.6.x.y -stable kernel tree
+3.x.y -stable kernel tree
 ---------------------------
-Kernels with 4-part versions are -stable kernels. They contain
+Kernels with 3-part versions are -stable kernels. They contain
 relatively small and critical fixes for security problems or significant
-regressions discovered in a given 2.6.x kernel.
+regressions discovered in a given 3.x kernel.
=20
 This is the recommended branch for users who want the most recent stable
 kernel and are not interested in helping test development/experimental
 versions.
=20
-If no 2.6.x.y kernel is available, then the highest numbered 2.6.x
+If no 3.x.y kernel is available, then the highest numbered 3.x
 kernel is the current stable kernel.
=20
-2.6.x.y are maintained by the "stable" team <stable@vger.kernel.org>, and
+3.x.y are maintained by the "stable" team <stable@vger.kernel.org>, and
 are released as needs dictate.  The normal release period is approximately
 two weeks, but it can be longer if there are no pressing problems.  A
 security-related problem, instead, can cause a release to happen almost
@@ -285,7 +285,7 @@ The file Documentation/stable_kernel_rules.txt in the k=
ernel tree
 documents what kinds of changes are acceptable for the -stable tree, and
 how the release process works.
=20
-2.6.x -git patches
+3.x -git patches
 ------------------
 These are daily snapshots of Linus' kernel tree which are managed in a
 git repository (hence the name.) These patches are usually released
@@ -317,13 +317,13 @@ revisions to it, and maintainers can mark patches as =
under review,
 accepted, or rejected.  Most of these patchwork sites are listed at
 http://patchwork.kernel.org/.
=20
-2.6.x -next kernel tree for integration tests
+3.x -next kernel tree for integration tests
 ---------------------------------------------
-Before updates from subsystem trees are merged into the mainline 2.6.x
+Before updates from subsystem trees are merged into the mainline 3.x
 tree, they need to be integration-tested.  For this purpose, a special
 testing repository exists into which virtually all subsystem trees are
 pulled on an almost daily basis:
-	http://git.kernel.org/?p=3Dlinux/kernel/git/sfr/linux-next.git
+	http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git
 	http://linux.f-seidel.de/linux-next/pmwiki/
=20
 This way, the -next kernel gives a summary outlook onto what will be
diff --git a/Makefile b/Makefile
index add68f1..8c428f0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 18
-EXTRAVERSION =3D
+SUBLEVEL =3D 19
+EXTRAVERSION =3D -rc1
 NAME =3D Saber-toothed Squirrel
=20
 # *DOCUMENTATION*
@@ -443,6 +443,7 @@ asm-generic:
 no-dot-config-targets :=3D clean mrproper distclean \
 			 cscope gtags TAGS tags help %docs check% coccicheck \
 			 include/linux/version.h headers_% \
+			 include/linux/version.h headers_% archscripts \
 			 kernelversion %src-pkg
=20
 config-targets :=3D 0
@@ -979,7 +980,7 @@ prepare1: prepare2 include/linux/version.h include/gene=
rated/utsrelease.h \
                    include/config/auto.conf
 	$(cmd_crmodverdir)
=20
-archprepare: prepare1 scripts_basic
+archprepare: archscripts prepare1 scripts_basic
=20
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=3D.
@@ -1046,8 +1047,11 @@ hdr-inst :=3D -rR -f $(srctree)/scripts/Makefile.hea=
dersinst obj
 # If we do an all arch process set dst to asm-$(hdr-arch)
 hdr-dst =3D $(if $(KBUILD_HEADERS), dst=3Dinclude/asm-$(hdr-arch), dst=3Di=
nclude/asm)
=20
+PHONY +=3D archscripts
+archscripts:
+
 PHONY +=3D __headers
-__headers: include/linux/version.h scripts_basic asm-generic FORCE
+__headers: include/linux/version.h scripts_basic asm-generic archscripts F=
ORCE
 	$(Q)$(MAKE) $(build)=3Dscripts build_unifdef
=20
 PHONY +=3D headers_install_all
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cache=
flush.h
index d5d8d5c..1252a26 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -249,7 +249,7 @@ extern void flush_cache_page(struct vm_area_struct *vma=
, unsigned long user_addr
  * Harvard caches are synchronised for the user space address range.
  * This is used for the ARM private sys_cacheflush system call.
  */
-#define flush_cache_user_range(vma,start,end) \
+#define flush_cache_user_range(start,end) \
 	__cpuc_coherent_user_range((start) & PAGE_MASK, PAGE_ALIGN(end))
=20
 /*
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 99a5727..160cb16 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -488,7 +488,9 @@ do_cache_op(unsigned long start, unsigned long end, int=
 flags)
 		if (end > vma->vm_end)
 			end =3D vma->vm_end;
=20
-		flush_cache_user_range(vma, start, end);
+		up_read(&mm->mmap_sem);
+		flush_cache_user_range(start, end);
+		return;
 	}
 	up_read(&mm->mmap_sem);
 }
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 43f4c92..7073185 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1169,6 +1169,11 @@ out:
=20
 #define PALE_RESET_ENTRY    0x80000000ffffffb0UL
=20
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
+{
+	return irqchip_in_kernel(vcpu->kcm) =3D=3D (vcpu->arch.apic !=3D NULL);
+}
+
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu *v;
diff --git a/arch/parisc/include/asm/prefetch.h b/arch/parisc/include/asm/p=
refetch.h
index c5edc60..1ee7c82 100644
--- a/arch/parisc/include/asm/prefetch.h
+++ b/arch/parisc/include/asm/prefetch.h
@@ -21,7 +21,12 @@
 #define ARCH_HAS_PREFETCH
 static inline void prefetch(const void *addr)
 {
-	__asm__("ldw 0(%0), %%r0" : : "r" (addr));
+	__asm__(
+#ifndef CONFIG_PA20
+		/* Need to avoid prefetch of NULL on PA7300LC */
+		"	extrw,u,=3D %0,31,32,%%r0\n"
+#endif
+		"	ldw 0(%0), %%r0" : : "r" (addr));
 }
=20
 /* LDD is a PA2.0 addition. */
diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 6f05944..5350342 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -581,7 +581,11 @@
 	 */
 	cmpiclr,=3D	0x01,\tmp,%r0
 	ldi		(_PAGE_DIRTY|_PAGE_READ|_PAGE_WRITE),\prot
+#ifdef CONFIG_64BIT
 	depd,z		\prot,8,7,\prot
+#else
+	depw,z		\prot,8,7,\prot
+#endif
 	/*
 	 * OK, it is in the temp alias region, check whether "from" or "to".
 	 * Check "subtle" note in pacache.S re: r23/r26.
diff --git a/arch/parisc/kernel/pacache.S b/arch/parisc/kernel/pacache.S
index 93ff3d9..5d7218a 100644
--- a/arch/parisc/kernel/pacache.S
+++ b/arch/parisc/kernel/pacache.S
@@ -692,7 +692,7 @@ ENTRY(flush_icache_page_asm)
=20
 	/* Purge any old translation */
=20
-	pitlb		(%sr0,%r28)
+	pitlb		(%sr4,%r28)
=20
 	ldil		L%icache_stride, %r1
 	ldw		R%icache_stride(%r1), %r1
@@ -706,27 +706,29 @@ ENTRY(flush_icache_page_asm)
 	sub		%r25, %r1, %r25
=20
=20
-1:      fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
-	fic,m		%r1(%r28)
+	/* fic only has the type 26 form on PA1.1, requiring an
+	 * explicit space specification, so use %sr4 */
+1:      fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
+	fic,m		%r1(%sr4,%r28)
 	cmpb,COND(<<)		%r28, %r25,1b
-	fic,m		%r1(%r28)
+	fic,m		%r1(%sr4,%r28)
=20
 	sync
 	bv		%r0(%r2)
-	pitlb		(%sr0,%r25)
+	pitlb		(%sr4,%r25)
 	.exit
=20
 	.procend
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 0243454..a5f6eff 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -133,13 +133,6 @@ static int handle_stop(struct kvm_vcpu *vcpu)
=20
 	vcpu->stat.exit_stop_request++;
 	spin_lock_bh(&vcpu->arch.local_int.lock);
-	if (vcpu->arch.local_int.action_bits & ACTION_STORE_ON_STOP) {
-		vcpu->arch.local_int.action_bits &=3D ~ACTION_STORE_ON_STOP;
-		rc =3D kvm_s390_vcpu_store_status(vcpu,
-						  KVM_S390_STORE_STATUS_NOADDR);
-		if (rc >=3D 0)
-			rc =3D -EOPNOTSUPP;
-	}
=20
 	if (vcpu->arch.local_int.action_bits & ACTION_RELOADVCPU_ON_STOP) {
 		vcpu->arch.local_int.action_bits &=3D ~ACTION_RELOADVCPU_ON_STOP;
@@ -155,7 +148,18 @@ static int handle_stop(struct kvm_vcpu *vcpu)
 		rc =3D -EOPNOTSUPP;
 	}
=20
-	spin_unlock_bh(&vcpu->arch.local_int.lock);
+	if (vcpu->arch.local_int.action_bits & ACTION_STORE_ON_STOP) {
+		vcpu->arch.local_int.action_bits &=3D ~ACTION_STORE_ON_STOP;
+		/* store status must be called unlocked. Since local_int.lock
+		 * only protects local_int.* and not guest memory we can give
+		 * up the lock here */
+		spin_unlock_bh(&vcpu->arch.local_int.lock);
+		rc =3D kvm_s390_vcpu_store_status(vcpu,
+						KVM_S390_STORE_STATUS_NOADDR);
+		if (rc >=3D 0)
+			rc =3D -EOPNOTSUPP;
+	} else
+		spin_unlock_bh(&vcpu->arch.local_int.lock);
 	return rc;
 }
=20
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d1c44573..d3cb86c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -418,7 +418,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu=
,
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu=
)
 {
 	memcpy(&vcpu->arch.guest_fpregs.fprs, &fpu->fprs, sizeof(fpu->fprs));
-	vcpu->arch.guest_fpregs.fpc =3D fpu->fpc;
+	vcpu->arch.guest_fpregs.fpc =3D fpu->fpc & FPC_VALID_MASK;
 	restore_fp_regs(&vcpu->arch.guest_fpregs);
 	return 0;
 }
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index c7f0fbc..b28aaa4 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -583,6 +583,7 @@ static void pfault_interrupt(unsigned int ext_int_code,
 			tsk->thread.pfault_wait =3D 0;
 			list_del(&tsk->thread.list);
 			wake_up_process(tsk);
+			put_task_struct(tsk);
 		} else {
 			/* Completion interrupt was faster than initial
 			 * interrupt. Set pfault_wait to -1 so the initial
@@ -597,14 +598,22 @@ static void pfault_interrupt(unsigned int ext_int_cod=
e,
 		put_task_struct(tsk);
 	} else {
 		/* signal bit not set -> a real page is missing. */
-		if (tsk->thread.pfault_wait =3D=3D -1) {
+		if (tsk->thread.pfault_wait =3D=3D 1) {
+			/* Already on the list with a reference: put to sleep */
+			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			set_tsk_need_resched(tsk);
+		} else if (tsk->thread.pfault_wait =3D=3D -1) {
 			/* Completion interrupt was faster than the initial
 			 * interrupt (pfault_wait =3D=3D -1). Set pfault_wait
 			 * back to zero and exit. */
 			tsk->thread.pfault_wait =3D 0;
 		} else {
 			/* Initial interrupt arrived before completion
-			 * interrupt. Let the task sleep. */
+			 * interrupt. Let the task sleep.
+			 * An extra task reference is needed since a different
+			 * cpu may set the task state to TASK_RUNNING again
+			 * before the scheduler is reached. */
+			get_task_struct(tsk);
 			tsk->thread.pfault_wait =3D 1;
 			list_add(&tsk->thread.list, &pfault_list);
 			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
@@ -629,6 +638,7 @@ static int __cpuinit pfault_cpu_notify(struct notifier_=
block *self,
 			list_del(&thread->list);
 			tsk =3D container_of(thread, struct task_struct, thread);
 			wake_up_process(tsk);
+			put_task_struct(tsk);
 		}
 		spin_unlock_irq(&pfault_lock);
 		break;
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index f92602e..f210d51 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -583,6 +583,9 @@ config SYSVIPC_COMPAT
 	depends on COMPAT && SYSVIPC
 	default y
=20
+config KEYS_COMPAT
+	def_bool y if COMPAT && KEYS
+
 endmenu
=20
 source "net/Kconfig"
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.=
S
index db86b1a..3a58e0d 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -74,7 +74,7 @@ sys_call_table32:
 	.word sys_timer_delete, compat_sys_timer_create, sys_ni_syscall, compat_s=
ys_io_setup, sys_io_destroy
 /*270*/	.word sys32_io_submit, sys_io_cancel, compat_sys_io_getevents, sys=
32_mq_open, sys_mq_unlink
 	.word compat_sys_mq_timedsend, compat_sys_mq_timedreceive, compat_sys_mq_=
notify, compat_sys_mq_getsetattr, compat_sys_waitid
-/*280*/	.word sys32_tee, sys_add_key, sys_request_key, sys_keyctl, compat_=
sys_openat
+/*280*/	.word sys32_tee, sys_add_key, sys_request_key, compat_sys_keyctl, =
compat_sys_openat
 	.word sys_mkdirat, sys_mknodat, sys_fchownat, compat_sys_futimesat, compa=
t_sys_fstatat64
 /*290*/	.word sys_unlinkat, sys_renameat, sys_linkat, sys_symlinkat, sys_r=
eadlinkat
 	.word sys_fchmodat, sys_faccessat, compat_sys_pselect6, compat_sys_ppoll,=
 sys_unshare
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 70a0de4..6cb8319 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -11,8 +11,9 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select HAVE_SYSCALL_WRAPPERS if TILEGX
 	select SYS_HYPERVISOR
-	select ARCH_HAVE_NMI_SAFE_CMPXCHG if !M386
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
=20
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.=
h
index 16f1fa5..bd186c4 100644
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -77,6 +77,11 @@ static inline int ffs(int x)
 	return __builtin_ffs(x);
 }
=20
+static inline int fls64(__u64 w)
+{
+	return (sizeof(__u64) * 8) - __builtin_clzll(w);
+}
+
 /**
  * fls - find last set bit in word
  * @x: the word to search
@@ -90,12 +95,7 @@ static inline int ffs(int x)
  */
 static inline int fls(int x)
 {
-	return (sizeof(int) * 8) - __builtin_clz(x);
-}
-
-static inline int fls64(__u64 w)
-{
-	return (sizeof(__u64) * 8) - __builtin_clzll(w);
+	return fls64((unsigned int) x);
 }
=20
 static inline unsigned int __arch_hweight32(unsigned int w)
diff --git a/arch/um/include/asm/pgtable.h b/arch/um/include/asm/pgtable.h
index 41474fb..aa365c5 100644
--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -271,6 +271,12 @@ static inline void set_pte(pte_t *pteptr, pte_t pteval=
)
 }
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
=20
+#define __HAVE_ARCH_PTE_SAME
+static inline int pte_same(pte_t pte_a, pte_t pte_b)
+{
+	return !((pte_val(pte_a) ^ pte_val(pte_b)) & ~_PAGE_NEWPAGE);
+}
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
@@ -346,11 +352,11 @@ extern pte_t *virt_to_pte(struct mm_struct *mm, unsig=
ned long addr);
 #define update_mmu_cache(vma,address,ptep) do ; while (0)
=20
 /* Encode and de-code a swap entry */
-#define __swp_type(x)			(((x).val >> 4) & 0x3f)
+#define __swp_type(x)			(((x).val >> 5) & 0x1f)
 #define __swp_offset(x)			((x).val >> 11)
=20
 #define __swp_entry(type, offset) \
-	((swp_entry_t) { ((type) << 4) | ((offset) << 11) })
+	((swp_entry_t) { ((type) << 5) | ((offset) << 11) })
 #define __pte_to_swp_entry(pte) \
 	((swp_entry_t) { pte_val(pte_mkuptodate(pte)) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b02e509..03dbc7f5b 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -117,6 +117,9 @@ KBUILD_CFLAGS +=3D $(call cc-option,-mno-sse -mno-mmx -=
mno-sse2 -mno-3dnow,)
 KBUILD_CFLAGS +=3D $(mflags-y)
 KBUILD_AFLAGS +=3D $(mflags-y)
=20
+archscripts:
+	$(Q)$(MAKE) $(build)=3Darch/x86/tools relocs
+
 ###
 # Kernel objects
=20
@@ -180,6 +183,7 @@ archclean:
 	$(Q)rm -rf $(objtree)/arch/i386
 	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=3D$(boot)
+	$(Q)$(MAKE) $(clean)=3Darch/x86/tools
=20
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/M=
akefile
index 09664ef..77453c6 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -31,13 +31,12 @@ OBJCOPYFLAGS_vmlinux.bin :=3D  -R .comment -S
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
=20
+targets +=3D vmlinux.bin.all vmlinux.relocs
=20
-targets +=3D vmlinux.bin.all vmlinux.relocs relocs
-hostprogs-$(CONFIG_X86_NEED_RELOCS) +=3D relocs
-
+CMD_RELOCS =3D arch/x86/tools/relocs
 quiet_cmd_relocs =3D RELOCS  $@
-      cmd_relocs =3D $(obj)/relocs $< > $@;$(obj)/relocs --abs-relocs $<
-$(obj)/vmlinux.relocs: vmlinux $(obj)/relocs FORCE
+      cmd_relocs =3D $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
+$(obj)/vmlinux.relocs: vmlinux FORCE
 	$(call if_changed,relocs)
=20
 vmlinux.bin.all-y :=3D $(obj)/vmlinux.bin
diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/r=
elocs.c
deleted file mode 100644
index e77f4e4..0000000
--- a/arch/x86/boot/compressed/relocs.c
+++ /dev/null
@@ -1,680 +0,0 @@
-#include <stdio.h>
-#include <stdarg.h>
-#include <stdlib.h>
-#include <stdint.h>
-#include <string.h>
-#include <errno.h>
-#include <unistd.h>
-#include <elf.h>
-#include <byteswap.h>
-#define USE_BSD
-#include <endian.h>
-#include <regex.h>
-
-static void die(char *fmt, ...);
-
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-static Elf32_Ehdr ehdr;
-static unsigned long reloc_count, reloc_idx;
-static unsigned long *relocs;
-
-struct section {
-	Elf32_Shdr     shdr;
-	struct section *link;
-	Elf32_Sym      *symtab;
-	Elf32_Rel      *reltab;
-	char           *strtab;
-};
-static struct section *secs;
-
-/*
- * Following symbols have been audited. There values are constant and do
- * not change if bzImage is loaded at a different physical address than
- * the address for which it has been compiled. Don't warn user about
- * absolute relocations present w.r.t these symbols.
- */
-static const char abs_sym_regex[] =3D
-	"^(xen_irq_disable_direct_reloc$|"
-	"xen_save_fl_direct_reloc$|"
-	"VDSO|"
-	"__crc_)";
-static regex_t abs_sym_regex_c;
-static int is_abs_reloc(const char *sym_name)
-{
-	return !regexec(&abs_sym_regex_c, sym_name, 0, NULL, 0);
-}
-
-/*
- * These symbols are known to be relative, even if the linker marks them
- * as absolute (typically defined outside any section in the linker script=
.)
- */
-static const char rel_sym_regex[] =3D
-	"^_end$";
-static regex_t rel_sym_regex_c;
-static int is_rel_reloc(const char *sym_name)
-{
-	return !regexec(&rel_sym_regex_c, sym_name, 0, NULL, 0);
-}
-
-static void regex_init(void)
-{
-        char errbuf[128];
-        int err;
-=09
-        err =3D regcomp(&abs_sym_regex_c, abs_sym_regex,
-                      REG_EXTENDED|REG_NOSUB);
-        if (err) {
-                regerror(err, &abs_sym_regex_c, errbuf, sizeof errbuf);
-                die("%s", errbuf);
-        }
-
-        err =3D regcomp(&rel_sym_regex_c, rel_sym_regex,
-                      REG_EXTENDED|REG_NOSUB);
-        if (err) {
-                regerror(err, &rel_sym_regex_c, errbuf, sizeof errbuf);
-                die("%s", errbuf);
-        }
-}
-
-static void die(char *fmt, ...)
-{
-	va_list ap;
-	va_start(ap, fmt);
-	vfprintf(stderr, fmt, ap);
-	va_end(ap);
-	exit(1);
-}
-
-static const char *sym_type(unsigned type)
-{
-	static const char *type_name[] =3D {
-#define SYM_TYPE(X) [X] =3D #X
-		SYM_TYPE(STT_NOTYPE),
-		SYM_TYPE(STT_OBJECT),
-		SYM_TYPE(STT_FUNC),
-		SYM_TYPE(STT_SECTION),
-		SYM_TYPE(STT_FILE),
-		SYM_TYPE(STT_COMMON),
-		SYM_TYPE(STT_TLS),
-#undef SYM_TYPE
-	};
-	const char *name =3D "unknown sym type name";
-	if (type < ARRAY_SIZE(type_name)) {
-		name =3D type_name[type];
-	}
-	return name;
-}
-
-static const char *sym_bind(unsigned bind)
-{
-	static const char *bind_name[] =3D {
-#define SYM_BIND(X) [X] =3D #X
-		SYM_BIND(STB_LOCAL),
-		SYM_BIND(STB_GLOBAL),
-		SYM_BIND(STB_WEAK),
-#undef SYM_BIND
-	};
-	const char *name =3D "unknown sym bind name";
-	if (bind < ARRAY_SIZE(bind_name)) {
-		name =3D bind_name[bind];
-	}
-	return name;
-}
-
-static const char *sym_visibility(unsigned visibility)
-{
-	static const char *visibility_name[] =3D {
-#define SYM_VISIBILITY(X) [X] =3D #X
-		SYM_VISIBILITY(STV_DEFAULT),
-		SYM_VISIBILITY(STV_INTERNAL),
-		SYM_VISIBILITY(STV_HIDDEN),
-		SYM_VISIBILITY(STV_PROTECTED),
-#undef SYM_VISIBILITY
-	};
-	const char *name =3D "unknown sym visibility name";
-	if (visibility < ARRAY_SIZE(visibility_name)) {
-		name =3D visibility_name[visibility];
-	}
-	return name;
-}
-
-static const char *rel_type(unsigned type)
-{
-	static const char *type_name[] =3D {
-#define REL_TYPE(X) [X] =3D #X
-		REL_TYPE(R_386_NONE),
-		REL_TYPE(R_386_32),
-		REL_TYPE(R_386_PC32),
-		REL_TYPE(R_386_GOT32),
-		REL_TYPE(R_386_PLT32),
-		REL_TYPE(R_386_COPY),
-		REL_TYPE(R_386_GLOB_DAT),
-		REL_TYPE(R_386_JMP_SLOT),
-		REL_TYPE(R_386_RELATIVE),
-		REL_TYPE(R_386_GOTOFF),
-		REL_TYPE(R_386_GOTPC),
-#undef REL_TYPE
-	};
-	const char *name =3D "unknown type rel type name";
-	if (type < ARRAY_SIZE(type_name) && type_name[type]) {
-		name =3D type_name[type];
-	}
-	return name;
-}
-
-static const char *sec_name(unsigned shndx)
-{
-	const char *sec_strtab;
-	const char *name;
-	sec_strtab =3D secs[ehdr.e_shstrndx].strtab;
-	name =3D "<noname>";
-	if (shndx < ehdr.e_shnum) {
-		name =3D sec_strtab + secs[shndx].shdr.sh_name;
-	}
-	else if (shndx =3D=3D SHN_ABS) {
-		name =3D "ABSOLUTE";
-	}
-	else if (shndx =3D=3D SHN_COMMON) {
-		name =3D "COMMON";
-	}
-	return name;
-}
-
-static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
-{
-	const char *name;
-	name =3D "<noname>";
-	if (sym->st_name) {
-		name =3D sym_strtab + sym->st_name;
-	}
-	else {
-		name =3D sec_name(secs[sym->st_shndx].shdr.sh_name);
-	}
-	return name;
-}
-
-
-
-#if BYTE_ORDER =3D=3D LITTLE_ENDIAN
-#define le16_to_cpu(val) (val)
-#define le32_to_cpu(val) (val)
-#endif
-#if BYTE_ORDER =3D=3D BIG_ENDIAN
-#define le16_to_cpu(val) bswap_16(val)
-#define le32_to_cpu(val) bswap_32(val)
-#endif
-
-static uint16_t elf16_to_cpu(uint16_t val)
-{
-	return le16_to_cpu(val);
-}
-
-static uint32_t elf32_to_cpu(uint32_t val)
-{
-	return le32_to_cpu(val);
-}
-
-static void read_ehdr(FILE *fp)
-{
-	if (fread(&ehdr, sizeof(ehdr), 1, fp) !=3D 1) {
-		die("Cannot read ELF header: %s\n",
-			strerror(errno));
-	}
-	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) !=3D 0) {
-		die("No ELF magic\n");
-	}
-	if (ehdr.e_ident[EI_CLASS] !=3D ELFCLASS32) {
-		die("Not a 32 bit executable\n");
-	}
-	if (ehdr.e_ident[EI_DATA] !=3D ELFDATA2LSB) {
-		die("Not a LSB ELF executable\n");
-	}
-	if (ehdr.e_ident[EI_VERSION] !=3D EV_CURRENT) {
-		die("Unknown ELF version\n");
-	}
-	/* Convert the fields to native endian */
-	ehdr.e_type      =3D elf16_to_cpu(ehdr.e_type);
-	ehdr.e_machine   =3D elf16_to_cpu(ehdr.e_machine);
-	ehdr.e_version   =3D elf32_to_cpu(ehdr.e_version);
-	ehdr.e_entry     =3D elf32_to_cpu(ehdr.e_entry);
-	ehdr.e_phoff     =3D elf32_to_cpu(ehdr.e_phoff);
-	ehdr.e_shoff     =3D elf32_to_cpu(ehdr.e_shoff);
-	ehdr.e_flags     =3D elf32_to_cpu(ehdr.e_flags);
-	ehdr.e_ehsize    =3D elf16_to_cpu(ehdr.e_ehsize);
-	ehdr.e_phentsize =3D elf16_to_cpu(ehdr.e_phentsize);
-	ehdr.e_phnum     =3D elf16_to_cpu(ehdr.e_phnum);
-	ehdr.e_shentsize =3D elf16_to_cpu(ehdr.e_shentsize);
-	ehdr.e_shnum     =3D elf16_to_cpu(ehdr.e_shnum);
-	ehdr.e_shstrndx  =3D elf16_to_cpu(ehdr.e_shstrndx);
-
-	if ((ehdr.e_type !=3D ET_EXEC) && (ehdr.e_type !=3D ET_DYN)) {
-		die("Unsupported ELF header type\n");
-	}
-	if (ehdr.e_machine !=3D EM_386) {
-		die("Not for x86\n");
-	}
-	if (ehdr.e_version !=3D EV_CURRENT) {
-		die("Unknown ELF version\n");
-	}
-	if (ehdr.e_ehsize !=3D sizeof(Elf32_Ehdr)) {
-		die("Bad Elf header size\n");
-	}
-	if (ehdr.e_phentsize !=3D sizeof(Elf32_Phdr)) {
-		die("Bad program header entry\n");
-	}
-	if (ehdr.e_shentsize !=3D sizeof(Elf32_Shdr)) {
-		die("Bad section header entry\n");
-	}
-	if (ehdr.e_shstrndx >=3D ehdr.e_shnum) {
-		die("String table index out of bounds\n");
-	}
-}
-
-static void read_shdrs(FILE *fp)
-{
-	int i;
-	Elf32_Shdr shdr;
-
-	secs =3D calloc(ehdr.e_shnum, sizeof(struct section));
-	if (!secs) {
-		die("Unable to allocate %d section headers\n",
-		    ehdr.e_shnum);
-	}
-	if (fseek(fp, ehdr.e_shoff, SEEK_SET) < 0) {
-		die("Seek to %d failed: %s\n",
-			ehdr.e_shoff, strerror(errno));
-	}
-	for (i =3D 0; i < ehdr.e_shnum; i++) {
-		struct section *sec =3D &secs[i];
-		if (fread(&shdr, sizeof shdr, 1, fp) !=3D 1)
-			die("Cannot read ELF section headers %d/%d: %s\n",
-			    i, ehdr.e_shnum, strerror(errno));
-		sec->shdr.sh_name      =3D elf32_to_cpu(shdr.sh_name);
-		sec->shdr.sh_type      =3D elf32_to_cpu(shdr.sh_type);
-		sec->shdr.sh_flags     =3D elf32_to_cpu(shdr.sh_flags);
-		sec->shdr.sh_addr      =3D elf32_to_cpu(shdr.sh_addr);
-		sec->shdr.sh_offset    =3D elf32_to_cpu(shdr.sh_offset);
-		sec->shdr.sh_size      =3D elf32_to_cpu(shdr.sh_size);
-		sec->shdr.sh_link      =3D elf32_to_cpu(shdr.sh_link);
-		sec->shdr.sh_info      =3D elf32_to_cpu(shdr.sh_info);
-		sec->shdr.sh_addralign =3D elf32_to_cpu(shdr.sh_addralign);
-		sec->shdr.sh_entsize   =3D elf32_to_cpu(shdr.sh_entsize);
-		if (sec->shdr.sh_link < ehdr.e_shnum)
-			sec->link =3D &secs[sec->shdr.sh_link];
-	}
-
-}
-
-static void read_strtabs(FILE *fp)
-{
-	int i;
-	for (i =3D 0; i < ehdr.e_shnum; i++) {
-		struct section *sec =3D &secs[i];
-		if (sec->shdr.sh_type !=3D SHT_STRTAB) {
-			continue;
-		}
-		sec->strtab =3D malloc(sec->shdr.sh_size);
-		if (!sec->strtab) {
-			die("malloc of %d bytes for strtab failed\n",
-				sec->shdr.sh_size);
-		}
-		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
-			die("Seek to %d failed: %s\n",
-				sec->shdr.sh_offset, strerror(errno));
-		}
-		if (fread(sec->strtab, 1, sec->shdr.sh_size, fp)
-		    !=3D sec->shdr.sh_size) {
-			die("Cannot read symbol table: %s\n",
-				strerror(errno));
-		}
-	}
-}
-
-static void read_symtabs(FILE *fp)
-{
-	int i,j;
-	for (i =3D 0; i < ehdr.e_shnum; i++) {
-		struct section *sec =3D &secs[i];
-		if (sec->shdr.sh_type !=3D SHT_SYMTAB) {
-			continue;
-		}
-		sec->symtab =3D malloc(sec->shdr.sh_size);
-		if (!sec->symtab) {
-			die("malloc of %d bytes for symtab failed\n",
-				sec->shdr.sh_size);
-		}
-		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
-			die("Seek to %d failed: %s\n",
-				sec->shdr.sh_offset, strerror(errno));
-		}
-		if (fread(sec->symtab, 1, sec->shdr.sh_size, fp)
-		    !=3D sec->shdr.sh_size) {
-			die("Cannot read symbol table: %s\n",
-				strerror(errno));
-		}
-		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
-			Elf32_Sym *sym =3D &sec->symtab[j];
-			sym->st_name  =3D elf32_to_cpu(sym->st_name);
-			sym->st_value =3D elf32_to_cpu(sym->st_value);
-			sym->st_size  =3D elf32_to_cpu(sym->st_size);
-			sym->st_shndx =3D elf16_to_cpu(sym->st_shndx);
-		}
-	}
-}
-
-
-static void read_relocs(FILE *fp)
-{
-	int i,j;
-	for (i =3D 0; i < ehdr.e_shnum; i++) {
-		struct section *sec =3D &secs[i];
-		if (sec->shdr.sh_type !=3D SHT_REL) {
-			continue;
-		}
-		sec->reltab =3D malloc(sec->shdr.sh_size);
-		if (!sec->reltab) {
-			die("malloc of %d bytes for relocs failed\n",
-				sec->shdr.sh_size);
-		}
-		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
-			die("Seek to %d failed: %s\n",
-				sec->shdr.sh_offset, strerror(errno));
-		}
-		if (fread(sec->reltab, 1, sec->shdr.sh_size, fp)
-		    !=3D sec->shdr.sh_size) {
-			die("Cannot read symbol table: %s\n",
-				strerror(errno));
-		}
-		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel =3D &sec->reltab[j];
-			rel->r_offset =3D elf32_to_cpu(rel->r_offset);
-			rel->r_info   =3D elf32_to_cpu(rel->r_info);
-		}
-	}
-}
-
-
-static void print_absolute_symbols(void)
-{
-	int i;
-	printf("Absolute symbols\n");
-	printf(" Num:    Value Size  Type       Bind        Visibility  Name\n");
-	for (i =3D 0; i < ehdr.e_shnum; i++) {
-		struct section *sec =3D &secs[i];
-		char *sym_strtab;
-		int j;
-
-		if (sec->shdr.sh_type !=3D SHT_SYMTAB) {
-			continue;
-		}
-		sym_strtab =3D sec->link->strtab;
-		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
-			Elf32_Sym *sym;
-			const char *name;
-			sym =3D &sec->symtab[j];
-			name =3D sym_name(sym_strtab, sym);
-			if (sym->st_shndx !=3D SHN_ABS) {
-				continue;
-			}
-			printf("%5d %08x %5d %10s %10s %12s %s\n",
-				j, sym->st_value, sym->st_size,
-				sym_type(ELF32_ST_TYPE(sym->st_info)),
-				sym_bind(ELF32_ST_BIND(sym->st_info)),
-				sym_visibility(ELF32_ST_VISIBILITY(sym->st_other)),
-				name);
-		}
-	}
-	printf("\n");
-}
-
-static void print_absolute_relocs(void)
-{
-	int i, printed =3D 0;
-
-	for (i =3D 0; i < ehdr.e_shnum; i++) {
-		struct section *sec =3D &secs[i];
-		struct section *sec_applies, *sec_symtab;
-		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
-		int j;
-		if (sec->shdr.sh_type !=3D SHT_REL) {
-			continue;
-		}
-		sec_symtab  =3D sec->link;
-		sec_applies =3D &secs[sec->shdr.sh_info];
-		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
-			continue;
-		}
-		sh_symtab  =3D sec_symtab->symtab;
-		sym_strtab =3D sec_symtab->link->strtab;
-		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel;
-			Elf32_Sym *sym;
-			const char *name;
-			rel =3D &sec->reltab[j];
-			sym =3D &sh_symtab[ELF32_R_SYM(rel->r_info)];
-			name =3D sym_name(sym_strtab, sym);
-			if (sym->st_shndx !=3D SHN_ABS) {
-				continue;
-			}
-
-			/* Absolute symbols are not relocated if bzImage is
-			 * loaded at a non-compiled address. Display a warning
-			 * to user at compile time about the absolute
-			 * relocations present.
-			 *
-			 * User need to audit the code to make sure
-			 * some symbols which should have been section
-			 * relative have not become absolute because of some
-			 * linker optimization or wrong programming usage.
-			 *
-			 * Before warning check if this absolute symbol
-			 * relocation is harmless.
-			 */
-			if (is_abs_reloc(name) || is_rel_reloc(name))
-				continue;
-
-			if (!printed) {
-				printf("WARNING: Absolute relocations"
-					" present\n");
-				printf("Offset     Info     Type     Sym.Value "
-					"Sym.Name\n");
-				printed =3D 1;
-			}
-
-			printf("%08x %08x %10s %08x  %s\n",
-				rel->r_offset,
-				rel->r_info,
-				rel_type(ELF32_R_TYPE(rel->r_info)),
-				sym->st_value,
-				name);
-		}
-	}
-
-	if (printed)
-		printf("\n");
-}
-
-static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
-{
-	int i;
-	/* Walk through the relocations */
-	for (i =3D 0; i < ehdr.e_shnum; i++) {
-		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
-		struct section *sec_applies, *sec_symtab;
-		int j;
-		struct section *sec =3D &secs[i];
-
-		if (sec->shdr.sh_type !=3D SHT_REL) {
-			continue;
-		}
-		sec_symtab  =3D sec->link;
-		sec_applies =3D &secs[sec->shdr.sh_info];
-		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
-			continue;
-		}
-		sh_symtab =3D sec_symtab->symtab;
-		sym_strtab =3D sec_symtab->link->strtab;
-		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel;
-			Elf32_Sym *sym;
-			unsigned r_type;
-			rel =3D &sec->reltab[j];
-			sym =3D &sh_symtab[ELF32_R_SYM(rel->r_info)];
-			r_type =3D ELF32_R_TYPE(rel->r_info);
-			/* Don't visit relocations to absolute symbols */
-			if (sym->st_shndx =3D=3D SHN_ABS &&
-			    !is_rel_reloc(sym_name(sym_strtab, sym))) {
-				continue;
-			}
-			switch (r_type) {
-			case R_386_NONE:
-			case R_386_PC32:
-				/*
-				 * NONE can be ignored and and PC relative
-				 * relocations don't need to be adjusted.
-				 */
-				break;
-			case R_386_32:
-				/* Visit relocations that need to be adjusted */
-				visit(rel, sym);
-				break;
-			default:
-				die("Unsupported relocation type: %s (%d)\n",
-				    rel_type(r_type), r_type);
-				break;
-			}
-		}
-	}
-}
-
-static void count_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
-{
-	reloc_count +=3D 1;
-}
-
-static void collect_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
-{
-	/* Remember the address that needs to be adjusted. */
-	relocs[reloc_idx++] =3D rel->r_offset;
-}
-
-static int cmp_relocs(const void *va, const void *vb)
-{
-	const unsigned long *a, *b;
-	a =3D va; b =3D vb;
-	return (*a =3D=3D *b)? 0 : (*a > *b)? 1 : -1;
-}
-
-static void emit_relocs(int as_text)
-{
-	int i;
-	/* Count how many relocations I have and allocate space for them. */
-	reloc_count =3D 0;
-	walk_relocs(count_reloc);
-	relocs =3D malloc(reloc_count * sizeof(relocs[0]));
-	if (!relocs) {
-		die("malloc of %d entries for relocs failed\n",
-			reloc_count);
-	}
-	/* Collect up the relocations */
-	reloc_idx =3D 0;
-	walk_relocs(collect_reloc);
-
-	/* Order the relocations for more efficient processing */
-	qsort(relocs, reloc_count, sizeof(relocs[0]), cmp_relocs);
-
-	/* Print the relocations */
-	if (as_text) {
-		/* Print the relocations in a form suitable that
-		 * gas will like.
-		 */
-		printf(".section \".data.reloc\",\"a\"\n");
-		printf(".balign 4\n");
-		for (i =3D 0; i < reloc_count; i++) {
-			printf("\t .long 0x%08lx\n", relocs[i]);
-		}
-		printf("\n");
-	}
-	else {
-		unsigned char buf[4];
-		/* Print a stop */
-		fwrite("\0\0\0\0", 4, 1, stdout);
-		/* Now print each relocation */
-		for (i =3D 0; i < reloc_count; i++) {
-			buf[0] =3D (relocs[i] >>  0) & 0xff;
-			buf[1] =3D (relocs[i] >>  8) & 0xff;
-			buf[2] =3D (relocs[i] >> 16) & 0xff;
-			buf[3] =3D (relocs[i] >> 24) & 0xff;
-			fwrite(buf, 4, 1, stdout);
-		}
-	}
-}
-
-static void usage(void)
-{
-	die("relocs [--abs-syms |--abs-relocs | --text] vmlinux\n");
-}
-
-int main(int argc, char **argv)
-{
-	int show_absolute_syms, show_absolute_relocs;
-	int as_text;
-	const char *fname;
-	FILE *fp;
-	int i;
-
-	regex_init();
-
-	show_absolute_syms =3D 0;
-	show_absolute_relocs =3D 0;
-	as_text =3D 0;
-	fname =3D NULL;
-	for (i =3D 1; i < argc; i++) {
-		char *arg =3D argv[i];
-		if (*arg =3D=3D '-') {
-			if (strcmp(argv[1], "--abs-syms") =3D=3D 0) {
-				show_absolute_syms =3D 1;
-				continue;
-			}
-
-			if (strcmp(argv[1], "--abs-relocs") =3D=3D 0) {
-				show_absolute_relocs =3D 1;
-				continue;
-			}
-			else if (strcmp(argv[1], "--text") =3D=3D 0) {
-				as_text =3D 1;
-				continue;
-			}
-		}
-		else if (!fname) {
-			fname =3D arg;
-			continue;
-		}
-		usage();
-	}
-	if (!fname) {
-		usage();
-	}
-	fp =3D fopen(fname, "r");
-	if (!fp) {
-		die("Cannot open %s: %s\n",
-			fname, strerror(errno));
-	}
-	read_ehdr(fp);
-	read_shdrs(fp);
-	read_strtabs(fp);
-	read_symtabs(fp);
-	read_relocs(fp);
-	if (show_absolute_syms) {
-		print_absolute_symbols();
-		return 0;
-	}
-	if (show_absolute_relocs) {
-		print_absolute_relocs();
-		return 0;
-	}
-	emit_relocs(as_text);
-	return 0;
-}
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cp=
u/mcheck/mce-severity.c
index 7395d5f..c9c9cfe 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -145,15 +145,19 @@ static struct severity {
 };
=20
 /*
- * If the EIPV bit is set, it means the saved IP is the
- * instruction which caused the MCE.
+ * If mcgstatus indicated that ip/cs on the stack were
+ * no good, then "m->cs" will be zero and we will have
+ * to assume the worst case (IN_KERNEL) as we actually
+ * have no idea what we were executing when the machine
+ * check hit.
+ * If we do have a good "m->cs" (or a faked one in the
+ * case we were executing in VM86 mode) we can use it to
+ * distinguish an exception taken in user from from one
+ * taken in the kernel.
  */
 static int error_context(struct mce *m)
 {
-	if (m->mcgstatus & MCG_STATUS_EIPV)
-		return (m->ip && (m->cs & 3) =3D=3D 3) ? IN_USER : IN_KERNEL;
-	/* Unknown, assume kernel */
-	return IN_KERNEL;
+	return ((m->cs & 3) =3D=3D 3) ? IN_USER : IN_KERNEL;
 }
=20
 int mce_severity(struct mce *m, int tolerant, char **msg)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/=
mce.c
index 2af127d..b0f1271 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -389,6 +389,14 @@ static inline void mce_gather_info(struct mce *m, stru=
ct pt_regs *regs)
 		if (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV)) {
 			m->ip =3D regs->ip;
 			m->cs =3D regs->cs;
+
+			/*
+			 * When in VM86 mode make the cs look like ring 3
+			 * always. This is a lie, but it's better than passing
+			 * the additional vm86 bit around everywhere.
+			 */
+			if (v8086_mode(regs))
+				m->cs |=3D 3;
 		}
 		/* Use accurate RIP reporting if available. */
 		if (rip_msr)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/per=
f_event_amd.c
index f64a039..3dbfb00 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -473,6 +473,7 @@ static __initconst const struct x86_pmu amd_pmu =3D {
  * 0x023	DE	PERF_CTL[2:0]
  * 0x02D	LS	PERF_CTL[3]
  * 0x02E	LS	PERF_CTL[3,0]
+ * 0x031	LS	PERF_CTL[2:0] (**)
  * 0x043	CU	PERF_CTL[2:0]
  * 0x045	CU	PERF_CTL[2:0]
  * 0x046	CU	PERF_CTL[2:0]
@@ -486,10 +487,12 @@ static __initconst const struct x86_pmu amd_pmu =3D {
  * 0x0DD	LS	PERF_CTL[5:0]
  * 0x0DE	LS	PERF_CTL[5:0]
  * 0x0DF	LS	PERF_CTL[5:0]
+ * 0x1C0	EX	PERF_CTL[5:3]
  * 0x1D6	EX	PERF_CTL[5:0]
  * 0x1D8	EX	PERF_CTL[5:0]
  *
- * (*) depending on the umask all FPU counters may be used
+ * (*)  depending on the umask all FPU counters may be used
+ * (**) only one unitmask enabled at a time
  */
=20
 static struct event_constraint amd_f15_PMC0  =3D EVENT_CONSTRAINT(0, 0x01,=
 0);
@@ -539,6 +542,12 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *c=
puc, struct perf_event *ev
 			return &amd_f15_PMC3;
 		case 0x02E:
 			return &amd_f15_PMC30;
+		case 0x031:
+			if (hweight_long(hwc->config & ARCH_PERFMON_EVENTSEL_UMASK) <=3D 1)
+				return &amd_f15_PMC20;
+			return &emptyconstraint;
+		case 0x1C0:
+			return &amd_f15_PMC53;
 		default:
 			return &amd_f15_PMC50;
 		}
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4ea7678..7315488 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1677,7 +1677,7 @@ static int nested_pf_handled(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
=20
 	/* TODO: also check PFEC_MATCH/MASK, not just EB.PF. */
-	if (!(vmcs12->exception_bitmap & PF_VECTOR))
+	if (!(vmcs12->exception_bitmap & (1u << PF_VECTOR)))
 		return 0;
=20
 	nested_vmx_vmexit(vcpu);
@@ -3915,7 +3915,9 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
=20
 	vmx->vcpu.arch.cr0 =3D X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
+	vcpu->srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
 	vmx_set_cr0(&vmx->vcpu, kvm_read_cr0(vcpu)); /* enter rmode */
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	vmx_set_cr4(&vmx->vcpu, 0);
 	vmx_set_efer(&vmx->vcpu, 0);
 	vmx_fpu_activate(&vmx->vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e04cae1..4fc5323 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3579,6 +3579,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r =3D -EEXIST;
 		if (kvm->arch.vpic)
 			goto create_irqchip_unlock;
+		r =3D -EINVAL;
+		if (atomic_read(&kvm->online_vcpus))
+			goto create_irqchip_unlock;
 		r =3D -ENOMEM;
 		vpic =3D kvm_create_pic(kvm);
 		if (vpic) {
@@ -6486,6 +6489,11 @@ void kvm_arch_check_processor_compat(void *rtn)
 	kvm_x86_ops->check_processor_compatibility(rtn);
 }
=20
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
+{
+	return irqchip_in_kernel(vcpu->kvm) =3D=3D (vcpu->arch.apic !=3D NULL);
+}
+
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index d99346e..4c262f6 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -64,6 +64,10 @@ static int xen_register_pirq(u32 gsi, int gsi_override, =
int triggering,
 	int shareable =3D 0;
 	char *name;
=20
+	irq =3D xen_irq_from_gsi(gsi);
+	if (irq > 0)
+		return irq;
+
 	if (set_pirq)
 		pirq =3D gsi;
=20
diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
new file mode 100644
index 0000000..be0ed06
--- /dev/null
+++ b/arch/x86/tools/.gitignore
@@ -0,0 +1 @@
+relocs
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index f820826..162a34a 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -29,3 +29,6 @@ HOSTCFLAGS_test_get_len.o :=3D -Wall -I$(objtree)/arch/x8=
6/lib/ -I$(srctree)/arch/
 # Dependencies are also needed.
 $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/=
lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86=
/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/=
x86/lib/inat-tables.c
=20
+HOST_EXTRACFLAGS +=3D -I$(srctree)/tools/include
+hostprogs-y	+=3D relocs
+relocs: $(obj)/relocs
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
new file mode 100644
index 0000000..e529730
--- /dev/null
+++ b/arch/x86/tools/relocs.c
@@ -0,0 +1,820 @@
+#include <stdio.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <elf.h>
+#include <byteswap.h>
+#define USE_BSD
+#include <endian.h>
+#include <regex.h>
+
+static void die(char *fmt, ...);
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+static Elf32_Ehdr ehdr;
+static unsigned long reloc_count, reloc_idx;
+static unsigned long *relocs;
+static unsigned long reloc16_count, reloc16_idx;
+static unsigned long *relocs16;
+
+struct section {
+	Elf32_Shdr     shdr;
+	struct section *link;
+	Elf32_Sym      *symtab;
+	Elf32_Rel      *reltab;
+	char           *strtab;
+};
+static struct section *secs;
+
+enum symtype {
+	S_ABS,
+	S_REL,
+	S_SEG,
+	S_LIN,
+	S_NSYMTYPES
+};
+
+static const char * const sym_regex_kernel[S_NSYMTYPES] =3D {
+/*
+ * Following symbols have been audited. There values are constant and do
+ * not change if bzImage is loaded at a different physical address than
+ * the address for which it has been compiled. Don't warn user about
+ * absolute relocations present w.r.t these symbols.
+ */
+	[S_ABS] =3D
+	"^(xen_irq_disable_direct_reloc$|"
+	"xen_save_fl_direct_reloc$|"
+	"VDSO|"
+	"__crc_)",
+
+/*
+ * These symbols are known to be relative, even if the linker marks them
+ * as absolute (typically defined outside any section in the linker script=
.)
+ */
+	[S_REL] =3D
+	"^(__init_(begin|end)|"
+	"__x86_cpu_dev_(start|end)|"
+	"(__parainstructions|__alt_instructions)(|_end)|"
+	"(__iommu_table|__apicdrivers|__smp_locks)(|_end)|"
+	"__(start|end)_pci_.*|"
+	"__(start|end)_builtin_fw|"
+	"__(start|stop)___ksymtab(|_gpl|_unused|_unused_gpl|_gpl_future)|"
+	"__(start|stop)___kcrctab(|_gpl|_unused|_unused_gpl|_gpl_future)|"
+	"__(start|stop)___param|"
+	"__(start|stop)___modver|"
+	"__(start|stop)___bug_table|"
+	"__tracedata_(start|end)|"
+	"__(start|stop)_notes|"
+	"__end_rodata|"
+	"__initramfs_start|"
+	"(jiffies|jiffies_64)|"
+	"_end)$"
+};
+
+
+static const char * const sym_regex_realmode[S_NSYMTYPES] =3D {
+/*
+ * These are 16-bit segment symbols when compiling 16-bit code.
+ */
+	[S_SEG] =3D
+	"^real_mode_seg$",
+
+/*
+ * These are offsets belonging to segments, as opposed to linear addresses=
,
+ * when compiling 16-bit code.
+ */
+	[S_LIN] =3D
+	"^pa_",
+};
+
+static const char * const *sym_regex;
+
+static regex_t sym_regex_c[S_NSYMTYPES];
+static int is_reloc(enum symtype type, const char *sym_name)
+{
+	return sym_regex[type] &&
+		!regexec(&sym_regex_c[type], sym_name, 0, NULL, 0);
+}
+
+static void regex_init(int use_real_mode)
+{
+        char errbuf[128];
+        int err;
+	int i;
+
+	if (use_real_mode)
+		sym_regex =3D sym_regex_realmode;
+	else
+		sym_regex =3D sym_regex_kernel;
+
+	for (i =3D 0; i < S_NSYMTYPES; i++) {
+		if (!sym_regex[i])
+			continue;
+
+		err =3D regcomp(&sym_regex_c[i], sym_regex[i],
+			      REG_EXTENDED|REG_NOSUB);
+
+		if (err) {
+			regerror(err, &sym_regex_c[i], errbuf, sizeof errbuf);
+			die("%s", errbuf);
+		}
+        }
+}
+
+static void die(char *fmt, ...)
+{
+	va_list ap;
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+	exit(1);
+}
+
+static const char *sym_type(unsigned type)
+{
+	static const char *type_name[] =3D {
+#define SYM_TYPE(X) [X] =3D #X
+		SYM_TYPE(STT_NOTYPE),
+		SYM_TYPE(STT_OBJECT),
+		SYM_TYPE(STT_FUNC),
+		SYM_TYPE(STT_SECTION),
+		SYM_TYPE(STT_FILE),
+		SYM_TYPE(STT_COMMON),
+		SYM_TYPE(STT_TLS),
+#undef SYM_TYPE
+	};
+	const char *name =3D "unknown sym type name";
+	if (type < ARRAY_SIZE(type_name)) {
+		name =3D type_name[type];
+	}
+	return name;
+}
+
+static const char *sym_bind(unsigned bind)
+{
+	static const char *bind_name[] =3D {
+#define SYM_BIND(X) [X] =3D #X
+		SYM_BIND(STB_LOCAL),
+		SYM_BIND(STB_GLOBAL),
+		SYM_BIND(STB_WEAK),
+#undef SYM_BIND
+	};
+	const char *name =3D "unknown sym bind name";
+	if (bind < ARRAY_SIZE(bind_name)) {
+		name =3D bind_name[bind];
+	}
+	return name;
+}
+
+static const char *sym_visibility(unsigned visibility)
+{
+	static const char *visibility_name[] =3D {
+#define SYM_VISIBILITY(X) [X] =3D #X
+		SYM_VISIBILITY(STV_DEFAULT),
+		SYM_VISIBILITY(STV_INTERNAL),
+		SYM_VISIBILITY(STV_HIDDEN),
+		SYM_VISIBILITY(STV_PROTECTED),
+#undef SYM_VISIBILITY
+	};
+	const char *name =3D "unknown sym visibility name";
+	if (visibility < ARRAY_SIZE(visibility_name)) {
+		name =3D visibility_name[visibility];
+	}
+	return name;
+}
+
+static const char *rel_type(unsigned type)
+{
+	static const char *type_name[] =3D {
+#define REL_TYPE(X) [X] =3D #X
+		REL_TYPE(R_386_NONE),
+		REL_TYPE(R_386_32),
+		REL_TYPE(R_386_PC32),
+		REL_TYPE(R_386_GOT32),
+		REL_TYPE(R_386_PLT32),
+		REL_TYPE(R_386_COPY),
+		REL_TYPE(R_386_GLOB_DAT),
+		REL_TYPE(R_386_JMP_SLOT),
+		REL_TYPE(R_386_RELATIVE),
+		REL_TYPE(R_386_GOTOFF),
+		REL_TYPE(R_386_GOTPC),
+		REL_TYPE(R_386_8),
+		REL_TYPE(R_386_PC8),
+		REL_TYPE(R_386_16),
+		REL_TYPE(R_386_PC16),
+#undef REL_TYPE
+	};
+	const char *name =3D "unknown type rel type name";
+	if (type < ARRAY_SIZE(type_name) && type_name[type]) {
+		name =3D type_name[type];
+	}
+	return name;
+}
+
+static const char *sec_name(unsigned shndx)
+{
+	const char *sec_strtab;
+	const char *name;
+	sec_strtab =3D secs[ehdr.e_shstrndx].strtab;
+	name =3D "<noname>";
+	if (shndx < ehdr.e_shnum) {
+		name =3D sec_strtab + secs[shndx].shdr.sh_name;
+	}
+	else if (shndx =3D=3D SHN_ABS) {
+		name =3D "ABSOLUTE";
+	}
+	else if (shndx =3D=3D SHN_COMMON) {
+		name =3D "COMMON";
+	}
+	return name;
+}
+
+static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
+{
+	const char *name;
+	name =3D "<noname>";
+	if (sym->st_name) {
+		name =3D sym_strtab + sym->st_name;
+	}
+	else {
+		name =3D sec_name(sym->st_shndx);
+	}
+	return name;
+}
+
+
+
+#if BYTE_ORDER =3D=3D LITTLE_ENDIAN
+#define le16_to_cpu(val) (val)
+#define le32_to_cpu(val) (val)
+#endif
+#if BYTE_ORDER =3D=3D BIG_ENDIAN
+#define le16_to_cpu(val) bswap_16(val)
+#define le32_to_cpu(val) bswap_32(val)
+#endif
+
+static uint16_t elf16_to_cpu(uint16_t val)
+{
+	return le16_to_cpu(val);
+}
+
+static uint32_t elf32_to_cpu(uint32_t val)
+{
+	return le32_to_cpu(val);
+}
+
+static void read_ehdr(FILE *fp)
+{
+	if (fread(&ehdr, sizeof(ehdr), 1, fp) !=3D 1) {
+		die("Cannot read ELF header: %s\n",
+			strerror(errno));
+	}
+	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) !=3D 0) {
+		die("No ELF magic\n");
+	}
+	if (ehdr.e_ident[EI_CLASS] !=3D ELFCLASS32) {
+		die("Not a 32 bit executable\n");
+	}
+	if (ehdr.e_ident[EI_DATA] !=3D ELFDATA2LSB) {
+		die("Not a LSB ELF executable\n");
+	}
+	if (ehdr.e_ident[EI_VERSION] !=3D EV_CURRENT) {
+		die("Unknown ELF version\n");
+	}
+	/* Convert the fields to native endian */
+	ehdr.e_type      =3D elf16_to_cpu(ehdr.e_type);
+	ehdr.e_machine   =3D elf16_to_cpu(ehdr.e_machine);
+	ehdr.e_version   =3D elf32_to_cpu(ehdr.e_version);
+	ehdr.e_entry     =3D elf32_to_cpu(ehdr.e_entry);
+	ehdr.e_phoff     =3D elf32_to_cpu(ehdr.e_phoff);
+	ehdr.e_shoff     =3D elf32_to_cpu(ehdr.e_shoff);
+	ehdr.e_flags     =3D elf32_to_cpu(ehdr.e_flags);
+	ehdr.e_ehsize    =3D elf16_to_cpu(ehdr.e_ehsize);
+	ehdr.e_phentsize =3D elf16_to_cpu(ehdr.e_phentsize);
+	ehdr.e_phnum     =3D elf16_to_cpu(ehdr.e_phnum);
+	ehdr.e_shentsize =3D elf16_to_cpu(ehdr.e_shentsize);
+	ehdr.e_shnum     =3D elf16_to_cpu(ehdr.e_shnum);
+	ehdr.e_shstrndx  =3D elf16_to_cpu(ehdr.e_shstrndx);
+
+	if ((ehdr.e_type !=3D ET_EXEC) && (ehdr.e_type !=3D ET_DYN)) {
+		die("Unsupported ELF header type\n");
+	}
+	if (ehdr.e_machine !=3D EM_386) {
+		die("Not for x86\n");
+	}
+	if (ehdr.e_version !=3D EV_CURRENT) {
+		die("Unknown ELF version\n");
+	}
+	if (ehdr.e_ehsize !=3D sizeof(Elf32_Ehdr)) {
+		die("Bad Elf header size\n");
+	}
+	if (ehdr.e_phentsize !=3D sizeof(Elf32_Phdr)) {
+		die("Bad program header entry\n");
+	}
+	if (ehdr.e_shentsize !=3D sizeof(Elf32_Shdr)) {
+		die("Bad section header entry\n");
+	}
+	if (ehdr.e_shstrndx >=3D ehdr.e_shnum) {
+		die("String table index out of bounds\n");
+	}
+}
+
+static void read_shdrs(FILE *fp)
+{
+	int i;
+	Elf32_Shdr shdr;
+
+	secs =3D calloc(ehdr.e_shnum, sizeof(struct section));
+	if (!secs) {
+		die("Unable to allocate %d section headers\n",
+		    ehdr.e_shnum);
+	}
+	if (fseek(fp, ehdr.e_shoff, SEEK_SET) < 0) {
+		die("Seek to %d failed: %s\n",
+			ehdr.e_shoff, strerror(errno));
+	}
+	for (i =3D 0; i < ehdr.e_shnum; i++) {
+		struct section *sec =3D &secs[i];
+		if (fread(&shdr, sizeof shdr, 1, fp) !=3D 1)
+			die("Cannot read ELF section headers %d/%d: %s\n",
+			    i, ehdr.e_shnum, strerror(errno));
+		sec->shdr.sh_name      =3D elf32_to_cpu(shdr.sh_name);
+		sec->shdr.sh_type      =3D elf32_to_cpu(shdr.sh_type);
+		sec->shdr.sh_flags     =3D elf32_to_cpu(shdr.sh_flags);
+		sec->shdr.sh_addr      =3D elf32_to_cpu(shdr.sh_addr);
+		sec->shdr.sh_offset    =3D elf32_to_cpu(shdr.sh_offset);
+		sec->shdr.sh_size      =3D elf32_to_cpu(shdr.sh_size);
+		sec->shdr.sh_link      =3D elf32_to_cpu(shdr.sh_link);
+		sec->shdr.sh_info      =3D elf32_to_cpu(shdr.sh_info);
+		sec->shdr.sh_addralign =3D elf32_to_cpu(shdr.sh_addralign);
+		sec->shdr.sh_entsize   =3D elf32_to_cpu(shdr.sh_entsize);
+		if (sec->shdr.sh_link < ehdr.e_shnum)
+			sec->link =3D &secs[sec->shdr.sh_link];
+	}
+
+}
+
+static void read_strtabs(FILE *fp)
+{
+	int i;
+	for (i =3D 0; i < ehdr.e_shnum; i++) {
+		struct section *sec =3D &secs[i];
+		if (sec->shdr.sh_type !=3D SHT_STRTAB) {
+			continue;
+		}
+		sec->strtab =3D malloc(sec->shdr.sh_size);
+		if (!sec->strtab) {
+			die("malloc of %d bytes for strtab failed\n",
+				sec->shdr.sh_size);
+		}
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
+			die("Seek to %d failed: %s\n",
+				sec->shdr.sh_offset, strerror(errno));
+		}
+		if (fread(sec->strtab, 1, sec->shdr.sh_size, fp)
+		    !=3D sec->shdr.sh_size) {
+			die("Cannot read symbol table: %s\n",
+				strerror(errno));
+		}
+	}
+}
+
+static void read_symtabs(FILE *fp)
+{
+	int i,j;
+	for (i =3D 0; i < ehdr.e_shnum; i++) {
+		struct section *sec =3D &secs[i];
+		if (sec->shdr.sh_type !=3D SHT_SYMTAB) {
+			continue;
+		}
+		sec->symtab =3D malloc(sec->shdr.sh_size);
+		if (!sec->symtab) {
+			die("malloc of %d bytes for symtab failed\n",
+				sec->shdr.sh_size);
+		}
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
+			die("Seek to %d failed: %s\n",
+				sec->shdr.sh_offset, strerror(errno));
+		}
+		if (fread(sec->symtab, 1, sec->shdr.sh_size, fp)
+		    !=3D sec->shdr.sh_size) {
+			die("Cannot read symbol table: %s\n",
+				strerror(errno));
+		}
+		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
+			Elf32_Sym *sym =3D &sec->symtab[j];
+			sym->st_name  =3D elf32_to_cpu(sym->st_name);
+			sym->st_value =3D elf32_to_cpu(sym->st_value);
+			sym->st_size  =3D elf32_to_cpu(sym->st_size);
+			sym->st_shndx =3D elf16_to_cpu(sym->st_shndx);
+		}
+	}
+}
+
+
+static void read_relocs(FILE *fp)
+{
+	int i,j;
+	for (i =3D 0; i < ehdr.e_shnum; i++) {
+		struct section *sec =3D &secs[i];
+		if (sec->shdr.sh_type !=3D SHT_REL) {
+			continue;
+		}
+		sec->reltab =3D malloc(sec->shdr.sh_size);
+		if (!sec->reltab) {
+			die("malloc of %d bytes for relocs failed\n",
+				sec->shdr.sh_size);
+		}
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
+			die("Seek to %d failed: %s\n",
+				sec->shdr.sh_offset, strerror(errno));
+		}
+		if (fread(sec->reltab, 1, sec->shdr.sh_size, fp)
+		    !=3D sec->shdr.sh_size) {
+			die("Cannot read symbol table: %s\n",
+				strerror(errno));
+		}
+		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
+			Elf32_Rel *rel =3D &sec->reltab[j];
+			rel->r_offset =3D elf32_to_cpu(rel->r_offset);
+			rel->r_info   =3D elf32_to_cpu(rel->r_info);
+		}
+	}
+}
+
+
+static void print_absolute_symbols(void)
+{
+	int i;
+	printf("Absolute symbols\n");
+	printf(" Num:    Value Size  Type       Bind        Visibility  Name\n");
+	for (i =3D 0; i < ehdr.e_shnum; i++) {
+		struct section *sec =3D &secs[i];
+		char *sym_strtab;
+		int j;
+
+		if (sec->shdr.sh_type !=3D SHT_SYMTAB) {
+			continue;
+		}
+		sym_strtab =3D sec->link->strtab;
+		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
+			Elf32_Sym *sym;
+			const char *name;
+			sym =3D &sec->symtab[j];
+			name =3D sym_name(sym_strtab, sym);
+			if (sym->st_shndx !=3D SHN_ABS) {
+				continue;
+			}
+			printf("%5d %08x %5d %10s %10s %12s %s\n",
+				j, sym->st_value, sym->st_size,
+				sym_type(ELF32_ST_TYPE(sym->st_info)),
+				sym_bind(ELF32_ST_BIND(sym->st_info)),
+				sym_visibility(ELF32_ST_VISIBILITY(sym->st_other)),
+				name);
+		}
+	}
+	printf("\n");
+}
+
+static void print_absolute_relocs(void)
+{
+	int i, printed =3D 0;
+
+	for (i =3D 0; i < ehdr.e_shnum; i++) {
+		struct section *sec =3D &secs[i];
+		struct section *sec_applies, *sec_symtab;
+		char *sym_strtab;
+		Elf32_Sym *sh_symtab;
+		int j;
+		if (sec->shdr.sh_type !=3D SHT_REL) {
+			continue;
+		}
+		sec_symtab  =3D sec->link;
+		sec_applies =3D &secs[sec->shdr.sh_info];
+		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
+			continue;
+		}
+		sh_symtab  =3D sec_symtab->symtab;
+		sym_strtab =3D sec_symtab->link->strtab;
+		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
+			Elf32_Rel *rel;
+			Elf32_Sym *sym;
+			const char *name;
+			rel =3D &sec->reltab[j];
+			sym =3D &sh_symtab[ELF32_R_SYM(rel->r_info)];
+			name =3D sym_name(sym_strtab, sym);
+			if (sym->st_shndx !=3D SHN_ABS) {
+				continue;
+			}
+
+			/* Absolute symbols are not relocated if bzImage is
+			 * loaded at a non-compiled address. Display a warning
+			 * to user at compile time about the absolute
+			 * relocations present.
+			 *
+			 * User need to audit the code to make sure
+			 * some symbols which should have been section
+			 * relative have not become absolute because of some
+			 * linker optimization or wrong programming usage.
+			 *
+			 * Before warning check if this absolute symbol
+			 * relocation is harmless.
+			 */
+			if (is_reloc(S_ABS, name) || is_reloc(S_REL, name))
+				continue;
+
+			if (!printed) {
+				printf("WARNING: Absolute relocations"
+					" present\n");
+				printf("Offset     Info     Type     Sym.Value "
+					"Sym.Name\n");
+				printed =3D 1;
+			}
+
+			printf("%08x %08x %10s %08x  %s\n",
+				rel->r_offset,
+				rel->r_info,
+				rel_type(ELF32_R_TYPE(rel->r_info)),
+				sym->st_value,
+				name);
+		}
+	}
+
+	if (printed)
+		printf("\n");
+}
+
+static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
+			int use_real_mode)
+{
+	int i;
+	/* Walk through the relocations */
+	for (i =3D 0; i < ehdr.e_shnum; i++) {
+		char *sym_strtab;
+		Elf32_Sym *sh_symtab;
+		struct section *sec_applies, *sec_symtab;
+		int j;
+		struct section *sec =3D &secs[i];
+
+		if (sec->shdr.sh_type !=3D SHT_REL) {
+			continue;
+		}
+		sec_symtab  =3D sec->link;
+		sec_applies =3D &secs[sec->shdr.sh_info];
+		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
+			continue;
+		}
+		sh_symtab =3D sec_symtab->symtab;
+		sym_strtab =3D sec_symtab->link->strtab;
+		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
+			Elf32_Rel *rel;
+			Elf32_Sym *sym;
+			unsigned r_type;
+			const char *symname;
+			int shn_abs;
+
+			rel =3D &sec->reltab[j];
+			sym =3D &sh_symtab[ELF32_R_SYM(rel->r_info)];
+			r_type =3D ELF32_R_TYPE(rel->r_info);
+
+			shn_abs =3D sym->st_shndx =3D=3D SHN_ABS;
+
+			switch (r_type) {
+			case R_386_NONE:
+			case R_386_PC32:
+			case R_386_PC16:
+			case R_386_PC8:
+				/*
+				 * NONE can be ignored and and PC relative
+				 * relocations don't need to be adjusted.
+				 */
+				break;
+
+			case R_386_16:
+				symname =3D sym_name(sym_strtab, sym);
+				if (!use_real_mode)
+					goto bad;
+				if (shn_abs) {
+					if (is_reloc(S_ABS, symname))
+						break;
+					else if (!is_reloc(S_SEG, symname))
+						goto bad;
+				} else {
+					if (is_reloc(S_LIN, symname))
+						goto bad;
+					else
+						break;
+				}
+				visit(rel, sym);
+				break;
+
+			case R_386_32:
+				symname =3D sym_name(sym_strtab, sym);
+				if (shn_abs) {
+					if (is_reloc(S_ABS, symname))
+						break;
+					else if (!is_reloc(S_REL, symname))
+						goto bad;
+				} else {
+					if (use_real_mode &&
+					    !is_reloc(S_LIN, symname))
+						break;
+				}
+				visit(rel, sym);
+				break;
+			default:
+				die("Unsupported relocation type: %s (%d)\n",
+				    rel_type(r_type), r_type);
+				break;
+			bad:
+				symname =3D sym_name(sym_strtab, sym);
+				die("Invalid %s %s relocation: %s\n",
+				    shn_abs ? "absolute" : "relative",
+				    rel_type(r_type), symname);
+			}
+		}
+	}
+}
+
+static void count_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
+{
+	if (ELF32_R_TYPE(rel->r_info) =3D=3D R_386_16)
+		reloc16_count++;
+	else
+		reloc_count++;
+}
+
+static void collect_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
+{
+	/* Remember the address that needs to be adjusted. */
+	if (ELF32_R_TYPE(rel->r_info) =3D=3D R_386_16)
+		relocs16[reloc16_idx++] =3D rel->r_offset;
+	else
+		relocs[reloc_idx++] =3D rel->r_offset;
+}
+
+static int cmp_relocs(const void *va, const void *vb)
+{
+	const unsigned long *a, *b;
+	a =3D va; b =3D vb;
+	return (*a =3D=3D *b)? 0 : (*a > *b)? 1 : -1;
+}
+
+static int write32(unsigned int v, FILE *f)
+{
+	unsigned char buf[4];
+
+	buf[0] =3D (v >>  0) & 0xff;
+	buf[1] =3D (v >>  8) & 0xff;
+	buf[2] =3D (v >> 16) & 0xff;
+	buf[3] =3D (v >> 24) & 0xff;
+	return fwrite(buf, 1, 4, f) =3D=3D 4 ? 0 : -1;
+}
+
+static void emit_relocs(int as_text, int use_real_mode)
+{
+	int i;
+	/* Count how many relocations I have and allocate space for them. */
+	reloc_count =3D 0;
+	walk_relocs(count_reloc, use_real_mode);
+	relocs =3D malloc(reloc_count * sizeof(relocs[0]));
+	if (!relocs) {
+		die("malloc of %d entries for relocs failed\n",
+			reloc_count);
+	}
+
+	relocs16 =3D malloc(reloc16_count * sizeof(relocs[0]));
+	if (!relocs16) {
+		die("malloc of %d entries for relocs16 failed\n",
+			reloc16_count);
+	}
+	/* Collect up the relocations */
+	reloc_idx =3D 0;
+	walk_relocs(collect_reloc, use_real_mode);
+
+	if (reloc16_count && !use_real_mode)
+		die("Segment relocations found but --realmode not specified\n");
+
+	/* Order the relocations for more efficient processing */
+	qsort(relocs, reloc_count, sizeof(relocs[0]), cmp_relocs);
+	qsort(relocs16, reloc16_count, sizeof(relocs16[0]), cmp_relocs);
+
+	/* Print the relocations */
+	if (as_text) {
+		/* Print the relocations in a form suitable that
+		 * gas will like.
+		 */
+		printf(".section \".data.reloc\",\"a\"\n");
+		printf(".balign 4\n");
+		if (use_real_mode) {
+			printf("\t.long %lu\n", reloc16_count);
+			for (i =3D 0; i < reloc16_count; i++)
+				printf("\t.long 0x%08lx\n", relocs16[i]);
+			printf("\t.long %lu\n", reloc_count);
+			for (i =3D 0; i < reloc_count; i++) {
+				printf("\t.long 0x%08lx\n", relocs[i]);
+			}
+		} else {
+			/* Print a stop */
+			printf("\t.long 0x%08lx\n", (unsigned long)0);
+			for (i =3D 0; i < reloc_count; i++) {
+				printf("\t.long 0x%08lx\n", relocs[i]);
+			}
+		}
+
+		printf("\n");
+	}
+	else {
+		if (use_real_mode) {
+			write32(reloc16_count, stdout);
+			for (i =3D 0; i < reloc16_count; i++)
+				write32(relocs16[i], stdout);
+			write32(reloc_count, stdout);
+
+			/* Now print each relocation */
+			for (i =3D 0; i < reloc_count; i++)
+				write32(relocs[i], stdout);
+		} else {
+			/* Print a stop */
+			write32(0, stdout);
+
+			/* Now print each relocation */
+			for (i =3D 0; i < reloc_count; i++) {
+				write32(relocs[i], stdout);
+			}
+		}
+	}
+}
+
+static void usage(void)
+{
+	die("relocs [--abs-syms|--abs-relocs|--text|--realmode] vmlinux\n");
+}
+
+int main(int argc, char **argv)
+{
+	int show_absolute_syms, show_absolute_relocs;
+	int as_text, use_real_mode;
+	const char *fname;
+	FILE *fp;
+	int i;
+
+	show_absolute_syms =3D 0;
+	show_absolute_relocs =3D 0;
+	as_text =3D 0;
+	use_real_mode =3D 0;
+	fname =3D NULL;
+	for (i =3D 1; i < argc; i++) {
+		char *arg =3D argv[i];
+		if (*arg =3D=3D '-') {
+			if (strcmp(arg, "--abs-syms") =3D=3D 0) {
+				show_absolute_syms =3D 1;
+				continue;
+			}
+			if (strcmp(arg, "--abs-relocs") =3D=3D 0) {
+				show_absolute_relocs =3D 1;
+				continue;
+			}
+			if (strcmp(arg, "--text") =3D=3D 0) {
+				as_text =3D 1;
+				continue;
+			}
+			if (strcmp(arg, "--realmode") =3D=3D 0) {
+				use_real_mode =3D 1;
+				continue;
+			}
+		}
+		else if (!fname) {
+			fname =3D arg;
+			continue;
+		}
+		usage();
+	}
+	if (!fname) {
+		usage();
+	}
+	regex_init(use_real_mode);
+	fp =3D fopen(fname, "r");
+	if (!fp) {
+		die("Cannot open %s: %s\n",
+			fname, strerror(errno));
+	}
+	read_ehdr(fp);
+	read_shdrs(fp);
+	read_strtabs(fp);
+	read_symtabs(fp);
+	read_relocs(fp);
+	if (show_absolute_syms) {
+		print_absolute_symbols();
+		return 0;
+	}
+	if (show_absolute_relocs) {
+		print_absolute_relocs();
+		return 0;
+	}
+	emit_relocs(as_text, use_real_mode);
+	return 0;
+}
diff --git a/block/genhd.c b/block/genhd.c
index 997afd6..4927476 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -744,7 +744,7 @@ void __init printk_all_partitions(void)
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
-		u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
+		char uuid_buf[PARTITION_META_INFO_UUIDLTH * 2 + 5];
=20
 		/*
 		 * Don't show empty devices or things that have been
@@ -763,14 +763,16 @@ void __init printk_all_partitions(void)
 		while ((part =3D disk_part_iter_next(&piter))) {
 			bool is_part0 =3D part =3D=3D &disk->part0;
=20
-			uuid[0] =3D 0;
+			uuid_buf[0] =3D '\0';
 			if (part->info)
-				part_unpack_uuid(part->info->uuid, uuid);
+				snprintf(uuid_buf, sizeof(uuid_buf), "%pU",
+					 part->info->uuid);
=20
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf), uuid);
+			       disk_name(disk, part->partno, name_buf),
+			       uuid_buf);
 			if (is_part0) {
 				if (disk->driverfs_dev !=3D NULL &&
 				    disk->driverfs_dev->driver !=3D NULL)
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 0a7ed69..ca191ff 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -438,6 +438,14 @@ static struct dmi_system_id __initdata acpisleep_dmi_t=
able[] =3D {
 	},
 	{
 	.callback =3D init_nvs_nosave,
+	.ident =3D "Sony Vaio VPCCW29FX",
+	.matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCCW29FX"),
+		},
+	},
+	{
+	.callback =3D init_nvs_nosave,
 	.ident =3D "Averatec AV1020-ED2",
 	.matches =3D {
 		DMI_MATCH(DMI_SYS_VENDOR, "AVERATEC"),
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index cf26222..fb65915 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -384,6 +384,8 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9128 */
 	{ PCI_DEVICE(0x1b4b, 0x9125),
 	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE(0x1b4b, 0x917a),
+	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data =3D board_ahci_yes_fbs },
=20
diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 5cd04b6..edcffd6 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -163,7 +163,8 @@ static void mpc8xxx_gpio_irq_cascade(unsigned int irq, =
struct irq_desc *desc)
 	if (mask)
 		generic_handle_irq(irq_linear_revmap(mpc8xxx_gc->irq,
 						     32 - ffs(mask)));
-	chip->irq_eoi(&desc->irq_data);
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
 }
=20
 static void mpc8xxx_irq_unmask(struct irq_data *d)
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_ir=
q.c
index d47a53b..d3820c2 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -424,14 +424,11 @@ static void gen6_pm_rps_work(struct work_struct *work=
)
 	mutex_unlock(&dev_priv->dev->struct_mutex);
 }
=20
-static void pch_irq_handler(struct drm_device *dev)
+static void pch_irq_handler(struct drm_device *dev, u32 pch_iir)
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_private;
-	u32 pch_iir;
 	int pipe;
=20
-	pch_iir =3D I915_READ(SDEIIR);
-
 	if (pch_iir & SDE_AUDIO_POWER_MASK)
 		DRM_DEBUG_DRIVER("PCH audio power change on port %d\n",
 				 (pch_iir & SDE_AUDIO_POWER_MASK) >>
@@ -529,7 +526,7 @@ static irqreturn_t ivybridge_irq_handler(DRM_IRQ_ARGS)
 	if (de_iir & DE_PCH_EVENT_IVB) {
 		if (pch_iir & SDE_HOTPLUG_MASK_CPT)
 			queue_work(dev_priv->wq, &dev_priv->hotplug_work);
-		pch_irq_handler(dev);
+		pch_irq_handler(dev, pch_iir);
 	}
=20
 	if (pm_iir & GEN6_PM_DEFERRED_EVENTS) {
@@ -629,7 +626,7 @@ static irqreturn_t ironlake_irq_handler(DRM_IRQ_ARGS)
 	if (de_iir & DE_PCH_EVENT) {
 		if (pch_iir & hotplug_mask)
 			queue_work(dev_priv->wq, &dev_priv->hotplug_work);
-		pch_irq_handler(dev);
+		pch_irq_handler(dev, pch_iir);
 	}
=20
 	if (de_iir & DE_PCU_EVENT) {
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_re=
g.h
index cbe5a88..a1d53b6 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -570,6 +570,21 @@
=20
 #define GEN6_BSD_RNCID			0x12198
=20
+#define GEN7_FF_THREAD_MODE		0x20a0
+#define   GEN7_FF_SCHED_MASK		0x0077070
+#define   GEN7_FF_TS_SCHED_HS1		(0x5<<16)
+#define   GEN7_FF_TS_SCHED_HS0		(0x3<<16)
+#define   GEN7_FF_TS_SCHED_LOAD_BALANCE	(0x1<<16)
+#define   GEN7_FF_TS_SCHED_HW		(0x0<<16) /* Default */
+#define   GEN7_FF_VS_SCHED_HS1		(0x5<<12)
+#define   GEN7_FF_VS_SCHED_HS0		(0x3<<12)
+#define   GEN7_FF_VS_SCHED_LOAD_BALANCE	(0x1<<12) /* Default */
+#define   GEN7_FF_VS_SCHED_HW		(0x0<<12)
+#define   GEN7_FF_DS_SCHED_HS1		(0x5<<4)
+#define   GEN7_FF_DS_SCHED_HS0		(0x3<<4)
+#define   GEN7_FF_DS_SCHED_LOAD_BALANCE	(0x1<<4)  /* Default */
+#define   GEN7_FF_DS_SCHED_HW		(0x0<<4)
+
 /*
  * Framebuffer compression (915+ only)
  */
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 390768f..3ff980d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7280,10 +7280,11 @@ static void intel_sanitize_modesetting(struct drm_d=
evice *dev,
 {
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
 	u32 reg, val;
+	int i;
=20
 	/* Clear any frame start delays used for debugging left by the BIOS */
-	for_each_pipe(pipe) {
-		reg =3D PIPECONF(pipe);
+	for_each_pipe(i) {
+		reg =3D PIPECONF(i);
 		I915_WRITE(reg, I915_READ(reg) & ~PIPECONF_FRAME_START_DELAY_MASK);
 	}
=20
@@ -8245,6 +8246,18 @@ static void gen6_init_clock_gating(struct drm_device=
 *dev)
 	}
 }
=20
+static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_p=
riv)
+{
+	uint32_t reg =3D I915_READ(GEN7_FF_THREAD_MODE);
+
+	reg &=3D ~GEN7_FF_SCHED_MASK;
+	reg |=3D GEN7_FF_TS_SCHED_HW;
+	reg |=3D GEN7_FF_VS_SCHED_HW;
+	reg |=3D GEN7_FF_DS_SCHED_HW;
+
+	I915_WRITE(GEN7_FF_THREAD_MODE, reg);
+}
+
 static void ivybridge_init_clock_gating(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
@@ -8285,6 +8298,8 @@ static void ivybridge_init_clock_gating(struct drm_de=
vice *dev)
 			   DISPPLANE_TRICKLE_FEED_DISABLE);
 		intel_flush_display_plane(dev_priv, pipe);
 	}
+
+	gen7_setup_fixed_func_scheduler(dev_priv);
 }
=20
 static void g4x_init_clock_gating(struct drm_device *dev)
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau=
/nouveau_bo.c
index 7cc37e6..d5af089 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1024,7 +1024,7 @@ nouveau_ttm_fault_reserve_notify(struct ttm_buffer_ob=
ject *bo)
=20
 	nvbo->placement.fpfn =3D 0;
 	nvbo->placement.lpfn =3D dev_priv->fb_mappable_pages;
-	nouveau_bo_placement_set(nvbo, TTM_PL_VRAM, 0);
+	nouveau_bo_placement_set(nvbo, TTM_PL_FLAG_VRAM, 0);
 	return nouveau_bo_validate(nvbo, false, true, false);
 }
=20
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 38b12e4..2eac8c5 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -26,6 +26,7 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <asm/unaligned.h>
 #include "usbhid/usbhid.h"
 #include "hid-ids.h"
 #include "hid-logitech-dj.h"
@@ -265,8 +266,8 @@ static void logi_dj_recv_add_djhid_device(struct dj_rec=
eiver_dev *djrcv_dev,
 		goto dj_device_allocate_fail;
 	}
=20
-	dj_dev->reports_supported =3D le32_to_cpu(
-		dj_report->report_params[DEVICE_PAIRED_RF_REPORT_TYPE]);
+	dj_dev->reports_supported =3D get_unaligned_le32(
+		dj_report->report_params + DEVICE_PAIRED_RF_REPORT_TYPE);
 	dj_dev->hdev =3D dj_hiddev;
 	dj_dev->dj_receiver_dev =3D djrcv_dev;
 	dj_dev->device_index =3D dj_report->device_index;
diff --git a/drivers/hid/hid-wiimote.c b/drivers/hid/hid-wiimote.c
index 76739c0..bfa9a27 100644
--- a/drivers/hid/hid-wiimote.c
+++ b/drivers/hid/hid-wiimote.c
@@ -829,7 +829,7 @@ static void __ir_to_input(struct wiimote_data *wdata, c=
onst __u8 *ir,
=20
 	/*
 	 * Basic IR data is encoded into 3 bytes. The first two bytes are the
-	 * upper 8 bit of the X/Y data, the 3rd byte contains the lower 2 bits
+	 * lower 8 bit of the X/Y data, the 3rd byte contains the upper 2 bits
 	 * of both.
 	 * If data is packed, then the 3rd byte is put first and slightly
 	 * reordered. This allows to interleave packed and non-packed data to
@@ -838,17 +838,11 @@ static void __ir_to_input(struct wiimote_data *wdata,=
 const __u8 *ir,
 	 */
=20
 	if (packed) {
-		x =3D ir[1] << 2;
-		y =3D ir[2] << 2;
-
-		x |=3D ir[0] & 0x3;
-		y |=3D (ir[0] >> 2) & 0x3;
+		x =3D ir[1] | ((ir[0] & 0x03) << 8);
+		y =3D ir[2] | ((ir[0] & 0x0c) << 6);
 	} else {
-		x =3D ir[0] << 2;
-		y =3D ir[1] << 2;
-
-		x |=3D (ir[2] >> 4) & 0x3;
-		y |=3D (ir[2] >> 6) & 0x3;
+		x =3D ir[0] | ((ir[2] & 0x30) << 4);
+		y =3D ir[1] | ((ir[2] & 0xc0) << 2);
 	}
=20
 	input_report_abs(wdata->ir, xid, x);
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davi=
nci.c
index a76d85f..79b4bcb 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -755,7 +755,7 @@ static int davinci_i2c_remove(struct platform_device *p=
dev)
 	dev->clk =3D NULL;
=20
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
-	free_irq(IRQ_I2C, dev);
+	free_irq(dev->irq, dev);
 	iounmap(dev->base);
 	kfree(dev);
=20
diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.=
c
index 730215e..2cda65bf 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -315,7 +315,7 @@ static s32 pch_i2c_wait_for_xfer_complete(struct i2c_al=
go_pch_data *adap)
 {
 	long ret;
 	ret =3D wait_event_timeout(pch_event,
-			(adap->pch_event_flag !=3D 0), msecs_to_jiffies(50));
+			(adap->pch_event_flag !=3D 0), msecs_to_jiffies(1000));
=20
 	if (ret =3D=3D 0) {
 		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.=
c
index 46b6500..3d7885a 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -401,8 +401,6 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 			disable_irq_nosync(i2c_dev->irq);
 			i2c_dev->irq_disabled =3D 1;
 		}
-
-		complete(&i2c_dev->msg_complete);
 		goto err;
 	}
=20
@@ -411,7 +409,6 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 			i2c_dev->msg_err |=3D I2C_ERR_NO_ACK;
 		if (status & I2C_INT_ARBITRATION_LOST)
 			i2c_dev->msg_err |=3D I2C_ERR_ARBITRATION_LOST;
-		complete(&i2c_dev->msg_complete);
 		goto err;
 	}
=20
@@ -429,14 +426,14 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_i=
d)
 			tegra_i2c_mask_irq(i2c_dev, I2C_INT_TX_FIFO_DATA_REQ);
 	}
=20
+	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
+	if (i2c_dev->is_dvc)
+		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
+
 	if (status & I2C_INT_PACKET_XFER_COMPLETE) {
 		BUG_ON(i2c_dev->msg_buf_remaining);
 		complete(&i2c_dev->msg_complete);
 	}
-
-	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
-	if (i2c_dev->is_dvc)
-		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
 	return IRQ_HANDLED;
 err:
 	/* An error occurred, mask all interrupts */
@@ -446,6 +443,8 @@ err:
 	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
 	if (i2c_dev->is_dvc)
 		dvc_writel(i2c_dev, DVC_STATUS_I2C_DONE_INTR, DVC_STATUS);
+
+	complete(&i2c_dev->msg_complete);
 	return IRQ_HANDLED;
 }
=20
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.=
c
index 71f0c0f..a841123 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -269,7 +269,7 @@ void ib_umem_release(struct ib_umem *umem)
 	} else
 		down_write(&mm->mmap_sem);
=20
-	current->mm->locked_vm -=3D diff;
+	current->mm->pinned_vm -=3D diff;
 	up_write(&mm->mmap_sem);
 	mmput(mm);
 	kfree(umem);
diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4=
/cm.c
index 0747004..2e6a538 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2714,6 +2714,12 @@ static int peer_abort_intr(struct c4iw_dev *dev, str=
uct sk_buff *skb)
 	unsigned int tid =3D GET_TID(req);
=20
 	ep =3D lookup_tid(t, tid);
+	if (!ep) {
+		printk(KERN_WARNING MOD
+		       "Abort on non-existent endpoint, tid %d\n", tid);
+		kfree_skb(skb);
+		return 0;
+	}
 	if (is_neg_adv_abort(req->status)) {
 		PDBG("%s neg_adv_abort ep %p tid %u\n", __func__, ep,
 		     ep->hwtid);
@@ -2725,11 +2731,8 @@ static int peer_abort_intr(struct c4iw_dev *dev, str=
uct sk_buff *skb)
=20
 	/*
 	 * Wake up any threads in rdma_init() or rdma_fini().
-	 * However, this is not needed if com state is just
-	 * MPA_REQ_SENT
 	 */
-	if (ep->com.state !=3D MPA_REQ_SENT)
-		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
+	c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 	sched(dev, skb);
 	return 0;
 }
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_=
wac.c
index 2ee47d0..f00c70e 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -843,12 +843,7 @@ static int wacom_bpt_pen(struct wacom_wac *wacom)
 	unsigned char *data =3D wacom->data;
 	int prox =3D 0, x =3D 0, y =3D 0, p =3D 0, d =3D 0, pen =3D 0, btn1 =3D 0=
, btn2 =3D 0;
=20
-	/*
-	 * Similar to Graphire protocol, data[1] & 0x20 is proximity and
-	 * data[1] & 0x18 is tool ID.  0x30 is safety check to ignore
-	 * 2 unused tool ID's.
-	 */
-	prox =3D (data[1] & 0x30) =3D=3D 0x30;
+	prox =3D (data[1] & 0x20) =3D=3D 0x20;
=20
 	/*
 	 * All reports shared between PEN and RUBBER tool must be
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 35c1e17..97b2e21 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1056,8 +1056,8 @@ static const char *intr_remap_fault_reasons[] =3D
=20
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
-	if (fault_reason >=3D 0x20 && (fault_reason <=3D 0x20 +
-				     ARRAY_SIZE(intr_remap_fault_reasons))) {
+	if (fault_reason >=3D 0x20 && (fault_reason - 0x20 <
+					ARRAY_SIZE(intr_remap_fault_reasons))) {
 		*fault_type =3D INTR_REMAP;
 		return intr_remap_fault_reasons[fault_reason - 0x20];
 	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index bdc447f..ccf347f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2267,12 +2267,6 @@ static int domain_add_dev_info(struct dmar_domain *d=
omain,
 	if (!info)
 		return -ENOMEM;
=20
-	ret =3D domain_context_mapping(domain, pdev, translation);
-	if (ret) {
-		free_devinfo_mem(info);
-		return ret;
-	}
-
 	info->segment =3D pci_domain_nr(pdev->bus);
 	info->bus =3D pdev->bus->number;
 	info->devfn =3D pdev->devfn;
@@ -2285,6 +2279,17 @@ static int domain_add_dev_info(struct dmar_domain *d=
omain,
 	pdev->dev.archdata.iommu =3D info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
=20
+	ret =3D domain_context_mapping(domain, pdev, translation);
+	if (ret) {
+		spin_lock_irqsave(&device_domain_lock, flags);
+		list_del(&info->link);
+		list_del(&info->global);
+		pdev->dev.archdata.iommu =3D NULL;
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		free_devinfo_mem(info);
+		return ret;
+	}
+
 	return 0;
 }
=20
diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 6d5ceee..fd17bb3 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -14,6 +14,7 @@
 #include "gigaset.h"
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/ratelimit.h>
 #include <linux/isdn/capilli.h>
 #include <linux/isdn/capicmd.h>
 #include <linux/isdn/capiutil.h>
@@ -223,10 +224,14 @@ get_appl(struct gigaset_capi_ctr *iif, u16 appl)
 static inline void dump_cmsg(enum debuglevel level, const char *tag, _cmsg=
 *p)
 {
 #ifdef CONFIG_GIGASET_DEBUG
+	/* dump at most 20 messages in 20 secs */
+	static DEFINE_RATELIMIT_STATE(msg_dump_ratelimit, 20 * HZ, 20);
 	_cdebbuf *cdb;
=20
 	if (!(gigaset_debuglevel & level))
 		return;
+	if (!___ratelimit(&msg_dump_ratelimit, tag))
+		return;
=20
 	cdb =3D capi_cmsg2str(p);
 	if (cdb) {
@@ -1882,6 +1887,9 @@ static void do_disconnect_req(struct gigaset_capi_ctr=
 *iif,
=20
 	/* check for active logical connection */
 	if (bcs->apconnstate >=3D APCONN_ACTIVE) {
+		/* clear it */
+		bcs->apconnstate =3D APCONN_SETUP;
+
 		/*
 		 * emit DISCONNECT_B3_IND with cause 0x3301
 		 * use separate cmsg structure, as the content of iif->acmsg
@@ -1906,6 +1914,7 @@ static void do_disconnect_req(struct gigaset_capi_ctr=
 *iif,
 		}
 		capi_cmsg2message(b3cmsg,
 			__skb_put(b3skb, CAPI_DISCONNECT_B3_IND_BASELEN));
+		dump_cmsg(DEBUG_CMD, __func__, b3cmsg);
 		kfree(b3cmsg);
 		capi_ctr_handle_message(&iif->ctr, ap->id, b3skb);
 	}
@@ -2059,12 +2068,6 @@ static void do_reset_b3_req(struct gigaset_capi_ctr =
*iif,
 }
=20
 /*
- * dump unsupported/ignored messages at most twice per minute,
- * some apps send those very frequently
- */
-static unsigned long ignored_msg_dump_time;
-
-/*
  * unsupported CAPI message handler
  */
 static void do_unsupported(struct gigaset_capi_ctr *iif,
@@ -2073,8 +2076,7 @@ static void do_unsupported(struct gigaset_capi_ctr *i=
if,
 {
 	/* decode message */
 	capi_message2cmsg(&iif->acmsg, skb->data);
-	if (printk_timed_ratelimit(&ignored_msg_dump_time, 30 * 1000))
-		dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
+	dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
 	send_conf(iif, ap, skb, CapiMessageNotSupportedInCurrentState);
 }
=20
@@ -2085,11 +2087,9 @@ static void do_nothing(struct gigaset_capi_ctr *iif,
 		       struct gigaset_capi_appl *ap,
 		       struct sk_buff *skb)
 {
-	if (printk_timed_ratelimit(&ignored_msg_dump_time, 30 * 1000)) {
-		/* decode message */
-		capi_message2cmsg(&iif->acmsg, skb->data);
-		dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
-	}
+	/* decode message */
+	capi_message2cmsg(&iif->acmsg, skb->data);
+	dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
 	dev_kfree_skb_any(skb);
 }
=20
diff --git a/drivers/isdn/gigaset/ev-layer.c b/drivers/isdn/gigaset/ev-laye=
r.c
index 6d12623..e95fac0 100644
--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -190,6 +190,7 @@ struct reply_t gigaset_tab_nocid[] =3D
 							  ACT_INIT} },
 {RSP_OK,	121, 121, -1,			  0,  0, {ACT_GOTVER,
 							  ACT_INIT} },
+{RSP_NONE,	121, 121, -1,			120,  0, {ACT_GETSTRING} },
=20
 /* leave dle mode */
 {RSP_INIT,	  0,   0, SEQ_DLE0,		201,  5, {0},	"^SDLE=3D0\r"},
@@ -1314,8 +1315,9 @@ static void do_action(int action, struct cardstate *c=
s,
 		s =3D ev->ptr;
=20
 		if (!strcmp(s, "OK")) {
+			/* OK without version string: assume old response */
 			*p_genresp =3D 1;
-			*p_resp_code =3D RSP_ERROR;
+			*p_resp_code =3D RSP_NONE;
 			break;
 		}
=20
diff --git a/drivers/md/md.c b/drivers/md/md.c
index adcd850..700ecae 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -453,7 +453,7 @@ static void submit_flushes(struct work_struct *ws)
 			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
-			bi =3D bio_alloc_mddev(GFP_KERNEL, 0, mddev);
+			bi =3D bio_alloc_mddev(GFP_NOIO, 0, mddev);
 			bi->bi_end_io =3D md_end_flush;
 			bi->bi_private =3D rdev;
 			bi->bi_bdev =3D rdev->bdev;
diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/sms=
usb.c
index 51c7121..b7d1e3e 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -542,6 +542,8 @@ static const struct usb_device_id smsusb_id_table[] __d=
evinitconst =3D {
 		.driver_info =3D SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ USB_DEVICE(0x2040, 0xc090),
 		.driver_info =3D SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
+	{ USB_DEVICE(0x2040, 0xc0a0),
+		.driver_info =3D SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ } /* Terminating entry */
 	};
=20
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/u=
vc_v4l2.c
index cf7788f..1030479 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -689,7 +689,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsign=
ed int cmd, void *arg)
 					break;
 			}
 			pin =3D iterm->id;
-		} else if (pin < selector->bNrInPins) {
+		} else if (index < selector->bNrInPins) {
 			pin =3D selector->baSourceID[index];
 			list_for_each_entry(iterm, &chain->entities, chain) {
 				if (!UVC_ENTITY_IS_ITERM(iterm))
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 3ab565e..558a495 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -663,7 +663,7 @@ static int mmc_sdio_resume(struct mmc_host *host)
 	}
=20
 	if (!err && host->sdio_irqs)
-		mmc_signal_sdio_irq(host);
+		wake_up_process(host->sdio_irq_thread);
 	mmc_release_host(host);
=20
 	/*
diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index 68f81b9..9dd0462 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -28,18 +28,20 @@
=20
 #include "sdio_ops.h"
=20
-static int process_sdio_pending_irqs(struct mmc_card *card)
+static int process_sdio_pending_irqs(struct mmc_host *host)
 {
+	struct mmc_card *card =3D host->card;
 	int i, ret, count;
 	unsigned char pending;
 	struct sdio_func *func;
=20
 	/*
 	 * Optimization, if there is only 1 function interrupt registered
-	 * call irq handler directly
+	 * and we know an IRQ was signaled then call irq handler directly.
+	 * Otherwise do the full probe.
 	 */
 	func =3D card->sdio_single_irq;
-	if (func) {
+	if (func && host->sdio_irq_pending) {
 		func->irq_handler(func);
 		return 1;
 	}
@@ -116,7 +118,8 @@ static int sdio_irq_thread(void *_host)
 		ret =3D __mmc_claim_host(host, &host->sdio_irq_thread_abort);
 		if (ret)
 			break;
-		ret =3D process_sdio_pending_irqs(host->card);
+		ret =3D process_sdio_pending_irqs(host);
+		host->sdio_irq_pending =3D false;
 		mmc_release_host(host);
=20
 		/*
diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
index fddb714..a9ff89ff 100644
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -1256,7 +1256,7 @@ static void sm_remove_dev(struct mtd_blktrans_dev *de=
v)
=20
 static struct mtd_blktrans_ops sm_ftl_ops =3D {
 	.name		=3D "smblk",
-	.major		=3D -1,
+	.major		=3D 0,
 	.part_bits	=3D SM_FTL_PARTN_BITS,
 	.blksize	=3D SM_SECTOR_SIZE,
 	.getgeo		=3D sm_getgeo,
diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink=
/dl2k.c
index b2dc2c8..2e09edb 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1259,55 +1259,21 @@ rio_ioctl (struct net_device *dev, struct ifreq *rq=
, int cmd)
 {
 	int phy_addr;
 	struct netdev_private *np =3D netdev_priv(dev);
-	struct mii_data *miidata =3D (struct mii_data *) &rq->ifr_ifru;
-
-	struct netdev_desc *desc;
-	int i;
+	struct mii_ioctl_data *miidata =3D if_mii(rq);
=20
 	phy_addr =3D np->phy_addr;
 	switch (cmd) {
-	case SIOCDEVPRIVATE:
-		break;
-
-	case SIOCDEVPRIVATE + 1:
-		miidata->out_value =3D mii_read (dev, phy_addr, miidata->reg_num);
+	case SIOCGMIIPHY:
+		miidata->phy_id =3D phy_addr;
 		break;
-	case SIOCDEVPRIVATE + 2:
-		mii_write (dev, phy_addr, miidata->reg_num, miidata->in_value);
+	case SIOCGMIIREG:
+		miidata->val_out =3D mii_read (dev, phy_addr, miidata->reg_num);
 		break;
-	case SIOCDEVPRIVATE + 3:
-		break;
-	case SIOCDEVPRIVATE + 4:
-		break;
-	case SIOCDEVPRIVATE + 5:
-		netif_stop_queue (dev);
+	case SIOCSMIIREG:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+		mii_write (dev, phy_addr, miidata->reg_num, miidata->val_in);
 		break;
-	case SIOCDEVPRIVATE + 6:
-		netif_wake_queue (dev);
-		break;
-	case SIOCDEVPRIVATE + 7:
-		printk
-		    ("tx_full=3D%x cur_tx=3D%lx old_tx=3D%lx cur_rx=3D%lx old_rx=3D%lx\n=
",
-		     netif_queue_stopped(dev), np->cur_tx, np->old_tx, np->cur_rx,
-		     np->old_rx);
-		break;
-	case SIOCDEVPRIVATE + 8:
-		printk("TX ring:\n");
-		for (i =3D 0; i < TX_RING_SIZE; i++) {
-			desc =3D &np->tx_ring[i];
-			printk
-			    ("%02x:cur:%08x next:%08x status:%08x frag1:%08x frag0:%08x",
-			     i,
-			     (u32) (np->tx_ring_dma + i * sizeof (*desc)),
-			     (u32)le64_to_cpu(desc->next_desc),
-			     (u32)le64_to_cpu(desc->status),
-			     (u32)(le64_to_cpu(desc->fraginfo) >> 32),
-			     (u32)le64_to_cpu(desc->fraginfo));
-			printk ("\n");
-		}
-		printk ("\n");
-		break;
-
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/dlink/dl2k.h b/drivers/net/ethernet/dlink=
/dl2k.h
index ba0adca..30c2da3 100644
--- a/drivers/net/ethernet/dlink/dl2k.h
+++ b/drivers/net/ethernet/dlink/dl2k.h
@@ -365,13 +365,6 @@ struct ioctl_data {
 	char *data;
 };
=20
-struct mii_data {
-	__u16 reserved;
-	__u16 reg_num;
-	__u16 in_value;
-	__u16 out_value;
-};
-
 /* The Rx and Tx buffer descriptors. */
 struct netdev_desc {
 	__le64 next_desc;
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/e=
thernet/emulex/benet/be_ethtool.c
index bf8153e..7570c1a 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -649,12 +649,8 @@ static int
 be_do_flash(struct net_device *netdev, struct ethtool_flash *efl)
 {
 	struct be_adapter *adapter =3D netdev_priv(netdev);
-	char file_name[ETHTOOL_FLASH_MAX_FILENAME];
=20
-	file_name[ETHTOOL_FLASH_MAX_FILENAME - 1] =3D 0;
-	strcpy(file_name, efl->data);
-
-	return be_load_fw(adapter, file_name);
+	return be_load_fw(adapter, efl->data);
 }
=20
 static int
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b=
43legacy/main.c
index 20f0243..c5ce163 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1564,8 +1564,6 @@ static int b43legacy_request_firmware(struct b43legac=
y_wldev *dev)
 	const char *filename;
 	int err;
=20
-	/* do dummy read */
-	ssb_read32(dev->dev, SSB_TMSHIGH);
 	if (!fw->ucode) {
 		if (rev =3D=3D 2)
 			filename =3D "ucode2";
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlw=
ifi/usb.c
index 2b7bcc8..db34db6 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -113,46 +113,38 @@ static int _usbctrl_vendorreq_sync_read(struct usb_de=
vice *udev, u8 request,
 	return status;
 }
=20
-static u32 _usb_read_sync(struct usb_device *udev, u32 addr, u16 len)
+static u32 _usb_read_sync(struct rtl_priv *rtlpriv, u32 addr, u16 len)
 {
+	struct device *dev =3D rtlpriv->io.dev;
+	struct usb_device *udev =3D to_usb_device(dev);
 	u8 request;
 	u16 wvalue;
 	u16 index;
-	u32 *data;
-	u32 ret;
+	__le32 *data =3D &rtlpriv->usb_data[rtlpriv->usb_data_index];
=20
-	data =3D kmalloc(sizeof(u32), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
 	request =3D REALTEK_USB_VENQT_CMD_REQ;
 	index =3D REALTEK_USB_VENQT_CMD_IDX; /* n/a */
=20
 	wvalue =3D (u16)addr;
 	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	ret =3D *data;
-	kfree(data);
-	return ret;
+	if (++rtlpriv->usb_data_index >=3D RTL_USB_MAX_RX_COUNT)
+		rtlpriv->usb_data_index =3D 0;
+	return le32_to_cpu(*data);
 }
=20
 static u8 _usb_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev =3D rtlpriv->io.dev;
-
-	return (u8)_usb_read_sync(to_usb_device(dev), addr, 1);
+	return (u8)_usb_read_sync(rtlpriv, addr, 1);
 }
=20
 static u16 _usb_read16_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev =3D rtlpriv->io.dev;
-
-	return (u16)_usb_read_sync(to_usb_device(dev), addr, 2);
+	return (u16)_usb_read_sync(rtlpriv, addr, 2);
 }
=20
 static u32 _usb_read32_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev =3D rtlpriv->io.dev;
-
-	return _usb_read_sync(to_usb_device(dev), addr, 4);
+	return _usb_read_sync(rtlpriv, addr, 4);
 }
=20
 static void _usb_write_async(struct usb_device *udev, u32 addr, u32 val,
@@ -913,6 +905,11 @@ int __devinit rtl_usb_probe(struct usb_interface *intf=
,
 		return -ENOMEM;
 	}
 	rtlpriv =3D hw->priv;
+	rtlpriv->usb_data =3D kzalloc(RTL_USB_MAX_RX_COUNT * sizeof(u32),
+				    GFP_KERNEL);
+	if (!rtlpriv->usb_data)
+		return -ENOMEM;
+	rtlpriv->usb_data_index =3D 0;
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	udev =3D interface_to_usbdev(intf);
 	usb_get_dev(udev);
@@ -990,6 +987,7 @@ void rtl_usb_disconnect(struct usb_interface *intf)
 	/* rtl_deinit_rfkill(hw); */
 	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
+	kfree(rtlpriv->usb_data);
 	rtlpriv->cfg->ops->deinit_sw_leds(hw);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 	_rtl_usb_io_handler_release(hw);
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtl=
wifi/wifi.h
index 713c7dd..b1e9deb 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -63,7 +63,7 @@
 #define AC_MAX					4
 #define QOS_QUEUE_NUM				4
 #define RTL_MAC80211_NUM_QUEUE			5
-
+#define RTL_USB_MAX_RX_COUNT			100
 #define QBSS_LOAD_SIZE				5
 #define MAX_WMMELE_LENGTH			64
=20
@@ -1621,6 +1621,10 @@ struct rtl_priv {
 	   interface or hardware */
 	unsigned long status;
=20
+	/* data buffer pointer for USB reads */
+	__le32 *usb_data;
+	int usb_data_index;
+
 	/*This must be the last item so
 	   that it points to the data allocated
 	   beyond  this structure like:
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony=
-laptop.c
index c006dee..40c4705 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -127,7 +127,7 @@ MODULE_PARM_DESC(minor,
 		 "default is -1 (automatic)");
 #endif
=20
-static int kbd_backlight;	/* =3D 1 */
+static int kbd_backlight =3D 1;
 module_param(kbd_backlight, int, 0444);
 MODULE_PARM_DESC(kbd_backlight,
 		 "set this to 0 to disable keyboard backlight, "
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 938398f..6ec610c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2765,6 +2765,8 @@ unset_supplies:
 	unset_regulator_supplies(rdev);
=20
 scrub:
+	if (rdev->supply)
+		regulator_put(rdev->supply);
 	kfree(rdev->constraints);
 	device_unregister(&rdev->dev);
 	/* device core frees rdev */
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index e86edfc..1e80a48 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -312,6 +312,7 @@ static int pl031_probe(struct amba_device *adev, const =
struct amba_id *id)
 	int ret;
 	struct pl031_local *ldata;
 	struct rtc_class_ops *ops =3D id->data;
+	unsigned long time;
=20
 	ret =3D amba_request_regions(adev, NULL);
 	if (ret)
@@ -343,6 +344,23 @@ static int pl031_probe(struct amba_device *adev, const=
 struct amba_id *id)
 		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
 		       ldata->base + RTC_CR);
=20
+	/*
+	 * On ST PL031 variants, the RTC reset value does not provide correct
+	 * weekday for 2000-01-01. Correct the erroneous sunday to saturday.
+	 */
+	if (ldata->hw_designer =3D=3D AMBA_VENDOR_ST) {
+		if (readl(ldata->base + RTC_YDR) =3D=3D 0x2000) {
+			time =3D readl(ldata->base + RTC_DR);
+			if ((time &
+			     (RTC_MON_MASK | RTC_MDAY_MASK | RTC_WDAY_MASK))
+			    =3D=3D 0x02120000) {
+				time =3D time | (0x7 << RTC_WDAY_SHIFT);
+				writel(0x2000, ldata->base + RTC_YLR);
+				writel(time, ldata->base + RTC_LR);
+			}
+		}
+	}
+
 	ldata->rtc =3D rtc_device_register("pl031", &adev->dev, ops,
 					THIS_MODULE);
 	if (IS_ERR(ldata->rtc)) {
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 865d452..b4d2c86 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1674,30 +1674,26 @@ static void figure_bus_target_lun(struct ctlr_info =
*h,
=20
 	if (is_logical_dev_addr_mode(lunaddrbytes)) {
 		/* logical device */
-		if (unlikely(is_scsi_rev_5(h))) {
-			/* p1210m, logical drives lun assignments
-			 * match SCSI REPORT LUNS data.
+		lunid =3D le32_to_cpu(*((__le32 *) lunaddrbytes));
+		if (is_msa2xxx(h, device)) {
+			/* msa2xxx way, put logicals on bus 1
+			 * and match target/lun numbers box
+			 * reports.
 			 */
-			lunid =3D le32_to_cpu(*((__le32 *) lunaddrbytes));
-			*bus =3D 0;
-			*target =3D 0;
-			*lun =3D (lunid & 0x3fff) + 1;
+			*bus =3D 1;
+			*target =3D (lunid >> 16) & 0x3fff;
+			*lun =3D lunid & 0x00ff;
 		} else {
-			/* not p1210m... */
-			lunid =3D le32_to_cpu(*((__le32 *) lunaddrbytes));
-			if (is_msa2xxx(h, device)) {
-				/* msa2xxx way, put logicals on bus 1
-				 * and match target/lun numbers box
-				 * reports.
-				 */
-				*bus =3D 1;
-				*target =3D (lunid >> 16) & 0x3fff;
-				*lun =3D lunid & 0x00ff;
+			if (likely(is_scsi_rev_5(h))) {
+				/* All current smart arrays (circa 2011) */
+				*bus =3D 0;
+				*target =3D 0;
+				*lun =3D (lunid & 0x3fff) + 1;
 			} else {
-				/* Traditional smart array way. */
+				/* Traditional old smart array way. */
 				*bus =3D 0;
-				*lun =3D 0;
 				*target =3D lunid & 0x3fff;
+				*lun =3D 0;
 			}
 		}
 	} else {
@@ -4072,10 +4068,10 @@ static int hpsa_request_irq(struct ctlr_info *h,
=20
 	if (h->msix_vector || h->msi_vector)
 		rc =3D request_irq(h->intr[h->intr_mode], msixhandler,
-				IRQF_DISABLED, h->devname, h);
+				0, h->devname, h);
 	else
 		rc =3D request_irq(h->intr[h->intr_mode], intxhandler,
-				IRQF_DISABLED, h->devname, h);
+				IRQF_SHARED, h->devname, h);
 	if (rc) {
 		dev_err(&h->pdev->dev, "unable to get irq %d for %s\n",
 		       h->intr[h->intr_mode], h->devname);
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index a97edab..83d08b6 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -465,7 +465,7 @@ static int __devinit isci_pci_probe(struct pci_dev *pde=
v, const struct pci_devic
 	if (!orom)
 		orom =3D isci_request_oprom(pdev);
=20
-	for (i =3D 0; orom && i < ARRAY_SIZE(orom->ctrl); i++) {
+	for (i =3D 0; orom && i < num_controllers(pdev); i++) {
 		if (sci_oem_parameters_validate(&orom->ctrl[i])) {
 			dev_warn(&pdev->dev,
 				 "[%d]: invalid oem parameters detected, falling back to firmware\n", =
i);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt=
2sas_base.c
index b1ddfef..ac336e1 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3274,7 +3274,7 @@ _base_get_port_facts(struct MPT2SAS_ADAPTER *ioc, int=
 port, int sleep_flag)
 	}
=20
 	pfacts =3D &ioc->pfacts[port];
-	memset(pfacts, 0, sizeof(Mpi2PortFactsReply_t));
+	memset(pfacts, 0, sizeof(struct mpt2sas_port_facts));
 	pfacts->PortNumber =3D mpi_reply.PortNumber;
 	pfacts->VP_ID =3D mpi_reply.VP_ID;
 	pfacts->VF_ID =3D mpi_reply.VF_ID;
@@ -3316,7 +3316,7 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int =
sleep_flag)
 	}
=20
 	facts =3D &ioc->facts;
-	memset(facts, 0, sizeof(Mpi2IOCFactsReply_t));
+	memset(facts, 0, sizeof(struct mpt2sas_facts));
 	facts->MsgVersion =3D le16_to_cpu(mpi_reply.MsgVersion);
 	facts->HeaderVersion =3D le16_to_cpu(mpi_reply.HeaderVersion);
 	facts->VP_ID =3D mpi_reply.VP_ID;
@@ -4193,7 +4193,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		goto out_free_resources;
=20
 	ioc->pfacts =3D kcalloc(ioc->facts.NumberOfPorts,
-	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
+	    sizeof(struct mpt2sas_port_facts), GFP_KERNEL);
 	if (!ioc->pfacts) {
 		r =3D -ENOMEM;
 		goto out_free_resources;
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 5f748c0..6a62934 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -933,7 +933,7 @@ err:
=20
 static void fsl_spi_cs_control(struct spi_device *spi, bool on)
 {
-	struct device *dev =3D spi->dev.parent;
+	struct device *dev =3D spi->dev.parent->parent;
 	struct mpc8xxx_spi_probe_info *pinfo =3D to_of_pinfo(dev->platform_data);
 	u16 cs =3D spi->chip_select;
 	int gpio =3D pinfo->gpios[cs];
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/=
comedi_fops.c
index 5e78c77..4ad2c0e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -280,7 +280,7 @@ static int do_devconfig_ioctl(struct comedi_device *dev=
,
 	if (ret =3D=3D 0) {
 		if (!try_module_get(dev->driver->module)) {
 			comedi_device_detach(dev);
-			return -ENOSYS;
+			ret =3D -ENOSYS;
 		}
 	}
=20
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index eeadf1b..70585b6 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2327,10 +2327,11 @@ serial8250_do_set_termios(struct uart_port *port, s=
truct ktermios *termios,
 		quot++;
=20
 	if (up->capabilities & UART_CAP_FIFO && up->port.fifosize > 1) {
-		if (baud < 2400)
-			fcr =3D UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_1;
-		else
-			fcr =3D uart_config[up->port.type].fcr;
+		fcr =3D uart_config[up->port.type].fcr;
+		if (baud < 2400) {
+			fcr &=3D ~UART_FCR_TRIGGER_MASK;
+			fcr |=3D UART_FCR_TRIGGER_1;
+		}
 	}
=20
 	/*
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 825937a..482d51e 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1590,54 +1590,72 @@ static struct pci_serial_quirk pci_serial_quirks[] =
__refdata =3D {
 	{
 		.vendor         =3D PCI_VENDOR_ID_INTEL,
 		.device         =3D 0x8811,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
 	{
 		.vendor         =3D PCI_VENDOR_ID_INTEL,
 		.device         =3D 0x8812,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
 	{
 		.vendor         =3D PCI_VENDOR_ID_INTEL,
 		.device         =3D 0x8813,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
 	{
 		.vendor         =3D PCI_VENDOR_ID_INTEL,
 		.device         =3D 0x8814,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
 	{
 		.vendor         =3D 0x10DB,
 		.device         =3D 0x8027,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
 	{
 		.vendor         =3D 0x10DB,
 		.device         =3D 0x8028,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
 	{
 		.vendor         =3D 0x10DB,
 		.device         =3D 0x8029,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
 	{
 		.vendor         =3D 0x10DB,
 		.device         =3D 0x800C,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
 	{
 		.vendor         =3D 0x10DB,
 		.device         =3D 0x800D,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
 		.init		=3D pci_eg20t_init,
 		.setup		=3D pci_default_setup,
 	},
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.=
c
index 7e02c9c..5b3d063 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -368,6 +368,8 @@ static void mxs_auart_settermios(struct uart_port *u,
=20
 	writel(ctrl, u->membase + AUART_LINECTRL);
 	writel(ctrl2, u->membase + AUART_CTRL2);
+
+	uart_update_timeout(u, termios->c_cflag, baud);
 }
=20
 static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_c=
ore.c
index 0406d7f..af5ffb9 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2305,6 +2305,7 @@ void uart_unregister_driver(struct uart_driver *drv)
 	tty_unregister_driver(p);
 	put_tty_driver(p);
 	kfree(drv->state);
+	drv->state =3D NULL;
 	drv->tty_driver =3D NULL;
 }
=20
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 2db0327..554ac90 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -496,11 +496,13 @@ static int wdm_flush(struct file *file, fl_owner_t id=
)
 	struct wdm_device *desc =3D file->private_data;
=20
 	wait_event(desc->wait, !test_bit(WDM_IN_USE, &desc->flags));
-	if (desc->werr < 0)
+
+	/* cannot dereference desc->intf if WDM_DISCONNECTING */
+	if (desc->werr < 0 && !test_bit(WDM_DISCONNECTING, &desc->flags))
 		dev_err(&desc->intf->dev, "Error in flush path: %d\n",
 			desc->werr);
=20
-	return desc->werr;
+	return usb_translate_errors(desc->werr);
 }
=20
 static unsigned int wdm_poll(struct file *file, struct poll_table_struct *=
wait)
@@ -511,7 +513,7 @@ static unsigned int wdm_poll(struct file *file, struct =
poll_table_struct *wait)
=20
 	spin_lock_irqsave(&desc->iuspin, flags);
 	if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
-		mask =3D POLLERR;
+		mask =3D POLLHUP | POLLERR;
 		spin_unlock_irqrestore(&desc->iuspin, flags);
 		goto desc_out;
 	}
@@ -586,10 +588,15 @@ static int wdm_release(struct inode *inode, struct fi=
le *file)
 	mutex_unlock(&desc->wlock);
=20
 	if (!desc->count) {
-		dev_dbg(&desc->intf->dev, "wdm_release: cleanup");
-		kill_urbs(desc);
-		if (!test_bit(WDM_DISCONNECTING, &desc->flags))
+		if (!test_bit(WDM_DISCONNECTING, &desc->flags)) {
+			dev_dbg(&desc->intf->dev, "wdm_release: cleanup");
+			kill_urbs(desc);
 			desc->intf->needs_remote_wakeup =3D 0;
+		} else {
+			/* must avoid dev_printk here as desc->intf is invalid */
+			pr_debug(KBUILD_MODNAME " %s: device gone - cleaning up\n", __func__);
+			cleanup(desc);
+		}
 	}
 	mutex_unlock(&wdm_mutex);
 	return 0;
@@ -805,6 +812,8 @@ static void wdm_disconnect(struct usb_interface *intf)
 	mutex_unlock(&desc->rlock);
 	if (!desc->count)
 		cleanup(desc);
+	else
+		dev_dbg(&intf->dev, "%s: %d open files - postponing cleanup\n", __func__=
, desc->count);
 	mutex_unlock(&wdm_mutex);
 }
=20
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 7abf060..f6ff837 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -295,17 +295,14 @@ static struct async *async_getcompleted(struct dev_st=
ate *ps)
 static struct async *async_getpending(struct dev_state *ps,
 					     void __user *userurb)
 {
-	unsigned long flags;
 	struct async *as;
=20
-	spin_lock_irqsave(&ps->lock, flags);
 	list_for_each_entry(as, &ps->async_pending, asynclist)
 		if (as->userurb =3D=3D userurb) {
 			list_del_init(&as->asynclist);
-			spin_unlock_irqrestore(&ps->lock, flags);
 			return as;
 		}
-	spin_unlock_irqrestore(&ps->lock, flags);
+
 	return NULL;
 }
=20
@@ -360,6 +357,7 @@ static void cancel_bulk_urbs(struct dev_state *ps, unsi=
gned bulk_addr)
 __releases(ps->lock)
 __acquires(ps->lock)
 {
+	struct urb *urb;
 	struct async *as;
=20
 	/* Mark all the pending URBs that match bulk_addr, up to but not
@@ -382,8 +380,11 @@ __acquires(ps->lock)
 	list_for_each_entry(as, &ps->async_pending, asynclist) {
 		if (as->bulk_status =3D=3D AS_UNLINK) {
 			as->bulk_status =3D 0;		/* Only once */
+			urb =3D as->urb;
+			usb_get_urb(urb);
 			spin_unlock(&ps->lock);		/* Allow completions */
-			usb_unlink_urb(as->urb);
+			usb_unlink_urb(urb);
+			usb_put_urb(urb);
 			spin_lock(&ps->lock);
 			goto rescan;
 		}
@@ -434,6 +435,7 @@ static void async_completed(struct urb *urb)
=20
 static void destroy_async(struct dev_state *ps, struct list_head *list)
 {
+	struct urb *urb;
 	struct async *as;
 	unsigned long flags;
=20
@@ -441,10 +443,13 @@ static void destroy_async(struct dev_state *ps, struc=
t list_head *list)
 	while (!list_empty(list)) {
 		as =3D list_entry(list->next, struct async, asynclist);
 		list_del_init(&as->asynclist);
+		urb =3D as->urb;
+		usb_get_urb(urb);
=20
 		/* drop the spinlock so the completion handler can run */
 		spin_unlock_irqrestore(&ps->lock, flags);
-		usb_kill_urb(as->urb);
+		usb_kill_urb(urb);
+		usb_put_urb(urb);
 		spin_lock_irqsave(&ps->lock, flags);
 	}
 	spin_unlock_irqrestore(&ps->lock, flags);
@@ -1350,12 +1355,24 @@ static int proc_submiturb(struct dev_state *ps, voi=
d __user *arg)
=20
 static int proc_unlinkurb(struct dev_state *ps, void __user *arg)
 {
+	struct urb *urb;
 	struct async *as;
+	unsigned long flags;
=20
+	spin_lock_irqsave(&ps->lock, flags);
 	as =3D async_getpending(ps, arg);
-	if (!as)
+	if (!as) {
+		spin_unlock_irqrestore(&ps->lock, flags);
 		return -EINVAL;
-	usb_kill_urb(as->urb);
+	}
+
+	urb =3D as->urb;
+	usb_get_urb(urb);
+	spin_unlock_irqrestore(&ps->lock, flags);
+
+	usb_kill_urb(urb);
+	usb_put_urb(urb);
+
 	return 0;
 }
=20
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2b0a341..52d27ed 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2420,6 +2420,10 @@ int usb_port_suspend(struct usb_device *udev, pm_mes=
sage_t msg)
 				NULL, 0,
 				USB_CTRL_SET_TIMEOUT);
=20
+		/* Try to enable USB2 hardware LPM again */
+		if (udev->usb2_hw_lpm_capable =3D=3D 1)
+			usb_set_usb2_hardware_lpm(udev, 1);
+
 		/* System sleep transitions should never fail */
 		if (!PMSG_IS_AUTO(msg))
 			status =3D 0;
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 4c65eb6..32d3adc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -123,6 +123,9 @@ static const struct usb_device_id usb_quirk_list[] =3D =
{
 	/* Guillemot Webcam Hercules Dualpix Exchange*/
 	{ USB_DEVICE(0x06f8, 0x3005), .driver_info =3D USB_QUIRK_RESET_RESUME },
=20
+	/* Midiman M-Audio Keystation 88es */
+	{ USB_DEVICE(0x0763, 0x0192), .driver_info =3D USB_QUIRK_RESET_RESUME },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info =3D USB_QUIRK_RESET_RESUME },
=20
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index 3888778..45e8479 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -132,20 +132,6 @@ static inline int is_usb_device_driver(struct device_d=
river *drv)
 			for_devices;
 }
=20
-/* translate USB error codes to codes user space understands */
-static inline int usb_translate_errors(int error_code)
-{
-	switch (error_code) {
-	case 0:
-	case -ENOMEM:
-	case -ENODEV:
-		return error_code;
-	default:
-		return -EIO;
-	}
-}
-
-
 /* for labeling diagnostics */
 extern const char *usbcore_name;
=20
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc=
_core.c
index 8e3e509..01de16e 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -736,6 +736,8 @@ static void fsl_queue_td(struct fsl_ep *ep, struct fsl_=
req *req)
 		lastreq =3D list_entry(ep->queue.prev, struct fsl_req, queue);
 		lastreq->tail->next_td_ptr =3D
 			cpu_to_hc32(req->head->td_dma & DTD_ADDR_MASK);
+		/* Ensure dTD's next dtd pointer to be updated */
+		wmb();
 		/* Read prime bit, if 1 goto done */
 		if (fsl_readl(&dr_regs->endpointprime) & bitmask)
 			return;
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 971d312..ee85e81 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -365,7 +365,9 @@ static bool usb_is_intel_switchable_ehci(struct pci_dev=
 *pdev)
 {
 	return pdev->class =3D=3D PCI_CLASS_SERIAL_USB_EHCI &&
 		pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
-		pdev->device =3D=3D 0x1E26;
+		(pdev->device =3D=3D 0x1E26 ||
+		 pdev->device =3D=3D 0x8C2D ||
+		 pdev->device =3D=3D 0x8C26);
 }
=20
 static void ehci_enable_xhci_companion(void)
diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 95a9fec..a60c7aa 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -199,7 +199,7 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 /*------------------------------------------------------------------------=
-*/
=20
 static int __devinit
-ohci_at91_start (struct usb_hcd *hcd)
+ohci_at91_reset (struct usb_hcd *hcd)
 {
 	struct at91_usbh_data	*board =3D hcd->self.controller->platform_data;
 	struct ohci_hcd		*ohci =3D hcd_to_ohci (hcd);
@@ -209,6 +209,14 @@ ohci_at91_start (struct usb_hcd *hcd)
 		return ret;
=20
 	ohci->num_ports =3D board->ports;
+	return 0;
+}
+
+static int __devinit
+ohci_at91_start (struct usb_hcd *hcd)
+{
+	struct ohci_hcd		*ohci =3D hcd_to_ohci (hcd);
+	int			ret;
=20
 	if ((ret =3D ohci_run(ohci)) < 0) {
 		err("can't start %s", hcd->self.bus_name);
@@ -390,6 +398,7 @@ static const struct hc_driver ohci_at91_hc_driver =3D {
 	/*
 	 * basic lifecycle operations
 	 */
+	.reset =3D		ohci_at91_reset,
 	.start =3D		ohci_at91_start,
 	.stop =3D			ohci_stop,
 	.shutdown =3D		ohci_shutdown,
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 2afff88..833b3c6 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -9,6 +9,7 @@
  */
=20
 #include <linux/types.h>
+#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -712,12 +713,28 @@ static int handshake(void __iomem *ptr, u32 mask, u32=
 done,
 	return -ETIMEDOUT;
 }
=20
-bool usb_is_intel_switchable_xhci(struct pci_dev *pdev)
+#define PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI	0x8C31
+
+bool usb_is_intel_ppt_switchable_xhci(struct pci_dev *pdev)
 {
 	return pdev->class =3D=3D PCI_CLASS_SERIAL_USB_XHCI &&
 		pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
 		pdev->device =3D=3D PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI;
 }
+
+/* The Intel Lynx Point chipset also has switchable ports. */
+bool usb_is_intel_lpt_switchable_xhci(struct pci_dev *pdev)
+{
+	return pdev->class =3D=3D PCI_CLASS_SERIAL_USB_XHCI &&
+		pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
+		pdev->device =3D=3D PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI;
+}
+
+bool usb_is_intel_switchable_xhci(struct pci_dev *pdev)
+{
+	return usb_is_intel_ppt_switchable_xhci(pdev) ||
+		usb_is_intel_lpt_switchable_xhci(pdev);
+}
 EXPORT_SYMBOL_GPL(usb_is_intel_switchable_xhci);
=20
 /*
@@ -742,6 +759,19 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 {
 	u32		ports_available;
=20
+	/* Don't switchover the ports if the user hasn't compiled the xHCI
+	 * driver.  Otherwise they will see "dead" USB ports that don't power
+	 * the devices.
+	 */
+	if (!IS_ENABLED(CONFIG_USB_XHCI_HCD)) {
+		dev_warn(&xhci_pdev->dev,
+				"CONFIG_USB_XHCI_HCD is turned off, "
+				"defaulting to EHCI.\n");
+		dev_warn(&xhci_pdev->dev,
+				"USB 3.0 devices will work at USB 2.0 speeds.\n");
+		return;
+	}
+
 	ports_available =3D 0xffffffff;
 	/* Write USB3_PSSEN, the USB 3.0 Port SuperSpeed Enable
 	 * Register, to turn on SuperSpeed terminations for all
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 01c3800..4232e868 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1699,6 +1699,14 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 {
 	struct pci_dev	*pdev =3D to_pci_dev(xhci_to_hcd(xhci)->self.controller);
 	struct dev_info	*dev_info, *next;
+	struct list_head *tt_list_head;
+	struct list_head *tt;
+	struct list_head *endpoints;
+	struct list_head *ep, *q;
+	struct xhci_tt_bw_info *tt_info;
+	struct xhci_interval_bw_table *bwt;
+	struct xhci_virt_ep *virt_ep;
+
 	unsigned long	flags;
 	int size;
 	int i;
@@ -1715,6 +1723,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->event_ring =3D NULL;
 	xhci_dbg(xhci, "Freed event ring\n");
=20
+	xhci->cmd_ring_reserved_trbs =3D 0;
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring =3D NULL;
@@ -1757,8 +1766,26 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
=20
+	bwt =3D &xhci->rh_bw->bw_table;
+	for (i =3D 0; i < XHCI_MAX_INTERVAL; i++) {
+		endpoints =3D &bwt->interval_bw[i].endpoints;
+		list_for_each_safe(ep, q, endpoints) {
+			virt_ep =3D list_entry(ep, struct xhci_virt_ep, bw_endpoint_list);
+			list_del(&virt_ep->bw_endpoint_list);
+			kfree(virt_ep);
+		}
+	}
+
+	tt_list_head =3D &xhci->rh_bw->tts;
+	list_for_each_safe(tt, q, tt_list_head) {
+		tt_info =3D list_entry(tt, struct xhci_tt_bw_info, tt_list);
+		list_del(tt);
+		kfree(tt_info);
+	}
+
 	xhci->num_usb2_ports =3D 0;
 	xhci->num_usb3_ports =3D 0;
+	xhci->num_active_eps =3D 0;
 	kfree(xhci->usb2_ports);
 	kfree(xhci->usb3_ports);
 	kfree(xhci->port_array);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 211296a..daf5754 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -72,6 +72,7 @@ static void xhci_pci_quirks(struct device *dev, struct xh=
ci_hcd *xhci)
 		xhci_dbg(xhci, "QUIRK: Fresco Logic revision %u "
 				"has broken MSI implementation\n",
 				pdev->revision);
+		xhci->quirks |=3D XHCI_TRUST_TX_LENGTH;
 	}
=20
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_NEC)
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 43b3447..fb0981e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1735,8 +1735,12 @@ static int process_isoc_td(struct xhci_hcd *xhci, st=
ruct xhci_td *td,
 	/* handle completion code */
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		frame->status =3D 0;
-		break;
+		if (TRB_LEN(le32_to_cpu(event->transfer_len)) =3D=3D 0) {
+			frame->status =3D 0;
+			break;
+		}
+		if ((xhci->quirks & XHCI_TRUST_TX_LENGTH))
+			trb_comp_code =3D COMP_SHORT_TX;
 	case COMP_SHORT_TX:
 		frame->status =3D td->urb->transfer_flags & URB_SHORT_NOT_OK ?
 				-EREMOTEIO : 0;
@@ -1752,6 +1756,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, str=
uct xhci_td *td,
 		break;
 	case COMP_DEV_ERR:
 	case COMP_STALL:
+	case COMP_TX_ERR:
 		frame->status =3D -EPROTO;
 		skip_td =3D true;
 		break;
@@ -1832,13 +1837,16 @@ static int process_bulk_intr_td(struct xhci_hcd *xh=
ci, struct xhci_td *td,
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
 		/* Double check that the HW transferred everything. */
-		if (event_trb !=3D td->last_trb) {
+		if (event_trb !=3D td->last_trb ||
+				TRB_LEN(le32_to_cpu(event->transfer_len)) !=3D 0) {
 			xhci_warn(xhci, "WARN Successful completion "
 					"on short TX\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 				*status =3D -EREMOTEIO;
 			else
 				*status =3D 0;
+			if ((xhci->quirks & XHCI_TRUST_TX_LENGTH))
+				trb_comp_code =3D COMP_SHORT_TX;
 		} else {
 			*status =3D 0;
 		}
@@ -1977,6 +1985,13 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	 * transfer type
 	 */
 	case COMP_SUCCESS:
+		if (TRB_LEN(le32_to_cpu(event->transfer_len)) =3D=3D 0)
+			break;
+		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
+			trb_comp_code =3D COMP_SHORT_TX;
+		else
+			xhci_warn(xhci, "WARN Successful completion on short TX: "
+					"needs XHCI_TRUST_TX_LENGTH quirk?\n");
 	case COMP_SHORT_TX:
 		break;
 	case COMP_STOP:
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 4850c4d..363b141 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1466,6 +1466,7 @@ struct xhci_hcd {
 #define XHCI_RESET_ON_RESUME	(1 << 7)
 #define	XHCI_SW_BW_CHECKING	(1 << 8)
 #define XHCI_AMD_0x96_HOST	(1 << 9)
+#define XHCI_TRUST_TX_LENGTH	(1 << 10)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index bd6d008..b9ac9a3 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -1025,7 +1025,10 @@ test_ctrl_queue(struct usbtest_dev *dev, struct usbt=
est_param *param)
 		case 13:	/* short read, resembling case 10 */
 			req.wValue =3D cpu_to_le16((USB_DT_CONFIG << 8) | 0);
 			/* last data packet "should" be DATA1, not DATA0 */
-			len =3D 1024 - udev->descriptor.bMaxPacketSize0;
+			if (udev->speed =3D=3D USB_SPEED_SUPER)
+				len =3D 1024 - 512;
+			else
+				len =3D 1024 - udev->descriptor.bMaxPacketSize0;
 			expected =3D -EREMOTEIO;
 			break;
 		case 14:	/* short read; try to fill the last packet */
@@ -1384,11 +1387,15 @@ static int test_halt(struct usbtest_dev *tdev, int =
ep, struct urb *urb)
=20
 static int halt_simple(struct usbtest_dev *dev)
 {
-	int		ep;
-	int		retval =3D 0;
-	struct urb	*urb;
+	int			ep;
+	int			retval =3D 0;
+	struct urb		*urb;
+	struct usb_device	*udev =3D testdev_to_usbdev(dev);
=20
-	urb =3D simple_alloc_urb(testdev_to_usbdev(dev), 0, 512);
+	if (udev->speed =3D=3D USB_SPEED_SUPER)
+		urb =3D simple_alloc_urb(udev, 0, 1024);
+	else
+		urb =3D simple_alloc_urb(udev, 0, 512);
 	if (urb =3D=3D NULL)
 		return -ENOMEM;
=20
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c4cf3f3..450bdfe 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -809,6 +809,7 @@ static struct usb_device_id id_table_combined [] =3D {
 		.driver_info =3D (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
 	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
+	{ USB_DEVICE(PI_VID, PI_E861_PID) },
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info =3D (kernel_ulong_t)&ftdi_jtag_quirk },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index c6dd18e..219b199 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -785,6 +785,14 @@
 #define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radio=
s using FT232RL */
 #define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
=20
+
+/*
+ * Physik Instrumente
+ * http://www.physikinstrumente.com/en/products/
+ */
+#define PI_VID              0x1a72  /* Vendor ID */
+#define PI_E861_PID         0x1008  /* E-861 piezo controller USB connecti=
on */
+
 /*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
  * http://winglucofacts.com/cables/
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_=
usb_3410_5052.c
index 21c82b0..2856474 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -165,7 +165,7 @@ static unsigned int product_5052_count;
 /* the array dimension is the number of default entries plus */
 /* TI_EXTRA_VID_PID_COUNT user defined entries plus 1 terminating */
 /* null entry */
-static struct usb_device_id ti_id_table_3410[14+TI_EXTRA_VID_PID_COUNT+1] =
=3D {
+static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] =
=3D {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -180,6 +180,7 @@ static struct usb_device_id ti_id_table_3410[14+TI_EXTR=
A_VID_PID_COUNT+1] =3D {
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 };
=20
 static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] =
=3D {
@@ -189,7 +190,7 @@ static struct usb_device_id ti_id_table_5052[5+TI_EXTRA=
_VID_PID_COUNT+1] =3D {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
 };
=20
-static struct usb_device_id ti_id_table_combined[18+2*TI_EXTRA_VID_PID_COU=
NT+1] =3D {
+static struct usb_device_id ti_id_table_combined[19+2*TI_EXTRA_VID_PID_COU=
NT+1] =3D {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -208,6 +209,7 @@ static struct usb_device_id ti_id_table_combined[18+2*T=
I_EXTRA_VID_PID_COUNT+1]
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 	{ }
 };
=20
diff --git a/drivers/usb/serial/ti_usb_3410_5052.h b/drivers/usb/serial/ti_=
usb_3410_5052.h
index f140f1b..b353e7e 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -37,6 +37,7 @@
 #define TI_5152_BOOT_PRODUCT_ID		0x5152	/* no EEPROM, no firmware */
 #define TI_5052_EEPROM_PRODUCT_ID	0x505A	/* EEPROM, no firmware */
 #define TI_5052_FIRMWARE_PRODUCT_ID	0x505F	/* firmware is running */
+#define FRI2_PRODUCT_ID			0x5053  /* Fish River Island II */
=20
 /* Multi-Tech vendor and product ids */
 #define MTS_VENDOR_ID			0x06E0
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusu=
al_devs.h
index 24caba7..591f57f 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1885,6 +1885,13 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x0201,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
=20
+/* Reported by Jesse Feddema <jdfeddema@gmail.com> */
+UNUSUAL_DEV(  0x177f, 0x0400, 0x0000, 0x0000,
+		"Yarvik",
+		"PMP400",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
+
 /* Reported by Hans de Goede <hdegoede@redhat.com>
  * These Appotech controllers are found in Picture Frames, they provide a
  * (buggy) emulation of a cdrom drive which contains the windows software
diff --git a/drivers/video/omap2/dss/venc.c b/drivers/video/omap2/dss/venc.=
c
index 7533458..7152b53 100644
--- a/drivers/video/omap2/dss/venc.c
+++ b/drivers/video/omap2/dss/venc.c
@@ -679,6 +679,11 @@ void venc_dump_regs(struct seq_file *s)
 {
 #define DUMPREG(r) seq_printf(s, "%-35s %08x\n", #r, venc_read_reg(r))
=20
+	if (cpu_is_omap44xx()) {
+		seq_printf(s, "VENC currently disabled on OMAP44xx\n");
+		return;
+	}
+
 	if (venc_runtime_get())
 		return;
=20
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 6e075cd..fec1204 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -600,7 +600,7 @@ static void disable_pirq(struct irq_data *data)
 	disable_dynirq(data);
 }
=20
-static int find_irq_by_gsi(unsigned gsi)
+int xen_irq_from_gsi(unsigned gsi)
 {
 	struct irq_info *info;
=20
@@ -614,6 +614,7 @@ static int find_irq_by_gsi(unsigned gsi)
=20
 	return -1;
 }
+EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
=20
 /*
  * Do not make any assumptions regarding the relationship between the
@@ -633,7 +634,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
=20
 	mutex_lock(&irq_mapping_update_lock);
=20
-	irq =3D find_irq_by_gsi(gsi);
+	irq =3D xen_irq_from_gsi(gsi);
 	if (irq !=3D -1) {
 		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
 		       irq, gsi);
diff --git a/fs/aio.c b/fs/aio.c
index b9d64d8..3b65ee7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1477,6 +1477,10 @@ static ssize_t aio_setup_vectored_rw(int type, struc=
t kiocb *kiocb, bool compat)
 	if (ret < 0)
 		goto out;
=20
+	ret =3D rw_verify_area(type, kiocb->ki_filp, &kiocb->ki_pos, ret);
+	if (ret < 0)
+		goto out;
+
 	kiocb->ki_nr_segs =3D kiocb->ki_nbytes;
 	kiocb->ki_cur_seg =3D 0;
 	/* ki_nbytes/left now reflect bytes instead of segs */
@@ -1488,11 +1492,17 @@ out:
 	return ret;
 }
=20
-static ssize_t aio_setup_single_vector(struct kiocb *kiocb)
+static ssize_t aio_setup_single_vector(int type, struct file * file, struc=
t kiocb *kiocb)
 {
+	int bytes;
+
+	bytes =3D rw_verify_area(type, file, &kiocb->ki_pos, kiocb->ki_left);
+	if (bytes < 0)
+		return bytes;
+
 	kiocb->ki_iovec =3D &kiocb->ki_inline_vec;
 	kiocb->ki_iovec->iov_base =3D kiocb->ki_buf;
-	kiocb->ki_iovec->iov_len =3D kiocb->ki_left;
+	kiocb->ki_iovec->iov_len =3D bytes;
 	kiocb->ki_nr_segs =3D 1;
 	kiocb->ki_cur_seg =3D 0;
 	return 0;
@@ -1517,10 +1527,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, b=
ool compat)
 		if (unlikely(!access_ok(VERIFY_WRITE, kiocb->ki_buf,
 			kiocb->ki_left)))
 			break;
-		ret =3D security_file_permission(file, MAY_READ);
-		if (unlikely(ret))
-			break;
-		ret =3D aio_setup_single_vector(kiocb);
+		ret =3D aio_setup_single_vector(READ, file, kiocb);
 		if (ret)
 			break;
 		ret =3D -EINVAL;
@@ -1535,10 +1542,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, b=
ool compat)
 		if (unlikely(!access_ok(VERIFY_READ, kiocb->ki_buf,
 			kiocb->ki_left)))
 			break;
-		ret =3D security_file_permission(file, MAY_WRITE);
-		if (unlikely(ret))
-			break;
-		ret =3D aio_setup_single_vector(kiocb);
+		ret =3D aio_setup_single_vector(WRITE, file, kiocb);
 		if (ret)
 			break;
 		ret =3D -EINVAL;
@@ -1549,9 +1553,6 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bo=
ol compat)
 		ret =3D -EBADF;
 		if (unlikely(!(file->f_mode & FMODE_READ)))
 			break;
-		ret =3D security_file_permission(file, MAY_READ);
-		if (unlikely(ret))
-			break;
 		ret =3D aio_setup_vectored_rw(READ, kiocb, compat);
 		if (ret)
 			break;
@@ -1563,9 +1564,6 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bo=
ol compat)
 		ret =3D -EBADF;
 		if (unlikely(!(file->f_mode & FMODE_WRITE)))
 			break;
-		ret =3D security_file_permission(file, MAY_WRITE);
-		if (unlikely(ret))
-			break;
 		ret =3D aio_setup_vectored_rw(WRITE, kiocb, compat);
 		if (ret)
 			break;
diff --git a/fs/bio.c b/fs/bio.c
index b1fe82c..4fc4dbb 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -507,11 +507,12 @@ int bio_get_nr_vecs(struct block_device *bdev)
 	struct request_queue *q =3D bdev_get_queue(bdev);
 	int nr_pages;
=20
-	nr_pages =3D ((queue_max_sectors(q) << 9) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (nr_pages > queue_max_segments(q))
-		nr_pages =3D queue_max_segments(q);
+	nr_pages =3D min_t(unsigned,
+		     queue_max_segments(q),
+		     queue_max_sectors(q) / (PAGE_SIZE >> 9) + 1);
+
+	return min_t(unsigned, nr_pages, BIO_MAX_PAGES);
=20
-	return nr_pages;
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
=20
diff --git a/fs/block_dev.c b/fs/block_dev.c
index abe9b48..9b98987 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -68,7 +68,7 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 	spin_unlock(&dst->wb.list_lock);
 }
=20
-static sector_t max_block(struct block_device *bdev)
+sector_t blkdev_max_block(struct block_device *bdev)
 {
 	sector_t retval =3D ~((sector_t)0);
 	loff_t sz =3D i_size_read(bdev->bd_inode);
@@ -139,7 +139,7 @@ static int
 blkdev_get_block(struct inode *inode, sector_t iblock,
 		struct buffer_head *bh, int create)
 {
-	if (iblock >=3D max_block(I_BDEV(inode))) {
+	if (iblock >=3D blkdev_max_block(I_BDEV(inode))) {
 		if (create)
 			return -EIO;
=20
@@ -161,7 +161,7 @@ static int
 blkdev_get_blocks(struct inode *inode, sector_t iblock,
 		struct buffer_head *bh, int create)
 {
-	sector_t end_block =3D max_block(I_BDEV(inode));
+	sector_t end_block =3D blkdev_max_block(I_BDEV(inode));
 	unsigned long max_blocks =3D bh->b_size >> inode->i_blkbits;
=20
 	if ((iblock + max_blocks) > end_block) {
diff --git a/fs/buffer.c b/fs/buffer.c
index 19d8eb7..c807931 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -971,6 +971,7 @@ init_page_buffers(struct page *page, struct block_devic=
e *bdev,
 	struct buffer_head *head =3D page_buffers(page);
 	struct buffer_head *bh =3D head;
 	int uptodate =3D PageUptodate(page);
+	sector_t end_block =3D blkdev_max_block(I_BDEV(bdev->bd_inode));
=20
 	do {
 		if (!buffer_mapped(bh)) {
@@ -979,7 +980,8 @@ init_page_buffers(struct page *page, struct block_devic=
e *bdev,
 			bh->b_blocknr =3D block;
 			if (uptodate)
 				set_buffer_uptodate(bh);
-			set_buffer_mapped(bh);
+			if (block < end_block)
+				set_buffer_mapped(bh);
 		}
 		block++;
 		bh =3D bh->b_this_page;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b4c2c99..b1451af 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -703,7 +703,7 @@ static loff_t cifs_llseek(struct file *file, loff_t off=
set, int origin)
 	 * origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D> we must revalida=
te
 	 * the cached file length
 	 */
-	if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
+	if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR) {
 		int rc;
 		struct inode *inode =3D file->f_path.dentry->d_inode;
=20
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 5c866e0..adae962 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -525,8 +525,12 @@ got:
 	if (IS_DIRSYNC(inode))
 		handle->h_sync =3D 1;
 	if (insert_inode_locked(inode) < 0) {
-		err =3D -EINVAL;
-		goto fail_drop;
+		/*
+		 * Likely a bitmap corruption causing inode to be allocated
+		 * twice.
+		 */
+		err =3D -EIO;
+		goto fail;
 	}
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation =3D sbi->s_next_generation++;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00beb4f..8fb6844 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -885,8 +885,12 @@ got:
 	if (IS_DIRSYNC(inode))
 		ext4_handle_sync(handle);
 	if (insert_inode_locked(inode) < 0) {
-		err =3D -EINVAL;
-		goto fail_drop;
+		/*
+		 * Likely a bitmap corruption causing inode to be allocated
+		 * twice.
+		 */
+		err =3D -EIO;
+		goto fail;
 	}
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation =3D sbi->s_next_generation++;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bab7c58..03d9b90 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3526,16 +3526,16 @@ out:
 	return ret;
 }
=20
-static void nfs4_write_cached_acl(struct inode *inode, const char *buf, si=
ze_t acl_len)
+static void nfs4_write_cached_acl(struct inode *inode, struct page **pages=
, size_t pgbase, size_t acl_len)
 {
 	struct nfs4_cached_acl *acl;
=20
-	if (buf && acl_len <=3D PAGE_SIZE) {
+	if (pages && acl_len <=3D PAGE_SIZE) {
 		acl =3D kmalloc(sizeof(*acl) + acl_len, GFP_KERNEL);
 		if (acl =3D=3D NULL)
 			goto out;
 		acl->cached =3D 1;
-		memcpy(acl->data, buf, acl_len);
+		_copy_from_pages(acl->data, pages, pgbase, acl_len);
 	} else {
 		acl =3D kmalloc(sizeof(*acl), GFP_KERNEL);
 		if (acl =3D=3D NULL)
@@ -3568,7 +3568,6 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *=
inode, void *buf, size_t bu
 	struct nfs_getaclres res =3D {
 		.acl_len =3D buflen,
 	};
-	void *resp_buf;
 	struct rpc_message msg =3D {
 		.rpc_proc =3D &nfs4_procedures[NFSPROC4_CLNT_GETACL],
 		.rpc_argp =3D &args,
@@ -3582,26 +3581,29 @@ static ssize_t __nfs4_get_acl_uncached(struct inode=
 *inode, void *buf, size_t bu
 	if (npages =3D=3D 0)
 		npages =3D 1;
=20
+	/* Add an extra page to handle the bitmap returned */
+	npages++;
+
 	for (i =3D 0; i < npages; i++) {
 		pages[i] =3D alloc_page(GFP_KERNEL);
 		if (!pages[i])
 			goto out_free;
 	}
-	if (npages > 1) {
-		/* for decoding across pages */
-		res.acl_scratch =3D alloc_page(GFP_KERNEL);
-		if (!res.acl_scratch)
-			goto out_free;
-	}
+
+	/* for decoding across pages */
+	res.acl_scratch =3D alloc_page(GFP_KERNEL);
+	if (!res.acl_scratch)
+		goto out_free;
+
 	args.acl_len =3D npages * PAGE_SIZE;
 	args.acl_pgbase =3D 0;
+
 	/* Let decode_getfacl know not to fail if the ACL data is larger than
 	 * the page we send as a guess */
 	if (buf =3D=3D NULL)
 		res.acl_flags |=3D NFS4_ACL_LEN_REQUEST;
-	resp_buf =3D page_address(pages[0]);
=20
-	dprintk("%s  buf %p buflen %ld npages %d args.acl_len %ld\n",
+	dprintk("%s  buf %p buflen %zu npages %d args.acl_len %zu\n",
 		__func__, buf, buflen, npages, args.acl_len);
 	ret =3D nfs4_call_sync(NFS_SERVER(inode)->client, NFS_SERVER(inode),
 			     &msg, &args.seq_args, &res.seq_res, 0);
@@ -3610,9 +3612,9 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *=
inode, void *buf, size_t bu
=20
 	acl_len =3D res.acl_len - res.acl_data_offset;
 	if (acl_len > args.acl_len)
-		nfs4_write_cached_acl(inode, NULL, acl_len);
+		nfs4_write_cached_acl(inode, NULL, 0, acl_len);
 	else
-		nfs4_write_cached_acl(inode, resp_buf + res.acl_data_offset,
+		nfs4_write_cached_acl(inode, pages, res.acl_data_offset,
 				      acl_len);
 	if (buf) {
 		ret =3D -ERANGE;
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 68adab4..bdd5bdc 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4965,11 +4965,19 @@ static int decode_getacl(struct xdr_stream *xdr, st=
ruct rpc_rqst *req,
 		 bitmap[3] =3D {0};
 	struct kvec *iov =3D req->rq_rcv_buf.head;
 	int status;
+	size_t page_len =3D xdr->buf->page_len;
=20
 	res->acl_len =3D 0;
 	if ((status =3D decode_op_hdr(xdr, OP_GETATTR)) !=3D 0)
 		goto out;
+
 	bm_p =3D xdr->p;
+	res->acl_data_offset =3D be32_to_cpup(bm_p) + 2;
+	res->acl_data_offset <<=3D 2;
+	/* Check if the acl data starts beyond the allocated buffer */
+	if (res->acl_data_offset > page_len)
+		return -ERANGE;
+
 	if ((status =3D decode_attr_bitmap(xdr, bitmap)) !=3D 0)
 		goto out;
 	if ((status =3D decode_attr_length(xdr, &attrlen, &savep)) !=3D 0)
@@ -4979,28 +4987,24 @@ static int decode_getacl(struct xdr_stream *xdr, st=
ruct rpc_rqst *req,
 		return -EIO;
 	if (likely(bitmap[0] & FATTR4_WORD0_ACL)) {
 		size_t hdrlen;
-		u32 recvd;
=20
 		/* The bitmap (xdr len + bitmaps) and the attr xdr len words
 		 * are stored with the acl data to handle the problem of
 		 * variable length bitmaps.*/
 		xdr->p =3D bm_p;
-		res->acl_data_offset =3D be32_to_cpup(bm_p) + 2;
-		res->acl_data_offset <<=3D 2;
=20
 		/* We ignore &savep and don't do consistency checks on
 		 * the attr length.  Let userspace figure it out.... */
 		hdrlen =3D (u8 *)xdr->p - (u8 *)iov->iov_base;
 		attrlen +=3D res->acl_data_offset;
-		recvd =3D req->rq_rcv_buf.len - hdrlen;
-		if (attrlen > recvd) {
+		if (attrlen > page_len) {
 			if (res->acl_flags & NFS4_ACL_LEN_REQUEST) {
 				/* getxattr interface called with a NULL buf */
 				res->acl_len =3D attrlen;
 				goto out;
 			}
-			dprintk("NFS: acl reply: attrlen %u > recvd %u\n",
-					attrlen, recvd);
+			dprintk("NFS: acl reply: attrlen %u > page_len %zu\n",
+					attrlen, page_len);
 			return -EINVAL;
 		}
 		xdr_read_pages(xdr, attrlen);
diff --git a/fs/super.c b/fs/super.c
index afd0f1a..2a698f6 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1166,6 +1166,8 @@ int freeze_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_frozen =3D SB_UNFROZEN;
+			smp_wmb();
+			wake_up(&sb->s_wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
 		}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11f1951..43d36b7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2094,6 +2094,7 @@ extern void unregister_blkdev(unsigned int, const cha=
r *);
 extern struct block_device *bdget(dev_t);
 extern struct block_device *bdgrab(struct block_device *bdev);
 extern void bd_set_size(struct block_device *, loff_t size);
+extern sector_t blkdev_max_block(struct block_device *bdev);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
 extern void invalidate_bdev(struct block_device *);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c6f7f6a..4eec461 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -222,12 +222,6 @@ static inline void part_pack_uuid(const u8 *uuid_str, =
u8 *to)
 	}
 }
=20
-static inline char *part_unpack_uuid(const u8 *uuid, char *out)
-{
-	sprintf(out, "%pU", uuid);
-	return out;
-}
-
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 35410ef..6136821 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -744,6 +744,13 @@ static inline bool kvm_vcpu_is_bsp(struct kvm_vcpu *vc=
pu)
 {
 	return vcpu->kvm->bsp_vcpu_id =3D=3D vcpu->vcpu_id;
 }
+
+bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu);
+
+#else
+
+static inline bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu) { return tru=
e; }
+
 #endif
=20
 #ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index a3ac9c4..deb6282 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -303,6 +303,7 @@ struct mmc_host {
=20
 	unsigned int		sdio_irqs;
 	struct task_struct	*sdio_irq_thread;
+	bool			sdio_irq_pending;
 	atomic_t		sdio_irq_thread_abort;
=20
 	mmc_pm_flag_t		pm_flags;	/* requested pm features */
@@ -356,6 +357,7 @@ extern int mmc_cache_ctrl(struct mmc_host *, u8);
 static inline void mmc_signal_sdio_irq(struct mmc_host *host)
 {
 	host->ops->enable_sdio_irq(host, 0);
+	host->sdio_irq_pending =3D true;
 	wake_up_process(host->sdio_irq_thread);
 }
=20
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 7503352..4269c3f 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1599,6 +1599,19 @@ usb_maxpacket(struct usb_device *udev, int pipe, int=
 is_out)
=20
 /* -----------------------------------------------------------------------=
 */
=20
+/* translate USB error codes to codes user space understands */
+static inline int usb_translate_errors(int error_code)
+{
+	switch (error_code) {
+	case 0:
+	case -ENOMEM:
+	case -ENODEV:
+		return error_code;
+	default:
+		return -EIO;
+	}
+}
+
 /* Events from the usb core */
 #define USB_DEVICE_ADD		0x0001
 #define USB_DEVICE_REMOVE	0x0002
diff --git a/include/xen/events.h b/include/xen/events.h
index d287997..8f3d622 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -96,6 +96,9 @@ int xen_irq_from_pirq(unsigned pirq);
 /* Return the pirq allocated to the irq. */
 int xen_pirq_from_irq(unsigned irq);
=20
+/* Return the irq allocated to the gsi */
+int xen_irq_from_gsi(unsigned gsi);
+
 /* Determine whether to ignore this IRQ if it is passed to a guest. */
 int xen_test_irq_shared(int irq);
=20
diff --git a/init/do_mounts.c b/init/do_mounts.c
index db6e5ee..d6c229f 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -470,7 +470,7 @@ void __init change_floppy(char *fmt, ...)
 void __init mount_root(void)
 {
 #ifdef CONFIG_ROOT_NFS
-	if (MAJOR(ROOT_DEV) =3D=3D UNNAMED_MAJOR) {
+	if (ROOT_DEV =3D=3D Root_NFS) {
 		if (mount_nfs_root())
 			return;
=20
diff --git a/init/main.c b/init/main.c
index 217ed23..cb08fea2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -563,9 +563,6 @@ asmlinkage void __init start_kernel(void)
 	early_boot_irqs_disabled =3D false;
 	local_irq_enable();
=20
-	/* Interrupts are enabled now so all GFP allocations are safe. */
-	gfp_allowed_mask =3D __GFP_BITS_MASK;
-
 	kmem_cache_init_late();
=20
 	/*
@@ -798,6 +795,10 @@ static int __init kernel_init(void * unused)
 	 * Wait until kthreadd is all set-up.
 	 */
 	wait_for_completion(&kthreadd_done);
+
+	/* Now the scheduler is fully set up and can do blocking allocations */
+	gfp_allowed_mask =3D __GFP_BITS_MASK;
+
 	/*
 	 * init can allocate pages on any node
 	 */
diff --git a/kernel/compat.c b/kernel/compat.c
index f346ced..a6d0649 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -320,25 +320,54 @@ asmlinkage long compat_sys_sigpending(compat_old_sigs=
et_t __user *set)
=20
 #ifdef __ARCH_WANT_SYS_SIGPROCMASK
=20
-asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user=
 *set,
-		compat_old_sigset_t __user *oset)
+/*
+ * sys_sigprocmask SIG_SETMASK sets the first (compat) word of the
+ * blocked set of signals to the supplied signal set
+ */
+static inline void compat_sig_setmask(sigset_t *blocked, compat_sigset_wor=
d set)
 {
-	old_sigset_t s;
-	long ret;
-	mm_segment_t old_fs;
+	memcpy(blocked->sig, &set, sizeof(set));
+}
=20
-	if (set && get_user(s, set))
-		return -EFAULT;
-	old_fs =3D get_fs();
-	set_fs(KERNEL_DS);
-	ret =3D sys_sigprocmask(how,
-			      set ? (old_sigset_t __user *) &s : NULL,
-			      oset ? (old_sigset_t __user *) &s : NULL);
-	set_fs(old_fs);
-	if (ret =3D=3D 0)
-		if (oset)
-			ret =3D put_user(s, oset);
-	return ret;
+asmlinkage long compat_sys_sigprocmask(int how,
+				       compat_old_sigset_t __user *nset,
+				       compat_old_sigset_t __user *oset)
+{
+	old_sigset_t old_set, new_set;
+	sigset_t new_blocked;
+
+	old_set =3D current->blocked.sig[0];
+
+	if (nset) {
+		if (get_user(new_set, nset))
+			return -EFAULT;
+		new_set &=3D ~(sigmask(SIGKILL) | sigmask(SIGSTOP));
+
+		new_blocked =3D current->blocked;
+
+		switch (how) {
+		case SIG_BLOCK:
+			sigaddsetmask(&new_blocked, new_set);
+			break;
+		case SIG_UNBLOCK:
+			sigdelsetmask(&new_blocked, new_set);
+			break;
+		case SIG_SETMASK:
+			compat_sig_setmask(&new_blocked, new_set);
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		set_current_blocked(&new_blocked);
+	}
+
+	if (oset) {
+		if (put_user(old_set, oset))
+			return -EFAULT;
+	}
+
+	return 0;
 }
=20
 #endif
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bb425b1..7947e16 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1215,8 +1215,13 @@ static void worker_enter_idle(struct worker *worker)
 	} else
 		wake_up_all(&gcwq->trustee_wait);
=20
-	/* sanity check nr_running */
-	WARN_ON_ONCE(gcwq->nr_workers =3D=3D gcwq->nr_idle &&
+	/*
+	 * Sanity check nr_running.  Because trustee releases gcwq->lock
+	 * between setting %WORKER_ROGUE and zapping nr_running, the
+	 * warning may trigger spuriously.  Check iff trustee is idle.
+	 */
+	WARN_ON_ONCE(gcwq->trustee_state =3D=3D TRUSTEE_DONE &&
+		     gcwq->nr_workers =3D=3D gcwq->nr_idle &&
 		     atomic_read(get_gcwq_nr_running(gcwq->cpu)));
 }
=20
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 778554f..c8425b1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4549,6 +4549,12 @@ static void mem_cgroup_usage_unregister_event(struct=
 cgroup *cgrp,
 swap_buffers:
 	/* Swap primary and spare array */
 	thresholds->spare =3D thresholds->primary;
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare =3D NULL;
+	}
+
 	rcu_assign_pointer(thresholds->primary, new);
=20
 	/* To be sure that nobody uses thresholds */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b26aae2..7c80c3f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -607,27 +607,6 @@ check_range(struct mm_struct *mm, unsigned long start,=
 unsigned long end,
 	return first;
 }
=20
-/* Apply policy to a single VMA */
-static int policy_vma(struct vm_area_struct *vma, struct mempolicy *new)
-{
-	int err =3D 0;
-	struct mempolicy *old =3D vma->vm_policy;
-
-	pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
-		 vma->vm_start, vma->vm_end, vma->vm_pgoff,
-		 vma->vm_ops, vma->vm_file,
-		 vma->vm_ops ? vma->vm_ops->set_policy : NULL);
-
-	if (vma->vm_ops && vma->vm_ops->set_policy)
-		err =3D vma->vm_ops->set_policy(vma, new);
-	if (!err) {
-		mpol_get(new);
-		vma->vm_policy =3D new;
-		mpol_put(old);
-	}
-	return err;
-}
-
 /* Step 2: apply policy to a range and do splits. */
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
@@ -675,9 +654,23 @@ static int mbind_range(struct mm_struct *mm, unsigned =
long start,
 			if (err)
 				goto out;
 		}
-		err =3D policy_vma(vma, new_pol);
-		if (err)
-			goto out;
+
+		/*
+		 * Apply policy to a single VMA. The reference counting of
+		 * policy for vma_policy linkages has already been handled by
+		 * vma_merge and split_vma as necessary. If this is a shared
+		 * policy then ->set_policy will increment the reference count
+		 * for an sp node.
+		 */
+		pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
+			vma->vm_start, vma->vm_end, vma->vm_pgoff,
+			vma->vm_ops, vma->vm_file,
+			vma->vm_ops ? vma->vm_ops->set_policy : NULL);
+		if (vma->vm_ops && vma->vm_ops->set_policy) {
+			err =3D vma->vm_ops->set_policy(vma, new_pol);
+			if (err)
+				goto out;
+		}
 	}
=20
  out:
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2015a1e..d3955f2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2102,7 +2102,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialf=
ile, int, swap_flags)
 			p->flags |=3D SWP_SOLIDSTATE;
 			p->cluster_next =3D 1 + (random32() % p->highest_bit);
 		}
-		if (discard_swap(p) =3D=3D 0 && (swap_flags & SWAP_FLAG_DISCARD))
+		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) =3D=3D 0)
 			p->flags |=3D SWP_DISCARDABLE;
 	}
=20
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index f444817..2b587ec 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1549,6 +1549,8 @@ static noinline_for_stack int ethtool_flash_device(st=
ruct net_device *dev,
 	if (!dev->ethtool_ops->flash_device)
 		return -EOPNOTSUPP;
=20
+	efl.data[ETHTOOL_FLASH_MAX_FILENAME - 1] =3D 0;
+
 	return dev->ethtool_ops->flash_device(dev, &efl);
 }
=20
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3302c56..c1c99dd 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -379,7 +379,15 @@ static void reg_regdb_query(const char *alpha2)
=20
 	schedule_work(&reg_regdb_work);
 }
+
+/* Feel free to add any other sanity checks here */
+static void reg_regdb_size_check(void)
+{
+	/* We should ideally BUILD_BUG_ON() but then random builds would fail */
+	WARN_ONCE(!reg_regdb_size, "db.txt is empty, you should update it...");
+}
 #else
+static inline void reg_regdb_size_check(void) {}
 static inline void reg_regdb_query(const char *alpha2) {}
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
=20
@@ -2236,6 +2244,8 @@ int __init regulatory_init(void)
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
=20
+	reg_regdb_size_check();
+
 	cfg80211_regdomain =3D cfg80211_world_regdom;
=20
 	user_alpha2[0] =3D '9';
diff --git a/scripts/Makefile b/scripts/Makefile
index df7678f..3626666 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -8,6 +8,8 @@
 # conmakehash:	 Create arrays for initializing the kernel console tables
 # docproc:       Used in Documentation/DocBook
=20
+HOST_EXTRACFLAGS +=3D -I$(srctree)/tools/include
+
 hostprogs-$(CONFIG_KALLSYMS)     +=3D kallsyms
 hostprogs-$(CONFIG_LOGO)         +=3D pnmtologo
 hostprogs-$(CONFIG_VT)           +=3D conmakehash
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index f466587..b4f802d 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1238,6 +1238,7 @@ static int sel_make_bools(void)
 		kfree(bool_pending_names[i]);
 	kfree(bool_pending_names);
 	kfree(bool_pending_values);
+	bool_num =3D 0;
 	bool_pending_names =3D NULL;
 	bool_pending_values =3D NULL;
=20
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index b9c7986..f17dfee 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -324,7 +324,7 @@ static void *start_thread_helper(void *arg)
=20
 		ret =3D t->in(t, t->buf, t->buf_size);
 		if (ret > 0) {
-			ret =3D t->out(t, t->buf, t->buf_size);
+			ret =3D t->out(t, t->buf, ret);
 			name =3D out_name;
 			op =3D "write";
 		} else {
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index fd817a2..533db33 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -239,9 +239,13 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 		return -ENODEV;
 	}
=20
+	mutex_lock(&kvm->slots_lock);
+
 	kvm->arch.iommu_domain =3D iommu_domain_alloc(&pci_bus_type);
-	if (!kvm->arch.iommu_domain)
-		return -ENOMEM;
+	if (!kvm->arch.iommu_domain) {
+		r =3D -ENOMEM;
+		goto out_unlock;
+	}
=20
 	if (!allow_unsafe_assigned_interrupts &&
 	    !iommu_domain_has_cap(kvm->arch.iommu_domain,
@@ -252,17 +256,16 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 		       " module option.\n", __func__);
 		iommu_domain_free(kvm->arch.iommu_domain);
 		kvm->arch.iommu_domain =3D NULL;
-		return -EPERM;
+		r =3D -EPERM;
+		goto out_unlock;
 	}
=20
 	r =3D kvm_iommu_map_memslots(kvm);
 	if (r)
-		goto out_unmap;
-
-	return 0;
+		kvm_iommu_unmap_memslots(kvm);
=20
-out_unmap:
-	kvm_iommu_unmap_memslots(kvm);
+out_unlock:
+	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
=20
@@ -338,7 +341,11 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
 	if (!domain)
 		return 0;
=20
+	mutex_lock(&kvm->slots_lock);
 	kvm_iommu_unmap_memslots(kvm);
+	kvm->arch.iommu_domain =3D NULL;
+	mutex_unlock(&kvm->slots_lock);
+
 	iommu_domain_free(domain);
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e401c1b..ec747dc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -289,15 +289,15 @@ static void kvm_mmu_notifier_invalidate_page(struct m=
mu_notifier *mn,
 	 */
 	idx =3D srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
+
 	kvm->mmu_notifier_seq++;
 	need_tlb_flush =3D kvm_unmap_hva(kvm, address) | kvm->tlbs_dirty;
-	spin_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
-
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)
 		kvm_flush_remote_tlbs(kvm);
=20
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 }
=20
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
@@ -335,12 +335,12 @@ static void kvm_mmu_notifier_invalidate_range_start(s=
truct mmu_notifier *mn,
 	for (; start < end; start +=3D PAGE_SIZE)
 		need_tlb_flush |=3D kvm_unmap_hva(kvm, start);
 	need_tlb_flush |=3D kvm->tlbs_dirty;
-	spin_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
-
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)
 		kvm_flush_remote_tlbs(kvm);
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 }
=20
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
@@ -378,13 +378,14 @@ static int kvm_mmu_notifier_clear_flush_young(struct =
mmu_notifier *mn,
=20
 	idx =3D srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
-	young =3D kvm_age_hva(kvm, address);
-	spin_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
=20
+	young =3D kvm_age_hva(kvm, address);
 	if (young)
 		kvm_flush_remote_tlbs(kvm);
=20
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
 	return young;
 }
=20
@@ -1666,6 +1667,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm,=
 u32 id)
 		goto vcpu_destroy;
=20
 	mutex_lock(&kvm->lock);
+	if (!kvm_vcpu_compatible(vcpu)) {
+		r =3D -EINVAL;
+		goto unlock_vcpu_destroy;
+	}
 	if (atomic_read(&kvm->online_vcpus) =3D=3D KVM_MAX_VCPUS) {
 		r =3D -EINVAL;
 		goto unlock_vcpu_destroy;


--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-fYpoxokc9qiwXwcfoPKR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT8Ly8Oe/yOyVhhEJAQqrMA/9Hf7tbPEpWNo4o85UkdvxuBpai2+KGh+6
NGuQOmPmyawGfXOGRdDdR/VqcZqBp1siW1XA1CbWlqlgnrvJPAAmerWElGgI7PPg
e/EghNATe8WUAtiA+5D59XeKzXPnnmH/9mcXoIglu66uw9Cmw4SZJt4WXDPtfQdC
wyVs67hxFDiJ+hHjzRmMIOobVV48rOsYmaKgcEbqTd2RMJeyyk8HQw+5eJyJNXqL
z4+GWagzQ2xC8txoJi4ZaXXYowaEvgXffKzxGAm8fTCzZegMNTcI/wy9O7aMTYXj
kosXZmadjupW1ETu8XeapkgA8ESrsuxrAMQxQsC0O5WVRvrhTZMmdRCJV65BK5qq
Ei/9xLlnh880aBdOJhJZb/wJrh+gesKt089zb2i9x60gQ0X+2kQDMHQDbRS9b85R
JPeigavhDRpDMXzKGeDz4+V8yOWhRA1l3PnEZcNL3asIv3zJ79C2JOMlbD+ADWrH
M80EW9/lCUxcLz0JYUBqths1k/LgGpggdYeRQBDk51scHrn56V2bUHV9O5Ya4IXy
iaIo/9vR3xFBmt1nxSdjiL50OwVPWsnrn2poO1VT9x/irDK3VyhdPTKIar+cnB4Z
TbszRHFszumrL6TEXzcAa1qJi7D3dvz1uSprdk4Uls/EyyWwdyUy2lPVLNLQi2vW
cDzWQTuNmC8=
=tQwj
-----END PGP SIGNATURE-----

--=-fYpoxokc9qiwXwcfoPKR--
