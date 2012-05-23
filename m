Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439Ab2EWBu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:50:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50040 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab2EWBuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:50:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d000001f49-49-4fbc4256170d
Message-id: <4FBC4255.4040307@samsung.com>
Date: Wed, 23 May 2012 10:50:13 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: yadi.brar01@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH v3 2/2] regulator: Add support for MAX77686.
References: <y@samsung.com> <4fbb2ada.63de440a.589d.78e2@mx.google.com>
In-reply-to: <4fbb2ada.63de440a.589d.78e2@mx.google.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jQd0wpz3+Br1HFS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK2b57LWPCXteL3pfXsDYyPWboYOTkkBEwkPp1qYYKw
	xSQu3FvP1sXIxSEkMJ1R4sKTU6wgCV4BQYkfk+8BNXBwMAvISxy5lA0SZhZQl5g0bxEzRP1b
	RolTy38zQtRrSSz43Qa2gEVAVeL6xYvMIDabgJzE26ZvjCBzRAUiJH71c4CERQQkJWa8vMgC
	ModZ4DWjxI49k8B6hQUcJGavnQ42U0jAXaLxxSswm1PAQuLevAusExgFZiE5bxbCebOQnLeA
	kXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAgPpPewbiqweIQowAHoxIP7wuLPf5CrIll
	xZW5hxglOJiVRHjXT9/tL8SbklhZlVqUH19UmpNafIhRmoNFSZz3yZId/kIC6YklqdmpqQWp
	RTBZJg5OqQZGz7afy/qulF+vjEgNqXMSPeg/f7rwL++Z9/4Ivz2pah2fLptbHVxi0djaGPbR
	/I2uyrLJE33iTX+wWPDpnHhge/zBdLeGup3hJztCTOf8P2nybuYT20uGnnp/Lji8cv3IlGAn
	JTLnxzm/HMFlHBMTuxZK2dieni/suWvWxCX2Hh4lEyt4v0opsRRnJBpqMRcVJwIAwdzPSkAC	AAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, again.
On 2012년 05월 22일 14:57, yadi.brar01@gmail.com wrote:


> +static __devinit int max77686_pmic_probe(struct platform_device *pdev)
> +{

> +
> +	for (i = 0; i < pdata->num_regulators; i++) {
> +		config.dev = max77686->dev;
> +		config.init_data = pdata->regulators[i].init_data;
> +		config.driver_data = max77686;
> +		config.regmap = iodev->regmap;
> +
> +		rdev[i] = regulator_register(&regulators[i], &config);


I'm sorry that i missed one. You have to register all regulators
unconditionally. Mark brown commented about this to my former patch.

'No, you should unconditionally register all regulators the device
physically has.  This is useful for debug and simplifies the code.'
						- from Mark Brown



Thanks.
