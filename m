Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2LJNoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:44:13 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:35729 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab2LJNoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:44:12 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH v4 2/7] pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
Date: Mon, 10 Dec 2012 14:42:31 +0100
Message-Id: <1355146956-6009-3-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>

The header is used by drivers/dma/amba-pl08x.c, which can be compiled
under x86, where PL080 exists under a PCI-to-AMBA bridge. This patche
moves it where it can be accessed by other architectures, and fixes
all users.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/arm/mach-s3c64xx/dma.c                                   |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c                             |    2 +-
 arch/arm/mach-spear6xx/spear6xx.c                             |    2 +-
 drivers/dma/amba-pl08x.c                                      |    2 +-
 {arch/arm/include/asm/hardware => include/linux/amba}/pl080.h |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)
 rename {arch/arm/include/asm/hardware => include/linux/amba}/pl080.h (99%)

diff --git a/arch/arm/mach-s3c64xx/dma.c b/arch/arm/mach-s3c64xx/dma.c
index f2a7a17..a77f521 100644
--- a/arch/arm/mach-s3c64xx/dma.c
+++ b/arch/arm/mach-s3c64xx/dma.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/amba/pl080.h>
 
 #include <mach/dma.h>
 #include <mach/map.h>
@@ -30,7 +31,6 @@
 
 #include <mach/regs-sys.h>
 
-#include <asm/hardware/pl080.h>
 
 /* dma channel state information */
 
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index 38fe95d..88be9a3 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -16,9 +16,9 @@
 #include <linux/amba/pl022.h>
 #include <linux/amba/pl08x.h>
 #include <linux/irqchip/spear-shirq.h>
+#include <linux/amba/pl080.h>
 #include <linux/of_irq.h>
 #include <linux/io.h>
-#include <asm/hardware/pl080.h>
 #include <asm/hardware/vic.h>
 #include <plat/pl080.h>
 #include <mach/generic.h>
diff --git a/arch/arm/mach-spear6xx/spear6xx.c b/arch/arm/mach-spear6xx/spear6xx.c
index 5a5a52d..8ce65a2 100644
--- a/arch/arm/mach-spear6xx/spear6xx.c
+++ b/arch/arm/mach-spear6xx/spear6xx.c
@@ -20,7 +20,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
-#include <asm/hardware/pl080.h>
+#include <linux/amba/pl080.h>
 #include <asm/hardware/vic.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 6eb6a5c..8bad254 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -83,7 +83,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include <asm/hardware/pl080.h>
+#include <linux/amba/pl080.h>
 
 #include "dmaengine.h"
 #include "virt-dma.h"
diff --git a/arch/arm/include/asm/hardware/pl080.h b/include/linux/amba/pl080.h
similarity index 99%
rename from arch/arm/include/asm/hardware/pl080.h
rename to include/linux/amba/pl080.h
index 4eea210..3e7b62f 100644
--- a/arch/arm/include/asm/hardware/pl080.h
+++ b/include/linux/amba/pl080.h
@@ -1,4 +1,4 @@
-/* arch/arm/include/asm/hardware/pl080.h
+/* include/linux/amba/pl080.h
  *
  * Copyright 2008 Openmoko, Inc.
  * Copyright 2008 Simtec Electronics
-- 
1.7.10.4

