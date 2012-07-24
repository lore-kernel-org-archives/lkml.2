Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2GXLMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 07:12:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47364 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586Ab2GXLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 07:12:11 -0400
Message-ID: <500E82D4.9090702@mvista.com>
Date: Tue, 24 Jul 2012 15:11:16 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, nsekhar@ti.com, khilman@ti.com,
        a.zummo@towertech.it, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/6] ARM: davinci: remove rtc kicker release
References: <cover.1343046707.git.afzal@ti.com> <f9e348c8cb7402b27b1a5633b06620266e369641.1343046707.git.afzal@ti.com>
In-Reply-To: <f9e348c8cb7402b27b1a5633b06620266e369641.1343046707.git.afzal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-07-2012 17:42, Afzal Mohammed wrote:

> rtc-omap driver is now capable of handling kicker mechanism,
> hence remove kicker handling at platform level, instead
> provide proper device name so that driver can handle kicker
> mechanism by itself

> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
>   arch/arm/mach-davinci/devices-da8xx.c |   13 +------------
>   1 files changed, 1 insertions(+), 12 deletions(-)

> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index d1624a3..c915bff 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -679,7 +679,7 @@ static struct resource da8xx_rtc_resources[] = {
>   };
>
>   static struct platform_device da8xx_rtc_device = {
> -	.name           = "omap_rtc",
> +	.name           = "am1808-rtc",

    Why not "da8xx-rtc". Kick registers exist startting with 
DA830/OMAP-L137/AM1707, not only on AM1808.

>   	.id             = -1,
>   	.num_resources	= ARRAY_SIZE(da8xx_rtc_resources),
>   	.resource	= da8xx_rtc_resources,
> @@ -688,17 +688,6 @@ static struct platform_device da8xx_rtc_device = {
>   int da8xx_register_rtc(void)
>   {
>   	int ret;
> -	void __iomem *base;
> -
> -	base = ioremap(DA8XX_RTC_BASE, SZ_4K);
> -	if (WARN_ON(!base))
> -		return -ENOMEM;
> -
> -	/* Unlock the rtc's registers */
> -	__raw_writel(0x83e70b13, base + 0x6c);
> -	__raw_writel(0x95a4f1e0, base + 0x70);
> -
> -	iounmap(base);
>
>   	ret = platform_device_register(&da8xx_rtc_device);
>   	if (!ret)

WBR, Sergei

