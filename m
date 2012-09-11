Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab2IKNCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:02:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab2IKNCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:02:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: [PATCH 01/16] ARM: at91: move platform_data definitions
Date: Tue, 11 Sep 2012 14:59:35 +0200
Message-Id: <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368350-31212-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:PcUhJhD83uhkIYHP/ZR/QjTrSUIfSqdUSsDS6tATEYv
 xa1VI3HzGw3jR4CfXgCJUXxgA+FIJhQt0GAdDvKHWMlEcmhMhT
 fb3ReDnNId/q9FL+KtsL/yxYhf4Rfh1f4lTcJHRsWNjW4+NNsi
 DhZnit/lMQf78ARZD3hOVdk1i8a5mfaPdDH58XNXDTux+pWqZU
 6Tz043O3tyigOVnk7HtshGMiU2ur2Y3HDE8C7FfCBhk8XT70Lf
 HVe3iBdv0JOZmt89ozoZL941Yn8qCe6pCLiNL4elxNGkurAzw9
 7db7tmjP2RIf5RLRLdcWwV9dC/p0TZ5mpgnXCH8CoFg/CL7kA/
 SSa78Eh1Lbe8aIEv4PLqXKgNJdjGQKavfaLsxSRNpzgFWFEuLg
 ZZSPDI/Yubl+u6pu6rf7/FddLiQplhYnxU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the at91 include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c                             |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c                              |    2 +-
 arch/arm/mach-at91/include/mach/atmel-mci.h                          |    2 +-
 drivers/dma/at_hdmac_regs.h                                          |    2 +-
 include/linux/platform_data/atmel-aes.h                              |    2 +-
 .../mach/at_hdmac.h => include/linux/platform_data/dma-atmel.h       |    0
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename arch/arm/mach-at91/include/mach/at_hdmac.h => include/linux/platform_data/dma-atmel.h (100%)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 0607399..0aa9bdb 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -31,7 +31,7 @@
 #include <mach/at91sam9g45_matrix.h>
 #include <mach/at91_matrix.h>
 #include <mach/at91sam9_smc.h>
-#include <mach/at_hdmac.h>
+#include <linux/platform_data/dma-atmel.h>
 #include <mach/atmel-mci.h>
 
 #include <media/atmel-isi.h>
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index f09fff9..e4da717 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -22,7 +22,7 @@
 #include <mach/at91sam9rl_matrix.h>
 #include <mach/at91_matrix.h>
 #include <mach/at91sam9_smc.h>
-#include <mach/at_hdmac.h>
+#include <linux/platform_data/dma-atmel.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/include/mach/atmel-mci.h b/arch/arm/mach-at91/include/mach/atmel-mci.h
index 998cb0c..cd580a1 100644
--- a/arch/arm/mach-at91/include/mach/atmel-mci.h
+++ b/arch/arm/mach-at91/include/mach/atmel-mci.h
@@ -1,7 +1,7 @@
 #ifndef __MACH_ATMEL_MCI_H
 #define __MACH_ATMEL_MCI_H
 
-#include <mach/at_hdmac.h>
+#include <linux/platform_data/dma-atmel.h>
 
 /**
  * struct mci_dma_data - DMA data for MCI interface
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 8a6c8e8..116e4ad 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -11,7 +11,7 @@
 #ifndef AT_HDMAC_REGS_H
 #define	AT_HDMAC_REGS_H
 
-#include <mach/at_hdmac.h>
+#include <linux/platform_data/dma-atmel.h>
 
 #define	AT_DMA_MAX_NR_CHANNELS	8
 
diff --git a/include/linux/platform_data/atmel-aes.h b/include/linux/platform_data/atmel-aes.h
index e7a1949..ab68082 100644
--- a/include/linux/platform_data/atmel-aes.h
+++ b/include/linux/platform_data/atmel-aes.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_ATMEL_AES_H
 #define __LINUX_ATMEL_AES_H
 
-#include <mach/at_hdmac.h>
+#include <linux/platform_data/dma-atmel.h>
 
 /**
  * struct aes_dma_data - DMA data for AES
diff --git a/arch/arm/mach-at91/include/mach/at_hdmac.h b/include/linux/platform_data/dma-atmel.h
similarity index 100%
rename from arch/arm/mach-at91/include/mach/at_hdmac.h
rename to include/linux/platform_data/dma-atmel.h
-- 
1.7.10

