Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab0JOVKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:10:11 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:36696 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932441Ab0JOVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:10:10 -0400
Message-ID: <4CB8C31A.3000000@eukrea.com>
Date: Fri, 15 Oct 2010 23:09:46 +0200
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, u.kleine-koenig@pengutronix.de,
        xiao-lizhang@freescale.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2/2] ARM: imx: Add POWER_KEY to mx51 babbage board
References: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com> <1287173908-25758-2-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1287173908-25758-2-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14058549188484705663
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

Le 15/10/2010 22:18, Dinh.Nguyen@freescale.com a écrit :
> +/*!
> + * Power Key interrupt handler.
> + */
> +static irqreturn_t power_key_int(int irq, void *dev_id)
> +{
> +	printk(KERN_INFO "PWR key pressed\n");
> +	return 0;
> +}
> +
> +/*!
> + * Power Key initialization.
> + */
> +static int __init mxc_init_power_key(void)
> +{
> +	/* Set power key as wakeup resource */
> +	int irq, ret;
> +
> +	/* power key */
> +	ret = gpio_request(BABBAGE_POWER_KEY, "power-key");
> +	if (ret) {
> +		printk(KERN_ERR"failed to get BABBAGE_POWER_KEY: %d\n", ret);
> +		return ret;
> +	}
> +	gpio_direction_input(BABBAGE_POWER_KEY);
> +
> +	irq = IOMUX_TO_IRQ(BABBAGE_POWER_KEY);
> +	set_irq_type(irq, IRQF_TRIGGER_RISING);
> +	ret = request_irq(irq, power_key_int, 0, "power-key", 0);
> +	if (ret)
> +		pr_info("register on-off key interrupt failed\n");
> +	else
> +		enable_irq_wake(irq);
> +	return ret;
> +}
> +late_initcall(mxc_init_power_key);
> +
instead of doing this, you could use the gpio-keys driver which will configure 
the IRQ as a wakeup source and also send keys to the input layer.

You can have an example here :
http://git.pengutronix.de/?p=imx/linux-2.6.git;a=blob;f=arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c;h=2b48f5190830c7cbe2f11676a628c55e1531c133;hb=imx-for-2.6.37#l98

Eric
