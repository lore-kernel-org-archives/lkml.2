Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0EOQsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 12:48:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13059 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0EOQsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 12:48:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=njTao5+rz8QrXUy/I6gOtTrQVAoYYyQScBrBx5sccb4bUr7YMQFMuPnZusf6SCNrU
	sNCt3QFXEEi4hGam+54Yw==
MIME-Version: 1.0
In-Reply-To: <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
References: <87tyq9mqrz.fsf@basil.nowhere.org>
	 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
Date: Sat, 15 May 2010 09:48:26 -0700
Message-ID: <AANLkTikRnoI1XeXkpIJXERD8kw2Akl4FgbBeuJ_vCPrX@mail.gmail.com>
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: Venkatesh Pallipadi <venki@google.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 6:29 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
>> From: Andi Kleen [mailto:andi@firstfloor.org]
>>
>> > Kernel information about calibrated value of tsc_khz and
>> > tsc_stability (result of tsc warp test) are useful bits of
>> information
>> > for any app that wants to use TSC directly. Export this read_only
>> > information in sysfs.
>>
>> Is this really a good idea?  It will encourage the applications
>> to use RDTSC directly, but there are all kinds of constraints on
>
> Indeed, that is what it is intended to do.
>
>> that. Even the kernel has a hard time with them, how likely
>> is it that applications will get all that right?
>
> That's the point of exposing the tsc_reliable kernel data.
> If the processor has Invariant TSC and the system has
> successfully passed Ingo's warp test and, as a result
> the kernel is using TSC as a clocksource, why not enable
> userland apps that need to obtain timestamp data
> tens or hundreds of thousands of times per second to
> also use the TSC directly?
>

I am a little concerned about applications getting this right, with
rdtsc and related barriers etc. May be that calls for a userspace
library.

Despite of that, it is useful information to human user to know
whether tsc is stable and what TSC freq is. It will be very hard for
userspace to do the TSC calibration. And to know whether TSC warp test
passed or whether TSC is marked unstable by the kernel, there is no
one place to get these answers today. Users have to look at
clocksource, dmesg, etc.

Thanks,
Venki
