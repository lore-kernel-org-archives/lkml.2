Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab0KVIz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:55:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61633 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0KVIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:55:25 -0500
From: "Srinath R" <srinath@mistralsolutions.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
Cc: <linux-omap@vger.kernel.org>, <nm@ti.com>, <linux@arm.linux.org.uk>,
        <umeshk@mistralsolutions.com>, <tony@atomide.com>,
        <nagendra@mistralsolutions.com>, <linux-kernel@vger.kernel.org>,
        <khilman@deeprootsystems.com>, <jdk@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <[PATCH] AM35xx-Craneboard-Add-USB-EHCI-support> <1290182862-21837-1-git-send-email-srinath@mistralsolutions.com> <4CE7B35F.6000704@ru.mvista.com>
In-Reply-To: <4CE7B35F.6000704@ru.mvista.com>
Subject: RE: [Patch v1] AM35xx: Craneboard: Add USB EHCI support
Date: Mon, 22 Nov 2010 14:25:48 +0530
Message-ID: <000501cb8a23$12ec36f0$38c4a4d0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuIp89b5d4+Sh6MTgOkSL28HyvQtABexK/A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

Thanks for review, I will modify and resend patch.

With Regards
Srinath

-----Original Message-----
From: Sergei Shtylyov [mailto:sshtylyov@mvista.com] 
Sent: Saturday, November 20, 2010 5:09 PM
To: srinath@mistralsolutions.com
Cc: linux-omap@vger.kernel.org; nm@ti.com; linux@arm.linux.org.uk;
umeshk@mistralsolutions.com; tony@atomide.com;
nagendra@mistralsolutions.com; linux-kernel@vger.kernel.org;
khilman@deeprootsystems.com; jdk@ti.com;
linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v1] AM35xx: Craneboard: Add USB EHCI support

Hello.

On 19-11-2010 19:07, srinath@mistralsolutions.com wrote:

> From: Srinath<srinath@mistralsolutions.com>

> AM3517/05 Craneboard has one EHCI interface on board using port1.

> GPIO35 is used as power enable.
> GPIO38 is used as port1 PHY reset.

> Signed-off-by: Srinath<srinath@mistralsolutions.com>
> ---
>   arch/arm/mach-omap2/board-am3517crane.c |   21 +++++++++++++++++++++
>   1 files changed, 21 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/mach-omap2/board-am3517crane.c
b/arch/arm/mach-omap2/board-am3517crane.c
> index 13ead33..0e1a806 100644
> --- a/arch/arm/mach-omap2/board-am3517crane.c
> +++ b/arch/arm/mach-omap2/board-am3517crane.c
[...]
> @@ -53,10 +55,29 @@ static void __init am3517_crane_init_irq(void)
>   	omap_gpio_init();
>   }
>
> +static struct ehci_hcd_omap_platform_data ehci_pdata __initdata = {
> +	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
> +	.port_mode[1] = EHCI_HCD_OMAP_MODE_UNKNOWN,
> +	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
> +
> +	.phy_reset  = true,
> +	.reset_gpio_port[0]  = 38,
> +	.reset_gpio_port[1]  = -EINVAL,
> +	.reset_gpio_port[2]  = -EINVAL
> +};
> +
>   static void __init am3517_crane_init(void)
>   {
>   	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
>   	omap_serial_init();
> +
> +	/* Configure GPIO for EHCI port */
> +	omap_mux_init_gpio(35, OMAP_PIN_OUTPUT);
> +	gpio_request(35, "usb_ehci_enable");
> +	gpio_direction_output(35, 1);
> +	gpio_set_value(35, 1);

    There's no need to call gpio_set_value(), as gpio_direction_output() has

already set the GPIO's value.

WBR, Sergei

