Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab2HHHYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:24:36 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65307 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2HHHYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <878vdqympe.fsf@sejong.aot.lge.com>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
	<87mx26z0it.fsf@sejong.aot.lge.com>
	<CANaxB-xAWtj8nU0WiE0aV_WHde_iX=rseU9NwwN=VTHOZYW=JQ@mail.gmail.com>
	<878vdqympe.fsf@sejong.aot.lge.com>
Date: Wed, 8 Aug 2012 11:24:34 +0400
Message-ID: <CANaxB-zZp0How3+WUC2BMsRMWBgf1CVkaVQSYWcvCXTgyymSvg@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: Teach perf tool to profile sleep times (v2)
From: Andrey Wagin <avagin@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/8 Namhyung Kim <namhyung@kernel.org>:
> On Wed, 8 Aug 2012 09:02:18 +0400, Andrey Wagin wrote:
>> 2012/8/8 Namhyung Kim <namhyung@kernel.org>:
>>>>
>>>> $ ./perf record -e sched:sched_stat_sleep -e sched:sched_switch \
>>>>               -e sched:sched_process_exit -gP -o ~/perf.data.raw ~/foo
>>
>> Actually this string is not completed, because sched:sched_switch
>> should be filtered by state.
>>
>>>> [ perf record: Woken up 1 times to write data ]
>>>> [ perf record: Captured and wrote 0.015 MB /root/perf.data.raw (~661 samples) ]
>>>> $ ./perf inject -v -s -i ~/perf.data.raw -o ~/perf.data
>>>> $ ./perf report -i ~/perf.data
>>>
>>> The usage like this is too specific and hard to use IMHO. How about
>>> putting it somehow into perf sched or new command?
>>>
>>> /me don't have an idea though. :-)
>>>
>>
>> I'm going to add a script, so the usage will look like this:
>> $ perf script record sched-stat -e sched:sched_stat_sleep <command>
>> This command will collect sched_stat_* and proper sched_switch events
>
> ???  That means '-e sched:sched_stat_sleep' part can be removed from
> command line, no?

No. My method works for all kind of sched_stat_* events, so you need
to specify an event type which should be traced.
