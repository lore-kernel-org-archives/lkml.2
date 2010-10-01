Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0JAN3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:29:46 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:12035 "EHLO protonic.prtnl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756167Ab0JAN3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:29:45 -0400
X-Greylist: delayed 1705 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Oct 2010 09:29:45 EDT
From: David Jander <david.jander@protonic.nl>
Organization: Protonic Holland
To: customers.protonic@pengutronix.de
Subject: Re: [Customers.Protonic] [PATCH 3/4] mfd/mc13xxx: add support for mc13892
Date: Fri, 1 Oct 2010 15:02:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; i686; ; )
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
References: <20100929162315.GG29811@pengutronix.de> <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010011502.03780.david.jander@protonic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 September 2010 06:23:46 pm Uwe Kleine-König wrote:
>[...]
> --- /dev/null
> +++ b/include/linux/mfd/mc13xxx.h
> @@ -0,0 +1,154 @@
> +/*
> + * Copyright 2009-2010 Pengutronix
> + * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it
>  under + * the terms of the GNU General Public License version 2 as
>  published by the + * Free Software Foundation.
> + */
> +#ifndef __LINUX_MFD_MC13XXX_H
> +#define __LINUX_MFD_MC13XXX_H
> +
> +#include <linux/interrupt.h>
> +
> +struct mc13xxx;
> +
> +void mc13xxx_lock(struct mc13xxx *mc13xxx);
> +void mc13xxx_unlock(struct mc13xxx *mc13xxx);
> +
> +int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32
>  *val); +int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int
>  offset, u32 val); +int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned
>  int offset, +		u32 mask, u32 val);
> +
> +int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
> +
> +int mc13xxx_irq_request(struct mc13xxx *mc13xxx, int irq,
> +		irq_handler_t handler, const char *name, void *dev);
> +int mc13xxx_irq_request_nounmask(struct mc13xxx *mc13xxx, int irq,
> +		irq_handler_t handler, const char *name, void *dev);
> +int mc13xxx_irq_free(struct mc13xxx *mc13xxx, int irq, void *dev);
> +
> +int mc13xxx_irq_mask(struct mc13xxx *mc13xxx, int irq);
> +int mc13xxx_irq_unmask(struct mc13xxx *mc13xxx, int irq);
> +int mc13xxx_irq_status(struct mc13xxx *mc13xxx, int irq,
> +		int *enabled, int *pending);
> +int mc13xxx_irq_ack(struct mc13xxx *mc13xxx, int irq);
> +
> +int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
> +
> +#define MC13XXX_IRQ_ADCDONE	0
> +#define MC13XXX_IRQ_ADCBISDONE	1
> +#define MC13XXX_IRQ_TS		2
> +#define MC13XXX_IRQ_CHGDET	6
> +#define MC13XXX_IRQ_CHGREV	8
> +#define MC13XXX_IRQ_CHGSHORT	9
> +#define MC13XXX_IRQ_CCCV	10
> +#define MC13XXX_IRQ_CHGCURR	11
> +#define MC13XXX_IRQ_BPON	12
> +#define MC13XXX_IRQ_LOBATL	13
> +#define MC13XXX_IRQ_LOBATH	14
> +#define MC13XXX_IRQ_1HZ		24
> +#define MC13XXX_IRQ_TODA	25
> +#define MC13XXX_IRQ_SYSRST	30
> +#define MC13XXX_IRQ_RTCRST	31
> +#define MC13XXX_IRQ_PC		32
> +#define MC13XXX_IRQ_WARM	33
> +#define MC13XXX_IRQ_MEMHLD	34
> +#define MC13XXX_IRQ_THWARNL	36
> +#define MC13XXX_IRQ_THWARNH	37
> +#define MC13XXX_IRQ_CLK		38
> +
> +#define MC13XXX_NUM_IRQ		46
> +
> +struct regulator_init_data;
> +
> +struct mc13xxx_regulator_init_data {
> +	int id;
> +	struct regulator_init_data *init_data;
> +};
> +
> +struct mc13xxx_regulator_platform_data {
> +	int num_regulators;
> +	struct mc13xxx_regulator_init_data *regulators;
> +};
> +
> +struct mc13xxx_led_platform_data {
> +#define MC13783_LED_MD		0
> +#define MC13783_LED_AD		1
> +#define MC13783_LED_KP		2
> +#define MC13783_LED_R1		3
> +#define MC13783_LED_G1		4
> +#define MC13783_LED_B1		5
> +#define MC13783_LED_R2		6
> +#define MC13783_LED_G2		7
> +#define MC13783_LED_B2		8
> +#define MC13783_LED_R3		9
> +#define MC13783_LED_G3		10
> +#define MC13783_LED_B3		11
> +#define MC13783_LED_MAX MC13783_LED_B3
> +	int id;
> +	const char *name;
> +	const char *default_trigger;
> +
> +/* Three or two bits current selection depending on the led */
> +	char max_current;
> +};
> +
> +struct mc13xxx_leds_platform_data {
> +	int num_leds;
> +	struct mc13xxx_led_platform_data *led;
> +
> +#define MC13783_LED_TRIODE_MD	(1 << 0)
> +#define MC13783_LED_TRIODE_AD	(1 << 1)
> +#define MC13783_LED_TRIODE_KP	(1 << 2)
> +#define MC13783_LED_BOOST_EN	(1 << 3)
> +#define MC13783_LED_TC1HALF	(1 << 4)
> +#define MC13783_LED_SLEWLIMTC	(1 << 5)
> +#define MC13783_LED_SLEWLIMBL	(1 << 6)
> +#define MC13783_LED_TRIODE_TC1	(1 << 7)
> +#define MC13783_LED_TRIODE_TC2	(1 << 8)
> +#define MC13783_LED_TRIODE_TC3	(1 << 9)
> +	int flags;
> +
> +#define MC13783_LED_AB_DISABLED		0
> +#define MC13783_LED_AB_MD1		1
> +#define MC13783_LED_AB_MD12		2
> +#define MC13783_LED_AB_MD123		3
> +#define MC13783_LED_AB_MD1234		4
> +#define MC13783_LED_AB_MD1234_AD1	5
> +#define MC13783_LED_AB_MD1234_AD12	6
> +#define MC13783_LED_AB_MD1_AD		7
> +	char abmode;
> +
> +#define MC13783_LED_ABREF_200MV	0
> +#define MC13783_LED_ABREF_400MV	1
> +#define MC13783_LED_ABREF_600MV	2
> +#define MC13783_LED_ABREF_800MV	3
> +	char abref;
> +
> +#define MC13783_LED_PERIOD_10MS		0
> +#define MC13783_LED_PERIOD_100MS	1
> +#define MC13783_LED_PERIOD_500MS	2
> +#define MC13783_LED_PERIOD_2S		3
> +	char bl_period;
> +	char tc1_period;
> +	char tc2_period;
> +	char tc3_period;
> +};

The LED drivers in mc13892 and mc13783 are very different. We should have 
separate pdev struct for these!

Best regards,

-- 
David Jander
Protonic Holland.
