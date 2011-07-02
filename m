Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1GBVzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:55:41 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:48220 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755892Ab1GBVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:55:30 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] xtensa: there is no CONFIG_UNALIGNED_USER
Date: Sun,  3 Jul 2011 00:47:52 +0300
Message-Id: <1309643272-364-8-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309643272-364-7-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-5-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-6-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-7-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is, however, CONFIG_XTENSE_UNALIGNED_USER.

Part of a shotgun patchset; found by greps, seds, and diffs
rather than actual understanding.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/xtensa/kernel/traps.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index e64efac..993c0dd 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -97,7 +97,7 @@ static dispatch_init_table_t __initdata dispatch_init_table[] = {
 /* EXCCAUSE_INTEGER_DIVIDE_BY_ZERO unhandled */
 /* EXCCAUSE_PRIVILEGED unhandled */
 #if XCHAL_UNALIGNED_LOAD_EXCEPTION || XCHAL_UNALIGNED_STORE_EXCEPTION
-#ifdef CONFIG_UNALIGNED_USER
+#ifdef CONFIG_XTENSA_UNALIGNED_USER
 { EXCCAUSE_UNALIGNED,		USER,	   fast_unaligned },
 #else
 { EXCCAUSE_UNALIGNED,		0,	   do_unaligned_user },
@@ -239,12 +239,12 @@ do_illegal_instruction(struct pt_regs *regs)
 /*
  * Handle unaligned memory accesses from user space. Kill task.
  *
- * If CONFIG_UNALIGNED_USER is not set, we don't allow unaligned memory
+ * If CONFIG_XTENSA_UNALIGNED_USER is not set, we don't allow unaligned memory
  * accesses causes from user space.
  */
 
 #if XCHAL_UNALIGNED_LOAD_EXCEPTION || XCHAL_UNALIGNED_STORE_EXCEPTION
-#ifndef CONFIG_UNALIGNED_USER
+#ifndef CONFIG_XTENSA_UNALIGNED_USER
 void
 do_unaligned_user (struct pt_regs *regs)
 {
-- 
1.7.2.5

