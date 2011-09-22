Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab1IVHv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 03:51:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61072 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1IVHvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 03:51:23 -0400
From: libfetion@gmail.com
To: jason.wessel@windriver.com, tim.bird@am.sony.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dongdong Deng <libfetion@gmail.com>
Subject: [PATCH] debug_core: Add warn message for CONFIG_DEBUG_RODATA enable
Date: Thu, 22 Sep 2011 15:50:48 +0800
Message-Id: <1316677848-10193-1-git-send-email-libfetion@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <libfetion@gmail.com>

The CONFIG_DEBUG_RODATA will limit KGDB/KDB's set breakpoint function,
and CONFIG_DEBUG_RODATA and CONFIG_KGDB could survive together.

Thus most of new user of KGDB/KDB get the set_breakpoint problem
caused by CONFIG_DEBUG_RODATA, and them have to send mail to
kgdb/kdb's mail-list for help.

This patch just adds an extra printk message to warn above case,
in order to provide some useful diagnostics to kgdb/kdb user.

Signed-off-by: Dongdong Deng <libfetion@gmail.com>
---
 kernel/debug/debug_core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index bad6786..c2d98c1 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -899,6 +899,11 @@ int kgdb_register_io_module(struct kgdb_io *new_dbg_io_ops)
 	if (kgdb_break_asap)
 		kgdb_initial_breakpoint();

+#ifdef CONFIG_DEBUG_RODATA
+	printk(KERN_WARNING "kgdb: May need to disable CONFIG_DEBUG_RODATA"
+			" in order to set breakpoints.\n");
+#endif
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kgdb_register_io_module);
--
1.7.1

