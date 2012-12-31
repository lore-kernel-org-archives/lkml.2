Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2LaCMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 21:12:35 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:45627 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2LaCMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 21:12:33 -0500
MIME-Version: 1.0
In-Reply-To: <20121230061542.GA21331@quad.lixom.net>
References: <1355141166-17205-1-git-send-email-a.kesavan@samsung.com>
	<1356686649-15856-1-git-send-email-a.kesavan@samsung.com>
	<20121230061542.GA21331@quad.lixom.net>
Date: Mon, 31 Dec 2012 07:42:32 +0530
Message-ID: <CAM4voakbSS08cJ19Yh1Vgh7E7w0VnPK42A3HzHg90Bm3qTzJ+Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS5: Support Exynos5-bus devfreq driver
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, rjw@sisk.pl, jhbird.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 11:45 AM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
Hi Olof,
>> +# ppmu support
>> +
>> +obj-$(CONFIG_EXYNOS5250_PPMU)                += exynos_ppmu.o exynos5_ppmu.o
>
> Quite obvious that it's ppmu support from the file names. No need for
> a comment.
Will improve the commenting in the file.
Also, will fix the whitespace, empty lines in the file.
>
>> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
>> index 578a610..a285080 100644
>> --- a/arch/arm/mach-exynos/common.c
>> +++ b/arch/arm/mach-exynos/common.c
>> @@ -308,6 +308,31 @@ static struct map_desc exynos5_iodesc[] __initdata = {
>>               .pfn            = __phys_to_pfn(EXYNOS5_PA_UART),
>>               .length         = SZ_512K,
>>               .type           = MT_DEVICE,
>> +     }, {
>> +             .virtual        = (unsigned long)S5P_VA_PPMU_CPU,
>> +             .pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_CPU),
>> +             .length         = SZ_8K,
>> +             .type           = MT_DEVICE,
>> +     }, {
>> +             .virtual        = (unsigned long)S5P_VA_PPMU_DDR_C,
>> +             .pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_C),
>> +             .length         = SZ_8K,
>> +             .type           = MT_DEVICE,
>> +     }, {
>> +             .virtual        = (unsigned long)S5P_VA_PPMU_DDR_R1,
>> +             .pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_R1),
>> +             .length         = SZ_8K,
>> +             .type           = MT_DEVICE,
>> +     }, {
>> +             .virtual        = (unsigned long)S5P_VA_PPMU_DDR_L,
>> +             .pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_L),
>> +             .length         = SZ_8K,
>> +             .type           = MT_DEVICE,
>> +     }, {
>> +             .virtual        = (unsigned long)S5P_VA_PPMU_RIGHT,
>> +             .pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_RIGHT),
>> +             .length         = SZ_8K,
>> +             .type           = MT_DEVICE,
>>       },
>
> You should add the ppmu device to the device tree, and get the addresses from
> there instead (via ioremap).
>
> That way you can make this driver probe using regular methods too.
Will re-work to remove these static mappings.
>
>> +
>> +#include <mach/exynos_ppmu.h>
>> +#include <mach/exynos5_ppmu.h>
>
> Can you avoid adding new mach includes for this, perhaps? We're working hard on
> removing them for all platforms, even though exynos is lagging behind on it.
> Local defines that are used in just one C file can either go in that file, or
> in a header file that sits next to it instead of in the shared directory. For
> the devfreq driver, include/linux/* is a better location.
Will do.
>
>> +#define FIXED_POINT_OFFSET 8
>> +#define FIXED_POINT_MASK ((1 << FIXED_POINT_OFFSET) - 1)
>
> 0xff. Easier to read for a single entry like this.
OK

Thanks,
Abhilash
