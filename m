Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3AJRVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:21:50 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53355 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3AJRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:21:49 -0500
Message-ID: <50EEF8A9.5070406@gmail.com>
Date: Thu, 10 Jan 2013 18:21:45 +0100
From: Adrian Byszuk <adrian.byszuk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
References: <50ED371A.3080903@gmail.com> <20130109120732.GA8016@liondog.tnic> <50ED98AA.1090304@gmail.com> <20130109170119.GA17840@liondog.tnic> <50EDB070.9020908@gmail.com> <20130109181520.GB17840@liondog.tnic> <50EE9F24.8010908@gmail.com> <20130110113511.GB23008@liondog.tnic> <50EECA0B.2050407@gmail.com>
In-Reply-To: <50EECA0B.2050407@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/13 15:02, Adrian Byszuk wrote:
> On 10/01/13 12:35, Borislav Petkov wrote:
>> On Thu, Jan 10, 2013 at 11:59:48AM +0100, Adrian Byszuk wrote:
>>> I think I won't get the answer this way. Bisecting between
>>> 3.7 and 3.8-rc2 (from linus tree) led me to commit
>>> 63e1ed2364050073770c085021377d7764969b85 titled "Update vt8500 PWM
>>> driver support", which I think is rather nonsense. Also, depending on
>>> bisected version, sometimes I got kernel panic, but sometimes (more
>>> often) whole system would just freeze completely.
>>>
>>> Any other way diagnose this bug?
>>
>> Hmm, bisection can sometimes lead us in the fields, nasty.
>>
>> Well, you could try bisecting the major releases in between. I.e., test
>> 3.8-rc1, and then test vanilla 3.7.
>>
>> For example, if you still trigger it with -rc1, then no need to bisect
>> the -rc2..-rc1 range. If you still trigger it with 3.7 then not good -
>> in that case you'd need to go further back in time.
>>
>> The best would be if you don't trigger it with 3.7 but trigger it with
>> 3.7.1 :) Then it is easy.
> 
> Life isn't easy :-) with 3.7 I can trigger it too, but I can't trigger
> it with 3.8-rc1, so the fix lies somewhere between 3.7.1..3.8-rc1.
> I'll try bisecting it again.


Aaaand failure again!
I haven't finished bisecting yet, but as of now I have ~20 commits left:
all related to 'mtd' - propably not a source of troubles too.
Any other way to diagnose this bug?
