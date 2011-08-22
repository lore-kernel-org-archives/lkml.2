Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1HVDrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 23:47:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13230 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1HVDrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 23:47:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 21 Aug 2011 20:47:14 -0700
From: Wei Ni <wni@nvidia.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
CC: "mike@compulab.co.il" <mike@compulab.co.il>,
        Nitin Kumbhar <nkumbhar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Aug 2011 11:47:10 +0800
Subject: RE: [PATCH] mfd: tps6586x: add api to power off tps6586x
Thread-Topic: [PATCH] mfd: tps6586x: add api to power off tps6586x
Thread-Index: AcxgVoMXSd938+WyTS+92QB4XrfCLwAH+Htg
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C2CD7600DD@HKMAIL01.nvidia.com>
References: <1311834636-15940-1-git-send-email-wni@nvidia.com>
 <20110821230511.GA4607@sortiz-mobl>
In-Reply-To: <20110821230511.GA4607@sortiz-mobl>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7M3lY9w018741

Hi, Samuel
Thanks for your comments.
Please check the following lines with [Wei Ni]

Thanks
Wei.


>-----Original Message-----
>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>Sent: Monday, August 22, 2011 7:05 AM
>To: Wei Ni
>Cc: mike@compulab.co.il; gking@nvidia.com; Nitin Kumbhar; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] mfd: tps6586x: add api to power off tps6586x
>
>Hi Wei,
>
>On Thu, Jul 28, 2011 at 02:30:36PM +0800, wni@nvidia.com wrote:
>> +static struct i2c_client *tps6586x_i2c_client;
>That's not vey nice. By doing so, you're preventing anyone to have more than
>one of those chips in their boards.
[Wei Ni] oh yes, I didnâ€™t consider this issue. We use i2c_register_board_info()
to register the tps6586x in the board file, but it didn't return the handle.
Do you have any ideas?
>
>
>> +int tps6586x_power_off(void)
>> +{
>> +	struct device *dev = NULL;
>> +	int ret = -EINVAL;
>> +
>> +	if (!tps6586x_i2c_client)
>> +		return ret;
>> +
>> +	dev = &tps6586x_i2c_client->dev;
>> +
>> +	ret = tps6586x_clr_bits(dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = tps6586x_set_bits(dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(tps6586x_power_off);
>Who is going to call this one ?
[Wei Ni] the tegra board will call this function to power off system.
It will put tps6586x in sleep mode by resetting EXITSLREQ and
setting SLEEP_MODE in SUPPLYENE register. It will power off ldos.
>
>Cheers,
>Samuel.
>
>--
>Intel Open Source Technology Centre
>http://oss.intel.com/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
