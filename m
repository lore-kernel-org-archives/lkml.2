Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1LAJKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:10:15 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:53868
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751601Ab1LAJKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:10:12 -0500
Message-ID: <4ED7446B.5000806@compulab.co.il>
Date: Thu, 01 Dec 2011 11:10:03 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: axel.lin@gmail.com
CC: linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/4] mfd: twl6040-core: Use gpio_request_one
References: <1322704074.11560.3.camel@phoenix> <1322704507.11560.8.camel@phoenix> <4ED734AD.1070303@compulab.co.il> <CAF+7xWnf398rY_Lb8CexjZDtcp8poseQc11S-14xyNSVGDdJWw@mail.gmail.com>
In-Reply-To: <CAF+7xWnf398rY_Lb8CexjZDtcp8poseQc11S-14xyNSVGDdJWw@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/11 10:18, Axel Lin wrote:
> 2011/12/1 Igor Grinberg <grinberg@compulab.co.il>:
>> On 12/01/11 03:55, Axel Lin wrote:
>>> Use gpio_request_one() instead of multiple gpiolib calls.
>>>
>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>> ---
>>>  drivers/mfd/twl6040-core.c |    7 ++-----
>>>  1 files changed, 2 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
>>> index 268f80f..e57b1d1 100644
>>> --- a/drivers/mfd/twl6040-core.c
>>> +++ b/drivers/mfd/twl6040-core.c
>>> @@ -509,13 +509,10 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
>>>               twl6040->audpwron = -EINVAL;
>>>
>>>       if (gpio_is_valid(twl6040->audpwron)) {
>>> -             ret = gpio_request(twl6040->audpwron, "audpwron");
>>> +             ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
>>> +                                    "audpwron");
>>>               if (ret)
>>>                       goto gpio1_err;
>>> -
>>> -             ret = gpio_direction_output(twl6040->audpwron, 0);
>>> -             if (ret)
>>> -                     goto gpio2_err;
>>>       }
>>
>> same here, double check gpio_is_valid()?
> 
> In the case of
> twl6040->audpwron = -EINVAL;  ( see line 509 )
> gpio_is_valid returns false, we just don't request gpio.
> 
> If we remove the gpio_is_valid checking here,
> then gpio_request_one will return -EINVAL.
> Then the code always goes to the error path if twl6040->audpwron is -EINVAL.

Thanks for the explanation.
So the GPIO is optional - now it makes sense to me.


-- 
Regards,
Igor.
