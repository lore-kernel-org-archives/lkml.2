Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2GPMmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:42:17 -0400
Received: from smtp-out-157.synserver.de ([212.40.185.157]:1059 "EHLO
	smtp-out-157.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2GPMmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:42:15 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16950
Message-ID: <50040D15.8040205@metafoo.de>
Date: Mon, 16 Jul 2012 14:46:13 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Adding support for configuring polarity in PWM framework.
References: <518397C60809E147AF5323E0420B992E3E960B0E@DBDE01.ent.ti.com> <20120716113921.GA3015@avionic-0098.adnet.avionic-design.de> <518397C60809E147AF5323E0420B992E3E960C32@DBDE01.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3E960C32@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 02:23 PM, Philip, Avinash wrote:
> On Mon, Jul 16, 2012 at 17:09:21, Thierry Reding wrote:
>> On Mon, Jul 16, 2012 at 11:15:50AM +0000, Philip, Avinash wrote:
>>> Hi Thierry,
>>>
>>> On one of the custom boards we are using, uses PWM to drive the backlight. However, for
>>> this device, PWM signal needs to be inversed.
>>> So, we need to a platform data to indicate this parameter.
>>> Current PWM framework doesn't provide .support for setting polarity (or inverse polarity).
>>>
>>> Have you come across any such requirements? If so, do you have any plans to implement it?
>>
>> I don't have any plans to implement such a feature.
> 
> Ok. Thanks for the quick response.
>>
>>> I am planning to add support for the same but want to avoid duplication of work.
>>>
>>> If you have no plans, then I will send a patch to support the same.
>>
>> I wonder how you want to implement this. You'll need special hardware
>> support for it 
> 
> Yes. Our custom hardware (backlight booster) requires the pwm signal to be 
> inverted.
> 
>> you may be able to implement it in the driver itself 
>> instead of putting it into the framework. 
> 

I think this is a common feature amongst PWM chips that they are able to
invert the PWM signal. And some applications of PWM require that you are
able to specify the polarity, so I think it makes sense to put this into the
common framework.

>> Anyway I'm interested in seeing your patch.
> 
> I am planning to modify PWM framework as below.
> 1. Configure PWM polarity from client driver (using platform data provided 
> to pwm backlight driver).
> 2. PWM device needs to be disabled before calling the set-polarity API.
> 
> This involves
> 
> 1. PWM framework API addition.
> 	PWM frame work API support.
> 	/**
> 	 * pwm_setpolarity() - change a PWM device Polarity	
> 	 * @pwm: PWM device
> 	 * @polarity: Configure polarity of PWM
>  	*
> 	 * polarity     - false -> "on" time defined by duty ns
> 	*              - true  -> "off' time defined by duty ns.
>  	*/

Isn't this more about whether we start with a low or a high signal? If it is
just about the duty time you can easily achieve the same effect by setting
it to (period_ns - duty_ns).

- Lars

