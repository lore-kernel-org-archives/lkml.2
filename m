Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab1FVDXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:23:08 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64851 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab1FVDXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:23:07 -0400
Message-ID: <4E016012.8090406@linaro.org>
Date: Wed, 22 Jun 2011 08:52:58 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: myungjoo.ham@samsung.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>, "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] regulator: MAX8997: Fix for divide by zero error
References: <29765534.104601308710936223.JavaMail.weblogic@epml07>
In-Reply-To: <29765534.104601308710936223.JavaMail.weblogic@epml07>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 08:18 AM, 함명주 wrote:
> Sender : Tushar Behera<tushar.behera@linaro.org>
> Date : 2011-06-21 12:38 (GMT+09:00)
>> Currently, ramp_delay variable is used uninitialized in
>> max8997_set_voltage_ldobuck which gets called through
>> regulator_register calls.
>>
>> To fix the problem, in max8997_pmic_probe, ramp_delay initialization
>> code is moved before calls to regulator_register.
>>
>> Cc: Liam Girdwood
>> Cc: Mark Brown
>> Cc: MyungJoo Ham
>> Cc: Kyungmin Park
>> Cc: Samuel Ortiz
>> Signed-off-by: Tushar Behera
> 
> Although I've never been reported such an issue, but I'm sure this will cause one any time. Thanks!
One scenario:
Division by zero in kernel.
[<c00399c4>] (unwind_backtrace+0x0/0xe0) from [<c0162ed4>] (Ldiv0+0x8/0x10)
[<c0162ed4>] (Ldiv0+0x8/0x10) from [<c018a1bc>]
(max8997_set_voltage_ldobuck+0x198/0x1bc)
[<c018a1bc>] (max8997_set_voltage_ldobuck+0x198/0x1bc) from [<c0187ae8>]
(_regulator_do_set_voltage+0x2c/0x1c4)
[<c0187ae8>] (_regulator_do_set_voltage+0x2c/0x1c4) from [<c0187eec>]
(regulator_register+0x25c/0xe2c)
[<c0187eec>] (regulator_register+0x25c/0xe2c) from [<c02b9124>]
(max8997_pmic_probe+0x5b8/0x69c)
> 
> Acked-by: MyungJoo Ham<myungjoo.ham@samsung.com>
Thanks.
> 
<snipped>

>> ---
>> drivers/regulator/max8997.c |    8 ++++----
>> 1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
>> index 10d5a1d..0fc7b8c 100644
>> --- a/drivers/regulator/max8997.c
>> +++ b/drivers/regulator/max8997.c
>> @@ -1124,6 +1124,10 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
>> 0x3f);
>> }
>>
>> + /* Misc Settings */
>> + max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
>> + max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf<<  4) | 0x9);
>> +
>> for (i = 0; i<  pdata->num_regulators; i++) {
>> const struct voltage_map_desc *desc;
>> int id = pdata->regulators[i].id;
>> @@ -1148,10 +1152,6 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
>> }
>> }
>>
>> - /* Misc Settings */
>> - max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
>> - max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf<<  4) | 0x9);
>> -
>> return 0;
>> err:
>> for (i = 0; i<  max8997->num_regulators; i++)
>> -- 
>> 1.7.4.1
>>
>>
> 
> 
> 
>   MyungJoo Ham (함명주)
> Mobile Software Platform Lab,
> Digital Media and Communications (DMC) Business
> Samsung Electronics
> cell: +82-10-6714-2858 / office: +82-31-279-8033


-- 
Tushar Behera
