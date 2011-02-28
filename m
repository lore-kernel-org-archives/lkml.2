Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1B1ONP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:13:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47809 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab1B1ONO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iYP38GeuedqQYgZKKpFc87WQLJh6UC16nlN5uhX/Q2TrpOtbWV7dp4caeu47IXahOx
         vzrX6jtMoX0nPcd8M/HA==
MIME-Version: 1.0
In-Reply-To: <1298901731.2169.35.camel@localhost>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	<AANLkTimAkCtPwEMzHM3A_=kWs+HbYMJ_OBvxcHo46RJg@mail.gmail.com>
	<1298883087.4937.42.camel@minggr.sh.intel.com>
	<20110228090833.GA7439@elte.hu>
	<1298901731.2169.35.camel@localhost>
Date: Mon, 28 Feb 2011 15:13:11 +0100
Message-ID: <AANLkTin0PrMKOjC-_w7wS0y0me8Qn0bdDN-p=O8sTOM6@mail.gmail.com>
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also for offcore_reponse_*, the fact that they are marked as PMC3 only is just
a convenience for scheduling. Given both events need an extra MSR, it makes
scheduling easier if you consider offcore_reponse_0 to work only on one counter.
That guarantees there won't be conflict on that extra MSR. The downside, is that
you cannot measure the event twice if you only want to vary the counter filters
(not the extra MSR), e.g., measure one instance at user level and the other at
kernel level.

On SNB, the extra MSRs are not shared by HT threads anymore (Table B-9).
That means that in the offcore patch, the extra_config logic is needed but not
the mutual exclusion between HT threads.


On Mon, Feb 28, 2011 at 3:02 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Mon, 2011-02-28 at 17:08 +0800, Ingo Molnar wrote:
>> * Lin Ming <ming.m.lin@intel.com> wrote:
>>
>> > > In other words, bit 0-3 of the umask cannot be zero.
>> >
>> > I got the umask from "Table 30-20. PEBS Performance Events for Intel
>> > microarchitecture code name Sandy Bridge".
>> >
>> > But from "Table A-2. Non-Architectural Performance Events In the Processor Core
>> > for Intel Core Processor 2xxx Series", the combinations are needed as you show
>> > above.
>> >
>> > Which one is correct?
>>
>> Since you have access to the hardware, could you please test and see it in practice
>> which one is correct?
>
> Stephane is right, need the combination.
> Sorry that I may made mistake when I tested 0xd0 pebs events.
>
> Re-test all PEBS events, now only below 2 events need more support to
> work.
>
> PEBS_EVENT_CONSTRAINT(0x01cd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
> PEBS_EVENT_CONSTRAINT(0x02cd, 0x8), /* MEM_TRANS_RETIRED.PRECISE_STORE*/
>
>>
>> Thanks,
>>
>>       Ingo
>
>
>
