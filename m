Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1E3BYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:24:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60582 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1E3BYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sACzcS203d9DOJwceoI1UuSrTXbgiBOWFSrmN1LTn9MD0YsoK8SaXKa9dvu20WISIX
         huCLc0rvNpjgseuOzq23TkniDni+dlBbwWtKqVASSwnj02ZiK5nvudOMrnvMNhLIigNC
         X1XlAX2dJore/xXJArvdcF990XhFiU2zsrb7Q=
MIME-Version: 1.0
In-Reply-To: <20110529084440.a4803072.rdunlap@xenotime.net>
References: <20110529083032.d3d16059.randy.dunlap@oracle.com>
	<20110529083520.41730250.randy.dunlap@oracle.com>
	<20110529084000.68a6351a.randy.dunlap@oracle.com>
	<20110529084440.a4803072.rdunlap@xenotime.net>
Date: Mon, 30 May 2011 10:24:47 +0900
X-Google-Sender-Auth: 2X2YMTPw7ZrlH0lMg33bciy0mlM
Message-ID: <BANLkTinhXj51dzCnnXhxrCLeW1qQES6CvA@mail.gmail.com>
Subject: Re: gpio: gpio-exynos4 build fails in mainline
From: Kyungmin Park <kmpark@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 12:44 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Sun, 29 May 2011 08:40:00 -0700 Randy Dunlap wrote:
>
>> On Sun, 29 May 2011 08:35:20 -0700 Randy Dunlap wrote:
>>
>> > On Sun, 29 May 2011 08:30:32 -0700 Randy Dunlap wrote:
>> >
>> > > probably should depend on ARM or some ARM sub-arch/mach-type?
>> > >
>> > >
>> > > drivers/gpio/gpio-exynos4.c:18:11: error: unable to open 'mach/map.h'
>> > >
>> > >
>> > > on x86_64
>> > >
>> > > ---
>> >
>> > similarly:
>> >
>> > drivers/gpio/gpio-plat-samsung.c:22:11: error: unable to open 'plat/gpio-core.h'
>>
>>
>> and
>>
>> drivers/gpio/gpio-s5pc100.c:21:11: error: unable to open 'mach/map.h'
>>
>>
>> (this began as x86_64 allmodconfig)
>
> and
>
> drivers/gpio/gpio-s5pv210.c:17:11: error: unable to open 'plat/gpio-core.h'

Hi,

Right, now it's just moved from mach directories to drivers/gpio
So it requires the proper depends on each ARCH_CPU.

Thank you,
Kyungmin Park
---
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 5923976..655babf 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -88,24 +88,28 @@ config GPIO_IT8761E

 config GPIO_EXYNOS4
        bool "Samsung Exynos4 GPIO library support"
+       depends on CPU_EXYNOS4210
        default y if CPU_EXYNOS4210
        help
          Say yes here to support Samsung Exynos4 series SoCs GPIO library

 config GPIO_PLAT_SAMSUNG
        bool "Samsung SoCs GPIO library support"
+       depends on SAMSUNG_GPIOLIB_4BIT
        default y if SAMSUNG_GPIOLIB_4BIT
        help
          Say yes here to support Samsung SoCs GPIO library

 config GPIO_S5PC100
        bool "Samsung S5PC100 GPIO library support"
+       depends on CPU_S5PC100
        default y if CPU_S5PC100
        help
          Say yes here to support Samsung S5PC100 SoCs GPIO library

 config GPIO_S5PV210
        bool "Samsung S5PV210/S5PC110 GPIO library support"
+       depends on CPU_S5PV210
        default y if CPU_S5PV210
        help
          Say yes here to support Samsung S5PV210/S5PC110 SoCs GPIO library

>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
