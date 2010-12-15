Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab0LOA11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:27:27 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42056 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab0LOA10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:27:26 -0500
Date: Tue, 14 Dec 2010 16:26:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Daniel Drake <dsd@laptop.org>
Subject: [PATCH] GPIO_VX855: eliminate kconfig dependency warning
Message-Id: <20101214162653.6791819c.randy.dunlap@oracle.com>
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

--- lnx-2637-rc4.orig/drivers/gpio/Kconfig
+++ lnx-2637-rc4/drivers/gpio/Kconfig
@@ -118,7 +118,7 @@ config GPIO_SCH
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on GPIOLIB
+	depends on GPIOLIB && MFD_SUPPORT && PCI
 	select MFD_CORE
 	select MFD_VX855
 	help
