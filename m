Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab1CYIqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:46:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44441 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab1CYIqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:46:10 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 5/5] mmc: sdhci: merge two sdhci-pltfm.h into one
Date: Fri, 25 Mar 2011 16:48:51 +0800
Message-Id: <1301042931-4869-6-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structure sdhci_pltfm_data is not necessarily to be in a public
header like include/linux/mmc/sdhci-pltfm.h, so the patch moves it
into drivers/mmc/host/sdhci-pltfm.h and eliminates the former one.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/sdhci-cns3xxx.c |    1 -
 drivers/mmc/host/sdhci-esdhc.c   |    1 -
 drivers/mmc/host/sdhci-pltfm.h   |    6 +++++-
 include/linux/mmc/sdhci-pltfm.h  |   29 -----------------------------
 4 files changed, 5 insertions(+), 32 deletions(-)
 delete mode 100644 include/linux/mmc/sdhci-pltfm.h

diff --git a/drivers/mmc/host/sdhci-cns3xxx.c b/drivers/mmc/host/sdhci-cns3xxx.c
index 95b9080..2238d34 100644
--- a/drivers/mmc/host/sdhci-cns3xxx.c
+++ b/drivers/mmc/host/sdhci-cns3xxx.c
@@ -15,7 +15,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/mmc/host.h>
-#include <linux/mmc/sdhci-pltfm.h>
 #include <mach/cns3xxx.h>
 #include "sdhci.h"
 #include "sdhci-pltfm.h"
diff --git a/drivers/mmc/host/sdhci-esdhc.c b/drivers/mmc/host/sdhci-esdhc.c
index b3d1bc1..fd041d9 100644
--- a/drivers/mmc/host/sdhci-esdhc.c
+++ b/drivers/mmc/host/sdhci-esdhc.c
@@ -20,7 +20,6 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/mmc/host.h>
-#include <linux/mmc/sdhci-pltfm.h>
 #ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
 #include <mach/hardware.h>
 #endif
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index 05fe25d..e2d143c 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -14,9 +14,13 @@
 #include <linux/clk.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
-#include <linux/mmc/sdhci-pltfm.h>
 #include <linux/mmc/sdhci.h>
 
+struct sdhci_pltfm_data {
+	struct sdhci_ops *ops;
+	unsigned int quirks;
+};
+
 struct sdhci_pltfm_host {
 	struct clk *clk;
 	u32 scratchpad; /* to handle quirks across io-accessor calls */
diff --git a/include/linux/mmc/sdhci-pltfm.h b/include/linux/mmc/sdhci-pltfm.h
deleted file mode 100644
index f1c2ac3..0000000
--- a/include/linux/mmc/sdhci-pltfm.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * Platform data declarations for the sdhci-pltfm driver.
- *
- * Copyright (c) 2010 MontaVista Software, LLC.
- *
- * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or (at
- * your option) any later version.
- */
-
-#ifndef _SDHCI_PLTFM_H
-#define _SDHCI_PLTFM_H
-
-struct sdhci_ops;
-
-/**
- * struct sdhci_pltfm_data - SDHCI platform-specific information & hooks
- * @ops: optional pointer to the platform-provided SDHCI ops
- * @quirks: optional SDHCI quirks
- */
-struct sdhci_pltfm_data {
-	struct sdhci_ops *ops;
-	unsigned int quirks;
-};
-
-#endif /* _SDHCI_PLTFM_H */
-- 
1.7.1

