Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab2FTTyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:54:21 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:53150 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757970Ab2FTTyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:54:20 -0400
Message-ID: <4FE22A53.9090309@xenotime.net>
Date: Wed, 20 Jun 2012 12:53:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH] mfd: TWL6040_CORE needs to select IRQ_DOMAIN
References: <1340156457.13830.1.camel@phoenix>
In-Reply-To: <1340156457.13830.1.camel@phoenix>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error by selecting IRQ_DOMAIN:

drivers/mfd/twl6040-irq.c:164:2: error: implicit declaration of function 'irq_domain_add_legacy'
drivers/mfd/twl6040-irq.c:165:11: error: 'irq_domain_simple_ops' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Samuel Ortiz <sameo@linux.intel.com>
Cc:	Misael Lopez Cruz <misael.lopez@ti.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20120620.orig/drivers/mfd/Kconfig
+++ linux-next-20120620/drivers/mfd/Kconfig
@@ -286,6 +286,7 @@ config TWL6040_CORE
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
+	select IRQ_DOMAIN
 	default n
 	help
 	  Say yes here if you want support for Texas Instruments TWL6040 audio
