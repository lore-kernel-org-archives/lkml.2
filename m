Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab0JNEEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:04:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48603 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0JNEEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:04:05 -0400
Date: Wed, 13 Oct 2010 18:09:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Florian Fainelli <florian@openwrt.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] gpio: fix rdc321x kconfig dependencies
Message-Id: <20101013180917.0a75631c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (GPIO_RDC321X && PCI && GPIOLIB) selects MFD_RDC321X which has unmet direct dependencies (MFD_SUPPORT && PCI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Florian Fainelli <florian@openwrt.org>
---
 drivers/gpio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101013.orig/drivers/gpio/Kconfig
+++ linux-next-20101013/drivers/gpio/Kconfig
@@ -322,6 +322,7 @@ config GPIO_TIMBERDALE
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
 	depends on PCI && GPIOLIB
+	select MFD_SUPPORT
 	select MFD_CORE
 	select MFD_RDC321X
 	help
