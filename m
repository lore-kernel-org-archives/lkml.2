Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2DXIkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:40:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64885 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab2DXIkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:40:31 -0400
Date: Tue, 24 Apr 2012 10:40:49 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 1/2] i2c-s3c2410: Rework device type handling
In-reply-to: <20120423182033.GB2767@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: m.szyprowski@samsung.com, ben-linux@fluff.org, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Message-id: <4F966711.7080608@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329
 Icedove/10.0.3
References: <1335198241-19344-1-git-send-email-k.lewandowsk@samsung.com>
 <1335198241-19344-2-git-send-email-k.lewandowsk@samsung.com>
 <20120423182033.GB2767@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.04.2012 20:20, Wolfram Sang wrote:

Hi!

>> -static inline int s3c24xx_i2c_is2440(struct s3c24xx_i2c *i2c)
>> +static inline unsigned int s3c24xx_get_device_quirks(struct platform_device *pdev)
>>  {
>> -	struct platform_device *pdev = to_platform_device(i2c->dev);
>> -	enum s3c24xx_i2c_type type;
>> -
>> -#ifdef CONFIG_OF
>> -	if (i2c->dev->of_node)
>> -		return of_device_is_compatible(i2c->dev->of_node,
>> -				"samsung,s3c2440-i2c");
>> -#endif
>> +	if (pdev->dev.of_node) {
>> +		const struct of_device_id *match;
>> +		match = of_match_node(&s3c24xx_i2c_match, pdev->dev.of_node);
> 
> I'd appreciate a comment explaining why match can't be NULL here (as to
> my understanding, it can't). Or just check for it, but this way it looks
> a bit fishy and people (hopefully ;)) will ask about it.


My understanding is that it can't be null for exactly same reason why
platform_get_device_id(pdev) can't be null either (see below).

I.e. prerequisite for this code to be run at all (as it's called from
driver's .probe()) is to be already matched against very same match
table.

As far I can see the only possibility for it to fail is to have
dev.of_node pointing to device tree node and NOT being instantiated
from DT description...

>> +		return (unsigned int)match->data;
>> +	}
>>  
>> -	type = platform_get_device_id(pdev)->driver_data;
>> -	return type == TYPE_S3C2440;
>> +	return platform_get_device_id(pdev)->driver_data;
>>  }


Regards,

-- 

Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
