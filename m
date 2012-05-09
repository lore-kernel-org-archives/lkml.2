Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263Ab2EIXmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:42:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13141 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071Ab2EIXmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:42:02 -0400
X-AuditID: cbfee61a-b7b97ae000004342-13-4fab00c86fb7
Message-id: <4FAB00C8.8000308@samsung.com>
Date: Thu, 10 May 2012 08:42:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [PATCH 1/2] mfd: Add support for MAX77686.
References: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
 <1336580695-1184-2-git-send-email-yadi.brar@samsung.com>
 <20120509182757.GB32037@sirena.org.uk>
In-reply-to: <20120509182757.GB32037@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

We have posted following patch on the last week and received
your comment. So, We are implementing that use regmap API for I2C
and modify MFD driver of MAX77686 according to your comment.

[PATCH] MFD : add MAX77686 mfd driver
- https://lkml.org/lkml/2012/4/30/96

Additionally, We are intergrating support irq_domain for MAX77686 irq.

We will post new patch to support MFD driver of MAX77686 including
modification by your comment within this week.

Best Regards,
Chanwoo Choi

On 05/10/2012 03:27 AM, Mark Brown wrote:

> On Wed, May 09, 2012 at 09:54:54PM +0530, Yadwinder Singh wrote:
> 
>> +int max77686_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>> +{
>> +	int ret;
>> +
>> +	ret = i2c_smbus_read_byte_data(i2c, reg);
>> +	if (ret < 0)
> 
> It would really be better if this used the regmap API - the regulator
> API is starting to build out functionality on top of regmap which this
> won't be able to take advantage of if it doesn't use regmap.
> 
>> +	if (of_get_property(dev->of_node, "max77686,wakeup", NULL))
>> +		pd->wakeup = true;
> 
> You haven't included any binding documentatiojn for the device tree
> bindings - you should do this.
> 
>> +	max77686 = kzalloc(sizeof(struct max77686_dev), GFP_KERNEL);
>> +	if (max77686 == NULL) {
>> +		dev_err(max77686->dev, "could not allocate memory\n");
>> +		return -ENOMEM;
>> +	}
> 
> devm_kzalloc().
> 
>> +	device_init_wakeup(max77686->dev, max77686->wakeup);
> 
> Why is this not just done unconditionally?  There's sysfs files to allow
> userspace control.
> 
>> +	if (max77686_read_reg(i2c, MAX77686_REG_DEVICE_ID, &data) < 0) {
>> +		ret = -EIO;
>> +		dbg_info("%s : device not found on this channel\n", __func__);
>> +		goto err_mfd;
>> +	} else
>> +		dev_info(max77686->dev, "device found\n");
> 
> You should verify that the device ID you read back is the expected one.
> 
>> +	dev_err(max77686->dev, "device probe failed : %d\n", ret);
> 
> Driver core should do this for you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


