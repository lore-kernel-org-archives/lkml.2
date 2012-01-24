Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2AXVsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:48:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39491 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751355Ab2AXVsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:48:16 -0500
Message-ID: <4F1F26CC.4040109@fb.com>
Date: Tue, 24 Jan 2012 13:46:52 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
References: <1327026020-32376-1-git-send-email-asharma@fb.com>  <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com>  <1327352631.2446.22.camel@twins>  <4F1DE6FE.4000603@fb.com> <1327415255.2614.33.camel@laptop>
In-Reply-To: <1327415255.2614.33.camel@laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-24_06:2012-01-24,2012-01-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/12 6:27 AM, Peter Zijlstra wrote:

> Bah, you're right. Also yes your proposal is too intrusive, but that can
> be fixed, I actually did, but then I noticed its broken too, it doesn't
> matter if the schedule that schedules a task back in preempted another
> task or not, what matters is if the task we're scheduling back in was
> itself preempted or recently woken. And we simply don't know.

Yes - we'd need an extra bit in the task_struct to do this right.

> I'm tempted to revert 1ac9bc69 for now, userspace will simply have to
> correlate trace_sched_switch() and trace_sched_stat_{sleep,blocked}(),
> which shouldn't be too hard.

We tried it and it didn't work very well. Especially when used with perf 
record -g. There are too many uninteresting trace_sched_switch() events.

Other possibilites: make a copy of {sleep,block}_start somewhere else in 
the perf_events subsystem in the sleep/wakeup path and leave 
sched_statistics untouched.

  -Arun


