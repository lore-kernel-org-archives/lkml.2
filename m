Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab1LOTJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:09:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56264 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751300Ab1LOTJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:09:16 -0500
Message-ID: <4EEA45C6.2020106@fb.com>
Date: Thu, 15 Dec 2011 11:08:54 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: <avagin@gmail.com>
CC: <avagin@openvz.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] trace: add ability to collect call chain of non-current
 task.
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org> <1317052535-1765247-4-git-send-email-avagin@openvz.org> <1317132351.15383.66.camel@twins> <20110927205548.GN18553@somewhere> <4EE01ACB.1000102@fb.com> <4EE1EC0B.4020600@openvz.org> <4EE903B1.7000600@fb.com> <4EEA101C.7060505@gmail.com>
In-Reply-To: <4EEA101C.7060505@gmail.com>
Content-Type: text/plain; charset="KOI8-R"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-15_05:2011-12-15,2011-12-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/15/11 7:19 AM, Andrew Vagin wrote:

>>> * It doesn't distinguish blocking time and sleeping time.
>>
>> Can't we distinguish based on next->state?
> It will be "Running". We can distinguish based on block_start of
> sleep_start

Sounds good.

>>
>>> * This patch does a bit mess between subsystems...
>>
>> Which subsystems?
> sched_switch belongs to scheduler.
> sched_stat belongs to sched_fair.
>

My reading of the code is that 'struct sched_statistics' is independent 
of the scheduling class. But only sched_fair.c is actually populating 
the stats. Other classes could populate those fields if they choose to.

> It works for me. You can find output of commands bellow.
>
> # ./perf record -e sched:sched_switch -agP

Thanks. I forgot to use the -P option you added on my cmdline.

I still need to investigate why per-process mode (command line without 
-a) doesn't work. Will send an updated patch once that's fixed.

  -Arun

