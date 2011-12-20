Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1LTSW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:22:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55678 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751782Ab1LTSWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:22:53 -0500
Message-ID: <4EF0D262.5000405@fb.com>
Date: Tue, 20 Dec 2011 10:22:26 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing, sched: Add a new tracepoint for sleeptime
References: <1324404558-353-1-git-send-email-asharma@fb.com>  <1324404558-353-3-git-send-email-asharma@fb.com> <1324404995.5916.66.camel@gandalf.stny.rr.com>
In-Reply-To: <1324404995.5916.66.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-20_07:2011-12-20,2011-12-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/11 10:16 AM, Steven Rostedt wrote:

>> +#ifdef CREATE_TRACE_POINTS
>
> Why the #ifdef? a static inline is fine to keep in the open. If nothing
> uses it, then it just wont be used or defined.
>

Without the ifdef I get:

In file included from include/trace/define_trace.h:80,
                  from include/trace/events/sched.h:445,
                  from kernel/sched/core.c:86:
include/trace/events/sched.h:366: error: redefinition of 
‘trace_get_sleeptime’
include/trace/events/sched.h:366: note: previous definition of 
‘trace_get_sleeptime’ was here

So I shamelessly copied what the other static inline function in the 
file does.

I also noticed that sched_stat_sleeptime() is very similar to 
sched_stat_sleep(). The latter covers sleeps but not iowait and doesn't 
include the scheduler latency. Let me know if you think this is a show 
stopper that needs a rename.

  -Arun
