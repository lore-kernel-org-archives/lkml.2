Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab2JIUOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:14:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2JIUOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:14:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v2 1/8] SCSI: ARM: ncr5380/oak uses no interrupts
Date: Tue,  9 Oct 2012 22:13:51 +0200
Message-Id: <1349813638-4617-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:mq1y1hTfh8IkQtWKmBJ04Ddcd/e3j+BxS8y0vNIW/QA
 Aeil6eUVSPNmKmf5KrdIm2QKy1lN59szZdbolRJlioUtvbXa1l
 g1zWnFRSMSrC9N76qgR+W6/WP+QwCrIsm5rq370T83jTMH4rSg
 zpDQuwKwvyLBm5Oq2LwSeNAF9ZBD1Ql7vfc6BZSuk+3XGEdk9H
 crt9BRuBMzJPJYAWcbnWUlmioCeYqaz127U3oIFzzDqV6ZKDKm
 TCttOU2O0YG4pZm1qWJXGErYeQvp5+hq1OgWLAYYMsWH47NkJR
 sQCLSrDkrikjjs54cCIYYN1/z80AFPbkvNj3mASit6T42oaGxA
 JgUmla4Ot1//ADw/35xWrsNrpwzliDfxH/Br7OdG+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ncr5380 driver is included by multiple board specific
drivers, which may or may not use the interrupt handler.
The oak variant doesn't, and should set the DONT_USE_INTR
macro.

Without this patch, building rpc_defconfig results in:

drivers/scsi/arm/../NCR5380.c:1160:20: warning: 'oakscsi_intr' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/arm/oak.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index d25f944..fc6a5aa 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -21,6 +21,7 @@
 /*#define PSEUDO_DMA*/
 
 #define OAKSCSI_PUBLIC_RELEASE 1
+#define DONT_USE_INTR
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
 #define NCR5380_local_declare()		void __iomem *_base
-- 
1.7.10

