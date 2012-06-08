Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975Ab2FHVy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:54:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56232 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538Ab2FHVxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:53:51 -0400
From: mathieu.poirier@linaro.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH RESEND 7/7] drivers/scsi: some ISA drivers need ISA_DMA_API
Date: Fri,  8 Jun 2012 15:53:36 -0600
Message-Id: <1339192416-27026-8-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
References: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The two options are separate, and some platforms (e.g. arm pxa)
have ISA slots but no ISA dma controller, so they cannot build
drivers using the enable_dma etc functions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index b43d72e..c97c418 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1042,7 +1042,7 @@ config SCSI_IZIP_SLOW_CTR
 
 config SCSI_NCR53C406A
 	tristate "NCR53c406a SCSI support"
-	depends on ISA && SCSI
+	depends on ISA && SCSI && ISA_DMA_API
 	help
 	  This is support for the NCR53c406a SCSI host adapter.  For user
 	  configurable parameters, check out <file:drivers/scsi/NCR53c406a.c>
@@ -1310,7 +1310,7 @@ config SCSI_NCR53C8XX_NO_DISCONNECT
 
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA && ISA_DMA_API && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
@@ -1324,7 +1324,7 @@ config SCSI_PAS16
 
 config SCSI_QLOGIC_FAS
 	tristate "Qlogic FAS SCSI support"
-	depends on ISA && SCSI
+	depends on ISA && SCSI && ISA_DMA_API
 	---help---
 	  This is a driver for the ISA, VLB, and PCMCIA versions of the Qlogic
 	  FastSCSI! cards as well as any other card based on the FASXX chip
-- 
1.7.5.4

