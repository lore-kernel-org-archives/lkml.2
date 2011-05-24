Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1EXCz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:55:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59297 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab1EXCz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:55:27 -0400
Date: Tue, 24 May 2011 12:55:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the namespace tree with the sh tree
Message-Id: <20110524125523.3a20bc27.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the namespace tree got conflicts in
arch/sh/include/asm/unistd_32.h, arch/sh/include/asm/unistd_64.h,
arch/sh/kernel/syscalls_32.S and arch/sh/kernel/syscalls_64.S between
commit c7434dbf29b4 ("sh: wire up sys_sendmmsg") from the sh tree and
commit e975ee91dcc1 ("ns: Wire up the setns system call") from the
namespace tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sh/include/asm/unistd_32.h
index bb7d270,26c697c..0000000
--- a/arch/sh/include/asm/unistd_32.h
+++ b/arch/sh/include/asm/unistd_32.h
@@@ -373,9 -373,9 +373,10 @@@
  #define __NR_open_by_handle_at	360
  #define __NR_clock_adjtime	361
  #define __NR_syncfs		362
 -#define __NR_setns              363
 +#define __NR_sendmmsg		363
++#define __NR_setns              364
  
--#define NR_syscalls 364
++#define NR_syscalls 365
  
  #ifdef __KERNEL__
  
diff --cc arch/sh/include/asm/unistd_64.h
index 46327ce,330668a..0000000
--- a/arch/sh/include/asm/unistd_64.h
+++ b/arch/sh/include/asm/unistd_64.h
@@@ -394,11 -394,11 +394,12 @@@
  #define __NR_open_by_handle_at	371
  #define __NR_clock_adjtime	372
  #define __NR_syncfs		373
 -#define __NR_setns              374
 +#define __NR_sendmmsg		374
++#define __NR_setns              375
  
  #ifdef __KERNEL__
  
--#define NR_syscalls 375
++#define NR_syscalls 376
  
  #define __ARCH_WANT_IPC_PARSE_VERSION
  #define __ARCH_WANT_OLD_READDIR
diff --cc arch/sh/kernel/syscalls_32.S
index 7c486f3,67dcf66..0000000
--- a/arch/sh/kernel/syscalls_32.S
+++ b/arch/sh/kernel/syscalls_32.S
@@@ -380,4 -380,4 +380,5 @@@ ENTRY(sys_call_table
  	.long sys_open_by_handle_at	/* 360 */
  	.long sys_clock_adjtime
  	.long sys_syncfs
 +	.long sys_sendmmsg
+ 	.long sys_setns
diff --cc arch/sh/kernel/syscalls_64.S
index ba1a737,dade54e..0000000
--- a/arch/sh/kernel/syscalls_64.S
+++ b/arch/sh/kernel/syscalls_64.S
@@@ -400,4 -400,4 +400,5 @@@ sys_call_table
  	.long sys_open_by_handle_at
  	.long sys_clock_adjtime
  	.long sys_syncfs
 -	.long sys_setns
 +	.long sys_sendmmsg
++	.long sys_setns			/* 375 */
