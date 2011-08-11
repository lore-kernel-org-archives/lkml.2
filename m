Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1HKSx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:53:57 -0400
Received: from masquerade.micron.com ([137.201.242.130]:9603 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1HKSxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:53:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH v3 3/3] drivers/block/mtip32xx: Adding Makefile and Kconfig
Date: Thu, 11 Aug 2011 12:53:40 -0600
Message-ID: <22A973199D2C2F46933448F6E7990A3002C80029@ntxboimbx31.micron.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v3 3/3] drivers/block/mtip32xx: Adding Makefile and Kconfig
Thread-Index: AcxYV/wRwGnrsacuTT+cSwSCu8KNhQ==
From: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Moyer" <jmoyer@redhat.com>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jeff Garzik" <jgarzik@pobox.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        "Jens Axboe" <jaxboe@fusionio.com>
Reply-To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	  <asamymuthupa@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third/final part of the new block driver,mtip32xx, for
Micron
PCIe SSD, which contains the new Makefile and Kconfig. Also contains the
changes to Kconfig and Makefile in drivers/block to add this new driver.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/Kconfig           |    2 ++
 drivers/block/Makefile          |    1 +
 drivers/block/mtip32xx/Kconfig  |    8 ++++++++
 drivers/block/mtip32xx/Makefile |    7 +++++++
 4 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/mtip32xx/Kconfig
 create mode 100644 drivers/block/mtip32xx/Makefile

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 717d6e4..b729ae3 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -116,6 +116,8 @@ config PARIDE

 source "drivers/block/paride/Kconfig"

+source "drivers/block/mtip32xx/Kconfig"
+
 config BLK_CPQ_DA
 	tristate "Compaq SMART2 support"
 	depends on PCI && VIRT_TO_BUS
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 76646e9..ad7b74a 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -39,5 +39,6 @@ obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+=
xen-blkfront.o
 obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
+obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/

 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/mtip32xx/Kconfig
b/drivers/block/mtip32xx/Kconfig
new file mode 100644
index 0000000..1a20e88
--- /dev/null
+++ b/drivers/block/mtip32xx/Kconfig
@@ -0,0 +1,8 @@
+#
+# mtip32xx device driver configuration
+#
+
+config BLK_DEV_PCIESSD_MTIP32XX
+	tristate "Block Device Driver for Micron PCIe SSDs"
+	help
+          This enables the block driver for Micron PCIe SSDs.
diff --git a/drivers/block/mtip32xx/Makefile
b/drivers/block/mtip32xx/Makefile
new file mode 100644
index 0000000..0a0fba2
--- /dev/null
+++ b/drivers/block/mtip32xx/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for  Block device driver for Micron PCIe SSD
+#
+
+obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX) += mtip32xx.o
+
+mtip32xx-y := mtip_pci.o mtip_block.o mtip_hw.o
-- 
1.7.1


-- 
Regards,
Asai Thambi
