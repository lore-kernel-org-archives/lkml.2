Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2DQC1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:27:38 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:19027 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2DQC1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:27:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACxOgk8Y9geI/2dsb2JhbAANNoVztlABAQEBAyMEUQEQCxgCAgUWCwICCQMCAQIBRQYNAQUCAQG0JIoYgS+OE4EYBKklgTgW
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="174785858"
Message-ID: <4F8CD4FC.6020006@teksavvy.com>
Date: Mon, 16 Apr 2012 22:27:08 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com>	<4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C76AA.4050608@linaro.org>
In-Reply-To: <4F8C76AA.4050608@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-16 03:44 PM, John Stultz wrote:
> On 04/16/2012 07:23 AM, richard -rw- weinberger wrote:
>> On Mon, Apr 16, 2012 at 3:55 PM, Mark Lord<kernel@teksavvy.com>  wrote:
>>> Speaking of which -- that batch of RTC updates is riddled with bugs.
>>> For example, this beauty from rtc-mpc5121.c in the same update:
>>>
>>>         ...
>>>         rtc->rtc = rtc_device_register("mpc5200-rtc",&op->dev,
>>>                                         &mpc5200_rtc_ops, THIS_MODULE);
>>>         ...
>>>
>>>         rtc->rtc->uie_unsupported = 1;    //<<<<  Ooops NULL pointer>>>>
>>>
>>>         if (IS_ERR(rtc->rtc)) {           //<<<<  this needs to be earlier>>>>
>>>                 err = PTR_ERR(rtc->rtc);
>>>                 goto out_free_irq;
>>>         }
>>>         ...
>>>
>>>
> 
> Thanks for noticing this and CC'ing me.  I'll spin up a fix promptly for review.
> -john

Yeah.  My apologies for being so harsh there.
At least the fix is easy enough.

Cheers!
