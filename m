Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab2BJUIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:08:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34656 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752539Ab2BJUH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:07:59 -0500
Message-ID: <4F3578FE.7030904@fb.com>
Date: Fri, 10 Feb 2012 12:07:26 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>, <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
References: <1327026020-32376-1-git-send-email-asharma@fb.com>  <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com>  <1327352631.2446.22.camel@twins> <4F1DE6FE.4000603@fb.com>  <1327415255.2614.33.camel@laptop> <4F1F26CC.4040109@fb.com>  <20120125092008.GB20878@somewhere>  <4F205D1D.1020304@fb.com> <1328899383.25989.40.camel@laptop>
In-Reply-To: <1328899383.25989.40.camel@laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.260,0.0.0000
 definitions=2012-02-10_07:2012-02-10,2012-02-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/12 10:43 AM, Peter Zijlstra wrote:
> On Wed, 2012-01-25 at 11:50 -0800, Arun Sharma wrote:
>> # perf record -agP -e sched:sched_switch --filter "prev_state == 1 ||
>> prev_state == 2" -e  sched:sched_stat_sleep -- sleep 3
>
> Problem with that is it'll try and do a backtrace for all events, not
> only the sched_switch but also sched_stat_sleep, which is completely
> superfluous (and expensive).
>
> Currently perf tool doesn't support individual -g flags though and its
> slightly non-trivial to make it so. Easiest work-around would be two
> records and then merge the two files.

If we have a sequence of:

SL1, SW1, SL2, SW2, SL3, SW3

I think you're suggesting:

perf.data1: SL1, SL2, SL3 (without -g)
perf.data2: SW1, SW2, SW3 (with -g)

and then munge the data to create perf.data. But making sure that all 
matching sleep and switch events are captured seems hard.

  -Arun


