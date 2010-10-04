Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0JDRO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:14:28 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:63105 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958Ab0JDRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:14:27 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Subject: [PATCH] OLPC: register XO-1 RF kill device
Message-Id: <20101004171419.E3F3E9D401B@zog.reactivated.net>
Date: Mon,  4 Oct 2010 18:14:19 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=hScSH-Q7Y2sA:10 a=Op-mwl0xAAAA:8 a=tezwERfGHUktJ1XZMyYA:9 a=TsixwKu1dwXQRo0Shyghg7Hpiw4A:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The upcoming XO-1 rfkill driver (for drivers/platform/x86) will register
itself with the name "xo1-rfkill"

Add the necessary mechanics so that this is properly probed and
initialized on XO-1 laptops.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/kernel/olpc.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 37c49934..d57f26a 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/string.h>
+#include <linux/platform_device.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -248,6 +249,15 @@ static int __init olpc_init(void)
 			olpc_platform_info.boardrev >> 4,
 			olpc_platform_info.ecver);
 
+	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0)) { /* XO-1 */
+		struct platform_device *pdev;
+
+		/* register any relevant platform devices */
+		pdev = platform_device_register_simple("xo1-rfkill", -1, NULL, 0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
+
 	return 0;
 }
 
-- 
1.7.2.3

