Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab2CMSAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:00:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29684 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2CMSAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:00:43 -0400
Date: Tue, 13 Mar 2012 19:00:40 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 3/3] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
In-reply-to: <4F5F838A.6030908@samsung.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F5F8B48.7080803@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
 <1331657679-31302-4-git-send-email-k.lewandowsk@samsung.com>
 <4F5F838A.6030908@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.03.2012 18:27, Tomasz Stanislawski wrote:

> Hi Karol,
> Please refer to comments below,
> 
> Regards,
> Tomasz Stanislawski
> 
> On 03/13/2012 05:54 PM, Karol Lewandowski wrote:
>> This patch adds support for s3c2440 I2C bus controller dedicated HDMIPHY device on
>> Exynos4 platform. Some quirks are introduced due to differences between HDMIPHY
>> and other I2C controllers on Exynos4.  These differences are:
>> - no GPIOs, HDMIPHY is inside the SoC and the controller is connected
>>   internally
>> - due to unknown reason (probably HW bug in HDMIPHY and/or the controller) a
>>   transfer fails to finish. The controller hangs after sending the last byte,
>>   the workaround for this bug is resetting the controller after each transfer
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
>> Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  .../devicetree/bindings/i2c/samsung-i2c.txt        |   10 ++++-
>>  drivers/i2c/busses/i2c-s3c2410.c                   |   36 ++++++++++++++++++++
>>  2 files changed, 44 insertions(+), 2 deletions(-)
>>
> [snip]
>> @@ -871,6 +896,14 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
>>  		return;
>>  
>>  	pdata->bus_num = -1; /* i2c bus number is dynamically assigned */
>> +
>> +	if (s3c24xx_i2c_is_type(i2c, TYPE_S3C2440) &&
> 
> I think that type checking should be removed because hdmiphy quirk is something
> orthogonal to the controller type.


Ok, I'll drop this test and resend patch in a minute.

Thanks!
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
