Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab2GEWdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:33:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41488 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2GEWde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:33:34 -0400
Date: Thu, 5 Jul 2012 15:33:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu] Introduce check for callback list/count mismatch
Message-ID: <20120705223319.GA27331@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070522-6148-0000-0000-00000764CD4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent bug that introduced the RCU callback list/count mismatch
showed the need for a diagnostic to check for this, which this patch
adds.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 95c7b61..4154c95 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1612,6 +1612,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		rdp->n_force_qs_snap = rsp->n_force_qs;
 	} else if (rdp->qlen < rdp->qlen_last_fqs_check - qhimark)
 		rdp->qlen_last_fqs_check = rdp->qlen;
+	WARN_ON_ONCE((rdp->nxtlist == NULL) != (rdp->qlen == 0));
 
 	local_irq_restore(flags);
 

