Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193Ab2B1SuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:50:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52510 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966021Ab2B1SuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:50:16 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 3/9] arm: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:32 -0800
Message-Id: <367cf464b8ffed274c51573e195da7bb41b6889c.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the function name not the address when possible.

builtin_return_address() gives an address.  When building
a kernel with CONFIG_KALLSYMS, emit the actual function
name not the address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/nwfpe/fpmodule.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/nwfpe/fpmodule.c b/arch/arm/nwfpe/fpmodule.c
index cb7658e..4e729f0 100644
--- a/arch/arm/nwfpe/fpmodule.c
+++ b/arch/arm/nwfpe/fpmodule.c
@@ -147,7 +147,7 @@ void float_raise(signed char flags)
 #ifdef CONFIG_DEBUG_USER
 	if (flags & debug)
  		printk(KERN_DEBUG
-		       "NWFPE: %s[%d] takes exception %08x at %p from %08lx\n",
+		       "NWFPE: %s[%d] takes exception %08x at %pf from %08lx\n",
 		       current->comm, current->pid, flags,
 		       __builtin_return_address(0), GET_USERREG()->ARM_pc);
 #endif
-- 
1.7.8.111.gad25c.dirty

