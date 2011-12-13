Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1LMGqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:46:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35136 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1LMGqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:46:00 -0500
MIME-Version: 1.0
In-Reply-To: <20111212173215.GI23870@elte.hu>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
	<1323559734-3488-3-git-send-email-eranian@google.com>
	<1323694657.13285.12.camel@twins>
	<20111212173215.GI23870@elte.hu>
Date: Mon, 12 Dec 2011 22:45:58 -0800
Message-ID: <CABPqkBQJZNFC3cnXWz1ycnFDKqY6j9QeoMnq_zxH138e2Tt6kQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES generic
 PMU event
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 9:32 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Sun, 2011-12-11 at 00:28 +0100, Stephane Eranian wrote:
>> > This event counts the number of reference core cpu cycles.
>> > Reference means that the event increments at a constant rate which
>> > is not subject to core CPU frequency adjustments. The event may
>> > not count when the processor is in halted (low power) state.
>> > As such, it may not be equivalent to wall clock time. However,
>> > when the processor is not halted state, the event keeps
>> > a constant correlation with wall clock time.
>> >
>> > Signed-off-by: Stephane Eranian <eranian@google.com>
>> > ---
>> >  include/linux/perf_event.h |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> > index 564769c..0885561 100644
>> > --- a/include/linux/perf_event.h
>> > +++ b/include/linux/perf_event.h
>> > @@ -54,6 +54,7 @@ enum perf_hw_id {
>> >     PERF_COUNT_HW_BUS_CYCLES                = 6,
>> >     PERF_COUNT_HW_STALLED_CYCLES_FRONTEND   = 7,
>> >     PERF_COUNT_HW_STALLED_CYCLES_BACKEND    = 8,
>> > +   PERF_COUNT_HW_REF_CPU_CYCLES            = 9,
>> >
>> >     PERF_COUNT_HW_MAX,                      /* non-ABI */
>> >  };
>>
>> Does it make sense to add this to the 'generic' events? Are
>> other archs going to use this?
>>
>> That is, I already queued patch 1, I'm just wondering if the
>> generic bit makes sense, Even BUS_CYCLES seems to be a
>> questionable 'generic' event, but that's history and we can't
>> fix it.
>
> If we named it in a generic way, with a generic,
> platform-independent meaning behind it, then it shouldn't be a
> problem. This is why i suggested naming it 'constant CPU cycles'
> - or 'constant freq cycles' or a variant of that.
>
Isn't CPU_REF_CYCLES good enough?
Should we speel out ref completely to 'REFERENCE'.
In the changelog, I gave a generic definition of what it is supposed to
measure. If most platforms don't have such events, then that's fine too.
