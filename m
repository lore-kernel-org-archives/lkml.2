Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2ISJ5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:57:41 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:33973 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916Ab2ISJ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:57:39 -0400
Subject: Re: [PATCH 3/3] i2c: OMAP fix driver initialization message
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <5058CA65.5080408@ti.com>
Date: Wed, 19 Sep 2012 12:57:34 +0300
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Tony Lindgren <tony@atomide.com>
Content-Transfer-Encoding: 7bit
Message-Id: <942374D7-2A8D-4C15-BA6D-3931CE11F8D9@antoniou-consulting.com>
References: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com> <1348070841-23354-4-git-send-email-panto@antoniou-consulting.com> <5058CA65.5080408@ti.com>
To: a0919096 <b-cousson@ti.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Sep 18, 2012, at 10:24 PM, a0919096 wrote:

> Hi Panto,
> 
> That patch is good, but a similar one was already posted by Florian.
> https://patchwork.kernel.org/patch/1392671/
> 
> Checking the email thread it seems that Wolfram	pulled it.
> 
> Regards,
> Benoit
> 

Great. One less thing to look after :)

Regards

-- Pantelis

> On 9/19/2012 11:07 AM, Pantelis Antoniou wrote:
>> The message spit out when the i2c-omap driver load is printing
>> the platform device's id as a bus number. However when booting
>> from OF id is -1, which is not so nice.
>> 
>> Fix it by printing the adapter number.
>> 
>> [    0.210467] omap_i2c 44e0b000.i2c: bus -1 rev2.4.0 at 400 kHz
>> 	vs
>> [    0.210467] omap_i2c 44e0b000.i2c: bus 0 rev2.4.0 at 400 kHz
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>>  drivers/i2c/busses/i2c-omap.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
>> index f722478..87bb705 100644
>> --- a/drivers/i2c/busses/i2c-omap.c
>> +++ b/drivers/i2c/busses/i2c-omap.c
>> @@ -1178,9 +1178,6 @@ omap_i2c_probe(struct platform_device *pdev)
>>  		goto err_unuse_clocks;
>>  	}
>> 
>> -	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", pdev->id,
>> -		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
>> -
>>  	adap = &dev->adapter;
>>  	i2c_set_adapdata(adap, dev);
>>  	adap->owner = THIS_MODULE;
>> @@ -1204,6 +1201,9 @@ omap_i2c_probe(struct platform_device *pdev)
>>  	if (IS_ERR(pinctrl))
>>  		dev_warn(dev->dev, "pins are not configured from the driver\n");
>> 
>> +	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", adap->nr,
>> +		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
>> +
>>  	pm_runtime_mark_last_busy(dev->dev);
>>  	pm_runtime_put_autosuspend(dev->dev);
>> 
>> 
> 

