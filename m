Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2BSHgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 02:36:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4192 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2BSHge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 02:36:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 18 Feb 2012 23:36:29 -0800
Message-ID: <4F40A5EF.4080909@nvidia.com>
Date: Sun, 19 Feb 2012 13:04:07 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH V1] mfd: tps65910: Initialize irq platform data properly
References: <1326898156-11293-1-git-send-email-ldewangan@nvidia.com> <4F2A95F2.9000006@nvidia.com>
In-Reply-To: <4F2A95F2.9000006@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,
Can you please review this patch? Without this change, the device is 
corrupting other irq registration because it tries to register  wrong irqs.

Thanks,
Laxman

On Thursday 02 February 2012 07:26 PM, Laxman Dewangan wrote:
> On Wednesday 18 January 2012 08:19 PM, Laxman Dewangan wrote:
>> irq_base of the tps65910 irq platform data should be
>> initialized with the board provided irq_base data.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> ---
>>    drivers/mfd/tps65910.c |    2 +-
>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
>> index c1da84b..8517481 100644
>> --- a/drivers/mfd/tps65910.c
>> +++ b/drivers/mfd/tps65910.c
>> @@ -168,7 +168,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>>    		goto err;
>>
>>    	init_data->irq = pmic_plat_data->irq;
>> -	init_data->irq_base = pmic_plat_data->irq;
>> +	init_data->irq_base = pmic_plat_data->irq_base;
>>
>>    	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
>>
> Hi Samuel,
> Any feedback on this patch?
>
> Thanks,
> Laxman
>
>

