Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1GUQAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:00:23 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:4563
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab1GUQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:00:21 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKc8kzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 22 Jul 2011 00:07:17 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
CC: <arnd@arndb.de>, Dajun <dajun.chen@diasemi.com>, <sameo@openedhand.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linaro-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Message-ID: <20110721160716.GB26837@S2100-06.ap.freescale.net>
References: <1309876620.960.169.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309876620.960.169.camel@L-0532.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 08:07:00PM +0530, ashishj3 wrote:
> The DA9052 is a highly integrated PMIC subsystem with supply domain flexibility
> to support wide range of high performance application.
> 
> It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> control and other functionality.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
[...]
> diff --git a/include/linux/mfd/da9052/pdata.h b/include/linux/mfd/da9052/pdata.h
> new file mode 100755
> index 0000000..75d82a3
> --- /dev/null
> +++ b/include/linux/mfd/da9052/pdata.h
> @@ -0,0 +1,43 @@
> +/*
> + * Platform data declarations for DA9052 PMICs.
> + *
> + * Copyright(c) 2011 Dialog Semiconductor Ltd.
> + *
> + * Author: David Dajun Chen <dchen@diasemi.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#ifndef __MFD_DA9052_PDATA_H__
> +#define __MFD_DA9052_PDATA_H__
> +
> +#define DA9052_MAX_REGULATORS	15
> +
> +struct da9052;
> +
> +struct da9052_pdata {
> +	struct led_platform_data *pled;
> +	struct da9052_wdt_platform_data *pwdt;
> +	struct da9052_tsi_platform_data *ptsi;
> +	int (*init) (struct da9052 *da9052);

Do you have any actually example to demonstrate the necessity of
this hook?  Otherwise, I would suggest we drop it, since machine
code can always do whatever setup needed there.

I'm asking because this kind of hooks always get in the way of the
device tree conversion.

Regards,
Shawn

> +	int irq;
> +	int irq_base;
> +	int num_regulators;
> +	int gpio_base;
> +	struct regulator_init_data *regulators[DA9052_MAX_REGULATORS];
> +};

