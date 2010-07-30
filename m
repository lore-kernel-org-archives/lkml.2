Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0G3FUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:20:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab0G3FTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:19:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=TluaPcQUTs1a4v3scOwT1ok2X1K9/xDpjZLcC52r1gsNRv+SLzRYmi6YeNclO7nIB
	SJFYoLFqDHUhnxItqUGtg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, Ken Chen <kenchen@google.com>,
        Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 6/6] sched: enable SD_IDLE_LOAD_BALANCE on MC, CPU and NUMA (x86) domains
Date: Thu, 29 Jul 2010 22:19:06 -0700
Message-Id: <1280467146-32218-7-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280467146-32218-1-git-send-email-ncrao@google.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable SD_IDLE_LOAD_BALANCE on MC, CPU and NUMA for x86. This sched
flag enables the idle load balancer on these scheduling domains.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 arch/x86/include/asm/topology.h |    2 +-
 include/linux/topology.h        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 9f29b4e..8b27b3f 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -150,7 +150,7 @@ extern unsigned long node_remap_size[];
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
-				| 0*SD_IDLE_LOAD_BALANCE		\
+				| 1*SD_IDLE_LOAD_BALANCE		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 97fbb1b..cef87aa 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -135,7 +135,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_IDLE_LOAD_BALANCE		\
+				| 1*SD_IDLE_LOAD_BALANCE		\
 				| sd_balance_for_mc_power()		\
 				| sd_power_saving_flags()		\
 				,					\
@@ -169,7 +169,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_IDLE_LOAD_BALANCE		\
+				| 1*SD_IDLE_LOAD_BALANCE		\
 				| sd_balance_for_package_power()	\
 				| sd_power_saving_flags()		\
 				,					\
-- 
1.7.1

