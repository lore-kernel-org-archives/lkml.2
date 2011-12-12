Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1LLJCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:02:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49614 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLJCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:02:48 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-10-4ee5c3368d0f
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <4EE5C330.8060902@samsung.com>
Date: Mon, 12 Dec 2011 18:02:40 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419
 Thunderbird/3.1.9
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
References: <1323422140-31332-1-git-send-email-dg77.kim@samsung.com>
 <1323422140-31332-2-git-send-email-dg77.kim@samsung.com>
 <20111209095855.GA1876@sirena.org.uk>
In-reply-to: <20111209095855.GA1876@sirena.org.uk>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011년 12월 09일 18:58, Mark Brown wrote:
> On Fri, Dec 09, 2011 at 06:15:39PM +0900, Donggeun Kim wrote:
> 
> Overall this looks good - a few small nits below.
> 
>> +int max77693_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>> +{
>> +	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
>> +	int ret;
>> +
>> +	mutex_lock(&max77693->iolock);
>> +	ret = i2c_smbus_read_byte_data(i2c, reg);
>> +	mutex_unlock(&max77693->iolock);
>> +	if (ret < 0)
>> +		return ret;
> 
> Might be worth considering regmap - should be a bit less code and the
> register cache is likely to make performance a bit better.
I'm not familiar with regmap. If I understand it fully, I will decide to
use it or not. Until then, I'd like to maintain this.
> 
>> +	if (max77693_read_reg(i2c, MAX77693_PMIC_REG_PMIC_ID2, &reg_data) < 0) {
>> +		dev_err(max77693->dev,
>> +			"device not found on this channel\n");
>> +		ret = -ENODEV;
>> +		goto err;
>> +	}
> 
> I'd suggest also verifying that the ID register has the expected value.
> If there's a chip reision register logging it can be helpful.
> 
The all expected values for the register are not specified at datasheet.
The perpose of the read function is simply checking the existence of the
device so that the following operations are stopped for error case.
>> +	max77693->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
>> +	i2c_set_clientdata(max77693->muic, max77693);
>> +
>> +	max77693->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
>> +	i2c_set_clientdata(max77693->haptic, max77693);
> 
>> +	pm_runtime_set_active(max77693->dev);
> 
> 
>> +	kfree(max77693);
> 
> devm_kzalloc().
> 
Okay, it will be used in the next version of patch.

Thanks.
-Donggeun
