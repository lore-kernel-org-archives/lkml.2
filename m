Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab2J3QkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:40:03 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48434 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844Ab2J3Qj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/6] rcu: Reduce default RCU CPU stall warning timeout
Date: Tue, 30 Oct 2012 09:27:55 -0700
Message-Id: <1351614475-22895-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030162728.GA22648@linux.vnet.ibm.com>
 <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5518-0000-0000-000008D6CD17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The RCU CPU stall warning timeout has defaulted to 60 seconds for
some years, with almost no false positives.  This commit therefore
reduces the default to 21 seconds, slightly shorter than the new
soft-lockup timeout.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28e9d6c9..41faf0b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -972,7 +972,7 @@ config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	range 3 300
-	default 60
+	default 21
 	help
 	  If a given RCU grace period extends more than the specified
 	  number of seconds, a CPU stall warning is printed.  If the
-- 
1.7.8

