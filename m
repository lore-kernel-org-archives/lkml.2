Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0JYPw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:52:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38672 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab0JYPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VpxGGDuZHAg2yxQEKIkC2rzfwexxfcbxHYRSEmhtHaIap4Zneo3RQDLOvu7UImTjvd
         bhM3n9SQOpJfCJoCZuWstauMzZ0Ej5PZEDPd67uJtrpBSYpN7osthcyqginHAPdj1o8A
         5tub4pyZfEBrtCAdYWuyA/MnERz3mQzB1TnAs=
From: Namhyung Kim <namhyung@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sparc32: fix build failure on CONFIG_SPARC_LEON
Date: Tue, 26 Oct 2010 00:52:38 +0900
Message-Id: <1288021958-3130-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
References: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      arch/sparc/kernel/irq_32.o
arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'
arch/sparc/include/asm/leon.h:366:22: note: previous declaration of 'trapbase_cpu1' was here
arch/sparc/kernel/irq_32.c:370:40: error: conflicting types for 'trapbase_cpu2'
arch/sparc/include/asm/leon.h:367:22: note: previous declaration of 'trapbase_cpu2' was here
arch/sparc/kernel/irq_32.c:370:55: error: conflicting types for 'trapbase_cpu3'
arch/sparc/include/asm/leon.h:368:22: note: previous declaration of 'trapbase_cpu3' was here
make[3]: *** [arch/sparc/kernel/irq_32.o] Error 1
make[2]: *** [arch/sparc/kernel] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/sparc/kernel/irq_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/irq_32.c b/arch/sparc/kernel/irq_32.c
index 0116d8d..5ad6e5c 100644
--- a/arch/sparc/kernel/irq_32.c
+++ b/arch/sparc/kernel/irq_32.c
@@ -365,7 +365,7 @@ static int request_fast_irq(unsigned int irq,
 	unsigned long flags;
 	unsigned int cpu_irq;
 	int ret;
-#ifdef CONFIG_SMP
+#if defined CONFIG_SMP && !defined CONFIG_SPARC_LEON
 	struct tt_entry *trap_table;
 	extern struct tt_entry trapbase_cpu1, trapbase_cpu2, trapbase_cpu3;
 #endif
@@ -425,7 +425,7 @@ static int request_fast_irq(unsigned int irq,
 	table[SP_TRAP_IRQ1+(cpu_irq-1)].inst_four = SPARC_NOP;
 
 	INSTANTIATE(sparc_ttable)
-#ifdef CONFIG_SMP
+#if defined CONFIG_SMP && !defined CONFIG_SPARC_LEON
 	trap_table = &trapbase_cpu1; INSTANTIATE(trap_table)
 	trap_table = &trapbase_cpu2; INSTANTIATE(trap_table)
 	trap_table = &trapbase_cpu3; INSTANTIATE(trap_table)
-- 
1.7.0.4

