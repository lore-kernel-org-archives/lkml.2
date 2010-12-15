Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab0LOA2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:28:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42709 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760125Ab0LOA2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:28:08 -0500
Date: Tue, 14 Dec 2010 16:26:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org
Subject: [PATCH] GPIO_SCH and I2C_SCH: select MFD_SUPPORT to eliminate
 kconfig warnings
Message-Id: <20101214162656.b8550c70.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

I2C_ISCH and GPIO_SCH need to select MFD_SUPPORT so that the
dependency tree hierarchy is satisfied.  This eliminates the
kconfig warning:

warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI) selects LPC_SCH which has unmet direct dependencies (MFD_SUPPORT && PCI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-i2c@vger.kernel.org
---
 drivers/gpio/Kconfig       |    1 +
 drivers/i2c/busses/Kconfig |    1 +
 2 files changed, 2 insertions(+)

--- lnx-2637-rc4.orig/drivers/gpio/Kconfig
+++ lnx-2637-rc4/drivers/gpio/Kconfig
@@ -102,6 +102,7 @@ config GPIO_VR41XX
 config GPIO_SCH
 	tristate "Intel SCH GPIO"
 	depends on GPIOLIB && PCI
+	select MFD_SUPPORT
 	select MFD_CORE
 	select LPC_SCH
 	help
--- lnx-2637-rc4.orig/drivers/i2c/busses/Kconfig
+++ lnx-2637-rc4/drivers/i2c/busses/Kconfig
@@ -107,6 +107,7 @@ config I2C_I801
 config I2C_ISCH
 	tristate "Intel SCH SMBus 1.0"
 	depends on PCI
+	select MFD_SUPPORT
 	select MFD_CORE
 	select LPC_SCH
 	help
