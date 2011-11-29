Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1K2TvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:51:01 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1228 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1K2TvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:51:00 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4ED53793.80209@broadcom.com>
Date: Tue, 29 Nov 2011 11:50:43 -0800
From: "Jiandong Zheng" <jdzheng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929
 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Axel Lin" <axel.lin@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Scott Branden" <sbranden@broadcom.com>,
        "Wan ZongShun" <mcuos.com@gmail.com>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        "Jamie Iles" <jamie@jamieiles.com>, "Olof Johansson" <olof@lixom.net>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>,
        "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        "Manuel Lauss" <manuel.lauss@googlemail.com>,
        "Vimal Singh" <vimal.newwork@gmail.com>,
        "Andres Salomon" <dilinger@queued.net>,
        "Sukumar Ghorai" <s-ghorai@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: convert drivers/mtd/* to use
 module_platform_driver()
References: <1322397903.2799.5.camel@phoenix>
In-Reply-To: <1322397903.2799.5.camel@phoenix>
X-WSS-ID: 62CBE6F43DS1803944-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2011 4:45 AM, Axel Lin wrote:
> This patch converts the drivers in drivers/mtd/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: David Woodhouse<dwmw2@infradead.org>
> Cc: Jiandong Zheng<jdzheng@broadcom.com>
> Cc: Scott Branden<sbranden@broadcom.com>
> Cc: Wan ZongShun<mcuos.com@gmail.com>
> Cc: Dmitry Eremin-Solenikov<dbaryshkov@gmail.com>
> Cc: Jamie Iles<jamie@jamieiles.com>
> Cc: Olof Johansson<olof@lixom.net>
> Cc: Kyungmin Park<kyungmin.park@samsung.com>
> Cc: Haojian Zhuang<haojian.zhuang@gmail.com>
> Cc: Artem Bityutskiy<Artem.Bityutskiy@nokia.com>
> Cc: Ralf Baechle<ralf@linux-mips.org>
> Cc: Brian Norris<computersforpeace@gmail.com>
> Cc: Lars-Peter Clausen<lars@metafoo.de>
> Cc: Manuel Lauss<manuel.lauss@googlemail.com>
> Cc: Vimal Singh<vimal.newwork@gmail.com>
> Cc: Andres Salomon<dilinger@queued.net>
> Cc: Sukumar Ghorai<s-ghorai@ti.com>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---

>   drivers/mtd/nand/bcm_umi_nand.c     |   13 +------------

> diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
> index 46b58d6..50387fd 100644
> --- a/drivers/mtd/nand/bcm_umi_nand.c
> +++ b/drivers/mtd/nand/bcm_umi_nand.c
> @@ -546,18 +546,7 @@ static struct platform_driver nand_driver = {
>          .resume = bcm_umi_nand_resume,
>   };
>
> -static int __init nand_init(void)
> -{
> -       return platform_driver_register(&nand_driver);
> -}
> -
> -static void __exit nand_exit(void)
> -{
> -       platform_driver_unregister(&nand_driver);
> -}
> -
> -module_init(nand_init);
> -module_exit(nand_exit);
> +module_platform_driver(nand_driver);
>
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("Broadcom");

Acked-by: Jiandong Zheng <jdzheng@broadcom.com>


