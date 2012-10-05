Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2JERqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:46:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43000 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2JERqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:46:02 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH] Partially revert a1ce39288e6fbef (UAPI: (Scripted) Convert #include "..." to #include <path/...> in kernel system headers)
Date: Fri,  5 Oct 2012 10:45:30 -0700
Message-Id: <1349459130-4367-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Syntax errors were introduced into include/linux/libfdt.h by the
offending commit, revert the changes made to this file.  The kernel
again compiles, thus restoring harmony and balance to the universe.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>
---
 include/linux/libfdt.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/libfdt.h b/include/linux/libfdt.h
index a0c3bf6..4c0306c 100644
--- a/include/linux/libfdt.h
+++ b/include/linux/libfdt.h
@@ -2,7 +2,7 @@
 #define _INCLUDE_LIBFDT_H_
 
 #include <linux/libfdt_env.h>
-#include <>
-#include <>
+#include "../../scripts/dtc/libfdt/fdt.h"
+#include "../../scripts/dtc/libfdt/libfdt.h"
 
 #endif /* _INCLUDE_LIBFDT_H_ */
-- 
1.7.11.4

