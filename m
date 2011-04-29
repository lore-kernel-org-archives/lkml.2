Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1D2EbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 00:31:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45264 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1D2EbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 00:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xnIwfpcM9AobANjAslDvAvwyyRHnuvCUAvdELurBhg6fB3tOhgN7xTXB7m0VD9oubN
         AP1lAczz8BdFjBvBhup5B+Yu976/ysOz/Rq3ZVPabnP4qOtVbJQyzG7V3IYQ11MNe6pS
         CIqjELW4gr2D7tB6OLfdOoK9neE3IxB37CJKI=
Message-ID: <4DBA3F13.9010706@gmail.com>
Date: Fri, 29 Apr 2011 08:31:15 +0400
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
CC: Rodolfo Giometti <rodolfo.giometti@enneenne.com>, linuxpps@ml.enneenne.com,
        linux-kernel@vger.kernel.org
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>	<20110428152222.0271163f@apollo.gnet>	<BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>	<20110429005524.67600139@apollo.gnet> <20110429012748.704a39a6@apollo.gnet>
In-Reply-To: <20110429012748.704a39a6@apollo.gnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> В Fri, 29 Apr 2011 00:55:24 +0400
> Alexander Gordeev<lasaine@lvk.cs.msu.su>  пишет:
>
>> В Thu, 28 Apr 2011 16:03:59 -0400
>> James Nuss<jamesnuss@nanometrics.ca>  пишет:
>>
>>> Hi Alexander,
>>>
>>> Thanks for reviewing the code.
>>>
>>> On Thu, Apr 28, 2011 at 7:22 AM, Alexander Gordeev
>>> <lasaine@lvk.cs.msu.su>  wrote:
>>>> Hi James,
>>>>
>>>> В Wed, 27 Apr 2011 14:14:14 -0400
>>>> James Nuss<jamesnuss@nanometrics.ca>  пишет:
>>>>
>>>>> +             return -EINVAL;
>>>>> +     }
>>>>> +
>>>>> +     res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>>>>> +     if (res == NULL) {
>>>>> +             pr_err(PPS_IRQ_NAME ": no IRQ resource was given");
>>>>> +             return -EINVAL;
>>>>> +     }
>>>>> +
>>>>> +     if (!(res->flags&  (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
>>>>> +             pr_err(PPS_IRQ_NAME ": given IRQ resource must be edge triggered");
>>>>> +             return -EINVAL;
>>>>> +     }
>>>> I think it doesn't actually expect that both flags are set because it
>>>> always treats it as assert in the irq handler. What does your signal
>>>> look like?
>>> The conditional logic is that one of either IRQF_TRIGGER_RISING or
>>> IRQF_TRIGGER_FALLING must be set. It doesn't make much sense to have
>>> neither set for PPS signals.
>>> My intention is that the driver is generic enough so you can register
>>> an IRQ resource with either IRQF_TRIGGER_RISING or
>>> IRQF_TRIGGER_FALLING and you will get and assert event for that edge.
>>> Clear events are not generated as you suggest but I believe this is
>>> OK.
>>> My signal is a simple low-to-high transition indicating the PPS. But I
>>> believe you could register a device using this driver referencing the
>>> other edge if required.
>> Ok, but is there a way one can register an IRQ resource with both flags
>> set? If yes, then it would be nice to have a stricter check here to
>> prevent two situations:
>> 1. none flag is set (it is already in place)
>> 2. both flags are set
>>
>> The latter will definitely mess things up, right?
> I mean, one surely can register an IRQ resource with both flags set. And
> if the underlying hardware works as it is described (i.e. raises an irq
> on both edges) then it will be a problem.

Please don't try to abandon one of ASSERT or CLEAR events!
It is very useful to register both of them, because in this case its 
possible to measure pulse width and decode PPS signals like DCF77.

I write similar driver (pps-client-gpio.c) for Linux-2.6.36 with helper 
drivers (virtual-gps.c and pps-decoders.c) which allows to receive 
GeoSIG Ltd. T1PPS (DCF77 alike) time signal, register both events, then 
decode them and provide a virtual GPS (NMEA time source) device.

These drivers operates very well together with standard NTP server.

>
> _______________________________________________
> LinuxPPS mailing list
> LinuxPPS@ml.enneenne.com
> http://ml.enneenne.com/cgi-bin/mailman/listinfo/linuxpps
> Wiki:http://wiki.enneenne.com/index.php/LinuxPPS_support

Best regards!

-- 
Igor Plyatov

