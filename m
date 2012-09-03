Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2ICIyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:54:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17873 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2ICIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:54:10 -0400
Message-id: <5044702E.3070209@samsung.com>
Date: Mon, 03 Sep 2012 10:54:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
To: Taehun Kim <kth3321@gmail.com>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: S3C24XX: Add WIZnet W5300E01-ARM board support
References: <1346653236-19728-1-git-send-email-kth3321@gmail.com>
 <CA+E=qVfGN9_Lj5GWqERfZGQsTtnnK_fARgXuCujdVeZ0PBoJEQ@mail.gmail.com>
In-reply-to: <CA+E=qVfGN9_Lj5GWqERfZGQsTtnnK_fARgXuCujdVeZ0PBoJEQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/03/2012 09:56 AM, Vasily Khoruzhick wrote:
>> +static void __init w5300e01_init(void)
>> +{
>> +       s3c_nand_set_platdata(&w5300e01_nand_info);
>> +       platform_add_devices(w5300e01_devices, ARRAY_SIZE(w5300e01_devices));
>> +
>> +       /* W5300 interrupt pin. */
>> +       s3c2410_gpio_cfgpin(S3C2410_GPF(0), S3C2410_GPIO_IRQ);
>> +
>> +       s3c2410_gpio_cfgpin(S3C2410_GPF(4), S3C2410_GPIO_OUTPUT);
>> +       s3c2410_gpio_cfgpin(S3C2410_GPF(5), S3C2410_GPIO_OUTPUT);
>> +       s3c2410_gpio_cfgpin(S3C2410_GPF(6), S3C2410_GPIO_OUTPUT);
>> +       s3c2410_gpio_cfgpin(S3C2410_GPF(7), S3C2410_GPIO_OUTPUT);
>> +
>> +       s3c2410_gpio_setpin(S3C2410_GPF(0), 1);
>> +       s3c2410_gpio_setpin(S3C2410_GPF(4), 1);
>> +       s3c2410_gpio_setpin(S3C2410_GPF(5), 1);
>> +       s3c2410_gpio_setpin(S3C2410_GPF(6), 1);
>> +       s3c2410_gpio_setpin(S3C2410_GPF(7), 1);
>> +
> 
> Please use gpiolib API, legacy s3c2410_gpio_* API will be removed soon.

Right, you'll find some information about this in
Documentation/arm/Samsung-S3C24XX/GPIO.txt.

These links may be useful as well:
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg11985.html
http://www.spinics.net/lists/arm-kernel/msg192119.html

--

Regards,
Sylwester
