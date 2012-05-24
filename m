Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab2EXXVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:21:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61507 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2EXXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:21:48 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-c0-4fbec28aa3b9
Message-id: <4FBEC294.1000707@samsung.com>
Date: Fri, 25 May 2012 08:21:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2] mfd: select REGMAP_I2C for config MFD_MAX77693
References: <1337849788.1028.0.camel@phoenix>
In-reply-to: <1337849788.1028.0.camel@phoenix>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd2uQ/v8DRoe2lhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mt38Xsha84ayY8C67gfEbexcjJ4eEgInE5UcHWCFsMYkL99az
	dTFycQgJTGeUeDl5OzuE080ksfhEFxNIFa+AlsS7X7vAOlgEVCX+7W1kBLHZgOL7X9wA6ubg
	EBWIkPjVzwFRLijxY/I9FhBbREBRov/dQ7CZzAJzGCWOLVkNlhAWcJfYea8XbKaQgK7E5E0v
	wOKcAnoSX+5sYQOxmQXUJSbNW8QMYctLbF7zlnkCo8AsJDtmISmbhaRsASPzKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYzgAHwmvYNxVYPFIUYBDkYlHl6Jgn3+QqyJZcWVuYcYJTiYlUR4
	BSOBQrwpiZVVqUX58UWlOanFhxilOViUxHmfLNnhLySQnliSmp2aWpBaBJNl4uCUamDU5t51
	LMwneNry+P0hV70+BoXe617id5/9f8UTn8QLyqbV39bcd83Squ1sabBfpHKxeuN/s21e7yJe
	rJKuiRK4dPO6qct8JrmKZudfD42DHwTV+Nd942zyPxD+y5t55Q3Lfh4XTbY36b1zNG6ozVK6
	9sTwBv/dDReS17zxl7SWs8qQ/VYs06jEUpyRaKjFXFScCADklbLZPAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel Lin,

On 05/24/2012 05:56 PM, Axel Lin wrote:

> max77693 driver uses regmap api, thus need to select REGMAP_I2C.
> This fixes below build error when CONFIG_REGMAP=y && CONFIG_REGMAP_I2C=m:
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `max77693_i2c_probe':
> clk-fixed-factor.c:(.text+0x541f8): undefined reference to `devm_regmap_init_i2c'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 4db63b1..e129c82 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -426,6 +426,7 @@ config MFD_MAX77693
>  	bool "Maxim Semiconductor MAX77693 PMIC Support"
>  	depends on I2C=y && GENERIC_HARDIRQS
>  	select MFD_CORE
> +	select REGMAP_I2C
>  	help
>  	  Say yes here to support for Maxim Semiconductor MAX77693.
>  	  This is a companion Power Management IC with Flash, Haptic, Charger,


I sent this patch yesterday due to same issue and it was applied to
mfd-2.6.git
by Samuel Ortiz. You can check it on below URL.
http://www.spinics.net/lists/kernel/msg1346801.html

Thank you,
Chanwoo Choi

