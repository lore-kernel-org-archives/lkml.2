Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0G3FTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:19:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22966 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0G3FTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:19:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Ua98+F3pjnLZsJy4srdnQWdIwXrN9s4gKvGUVq9GxBCVZSAXYYkfcEZFFP8H5Y/8f
	kPUMLU6qtuU9M6Q6R2CWw==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, Ken Chen <kenchen@google.com>,
        Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 2/6] sched: add SD_IDLE_LOAD_BALANCE to sched domain flags
Date: Thu, 29 Jul 2010 22:19:02 -0700
Message-Id: <1280467146-32218-3-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280467146-32218-1-git-send-email-ncrao@google.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new sched domain flag called SD_IDLE_LOAD_BALANCE. SCHED_IDLE tasks are
balanced by the SCHED_IDLE balancer on this domain when enabled, and are handled
by the SCHED_NORMAL load balancer when disabled.

This patch also adds this flag to sched domain init functions in
include/linux/topology.h and arch/x86/include/asm/topology.h (disabled by
default).

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 arch/x86/include/asm/topology.h |    1 +
 include/linux/sched.h           |    1 +
 include/linux/topology.h        |    4 ++++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 21899cc..9f29b4e 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -150,6 +150,7 @@ extern unsigned long node_remap_size[];
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
+				| 0*SD_IDLE_LOAD_BALANCE		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 747fcae..badf2a7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -806,6 +806,7 @@ enum cpu_idle_type {
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
+#define SD_IDLE_LOAD_BALANCE	0x2000	/* Idle load balance on this domain */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index c44df50..97fbb1b 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -103,6 +103,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
+				| 0*SD_IDLE_LOAD_BALANCE		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
@@ -134,6 +135,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| 0*SD_IDLE_LOAD_BALANCE		\
 				| sd_balance_for_mc_power()		\
 				| sd_power_saving_flags()		\
 				,					\
@@ -167,6 +169,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| 0*SD_IDLE_LOAD_BALANCE		\
 				| sd_balance_for_package_power()	\
 				| sd_power_saving_flags()		\
 				,					\
@@ -195,6 +198,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
+				| 0*SD_IDLE_LOAD_BALANCE		\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 64,					\
-- 
1.7.1

