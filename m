Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0KZVLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:11:51 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:40905 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751781Ab0KZVJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:09:53 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: SHC8CUIVM1nJemuHB5vQUuPVhyhNvryUkOuBppThfhkvTEL
 cPm8yh7RT3dJ.KbOr3MySJCUEeTNwp.YrmJ19iwV.q6sfm4NZ07LQDP05fLv
 ApiUBPYFMh7fr_ZAvlQnt_wMps5CI3VTOvtag4Yan80I7QAQ5aq3M.QjKsVm
 .hf2w6uuJtBNt_xoW17Dz0OynEuMRJc6Mrz1qwwGTdzLos41IS6XnlG3k3UM
 A4g6zUf0iu4eZH4VZuzp19DUOMZgM8azDyNj886.6WcMoAJov1rMbxiMxJfV
 j75_QiDGe8dn27unvZsw-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101126210951.874368925@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 15:09:42 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thisops uV2 05/10] x86: Use this_cpu_inc_return for nmi counter
References: <20101126210937.383047168@linux.com>
Content-Disposition: inline; filename=this_cpu_add_nmi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc_return() saves us a memory access there.

Reviewed-by: Tejun Heo <tj@kernel.org>
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

