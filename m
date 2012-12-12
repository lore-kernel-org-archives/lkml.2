Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2LLSXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:23:30 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35059 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:23:28 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 25/26] x86: head_64.S: Use vsprintf extension %pSR not print_symbol
Date: Wed, 12 Dec 2012 10:19:14 -0800
Message-Id: <ecdebc4ab0c336cb2edc062e57e12d75df7185e8.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_symbol will be removed so replace this instance
with the %pSR vsprintf extension.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/head_64.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 980053c..37575a5 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -344,7 +344,7 @@ ENTRY(early_idt_handler)
 #ifdef CONFIG_KALLSYMS	
 	leaq early_idt_ripmsg(%rip),%rdi
 	movq 40(%rsp),%rsi	# %rip again
-	call __print_symbol
+	call early_printk
 #endif
 #endif /* EARLY_PRINTK */
 1:	hlt
@@ -372,7 +372,7 @@ early_recursion_flag:
 early_idt_msg:
 	.asciz "PANIC: early exception %02lx rip %lx:%lx error %lx cr2 %lx\n"
 early_idt_ripmsg:
-	.asciz "RIP %s\n"
+	.asciz "RIP %pSR\n"
 #endif /* CONFIG_EARLY_PRINTK */
 	.previous
 
-- 
1.7.8.112.g3fd21

