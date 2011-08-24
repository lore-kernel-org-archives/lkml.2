Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1HXNca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:32:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53717 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1HXNc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:32:28 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 24 Aug 2011 15:28:25 +0200
Message-Id: <1314192505-23499-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
 <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH 6/6] mfd/mc13xxx: remove mc13783 API functions and symbols
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all in-tree users are fixed to use the more general mc13xxx API
the obsolete stuff can go away.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13xxx-core.c  |   12 -----
 include/linux/mfd/mc13783.h |  112 -------------------------------------------
 2 files changed, 0 insertions(+), 124 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 5ee5e64..5f782ad 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -30,16 +30,6 @@ struct mc13xxx {
 	int adcflags;
 };
 
-struct mc13783 {
-	struct mc13xxx mc13xxx;
-};
-
-struct mc13xxx *mc13783_to_mc13xxx(struct mc13783 *mc13783)
-{
-	return &mc13783->mc13xxx;
-}
-EXPORT_SYMBOL(mc13783_to_mc13xxx);
-
 #define MC13XXX_IRQSTAT0	0
 #define MC13XXX_IRQSTAT0_ADCDONEI	(1 << 0)
 #define MC13XXX_IRQSTAT0_ADCBISDONEI	(1 << 1)
@@ -558,8 +548,6 @@ static const char *mc13xxx_get_chipname(struct mc13xxx *mc13xxx)
 	return mc13xxx_chipname[devid->driver_data];
 }
 
-#include <linux/mfd/mc13783.h>
-
 int mc13xxx_get_flags(struct mc13xxx *mc13xxx)
 {
 	struct mc13xxx_platform_data *pdata =
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index e7a3c01..a8eeda7 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -12,118 +12,6 @@
 
 #include <linux/mfd/mc13xxx.h>
 
-struct mc13783;
-
-struct mc13xxx *mc13783_to_mc13xxx(struct mc13783 *mc13783);
-
-static inline void mc13783_lock(struct mc13783 *mc13783)
-{
-	mc13xxx_lock(mc13783_to_mc13xxx(mc13783));
-}
-
-static inline void mc13783_unlock(struct mc13783 *mc13783)
-{
-	mc13xxx_unlock(mc13783_to_mc13xxx(mc13783));
-}
-
-static inline int mc13783_reg_read(struct mc13783 *mc13783,
-		unsigned int offset, u32 *val)
-{
-	return mc13xxx_reg_read(mc13783_to_mc13xxx(mc13783), offset, val);
-}
-
-static inline int mc13783_reg_write(struct mc13783 *mc13783,
-		unsigned int offset, u32 val)
-{
-	return mc13xxx_reg_write(mc13783_to_mc13xxx(mc13783), offset, val);
-}
-
-static inline int mc13783_reg_rmw(struct mc13783 *mc13783,
-		unsigned int offset, u32 mask, u32 val)
-{
-	return mc13xxx_reg_rmw(mc13783_to_mc13xxx(mc13783), offset, mask, val);
-}
-
-static inline int mc13783_get_flags(struct mc13783 *mc13783)
-{
-	return mc13xxx_get_flags(mc13783_to_mc13xxx(mc13783));
-}
-
-static inline int mc13783_irq_request(struct mc13783 *mc13783, int irq,
-		irq_handler_t handler, const char *name, void *dev)
-{
-	return mc13xxx_irq_request(mc13783_to_mc13xxx(mc13783), irq,
-			handler, name, dev);
-}
-
-static inline int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
-		irq_handler_t handler, const char *name, void *dev)
-{
-	return mc13xxx_irq_request_nounmask(mc13783_to_mc13xxx(mc13783), irq,
-			handler, name, dev);
-}
-
-static inline int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev)
-{
-	return mc13xxx_irq_free(mc13783_to_mc13xxx(mc13783), irq, dev);
-}
-
-static inline int mc13783_irq_mask(struct mc13783 *mc13783, int irq)
-{
-	return mc13xxx_irq_mask(mc13783_to_mc13xxx(mc13783), irq);
-}
-
-static inline int mc13783_irq_unmask(struct mc13783 *mc13783, int irq)
-{
-	return mc13xxx_irq_unmask(mc13783_to_mc13xxx(mc13783), irq);
-}
-static inline int mc13783_irq_status(struct mc13783 *mc13783, int irq,
-		int *enabled, int *pending)
-{
-	return mc13xxx_irq_status(mc13783_to_mc13xxx(mc13783),
-			irq, enabled, pending);
-}
-
-static inline int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
-{
-	return mc13xxx_irq_ack(mc13783_to_mc13xxx(mc13783), irq);
-}
-
-#define MC13783_ADC0		MC13XXX_ADC0
-#define MC13783_ADC0_ADREFEN		MC13XXX_ADC0_ADREFEN
-#define MC13783_ADC0_TSMOD0		MC13XXX_ADC0_TSMOD0
-#define MC13783_ADC0_TSMOD1		MC13XXX_ADC0_TSMOD1
-#define MC13783_ADC0_TSMOD2		MC13XXX_ADC0_TSMOD2
-#define MC13783_ADC0_ADINC1		MC13XXX_ADC0_ADINC1
-#define MC13783_ADC0_ADINC2		MC13XXX_ADC0_ADINC2
-
-#define MC13783_ADC0_TSMOD_MASK		MC13XXX_ADC0_TSMOD_MASK
-
-#define mc13783_regulator_init_data mc13xxx_regulator_init_data
-#define mc13783_regulator_platform_data mc13xxx_regulator_platform_data
-#define mc13783_led_platform_data mc13xxx_led_platform_data
-#define mc13783_leds_platform_data mc13xxx_leds_platform_data
-
-#define mc13783_platform_data mc13xxx_platform_data
-#define MC13783_USE_TOUCHSCREEN	MC13XXX_USE_TOUCHSCREEN
-#define MC13783_USE_CODEC	MC13XXX_USE_CODEC
-#define MC13783_USE_ADC		MC13XXX_USE_ADC
-#define MC13783_USE_RTC		MC13XXX_USE_RTC
-#define MC13783_USE_REGULATOR	MC13XXX_USE_REGULATOR
-#define MC13783_USE_LED		MC13XXX_USE_LED
-
-#define MC13783_ADC_MODE_TS		MC13XXX_ADC_MODE_TS
-#define MC13783_ADC_MODE_SINGLE_CHAN	MC13XXX_ADC_MODE_SINGLE_CHAN
-#define MC13783_ADC_MODE_MULT_CHAN	MC13XXX_ADC_MODE_MULT_CHAN
-
-static inline int mc13783_adc_do_conversion(struct mc13783 *mc13783,
-		unsigned int mode, unsigned int channel, unsigned int *sample)
-{
-	return mc13xxx_adc_do_conversion(mc13783_to_mc13xxx(mc13783), mode,
-			channel, sample);
-}
-
-
 #define	MC13783_REG_SW1A		0
 #define	MC13783_REG_SW1B		1
 #define	MC13783_REG_SW2A		2
-- 
1.7.5.4

