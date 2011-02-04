Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1BDIyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 03:54:23 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:58821 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab1BDIyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 03:54:20 -0500
X-Greylist: delayed 1947 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Feb 2011 03:54:18 EST
Message-ID: <4D4BB6D4.8070607@stericsson.com>
Date: Fri, 4 Feb 2011 09:20:36 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 03/19] ab3550: mfd_cell is now implicitly available to
 drivers
References: <20110202195417.228e2656@queued.net> <20110202200139.7391044f@queued.net>
In-Reply-To: <20110202200139.7391044f@queued.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,
Thanks for your input on ab3550. You are absolutely right the platform 
data is not used in mainline right now. However we have a few ab3550 
drivers (regulator, gpadc..) that uses the platform data. They have been 
lying on the shelf for a while now but I at least plan to mainline them 
at some point.

BR,
/Mattias Wallin

On 02/03/2011 05:01 AM, Andres Salomon wrote:
>
> No need to explicitly set the cell's platform_data/data_size.
>
> This wasn't actually used anywhere by the ab3550 stuff; dev_data
> in mach-u300's i2c code was empty.
>
> Signed-off-by: Andres Salomon<dilinger@queued.net>
> ---
>   arch/arm/mach-u300/i2c.c   |    2 --
>   drivers/mfd/ab3550-core.c  |    6 ------
>   include/linux/mfd/abx500.h |    2 --
>   3 files changed, 0 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
> index f0394ba..1ff7a82 100644
> --- a/arch/arm/mach-u300/i2c.c
> +++ b/arch/arm/mach-u300/i2c.c
> @@ -291,8 +291,6 @@ static struct ab3550_platform_data ab3550_plf_data = {
>   		.base = IRQ_AB3550_BASE,
>   		.count = (IRQ_AB3550_END - IRQ_AB3550_BASE + 1),
>   	},
> -	.dev_data = {
> -	},
>   	.init_settings = ab3550_init_settings,
>   	.init_settings_sz = ARRAY_SIZE(ab3550_init_settings),
>   };
> diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
> index 5fbca34..47625b9 100644
> --- a/drivers/mfd/ab3550-core.c
> +++ b/drivers/mfd/ab3550-core.c
> @@ -1319,12 +1319,6 @@ static int __init ab3550_probe(struct i2c_client *client,
>   	if (err)
>   		goto exit_no_ops;
>
> -	/* Set up and register the platform devices. */
> -	for (i = 0; i<  AB3550_NUM_DEVICES; i++) {
> -		ab3550_devs[i].platform_data = ab3550_plf_data->dev_data[i];
> -		ab3550_devs[i].data_size = ab3550_plf_data->dev_data_sz[i];
> -	}
> -
>   	err = mfd_add_devices(&client->dev, 0, ab3550_devs,
>   		ARRAY_SIZE(ab3550_devs), NULL,
>   		ab3550_plf_data->irq.base);
> diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
> index 67bd6f7..a735210 100644
> --- a/include/linux/mfd/abx500.h
> +++ b/include/linux/mfd/abx500.h
> @@ -185,8 +185,6 @@ struct abx500_init_settings {
>    */
>   struct ab3550_platform_data {
>   	struct {unsigned int base; unsigned int count; } irq;
> -	void *dev_data[AB3550_NUM_DEVICES];
> -	size_t dev_data_sz[AB3550_NUM_DEVICES];
>   	struct abx500_init_settings *init_settings;
>   	unsigned int init_settings_sz;
>   };

