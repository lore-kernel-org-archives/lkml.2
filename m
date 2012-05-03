Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab2ECTnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:43:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52352 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2ECTnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:43:14 -0400
Message-ID: <4FA2DF8F.5080501@linaro.org>
Date: Thu, 03 May 2012 12:42:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
References: <cover.1335510125.git.richardcochran@gmail.com> <4F9B228F.90903@linaro.org> <20120503182128.GB2254@netboy.at.omicron.at> <4FA2D21D.6010805@linaro.org> <20120503192823.GA5711@netboy.at.omicron.at>
In-Reply-To: <20120503192823.GA5711@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050319-6148-0000-0000-0000058A0327
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 12:28 PM, Richard Cochran wrote:
> On Thu, May 03, 2012 at 11:44:45AM -0700, John Stultz wrote:
>> But the changes you make to getnstimeofday() still needs to happen
>> in the vDSO code. The vDSO code basically implements
>> getnstimeofday() in userland.
>>
>> If you're code is trying to make it so that the leap-second is
>> properly handled at the second boundary instead of the tick
>> boundary, there must me some change needed to the vDSO, since the
>> vDSO code is updated only each tick. Otherwise how can you enforce
>> the leap after the second boundary but before the tick?
> Yeah, so the vDSO does the sub-tick interpolation, and this can easily
> miss an inserted leap second for a while (just like the current code).
>
> So, this patch series as it stands improves the users of the
> traditional syscalls without hurting the superduper vDSO performance
> at all. The vDSO leap second time errors are not fixed, but they are
> also no worse than today, either.
>
> I am try to say that, even if there is resistance to adding code in
> the vDSO path for reasons of performance, that doesn't necessarily
> mean that we cannot fix the leap second for the tradition syscall
> case.
But this also has the same drawback of only fixing the adjtimex() path, 
in that applications that mix calls to gettimeofday or adjtimex will see 
different behavior in that tick interval.  I'd also try to avoid any 
disparity between the syscall and vdso syscall implementations, as 
they're supposed to be identical.

thanks
-john

