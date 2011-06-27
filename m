Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab1F0HzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:55:25 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:51980 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756103Ab1F0Hy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:54:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Om Prakash <omprakash.pal@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd/stmpe: fix missing kerneldoc
Date: Mon, 27 Jun 2011 09:54:22 +0200
Message-ID: <1309161262-16670-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Om Prakash <omprakash.pal@stericsson.com>

Generating kerneldoc for STMPE result in warnings, so fix this by
adding missing documentation.

Signed-off-by: Om Prakash <omprakash.pal@stericsson.com>
Reviewed-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stmpe.c       |    2 +-
 drivers/mfd/stmpe.h       |    1 +
 include/linux/mfd/stmpe.h |    3 +++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 7ab7746..2963689 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -228,7 +228,7 @@ int stmpe_block_write(struct stmpe *stmpe, u8 reg, u8 length,
 EXPORT_SYMBOL_GPL(stmpe_block_write);
 
 /**
- * stmpe_set_altfunc: set the alternate function for STMPE pins
+ * stmpe_set_altfunc()- set the alternate function for STMPE pins
  * @stmpe:	Device to configure
  * @pins:	Bitmask of pins to affect
  * @block:	block to enable alternate functions for
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index 0dbdc4e..e4ee3895 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -42,6 +42,7 @@ struct stmpe_variant_block {
  * @id_mask:	bits valid in CHIPID register for comparison with id_val
  * @num_gpios:	number of GPIOS
  * @af_bits:	number of bits used to specify the alternate function
+ * @regs: variant specific registers.
  * @blocks:	list of blocks present on this device
  * @num_blocks:	number of blocks present on this device
  * @num_irqs:	number of internal IRQs available on this device
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index e762c27..be1af7c 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -57,6 +57,7 @@ struct stmpe_variant_info;
  * @irq_lock: IRQ bus lock
  * @dev: device, mostly for dev_dbg()
  * @i2c: i2c client
+ * @partnum: part number
  * @variant: the detected STMPE model number
  * @regs: list of addresses of registers which are at different addresses on
  *	  different variants.  Indexed by one of STMPE_IDX_*.
@@ -121,6 +122,8 @@ struct stmpe_keypad_platform_data {
  * @norequest_mask: bitmask specifying which GPIOs should _not_ be
  *		    requestable due to different usage (e.g. touch, keypad)
  *		    STMPE_GPIO_NOREQ_* macros can be used here.
+ * @setup: board specific setup callback.
+ * @remove: board specific remove callback
  */
 struct stmpe_gpio_platform_data {
 	int gpio_base;
-- 
1.7.3.2

