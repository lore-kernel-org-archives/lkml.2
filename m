Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab0JNW4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:56:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51894 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab0JNW4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:56:35 -0400
Message-ID: <4CB78AA1.40909@ti.com>
Date: Thu, 14 Oct 2010 17:56:33 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Elvis Dowson <elvis.dowson@mac.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: Difference between twl4030_hsmmc_info and omap_mmc_platform_data
References: <DB759C09-975B-4088-B334-79F9010573F8@mac.com>
In-Reply-To: <DB759C09-975B-4088-B334-79F9010573F8@mac.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elvis Dowson had written, on 10/14/2010 04:48 PM, the following:
> Hi,
>  I'm trying to bring up a TI WL1271 wlan module connected to MMC2 controller of a TI OMAP 3530 processor. 
> 
> I am unclear about the difference between the use of twl4030_hsmmc_info and omap_mmc_platform_data, to set the attributes and constraints for the MMC1 (connected to microSD card) and MMC2 (connected to WLAN module). 
could you please fix your mailer btw for line wraps?

> 
> The beagleboard uses twl4030_mmc_init, which has a wrapper for omap_mmc_platform_data defined in mmc-twl4030.h. 
> 
> The board-sholes-hsmmc.c doesn't use twl4030, but directly uses the omap_mmc_platform_data structure. 
> 
> Example: 
> 
> board-omap3beagle.c uses twl4030_mmc_init, which internally uses the following structure to define mmc properties. 
> 
> static struct twl4030_hsmmc_info mmc[] = {
> 	{
> 		.mmc            = 1,
> 		.wires          = 8,
> 		.gpio_wp        = -ENOSYS,
> 		.gpio_cd        = -ENOSYS,
> 		.name           = "MMC1 controller slot"
> 	},
> 	{
> 		.mmc            = 2,
> 		.wires          = 4,
> 		.gpio_cd        = -EINVAL,
> 		.gpio_wp        = -EINVAL,
> //		.transceiver    = true,
> 		.name           = "MMC2 controller slot",
> 		.ocr_mask       = 0x00000080,
> 	},
> 	{}	/* Terminator */
> };
> 
> For board-sholes-hsmmc.c, it uses a omap_mmc_platform_data
> 
> static struct omap_mmc_platform_data mmc1_data = {
> 	.nr_slots			= 1,
> 	.init				= hsmmc_late_init,
> 	.cleanup			= hsmmc_cleanup,
> #ifdef CONFIG_PM
> 	.suspend			= hsmmc_suspend,
> 	.resume				= hsmmc_resume,
> #endif
> 	.dma_mask			= 0xffffffff,
> 	.slots[0] = {
> 		.wires			= 8,
> 		.set_power		= hsmmc_set_power,
> 		.ocr_mask		= MMC_VDD_32_33 | MMC_VDD_33_34 |
> 						MMC_VDD_165_195,
> 		.name			= "first slot",
> 		/* we get car_detect_irq later */
> 		.card_detect_irq	= 0,
> 		.card_detect            = hsmmc_card_detect,
> 	},
> };

Dont have a board-sholes-hsmm.c in l-o[1]... :( so not sure which kernel 
you are talking about here.
mainline does it this way:
board files report using omap2_hsmmc_info[2] to hsmmc.c using 
omap2_hsmmc_init[3] - hsmmc.c converts them to required datastructures 
that omap_hsmmc.c uses..

[1] 
http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=tree;f=arch/arm/mach-omap2;h=abedb1903a0d81f33d7614480da0f7a0c78f8f2f;hb=HEAD
[2] 
http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=blob;f=arch/arm/mach-omap2/hsmmc.h;h=281e97287adf988493efd1ca94b19ab8588b7aaf;hb=HEAD#l11
[3] 
http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=blob;f=arch/arm/mach-omap2/board-omap3beagle.c;h=73689c082b26d0ef38233c0adefc1d0b9d14e8d0;hb=HEAD#l287
-- 
Regards,
Nishanth Menon
