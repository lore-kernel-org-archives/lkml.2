Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0J3VV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:21:27 -0400
Received: from mail.perches.com ([173.55.12.10]:3842 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab0J3VVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:21:25 -0400
Subject: [PATCH] arch/arm/kernel/hw_breakpoint.c: Convert WARN_ON to WARN
From: Joe Perches <joe@perches.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 14:21:24 -0700
Message-ID: <1288473684.366.139.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message isn't printed by WARN_ON.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/kernel/hw_breakpoint.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 54593b0..21e3a4a 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -748,8 +748,7 @@ static int hw_breakpoint_pending(unsigned long addr, unsigned int fsr,
 		breakpoint_handler(addr, regs);
 		break;
 	case ARM_ENTRY_ASYNC_WATCHPOINT:
-		WARN_ON("Asynchronous watchpoint exception taken. "
-			"Debugging results may be unreliable");
+		WARN(1, "Asynchronous watchpoint exception taken. Debugging results may be unreliable\n");
 	case ARM_ENTRY_SYNC_WATCHPOINT:
 		watchpoint_handler(addr, regs);
 		break;


