Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2AZTOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:14:06 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54298 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752632Ab2AZTOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:14:02 -0500
Message-ID: <4F21A5E6.9030305@fb.com>
Date: Thu, 26 Jan 2012 11:13:42 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
References: <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com> <1327352631.2446.22.camel@twins> <4F1DE6FE.4000603@fb.com> <1327415255.2614.33.camel@laptop> <4F1F26CC.4040109@fb.com> <20120125092008.GB20878@somewhere> <4F205D1D.1020304@fb.com> <1327522558.22710.47.camel@gandalf.stny.rr.com> <4F20823A.6010808@fb.com> <20120126022732.GH20878@somewhere>
In-Reply-To: <20120126022732.GH20878@somewhere>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-26_07:2012-01-26,2012-01-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/12 6:27 PM, Frederic Weisbecker wrote:

>> Even if we resolve the sampling rate related problems, there is the
>> issue of: can we trust that a sampled sched_switch event and a
>> sampled sched_stat_sleep event actually match each other?
>
> Well, a sched_stat_sleep event should match the sched_switch with
> prev as the last targeted task.
>
> Or am I missing something?

I was thinking about large systems with 100k+ sched_switch events, where 
the user wants to just sample 1k events/sec.

perf record -F 1000 -e sched:sched_switch -a -- sleep 1

Doesn't look like we're using sampling for tracepoint events? The rest 
of this makes sense only if we're sampling tracepoint events (eg: to 
limit the impact on the system being profiled/traced).

On a system with 50k sched_switch and 10k sched_stat_sleep events, if we 
sample at 1000 events/sec, we may lose an event of interest either due 
to finite buffer sizes or to sampling, which is why a single event based 
sleep profiling is of interest to us.

On 1/25/12 6:21 PM, Frederic Weisbecker wrote:
 >
 > Have you tried to tweak the -m options to increase the size of the 
buffer?

-m4:

Processed 276875 events and lost 4772 chunks!

Check IO/CPU overload!

-m5:

   Fatal: failed to mmap with 22 (Invalid argument)

  -Arun
