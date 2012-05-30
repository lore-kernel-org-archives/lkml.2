Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2E3C0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 22:26:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56013 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2E3C0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 22:26:15 -0400
Message-ID: <4FC59171.8040009@gmail.com>
Date: Wed, 30 May 2012 11:18:09 +0800
From: Xiao Jiang <jgq516@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: linux@arm.linux.org.uk, b-cousson@ti.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, rnayak@ti.com, tony@atomide.com,
        wim@iguana.be, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: omap_wdt: add device tree support
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <1337942552-28218-4-git-send-email-jgq516@gmail.com> <4FC51008.1050004@ti.com>
In-Reply-To: <4FC51008.1050004@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Hunter wrote:
> On 05/25/2012 05:42 AM, jgq516@gmail.com wrote:
>   
>> From: Xiao Jiang <jgq516@gmail.com>
>>
>> Add device table for omap_wdt to support dt.
>>
>> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
>> ---
>>  drivers/watchdog/omap_wdt.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
>> index 8285d65..d98c615 100644
>> --- a/drivers/watchdog/omap_wdt.c
>> +++ b/drivers/watchdog/omap_wdt.c
>> @@ -430,6 +430,13 @@ static int omap_wdt_resume(struct platform_device *pdev)
>>  #define	omap_wdt_resume		NULL
>>  #endif
>>  
>> +static const struct of_device_id omap_wdt_of_match[] = {
>> +	{ .compatible = "ti,omap3-wdt", },
>> +	{ .compatible = "ti,omap4-wdt", },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, omap_wdt_of_match);
>> +
>>  static struct platform_driver omap_wdt_driver = {
>>  	.probe		= omap_wdt_probe,
>>  	.remove		= __devexit_p(omap_wdt_remove),
>> @@ -439,6 +446,7 @@ static struct platform_driver omap_wdt_driver = {
>>  	.driver		= {
>>  		.owner	= THIS_MODULE,
>>  		.name	= "omap_wdt",
>> +		.of_match_table = omap_wdt_of_match,
>>  	},
>>  };
>>  
>>     
>
> I think we need to add some code to the probe function that calls
> of_match_device() and ensures we find a match. For example ...
>
> 	if (of_have_populated_dt())
> 		if (!of_match_device(omap_wdt_of_match, &pdev->dev))
> 			return -EINVAL;
>
>   
Will add it in v2, thanks for suggestion.

Regards,
Xiao
> Cheers
> Jon
>   

