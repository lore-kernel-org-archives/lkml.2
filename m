Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0JNEEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:04:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48666 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab0JNEEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:04:20 -0400
Date: Wed, 13 Oct 2010 18:10:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] gpio/vx855: fix kconfig dependency warning
Message-Id: <20101013181035.b461b948.randy.dunlap@oracle.com>
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

warning: (GPIO_VX855 && GPIOLIB) selects MFD_VX855 which has unmet direct dependencies (MFD_SUPPORT && PCI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101013.orig/drivers/gpio/Kconfig
+++ linux-next-20101013/drivers/gpio/Kconfig
@@ -113,7 +113,7 @@ config GPIO_SCH
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on GPIOLIB
+	depends on GPIOLIB && MFD_SUPPORT && PCI
 	select MFD_CORE
 	select MFD_VX855
 	help
