Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2LNVWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:22:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50427 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab2LNVWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:22:13 -0500
Message-ID: <50CB986C.20306@zytor.com>
Date: Fri, 14 Dec 2012 13:21:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andy Lutomirski <luto@amacapital.net>, aarcange@redhat.com,
        ak@linux.intel.com, Pavel Emelyanov <xemul@parallels.com>,
        Stefani Seibold <stefani@seibold.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org, mingo@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
References: <50CA85BD.7070502@zytor.com> <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com> <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com> <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com> <50CAE485.5020608@parallels.com> <50CB716D.6020501@zytor.com> <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com> <50CB7459.7010107@zytor.com> <20121214201217.GE6582@moon> <50CB9553.7050808@zytor.com> <20121214212023.GF6582@moon>
In-Reply-To: <20121214212023.GF6582@moon>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 01:20 PM, Cyrill Gorcunov wrote:
> On Fri, Dec 14, 2012 at 01:08:35PM -0800, H. Peter Anvin wrote:
>> On 12/14/2012 12:12 PM, Cyrill Gorcunov wrote:
>>>>>
>>>> The real issue is that happens if the process is checkpointed while
>>>> inside the vdso and now eip/rip or a stack frame points into the vdso.
>>>> This is not impossible or even unlikely, especially on 32 bits it is
>>>> downright likely.
>>>
>>> I fear if there are stacked ip which point to vdso -- we simply won't
>>> be able to restore properly if vdso internal format changed significantly
>>> between kernel versions. (At moment we restore vdso exactly at same position
>>> it was on checkpoint stage with same content, iirc).
>>>
>>
>> I don't think there is a way around that.  It is completely unreasonable
>> to say that the vdso cannot change between kernel versions, for obvious
>> reasons.  It's worse than "significantly"... changing even one
>> instruction makes it plausible your eip/rip will point into the middle
>> of an instruction.
> 
> Well, one idea was to try to escape dumping when a dumpee inside vdso area
> and wait until it leaves this zone, then proceed dumping. Then, if vdso is
> changed (say some new instructions were added) we zap original prologues
> with jmp to new symbols from fresh vdso provided us by a kernel. I'm not
> really sure if this would help us much but just saying (I must admit I
> didn't looked yet into vdso implementation details, so sorry if it sounds
> stupid).
> 

Well, if the vdso contains a system call you may be waiting indefinitely.

	-hpa


