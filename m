Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2E3JWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:22:22 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51108 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2E3JWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:22:20 -0400
Message-ID: <4FC5F2FA.4050606@gmail.com>
Date: Wed, 30 May 2012 18:14:18 +0800
From: Xiao Jiang <jgq516@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Jon Hunter <jon-hunter@ti.com>, linux@arm.linux.org.uk,
        rob.herring@calxeda.com, grant.likely@secretlab.ca, rnayak@ti.com,
        tony@atomide.com, wim@iguana.be, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: omap_wdt: add device tree support
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <1337942552-28218-4-git-send-email-jgq516@gmail.com> <4FC51008.1050004@ti.com> <4FC59171.8040009@gmail.com> <4FC5D21F.2030702@ti.com>
In-Reply-To: <4FC5D21F.2030702@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cousson, Benoit wrote:
> On 5/30/2012 5:18 AM, Xiao Jiang wrote:
>> Jon Hunter wrote:
>>> On 05/25/2012 05:42 AM, jgq516@gmail.com wrote:
>>>> From: Xiao Jiang <jgq516@gmail.com>
>>>>
>>>> Add device table for omap_wdt to support dt.
>>>>
>>>> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
>>>> ---
>>>> drivers/watchdog/omap_wdt.c | 8 ++++++++
>>>> 1 files changed, 8 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
>>>> index 8285d65..d98c615 100644
>>>> --- a/drivers/watchdog/omap_wdt.c
>>>> +++ b/drivers/watchdog/omap_wdt.c
>>>> @@ -430,6 +430,13 @@ static int omap_wdt_resume(struct
>>>> platform_device *pdev)
>>>> #define omap_wdt_resume NULL
>>>> #endif
>>>>
>>>> +static const struct of_device_id omap_wdt_of_match[] = {
>>>> + { .compatible = "ti,omap3-wdt", },
>>>> + { .compatible = "ti,omap4-wdt", },
>
> If there is no difference between the OMAP3 and the OMAP4 WDT IP, just 
> add one entry "ti,omap3-wdt". And then in the OMAP4 DTS you will just 
> put : compatible = "ti,omap3-wdt"; or compatible =  "ti,omap4-wdt", 
> "ti,omap3-wdt";
> I'm still a little bit confused about the real need for the 
> "ti,omap4-wdt: entry, but it seems to be the way to do it in PPC.
I believe OMAP2, OMAP3 and OMAP4 share the same IP, so how about use 
"ti, omap2-wdt"? and other dts files
put compatible like "ti,omap4-wdt", "ti,omap2-wdt" and "ti,omap4-wdt", 
"ti,omap2-wdt".
>
>>>> + {},
>>>> +};
>>>> +MODULE_DEVICE_TABLE(of, omap_wdt_of_match);
>>>> +
>>>> static struct platform_driver omap_wdt_driver = {
>>>> .probe = omap_wdt_probe,
>>>> .remove = __devexit_p(omap_wdt_remove),
>>>> @@ -439,6 +446,7 @@ static struct platform_driver omap_wdt_driver = {
>>>> .driver = {
>>>> .owner = THIS_MODULE,
>>>> .name = "omap_wdt",
>>>> + .of_match_table = omap_wdt_of_match,
>>>> },
>>>> };
>>>>
>>>
>>> I think we need to add some code to the probe function that calls
>>> of_match_device() and ensures we find a match. For example ...
>>>
>>> if (of_have_populated_dt())
>>> if (!of_match_device(omap_wdt_of_match, &pdev->dev))
>>> return -EINVAL;
>>>
>> Will add it in v2, thanks for suggestion.
>
> No, in fact this is not needed. We need that mainly when several 
> instances can match the same driver and thus we select the proper one 
> using the of_match_device. Otherwise, just check is the device_node is 
> there.
>
> In that case, the driver does not even care about any DT node so there 
> is no need to add extra code for that. Keep it simple.
>
Thanks for elaborating, simple is good for this one.

Regards,
Xiao
> Regards,
> Benoit

