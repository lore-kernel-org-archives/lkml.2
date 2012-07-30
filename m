Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2G3JN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:13:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45058 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab2G3JNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:13:12 -0400
Message-ID: <50165046.9020705@gmail.com>
Date: Mon, 30 Jul 2012 11:13:42 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com> <50112D3B.4020201@redhat.com> <50127B16.5040401@gmail.com> <50153138.4020304@redhat.com> <5015A5A8.7030601@gmail.com> <50161D5E.4030009@redhat.com>
In-Reply-To: <50161D5E.4030009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 07:36 AM, Avi Kivity wrote:
> On 07/30/2012 12:05 AM, Sasha Levin wrote:
>> On 07/29/2012 02:48 PM, Avi Kivity wrote:
>>> On 07/27/2012 02:27 PM, Sasha Levin wrote:
>>>> On 07/26/2012 01:42 PM, Avi Kivity wrote:
>>>>> On 07/24/2012 08:10 PM, Sasha Levin wrote:
>>>>>> [  215.026612] NMI backtrace for cpu 1
>>>>>> [  215.026612] CPU 1
>>>>>> [  215.026612] Pid: 2395, comm: pageattr-test Tainted: G        W    3.5.0-sasha-01644-g824681b #267
>>>>>> [  215.026612] RIP: 0010:[<ffffffff8109bd5a>]  [<ffffffff8109bd5a>] native_write_msr_safe+0xa/0x10
>>>>>> [  215.026612] RSP: 0018:ffff88001b803f70  EFLAGS: 00000046
>>>>>> [  215.026612] RAX: 0000000000000000 RBX: 000000000000ef80 RCX: 000000000000080b
>>>>>> [  215.026612] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000000080b
>>>>>> [  215.026612] RBP: ffff88001b803f70 R08: 00003ffffffff000 R09: ffff880000000000
>>>>>> [  215.026612] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
>>>>>> [  215.026612] R13: ffff880007a98000 R14: ffff88001fc3a4b8 R15: ffff880000000000
>>>>>> [  215.026612] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
>>>>>> [  215.026612] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>>>> [  215.026612] CR2: 000000000000000c CR3: 0000000019dcf000 CR4: 00000000000406e0
>>>>>> [  215.026612] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>>> [  215.026612] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>>>> [  215.026612] Process pageattr-test (pid: 2395, threadinfo ffff88000ced0000, task ffff88000d773000)
>>>>>> [  215.026612] Stack:
>>>>>> [  215.026612]  ffff88001b803f88 ffffffff81095d07 000000000000ef80 ffff88001b803fa8
>>>>>> [  215.026612]  ffffffff810901c4 ffff88000ced1db0 0000000000007a98 ffff88000ced1d00
>>>>>> [  215.026612]  ffffffff8369c4af ffff88000ced1c78 <EOI>  ffff88000ced1d00 ffffffff8369aeb4
>>>>>> [  215.026612] Call Trace:
>>>>>> [  215.026612]  <IRQ>
>>>>>> [  215.026612]  [<ffffffff81095d07>] native_apic_msr_eoi_write+0x27/0x30
>>>>>> [  215.026612]  [<ffffffff810901c4>] smp_apic_timer_interrupt+0x34/0xa0
>>>>>> [  215.026612]  [<ffffffff8369c4af>] apic_timer_interrupt+0x6f/0x80
>>>>>> [  215.026612]  <EOI>
>>>>>> [  215.026612]  [<ffffffff8369aeb4>] ? retint_restore_args+0x13/0x13
>>>>>> [  215.026612]  [<ffffffff810a2cb2>] ? lookup_address+0x112/0x170
>>>>>> [  215.026612]  [<ffffffff810a32ae>] print_split+0x7e/0x200
>>>>>> [  215.026612]  [<ffffffff810a4300>] pageattr_test+0x80/0x4a0
>>>>>> [  215.026612]  [<ffffffff8114a2f8>] ? trace_hardirqs_on_caller+0x118/0x140
>>>>>> [  215.026612]  [<ffffffff83696cbe>] ? schedule_timeout+0x2ce/0x370
>>>>>> [  215.026612]  [<ffffffff8369aeb4>] ? retint_restore_args+0x13/0x13
>>>>>> [  215.026612]  [<ffffffff810a4720>] ? pageattr_test+0x4a0/0x4a0
>>>>>> [  215.026612]  [<ffffffff810a473f>] do_pageattr_test+0x1f/0x50
>>>>>> [  215.026612]  [<ffffffff8110607d>] kthread+0xad/0xc0
>>>>>> [  215.026612]  [<ffffffff8369cdb4>] kernel_thread_helper+0x4/0x10
>>>>>> [  215.026612]  [<ffffffff8369aeb4>] ? retint_restore_args+0x13/0x13
>>>>>> [  215.026612]  [<ffffffff81105fd0>] ? kthread_flush_work_fn+0x10/0x10
>>>>>> [  215.026612]  [<ffffffff8369cdb0>] ? gs_change+0x13/0x13
>>>>>> [  215.026612] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 48 89 d0 44 89 06 48 c1 e0 20 89 f9 5d 48 09 c8 c3 66 90 55 89 f0 89 f9 48 89 e5 0f 30 <31> c0 5d c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 48 89 d0 5d 48
>>>>>
>>>>> This is immediately after the EOI.  It looks like the timer interrupt is
>>>>> stuck somehow.  Can you run kvm_stat and confirm?
>>>>
>>>> Yup, looks like it. kvm_stats is something like this:
>>>>
>>>>  kvm_entry                                142104033  939393
>>>>  kvm_exit                                 142104004  939390
>>>>  kvm_apic                                  84781115  582714
>>>>  kvm_msr                                   84682085  582714
>>>>  kvm_apic_accept_irq                       65219959  522263
>>>>  kvm_inj_virq                              43173709  291385
>>>>
>>>> With everything else at 0 when it happens.
>>>
>>> Please run a trace and verify that the injected vector is indeed the
>>> timer interrupt.
>>
>> Looks like it is.
>>
>>> Then work backwards to see the last place it is
>>> programmed (APIC_TMICT/APIC_TDCR).
>>
>> This looks like what you're looking for:
>>
>> kvm_apic: apic_write APIC_TMICT = 0x3e
>>
>>
>> Basically it's spinning on the following 4 lines of trace when it happens:
>>
>> 	16063.549189: kvm_apic: apic_write APIC_TMICT = 0x3e
>> 	16063.549190: kvm_msr: msr_write 838 = 0x3e
>> 	16063.549190: kvm_exit: reason EXTERNAL_INTERRUPT rip 0xffffffff8115de02 info 0 0
>> 	16063.549190: kvm_entry: vcpu 2
>>
> 
> What, no kvm_inj_virq?
> 
> Are you running with pveoi?  Try disabling it.

I must have looked at a block in the logfile which doesn't represent everything thats going on, sorry.

Here's a more complete picture:

	vm-16567 [000] d..2 16063.549298: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff83625c80 info 0 0
	vm-16567 [000] ...1 16063.549299: kvm_inj_virq: irq 239
	vm-16567 [000] d..2 16063.549300: kvm_entry: vcpu 0
	vm-16567 [000] d..2 16063.549301: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
	vm-16567 [000] ...1 16063.549302: kvm_apic: apic_write APIC_EOI = 0x0
	vm-16567 [000] ...1 16063.549302: kvm_msr: msr_write 80b = 0x0
	vm-16567 [000] d..2 16063.549303: kvm_entry: vcpu 0
	vm-16567 [000] d..2 16063.549308: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
	vm-16567 [000] ...1 16063.549309: kvm_apic: apic_write APIC_TMICT = 0x3e
	vm-16567 [000] ...1 16063.549310: kvm_msr: msr_write 838 = 0x3e
	vm-16567 [000] d..2 16063.549311: kvm_entry: vcpu 0
	vm-16567 [000] d..2 16063.549312: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff83625c80 info 0 0
	vm-16567 [000] ...1 16063.549314: kvm_apic_accept_irq: apicid 0 vec 239 (Fixed|edge)
	vm-16567 [000] ...1 16063.549315: kvm_inj_virq: irq 239
	vm-16567 [000] d..2 16063.549315: kvm_entry: vcpu 0
	vm-16567 [000] d..2 16063.549316: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
	vm-16567 [000] ...1 16063.549318: kvm_apic: apic_write APIC_EOI = 0x0
	vm-16567 [000] ...1 16063.549318: kvm_msr: msr_write 80b = 0x0


