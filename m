Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab2INLO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:14:29 -0400
Received: from smtp.citrix.com ([66.165.176.89]:2549 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab2INLOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:14:03 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="37873001"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 05/24] xen/arm: empty implementation of grant_table arch specific functions
Date: Fri, 14 Sep 2012 12:13:07 +0100
Message-ID: <1347621207-11294-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:

- return -ENOSYS rather than -1.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/xen/Makefile      |    2 +-
 arch/arm/xen/grant-table.c |   53 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/xen/grant-table.c

diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
index b9d6acc..4384103 100644
--- a/arch/arm/xen/Makefile
+++ b/arch/arm/xen/Makefile
@@ -1 +1 @@
-obj-y		:= enlighten.o hypercall.o
+obj-y		:= enlighten.o hypercall.o grant-table.o
diff --git a/arch/arm/xen/grant-table.c b/arch/arm/xen/grant-table.c
new file mode 100644
index 0000000..dbd1330
--- /dev/null
+++ b/arch/arm/xen/grant-table.c
@@ -0,0 +1,53 @@
+/******************************************************************************
+ * grant_table.c
+ * ARM specific part
+ *
+ * Granting foreign access to our memory reservation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <xen/interface/xen.h>
+#include <xen/page.h>
+#include <xen/grant_table.h>
+
+int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
+			   unsigned long max_nr_gframes,
+			   void **__shared)
+{
+	return -ENOSYS;
+}
+
+void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
+{
+	return;
+}
+
+int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
+			   unsigned long max_nr_gframes,
+			   grant_status_t **__shared)
+{
+	return -ENOSYS;
+}
-- 
1.7.2.5

