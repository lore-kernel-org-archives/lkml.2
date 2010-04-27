Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0D0SAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:00:47 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:23763 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab0D0SAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:00:44 -0400
X-Spam-Processed: digidescorp.com, Tue, 27 Apr 2010 13:00:44 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1733b75585=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: export assembly functions used by modules
Date: Tue, 27 Apr 2010 13:00:35 -0500
Message-Id: <1272391235-32036-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modules that use copy_{to,from}_user(), memcpy(), and memset() fail to build
in certain circumstances.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
--- a/arch/microblaze/kernel/microblaze_ksyms.c	2010-04-27 10:14:33.000000000 -0500
+++ b/arch/microblaze/kernel/microblaze_ksyms.c	2010-04-27 12:52:08.000000000 -0500
@@ -52,3 +52,13 @@ EXPORT_SYMBOL_GPL(_ebss);
 extern void _mcount(void);
 EXPORT_SYMBOL(_mcount);
 #endif
+
+/*
+ * Assembly functions that may be used (directly or indirectly) by modules
+ */
+EXPORT_SYMBOL(__copy_tofrom_user);
+
+#ifdef CONFIG_OPT_LIB_ASM
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(memmove);
+#endif

