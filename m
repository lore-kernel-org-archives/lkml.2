Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab1GYMii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:38:38 -0400
Received: from ozlabs.org ([203.10.76.45]:39654 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab1GYMhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:37:23 -0400
X-Mailbox-Line: From anton@samba.org Mon Jul 25 12:34:26 2011
Message-Id: <20110725023426.138582698@samba.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 12:33:13 +1000
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, peterz@infradead.org, benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] sched: Allow SD_NODES_PER_DOMAIN to be overridden
References: <20110725023311.175792493@samba.org>
Content-Disposition: inline; filename=move_SD_NODES_PER_DOMAIN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to override the default value of SD_NODES_PER_DOMAIN on ppc64,
so move it into linux/topology.h.

Signed-off-by: Anton Blanchard <anton@samba.org> 
---

Index: linux-2.6-work/include/linux/topology.h
===================================================================
--- linux-2.6-work.orig/include/linux/topology.h	2011-07-25 11:20:02.588717796 +1000
+++ linux-2.6-work/include/linux/topology.h	2011-07-25 11:26:50.616468376 +1000
@@ -201,6 +201,10 @@ int arch_update_cpu_topology(void);
 	.balance_interval	= 64,					\
 }
 
+#ifndef SD_NODES_PER_DOMAIN
+#define SD_NODES_PER_DOMAIN 16
+#endif
+
 #ifdef CONFIG_SCHED_BOOK
 #ifndef SD_BOOK_INIT
 #error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
Index: linux-2.6-work/kernel/sched.c
===================================================================
--- linux-2.6-work.orig/kernel/sched.c	2011-07-25 11:20:09.538850173 +1000
+++ linux-2.6-work/kernel/sched.c	2011-07-25 11:26:50.626468565 +1000
@@ -6938,8 +6938,6 @@ static int __init isolated_cpu_setup(cha
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-#define SD_NODES_PER_DOMAIN 16
-
 #ifdef CONFIG_NUMA
 
 /**


