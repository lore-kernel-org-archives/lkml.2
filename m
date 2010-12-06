Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0LFRky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:40:54 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:29225 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754020Ab0LFRkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:20 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Rlmpzn4VM1mTdoWPhfdoJrkRHpJBFFfuzrXLdbaYsKaj4iq
 q7Vw02rMCIDJ56z9WAkgbFEK8b6gNmBVK5OLwGxfcfJ7Ilv387bbl3g7kuTI
 C2KAHIlaDoKxOyK_lxGqBgbwaMRlgzi9_YyqNHnTCiXLCry2JuJ8lwuk9CdF
 pz41.XDZScLAO10H_x7eNqlhq5Pq67ckKB4aqtXq4mH_ZgqrM03vHA4d_jhp
 MZoNk05VTfA32opl6vtvWVQ6LozP_U_YIaHWxkehYQWfkDXR.SWJ_
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206174018.255175103@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:40:07 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 9/9] Xen: Use this_cpu_inc_return
References: <20101206173958.685460926@linux.com>
Content-Disposition: inline; filename=cpuops_inc_return_xen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_inc_return reduces code and simplifies code.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/xen/events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c	2010-12-06 11:00:18.000000000 -0600
+++ linux-2.6/drivers/xen/events.c	2010-12-06 11:00:47.000000000 -0600
@@ -1109,7 +1109,7 @@ static void __xen_evtchn_do_upcall(void)
 
 		vcpu_info->evtchn_upcall_pending = 0;
 
-		if (__get_cpu_var(xed_nesting_count)++)
+		if (__this_cpu_inc_return(xed_nesting_count) - 1)
 			goto out;
 
 #ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86. */

