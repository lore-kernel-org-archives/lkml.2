Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0LFRkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:40:25 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:31690 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753974Ab0LFRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:19 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _y_p79oVM1kKIiBVG6elOINAgZ7y.fN_gJHPOuRRd9Exg7B
 k94kZu_wsFiSp7fdwb9FcED7ZmGD4PqdEn0.ALjL99HrswA9HzNoKnqkhsEq
 Wmvc_Ui0iNL8vPMJTMnia6grnwoD9CSx.7Q9uGYb346ftz6AFAXvLTE7pC8j
 EiVMgitGfRI0NzC5j5bGaWbLz7PwivwJveL3VvaDcqwECOQSrNoy6fo5PSl0
 byDKc9f3RRs3IBvIVahV3jPLIBTM_4cfcEQ_ZS.7_hxxVf5Qh_qzgxSI-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206174017.684979312@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:40:06 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Richard Kennedy <richard@rsk.demon.co.uk>,
        Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 8/9] random: Use this_cpu_inc_return
References: <20101206173958.685460926@linux.com>
Content-Disposition: inline; filename=cpuops_inc_return_random
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_inc can create a single instruction to do the same as
__get_cpu_var()++.

Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c	2010-12-06 11:01:06.000000000 -0600
+++ linux-2.6/drivers/char/random.c	2010-12-06 11:19:38.000000000 -0600
@@ -626,7 +626,7 @@ static void add_timer_randomness(struct
 	preempt_disable();
 	/* if over the trickle threshold, use only 1 in 4096 samples */
 	if (input_pool.entropy_count > trickle_thresh &&
-	    (__get_cpu_var(trickle_count)++ & 0xfff))
+	    ((__this_cpu_inc_return(trickle_count) - 1) & 0xfff))
 		goto out;
 
 	sample.jiffies = jiffies;

