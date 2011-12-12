Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1LLXUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:20:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34999 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732Ab1LLXUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:20:34 -0500
Message-ID: <4EE68C31.1030207@fb.com>
Date: Mon, 12 Dec 2011 15:20:17 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
References: <1323718578-1157-1-git-send-email-asharma@fb.com>  <1323718578-1157-3-git-send-email-asharma@fb.com> <1323731361.4078.102.camel@work-vm>
In-Reply-To: <1323731361.4078.102.camel@work-vm>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-12_10:2011-12-12,2011-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 3:09 PM, john stultz wrote:
> On Mon, 2011-12-12 at 11:36 -0800, Arun Sharma wrote:
>> From: Kumar Sundararajan<kumar@fb.com>
>>
>> This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..)
>> via a new vsyscall. We also add a direct vsyscall that returns
>> time in ns (RFC: the direct vsyscall doesn't have a corresponding
>> regular syscall, although clock_gettime() is pretty close).
>
> I'm still not super psyched about providing a vdso-only API.
>
> If a nanosecond interface like thread_cpu_time() is actually a big win
> over clock_gettime(CLOCK_THREAD_CPUTIME,...) it seems it should have its
> own syscall as well, no?

The win is relatively small when we're dealing with syscalls. But with 
vsyscalls, it starts showing up in micro benchmarks.

Happy to post patches for regular syscalls (assuming I can get them 
allocated :).

>
> Possibly something like clock_gettime_ns(), which would return the same
> values as clock_gettime() but in nanoseconds rather then a timespec?
>

If we're doing non-POSIXy things there, how about allocating one syscall 
per clock instead of multiplexing them through a single syscall?

This would be a nice to have (clock_gettime_ns() should get us most of 
the perf benefit).

-Arun
