Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1KOVB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:01:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab1KOVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:01:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Wan ZongShun <mcuos.com@gmail.com>
Subject: Re: [PATCH] ARM: NUC900: add and change some device clk definitions.
Date: Tue, 15 Nov 2011 21:01:50 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <4EC25D72.4070909@gmail.com>
In-Reply-To: <4EC25D72.4070909@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201111152101.51000.arnd@arndb.de>
X-Provags-ID: V02:K0:dfay3AkCVb3oEYSL4rgXO9yo8FSJyr7apwAE42gM/Gn
 q/yOe/7Xx3x1de3GB7BEkhvseE7nFMaeIDeMkezmhI0J529EE8
 LCw+1QYTH6FRlVcnhnBNyI7N2cnWbIbSx1ZNqwegWIjg20DjCr
 qwdEZ+GLwxsvM7KL+yT1iS5tkpHjl2g8aK17Fi3ruHVywF7CqT
 Bd3l7EyOkA3KPbdP/HJ2TdkpzOWLS7kc4fSE3e/jFIrW4C9MlF
 TgYaZ7q/mTasf/HQ/iFfM4vMvbJ4mjwz9JfEcQTHIsZpYBpwK2
 NIZGzPYaXWZgQM0iNzQcrMEs2wdshPzbWkqjO+c/9RrbygWtOv
 HlhmWcxb5vse+gaQkXKI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 November 2011, Wan ZongShun wrote:
> This patch is to modify usb, audio and add i2c clk setting in cpu.c.
> Also, add DMA, FMI definition to nuc900_iodesc, since I will use them
> in the corresponding driver.
> 
> ---
>  arch/arm/mach-w90x900/cpu.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
> index 0a235e5..6eeadfc 100644
> --- a/arch/arm/mach-w90x900/cpu.c
> +++ b/arch/arm/mach-w90x900/cpu.c
> @@ -46,6 +46,8 @@ static struct map_desc nuc900_iodesc[] __initdata = {
>  	IODESC_ENT(TIMER),
>  	IODESC_ENT(EBI),
>  	IODESC_ENT(GPIO),
> +	IODESC_ENT(DMA),
> +	IODESC_ENT(FMI),
>  };

Can you change the driver to instead use ioremap with the device resources?
I think that would be much preferred. The two main uses of map_desc are
for devices that you need very early and in order to get larger than 4k
TLB entries. Neither of these seem to apply here.

	Arnd
