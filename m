Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab0HLPeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:34:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:45447 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab0HLPeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:34:04 -0400
Date: Thu, 12 Aug 2010 15:33:47 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
References: <tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, asm: Use a lower case name for the end macro in atomic64_386_32.S
Message-ID: <tip-417484d47e115774745ef025bce712a102b6f86f@git.kernel.org>
Git-Commit-ID: 417484d47e115774745ef025bce712a102b6f86f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 15:33:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  417484d47e115774745ef025bce712a102b6f86f
Gitweb:     http://git.kernel.org/tip/417484d47e115774745ef025bce712a102b6f86f
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Thu, 12 Aug 2010 07:00:35 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 12 Aug 2010 07:04:16 -0700

x86, asm: Use a lower case name for the end macro in atomic64_386_32.S

Use a lowercase name for the end macro, which somehow fixes a binutils 2.16
problem.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/lib/atomic64_386_32.S |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 78ee8e0..2cda60a 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -26,35 +26,37 @@
 .endm
 
 #define BEGIN(op) \
-.macro END; \
+.macro endp; \
 	CFI_ENDPROC; \
 ENDPROC(atomic64_##op##_386); \
-.purgem END; \
+.purgem endp; \
 .endm; \
 ENTRY(atomic64_##op##_386); \
 	CFI_STARTPROC; \
 	LOCK v;
 
+#define ENDP endp
+
 #define RET \
 	UNLOCK v; \
 	ret
 
-#define RET_END \
+#define RET_ENDP \
 	RET; \
-	END
+	ENDP
 
 #define v %ecx
 BEGIN(read)
 	movl  (v), %eax
 	movl 4(v), %edx
-RET_END
+RET_ENDP
 #undef v
 
 #define v %esi
 BEGIN(set)
 	movl %ebx,  (v)
 	movl %ecx, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v  %esi
@@ -63,14 +65,14 @@ BEGIN(xchg)
 	movl 4(v), %edx
 	movl %ebx,  (v)
 	movl %ecx, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %ecx
 BEGIN(add)
 	addl %eax,  (v)
 	adcl %edx, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %ecx
@@ -79,14 +81,14 @@ BEGIN(add_return)
 	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %ecx
 BEGIN(sub)
 	subl %eax,  (v)
 	sbbl %edx, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %ecx
@@ -98,14 +100,14 @@ BEGIN(sub_return)
 	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %esi
 BEGIN(inc)
 	addl $1,  (v)
 	adcl $0, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %esi
@@ -116,14 +118,14 @@ BEGIN(inc_return)
 	adcl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %esi
 BEGIN(dec)
 	subl $1,  (v)
 	sbbl $0, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %esi
@@ -134,7 +136,7 @@ BEGIN(dec_return)
 	sbbl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_END
+RET_ENDP
 #undef v
 
 #define v %ecx
@@ -156,7 +158,7 @@ BEGIN(add_unless)
 	jne 1b
 	xorl %eax, %eax
 	jmp 2b
-END
+ENDP
 #undef v
 
 #define v %esi
@@ -177,7 +179,7 @@ BEGIN(inc_not_zero)
 	testl %edx, %edx
 	jne 1b
 	jmp 2b
-END
+ENDP
 #undef v
 
 #define v %esi
@@ -190,5 +192,5 @@ BEGIN(dec_if_positive)
 	movl %eax,  (v)
 	movl %edx, 4(v)
 1:
-RET_END
+RET_ENDP
 #undef v
