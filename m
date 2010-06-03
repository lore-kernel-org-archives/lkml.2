Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0FCSKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:10:08 -0400
Received: from kroah.org ([198.145.64.141]:39955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab0FCSKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:10:05 -0400
Subject: patch staging-phison-depends-on-ata_bmdma.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Thu, 03 Jun 2010 11:09:16 -0700
In-Reply-To: <20100526103002.ac2c6703.randy.dunlap@oracle.com>
Message-ID: <12755885561990@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: phison: depends on ATA_BMDMA

to my gregkh-2.6 tree.  Its filename is

    staging-phison-depends-on-ata_bmdma.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Tue Jun  1 14:14:50 2010
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 26 May 2010 10:30:02 -0700
Subject: Staging: phison: depends on ATA_BMDMA
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, evan_ko@phison.com
Message-ID: <20100526103002.ac2c6703.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

phison uses interfaces and data that are built only when
ATA_BMDMA is enabled, so it should depend on that symbol.

drivers/staging/phison/phison.c:43: error: implicit declaration of function 'ATA_BMDMA_SHT'
drivers/staging/phison/phison.c:43: error: initializer element is not constant
drivers/staging/phison/phison.c:43: error: (near initialization for 'phison_sht.module')
drivers/staging/phison/phison.c:47: error: 'ata_bmdma_port_ops' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: evan_ko@phison.com
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/phison/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/phison/Kconfig
+++ b/drivers/staging/phison/Kconfig
@@ -1,5 +1,5 @@
 config IDE_PHISON
 	tristate "PCIE ATA PS5000 IDE support"
-	depends on PCI && ATA && ATA_SFF
+	depends on PCI && ATA && ATA_SFF && ATA_BMDMA
 	---help---
 	  This is an experimental driver for PS5000 IDE driver.

