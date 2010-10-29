Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954Ab0J2Ui5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:38:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29455 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761852Ab0J2Uiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:38:55 -0400
Date: Fri, 29 Oct 2010 13:37:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        Ba Zheng <zheng.ba@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH -next] i2c: intel-mid depends on PCI
Message-Id: <20101029133709.5e5df4ad.randy.dunlap@oracle.com>
In-Reply-To: <20101029121148.d27e03bc.sfr@canb.auug.org.au>
References: <20101029121148.d27e03bc.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

i2c-intel-mid driver uses PCI data structs and interfaces,
so it should depend on PCI.  Fixes these build errors:

drivers/i2c/busses/i2c-intel-mid.c:977: error: implicit declaration of function 'pci_request_region'
drivers/i2c/busses/i2c-intel-mid.c:1077: error: implicit declaration of function 'pci_release_region'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ba Zheng <zheng.ba@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/busses/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101029.orig/drivers/i2c/busses/Kconfig
+++ linux-next-20101029/drivers/i2c/busses/Kconfig
@@ -398,6 +398,7 @@ config I2C_IMX
 
 config I2C_INTEL_MID
 	tristate "Intel Moorestown/Medfield Platform I2C controller"
+	depends on PCI
 	help
 	  Say Y here if you have an Intel Moorestown/Medfield platform I2C
 	  controller.
