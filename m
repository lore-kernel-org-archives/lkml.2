Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2KRBdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 20:33:10 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54908 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2KRBdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 20:33:08 -0500
Date: Fri, 16 Nov 2012 11:26:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu] Fix TINY_RCU rcu_is_cpu_rrupt_from_idle check
Message-ID: <20121116192625.GA447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111801-5806-0000-0000-00001BE64661
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu_is_cpu_rrupt_from_idle() needs to allow for one interrupt level
from the idle loop, but TINY_RCU checks for a call from the idle loop
itself.  This commit fixes this issue.

Reported-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

 b/kernel/rcutiny.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e4c6a59..e7dce58 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -195,7 +195,7 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
  */
 int rcu_is_cpu_rrupt_from_idle(void)
 {
-	return rcu_dynticks_nesting <= 0;
+	return rcu_dynticks_nesting <= 1;
 }
 
 /*

