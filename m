Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2DPVLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:11:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48976 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab2DPVLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:11:47 -0400
Message-ID: <4F8C76AA.4050608@linaro.org>
Date: Mon, 16 Apr 2012 12:44:42 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com>	<4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com>
In-Reply-To: <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041621-7182-0000-0000-00000148180A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 07:23 AM, richard -rw- weinberger wrote:
> On Mon, Apr 16, 2012 at 3:55 PM, Mark Lord<kernel@teksavvy.com>  wrote:
>> Speaking of which -- that batch of RTC updates is riddled with bugs.
>> For example, this beauty from rtc-mpc5121.c in the same update:
>>
>>         ...
>>         rtc->rtc = rtc_device_register("mpc5200-rtc",&op->dev,
>>                                         &mpc5200_rtc_ops, THIS_MODULE);
>>         ...
>>
>>         rtc->rtc->uie_unsupported = 1;    //<<<<  Ooops NULL pointer>>>>
>>
>>         if (IS_ERR(rtc->rtc)) {           //<<<<  this needs to be earlier>>>>
>>                 err = PTR_ERR(rtc->rtc);
>>                 goto out_free_irq;
>>         }
>>         ...
>>
>>

Thanks for noticing this and CC'ing me.  I'll spin up a fix promptly for 
review.
-john

