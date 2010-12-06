Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0LFRli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:41:38 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:34960 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753321Ab0LFRkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:16 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: jsPbr_oVM1mTzmH3lDD_iuCYYHq7.tV4EC9OrbOb2La.TgE
 8fa3DvDz2Uc5Wcx36CQS5i_kHkKDYo3TmXRmD51LksgoZchskXQ0PJRp6AHc
 gePl3FyOQxPjXXEgBGelxTmWThc8tqsZAV3eCXXDLRNNqom7L86a96K4yIjr
 LrIBxyFW_64wH7ihy7.M1_ch8puXDzaGZZoav._UffpppdQcjYTxMbSuRKJs
 zY0SdxlN_UWts.2pmnrwSZdR2MizW4uGAbEPFRxpDaPCdRV.HK5fDWnpydYX
 ALF58BQWIkzie04EyI5b1
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206174014.806809612@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:40:01 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 3/9] x86: Use this_cpu_inc_return for nmi counter
References: <20101206173958.685460926@linux.com>
Content-Disposition: inline; filename=cpuops_inc_return_nmi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc_return() saves us a memory access there.

Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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

