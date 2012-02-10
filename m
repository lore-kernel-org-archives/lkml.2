Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab2BJLZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:25:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759179Ab2BJLZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:25:52 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] unwind, kconfig: Adding UNWIND* options
Date: Fri, 10 Feb 2012 12:25:15 +0100
Message-Id: <1328873119-21553-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding following config options:

CONFIG_UNWIND
- governs wether the unwind code is compiled in

CONFIG_UNWIND_EH_FRAME
- source of unwind data - eh_frame_hdr/eh_frame

CONFIG_UNWIND_DEBUG_FRAME
- source of unwind data - .debug.frame
---
 arch/x86/Kconfig.debug |    2 ++
 kernel/Kconfig.unwind  |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 kernel/Kconfig.unwind

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index e46c214..4705ba1 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -299,4 +299,6 @@ config DEBUG_NMI_SELFTEST
 
 	  If unsure, say N.
 
+source "kernel/Kconfig.unwind"
+
 endmenu
diff --git a/kernel/Kconfig.unwind b/kernel/Kconfig.unwind
new file mode 100644
index 0000000..273dc68
--- /dev/null
+++ b/kernel/Kconfig.unwind
@@ -0,0 +1,26 @@
+
+config UNWIND
+	bool "Use compiler information to display backtrace dump"
+	---help---
+	  Adding code allowing to use compiled debug information
+	  for stack unwinding (results in MUCH bigger kernel
+	  and many more panics).
+
+choice
+	prompt "Unwind information source"
+	default UNWIND_EH_FRAME
+	depends on UNWIND
+	---help---
+	  source of unwind information
+
+config UNWIND_EH_FRAME
+	bool "exception frame section"
+	---help---
+	  eh_frame section
+
+config UNWIND_DEBUG_FRAME
+	bool "NOT IMPLEMENTED debug frame section"
+	---help---
+	  debug_frame section
+
+endchoice
-- 
1.7.1

