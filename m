Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2E1Qhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:37:41 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:43093 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2E1Qhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:37:37 -0400
Date: Mon, 28 May 2012 18:37:14 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH V2 1/6] sizes.h: move from asm-generic to <linux/sizes.h>
Message-ID: <3c8248fcd1d73fa0a070a673b83a4772bb3ca0c1.1338222461.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1338222460.git.rubini@gnudd.com>
In-Reply-To: <cover.1338222460.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizes.h is used throughout the AMBA code and drivers, so the header
should be available to everyone in order to driver AMBA/PrimeCell
peripherals behind a PCI bridge where the host can be any platform
(I'm doing it under x86).

At this step <asm-generic/sizes.h> includes <linux/sizes.h>,
to allow a grace period for both in-tree and out-of-tree drivers.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
---
 include/asm-generic/sizes.h |   49 +-----------------------------------------
 include/linux/sizes.h       |   47 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 47 deletions(-)
 create mode 100644 include/linux/sizes.h

diff --git a/include/asm-generic/sizes.h b/include/asm-generic/sizes.h
index ea5d4ef..1dcfad9 100644
--- a/include/asm-generic/sizes.h
+++ b/include/asm-generic/sizes.h
@@ -1,47 +1,2 @@
-/*
- * linux/include/asm-generic/sizes.h
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ASM_GENERIC_SIZES_H__
-#define __ASM_GENERIC_SIZES_H__
-
-#define SZ_1				0x00000001
-#define SZ_2				0x00000002
-#define SZ_4				0x00000004
-#define SZ_8				0x00000008
-#define SZ_16				0x00000010
-#define SZ_32				0x00000020
-#define SZ_64				0x00000040
-#define SZ_128				0x00000080
-#define SZ_256				0x00000100
-#define SZ_512				0x00000200
-
-#define SZ_1K				0x00000400
-#define SZ_2K				0x00000800
-#define SZ_4K				0x00001000
-#define SZ_8K				0x00002000
-#define SZ_16K				0x00004000
-#define SZ_32K				0x00008000
-#define SZ_64K				0x00010000
-#define SZ_128K				0x00020000
-#define SZ_256K				0x00040000
-#define SZ_512K				0x00080000
-
-#define SZ_1M				0x00100000
-#define SZ_2M				0x00200000
-#define SZ_4M				0x00400000
-#define SZ_8M				0x00800000
-#define SZ_16M				0x01000000
-#define SZ_32M				0x02000000
-#define SZ_64M				0x04000000
-#define SZ_128M				0x08000000
-#define SZ_256M				0x10000000
-#define SZ_512M				0x20000000
-
-#define SZ_1G				0x40000000
-#define SZ_2G				0x80000000
-
-#endif /* __ASM_GENERIC_SIZES_H__ */
+/* This is a placeholder, to be removed over time */
+#include <linux/sizes.h>
diff --git a/include/linux/sizes.h b/include/linux/sizes.h
new file mode 100644
index 0000000..ce3e815
--- /dev/null
+++ b/include/linux/sizes.h
@@ -0,0 +1,47 @@
+/*
+ * include/linux/sizes.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __LINUX_SIZES_H__
+#define __LINUX_SIZES_H__
+
+#define SZ_1				0x00000001
+#define SZ_2				0x00000002
+#define SZ_4				0x00000004
+#define SZ_8				0x00000008
+#define SZ_16				0x00000010
+#define SZ_32				0x00000020
+#define SZ_64				0x00000040
+#define SZ_128				0x00000080
+#define SZ_256				0x00000100
+#define SZ_512				0x00000200
+
+#define SZ_1K				0x00000400
+#define SZ_2K				0x00000800
+#define SZ_4K				0x00001000
+#define SZ_8K				0x00002000
+#define SZ_16K				0x00004000
+#define SZ_32K				0x00008000
+#define SZ_64K				0x00010000
+#define SZ_128K				0x00020000
+#define SZ_256K				0x00040000
+#define SZ_512K				0x00080000
+
+#define SZ_1M				0x00100000
+#define SZ_2M				0x00200000
+#define SZ_4M				0x00400000
+#define SZ_8M				0x00800000
+#define SZ_16M				0x01000000
+#define SZ_32M				0x02000000
+#define SZ_64M				0x04000000
+#define SZ_128M				0x08000000
+#define SZ_256M				0x10000000
+#define SZ_512M				0x20000000
+
+#define SZ_1G				0x40000000
+#define SZ_2G				0x80000000
+
+#endif /* __LINUX_SIZES_H__ */
-- 
1.7.7.2
