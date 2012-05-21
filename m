Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2EUHdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:33:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54903 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2EUHdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:33:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d000001f49-e3-4fb9efbb2337
Message-id: <4FB9EFBB.20306@samsung.com>
Date: Mon, 21 May 2012 16:33:15 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <trg@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH 2/3] regulator: MAX77686: Add Maxim 77686 regulator driver
References: <1337333539-18371-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337333539-18371-3-git-send-email-jonghwa3.lee@samsung.com>
 <20120520155616.GB9337@opensource.wolfsonmicro.com>
In-reply-to: <20120520155616.GB9337@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd3d73f6G9xeZ2RxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy5h7/y1iwQKji8dL/LA2M6/m6GDk5JARMJPa2n2aCsMUkLtxb
	z9bFyMUhJDCdUaL9yWZmkASvgKDEj8n3WLoYOTiYBeQljlzKBgkzC6hLTJq3iBmivo9JYvOv
	dSwQ9RoSm6fPYAWxWQRUJfZ8OAoWZxOQk3jb9I0RZI6oQITEr34OEFME6Ibf9ytBxjALbGWS
	WHztGzNIXFjAT+LycXeI8XsZJW50trOBxDkFHCTWtzJOYBSYheS4WQjHzUJy3AJG5lWMoqkF
	yQXFSem5RnrFibnFpXnpesn5uZsYwaH3THoH46oGi0OMAhyMSjy8C97s9BdiTSwrrsw9xCjB
	wawkwnv3IVCINyWxsiq1KD++qDQntfgQozQHi5I475MlO/yFBNITS1KzU1MLUotgskwcnFIN
	jJMLvxYqi959lWBt5bA4vHi1yPqjErc23/W4snmh2BnlJ0cOn1+6bk+K18O/Rw5+WeHwce/e
	IsXZ3HNmsatJJExPUDvbU1Eyz6vlC8eiR6cNFzu9uWGnVrXKZMLfyOS/Uq4Tt++N+64RP2Xp
	/yNXlhdZbq8LqzGuzf9eteqwQpHe9SntvgvYeMOVWIozEg21mIuKEwEh0q9+OQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 05월 21일 00:56, Mark Brown wrote:
Hi, Mark.

> On Fri, May 18, 2012 at 06:32:18PM +0900, Jonghwa Lee wrote:
> 
>> Add driver for support max77686 regulator.
>> MAX77686 provides LDOs[1~26] and BUCKs[1~9]. It support to set or get the
>> volatege of regulator on max77686 chip with using regmap.
> 
> Looks mostly good, a few things below but they're all pretty
> minor/straghtforward.
> 
>> +/* LDO3 ~ 5, 9 ~ 14, 16 ~ 26 (uV) */
>> +static const struct voltage_map_desc ldo_voltage_map_desc = {
>> +	.min = 800000,	.max = 3950000,	.step = 50000,	.n_bits = 6,
>> +};
> 
> Should convert all these to use regulator_map_voltage_linear() and
> regulator_{get,set}_voltage_vsel().
> 
>> +	ret = regmap_read(max77686->iodev->regmap, reg, &val);
>> +
>> +	if (ret)
>> +		return ret;
> 
>> +	printk(PMIC_DEBUG "id=%d, ret=%d, val=%x, mask=%x, pattern=%x\n",
>> +		 rdev_get_id(rdev), (val & mask) == pattern,
>> +		 val, mask, pattern);
> 
> dev_dbg() or just remove this (and similarly for the other similar logs).
> 
>> +	{
>> +		.name	= "EN32KHz AP",
>> +		.id	= MAX77686_EN32KHZ_AP,
>> +		.ops	= &max77686_fixedvolt_ops,
>> +		.type	= REGULATOR_VOLTAGE,
>> +		.owner	= THIS_MODULE,
>> +	}, {
>> +		.name	= "EN32KHz CP",
>> +		.id	= MAX77686_EN32KHZ_CP,
>> +		.ops	= &max77686_fixedvolt_ops,
>> +		.type	= REGULATOR_VOLTAGE,
>> +		.owner	= THIS_MODULE,
>> +	}, {
>> +		.name	= "EN32KHz PMIC",
>> +		.id	= MAX77686_P32KH,
>> +		.ops	= &max77686_fixedvolt_ops,
>> +		.type	= REGULATOR_VOLTAGE,
>> +		.owner	= THIS_MODULE,
>> +	},
> 
> These should be managed via the clock API now we have one.

>

I already updated all your comments except only this one. Could you
explain more details?


>> +	if (!pdata)
>> +		dev_err(pdev->dev.parent, "No platform init data supplied.\n");
> 
> Should be able to carry on without this and register the regulators to
> allow for diagnostics and powering off unused regulators when we have
> full constraints.
> 
>> +	size = sizeof(struct regulator_dev *) * MAX77686_REGULATORS;
>> +	max77686->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
>> +	if (!max77686->rdev) {
>> +		devm_kfree(&pdev->dev, max77686);
> 
> Shouldn't need to devm_kfree(), the major point is that this will happen
> automatically.


Thanks.
