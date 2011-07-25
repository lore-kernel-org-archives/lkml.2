Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1GYMh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:37:57 -0400
Received: from ozlabs.org ([203.10.76.45]:46738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1GYMh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:37:27 -0400
X-Mailbox-Line: From anton@samba.org Mon Jul 25 12:34:26 2011
Message-Id: <20110725023426.307093692@samba.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 12:33:15 +1000
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, peterz@infradead.org, benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] powerpc/numa: Disable NEWIDLE balancing at node level
References: <20110725023311.175792493@samba.org>
Content-Disposition: inline; filename=nodes_no_newidle
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On big POWER7 boxes we see large amounts of CPU time in system
processes like workqueue and watchdog kernel threads.

We currently rebalance the entire machine each time a task goes
idle and this is very expensive on large machines. Disable newidle
balancing at the node level and rely on the scheduler tick to
rebalance across nodes.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-work/arch/powerpc/include/asm/topology.h
===================================================================
--- linux-2.6-work.orig/arch/powerpc/include/asm/topology.h	2011-07-25 12:14:25.448671947 +1000
+++ linux-2.6-work/arch/powerpc/include/asm/topology.h	2011-07-25 12:14:26.568692651 +1000
@@ -75,7 +75,7 @@ static inline int pcibus_to_node(struct
 	.forkexec_idx		= 0,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
-				| 1*SD_BALANCE_NEWIDLE			\
+				| 0*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\


