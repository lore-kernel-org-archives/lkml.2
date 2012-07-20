Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2GTBFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:05:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40326 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2GTBFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:05:15 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com
Subject: [PATCH 6/7] x86/boot: Exclude early_serial_console.c if can't use it.
Date: Thu, 19 Jul 2012 18:04:41 -0700
Message-Id: <1342746282-28497-7-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes early_serial_console.c code if we don't have the config option that
enables it (EARLY_PRINTK). When disabling this code, make early_serial_base a
constant 0 to allow the compiler to optimize away the code that checks for
early_serial_base.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/boot/compressed/early_serial_console.c |    4 ++++
 arch/x86/boot/compressed/misc.h                 |   10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/boot/compressed/early_serial_console.c b/arch/x86/boot/compressed/early_serial_console.c
index 261e81f..d3d003c 100644
--- a/arch/x86/boot/compressed/early_serial_console.c
+++ b/arch/x86/boot/compressed/early_serial_console.c
@@ -1,5 +1,9 @@
 #include "misc.h"
 
+#ifdef CONFIG_EARLY_PRINTK
+
 int early_serial_base;
 
 #include "../early_serial_console.c"
+
+#endif
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 618e5c8..3ffee6e 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -43,7 +43,17 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 
 /* early_serial_console.c */
+#ifdef CONFIG_EARLY_PRINTK
+
 extern int early_serial_base;
 void console_init(void);
 
+#else
+
+static const int early_serial_base;
+static inline void console_init(void)
+{ }
+
+#endif
+
 #endif
-- 
1.7.9.5

