Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab2IRKBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:01:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2IRKBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:01:43 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: fix MAX77693 dependency on IRQ_DOMAIN
Date: Tue, 18 Sep 2012 12:01:37 +0200
Message-Id: <1347962497-17779-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver needs CONFIG_IRQ_DOMAIN because it uses max77693_irq_thread and
max77693_irq_init.

drivers/mfd/max77693-irq.c: In function ‘max77693_irq_thread’:
drivers/mfd/max77693-irq.c:217: error: implicit declaration of function ‘irq_find_mapping’
drivers/mfd/max77693-irq.c: In function ‘max77693_irq_init’:
drivers/mfd/max77693-irq.c:286: error: implicit declaration of function ‘irq_domain_add_linear’

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 92144ed..28ad9a5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -428,6 +428,7 @@ config MFD_MAX77693
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
+	select IRQ_DOMAIN
 	help
 	  Say yes here to support for Maxim Semiconductor MAX77693.
 	  This is a companion Power Management IC with Flash, Haptic, Charger,
-- 
1.7.10.4

