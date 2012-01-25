Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2AYTvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:51:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57988 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751089Ab2AYTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:51:18 -0500
Message-ID: <4F205D1D.1020304@fb.com>
Date: Wed, 25 Jan 2012 11:50:53 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
References: <1327026020-32376-1-git-send-email-asharma@fb.com> <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com> <1327352631.2446.22.camel@twins> <4F1DE6FE.4000603@fb.com> <1327415255.2614.33.camel@laptop> <4F1F26CC.4040109@fb.com> <20120125092008.GB20878@somewhere>
In-Reply-To: <20120125092008.GB20878@somewhere>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-25_08:2012-01-25,2012-01-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/12 1:20 AM, Frederic Weisbecker wrote:

>>> I'm tempted to revert 1ac9bc69 for now, userspace will simply have to
>>> correlate trace_sched_switch() and trace_sched_stat_{sleep,blocked}(),
>>> which shouldn't be too hard.
>>
>> We tried it and it didn't work very well. Especially when used with
>> perf record -g. There are too many uninteresting
>> trace_sched_switch() events.
>
> You mean context switches happening when the prev task doesn't need
> to block or so? As it happens with preemption for example?
>
> In this case you can use filters to drop context switches for
> which the prev state is not S or D.

We had these filters and still couldn't keep up:

# perf record -agP -e sched:sched_switch --filter "prev_state == 1 || 
prev_state == 2" -e  sched:sched_stat_sleep -- sleep 3
[ perf record: Woken up 107 times to write data ]
[ perf record: Captured and wrote 32.629 MB perf.data (~1425585 samples) ]
Warning:
Processed 104066 events and lost 4 chunks!

Check IO/CPU overload!

  -Arun
