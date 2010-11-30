Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab0K3TL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:11:59 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:34459 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753337Ab0K3TIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:46 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: au2q5xgVM1kBMsVTPq.23A5odm3HXFnQzs3fj8s4Viki.wh
 wO00fkbNGM7th0uERQLT6.y15O8w6ggzawP0fIKCk267qiGlBua5E07Mut2l
 WNry7GREJtF32hn6Xy91MnaAwYha3K30idjEgHsFV1Zq5DoLmC8S_pspCcuc
 EcQlhJFI_9IMkOWmeBALYyogOv37RRoTbLU2zPMwX2x7Nwfx7v8Vuh6r0ia6
 9u1v_0h_rvlVIGYVQe3NC4fcWQdLPOsNwCnG6Xu8SXPjb3Z2ucl7jUuJ6sfv
 Juh31fvNQJS_qM3j_NZpF
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190844.025319634@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:12 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 05/18] x86: Use this_cpu_inc_return for nmi counter
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_add_nmi
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

