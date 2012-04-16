Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2DPQue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:50:34 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:53354 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751651Ab2DPQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:50:32 -0400
Message-ID: <4F8C780D.9010702@xenotime.net>
Date: Mon, 16 Apr 2012 12:50:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Tim Hockin <thockin@sun.com>
Subject: [PATCH -next] mtd: fix sbc2_flash build when PCI is not enabled
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
In-Reply-To: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

sbc2_flash.c is a PCI driver, but its build fails when CONFIG_PCI
is not enabled, so make it depend on PCI.

drivers/mtd/maps/scb2_flash.c:237:1: warning: data definition has no type or storage class
drivers/mtd/maps/scb2_flash.c:237:1: warning: type defaults to 'int' in declaration of 'module_pci_driver'
drivers/mtd/maps/scb2_flash.c:237:1: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	David Woodhouse <dwmw2@infradead.org>
Cc:	linux-mtd@lists.infradead.org
---
 drivers/mtd/maps/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120416.orig/drivers/mtd/maps/Kconfig
+++ linux-next-20120416/drivers/mtd/maps/Kconfig
@@ -224,7 +224,7 @@ config MTD_CK804XROM
 
 config MTD_SCB2_FLASH
 	tristate "BIOS flash chip on Intel SCB2 boards"
-	depends on X86 && MTD_JEDECPROBE
+	depends on X86 && MTD_JEDECPROBE && PCI
 	help
 	  Support for treating the BIOS flash chip on Intel SCB2 boards
 	  as an MTD device - with this you can reprogram your BIOS.
