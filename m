Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2DSARe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:17:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43439 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2DSARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:17:32 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/5] x86: Add symbolic constant for exceptions with error code
Date: Wed, 18 Apr 2012 17:16:47 -0700
Message-Id: <1334794610-5546-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1334794610-5546-1-git-send-email-hpa@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 17:17:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Add a symbolic constant for the bitmask which states which exceptions
carry an error code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/segment.h |    2 ++
 arch/x86/kernel/head_64.S      |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 1654662..58c1e6c 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -205,6 +205,8 @@
 
 #define IDT_ENTRIES 256
 #define NUM_EXCEPTION_VECTORS 32
+/* Bitmask of exception vectors which push an error code on the stack */
+#define EXCEPTION_ERRCODE_MASK  0x00027d00
 #define GDT_SIZE (GDT_ENTRIES * 8)
 #define GDT_ENTRY_TLS_ENTRIES 3
 #define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 40f4eb3..adf52e8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -295,7 +295,7 @@ ENTRY(early_idt_handler)
 	ja 0f
 	movl $1,%eax
 	salq %cl,%rax
-	testl $0x27d00,%eax
+	testl $EXCEPTION_ERRCODE_MASK,%eax
 	je 0f
 	popq %r8		# get error code
 0:	movq 0(%rsp),%rcx	# get ip
-- 
1.7.6.5

