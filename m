Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0EGWFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:05:36 -0400
Received: from xenotime.net ([72.52.115.56]:54634 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751094Ab0EGWFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:05:34 -0400
Date: Fri, 7 May 2010 15:05:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd: use menuconfig for quicker config editing
Message-Id: <20100507150525.70d76e17.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Change MFD 'menu' to 'menuconfig' to facilitate easy (one-click)
disabling of all MFD drivers.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/Kconfig |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- linux-2.6.34-rc6-git5.orig/drivers/mfd/Kconfig
+++ linux-2.6.34-rc6-git5/drivers/mfd/Kconfig
@@ -2,8 +2,14 @@
 # Multifunction miscellaneous devices
 #
 
-menu "Multifunction device drivers"
+menuconfig MFD_SUPPORT
+	bool "Multifunction device drivers"
 	depends on HAS_IOMEM
+	default y
+	help
+	  Configure MFD device drivers.
+
+if MFD_SUPPORT
 
 config MFD_CORE
 	tristate
@@ -399,7 +405,7 @@ config LPC_SCH
 	  LPC bridge function of the Intel SCH provides support for
 	  System Management Bus and General Purpose I/O.
 
-endmenu
+endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
