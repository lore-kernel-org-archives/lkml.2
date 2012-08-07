Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2HGSok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:44:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54914 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173Ab2HGSmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:42:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <rmk@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/7] resources: Add register address resource type
Date: Tue,  7 Aug 2012 19:42:45 +0100
Message-Id: <1344364969-32489-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a bunch of I2C/SPI MFD drivers are using IORESOURCE_IO for
register address ranges. Since this causes some confusion due to the
primary use of this resource type for PCI/ISA I/O ports create a new
resource type IORESOURCE_REG.

Unfortunately the current resource types are specified as bitmasks and
there are no free bitmasks even though they really shouldn't be used as
such so we define the new type as IORESOURCE_IO | IORESOURCE_MEM.
Benjamin Herrenschmidt and Russell King have both verified that none of
the users in this series will have a problem with this, and no new code
should be affected.

This patch was written by Russell King but he found himself unable to
take the patch further.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/ioport.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 589e0e7..bfee885 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -31,6 +31,7 @@ struct resource {
 #define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
 #define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
+#define IORESOURCE_REG		0x00000300	/* Register offsets */
 #define IORESOURCE_IRQ		0x00000400
 #define IORESOURCE_DMA		0x00000800
 #define IORESOURCE_BUS		0x00001000
-- 
1.7.10.4

