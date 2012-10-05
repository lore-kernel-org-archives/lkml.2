Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2JEO7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:59:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab2JEO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 03/16] SCSI: ARM: ncr5380/oak uses no interrupts
Date: Fri,  5 Oct 2012 16:55:17 +0200
Message-Id: <1349448930-23976-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:702RgIr6IIr1koYlcAuv9NWJCMs57bZQkXwEO/6HwIe
 3YyiXBBPVHDs1qq0rix5+0OVbmoxtQLJE/mLSoIqCt8KRPriEf
 0PzyOQ/vTgSjAiM4xZQ4Ac91B0lDpL/5PVeZahy3EFviF/VssF
 jQ0a4JR/uxOa768ZXCMCluTb1MiEyGuhStP7GiJb877rv61OlL
 C3Sx/1cnWFT8f85p0vEhSin4scpf8LVm1PPchBCus2e3IC7LnC
 AO8IVltafvVLFjUrWQeIwJ0a7+QRNtBg7Z4+mtFrXzNbtm2Tss
 auCvOh1Yd8P1+5wGOX9HKzqsPZmihpoJ0nnV8u6Bi5m5DeD5fy
 A5pr5YtADazY1oNvprYjeLS/aT435E6YAXGC1U/D5wAc/B7k/v
 Am5jyr2suS2bqrvrQz0gbOLXgj51tt0+ps=
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

