Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1LBWWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:22:06 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34520 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab1LBWWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:22:04 -0500
MIME-Version: 1.0
In-Reply-To: <4ED9267F.10106@fb.com>
References: <20111121145114.049265181@chello.nl>
	<4ED9267F.10106@fb.com>
Date: Fri, 2 Dec 2011 14:22:02 -0800
Message-ID: <CABPqkBRpYA-StOTDFwyFhFtBPynbn-FLUzqZvaQn3oM3SJpCWg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
From: Stephane Eranian <eranian@google.com>
To: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
        William Cohen <wcohen@redhat.com>, Vince Weaver <vince@deater.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you tried with inheritance disabled?
I don't remember if perf stat has it enabled buy default.

On Fri, Dec 2, 2011 at 11:26 AM, Arun Sharma <asharma@fb.com> wrote:
> On 11/21/11 6:51 AM, Peter Zijlstra wrote:
>>
>> These few patches implement x86 RDPMC support and add an extention to the
>> self
>> monitoring data to also allow additional time updates using userspace TSC
>> reads.
>>
>> There's a few loose ends, but it mostly seems to work.
>
>
> I haven't had a chance to test this out yet. But low overhead, always on
> perf counters is something we're very interested in. Thanks for implementing
> it.
>
> However, I suspect the major cost of leaving the perf counters always on
> seems to be in the hit on context switches, rather than the cost of reading
> the perf counters themselves. For eg:
>
>  Baseline:
>
>   (for i in `seq 1 10`; do numactl --cpunodebind 1 ./lat_ctx -P1 -s32k 4;
> done) 2>&1 | tee lmbench1.log
>
>  1 event:
>
>  (for i in `seq 1 10`; do numactl --cpunodebind 1 perf stat -e instructions
> ./lat_ctx -P1 -s32k 4; done) 2>&1 | tee lmbench2.log
>
>  2 events:
>
>  (for i in `seq 1 10`; do numactl --cpunodebind 1 perf stat -e
> cycles,instructions ./lat_ctx -P1 -s32k 4; done) 2>&1 | tee lmbench3.log
>
>  Baseline: 2.2us
>  One event: 6.8us
>  Two events: 7.2us
>
> The cost seems to be at roughly 5us (I measured 2.6.38 and 3.2-rc2). I'll
> dig a bit more on what may be going on here.
>
>  -Arun
