Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2LNSmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:42:39 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51999 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab2LNSmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:42:32 -0500
Subject: [RFC][PATCH 1/7] move debugfs to filesystems menu (fs/Kconfig)
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 13:42:01 -0500
References: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
In-Reply-To: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
Message-Id: <20121214184201.2D87BED3@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121418-9360-0000-0000-00000DF53A7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


debugfs may have started out as a kernel hacking kind of option.  But,
today, it is an integral part of lots of facilities like tracing that
are far from kernel hacking.  Let's move it out of the very cluttered
"Kernel Hacking" menu and but it next to its real family: other
filesystems like sysfs, configfs, or /proc.

Also, "Debug filesystem" sounds like a debugging option _for_
filesystems code, not a filesystem for debugging.  We also never call
it "the debug filesystem."  We always say "debugfs", so reflect the
fact that we _call_ it debugfs in the menu text.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/Kconfig        |   12 ++++++++++++
 linux-2.6.git-dave/lib/Kconfig.debug |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN lib/Kconfig.debug~be-clear-about-debugfs lib/Kconfig.debug
--- linux-2.6.git/lib/Kconfig.debug~be-clear-about-debugfs	2012-12-14 13:32:20.782780277 -0500
+++ linux-2.6.git-dave/lib/Kconfig.debug	2012-12-14 13:32:22.890797974 -0500
@@ -99,18 +99,6 @@ config UNUSED_SYMBOLS
 	  you really need it, and what the merge plan to the mainline kernel for
 	  your module is.
 
-config DEBUG_FS
-	bool "Debug Filesystem"
-	help
-	  debugfs is a virtual file system that kernel developers use to put
-	  debugging files into.  Enable this option to be able to read and
-	  write to these files.
-
-	  For detailed documentation on the debugfs API, see
-	  Documentation/DocBook/filesystems.
-
-	  If unsure, say N.
-
 config HEADERS_CHECK
 	bool "Run 'make headers_check' when building vmlinux"
 	depends on !UML
diff -puN fs/Kconfig~be-clear-about-debugfs fs/Kconfig
--- linux-2.6.git/fs/Kconfig~be-clear-about-debugfs	2012-12-14 13:32:20.782780277 -0500
+++ linux-2.6.git-dave/fs/Kconfig	2012-12-14 13:32:22.890797974 -0500
@@ -176,6 +176,18 @@ config HUGETLBFS
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
+config DEBUG_FS
+	bool "Debug Filesystem (debugfs)"
+	help
+	  debugfs is a virtual file system that kernel developers use to put
+	  debugging files into.  Enable this option to be able to read and
+	  write to these files.
+
+	  For detailed documentation on the debugfs API, see
+	  Documentation/DocBook/filesystems.
+
+	  If unsure, say N.
+
 source "fs/configfs/Kconfig"
 
 endmenu
_

