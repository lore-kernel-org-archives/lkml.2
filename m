Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab1LTLI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:08:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57795 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1LTLIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:08:20 -0500
Message-ID: <4EF06C64.8000708@mvista.com>
Date: Tue, 20 Dec 2011 15:07:16 +0400
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

On 20.12.2011 10:36, Manjunathappa, Prakash wrote:

> From: Ajay Kumar Gupta <ajay.gupta@ti.com>

    It's a good practice to CC the original author of the patch -- which I'm 
doing now...

> On this board the OHCI port's power control and over-current signals from
> TPS2065 power switch are connected via GPIO1[15] and GPIO2[1] respectively,

    Ajay, your description seems to be copied unchganged from the analogous 
DA830 EVM patch, and thus doesn't match your patch: GPIO2[4] and GPIO6[13] are 
used apparently. Be more attentive to detail next time please.

> so we can implement the DA8xx OHCI glue layer's hooks for overriding the
> root hub port's power and over-current status bits.

> We also have to properly set up the clocking mode in the CFGCHIP2 register,
> so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB) PHY and
> its output is used to clock the USB 1.1 (OHCI) PHY...

> Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
> ---
>   arch/arm/mach-davinci/board-da850-evm.c |  126 +++++++++++++++++++++++++++++++
>   1 files changed, 126 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 6659a90..df74ba5 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
[...]
> @@ -734,6 +736,127 @@ static struct davinci_i2c_platform_data da850_evm_i2c_0_pdata = {
[...]
> +static int da850_evm_usb_ocic_notify(da8xx_ocic_handler_t handler)
> +{
> +	int irq		= gpio_to_irq(ON_BD_USB_OVC);
> +	int error	= 0;
> +
> +	if (handler != NULL) {
> +		da850_evm_usb_ocic_handler = handler;
> +
> +		error = request_irq(irq, da850_evm_usb_ocic_irq, IRQF_DISABLED |

    IRQF_DISABLED is a nop now -- just remove it.

WBR, Sergei
