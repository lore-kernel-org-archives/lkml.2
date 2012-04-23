Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2DWQWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:22:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16875 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2DWQWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:22:10 -0400
Date: Mon, 23 Apr 2012 18:22:25 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 3/3] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
In-reply-to: <20120423100106.GB19192@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, ben-linux@fluff.org,
        thomas.abraham@linaro.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        kyungmin.park@samsung.com, broonie@opensource.wolfsonmicro.com
Message-id: <4F9581C1.8030603@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329
 Icedove/10.0.3
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
 <1332357113-2973-4-git-send-email-k.lewandowsk@samsung.com>
 <20120417174029.GC22406@pengutronix.de>
 <00dd01cd1d5c$57ce7f80$076b7e80$%szyprowski@samsung.com>
 <20120418134644.GB19220@pengutronix.de> <4F8EEC60.2080603@samsung.com>
 <20120423100106.GB19192@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.04.2012 12:01, Wolfram Sang wrote:

> Hi Karol,
>> Tomasz had similar doubts when I've posted patch that checked these
>> quirks only for S3C2440:
>>
>>   http://permalink.gmane.org/gmane.linux.drivers.i2c/10305
>>
>> Thus, I've chosen properties and not separate type.
> 
> I understand this reasoning. I still differ, though. Think about my
> above example about things getting worse. Then, you'd need another
> quirk-property for $FLAW. Later, $FLAW is still there, but the timeout
> issue was fixed. That would mean, the poor device-tree making person has
> to know which quirks to select for this version of the controller. Just
> specifying that it is the HDMI-phy and not a regular I2C controller is
> much more convenient, and the driver will figure the rest.

>

>> It's easy to introduce compat string (see below), but given above
>> I'm afraid that we might end up adding -hdmiphy- variant for every
>> new version of i2c controller.
> 
> I'd be fine with that, given that the upcoming hdmiphy versions will not
> need all the same set of quirk-flags. I think we want that "quirk lookup
> table" fixed in the driver and not encoded in the device tree where
> people could get it wrong. Also, the quirks are nothing a board maker
> can select from; it is implicit as soons as you want the HDMIPHY on that
> SoC, thus the compatible-entry should be enough of a description.


Fair point, from integrator/board maker POV this makes much more sense.

> I am not the ultimate expert about bindings, though, and am open for
> corrections (I feel kinda confident on this issue, though ;))


I'm quite happy with doing it the way you just described.

I'll resend whole patchset in a minute.

Thanks!
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
