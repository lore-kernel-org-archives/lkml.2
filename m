Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0EDQBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:01:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57286 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab0EDQBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bKl/rGkiaFsT06fs0iVVKY6ofDLP2o2lZFhGZ4BiBlCDCst6H90WFvI6Nq4XtNeV6n
         3BXR9s/DO6Q1391Sg0kwrdClLo22+RLUn3/UZjXnHUuSCpivkVKT6PdOVv+NRQ8oaMh0
         my8w4f/vdcUQgfWIixsoZb7lzA2IxBINt7ai4=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] kernel:fork: fix dependency of hardirqs_enabled and softirqs_enabled
Date: Wed,  5 May 2010 00:01:12 +0800
Message-Id: <1272988872-2347-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

The defination of hardirqs_enabled and softirqs_enabled in task_struct
depends on CONFIG_TRACE_IRQFLAGS instead of CONFIG_PROVE_LOCKING.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 44b0791..038a8fd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1004,7 +1004,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	rt_mutex_init_task(p);
 
-#ifdef CONFIG_PROVE_LOCKING
+#ifdef CONFIG_TRACE_IRQFLAGS
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
-- 
1.6.2.5

