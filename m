Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2AYMs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:48:26 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4138 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2AYMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:48:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 25 Jan 2012 04:48:21 -0800
Message-ID: <4F1FF9EF.9000004@nvidia.com>
Date: Wed, 25 Jan 2012 18:17:43 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] regulator: tps65910: Sleep control through external
 inputs
References: <1327489068-9460-1-git-send-email-ldewangan@nvidia.com> <20120125124250.GH3687@opensource.wolfsonmicro.com>
In-Reply-To: <20120125124250.GH3687@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 January 2012 06:12 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Jan 25, 2012 at 04:27:48PM +0530, Laxman Dewangan wrote:
>
>> @@ -450,6 +489,29 @@ static int tps65910_set_mode(struct regulator_dev *dev, unsigned int mode)
>>   	struct tps65910 *mfd = pmic->mfd;
>>   	int reg, value, id = rdev_get_id(dev);
>>
>> +	/*
>> +	 * If regulator is controlled through external control then
>> +	 * mode can be identified by the input level of EN1/EN2/EN3.
>> +	 * If it is HIGH then regulators is on, full power.
>> +	 * If it is LOW then:
>> +	 *       - the regulator is set off if its corresponding Control
>> +	 *         bit = 0 in SLEEP_KEEP_XXX_ON.
>> +	 *       - the regulator is set in low-power mode if its corresponding
>> +	 *         control bit = 1 in SLEEP_KEEP_XXX_ON register.
>> +	 */
> This really isn't what the set_mode() API is for - especially the fact
> that it supports turning the regulator off which really isn't what
> set_mode() is supposed to do.  A generic driver using this API isn't
> going to play too well.
Then what should be the method? Is it through the macro similar to patch 
V1 where LOW_POWER mode option come from platform data? The idea  is to 
set the regulator in OFF or low power mode based on external control.

>> +	if (pmic->board_ext_control[id]) {
>> +		u8 regoffs = (pmic->ext_sleep_control[id]>>  8)&  0xFF;
>> +		u8 bit_pos = (1<<  pmic->ext_sleep_control[id]&  0xFF);
>> +		int ret = 0;
>> +		if ((mode == REGULATOR_MODE_IDLE) ||
>> +			(mode == REGULATOR_MODE_STANDBY))
>> +			ret = tps65910_set_bits(mfd,
>> +				TPS65910_SLEEP_KEEP_LDO_ON + regoffs, bit_pos);
> As a coding style thing this should be a switch statement.
I will take care in next patch once above question is clear.

> * Unknown Key
> * 0x6E30FDDD

