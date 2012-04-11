Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2DKSf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:35:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40968 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2DKSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:35:58 -0400
Date: Wed, 11 Apr 2012 11:34:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sam Bradshaw <sbradshaw@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
Message-ID: <20120411183457.GA19379@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
depend on PCI.

Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
Note, the driver builds just fine without this dependency, and I have a
system that does not have HOTPLUG PCIE, yet it has PCIE slots, which
should be all that is required for this driver.

What am I missing that required this dependency in the first place?

diff --git a/drivers/block/mtip32xx/Kconfig b/drivers/block/mtip32xx/Kconfig
index b5dd14e..0ba837f 100644
--- a/drivers/block/mtip32xx/Kconfig
+++ b/drivers/block/mtip32xx/Kconfig
@@ -4,6 +4,6 @@
 
 config BLK_DEV_PCIESSD_MTIP32XX
 	tristate "Block Device Driver for Micron PCIe SSDs"
-	depends on HOTPLUG_PCI_PCIE
+	depends on PCI
 	help
           This enables the block driver for Micron PCIe SSDs.
