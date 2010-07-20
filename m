Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761095Ab0GTDsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 23:48:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51216 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761131Ab0GTDsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 23:48:35 -0400
Date: Tue, 20 Jul 2010 13:48:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: linux-next: manual merge of the limits tree with the tile tree
Message-Id: <20100720134833.4082eed4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the limits tree got a conflict in
include/asm-generic/unistd.h between commits
5360bd776f73d0a7da571d72a09a03f237e99900 ("Fix up the "generic" unistd.h
ABI to be more useful") and b51cae21ee66f77a368428e6bdf75a0c012c9fd7
("Add wait4() back to the set of <asm-generic/unistd.h> syscalls") from
the tile tree and commit f33ebbe9da2c3c24664a0ad4f8fd83f293547e63
("unistd: add __NR_prlimit64 syscall numbers") from the limits tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/asm-generic/unistd.h
index c17cebc,0dfd517..0000000
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@@ -631,18 -626,11 +631,20 @@@ __SYSCALL(__NR_perf_event_open, sys_per
  __SYSCALL(__NR_accept4, sys_accept4)
  #define __NR_recvmmsg 243
  __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+ #define __NR_prlimit64 244
+ __SYSCALL(__NR_prlimit64, sys_prlimit64)
  
 +/*
 + * Architectures may provide up to 16 syscalls of their own
 + * starting with this value.
 + */
- #define __NR_arch_specific_syscall 244
++#define __NR_arch_specific_syscall 245
 +
 +#define __NR_wait4 260
 +__SYSCALL(__NR_wait4, sys_wait4)
 +
  #undef __NR_syscalls
 -#define __NR_syscalls 245
 +#define __NR_syscalls 261
  
  /*
   * All syscalls below here should go away really,
