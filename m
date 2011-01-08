Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1AHCbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 21:31:23 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45607 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1AHCbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 21:31:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=W/P8SRddLKV40HE71LV6fDbAzS0WTfWJLIsMewruDQ8ydwymTWy8QGEW3sNUyjWxCJ
         txd9VtnxtQ+RRgu3I7TthpdDmVGfkH1na+lTv8FbtzL5D7bUP64PbHLHOrzTCJlk5pH7
         C+h5HKiuDNL54wkOLT0M8GrqGPi4mT4nJXVmQ=
From: Nick Bowler <nbowler@draconx.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] pata_platform: Remove CONFIG_HAVE_PATA_PLATFORM's dependencies.
Date: Fri,  7 Jan 2011 21:32:02 -0500
Message-Id: <1294453922-27602-1-git-send-email-nbowler@draconx.ca>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20110107224348.GZ31708@n2100.arm.linux.org.uk>
References: <20110107224348.GZ31708@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@elliptictech.com>

CONFIG_HAVE_PATA_PLATFORM, by virtue of where its defined, has a
dependency on CONFG_ATA and CONFIG_ATA_SFF.  This causes Kconfig
warnings when it is selected by various architectures, such as

  warning: (ARCH_VEXPRESS && <choice> || ARCH_RPC && <choice> || MACH_VPAC270 && ARCH_PXA || MACH_REALVIEW_PB11MP && ARCH_REALVIEW || MACH_REALVIEW_PBA8 && ARCH_REALVIEW || MACH_REALVIEW_PBX && ARCH_REALVIEW || MACH_BAST_IDE && ARCH_S3C2410 || MACH_ANUBIS && ARCH_S3C2410) selects HAVE_PATA_PLATFORM which has unmet direct dependencies (ATA && ATA_SFF)

Since this option is only used to control visibility of the
CONFIG_PATA_PLATFORM option and isn't itself visible in the menu,
it is straightforward to simply remove these dependencies rather
than adjust all the architectures.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 drivers/ata/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 36e2319..b15254f 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -2,6 +2,14 @@
 # SATA/PATA driver configuration
 #
 
+config HAVE_PATA_PLATFORM
+	bool
+	help
+	  This is an internal configuration node for any machine that
+	  uses pata-platform driver to enable the relevant driver in the
+	  configuration structure without having to submit endless patches
+	  to update the PATA_PLATFORM entry.
+
 menuconfig ATA
 	tristate "Serial ATA and Parallel ATA drivers"
 	depends on HAS_IOMEM
@@ -765,14 +773,6 @@ config PATA_PCMCIA
 
 	  If unsure, say N.
 
-config HAVE_PATA_PLATFORM
-	bool
-	help
-	  This is an internal configuration node for any machine that
-	  uses pata-platform driver to enable the relevant driver in the
-	  configuration structure without having to submit endless patches
-	  to update the PATA_PLATFORM entry.
-
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
 	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
-- 
1.7.2.2

