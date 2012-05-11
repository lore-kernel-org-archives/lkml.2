Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030317Ab2EKWL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:11:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58842 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030295Ab2EKWJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:09:39 -0400
From: mathieu.poirier@linaro.org
To: JBottomley@parallels.com
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH 4/7] scsi/advansys: do not build on ARM
Date: Fri, 11 May 2012 16:09:25 -0600
Message-Id: <1336774168-26577-5-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The advansys driver uses the dma_cache_sync interface
which is impossible to support on ARM.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 651f905..2f49a00 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -584,6 +584,7 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI && VIRT_TO_BUS
 	depends on ISA || EISA || PCI
+	depends on !ARM # no support for DMA_CACHE_SYNC
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
-- 
1.7.5.4

