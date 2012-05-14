Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2ENFE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:04:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41278 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2ENFE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:04:26 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-6d-4fb092595c46
Message-id: <4FB09257.5020907@samsung.com>
Date: Mon, 14 May 2012 14:04:23 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RESEND PATCH v2 1/2] MFD: MAX77693: add MAX77693 MFD driver
References: <4F5EDB01.9070308@samsung.com> <4F67D86E.30509@samsung.com>
 <20120511141508.GQ1214@sortiz-mobl>
In-reply-to: <20120511141508.GQ1214@sortiz-mobl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 05/11/2012 11:15 PM, Samuel Ortiz wrote:

> Hi Choi,
> 
> On Tue, Mar 20, 2012 at 10:07:58AM +0900, Chanwoo Choi wrote:
>> @@ -0,0 +1,224 @@
>> +/*
>> + * max77693.c - mfd core driver for the MAX 77693
>> + *
>> + * Copyright (C) 2011 Samsung Electronics
> 2012 ?

I fix it.

> 
>> +int max77693_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>> +{
>> +	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
>> +	int ret;
>> +
>> +	mutex_lock(&max77693->iolock);
>> +	ret = i2c_smbus_read_byte_data(i2c, reg);
>> +	mutex_unlock(&max77693->iolock);
> You don't need this locking as the i2c layer will do it for you.
> Also, this definitely look like a good candidate for a regmap API conversion,
> I'd appreciate if you could work on that.
> 

OK, I will apply regmap for i2c of MAX77693 and post new patchset.

>> +static struct i2c_driver max77693_i2c_driver = {
>> +	.driver = {
>> +		   .name = "max77693",
>> +		   .owner = THIS_MODULE,
>> +	},
>> +	.probe = max77693_i2c_probe,
>> +	.remove = max77693_i2c_remove,
>> +	.id_table = max77693_i2c_id,
>> +};
>> +
>> +static int __init max77693_i2c_init(void)
>> +{
>> +	return i2c_add_driver(&max77693_i2c_driver);
>> +}
>> +/* init early so consumer devices can complete system boot */
>> +subsys_initcall(max77693_i2c_init);
>> +
>> +static void __exit max77693_i2c_exit(void)
>> +{
>> +	i2c_del_driver(&max77693_i2c_driver);
>> +}
>> +module_exit(max77693_i2c_exit);
> You could use module_i2c_driver() here.


As Mark Brown said, I maintain it.

Thank you,

Best Regards,
Chanwoo Choi


