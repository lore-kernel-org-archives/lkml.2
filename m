Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab2F0Myy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:54:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab2F0Myw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:54:52 -0400
Message-ID: <4FEB0288.5080106@redhat.com>
Date: Wed, 27 Jun 2012 15:54:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Use __print_hex() for kvm_emulate_insn tracepoint
References: <1340757701-10711-1-git-send-email-namhyung@kernel.org>  <1340757701-10711-2-git-send-email-namhyung@kernel.org> <1340801375.16702.10.camel@gandalf.stny.rr.com>
In-Reply-To: <1340801375.16702.10.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 03:49 PM, Steven Rostedt wrote:
> [ Added Avi]
> 
> On Wed, 2012-06-27 at 09:41 +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The kvm_emulate_insn tracepoint used __print_insn()
>> for printing its instructions. However it makes the
>> format of the event hard to parse as it reveals TP
>> internals.
>> 
>> Fortunately, kernel provides __print_hex for almost
>> same purpose, we can use it instead of open coding
>> it. The user-space can be changed to parse it later.
>> 
>> That means raw kernel tracing will not be affected
>> by this change:
>> 
>>  # cd /sys/kernel/debug/tracing/
>>  # cat events/kvm/kvm_emulate_insn/format
>>  name: kvm_emulate_insn
>>  ID: 29
>>  format:
>> 	...
>>  print fmt: "%x:%llx:%s (%s)%s", REC->csbase, REC->rip, __print_hex(REC->insn, REC->len), \
>>  __print_symbolic(REC->flags, { 0, "real" }, { (1 << 0) | (1 << 1), "vm16" }, \
>>  { (1 << 0), "prot16" }, { (1 << 0) | (1 << 2), "prot32" }, { (1 << 0) | (1 << 3), "prot64" }), \
>>  REC->failed ? " failed" : ""
>> 
>>  # echo 1 > events/kvm/kvm_emulate_insn/enable
>>  # cat trace
>>  # tracer: nop
>>  #
>>  # entries-in-buffer/entries-written: 2183/2183   #P:12
>>  #
>>  #                              _-----=> irqs-off
>>  #                             / _----=> need-resched
>>  #                            | / _---=> hardirq/softirq
>>  #                            || / _--=> preempt-depth
>>  #                            ||| /     delay
>>  #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>>  #              | |       |   ||||       |         |
>>          qemu-kvm-1782  [002] ...1   140.931636: kvm_emulate_insn: 0:c102fa25:89 10 (prot32)
>>          qemu-kvm-1781  [004] ...1   140.931637: kvm_emulate_insn: 0:c102fa25:89 10 (prot32)
> 
> Avi, can you give your Acked-by for this change?

Acked-by: Avi Kivity <avi@redhat.com>

Some time ago we discussed moving the trace-cmd plugins to /lib/modules,
which would make this trace display as "mov %edx,(%eax)" instead of "89
10", even for non-trace-cmd users.  Was there any movement on this?

-- 
error compiling committee.c: too many arguments to function


