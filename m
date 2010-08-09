Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0HIWPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:36 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56751 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab0HIWPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/10] rcu: restrict TREE_RCU to SMP builds with !PREEMPT
Date: Mon,  9 Aug 2010 15:15:06 -0700
Message-Id: <1281392111-25060-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because both TINY_RCU and TREE_PREEMPT_RCU have been in mainline for
several releases, it is time to restrict the use of TREE_RCU to SMP
non-preemptible systems.  This reduces testing/validation effort.  This
commit is a first step towards driving the selection of RCU implementation
directly off of the SMP and PREEMPT configuration parameters.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5cff9a9..9366954 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -336,6 +336,7 @@ choice
 
 config TREE_RCU
 	bool "Tree-based hierarchical RCU"
+	depends on !PREEMPT && SMP
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP system with hundreds or
-- 
1.7.0.6

