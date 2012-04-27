Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634Ab2D0PcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:32:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59873 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760416Ab2D0PcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:32:13 -0400
Message-ID: <4F9ABBF9.8080409@gmail.com>
Date: Fri, 27 Apr 2012 09:32:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com> <1335417327-11796-8-git-send-email-namhyung.kim@lge.com> <4F996433.7040003@gmail.com> <1335474778.1497.14.camel@leonhard> <4F99BCAF.1080309@gmail.com> <87397qhvvx.fsf@sejong.aot.lge.com> <20120427150821.GA27997@infradead.org>
In-Reply-To: <20120427150821.GA27997@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/12 9:08 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Apr 27, 2012 at 09:16:18AM +0900, Namhyung Kim escreveu:
>> Hi,
>>
>> On Thu, 26 Apr 2012 15:22:55 -0600, David Ahern wrote:
>>> On 4/26/12 3:12 PM, Namhyung Kim wrote:
>>>> Hmm.. No, I can reproduce it without any of this series. And now I think
>>>> that it is not related to the number of cpus. On my 4 core (no
>>>> hyperthreading) machine at home, the result was same.
>>>>
>>>> BTW, did you change sysctl settings?
>>>>
>>>>     $ cat /sys/devices/system/cpu/online
>>>>     0-3
>>>>     $ grep . /proc/sys/kernel/perf_event_*
>>>>     /proc/sys/kernel/perf_event_max_sample_rate:100000
>>>>     /proc/sys/kernel/perf_event_mlock_kb:516
>>>>     /proc/sys/kernel/perf_event_paranoid:1
>>>
>>> $ grep . /proc/sys/kernel/perf_event_*
>>> /proc/sys/kernel/perf_event_max_sample_rate:100000
>>> /proc/sys/kernel/perf_event_mlock_kb:516
>>> /proc/sys/kernel/perf_event_paranoid:-1
>>>
>>> That last one is the key. I have it set to not paranoid and usually
>>> run perf a non-root user.
>>>
>>
>> That's exactly what I want to see :). On perf_mmap() we have:
>>
>> 	if ((locked>  lock_limit)&&  perf_paranoid_tracepoint_raw()&&
>> 		!capable(CAP_IPC_LOCK)) {
>> 		ret = -EPERM;
>> 		goto unlock;
>> 	}
>>
>> So as long as you set perf_event_paranoid to -1 or run perf test as
>> root, you cannot see the failure.
>
> Ok, after this discussion, David, can I have your acked-by or tested-by?
>
> - Arnaldo

I had reviewed the whole series yesterday, so you can add my

Reviewed-by: David Ahern <dsahern@gmail.com>

to the whole series if you want. I did not pull down the set and apply 
to test it, and this particular patch requires prior ones so I have not 
tested it.

David
