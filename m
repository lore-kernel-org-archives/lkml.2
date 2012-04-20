Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2DTVbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:31:38 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62744 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab2DTVaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:30:11 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@redhat.com>, <masami.hiramatsu.pt@hitachi.com>,
        <rusty@rustcorp.com.au>
Subject: [RFC PATCH 8/8] kallsyms,modules: add module_address_line_lookup() to kallsyms_line_loc_lookup()
Date: Fri, 20 Apr 2012 16:29:54 -0500
Message-ID: <1334957394-12086-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch connects the kallsyms line location lookups into also
asking for lines for locations information from kernel modules.

The kernel module subsystem can provide line location information
independently of the core kernel and is in no way dependent on the
core kernel being able to lookup line information when
CONFIG_KALLSYMS_LINE_LOCATIONS=y.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kallsyms.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 921f2b3..6300c70 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -295,7 +295,7 @@ int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
 
 #ifdef CONFIG_KALLSYMS_LINE_LOCATIONS
 /*
- * Lookup an address
+ * Lookup a line location address in the kernel or or a kernel module
  * - modname is set to NULL if it's in the kernel.
  * - We guarantee that the returned name is valid until we reschedule even if.
  *   It resides in a module.
@@ -322,7 +322,8 @@ const char *kallsyms_line_loc_lookup(unsigned long addr,
 		return namebuf;
 	}
 
-	return NULL;
+	return module_address_line_lookup(addr, symbolsize, offset, modname,
+					  namebuf);
 }
 #else /* !CONFIG_KALLSYMS_LINE_LOCATIONS */
 const char *kallsyms_line_loc_lookup(unsigned long addr,
@@ -330,7 +331,8 @@ const char *kallsyms_line_loc_lookup(unsigned long addr,
 			    unsigned long *offset,
 			    char **modname, char *namebuf)
 {
-	return NULL;
+	return module_address_line_lookup(addr, symbolsize, offset, modname,
+					  namebuf);
 }
 #endif /* CONFIG_KALLSYMS_LINE_LOCATIONS */
 
-- 
1.7.10

