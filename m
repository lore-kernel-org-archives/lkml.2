Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab2EaIps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:45:48 -0400
Received: from [37.128.190.40] ([37.128.190.40]:40812 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932341Ab2EaIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:45:40 -0400
Message-ID: <4FC72C8F.30206@codethink.co.uk>
Date: Thu, 31 May 2012 09:32:15 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH RFC 1/3] i2c-nomadik: move header from <plat/i2c.h> to
 <linux/i2c-nomadik.h>
References: <cover.1338398567.git.rubini@gnudd.com> <ca47a47e0a4db31545549ed978e1dc7b3aad4377.1338398567.git.rubini@gnudd.com>
In-Reply-To: <ca47a47e0a4db31545549ed978e1dc7b3aad4377.1338398567.git.rubini@gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/12 18:45, Alessandro Rubini wrote:
> The header and driver were only used by arm/mach-nomadik and
> arm/mach-u8500.  The STA2X11 I/O Hub exports on PCIe a number of
> devices, including i2c-nomadik.  This patch allows compilation of
> the driver under x86.
>
> Signed-off-by: Alessandro Rubini<rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi<giancarlo.asnaghi@st.com>

> -
> -#endif	/* __PLAT_I2C_H */
> diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
> index 5267ab9..09b7589 100644
> --- a/drivers/i2c/busses/i2c-nomadik.c
> +++ b/drivers/i2c/busses/i2c-nomadik.c
> @@ -23,8 +23,7 @@
>   #include<linux/io.h>
>   #include<linux/regulator/consumer.h>
>   #include<linux/pm_runtime.h>
> -
> -#include<plat/i2c.h>
> +#include<linux/i2c-nomadik.h>
>
>   #define DRIVER_NAME "nmk-i2c"
>
> diff --git a/include/linux/i2c-nomadik.h b/include/linux/i2c-nomadik.h
> new file mode 100644
> index 0000000..9350fe9
> --- /dev/null
> +++ b/include/linux/i2c-nomadik.h
> @@ -0,0 +1,39 @@
> +/*
> + * Copyright (C) 2009 ST-Ericsson
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __LINUX_I2C_NOMADIK_H
> +#define __LINUX_I2C_NOMADIK_H
> +
> +enum i2c_freq_mode {
> +	I2C_FREQ_MODE_STANDARD,		/* up to 100 Kb/s */
> +	I2C_FREQ_MODE_FAST,		/* up to 400 Kb/s */
> +	I2C_FREQ_MODE_HIGH_SPEED,	/* up to 3.4 Mb/s */
> +	I2C_FREQ_MODE_FAST_PLUS,	/* up to 1 Mb/s */
> +};
> +
> +/**
> + * struct nmk_i2c_controller - client specific controller configuration
> + * @clk_freq:	clock frequency for the operation mode
> + * @slsu:	Slave data setup time in ns.
> + *		The needed setup time for three modes of operation
> + *		are 250ns, 100ns and 10ns respectively thus leading
> + *		to the values of 14, 6, 2 for a 48 MHz i2c clk
> + * @tft:	Tx FIFO Threshold in bytes
> + * @rft:	Rx FIFO Threshold in bytes
> + * @timeout	Slave response timeout(ms)
> + * @sm:		speed mode
> + */
> +struct nmk_i2c_controller {
> +	unsigned long	clk_freq;
> +	unsigned short	slsu;
> +	unsigned char	tft;
> +	unsigned char	rft;
> +	int timeout;
> +	enum i2c_freq_mode	sm;
> +};
> +
> +#endif	/* __LINUX_I2C_NOMADIK_H */

How about moving it to include/linux/platform_data so that we're
not filling include/linux with a bunch of driver specific includes?

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
