Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1DHPdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:33:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65517 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1DHPdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:33:02 -0400
Date: Fri, 8 Apr 2011 08:32:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Baruch Siach <baruch@tkos.co.il>,
        linux-i2c@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        khali@linux-fr.org, ben-linux@fluff.org
Subject: [PATCH -next reresend] i2c: designware-pcidrv depends on PCI
Message-Id: <20110408083215.6b3b0bfe.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D9F2A85.0041:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

i2c-designware-pcidrv is a PCI driver and should depend on PCI.
Fixes these build errors:

drivers/i2c/busses/i2c-designware-pcidrv.c:256: error: implicit declaration of function 'pci_request_region'
drivers/i2c/busses/i2c-designware-pcidrv.c:338: error: implicit declaration of function 'pci_release_region'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Baruch Siach <baruch@tkos.co.il>
---
 drivers/i2c/busses/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Does anybody merge i2c patches???

--- linux-next-20110316.orig/drivers/i2c/busses/Kconfig
+++ linux-next-20110316/drivers/i2c/busses/Kconfig
@@ -359,6 +359,7 @@ config I2C_DESIGNWARE_PLATFORM
 
 config I2C_DESIGNWARE_PCI
 	tristate "Synopsys DesignWare PCI"
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the
 	  Synopsys DesignWare I2C adapter. Only master mode is supported.
--
