Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1BUWki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:40:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41641 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1BUWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:40:36 -0500
Date: Mon, 21 Feb 2011 14:39:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>
Subject: [PATCH -next] staging: fix olpc_dcon kconfig and build errors
Message-Id: <20110221143908.96e03b3c.randy.dunlap@oracle.com>
In-Reply-To: <20110221182134.09abd232.sfr@canb.auug.org.au>
References: <20110221182134.09abd232.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D62E9D4.0056:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c:106: error: 'acpi_gbl_FADT' undeclared (first use in this function)

Fixing that one gives:

ERROR: "backlight_device_register" [drivers/staging/olpc_dcon/olpc-dcon.ko] undefined!
ERROR: "registered_fb" [drivers/staging/olpc_dcon/olpc-dcon.ko] undefined!
ERROR: "lock_fb_info" [drivers/staging/olpc_dcon/olpc-dcon.ko] undefined!
ERROR: "backlight_device_unregister" [drivers/staging/olpc_dcon/olpc-dcon.ko] undefined!
ERROR: "num_registered_fb" [drivers/staging/olpc_dcon/olpc-dcon.ko] undefined!
ERROR: "fb_blank" [drivers/staging/olpc_dcon/olpc-dcon.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Chris Ball <cjb@laptop.org>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
---
 drivers/staging/olpc_dcon/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20110221.orig/drivers/staging/olpc_dcon/Kconfig
+++ linux-next-20110221/drivers/staging/olpc_dcon/Kconfig
@@ -1,6 +1,6 @@
 config FB_OLPC_DCON
 	tristate "One Laptop Per Child Display CONtroller support"
-	depends on OLPC
+	depends on OLPC && FB
 	select I2C
 	---help---
 	  Add support for the OLPC XO DCON controller.  This controller is
@@ -19,7 +19,7 @@ config FB_OLPC_DCON_1
 
 config FB_OLPC_DCON_1_5
 	bool "OLPC XO-1.5 DCON support"
-	depends on FB_OLPC_DCON
+	depends on FB_OLPC_DCON && ACPI
 	default y
 	---help---
 	  Enable support for the DCON in XO-1.5 model laptops.  The kernel
