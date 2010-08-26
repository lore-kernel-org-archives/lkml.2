Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0HZMbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 08:31:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:39856 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0HZMba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 08:31:30 -0400
Message-ID: <4C765FD3.9060904@windriver.com>
Date: Thu, 26 Aug 2010 20:36:35 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, fweisbec@gmail.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix possible divide-by-zero in perf_swevent_overflow()
References: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com> <1282824727.1975.747.camel@laptop>
In-Reply-To: <1282824727.1975.747.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Aug 2010 12:31:06.0202 (UTC) FILETIME=[8DE173A0:01CB451A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2010-08-26 at 20:07 +0800, Dongdong Deng wrote:
>> The event->hw.last_period is possible to zero, thus it will
>> cause divide_by_zero later in perf_swevent_set_period().
> 
> How can it be zero?

When I am running the kgdbts to test the hw_breakpoint_layer with kgdb,
I get a call trace as following and this problem is hardly to reproduce.

Maybe the root cause was from kgdb/hw_breakpoint_layer,
but add a checking is good to us and harmless. :-)

Thanks,
Dongdong



------------[ cut here ]------------
WARNING: at /buildarea/ddeng/build/linux/drivers/misc/kgdbts.c:703 
run_simple_test+0x1fc/0x2a0()
Hardware name: Moon Creek platform
Modules linked in:
Pid: 668, comm: sh Tainted: G        W  2.6.36-rc1-00133-g47ade1d #43
Call Trace:
  [<c103b1fd>] warn_slowpath_common+0x6d/0xa0
  [<c124e15c>] ? run_simple_test+0x1fc/0x2a0
  [<c124e15c>] ? run_simple_test+0x1fc/0x2a0
  [<c103b245>] warn_slowpath_null+0x15/0x20
  [<c124e15c>] run_simple_test+0x1fc/0x2a0
  [<c124daf4>] kgdbts_put_char+0x14/0x20
  [<c107bab8>] gdb_serial_stub+0x678/0xbd0
  [<c101aced>] ? default_send_IPI_allbutself+0x7d/0x90
  [<c107a487>] kgdb_cpu_enter+0x197/0x470
  [<c107a8e7>] kgdb_handle_exception+0x47/0x140
  [<c13be9f0>] ? _raw_read_unlock+0x10/0x30
  [<c101eb48>] __kgdb_notify+0x38/0x170
  [<c130f1e0>] ? sock_queue_rcv_skb+0xe0/0x130
  [<c101ec8e>] kgdb_notify+0xe/0x20
  [<c105b815>] notifier_call_chain+0x35/0x70
  [<c1003910>] ? do_divide_error+0x0/0xa0
  [<c105bce8>] __atomic_notifier_call_chain+0x28/0x50
  [<c105bd2a>] atomic_notifier_call_chain+0x1a/0x20
  [<c105bd7d>] notify_die+0x2d/0x30
  [<c1003964>] do_divide_error+0x54/0xa0
  [<c11cf3d5>] ? div64_u64+0x55/0x80
  [<c1361c22>] ? udp_rcv+0x12/0x20
  [<c133e6e7>] ? ip_local_deliver_finish+0x127/0x240
  [<c1361c22>] ? udp_rcv+0x12/0x20
  [<c133e887>] ? ip_local_deliver+0x87/0x90
  [<c109bb8e>] ? perf_output_begin+0x1fe/0x230
  [<c133e0c3>] ? ip_rcv_finish+0xc3/0x320
  [<c13bf822>] error_code+0x66/0x6c
  [<c1003910>] ? do_divide_error+0x0/0xa0
  [<c11cf3d5>] ? div64_u64+0x55/0x80
  [<c1097cac>] perf_swevent_set_period+0x7c/0x100
  [<c109c797>] perf_swevent_overflow+0x87/0x90
  [<c109c85f>] perf_swevent_add+0xbf/0xd0
  [<c109c8ce>] perf_bp_event+0x5e/0x80
  [<c1289be7>] ? e1000_clean+0xf7/0x260
  [<c1008941>] hw_breakpoint_exceptions_notify+0x111/0x170
  [<c105b815>] notifier_call_chain+0x35/0x70
  [<c105bce8>] __atomic_notifier_call_chain+0x28/0x50
  [<c105bd2a>] atomic_notifier_call_chain+0x1a/0x20
  [<c105bd7d>] notify_die+0x2d/0x30
  [<c1004088>] do_debug+0x68/0x270
  [<c101a4d4>] ? smp_apic_timer_interrupt+0x74/0x140
  [<c13bf871>] debug_stack_correct+0x29/0x30
  [<c101007b>] ? hw_perf_event_init+0x1bb/0x820
  [<c124de60>] ? kgdbts_break_test+0x0/0x30
  [<c124e870>] ? configure_kgdbts+0x1d0/0x4c0
  [<c10544f0>] ? param_attr_store+0x0/0x20
  [<c124ebad>] param_set_kgdbts_var+0x4d/0xb0
  [<c124eb60>] ? param_set_kgdbts_var+0x0/0xb0
  [<c1054507>] param_attr_store+0x17/0x20
  [<c105458c>] module_attr_store+0x2c/0x40
  [<c111fe54>] sysfs_write_file+0x94/0xf0
  [<c10d42c6>] vfs_write+0x96/0x130
  [<c111fdc0>] ? sysfs_write_file+0x0/0xf0
  [<c10d44a6>] sys_write+0x46/0xd0
  [<c13bf209>] system_call_done+0x0/0x4
---[ end trace e0a820ecc2c65c24 ]---


> 
>> This patch checks event->hw.last_period before invoke
>> perf_swevent_set_period() and replaces "event->hw" with "hwc".
>>
>> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Paul Mackerras <paulus@samba.org>
>> ---
>>  kernel/perf_event.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> index 403d180..ccba741 100644
>> --- a/kernel/perf_event.c
>> +++ b/kernel/perf_event.c
>> @@ -4050,8 +4050,8 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
>>  	struct hw_perf_event *hwc = &event->hw;
>>  	int throttle = 0;
>>  
>> -	data->period = event->hw.last_period;
>> -	if (!overflow)
>> +	data->period = hwc->last_period;
>> +	if (!overflow && hwc->last_period)
>>  		overflow = perf_swevent_set_period(event);
>>  
>>  	if (hwc->interrupts == MAX_INTERRUPTS)
> 
> 
> 

