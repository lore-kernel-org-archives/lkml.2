Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab2DYMDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:03:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10390 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab2DYMDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:03:46 -0400
Date: Wed, 25 Apr 2012 13:38:55 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 1/2] i2c-s3c2410: Rework device type handling
In-reply-to: <20120424144407.GA9007@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: m.szyprowski@samsung.com, ben-linux@fluff.org, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Message-id: <4F97E24F.5030500@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329
 Icedove/10.0.3
References: <1335198241-19344-1-git-send-email-k.lewandowsk@samsung.com>
 <1335198241-19344-2-git-send-email-k.lewandowsk@samsung.com>
 <20120423182033.GB2767@pengutronix.de> <4F966711.7080608@samsung.com>
 <20120424144407.GA9007@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.04.2012 16:44, Wolfram Sang wrote:

> On Tue, Apr 24, 2012 at 10:40:49AM +0200, Karol Lewandowski wrote:
>> On 23.04.2012 20:20, Wolfram Sang wrote:


>>>> +	if (pdev->dev.of_node) {
>>>> +		const struct of_device_id *match;
>>>> +		match = of_match_node(&s3c24xx_i2c_match, pdev->dev.of_node);
>>>
>>> I'd appreciate a comment explaining why match can't be NULL here (as to
>>> my understanding, it can't). Or just check for it, but this way it looks
>>> a bit fishy and people (hopefully ;)) will ask about it.
>>
>>
>> My understanding is that it can't be null for exactly same reason why
>> platform_get_device_id(pdev) can't be null either (see below).
>>
>> I.e. prerequisite for this code to be run at all (as it's called from
>> driver's .probe()) is to be already matched against very same match
>> table.
> 
> Yes, I agree. Yet, this is not obvious and people might try to fix it
> (especially since programs like smatch report it as potentially
> dangerous). Ah, whatever, I could simply apply the fix then :) OK.


Great! I hope it won't cause any problems. :)

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
