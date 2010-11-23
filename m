Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0KWXxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:53:34 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:41475 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753416Ab0KWXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:52:00 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: WE12wHcVM1mdmBIKubTLQc5NElLVJhEE4cVbb4Beoymk76X
 Dxy5pA4ohAE0CYbRp5Z1ShVqIT.i28qD6f1eNdZBGOUvONmJZCMGI.5SibCj
 ELXocNO9md42lFg70RUpcQW8xtJxA84ZrQG6jKl94pKaxmN63LQ9KhgNxFs2
 F_k0C_MktRl0TB7t5HVx5nkv3ERsI_5m4mQtKtjcHcxcBt0U.oKUOepmzKnn
 AzjvpyL5kFS8.Ztz9HSbx_k3_IkZAV3wePQm4AWetgPL.ia98hQMo3AFlfiv
 xjv0vaE3noF1incmA.kk-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235158.826005750@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:44 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 05/10] x86: Use this_cpu_inc_return for nmi counter
References: <20101123235139.908255844@linux.com>
Content-Disposition: inline; filename=this_cpu_add_nmi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc_return() saves us a memory access there.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/kernel/apic/nmi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/nmi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/nmi.c	2010-11-23 16:35:19.000000000 -0600
+++ linux-2.6/arch/x86/kernel/apic/nmi.c	2010-11-23 16:38:29.000000000 -0600
@@ -432,8 +432,7 @@ nmi_watchdog_tick(struct pt_regs *regs,
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
 		 */
-		__this_cpu_inc(alert_counter);
-		if (__this_cpu_read(alert_counter) == 5 * nmi_hz)
+		if (__this_cpu_inc_return(alert_counter) == 5 * nmi_hz)
 			/*
 			 * die_nmi will return ONLY if NOTIFY_STOP happens..
 			 */

