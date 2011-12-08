Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1LHAgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:36:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:9661 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab1LHAgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:36:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83422190"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] panic: Don't print redundant backtraces on oops
Date: Wed,  7 Dec 2011 16:36:43 -0800
Message-Id: <1323304603-27895-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When an oops causes a panic and panic prints another backtrace it's
pretty common to have the original oops data be scrolled away on a 80x50
screen.

The second backtrace is quite redundant and not needed anyways.

So don't print the panic backtrace when oops_in_progress is true.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/panic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b2659360..398412b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -78,7 +78,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-	dump_stack();
+	if (!oops_in_progress)
+		dump_stack();
 #endif
 
 	/*
-- 
1.7.4.4

