Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab2EKEPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:15:52 -0400
Received: from hm1480-14.locaweb.com.br ([201.76.49.111]:4329 "EHLO
	hm1480-14.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2EKEPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:15:50 -0400
From: Thiago Rafael Becker <trbecker@trbecker.org>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Thiago Rafael Becker <trbecker@trbecker.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        jan.kiszka@siemens.com, dhowells@redhat.com
Subject: [PATCH] kgbd: clear compilation warning
Date: Fri, 11 May 2012 01:13:40 -0300
Message-Id: <1336709620-19351-1-git-send-email-trbecker@trbecker.org>
X-Mailer: git-send-email 1.7.10.1
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=Krv6LxqN c=1 sm=1 a=0YOFKI15By1UX1CHIXxkcA==:17
	a=p-u1EHEsKPEA:10 a=la6TjtyCKkkA:10 a=yrWXaES42gIA:10 a=e_HWqny2AAAA:8
	a=8pZwhUQvnLxRy1rpyCYA:9 a=C4R2vJAwBmoA:10 a=y+3UcTADKzVc0lt15HEoKA==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function kgbd_arch_set_breakpoint, the variable is only used
if DEBUG_RODATA is configured. This clears the following compilation
warning:

arch/x86/kernel/kgdb.c:749:7: warning: unused variable 'opc'

Signed-off-by: Thiago Rafael Becker <trbecker@trbecker.org>
---
 arch/x86/kernel/kgdb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8bfb614..7c54c78 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -746,7 +746,6 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
-	char opc[BREAK_INSTR_SIZE];
 
 	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
@@ -756,6 +755,8 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 	err = probe_kernel_write((char *)bpt->bpt_addr,
 				 arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
 #ifdef CONFIG_DEBUG_RODATA
+	char opc[BREAK_INSTR_SIZE];
+
 	if (!err)
 		return err;
 	/*
-- 
1.7.10.1

