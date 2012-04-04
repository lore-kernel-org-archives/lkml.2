Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2DDNOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:14:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9065 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab2DDNOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:14:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Apr 2012 06:14:20 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V1 2/2] mfd: rc5t583: Initialize gpio during initialization.
Date: Wed,  4 Apr 2012 18:34:31 +0530
Message-Id: <1333544671-24549-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1333544671-24549-1-git-send-email-ldewangan@nvidia.com>
References: <1333544671-24549-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initializing gpios of the device RICOH's PMIC RC5T583
during device initialization. This device support 8 gpios
which can be access through gpio library.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/Kconfig   |    1 +
 drivers/mfd/rc5t583.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 29f463c..7155d5f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -864,6 +864,7 @@ config MFD_RC5T583
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
+	select GPIO_RC5T583
 	help
 	  Select this option to get support for the RICOH583 Power
 	  Management system device.
diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 99ef944..a0c9e61 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -331,6 +331,7 @@ static int __devinit rc5t583_i2c_probe(struct i2c_client *i2c,
 		goto err_add_devs;
 	}
 
+	rc5t583_gpio_init(rc5t583, pdata);
 	return 0;
 
 err_add_devs:
-- 
1.7.1.1

