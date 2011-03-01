Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1CAQpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:45:14 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:2679 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1CAQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:45:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANKxbE2rR7Ht/2dsb2JhbACEKKIkdKBBiwWRIoEng0R2BIUShw2DQA
X-IronPort-AV: E=Sophos;i="4.62,248,1297036800"; 
   d="scan'208";a="337080158"
Message-ID: <4D6D22A7.6000000@cisco.com>
Date: Tue, 01 Mar 2011 09:45:27 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>	 <1298865151-23656-4-git-send-email-daahern@cisco.com>	 <1298989751.5226.863.camel@laptop>  <4D6D0438.2090901@cisco.com>	 <1298993714.5226.871.camel@laptop>  <4D6D13C6.5020807@cisco.com>	 <1298995250.5226.882.camel@laptop>  <4D6D1A4C.1090009@cisco.com> <1298997435.5226.890.camel@laptop>
In-Reply-To: <1298997435.5226.890.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/01/2011 09:37 AM, Peter Zijlstra wrote:
> On Tue, 2011-03-01 at 09:09 -0700, David Ahern wrote:
>>
>> I did not code it create samples of a realtime-clock event; I coded it
>> to add an event to the stream on demand -- whatever event the fd is
>> tied to.
>>
>>
> Well yes, but aside from you and the realtime clock stuff, who'd ever
> want to do this particular thing?

One example would be a system watchdog that decided for some reason or
another to force an event sample because of some event it detected.

> 
> I'd much rather expose the whole
> local_clock()/perf_clock()/trace_clock() (should all be the same anyway)
> as a posix clock using CLOCK_TRACING or whatever would be an appropriate
> name.
> 
> [ Since the whole thing is NMI safe it should be well possible to make a
> VDSO version as well. ]
> 
> Anyway, once its visible as a posix clock you can sync up from
> userspace. And this clock is indeed wanted for other things too, like
> user-space tracing etc.
> 

And for some silly reason I sense a time trap here (pun intended) .....

So your pushback is:
1. throw out the realtime-clock event patch,

2. add a new CLOCK_TRACING type to clock_gettime with VDSO hook,

3. and use a synthesized event from userspace for snapshotting
perf_clock to time-of-day -- similar to what I have now, but one that
will guarantee a time-of-day to perf_clock correlation (versus the
current one which hopes that perf_clock is the monotonic clock).

David
