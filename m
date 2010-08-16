Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0HPVHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:07:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:34512 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab0HPVHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:07:42 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Eric Miao <eric.y.miao@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/5] arm,kgdb: fix GDB_MAX_REGS no longer used
Date: Mon, 16 Aug 2010 16:06:27 -0500
Message-Id: <1281992789-2471-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281992789-2471-3-git-send-email-jason.wessel@windriver.com>
References: <1281992789-2471-1-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-2-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Aug 2010 21:06:37.0322 (UTC) FILETIME=[EA224EA0:01CB3D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.y.miao@gmail.com>

According to commit 22eeef4bb2a7fd225089c0044060ed1fbf091958

    kgdb,arm: Individual register get/set for arm

It's now replaced by DBG_MAX_REG_NUM.

Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/arm/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index 778c2f7..d6e8b4d 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -79,7 +79,7 @@ sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *task)
 		return;
 
 	/* Initialize to zero */
-	for (regno = 0; regno < GDB_MAX_REGS; regno++)
+	for (regno = 0; regno < DBG_MAX_REG_NUM; regno++)
 		gdb_regs[regno] = 0;
 
 	/* Otherwise, we have only some registers from switch_to() */
-- 
1.6.3.3

