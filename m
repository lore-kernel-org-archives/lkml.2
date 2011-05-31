Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1EaOPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:15:23 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:57397 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405Ab1EaOPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:15:16 -0400
X-AuditID: 12074424-b7bc6ae000005a77-f2-4de4f7f355ce
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v4 06/10] x86-64: Remove vsyscall number 3 (venosys)
Date: Tue, 31 May 2011 10:14:04 -0400
Message-Id: <c1b36173beff15c421826aea7c8c5f714084e170.1306851090.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsUixG6novv5+xNfg/0L+C3mrF/DZtF35Si7
	xZFr39ktZl3jtfi84R+bxYFfT9ks3l/dzmZxedccNosnzdcZLbZcama1+DBxA5vF5k1TmS0e
	9b1lt/ix4TGrA5/H99Y+Fo9jZw4zetxq+8PsMX/nR0aPnbPusntsXqHl8f/lETaPTas62Tze
	nTvH7nFixm8Wj+NnnD0+b5IL4InisklJzcksSy3St0vgyrjccY6lYA9nReuUc8wNjK/Zuxg5
	OSQETCQ27vvGAmGLSVy4t56ti5GLQ0hgH6NE/8bZzBDOBkaJ25u/s0M4z5gkTt3cwwbSwiag
	ItGx9AFTFyMHh4iAvsTVz4wgNcwCk1gkDv89DTZWWMBFYvKWXkYQm0VAVeLfy+msIPW8AkES
	m1a4QmxWkLhyZR5YOaeAgcT2q6sYQUqEgEYe/6CLQ3gCo8ACRoZVjLIpuVW6uYmZOcWpybrF
	yYl5ealFuuZ6uZkleqkppZsYwRHjorKDsfmQ0iFGAQ5GJR7elIOPfYVYE8uKK3MPMUpyMCmJ
	8lZ8e+IrxJeUn1KZkVicEV9UmpNafIhRgoNZSYT3Gx9QjjclsbIqtSgfJiXNwaIkzjtPUt1X
	SCA9sSQ1OzW1ILUIJivDwaEkwZsLTAxCgkWp6akVaZk5JQhpJg5OkOE8QMMLQRbzFhck5hZn
	pkPkTzHqcjSu3XGQUYglLz8vVUqc1wpkkABIUUZpHtwcWKJ7xSgO9JYwrwJIFQ8wScJNegW0
	hAloSe+7hyBLShIRUlINjA1eKf+VD3BuufHz9+ntLXpXLm3xammybUvKuNfsxqfeFs0Tc6y6
	8NcP1+sGs1dXxe64e2Cv+Df2i8z6pouOasplNG83qqzjjWcWZWZ1n3Ilq7ZHn3/ypdOPLubz
	8O3p02piM93vkLvuIPP2PRLLs1b1uV6fyHNa8MMXBxa55RWBtpc0Pq7/rsRSnJFoqMVcVJwI
	ALXV/qVPAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It just segfaults since April 2008 (a4928cff), so I'm pretty sure
that nothing uses it.  And having an empty section makes the linker
script a bit fragile.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vmlinux.lds.S |    4 ----
 arch/x86/kernel/vsyscall_64.c |    3 ---
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 3d89a00..dc8ac70 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -182,10 +182,6 @@ SECTIONS
 		*(.vsyscall_2)
 	}
 
-	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
-		*(.vsyscall_3)
-	}
-
 	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
 
 #undef VSYSCALL_ADDR
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 9b2f3f5..c7fe325 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -209,9 +209,6 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 	return 0;
 }
 
-static long __vsyscall(3) venosys_1(void)
-{
-	return -ENOSYS;
 }
 
 /* Assume __initcall executes before all user space. Hopefully kmod
-- 
1.7.5.1

