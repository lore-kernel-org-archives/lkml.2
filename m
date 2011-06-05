Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1FESDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:03:04 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:51694 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714Ab1FESC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:02:59 -0400
X-AuditID: 12074423-b7ce8ae000000a29-c0-4debc4cdfb47
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
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 6/9] x86-64: Remove vsyscall number 3 (venosys)
Date: Sun,  5 Jun 2011 13:50:22 -0400
Message-Id: <4a4abcf47ecadc269f2391a313576fe6d06acef7.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA3WSW0gUYRTH+3ZmZ2YXp8bR9MsuxGQUxnZPv6AktIfvoY2IXioxx3Z0t/Zi
	O6uoDyFYUoa3KCyzC1EUm+W2Vmao5XottaTsgmSJFywvWRolJdmMZj31ds75/77/OYfvMAT/
	XhvCWOwuyWkXrQKlJ3k6MtTQWjdoXD2aEYGKS0solNteT6O6V99pVPSKRWOeXxRq9UH06Ecf
	hUZellPoxYNiCt1/206h3szXAN15nqlFPSX9BPpc4KFQmfc0gbpzh2n0fOQzicY9PdotPP5+
	NJfEDS21AHdkTRD4YsUXgK8cG6dxRVEnjcuuh+HJj3UULhh6A7DXfZzCn54+pXHTmZ8kbmyJ
	xmPeRdhXPkTtmLNHv8kkWS0pknNVZJze3OPupZIqdamjt0qJDDBIZwOGgdx6eDLrUDbQKWEQ
	bHtXSmUDPcNz1QDmNY7/SUoBrGrL1EwnfRp47lM9rT6huFB47GqXRnUK5FbBl2NAZQjuohZ6
	m0+QKhPARcEL545M8SS3FFblV2rVmOV2woGvHzTTUyyGz9wOtazjVsO2161TCK9Y+oYfU/+r
	5wPuEpjlBgtNtnSDTbRYZWm/Qd4v2u2S0xC+0mZxrZRMyV4w9Xdbl9wHEzWCD3AMEPxYT8mg
	kdeKKXKazQfmMRphLnupVinNjneY0syibN7nTLZKsg9AhhAC2cOBA0aeNYlp6ZLTMSPNZ0gh
	mD0/b5mR5xJFl3RQkpIk54y6gGEEyC5X7oX3d0qJUmqCxer6J2sYnWrup5hHqAwrJ4k22ZI4
	rT8BBuZu03AN4Em7wy6FBLNrVIhTIXOy/a/PzF0OgGBlrQBWp1J+ytX+dRpQmmiUJo1R6gay
	S/wnhWSA9K/9YnjgPdG3rqlkg2bSFdnNhI5d9+8YvLexJiuiM7R9W85ed/P4w1un2LbLmcUT
	hSnvyvJ8ReXVZ7k3Q9Gxk/nRXQ36tSOFC89U5tw2jsb79d24EO5J2J3hsMVcO5sSLbRiLQ5a
	8WjXgajNvxoXWxJavhDb42L6qhfd9Ge/xSYJpGwW14QRTln8DdjlfztyAwAA
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
index 98b378d..4f90082 100644
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
1.7.5.2

