Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab0FFD3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 23:29:46 -0400
Received: from mail.lang.hm ([64.81.33.126]:58335 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934005Ab0FFD3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 23:29:44 -0400
Date: Sat, 5 Jun 2010 20:28:51 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Russell King <rmk@arm.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <20100603185333.GD25779@flint.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.01.1006052021300.17462@asgard.lang.hm>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
 <20100603185333.GD25779@flint.arm.linux.org.uk>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Russell King wrote:

> On Thu, Jun 03, 2010 at 11:18:05AM -0700, Linus Torvalds wrote:
>>
>>
>> On Thu, 3 Jun 2010, Russell King wrote:
>>>
>>> Umm.  I don't think you've actually looked at the Kconfig files if you're
>>> writing this, because that's precisely what we already do.
>>
>> .. but if you do this _right_, then the defconfig files would be
>> unnecessary.
>>
>> That's my point. If you are right, then I can remove the defconfig files
>> entirely. Are you ready for that?
>
> Absolutely no way are we ready for that.
>
>> And if you aren't ready for that, then what was the point of your email?
>
> Linus, don't make this personal.
>
> The problem is NOT "what options which are found under the arch/arm tree
> do I need".
>
> The problem is "what options throughout the rest of the kernel do I need
> to result in a usable kernel".

What do you define as useable?

at two extremes:

do you mean a kernel that fully supports the board and all it's features?

do you mean a kernel that will compile and boot, but may not be able to 
talk to the outside world as it doesn't know about any I/O that the chip 
may have.

I don't think that defconfig can work for the first case (every single 
system would hae it's own defconfig, which just doesn't scale)

and I'm not sure the second is very useful (and it should be covered by 
the kconfig defaults)

if you are looking for something in between, where do you draw the line?

back when linux ran on x86 with IDE only, defconfig made a lot of sense, 
but that was because the hardware was very standardized, nowdays even in 
the x6 space there is enough variation that it's questionable how useful a 
defconfig is.

What would be far better would be some tool that would take some hardware 
defintition (either autodetecting from a currenlty running system on x86, 
or from the device_tree stuff that's being worked on for other 
architectures) and create a kernel config from that that would fully 
support the hardware detected.

David Lang

> No amount of reorganising the Kconfig files into a heirarchial manner
> (which they already are) helps.  Not one bit.  Because they already are.
> That's not where the problem is.
>
> For instance, if I have platform A, I know it has an RTC.  How do I know
> which of the 37 RTC drivers the kernel configuration presents me with to
> select?  Am I really expected to open up the platform and read the
> device numbers off all the chips (some of which being surface mount are
> abbreviated) and work out that it's a TWL4030 RTC that I should be using?
>
> That's just one instance - and there's probably many more just like that.
> Just look at "multifunction drivers" for another case in point.  How the
> hell do I know what multifunction driver is appropriate for a platform?
>
> Ditto "Power supply support".
>
> The list goes endlessly on.  All those things I've mentioned are all
> _outside_ of arch/arm.  That's where the _real_ problem is.  Solve that
> problem so that it's easier for people to configure the kernel, and then
> we don't need the multitude defconfig files.
>
> That's the problem which the defconfigs are solving today.
>
>
