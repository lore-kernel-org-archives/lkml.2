Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965422Ab2J3Sad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:30:33 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:48000 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965353Ab2J3Sa2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:30:28 -0400
Subject: Re: [PATCH] ti_tscadc: Match mfd sub devices to regmap interface
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <50901AB1.6040005@metafoo.de>
Date: Tue, 30 Oct 2012 20:30:21 +0200
Cc: Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0E834478-2207-4937-83A7-88B98A76D843@antoniou-consulting.com>
References: <1351698945-3881-1-git-send-email-panto@antoniou-consulting.com> <50901AB1.6040005@metafoo.de>
To: Lars-Peter Clausen <lars@metafoo.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK,

Will rework it, and repost.


On Oct 30, 2012, at 8:21 PM, Lars-Peter Clausen wrote:

> On 10/31/2012 04:55 PM, Pantelis Antoniou wrote:
>> The MFD parent device now uses a regmap, instead of direct
>> memory access. Use the same method in the sub devices to avoid
>> nasty surprises.
>> 
>> Also rework the channel initialization of tiadc a bit.
> 
> Those two bits are not even closely related, they should really go into
> separate patches.
> 
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>> drivers/iio/adc/ti_am335x_adc.c           | 27 +++++++++++++++++++--------
>> drivers/input/touchscreen/ti_am335x_tsc.c | 16 +++++++++++++---
>> drivers/mfd/ti_am335x_tscadc.c            |  7 +++++--
>> 3 files changed, 37 insertions(+), 13 deletions(-)
>> 
> [...]
>> 
>> @@ -213,6 +222,8 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
>> 
>> 	platform_set_drvdata(pdev, indio_dev);
>> 
>> +	dev_info(&pdev->dev, "Initialized\n");
> 
> That's just noise, please don't add it. Imagine every driver did this you'd
> end up with a lot of noise your debug log.
> 
>> +
>> 	return 0;
>> 
>> err_free_channels:
>> diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
>> index 7a26810..d09e1a7 100644
>> --- a/drivers/input/touchscreen/ti_am335x_tsc.c
>> +++ b/drivers/input/touchscreen/ti_am335x_tsc.c
>> @@ -26,6 +26,7 @@
> [...]
>> /*
>> @@ -455,10 +460,15 @@ static int __devinit titsc_probe(struct platform_device *pdev)
>> 
>> 	/* register to the input system */
>> 	err = input_register_device(input_dev);
>> -	if (err)
>> +	if (err) {
>> +		dev_err(&pdev->dev, "Failed to register input device\n");
>> 		goto err_free_irq;
>> +	}
>> 
>> 	platform_set_drvdata(pdev, ts_dev);
>> +
>> +	dev_info(&pdev->dev, "Initialized OK\n");
> 
> Same here
> 
> 

