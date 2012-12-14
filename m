Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2LNXsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:48:37 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65235 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab2LNXsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:48:32 -0500
Message-ID: <50CBBACA.2070108@linaro.org>
Date: Fri, 14 Dec 2012 15:48:26 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andy Lutomirski <luto@amacapital.net>, aarcange@redhat.com,
        ak@linux.intel.com, Pavel Emelyanov <xemul@parallels.com>,
        Stefani Seibold <stefani@seibold.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org, mingo@redhat.com,
        tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
References: <50CAE485.5020608@parallels.com> <50CB716D.6020501@zytor.com> <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com> <50CB7459.7010107@zytor.com> <20121214201217.GE6582@moon> <50CB9553.7050808@zytor.com> <CALCETrUS7JDtLd0jYy7cRNoBm1VHhMw3sTPRjhsm3uDwoPQrCA@mail.gmail.com> <50CBA171.4080403@zytor.com> <20121214222517.GG6582@moon> <50CBA7BC.4020001@zytor.com> <20121214224307.GH6582@moon> <50CBACD2.60307@zytor.com>
In-Reply-To: <50CBACD2.60307@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 02:48 PM, H. Peter Anvin wrote:
> On 12/14/2012 02:43 PM, Cyrill Gorcunov wrote:
>> On Fri, Dec 14, 2012 at 02:27:08PM -0800, H. Peter Anvin wrote:
>>
>>
>> This won't help in case of scenario you've been pointing in
>> previous email (where c/r happens in a middle of vdso),
>> would it? Because we still need somehow to be sure we're not
>> checkpointing in a middle of signal handler which will return
>> to some vdso place.
> It is okay if and only if those vdso places never change... which I
> think is doable if they only contain trival system call wrappers, i.e.
> something like:
>
> 	movl $__SYS_gettimeofday, %eax
> 	syscall
> 	ret

Though doesn't this make it easier for exploits (somewhat undoing ASLR)? 
I know Andi always wanted to avoid having syscall instructions at a 
fixed location for the old vsyscall code (though I know we had it 
none-the-less for awhile).   But maybe I'm confusing issues here?

thanks
-john
