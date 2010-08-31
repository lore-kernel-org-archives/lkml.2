Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab0HaPwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:52:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab0HaPwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:52:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] h8300: Fix die()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: ysato@users.sourceforge.jp, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Tue, 31 Aug 2010 16:52:16 +0100
Message-ID: <20100831155216.10885.84495.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100831155211.10885.62967.stgit@warthog.procyon.org.uk>
References: <20100831155211.10885.62967.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix h8300's die() to take care of a number of problems:

  CC      arch/h8300/kernel/traps.o
In file included from /warthog/nfs/linux-2.6-fscache/arch/h8300/include/asm/bitops.h:10,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:17,
                 from include/linux/sched.h:54,
                 from arch/h8300/kernel/traps.c:18:
/warthog/nfs/linux-2.6-fscache/arch/h8300/include/asm/system.h:136: warning: 'struct pt_regs' declared inside parameter list
/warthog/nfs/linux-2.6-fscache/arch/h8300/include/asm/system.h:136: warning: its scope is only this definition or declaration, which is probably not what you want
arch/h8300/kernel/traps.c:100: error: conflicting types for 'die'
/warthog/nfs/linux-2.6-fscache/arch/h8300/include/asm/system.h:136: error: previous declaration of 'die' was here
make[2]: *** [arch/h8300/kernel/traps.o] Error 1

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/h8300/include/asm/system.h |    4 +++-
 arch/h8300/kernel/traps.c       |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/include/asm/system.h b/arch/h8300/include/asm/system.h
index d98d976..16bf156 100644
--- a/arch/h8300/include/asm/system.h
+++ b/arch/h8300/include/asm/system.h
@@ -3,6 +3,8 @@
 
 #include <linux/linkage.h>
 
+struct pt_regs;
+
 /*
  * switch_to(n) should switch tasks to task ptr, first checking that
  * ptr isn't the current task, in which case it does nothing.  This
@@ -155,6 +157,6 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
 
 #define arch_align_stack(x) (x)
 
-void die(char *str, struct pt_regs *fp, unsigned long err);
+extern void die(const char *str, struct pt_regs *fp, unsigned long err);
 
 #endif /* _H8300_SYSTEM_H */
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index 3c0b66b..dfa05bd 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -96,7 +96,7 @@ static void dump(struct pt_regs *fp)
 	printk("\n\n");
 }
 
-void die(char *str, struct pt_regs *fp, unsigned long err)
+void die(const char *str, struct pt_regs *fp, unsigned long err)
 {
 	static int diecount;
 

