Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2KHNt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:49:29 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35316 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2KHNt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:49:28 -0500
MIME-Version: 1.0
In-Reply-To: <509BAFB9.6090801@antcom.de>
References: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de>
	<1352301955-15960-1-git-send-email-alban.bedel@avionic-design.de>
	<509B80A7.1060700@antcom.de>
	<20121108113353.4fdbb25c@avionic-0020.adnet.avionic-design.de>
	<509B8D20.6070208@antcom.de>
	<20121108122345.72aa0f6c@avionic-0020.adnet.avionic-design.de>
	<509BAFB9.6090801@antcom.de>
Date: Thu, 8 Nov 2012 11:49:27 -0200
Message-ID: <CAAAP30HVdducnECimoh=Buh3CRTLu0agg4GcKEA7B03EnXuAAw@mail.gmail.com>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Alban Bedel <alban.bedel@avionic-design.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 11:12 AM, Roland Stigge <stigge@antcom.de> wrote:
> On 08/11/12 12:23, Alban Bedel wrote:
>>>> It is intended, the formular for duty value in the register is:
>>>>
>>>> duty = (256 - 256*duty_ns/period_ns) % 256
>>>
>>> Where does this modulo defined? In the Manual, there is sth. like this
>>> defined for RELOADV (tables 606+607), but not for DUTY.
>>>
>>> Maybe I missed sth. in the manual. Link or hint appreciated!
>>
>> The manual doesn't mention this explicitly but you can see that without
>> the modulo when duty_ns==0 DUTY would be 256, but the register is only
>> 8 bits wide (ie. modulo 256). I made a few test and looked at the PWM
>> output on a scope they confirm this:
>>
>>  DUTY     HIGH LEVEL
>>   1         99.9%
>>   25        90.0%
>>   128       50.0%
>>   220       10.0%
>>   255        0.1%
>>   0          0.0%
>>
>> I'll resubmit the patch with the clamping in the correct order.
>
> Thanks for measuring. With this, your resubmitted patch make much more
> sense now.
>
> Roland

Alban,

I think you should include this measurements on the source code as
comments, for future reference.

Thanks.
