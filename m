Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1DEKVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 06:21:52 -0400
Received: from smtp.nokia.com ([147.243.128.24]:30813 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab1DEKVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 06:21:49 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2 1/2] Kconfig: improve KALLSYMS_ALL documentation
Date: Tue,  5 Apr 2011 13:24:57 +0300
Message-Id: <1301999098-21412-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Dumb users like myself are not able to grasp from the existing KALLSYMS_ALL
documentation that this option is not what they need. Improve the help
message and make it clearer that KALLSYMS is enough in the majority of
use cases, and KALLSYMS_ALL should really be used very rarely.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 init/Kconfig |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

Changelog:
v1->v2:
	* Spelling fix

diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..563065d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -968,12 +968,18 @@ config KALLSYMS_ALL
 	bool "Include all symbols in kallsyms"
 	depends on DEBUG_KERNEL && KALLSYMS
 	help
-	   Normally kallsyms only contains the symbols of functions, for nicer
-	   OOPS messages.  Some debuggers can use kallsyms for other
-	   symbols too: say Y here to include all symbols, if you need them 
-	   and you don't care about adding 300k to the size of your kernel.
-
-	   Say N.
+	   Normally kallsyms only contains the symbols of functions for nicer
+	   OOPS messages and backtraces (i.e., symbols from the text and inittext
+	   sections). This is sufficient for most cases. And only in very rare
+	   cases (e.g., when a debugger is used) all symbols are required (e.g.,
+	   names of variables from the data sections, etc).
+
+	   This option makes sure that all symbols are loaded into the kernel
+	   image (i.e., symbols from all sections) in cost of increased kernel
+	   size (depending on the kernel configuration, it may be 300KiB or
+	   something like this).
+
+	   Say N unless you really need all symbols.
 
 config KALLSYMS_EXTRA_PASS
 	bool "Do an extra kallsyms pass"
-- 
1.7.2.3

