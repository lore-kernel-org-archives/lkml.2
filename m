Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab2JLTo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:44:26 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:44798 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab2JLToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:44:25 -0400
Message-ID: <201210121944.q9CJiOuS012397@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 12 Oct 2012 15:38:54 -0400
Subject: [PATCH] arch/tile: enable interrupts in do_work_pending()
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the called functions expect interrupts to be enabled, and
now one of them has started to warn about it, so make it correct.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 6be7991..4f1a241 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -548,6 +548,9 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 	if (!user_mode(regs))
 		return 0;
 
+	/* Enable interrupts; they are disabled again on return to caller. */
+	local_irq_enable();
+
 	if (thread_info_flags & _TIF_NEED_RESCHED) {
 		schedule();
 		return 1;
-- 
1.7.10.3

