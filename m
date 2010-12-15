Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab0LOA2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:28:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42660 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760125Ab0LOA2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:28:03 -0500
Date: Tue, 14 Dec 2010 16:26:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Florian Fainelli <florian@openwrt.org>
Subject: [PATCH] GPIO_RDC321X: select MFD_SUPPORT to squelch kconfig warning
Message-Id: <20101214162649.f9b209e1.randy.dunlap@oracle.com>
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

--- lnx-2637-rc4.orig/drivers/gpio/Kconfig
+++ lnx-2637-rc4/drivers/gpio/Kconfig
@@ -342,6 +342,7 @@ config GPIO_TIMBERDALE
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
 	depends on PCI && GPIOLIB
+	select MFD_SUPPORT
 	select MFD_CORE
 	select MFD_RDC321X
 	help
