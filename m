Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2FOHcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:32:24 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36824 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264Ab2FOHcX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120615072904.GA1767@m.brq.redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
	<1339706321-8802-2-git-send-email-jolsa@redhat.com>
	<1339708192.2559.40.camel@twins>
	<CABPqkBTjr2YiHYPT=32G-pqh6ca7BrtxcA8Nv-xFeG-eZrGtVA@mail.gmail.com>
	<20120615072904.GA1767@m.brq.redhat.com>
Date: Fri, 15 Jun 2012 09:32:20 +0200
Message-ID: <CABPqkBT4GPTp3k6Ko-t4Q5Kgz54O5yBZ7L+9M6Uc660rxTtrAA@mail.gmail.com>
Subject: Re: [PATCH 1/6] perf, x86: Making hardware events tranlations sysfs available
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 9:29 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Jun 14, 2012 at 11:36:51PM +0200, Stephane Eranian wrote:
>> On Thu, Jun 14, 2012 at 11:09 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Thu, 2012-06-14 at 22:38 +0200, Jiri Olsa wrote:
>> >> Making hardware events tranlations available throught the sysfs.
>> >> Adding 'events' group attribute under the sysfs x86 PMU record
>> >> with attribute/file for each hardware event:
>> >>
>> >>   # ls  /sys/devices/cpu/events/
>> >>   branch_instructions
>> >>   branch_misses
>> >>   bus_cycles
>> >>   cache_misses
>> >>   cache_references
>> >>   cycles
>> >>   instructions
>> >>   ref_cycles
>> >>   stalled_cycles_backend
>> >>   stalled_cycles_frontend
>> >>
>> >> The file - ID mappings is:
>> >>
>> >>   file                      hw id
>> >>   ----------------------------------------------------------------
>> >>   cycles                    PERF_COUNT_HW_CPU_CYCLES
>> >>   instructions              PERF_COUNT_HW_INSTRUCTIONS
>> >>   cache_references          PERF_COUNT_HW_CACHE_REFERENCES
>> >>   cache_misses              PERF_COUNT_HW_CACHE_MISSES
>> >>   branch_instructions       PERF_COUNT_HW_BRANCH_INSTRUCTIONS
>> >>   branch_misses             PERF_COUNT_HW_BRANCH_MISSES
>> >>   bus_cycles                PERF_COUNT_HW_BUS_CYCLES
>> >>   stalled_cycles_frontend   PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
>> >>   stalled_cycles_backend    PERF_COUNT_HW_STALLED_CYCLES_BACKEND
>> >>   ref_cycles                PERF_COUNT_HW_REF_CPU_CYCLES
>> >>
>> >> Each attribute/file contains HW ID event translation for the currently
>> >> running CPU model
>> >>
>> >>   # cat /sys/devices/cpu/events/instructions
>> >>   0xc0
>> >
>> > Why not have it consistent with the stuff done for uncore where events
>> > read: 'event=0xc0', ie the regular field=value stuff.
>> >
>> Yes, you want that. Because those events may need more than a code.
>> You want full syntax capability. So return a string.
>
> humm... right :)
>
> how about the term name 'event=...', could I always assume it's 'event',
> or do we want some arch specific connection for that?
>
You should not assume anything. You grab the string from sysfs and put it
through your regular parser. It could have arch specific terms in it. That's
how I suspect this is done for uncore.

> jirka
