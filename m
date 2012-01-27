Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2A0SVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:21:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59645 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752203Ab2A0SVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:21:10 -0500
Message-ID: <4F22EAFD.1020006@fb.com>
Date: Fri, 27 Jan 2012 10:20:45 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <mingo@elte.hu>, <acme@infradead.org>, <robert.richter@amd.com>,
        <ming.m.lin@intel.com>, <andi@firstfloor.org>, <ravitillo@lbl.gov>,
        <vweaver1@eecs.utk.edu>
Subject: Re: [PATCH 00/13] perf_events: add support for sampling taken branches
 (v3)
References: <1326127761-2723-1-git-send-email-eranian@google.com> <1327666141.2446.168.camel@twins>
In-Reply-To: <1327666141.2446.168.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-27_06:2012-01-27,2012-01-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/12 4:09 AM, Peter Zijlstra wrote:
>> Here is a kernel example, where we want to sample indirect calls:
>> $ perf record -a -C 1 -b ind_call -e r1c4:k sleep 10
>> $ perf report -b
>> #
>> # Overhead  Source Symbol               Target Symbol
>> # ........  ..........................  ..........................
>> #
>>      36.36%  [k] __delay                 [k] delay_tsc
>>       9.09%  [k] ktime_get               [k] read_tsc
>>       9.09%  [k] getnstimeofday          [k] read_tsc
>>       9.09%  [k] notifier_call_chain     [k] tick_notify
>>       4.55%  [k] cpuidle_idle_call       [k] intel_idle
>>       4.55%  [k] cpuidle_idle_call       [k] menu_reflect
>>       2.27%  [k] handle_irq              [k] handle_edge_irq
>>       2.27%  [k] ack_apic_edge           [k] native_apic_mem_write
>>       2.27%  [k] hpet_interrupt_handler  [k] hrtimer_interrupt
>>       2.27%  [k] __run_hrtimer           [k] watchdog_timer_fn
>>       2.27%  [k] enqueue_task            [k] enqueue_task_rt
>>       2.27%  [k] try_to_wake_up          [k] select_task_rq_rt
>>       2.27%  [k] do_timer                [k] read_tsc
>>
>> Due to HW limitations, branch filtering may be approximate on
>> Core, Atom processors. It is more accurate on Nehalem, Westmere
>> and best on Sandy Bridge.
>
> Can I have you ACK on this userspace stuff (patches 11-13)?

While the current "Source -> Target" based UI works well for many cases, 
it'd be nice to have "-g -b any_call" to result in a callgraph like 
output, so for userspace programs compiled without frame pointers, we 
get a limited callgraph.

  -Arun
