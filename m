Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2DPU4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:56:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48948 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2DPU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:56:29 -0400
Message-ID: <4F8C76EB.20709@linaro.org>
Date: Mon, 16 Apr 2012 12:45:47 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C3DDF.8030103@teksavvy.com> <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com> <4F8C415C.80806@teksavvy.com>
In-Reply-To: <4F8C415C.80806@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041620-3270-0000-0000-00000599D8AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 08:57 AM, Mark Lord wrote:
> On 12-04-16 11:49 AM, richard -rw- weinberger wrote:
>> On Mon, Apr 16, 2012 at 5:42 PM, Mark Lord<kernel@teksavvy.com>  wrote:
>>> On 12-04-16 10:23 AM, richard -rw- weinberger wrote:
>>>> On Mon, Apr 16, 2012 at 3:55 PM, Mark Lord<kernel@teksavvy.com>  wrote:
>>>>> On 12-04-16 12:36 AM, Mark Lord wrote:
>>>>>> Something recent has killed suspend-to-ram on a number of machines here.
>>>>>> The symptom is that they suspend, but immediately wake up and panic,
>>>>>> with just a black screen so no visible messages to go by.
>>>>>>
>>>>>> The patch below works around the issue -- making things work as they used to work.
>>>>>>
>>>>>> +++ linux/drivers/rtc/interface.c     2012-04-16 00:09:14.105387382 -0400
>>>>>> @@ -773,7 +773,7 @@
>>>>>>        if (!rtc->ops || !rtc->ops->alarm_irq_enable)
>>>>>>                return;
>>>>>>
>>>>>> -     rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>>>>>> +     //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);  // Kills suspend on ZBOX HD-ID41U
>>>>>>   }
>>>
>>> How about the line above -- that's the commit that breaks things here.
>> Download Linus' GIT tree and use git blame. :-)
> Too steep a learning curve for a casual user.
> But google works:
>
> http://www.mail-archive.com/stable@vger.kernel.org/msg04391.html

Thanks for the report and sorry for the trouble.  I'm trying to 
reproduce this locally. Can you send me your .config?

thanks
-john

