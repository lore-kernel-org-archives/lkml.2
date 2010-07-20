Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0GTDsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 23:48:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51213 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761100Ab0GTDsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 23:48:32 -0400
Date: Tue, 20 Jul 2010 13:48:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: linux-next: manual merge of the limits tree with the fsnotify tree
Message-Id: <20100720134826.fd4ce996.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the limits tree got conflicts in
arch/x86/ia32/ia32entry.S, arch/x86/include/asm/unistd_32.h,
arch/x86/include/asm/unistd_64.h and arch/x86/kernel/syscall_table_32.S
between commits 21eeaef698e82e64083c10a85121a81a860dac9a ("fanotify:
fanotify_init syscall declaration") and
36bcd29670c4042c25405750067880a51b3113a9 ("fanotify: sys_fanotify_mark
declartion") from the fsnotify tree and commit
f33ebbe9da2c3c24664a0ad4f8fd83f293547e63 ("unistd: add __NR_prlimit64
syscall numbers") from the limits tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/ia32/ia32entry.S
index 17cf65c,a88e31d..0000000
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@@ -842,6 -842,5 +842,7 @@@ ia32_sys_call_table
  	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
  	.quad sys_perf_event_open
  	.quad compat_sys_recvmmsg
 +	.quad sys_fanotify_init
 +	.quad sys32_fanotify_mark
+ 	.quad sys_prlimit64
  ia32_syscall_end:
diff --cc arch/x86/include/asm/unistd_32.h
index 80b799c,35e0cb1..0000000
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@@ -343,12 -343,11 +343,13 @@@
  #define __NR_rt_tgsigqueueinfo	335
  #define __NR_perf_event_open	336
  #define __NR_recvmmsg		337
 -#define __NR_prlimit64		338
 +#define __NR_fanotify_init	338
 +#define __NR_fanotify_mark	339
++#define __NR_prlimit64		340
  
  #ifdef __KERNEL__
  
- #define NR_syscalls 340
 -#define NR_syscalls 339
++#define NR_syscalls 341
  
  #define __ARCH_WANT_IPC_PARSE_VERSION
  #define __ARCH_WANT_OLD_READDIR
diff --cc arch/x86/include/asm/unistd_64.h
index 5b7b1d5,570bf5e..0000000
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@@ -663,10 -663,8 +663,12 @@@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_r
  __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
  #define __NR_recvmmsg				299
  __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 -#define __NR_prlimit64				300
 +#define __NR_fanotify_init			300
 +__SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 +#define __NR_fanotify_mark			301
 +__SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
++#define __NR_prlimit64				302
+ __SYSCALL(__NR_prlimit64, sys_prlimit64)
  
  #ifndef __NO_STUBS
  #define __ARCH_WANT_OLD_READDIR
diff --cc arch/x86/kernel/syscall_table_32.S
index 07ad5eb,eca1d7d..0000000
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@@ -337,5 -337,4 +337,6 @@@ ENTRY(sys_call_table
  	.long sys_rt_tgsigqueueinfo	/* 335 */
  	.long sys_perf_event_open
  	.long sys_recvmmsg
 -	.long sys_prlimit64
 +	.long sys_fanotify_init
 +	.long sys_fanotify_mark
++	.long sys_prlimit64		/* 340 */
