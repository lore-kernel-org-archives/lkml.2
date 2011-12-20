Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1LTLSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:18:31 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55693 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab1LTLSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:18:25 -0500
Message-ID: <4EF06EC2.3070907@mvista.com>
Date: Tue, 20 Dec 2011 15:17:22 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>, ajay.gupta@ti.com
CC: davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] davinci: DA850 EVM: OHCI platform code
References: <1324363005-11320-1-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1324363005-11320-1-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-12-2011 10:36, Manjunathappa, Prakash wrote:

> From: Ajay Kumar Gupta<ajay.gupta@ti.com>

> On this board the OHCI port's power control and over-current signals from
> TPS2065 power switch are connected via GPIO1[15] and GPIO2[1] respectively,
> so we can implement the DA8xx OHCI glue layer's hooks for overriding the
> root hub port's power and over-current status bits.

> We also have to properly set up the clocking mode in the CFGCHIP2 register,
> so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB) PHY and
> its output is used to clock the USB 1.1 (OHCI) PHY...

> Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>

    BTW, Prakash, as you'r on the patch's disrtibution path, shouldn't you add 
your signoff as well?

> ---
>   arch/arm/mach-davinci/board-da850-evm.c |  126 +++++++++++++++++++++++++++++++
>   1 files changed, 126 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 6659a90..df74ba5 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
[...]
> +static __init void da850_evm_usb_init(void)
> +{
[...]
> +	ret = gpio_request(ON_BD_USB_DRV, "ON_BD_USB_DRV");
> +	if (ret) {
> +		printk(KERN_ERR "%s: failed to request GPIO for USB 1.1 port "
> +		       "power control: %d\n", __func__, ret);
> +		return;
> +	}
> +	gpio_direction_output(ON_BD_USB_DRV, 0);

    You should also use gpio_request_one() instead 
gpio_request()/gpio_direction_output() pair.

> +
> +	ret = gpio_request(ON_BD_USB_OVC, "ON_BD_USB_OVC");
> +	if (ret) {
> +		printk(KERN_ERR "%s: failed to request GPIO for USB 1.1 port "
> +		       "over-current indicator: %d\n", __func__, ret);
> +		return;
> +	}
> +	gpio_direction_input(ON_BD_USB_OVC);

    Same here.

WBR, Sergei
