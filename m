Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2EKO2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:28:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39560 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2EKO2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:28:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2WJ+Xb9GOHuZ2hLiQ_=Rgs_fqqm0AUDB4Y61HoYqf+zBQ@mail.gmail.com>
References: <4F5EDB01.9070308@samsung.com>
	<4F67D86E.30509@samsung.com>
	<20120511141508.GQ1214@sortiz-mobl>
	<CAH9JG2WJ+Xb9GOHuZ2hLiQ_=Rgs_fqqm0AUDB4Y61HoYqf+zBQ@mail.gmail.com>
Date: Fri, 11 May 2012 23:28:41 +0900
X-Google-Sender-Auth: jflDYK-YI4DGOztPnAlTC5Nqmd8
Message-ID: <CAH9JG2Wr25BVNudAQaQ8GaN9mMV90iVcioAaomdBtORD_d3w+g@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 1/2] MFD: MAX77693: add MAX77693 MFD driver
From: Kyungmin Park <kmpark@infradead.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:25 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> Hi Samuel,
>
> On Fri, May 11, 2012 at 11:15 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>> Hi Choi,
>>
>> On Tue, Mar 20, 2012 at 10:07:58AM +0900, Chanwoo Choi wrote:
>>> @@ -0,0 +1,224 @@
>>> +/*
>>> + * max77693.c - mfd core driver for the MAX 77693
>>> + *
>>> + * Copyright (C) 2011 Samsung Electronics
>> 2012 ?
>>
>>> +int max77693_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>>> +{
>>> +     struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
>>> +     int ret;
>>> +
>>> +     mutex_lock(&max77693->iolock);
>>> +     ret = i2c_smbus_read_byte_data(i2c, reg);
>>> +     mutex_unlock(&max77693->iolock);
>> You don't need this locking as the i2c layer will do it for you.
>> Also, this definitely look like a good candidate for a regmap API conversion,
>> I'd appreciate if you could work on that.
>
> Right, it's already done. you can find the updated patches in your mail box.
>
> [PATCH v2 0/3] mfd: MAX77686: Add initial support for MAXIM 77686 mfd chip
>
> This patchset adds suppport for MAX77686 which is a multifunction
> device including
> regulator and rtc. It also contains drivers supporting rtc and regulator.
> All drivers ard based on MAX8997 dirvers and use regmap to access to
> the inner registers.
> To manage IRQs occuered by max77686, it supports IRQ domain.
>
Sorry, I'm confused. it's another PMIC IC. I'll check the max77693 also. :);
> Thank you,
> Kyungmin Park
>>
>>> +static struct i2c_driver max77693_i2c_driver = {
>>> +     .driver = {
>>> +                .name = "max77693",
>>> +                .owner = THIS_MODULE,
>>> +     },
>>> +     .probe = max77693_i2c_probe,
>>> +     .remove = max77693_i2c_remove,
>>> +     .id_table = max77693_i2c_id,
>>> +};
>>> +
>>> +static int __init max77693_i2c_init(void)
>>> +{
>>> +     return i2c_add_driver(&max77693_i2c_driver);
>>> +}
>>> +/* init early so consumer devices can complete system boot */
>>> +subsys_initcall(max77693_i2c_init);
>>> +
>>> +static void __exit max77693_i2c_exit(void)
>>> +{
>>> +     i2c_del_driver(&max77693_i2c_driver);
>>> +}
>>> +module_exit(max77693_i2c_exit);
>> You could use module_i2c_driver() here.
>>
>> Cheers,
>> Samuel.
>>
>> --
>> Intel Open Source Technology Centre
>> http://oss.intel.com/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
