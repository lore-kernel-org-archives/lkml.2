Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1HAAii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:38:38 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:45883 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1HAAia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:38:30 -0400
Date: Sun, 31 Jul 2011 20:36:03 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz, rdunlap@xenotime.net, lacombar@gmail.com
Subject: [PATCH RFC] kconfig.h fix extraneous dependencies
Message-id: <alpine.LNX.2.00.1107311812460.62769@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of kconfig.h caused fixdep to create three extraneous 
dependencies.
include/config/.h
include/config/h.h
include/config/foo.h

Remove them by eliminating instances of CONFIG_

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---

Suggestions for a better replacement for CONFIG_FOO would be appreciated.

diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
index 067eda0..66a0659 100644
--- a/include/linux/kconfig.h
+++ b/include/linux/kconfig.h
@@ -1,15 +1,15 @@
-#ifndef __LINUX_KCONFIG_H
-#define __LINUX_KCONFIG_H
+#ifndef __LINUX_KCONFIG
+#define __LINUX_KCONFIG
 
 #include <generated/autoconf.h>
 
 /*
- * Helper macros to use CONFIG_ options in C expressions. Note that
+ * Helper macros to use CONFIG options in C expressions. Note that
  * these only work with boolean and tristate options.
  */
 
 /*
- * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
+ * IS_ENABLED(CONFIG _FOO) evaluates to 1 if CONFIG _FOO is set to 'y' or 'm',
  * 0 otherwise.
  *
  */
@@ -17,16 +17,16 @@
 	(__enabled_ ## option || __enabled_ ## option ## _MODULE)
 
 /*
- * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
+ * IS_BUILTIN(CONFIG _FOO) evaluates to 1 if CONFIG _FOO is set to 'y', 0
  * otherwise. For boolean options, this is equivalent to
- * IS_ENABLED(CONFIG_FOO).
+ * IS_ENABLED(CONFIG _FOO).
  */
 #define IS_BUILTIN(option) __enabled_ ## option
 
 /*
- * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
+ * IS_MODULE(CONFIG _FOO) evaluates to 1 if CONFIG _FOO is set to 'm', 0
  * otherwise.
  */
 #define IS_MODULE(option) __enabled_ ## option ## _MODULE
 
-#endif /* __LINUX_KCONFIG_H */
+#endif /* __LINUX_KCONFIG */
