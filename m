Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2ELTDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:03:17 -0400
Received: from hm1481-24.locaweb.com.br ([201.76.49.146]:23295 "EHLO
	hm1481-24.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2ELTDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:03:15 -0400
From: Thiago Rafael Becker <trbecker@trbecker.org>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Thiago Rafael Becker <trbecker@trbecker.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        jan.kiszka@siemens.com, dhowells@redhat.com
Subject: [PATCH] kgdb: clear compilation warning
Date: Sat, 12 May 2012 16:02:23 -0300
Message-Id: <1336849343-2701-1-git-send-email-trbecker@trbecker.org>
X-Mailer: git-send-email 1.7.10.1
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=Krv6LxqN c=1 sm=1 a=0YOFKI15By1UX1CHIXxkcA==:17
	a=Wkv0oGY1V4kA:10 a=la6TjtyCKkkA:10 a=E8gkYdMb1ykA:10 a=e_HWqny2AAAA:8
	a=vrZhlg8AEgI0H31yA2UA:9 a=C4R2vJAwBmoA:10 a=zWQKXumA2evbgYzgbGTjVw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function kgdb_arch_set_breakpoint, the variable is only used
if DEBUG_RODATA is configured. This clears the following compilation
warning:

arch/x86/kernel/kgdb.c:749:7: warning: unused variable 'opc'

Signed-off-by: Thiago Rafael Becker <trbecker@trbecker.org>
---
 arch/x86/kernel/kgdb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8bfb614..0ea80ef 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -746,7 +746,9 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
+#ifdef CONFIG_DEBUG_RODATA
 	char opc[BREAK_INSTR_SIZE];
+#endif
 
 	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
-- 
1.7.10.1

