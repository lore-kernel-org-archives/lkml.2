Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab1FQBNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:13:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:43427 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698Ab1FQBNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:13:48 -0400
Subject: [PATCH 3/5] powerpc/udbg: Register udbg console generically
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 11:08:37 +1000
Message-ID: <1308272917.2516.107.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PPC_EARLY_DEBUG is set, call register_early_udbg_console()
early from generic code.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/udbg.c            |    2 ++
 arch/powerpc/platforms/pseries/lpar.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/udbg.c b/arch/powerpc/kernel/udbg.c
index 23d65ab..a57e61e 100644
--- a/arch/powerpc/kernel/udbg.c
+++ b/arch/powerpc/kernel/udbg.c
@@ -68,6 +68,8 @@ void __init udbg_early_init(void)
 
 #ifdef CONFIG_PPC_EARLY_DEBUG
 	console_loglevel = 10;
+
+	register_early_udbg_console();
 #endif
 }
 
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 39e6e0a..e3a96c4 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -193,8 +193,6 @@ void __init udbg_init_debug_lpar(void)
 	udbg_putc = udbg_putcLP;
 	udbg_getc = udbg_getcLP;
 	udbg_getc_poll = udbg_getc_pollLP;
-
-	register_early_udbg_console();
 }
 
 /* returns 0 if couldn't find or use /chosen/stdout as console */


