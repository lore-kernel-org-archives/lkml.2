Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1ATKEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:04:43 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:60198 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317Ab1ATKEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:04:41 -0500
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Jan 2011 11:03:29 +0100
Subject: RE: [PATCH 1/2] leds: add driver for LM3530 ALS
Thread-Topic: [PATCH 1/2] leds: add driver for LM3530 ALS
Thread-Index: Acu34qXTczXLMvB2R6iGUOawY7B1fwAph31Q
Message-ID: <2E48302EED53D048A7BA72B0A307FB51172F55C632@EXDCVYMBSTM005.EQ1STM.local>
References: <1295420175-22332-1-git-send-email-shreshthakumar.sahu@stericsson.com>
 <1295446213.14388.21898.camel@rex>
In-Reply-To: <1295446213.14388.21898.camel@rex>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0KA4qZW004421



[...]
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_GEN_CONFIG, gen_config);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_CONFIG, als_config);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_BRT_RAMP_RATE, brt_ramp);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_IMP_SELECT, als_imp_sel);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_BRT_CTRL_REG, brightness);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_ZB0_REG, LM3530_DEF_ZB_0);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_ZB1_REG, LM3530_DEF_ZB_1);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_ZB2_REG, LM3530_DEF_ZB_2);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_ZB3_REG, LM3530_DEF_ZB_3);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z0T_REG, LM3530_DEF_ZT_0);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z1T_REG, LM3530_DEF_ZT_1);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z2T_REG, LM3530_DEF_ZT_2);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z3T_REG, LM3530_DEF_ZT_3);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z4T_REG, LM3530_DEF_ZT_4);
> +	if (ret)
> +		return ret;
> +
> +	return ret;

I can't help wonder if a table of values iterated over would look a
little neater here. The last if is harmless but pointless too.

[Shreshtha Kumar SAHU] done

> +static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
> +				   *attr, const char *buf, size_t size)
> +{
> +	int err;
> +	struct i2c_client *client = container_of(
> +					dev->parent, struct i2c_client, dev);
> +	struct lm3530_data *drvdata = i2c_get_clientdata(client);
> +	unsigned long mode;
> +
> +	err = strict_strtoul(buf, 10, &mode);
> +	if (err < 0)
> +		return -EINVAL;
> +
> +	if (mode == LM3530_BL_MODE_MANUAL)
> +		drvdata->mode = LM3530_BL_MODE_MANUAL;
> +	else if (mode == LM3530_BL_MODE_ALS)
> +		drvdata->mode = LM3530_BL_MODE_ALS;
> +	else if (mode == LM3530_BL_MODE_PWM) {
> +		dev_err(dev, "PWM mode not supported\n");
> +		return -EINVAL;
> +	}
> +
> +	err = lm3530_init_registers(drvdata);
> +	if (err) {
> +		dev_err(dev, "Setting %s Mode failed :%d\n", buf, err);
> +		return err;
> +	}
> +
> +	return sizeof(drvdata->mode);
> +}
> +
> +static DEVICE_ATTR(mode, 0644, NULL, lm3530_mode_set);

So you poke random values of 0, 1, 2 into sysfs? I suspect that breaks
sysfs guidelines and these should be meaningful values like "pwm", "als"
and "led". The enum is ok within the kernel but not for exposure outside
of it. 

[Shreshtha Kumar SAHU] done

Also, calling out PWM specifically as not supported seems like the wrong
approach 
[Shreshtha Kumar SAHU] I will add support for PWM soon.

and I'm curious what happens if I poke 4 in there.
[Shreshtha Kumar SAHU] rectified with implementation of meaningful input
values


The rest looked ok at a quick glance.

Cheers,

Richard

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
