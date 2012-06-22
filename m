Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab2FVPfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:35:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45465 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762598Ab2FVPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:35:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Carsten Emde <C.Emde@osadl.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/17] Prevent uninitialized string in RCU stall info
Date: Fri, 22 Jun 2012 08:35:10 -0700
Message-Id: <1340379312-6684-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-1780-0000-0000-000006B6DB46
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00150294; UDB=6.00034140; UTC=2012-06-22
 15:35:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <C.Emde@osadl.org>

An uninitialized string may be displayed at the end of the rcu_preempt
detected stall info such as

0: (1 GPs behind) idle=075/140000000000000/0 =8?^D=8?^D
                                             ^^^^^^^^^^
if CONFIG_RCU_FAST_NO_HZ is not defined.

This trivial patch clears the string in this case.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index d806186..321ba89 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2205,6 +2205,7 @@ static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 
 static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
+	*cp = '\0';
 }
 
 #endif /* #else #ifdef CONFIG_RCU_FAST_NO_HZ */
-- 
1.7.8

