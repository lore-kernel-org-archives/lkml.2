Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2GVA6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 20:58:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2GVA6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 20:58:32 -0400
Date: Sat, 21 Jul 2012 17:58:18 -0700
From: tip-bot for Joe Millenbach <jmillenbach@gmail.com>
Message-ID: <tip-cec49df9d331feaa2fea3d24c07147c7659940d1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        caushik1@gmail.com, jmillenbach@gmail.com, josh@joshtriplett.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmillenbach@gmail.com, caushik1@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org
In-Reply-To: <1342746282-28497-7-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-7-git-send-email-jmillenbach@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Exclude early_serial_console.c if can'
 t use it.
Git-Commit-ID: cec49df9d331feaa2fea3d24c07147c7659940d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jul 2012 17:58:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cec49df9d331feaa2fea3d24c07147c7659940d1
Gitweb:     http://git.kernel.org/tip/cec49df9d331feaa2fea3d24c07147c7659940d1
Author:     Joe Millenbach <jmillenbach@gmail.com>
AuthorDate: Thu, 19 Jul 2012 18:04:41 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 21 Jul 2012 11:07:34 -0700

x86, boot: Exclude early_serial_console.c if can't use it.

Removes early_serial_console.c code if we don't have the config option that
enables it (EARLY_PRINTK). When disabling this code, make early_serial_base a
constant 0 to allow the compiler to optimize away the code that checks for
early_serial_base.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Link: http://lkml.kernel.org/r/1342746282-28497-7-git-send-email-jmillenbach@gmail.com
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/early_serial_console.c |    4 ++++
 arch/x86/boot/compressed/misc.h                 |   10 ++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

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
