Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2CLXjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:39:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2CLXjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:39:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/35] Split arch_align_stack() out from asm-generic/system.h
 [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 12 Mar 2012 23:39:35 +0000
Message-ID: <20120312233935.13888.29261.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split arch_align_stack() out from asm-generic/system.h into its own header of
asm-generic/exec.h as part of the asm/system.h disintegration.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>
---

 include/asm-generic/exec.h   |   19 +++++++++++++++++++
 include/asm-generic/system.h |   22 ++--------------------
 2 files changed, 21 insertions(+), 20 deletions(-)
 create mode 100644 include/asm-generic/exec.h

diff --git a/include/asm-generic/exec.h b/include/asm-generic/exec.h
new file mode 100644
index 0000000..567766b
--- /dev/null
+++ b/include/asm-generic/exec.h
@@ -0,0 +1,19 @@
+/* Generic process execution definitions, based on MN10300 definitions.
+ *
+ * It should be possible to use these on really simple architectures,
+ * but it serves more as a starting point for new ports.
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef __ASM_GENERIC_EXEC_H
+#define __ASM_GENERIC_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* __ASM_GENERIC_EXEC_H */
diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
index f2b8eb4..a7f4057 100644
--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -1,23 +1,5 @@
-/* Generic system definitions, based on MN10300 definitions.
- *
- * It should be possible to use these on really simple architectures,
- * but it serves more as a starting point for new ports.
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef __ASM_GENERIC_SYSTEM_H
-#define __ASM_GENERIC_SYSTEM_H
-
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
 #include <asm/barrier.h>
 #include <asm/cmpxchg.h>
+#include <asm/exec.h>
 #include <asm/switch_to.h>
-
-#define arch_align_stack(x) (x)
-
-#endif /* __ASM_GENERIC_SYSTEM_H */

