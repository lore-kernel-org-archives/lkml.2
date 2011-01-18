Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1ARU0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:26:38 -0500
Received: from smtp-out.google.com ([74.125.121.67]:7688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1ARU0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:26:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eiMCzIGPwnrlADuAtQSjzryFNRLGNsLR9iL0VU25jkBvG+dmGwMk1zogwW1PxU69Ca
         hnJXTGMmP7uq8E0liwnQ==
MIME-Version: 1.0
In-Reply-To: <1295375793.30950.1056.camel@laptop>
References: <AANLkTinVc=VRo+2=M3x5HEoF__SOJn7kBk7Ek0R94TG9@mail.gmail.com>
	<1295375793.30950.1056.camel@laptop>
Date: Tue, 18 Jan 2011 21:26:31 +0100
Message-ID: <AANLkTikG_Tnh53Cp8fStPBmeuowZgQp8HvMLXZ4kxSbv@mail.gmail.com>
Subject: Re: [BUG] perf_event: inst_retired:any_p:c=16:i=1 is not equivalent
 to cpu_clk_unhalted:thread_p
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 7:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-01-18 at 19:05 +0100, Stephane Eranian wrote:
>> Peter,
>>
>> commit 7639dae0ca11038286bbbcda05f2bef601c1eb8d
>> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Date:   Tue Dec 14 21:26:40 2010 +0100
>>
>>     perf, x86: Provide a PEBS capable cycle event
>>
>>
>>
>> Even with the transformation cmask=16:invert=1, you are not quite
>> counting the same thing.
>>
>> inst_retired:any_p:c=16:i=1  is different from cpu_clk_unhalted:thread_p
>>
>> Simply because, I think, this form of inst_retired counts in HALTED state.
>
> Drad it does indeed:
>
> # perf stat -a -e cycles:p -e cycles sleep 1
>
>  Performance counter stats for 'sleep 1':
>
>        61,634,870 cycles
>        26,703,249 cycles
>
>        1.000860820  seconds time elapsed
>
What's interesting here is that this cycles:p is not event equal to 1x CPU freq
given your measuring for 1s. So it must stop counting at some point.

>
>> This automatic transformation would be "okay" in per-thread mode, but
>> not in system-wide mode. It should not be done under the cover. I would
>> rather have this option at the user level.
>
> Agreed, since its not identical it had best be done in userspace, too
> bad :/ I'll revert this patch.
>
Yes, it would have been nice. But if you know what you're doing, this is
still doable from user space. So I think we are okay.
