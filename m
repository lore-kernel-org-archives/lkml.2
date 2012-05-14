Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2ENKIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:08:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43313 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab2ENKIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:08:07 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-15-4fb0d9865cb5
Message-id: <4FB0D983.4050404@samsung.com>
Date: Mon, 14 May 2012 19:08:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] MFD: MAX77693: add MAX77693 MFD driver
References: <1336972830-15169-1-git-send-email-cw00.choi@samsung.com>
 <20120514091917.GJ31985@opensource.wolfsonmicro.com>
In-reply-to: <20120514091917.GJ31985@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 05/14/2012 06:19 PM, Mark Brown wrote:

> On Mon, May 14, 2012 at 02:20:30PM +0900, Chanwoo Choi wrote:
> 
>> Signef-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> Typo :)
> 
>> +int max77693_read_reg(struct regmap *map, u8 reg, u8 *dest)
>> +{
>> +	unsigned int val;
>> +	int ret;
>> +
>> +	ret = regmap_read(map, reg, &val);
>> +	val &= 0xff;
>> +	*dest = val;
> 
> Should be no need for the val &= 0xff - if there is there's a bug we
> ought to fix in regmap.
> 
>> +int max77693_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
>> +{
>> +	unsigned int old_val, new_val;
>> +	int ret;
>> +
>> +	ret = regmap_read(map, reg, &old_val);
>> +	old_val &= 0xff;
>> +	new_val = (val & mask) | (old_val & (~mask));
>> +	ret = regmap_write(map, reg, new_val);
> 
> This should be using regmap_update_bits(), the current code is buggy as
> it does not lock which means that multiple simultaneous updaters could
> conflict with each other.
> 
>> +static struct regmap_config max77693_regmap_config = {
>> +	.reg_bits = 8,
>> +	.val_bits = 8,
> 
> Defining max_register would let you see the register map in debugfs but
> this is optional.
> 
>> +	max77693->regmap = regmap_init_i2c(i2c, &max77693_regmap_config);
>> +	if (IS_ERR(max77693->regmap)) {
> 
> devm_regmap_init_i2c().


I modify all of it according of your comment.

Thank you for your comment.

Best Regards,
Chanwoo Choi
