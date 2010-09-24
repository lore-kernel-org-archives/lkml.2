Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0IXQbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:31:33 -0400
Received: from kroah.org ([198.145.64.141]:38557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932814Ab0IXQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:21 2010
Message-Id: <20100924162620.930407725@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luca Barbieri <luca@luca-barbieri.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [69/80] x86, asm: Use a lower case name for the end macro in atomic64_386_32.S
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luca Barbieri <luca@luca-barbieri.com>

commit 417484d47e115774745ef025bce712a102b6f86f upstream.

Use a lowercase name for the end macro, which somehow fixes a binutils 2.16
problem.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/lib/atomic64_386_32.S |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

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


