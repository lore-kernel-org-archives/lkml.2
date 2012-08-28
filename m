Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2H1PRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:17:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19584 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2H1PRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:17:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 28 Aug 2012 08:17:48 -0700
Message-ID: <503CDC26.2030701@nvidia.com>
Date: Tue, 28 Aug 2012 20:26:38 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "swarren@wwwdotorg.com" <swarren@wwwdotorg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps6586x: register regulator even if no init
 data
References: <1346149767-31602-1-git-send-email-ldewangan@nvidia.com> <503CD31E.6050207@wwwdotorg.org>
In-Reply-To: <503CD31E.6050207@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2012 07:48 PM, Stephen Warren wrote:
>
>>
>> -		if ((devs[j].id == TPS6586X_ID_LDO_5) ||
>> -			(devs[j].id == TPS6586X_ID_LDO_RTC))
>> -			reg_idata->supply_regulator = sys_rail_name;
>> +		if (tps6586x_matches[i].init_data) {
> The variable that's being used inside this block is reg_idata.
> Admittedly the value of that variable is tps6586x_matches[i].init_data,
> but I think it'd be much cleaner if the if statement checked reg_idata
> directly; that way, someone reading the code wouldn't have to look above
> to find out that reg_idata and tps6586x_matches[i].init_data are related.
>

OK, will take care in my next patch.


>> +			if (devs[j].id == TPS6586X_ID_SYS)
>> +				sys_rail_name = reg_idata->constraints.name;
> In the MAX8907 patch this attempts to duplicate; if there is no init
> data where the user gives an explicit name, the name from the descriptor
> is used:
>
> if (idata&&  idata->constraints.name)
>      mbatt_rail_name = idata->constraints.name;
> else
>      mbatt_rail_name = pmic->desc[i].name;
>
> Shouldn't that same algorithm be used here?

the desc is not available here in mfd file and so not possible. Each 
regulator register as different platform driver and hence does not have 
the other instance platform data.
However, this will be get fixed once my next patch for moving the dt 
parsing from mfd core to regulator is there. At that time I will take 
care of this.

>>
>> +	if (!pdev->dev.platform_data)
>> +		return 0;
>> +
>>   	return tps6586x_regulator_set_slew_rate(pdev);
>>   }
> Sorry, I don't immediately see why that's related?
The function tps6586x_regulator_set_slew_rate() use the platform data 
which is not available if init_data is not provided by platform.

