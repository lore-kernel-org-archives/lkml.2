Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3ACKsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:48:05 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18832 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3ACKsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:48:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 Jan 2013 02:47:30 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <linus.walleij@linaro.org>,
        <grant.likely@secretlab.ca>, <akpm@linux-foundation.org>
CC: <a.zummo@towertech.it>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/4] mfd: palmas: add apis to access the Palmas' registers
Date: Thu, 3 Jan 2013 16:16:58 +0530
Message-ID: <1357210020-19876-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas register set is divided into different blocks (base and offset)
and hence different i2c addresses. The i2c address offsets are derived
from base address of block of registers.

Add inline APIs to access the Palma's registers which takes the base of
register block and register offset. The i2c address offset is  derived
from the base address of register blocks.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 include/linux/mfd/palmas.h |   52 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 29f6616..a4d13d7 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -2789,4 +2789,56 @@ enum usb_irq_events {
 #define PALMAS_GPADC_TRIM15					0xE
 #define PALMAS_GPADC_TRIM16					0xF
 
+static inline int palmas_read(struct palmas *palmas, unsigned int base,
+		unsigned int reg, unsigned int *val)
+{
+	unsigned int addr =  PALMAS_BASE_TO_REG(base, reg);
+	int slave_id = PALMAS_BASE_TO_SLAVE(base);
+
+	return regmap_read(palmas->regmap[slave_id], addr, val);
+}
+
+static inline int palmas_write(struct palmas *palmas, unsigned int base,
+		unsigned int reg, unsigned int value)
+{
+	unsigned int addr = PALMAS_BASE_TO_REG(base, reg);
+	int slave_id = PALMAS_BASE_TO_SLAVE(base);
+
+	return regmap_write(palmas->regmap[slave_id], addr, value);
+}
+
+static inline int palmas_bulk_write(struct palmas *palmas, unsigned int base,
+	unsigned int reg, const void *val, size_t val_count)
+{
+	unsigned int addr = PALMAS_BASE_TO_REG(base, reg);
+	int slave_id = PALMAS_BASE_TO_SLAVE(base);
+
+	return regmap_bulk_write(palmas->regmap[slave_id], addr,
+			val, val_count);
+}
+
+static inline int palmas_bulk_read(struct palmas *palmas, unsigned int base,
+		unsigned int reg, void *val, size_t val_count)
+{
+	unsigned int addr = PALMAS_BASE_TO_REG(base, reg);
+	int slave_id = PALMAS_BASE_TO_SLAVE(base);
+
+	return regmap_bulk_read(palmas->regmap[slave_id], addr,
+		val, val_count);
+}
+
+static inline int palmas_update_bits(struct palmas *palmas, unsigned int base,
+	unsigned int reg, unsigned int mask, unsigned int val)
+{
+	unsigned int addr = PALMAS_BASE_TO_REG(base, reg);
+	int slave_id = PALMAS_BASE_TO_SLAVE(base);
+
+	return regmap_update_bits(palmas->regmap[slave_id], addr, mask, val);
+}
+
+static inline int palmas_irq_get_virq(struct palmas *palmas, int irq)
+{
+	return regmap_irq_get_virq(palmas->irq_data, irq);
+}
+
 #endif /*  __LINUX_MFD_PALMAS_H */
-- 
1.7.1.1

