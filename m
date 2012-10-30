Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043Ab2J3Rgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:36:46 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34348 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965008Ab2J3RcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/5] rcu: Update RCU_FAST_NO_HZ help text
Date: Tue, 30 Oct 2012 10:19:20 -0700
Message-Id: <1351617563-28506-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030171906.GA27431@linux.vnet.ibm.com>
 <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7408-0000-0000-000009C5C6AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The RCU_FAST_NO_HZ help text included a warning about overhead on large
systems, but that issue has since been resolved.  The main remaining
issue with RCU_FAST_NO_HZ is increased real-time latency.  This commit
therefore updates the help text accordingly.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..b63e798 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -582,14 +582,13 @@ config RCU_FAST_NO_HZ
 	depends on NO_HZ && SMP
 	default n
 	help
-	  This option causes RCU to attempt to accelerate grace periods
-	  in order to allow CPUs to enter dynticks-idle state more
-	  quickly.  On the other hand, this option increases the overhead
-	  of the dynticks-idle checking, particularly on systems with
-	  large numbers of CPUs.
-
-	  Say Y if energy efficiency is critically important, particularly
-	  	if you have relatively few CPUs.
+	  This option causes RCU to attempt to accelerate grace periods in
+	  order to allow CPUs to enter dynticks-idle state more quickly.
+	  On the other hand, this option increases the overhead of the
+	  dynticks-idle checking, thus degrading scheduling latency.
+
+	  Say Y if energy efficiency is critically important, and you don't
+	  	care about real-time response.
 
 	  Say N if you are unsure.
 
-- 
1.7.8

