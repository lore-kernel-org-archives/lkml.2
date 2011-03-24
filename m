Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1CXFyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:54:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51192 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1CXFyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:54:38 -0400
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH] sh: Fix build alloc_thread_info_node function
Date: Thu, 24 Mar 2011 14:47:40 +0900
Message-Id: <1300945660-8323-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By commit b6a84016bd2598e35ead635147fa53619982648d,
alloc_thread_info was replaced by alloc_thread_info_node.
However, the change of the function name and the addition of the argument
were incomplete.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>
---
 arch/sh/kernel/process.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
index f39ad57..325f98b 100644
--- a/arch/sh/kernel/process.c
+++ b/arch/sh/kernel/process.c
@@ -32,7 +32,7 @@ void free_thread_xstate(struct task_struct *tsk)
 #if THREAD_SHIFT < PAGE_SHIFT
 static struct kmem_cache *thread_info_cache;
 
-struct thread_info *alloc_thread_info(struct task_struct *tsk, int node)
+struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
 {
 	struct thread_info *ti;
 #ifdef CONFIG_DEBUG_STACK_USAGE
@@ -57,7 +57,7 @@ void thread_info_cache_init(void)
 					      THREAD_SIZE, SLAB_PANIC, NULL);
 }
 #else
-struct thread_info *alloc_thread_info(struct task_struct *tsk)
+struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
 {
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
-- 
1.7.2.3

