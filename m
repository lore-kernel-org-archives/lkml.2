Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab2CWL2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 07:28:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10065 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2CWL2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 07:28:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Date: Fri, 23 Mar 2012 12:28:52 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 2/2] s5p-tv: Add initial DT-support for HDMIPHY
In-reply-to: <20120318182458.9CCC43E07BF@localhost>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: t.stanislaws@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com
Message-id: <4F6C5E74.60104@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1331912532-7798-1-git-send-email-k.lewandowsk@samsung.com>
 <1331912532-7798-3-git-send-email-k.lewandowsk@samsung.com>
 <20120318182458.9CCC43E07BF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2012 19:24, Grant Likely wrote:

> On Fri, 16 Mar 2012 16:42:12 +0100, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
>> Make it possible to instantiate driver from device tree description.
>>
>> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
>>  drivers/media/video/s5p-tv/hdmiphy_drv.c |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
>> index 6693f4a..ddf3008 100644
>> --- a/drivers/media/video/s5p-tv/hdmiphy_drv.c
>> +++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/irq.h>
>>  #include <linux/err.h>
>> +#include <linux/of.h>
>>  
>>  #include <media/v4l2-subdev.h>
>>  
>> @@ -165,10 +166,19 @@ static const struct i2c_device_id hdmiphy_id[] = {
>>  };
>>  MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
>>  
>> +#ifdef CONFIG_OF
>> +static struct of_device_id hdmiphy_dt_match[] = {
>> +	{ .compatible = "samsung,s5pv210-hdmiphy" },
> 
> Ditto here; needs to be listed in documentation.


As these drivers require only irq and io address may add these to
something like [bindings/arm/samsung/]trivial-devices.txt (like it's
done for i2c)?

Thanks for review!
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
