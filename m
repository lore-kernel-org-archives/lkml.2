Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2J2JoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:44:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53168 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2J2Jn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <m2ip9uqc5w.fsf@firstfloor.org>
References: <CABPqkBRBcYqBqhitAF0u6o1+TZqaRREMvb+ie_bbTaK3JdAB3Q@mail.gmail.com>
	<m2ip9uqc5w.fsf@firstfloor.org>
Date: Mon, 29 Oct 2012 10:43:57 +0100
Message-ID: <CABPqkBRR9zeoO_fPcAaR2C2QgVkfFRTtMuS684EJAwpPejM=_Q@mail.gmail.com>
Subject: Re: [BUG] perf parser: does not support arbitrary new sysfs events
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 2:50 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Stephane Eranian <eranian@google.com> writes:
>
>> Hi,
>>
>> The latest round of perf parser changes broke my PEBS-LL patch series
>> (at the last minute). For PEBS-LL, I need to add to generic events but I want
>> to keep them PMU specific. As such, they need to live in the sysfs events
>> subdir: /sys/devices/cpu/events/mem-loads, sys/devices/cpu/events/mem-stores.
>>
>> Given your latest rounds of sysfs event changes, I had to modify my kernel
>> patches to fit those two new events within your perf_pmu_events_attr tables.
>>
>> But now, when I try to do:
>>
>> $ perf record -e cpu/mem-loads/ ....
>
> - is not supported in an event name. I fixed this in my patchkit
>
Yes, this was indeed the problem. Glad you tracked it down.

We need this patch ASAP.

> Yes the sysfs stuff in general is quite fragile.
>
I would say complicated rather than fragile.
