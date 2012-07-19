Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2GSFhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 01:37:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61360 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2GSFhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 01:37:36 -0400
MIME-Version: 1.0
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDB1D6B26@BGMAIL02.nvidia.com>
References: <CAPLVkLshQjOne9BtZYkth0uZ6ABjYHZ85M2ETKd-D0TRkt+QQw@mail.gmail.com>
	<D958900912E20642BCBC71664EFECE3E6DDB1D6B26@BGMAIL02.nvidia.com>
Date: Thu, 19 Jul 2012 14:37:35 +0900
Message-ID: <CAPLVkLuL9u5NbNrhxNag+D6dLBK3pbpPe4jkg6OETCLm2wt4Kg@mail.gmail.com>
Subject: Re: Question about tps65090 mfd driver
From: Joonyoung Shim <dofmind@gmail.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Venu.

2012/7/18 Venu Byravarasu <vbyravarasu@nvidia.com>:
> Yes, you are right.
> it was a mistake.
> Will send a patch soon.

I saw your patch about this from https://lkml.org/lkml/2012/7/18/232
because i doesn't subcribe linux-kernel ML yet.

The tps65090 mfd driver has two mfd_cells for "tps65090-pmic" and
"tps65090-regulator". I can find tps65090-regulator driver but cannot find
tps65090-pmic driver.

Is there any reason to exist two mfd_cells?

And one more question.

struct tps65090_platform_data {
        int irq_base;
        int num_subdevs;
        struct tps65090_subdev_info *subdevs;
}

This is  platform data struct for tps65090 mfd driver, but num_subdevs
and subdevs are not used in the mfd driver. How do you handle platform
data of tps65090 mfd driver and regulator driver?

Thanks.

>
> Thanks,
> Venu
>
>
>> -----Original Message-----
>> From: Joonyoung Shim [mailto:dofmind@gmail.com]
>> Sent: Wednesday, July 18, 2012 6:14 PM
>> To: Venu Byravarasu
>> Cc: sameo@linux.intel.com; linux-kernel@vger.kernel.org
>> Subject: Question about tps65090 mfd driver
>>
>> Hi,
>>
>> I have one question about tps65090 mfd driver.
>> There are following codes in the drivers/mfd/tps65090.c
>>
>> ...
>> static struct mfd_cell tps65090s[] = {
>>       {
>>               .name = "tps65910-pmic",
>>       },
>>       {
>>               .name = "tps65910-regulator",
>>       },
>> };
>> ...
>>
>> I know tps65090 and tps65910 have each different regulator driver.
>>
>> drivers/regulator/tps65090-regulator.c
>> drivers/regulator/tps65910-regulator.c
>>
>> So, i wonder whether it is right that tps65090 mfd driver has tps65910-xxx.
>>
>> Thanks.
>>
>> --
>> - Joonyoung Shim



-- 
- Joonyoung Shim
