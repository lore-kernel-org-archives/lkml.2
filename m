Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2LYNZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 08:25:12 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60906 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2LYNZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 08:25:08 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] alpha: Fix compile error "unused variable 'settls'
Date: Tue, 25 Dec 2012 22:24:46 +0900
Message-Id: <1356441886-8475-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.1.rc2.38.gb10c4ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compile error.
+ arch/alpha/kernel/process.c: warning: unused variable 'settls': => 253

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/alpha/kernel/process.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index a4dc79ba..f8d8f3b 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -275,7 +275,6 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 	struct pt_regs *childregs = task_pt_regs(p);
 	struct pt_regs *regs = current_pt_regs();
 	struct switch_stack *childstack, *stack;
-	unsigned long settls;
 
 	childstack = ((struct switch_stack *) childregs) - 1;
 	childti->pcb.ksp = (unsigned long) childstack;
-- 
1.8.1.rc2.38.gb10c4ad

