Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2BGQpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:45:41 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:64771 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2BGQpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:45:40 -0500
Message-ID: <4F31552D.9060505@criticallink.com>
Date: Tue, 07 Feb 2012 11:45:33 -0500
From: Michael Williamson <michael.williamson@criticallink.com>
Organization: Critical Link, LLC
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3 3/3] arm:davinci: move NAND and NOR devices as aemif
 MFD slaves
References: <1328627513-30134-1-git-send-email-prakash.pm@ti.com> <1328627513-30134-4-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1328627513-30134-4-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Prakash,

On 2/7/2012 10:11 AM, Manjunathappa, Prakash wrote:

> NAND and NOR device are made as aemif device slaves, hence all DaVinci
> board NAND/NOR device registration achieved via aemif MFD driver.
>
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> ---
> Since v2:
> Make changes for all DaVinci boards in single patch.



[...]

> diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
> index 672d820..bb29b7a 100644
> --- a/arch/arm/mach-davinci/board-mityomapl138.c
> +++ b/arch/arm/mach-davinci/board-mityomapl138.c
> @@ -19,6 +19,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/spi/spi.h>
>  #include <linux/spi/flash.h>
> +#include <linux/mfd/davinci_aemif.h>
>  
>  #include <asm/io.h>
>  #include <asm/mach-types.h>
> @@ -414,18 +415,35 @@ static struct resource mityomapl138_nandflash_resource[] = {
>  	},
>  };
>  
> -static struct platform_device mityomapl138_nandflash_device = {
> -	.name		= "davinci_nand",
> -	.id		= 1,
> -	.dev		= {
> -		.platform_data	= &mityomapl138_nandflash_data,
> +static struct platform_device mityomapl138_emif_devices[] __initdata = {
> +	{
> +		.name		= "davinci_nand",
> +		.id		= 0,



Pretty sure this still needs to be a 1.  The nand is on chip select 3,
EMA_CS3, which I believe is the same as the da850 EVM.

-Mike


