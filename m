Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1LSXkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:40:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42286 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751415Ab1LSXkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:40:41 -0500
Message-ID: <4EEFCB57.8080203@fb.com>
Date: Mon, 19 Dec 2011 15:40:07 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing, sched: Add delay info to sched_switch
References: <1324337005-31718-1-git-send-email-asharma@fb.com>  <1324337005-31718-3-git-send-email-asharma@fb.com>  <1324337287.24621.22.camel@twins> <1324337685.5916.47.camel@gandalf.stny.rr.com>
In-Reply-To: <1324337685.5916.47.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-19_08:2011-12-19,2011-12-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/11 3:34 PM, Steven Rostedt wrote:
> On Tue, 2011-12-20 at 00:28 +0100, Peter Zijlstra wrote:
>> On Mon, 2011-12-19 at 15:23 -0800, Arun Sharma wrote:
>>> +#ifdef CONFIG_SCHEDSTATS
>>> +               __entry->delay          = next->se.statistics.block_start ? next->se.statistics.block_start
>>> +                                         : next->se.statistics.sleep_start ? next->se.statistics.sleep_start : 0;
>>> +               __entry->delay = __entry->delay ? now - __entry->delay : 0;
>>> +#else
>>> +               __entry->delay = 0;
>>> +#endif
>>
>> I don't really like this, this should be one of those sched_*_stat
>> thingies, not sched_switch().
>
> Agreed.

How does:

sched_stat_sleeptime(current, now);

at the same point sound? I'll leave sched_switch() as is.

  -Arun

