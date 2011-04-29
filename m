Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab1D2Mqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:46:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40072 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1D2Mqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:46:35 -0400
Message-ID: <4DBAB2BC.1090202@ru.mvista.com>
Date: Fri, 29 Apr 2011 16:44:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: srinath@mistralsolutions.com
CC: linux-omap@vger.kernel.org, nm@ti.com, linux@arm.linux.org.uk,
        umeshk@mistralsolutions.com, tony@atomide.com,
        nagendra@mistralsolutions.com, linux-kernel@vger.kernel.org,
        khilman@deeprootsystems.com, jdk@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] AM35xx-Craneboard:Display: Add DVI and TV Support
References: <[PATCH]> <1304077261-17811-2-git-send-email-srinath@mistralsolutions.com>
In-Reply-To: <1304077261-17811-2-git-send-email-srinath@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-04-2011 15:41, srinath@mistralsolutions.com wrote:

> From: Srinath <srinath@mistralsolutions.com>

> Added Display (DVI and TV) support for CraneBoard.

> Signed-off-by: Srinath <srinath@mistralsolutions.com>
[...]

> diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
> index 05867b5..83fe85b 100644
> --- a/arch/arm/mach-omap2/board-am3517crane.c
> +++ b/arch/arm/mach-omap2/board-am3517crane.c
[...]
> @@ -66,11 +69,83 @@ static struct usbhs_omap_board_data usbhs_bdata __initdata = {
>   	.reset_gpio_port[2]  = -EINVAL
>   };
>
> +static void __init am3517_crane_display_init(void)
> +{
> +	int ret;
> +
> +	ret = omap_mux_init_gpio(GPIO_DVI_ENABLE, OMAP_PIN_OUTPUT);
> +	if (ret<  0) {
> +		pr_err("Can not configure mux for GPIO_DVI_ENABLE %d\n",
> +			GPIO_DVI_ENABLE);
> +		return;
> +	}
> +
> +	ret = gpio_request(GPIO_DVI_ENABLE, "dvi_enable");
> +	if (ret<  0) {
> +		pr_err("Can not request GPIO %d\n", GPIO_DVI_ENABLE);
> +		return;
> +	}
> +
> +	ret = gpio_direction_output(GPIO_DVI_ENABLE, 1);
> +	if (ret<  0) {
> +		gpio_free(GPIO_DVI_ENABLE);
> +		pr_err("Unable to enable DVI\n");
> +		return;
> +	}

    You can use gpio_request_one() ISO gpio_request()/gpio_direction_output().

WBR, Sergei
