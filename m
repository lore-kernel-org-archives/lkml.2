Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2BOFgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:36:41 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39790 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2BOFgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:36:39 -0500
Message-ID: <1329284188.12708.1.camel@phoenix>
Subject: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nathaniel Husted <nhusted@gmail.com>, Eric Paris <eparis@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 15 Feb 2012 13:36:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/audit.h to fix below build errors:

  CC      arch/arm/kernel/ptrace.o
arch/arm/kernel/ptrace.c: In function 'syscall_trace':
arch/arm/kernel/ptrace.c:919: error: implicit declaration of function 'audit_syscall_exit'
arch/arm/kernel/ptrace.c:921: error: implicit declaration of function 'audit_syscall_entry'
arch/arm/kernel/ptrace.c:921: error: 'AUDIT_ARCH_ARMEB' undeclared (first use in this function)
arch/arm/kernel/ptrace.c:921: error: (Each undeclared identifier is reported only once
arch/arm/kernel/ptrace.c:921: error: for each function it appears in.)
make[1]: *** [arch/arm/kernel/ptrace.o] Error 1
make: *** [arch/arm/kernel] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next 20120215.

 arch/arm/kernel/ptrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index e33870f..48970ad 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -23,6 +23,7 @@
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/regset.h>
+#include <linux/audit.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
-- 
1.7.5.4



