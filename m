Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab0HEPQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:16:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:52412 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210Ab0HEPQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:16:09 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: gregkh@suse.de
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        akpm@linux-foundation.org
Subject: [PATCH 1/3] driver core: Add ability for arch code to setup pdev_archdata
Date: Thu,  5 Aug 2010 10:15:45 -0500
Message-Id: <1281021347-1278-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org>
References: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures we need to setup pdev_archdata before we add the
device.  Waiting til a bus_notifier is too late since we might need the
pdev_archdata in the bus notifier.  One example is setting up of dma_mask
pointers such that it can be used in a bus_notifier.

We add ARCH_HAS_PDEV_ARCHDATA_SETUP and a dummy <asm/platform_device.h>
header to allow the arch code to have an inline implementation of
arch_setup_pdev_archdata() and being able to access the full definitions
of struct device, struct platform_device, and struct pdev_archdata.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/alpha/include/asm/platform_device.h      |    1 +
 arch/arm/include/asm/platform_device.h        |    1 +
 arch/avr32/include/asm/platform_device.h      |    1 +
 arch/blackfin/include/asm/platform_device.h   |    1 +
 arch/cris/include/asm/platform_device.h       |    1 +
 arch/frv/include/asm/platform_device.h        |    1 +
 arch/h8300/include/asm/platform_device.h      |    1 +
 arch/ia64/include/asm/platform_device.h       |    1 +
 arch/m32r/include/asm/platform_device.h       |    1 +
 arch/m68k/include/asm/platform_device.h       |    1 +
 arch/microblaze/include/asm/platform_device.h |    1 +
 arch/mips/include/asm/platform_device.h       |    1 +
 arch/mn10300/include/asm/platform_device.h    |    1 +
 arch/parisc/include/asm/platform_device.h     |    1 +
 arch/powerpc/include/asm/platform_device.h    |    1 +
 arch/s390/include/asm/platform_device.h       |    1 +
 arch/score/include/asm/platform_device.h      |    1 +
 arch/sh/include/asm/platform_device.h         |    1 +
 arch/sparc/include/asm/platform_device.h      |    1 +
 arch/x86/include/asm/platform_device.h        |    1 +
 arch/xtensa/include/asm/platform_device.h     |    1 +
 drivers/base/platform.c                       |    4 ++++
 include/asm-generic/platform_device.h         |    7 +++++++
 23 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 arch/alpha/include/asm/platform_device.h
 create mode 100644 arch/arm/include/asm/platform_device.h
 create mode 100644 arch/avr32/include/asm/platform_device.h
 create mode 100644 arch/blackfin/include/asm/platform_device.h
 create mode 100644 arch/cris/include/asm/platform_device.h
 create mode 100644 arch/frv/include/asm/platform_device.h
 create mode 100644 arch/h8300/include/asm/platform_device.h
 create mode 100644 arch/ia64/include/asm/platform_device.h
 create mode 100644 arch/m32r/include/asm/platform_device.h
 create mode 100644 arch/m68k/include/asm/platform_device.h
 create mode 100644 arch/microblaze/include/asm/platform_device.h
 create mode 100644 arch/mips/include/asm/platform_device.h
 create mode 100644 arch/mn10300/include/asm/platform_device.h
 create mode 100644 arch/parisc/include/asm/platform_device.h
 create mode 100644 arch/powerpc/include/asm/platform_device.h
 create mode 100644 arch/s390/include/asm/platform_device.h
 create mode 100644 arch/score/include/asm/platform_device.h
 create mode 100644 arch/sh/include/asm/platform_device.h
 create mode 100644 arch/sparc/include/asm/platform_device.h
 create mode 100644 arch/x86/include/asm/platform_device.h
 create mode 100644 arch/xtensa/include/asm/platform_device.h
 create mode 100644 include/asm-generic/platform_device.h

diff --git a/arch/alpha/include/asm/platform_device.h b/arch/alpha/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/alpha/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/arm/include/asm/platform_device.h b/arch/arm/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/arm/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/avr32/include/asm/platform_device.h b/arch/avr32/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/avr32/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/blackfin/include/asm/platform_device.h b/arch/blackfin/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/blackfin/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/cris/include/asm/platform_device.h b/arch/cris/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/cris/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/frv/include/asm/platform_device.h b/arch/frv/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/frv/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/h8300/include/asm/platform_device.h b/arch/h8300/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/h8300/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/ia64/include/asm/platform_device.h b/arch/ia64/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/ia64/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/m32r/include/asm/platform_device.h b/arch/m32r/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/m32r/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/m68k/include/asm/platform_device.h b/arch/m68k/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/m68k/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/microblaze/include/asm/platform_device.h b/arch/microblaze/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/microblaze/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/mips/include/asm/platform_device.h b/arch/mips/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/mips/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/mn10300/include/asm/platform_device.h b/arch/mn10300/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/mn10300/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/parisc/include/asm/platform_device.h b/arch/parisc/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/parisc/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/powerpc/include/asm/platform_device.h b/arch/powerpc/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/powerpc/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/s390/include/asm/platform_device.h b/arch/s390/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/s390/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/score/include/asm/platform_device.h b/arch/score/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/score/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/sh/include/asm/platform_device.h b/arch/sh/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/sh/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/sparc/include/asm/platform_device.h b/arch/sparc/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/sparc/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/x86/include/asm/platform_device.h b/arch/x86/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/x86/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/arch/xtensa/include/asm/platform_device.h b/arch/xtensa/include/asm/platform_device.h
new file mode 100644
index 0000000..01452c3
--- /dev/null
+++ b/arch/xtensa/include/asm/platform_device.h
@@ -0,0 +1 @@
+#include <asm-generic/platform_device.h>
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4d99c8b..165b454 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -19,6 +19,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <asm/platform_device.h>
 
 #include "base.h"
 
@@ -170,6 +171,9 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 		pa->pdev.id = id;
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
+#ifdef ARCH_HAS_PDEV_ARCHDATA_SETUP
+		arch_setup_pdev_archdata(&pa->pdev);
+#endif
 	}
 
 	return pa ? &pa->pdev : NULL;
diff --git a/include/asm-generic/platform_device.h b/include/asm-generic/platform_device.h
new file mode 100644
index 0000000..64806dc
--- /dev/null
+++ b/include/asm-generic/platform_device.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_GENERIC_PLATFORM_DEVICE_H_
+#define __ASM_GENERIC_PLATFORM_DEVICE_H_
+/*
+ * an architecture can override to define arch_setup_pdev_archdata
+ */
+
+#endif /* __ASM_GENERIC_PLATFORM_DEVICE_H_ */
-- 
1.6.0.6

