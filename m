Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2HIFZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:25:24 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54717 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2HIFZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:25:23 -0400
X-AuditID: 9c930179-b7b65ae000006d01-61-502349c16102
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5 5/5] perf script: Add event_analyzing_sample.py as a sample for general event handling
References: <1344419875-21665-1-git-send-email-feng.tang@intel.com>
	<1344419875-21665-6-git-send-email-feng.tang@intel.com>
	<87ipcsyhqd.fsf@sejong.aot.lge.com> <20120809123007.6f3f0a8f@feng-i7>
Date: Thu, 09 Aug 2012 14:19:29 +0900
In-Reply-To: <20120809123007.6f3f0a8f@feng-i7> (Feng Tang's message of "Thu, 9
	Aug 2012 12:30:07 +0800")
Message-ID: <874nocy74u.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 9 Aug 2012 12:30:07 +0800, Feng Tang wrote:
> Hi Namhyung,
>
> Many thanks for your valuable comments, I'll fold the fixes into an
> incremental patch.
>
> On Thu, 9 Aug 2012 10:30:34 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> On Wed,  8 Aug 2012 17:57:55 +0800, Feng Tang wrote:
>> > Currently only trace point events are supported in perf/python script,
>> > the first 3 patches of this serie add the support for all types of
>> 
>
>> > +con = sqlite3.connect("/dev/shm/perf.db")
>> > +con.isolation_level = None
>> > +
>> > +def trace_begin():
>> > +	print "In trace_begin:\n"
>> 
>> It seems it's not aligned with other statements, and even not needed at
>> all. Does it work?
>
> trace_begin() is a must have for a python script, the <print "In trace_begin:\n">
> is automatically generated from "perf script -g", I guess its intension is
> to help developer debug their own patches. and same for the trace_end().
>
I meant the print statement not trace_begin function :)

Btw, by any chance do you plan to add support to callchains? I think
it's very nice to have.

Thanks,
Namhyung


>> > +def print_header(event_name, cpu, secs, nsecs, pid, comm):
>> > +	print "%-20s %5u %05u.%09u %8u %-20s " % \
>> > +	(event_name, cpu, secs, nsecs, pid, comm),
>> 
>> It seems this function was not called anywhere.
>
> It is auto-generated too, and you are right, it is not needed at all,
> will remove it.
>
> Thanks,
> Feng
