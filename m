Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2DPPtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:49:14 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49283 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754575Ab2DPPtM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <4F8C3DDF.8030103@teksavvy.com>
References: <4F8BA1C1.4030804@teksavvy.com>
	<4F8C24E5.4020703@teksavvy.com>
	<CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com>
	<4F8C3DDF.8030103@teksavvy.com>
Date: Mon, 16 Apr 2012 17:49:10 +0200
Message-ID: <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 5:42 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 12-04-16 10:23 AM, richard -rw- weinberger wrote:
>> On Mon, Apr 16, 2012 at 3:55 PM, Mark Lord <kernel@teksavvy.com> wrote:
>>> On 12-04-16 12:36 AM, Mark Lord wrote:
>>>> Something recent has killed suspend-to-ram on a number of machines here.
>>>> The symptom is that they suspend, but immediately wake up and panic,
>>>> with just a black screen so no visible messages to go by.
>>>>
>>>> The patch below works around the issue -- making things work as they used to work.
>>>>
>>>> +++ linux/drivers/rtc/interface.c     2012-04-16 00:09:14.105387382 -0400
>>>> @@ -773,7 +773,7 @@
>>>>       if (!rtc->ops || !rtc->ops->alarm_irq_enable)
>>>>               return;
>>>>
>>>> -     rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>>>> +     //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);  // Kills suspend on ZBOX HD-ID41U
>>>>  }
>
>
> How about the line above -- that's the commit that breaks things here.

Download Linus' GIT tree and use git blame. :-)

-- 
Thanks,
//richard
