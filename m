Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab2IFBcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:32:15 -0400
Received: from mail1.windriver.com ([147.11.146.13]:33809 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2IFBcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:32:13 -0400
Message-ID: <5047FCBD.9000205@windriver.com>
Date: Thu, 6 Sep 2012 09:30:37 +0800
From: wyang1 <Wei.Yang@windriver.com>
Reply-To: <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 1/1] x86/oprofile: Fix the calltrace upon profiling some
 specified events with oprofile
References: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com> <20120904102439.GS8285@erda.amd.com>
In-Reply-To: <20120904102439.GS8285@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.190]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 06:24 PM, Robert Richter wrote:
> Wei,
>
> see my comments below.
>
> On 27.08.12 09:32:13, Wei.Yang@windriver.com wrote:
>> From: Wei Yang<Wei.Yang@windriver.com>
>>
>> Upon enabling the call-graph functionality of oprofile, A few minutes
>> later the following calltrace will always occur.
>>
>> BUG: unable to handle kernel paging request at 656d6153
>> IP: [<c10050f5>] print_context_stack+0x55/0x110
>> *pde = 00000000
>> Oops: 0000 [#1] PREEMPT SMP
>> Modules linked in:
>> Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc3-WR5.0+snapshot-20120820_standard
>> EIP: 0060:[<c10050f5>] EFLAGS: 00010093 CPU: 0
>> EIP is at print_context_stack+0x55/0x110
>> EAX: 656d7ffc EBX: 656d6153 ECX: c1837ee0 EDX: 656d6153
>> ESI: 00000000 EDI: ffffe000 EBP: f600deac ESP: f600de88
>> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> CR0: 8005003b CR2: 656d6153 CR3: 01934000 CR4: 000007d0
>> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> DR6: ffff0ff0 DR7: 00000400
>> Process swapper/0 (pid: 0, ti=f600c000 task=c18411a0 task.ti=c1836000)
>> Stack:
>> 1a7f76ea 656d7ffc 656d6000 c1837ee0 ffffe000 c1837ee0 656d6153 c188e27c
>> 656d6000 f600dedc c10040f8 c188e27c f600def0 00000000 f600dec8 c1837ee0
>> 00000000 f600ded4 c1837ee0 f600dfc4 0000001f f600df08 c1564d22 00000000
>> Call Trace:
>> [<c10040f8>] dump_trace+0x68/0xf0
>> [<c1564d22>] x86_backtrace+0xb2/0xc0
>> [<c1562dd2>] oprofile_add_sample+0xa2/0xc0
>> [<c1003fbf>] ? do_softirq+0x6f/0xa0
>> [<c1566519>] ppro_check_ctrs+0x79/0x100
>> [<c15664a0>] ? ppro_shutdown+0x60/0x60
>> [<c156552f>] profile_exceptions_notify+0x8f/0xb0
>> [<c1672248>] nmi_handle.isra.0+0x48/0x70
>> [<c1672343>] do_nmi+0xd3/0x3c0
>> [<c1033d39>] ? __local_bh_enable+0x29/0x70
>> [<c1034620>] ? ftrace_define_fields_irq_handler_entry+0x80/0x80
>> [<c1671a0d>] nmi_stack_correct+0x28/0x2d
>> [<c1034620>] ? ftrace_define_fields_irq_handler_entry+0x80/0x80
>> [<c1003fbf>] ? do_softirq+0x6f/0xa0
>> <IRQ>
>> [<c1034ad5>] irq_exit+0x65/0x70
>> [<c16776f9>] smp_apic_timer_interrupt+0x59/0x89
>> [<c16717da>] apic_timer_interrupt+0x2a/0x30
>> [<c135164d>] ? acpi_idle_enter_bm+0x245/0x273
>> [<c14f3a25>] cpuidle_enter+0x15/0x20
>> [<c14f4070>] cpuidle_idle_call+0xa0/0x320
>> [<c1009705>] cpu_idle+0x55/0xb0
>> [<c16519a8>] rest_init+0x6c/0x74
>> [<c18a291b>] start_kernel+0x2ec/0x2f3
>> [<c18a2467>] ? repair_env_string+0x51/0x51
>> [<c18a22a2>] i386_start_kernel+0x78/0x7d
>> Code: e0 ff ff 89 7d ec 74 5a 8d b4 26 00 00 00 00 8d bc 27 00 00
>> 00 00 39 f3 72 0c 8b 45 f0 8d 64 24 18 5b 5e 5f 5d c3 3b 5d ec 72
>> ef<8b>  3b 89 f8 89 7d dc e8 ef 40 04 00 85 c0 74 20 8b 40
>> EIP: [<c10050f5>] print_context_stack+0x55/0x110 SS:ESP 0068:f600de88
>> CR2: 00000000656d6153
>> ---[ end trace 751c9b47c6ff5e29 ]---
>>
>> Let's assume a scenario that do_softirq() switches the stack to a soft irq
>> stack, and the soft irq stack is totally empty. At this moment, a nmi interrupt
>> occurs, subsequently, CPU does not automatically save SS and SP registers
>> and switch any stack, but instead only stores EFLAGS, CS and IP to the soft irq
>> stack. since the CPU is in kernel mode when the NMI exception occurs.
>> the layout of the current soft irq stack is this:
>>
>>    +--------------+<-----the top of soft irq
>>    |   EFLAGS     |
>>    +--------------+
>>    |    CS        |
>>    +--------------+
>>    |    IP        |
>>    +--------------+
>>    |   SAVE_ALL   |
>>    +--------------+
>>
>> but the return value of the function kernel_stack_pointer() is'&regs->sp'
>> (for x86_32 CPU), which is invoked by the x86_backtrace function. Since
>> the type of regs pointer is a pt_regs structure, the return value is not
>> in the range of the soft irq stack, as the SP register is not save in the
>> soft irq stack. Therefore, we need to check if the return value of the function
>> resides in valid range. Additionally, the changes has no impact on the normal
>> NMI exception.
>>
>> Signed-off-by: Yang Wei<wei.yang@windriver.com>
>> ---
>>   arch/x86/oprofile/backtrace.c |   10 ++++++++++
>>   1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
>> index d6aa6e8..a5fca0b 100644
>> --- a/arch/x86/oprofile/backtrace.c
>> +++ b/arch/x86/oprofile/backtrace.c
>> @@ -17,6 +17,11 @@
>>   #include<asm/ptrace.h>
>>   #include<asm/stacktrace.h>
>>
>> +static inline int valid_stack_ptr(struct thread_info *tinfo, void *p)
>> +{
>> +	void *t = tinfo;
>> +	return p>  t + sizeof(struct thread_info)&&  p<  t + THREAD_SIZE;
>> +}
>>   static int backtrace_stack(void *data, char *name)
>>   {
>>   	/* Yes, we want all stacks */
>> @@ -110,9 +115,14 @@ void
>>   x86_backtrace(struct pt_regs * const regs, unsigned int depth)
>>   {
>>   	struct stack_frame *head = (struct stack_frame *)frame_pointer(regs);
>> +	struct thread_info *context;
>>
>>   	if (!user_mode_vm(regs)) {
>>   		unsigned long stack = kernel_stack_pointer(regs);
>> +		context = (struct thread_info *)
>> +			(stack&  (~(THREAD_SIZE - 1)));
> You derive the context from a potential wrong stack here.
>
>> +		if (!valid_stack_ptr(context, (void *)stack))
> Thus, you basically test this:
>
> 	if (t&  (THREAD_SIZE - 1)<  sizeof(struct thread_info))
> 		...
>
>> +			return;
>>   		if (depth)
>>   			dump_trace(NULL, regs, (unsigned long *)stack, 0,
>>   				&backtrace_ops,&depth);
>> -- 
>> 1.7.0.2
>>
>>
> Though this patch prevents access to an invalid stack (NULL pointer
> access or page fault), I don't think this is the proper fix since it
> does not fix the root cause that is an invalid stack pointer deliverd
> by kernel_stack_pointer(). Also, a fix only in oprofile code does not
> solve other uses of dump_trace()/kernel_stack_pointer().
Robert,

I agreed what you said, my patch more likes a workaround.

> So the proper fix I see is to fix kernel_stack_pointer() to return a
> valid stack in case of an empty stack while in softirq. Something like
> the patch below. Maybe it must be optimized a bit. I tested the patch
> over night with no issues found. Please test it too.

I also tested the following patch over night. it is fine.:-)

Thanks
Wei
> Thanks,
>
> -Robert
>
>
> > From 8e7c16913b1fcfc63f7b24337551aacc7153c334 Mon Sep 17 00:00:00 2001
> From: Robert Richter<robert.richter@amd.com>
> Date: Mon, 3 Sep 2012 20:54:48 +0200
> Subject: [PATCH] x86, 32-bit: Fix invalid stack address while in softirq
>
> In 32 bit the stack address provided by kernel_stack_pointer() may
> point to an invalid range causing NULL pointer access or page faults
> while in NMI (see trace below). This happens if called in softirq
> context and if the stack is empty. The address at&regs->sp is then
> out of range.
>
> Fixing this by checking if regs and&regs->sp are in the same stack
> context. Otherwise return the previous stack pointer stored in struct
> thread_info.
>
>   BUG: unable to handle kernel NULL pointer dereference at 0000000a
>   IP: [<c1004237>] print_context_stack+0x6e/0x8d
>   *pde = 00000000
>   Oops: 0000 [#1] SMP
>   Modules linked in:
>   Pid: 4434, comm: perl Not tainted 3.6.0-rc3-oprofile-i386-standard-g4411a05 #4 Hewlett-Packard HP xw9400 Workstation/0A1Ch
>   EIP: 0060:[<c1004237>] EFLAGS: 00010093 CPU: 0
>   EIP is at print_context_stack+0x6e/0x8d
>   EAX: ffffe000 EBX: 0000000a ECX: f4435f94 EDX: 0000000a
>   ESI: f4435f94 EDI: f4435f94 EBP: f5409ec0 ESP: f5409ea0
>    DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>   CR0: 8005003b CR2: 0000000a CR3: 34ac9000 CR4: 000007d0
>   DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>   DR6: ffff0ff0 DR7: 00000400
>   Process perl (pid: 4434, ti=f5408000 task=f5637850 task.ti=f4434000)
>   Stack:
>    000003e8 ffffe000 00001ffc f4e39b00 00000000 0000000a f4435f94 c155198c
>    f5409ef0 c1003723 c155198c f5409f04 00000000 f5409edc 00000000 00000000
>    f5409ee8 f4435f94 f5409fc4 00000001 f5409f1c c12dce1c 00000000 c155198c
>   Call Trace:
>    [<c1003723>] dump_trace+0x7b/0xa1
>    [<c12dce1c>] x86_backtrace+0x40/0x88
>    [<c12db712>] ? oprofile_add_sample+0x56/0x84
>    [<c12db731>] oprofile_add_sample+0x75/0x84
>    [<c12ddb5b>] op_amd_check_ctrs+0x46/0x260
>    [<c12dd40d>] profile_exceptions_notify+0x23/0x4c
>    [<c1395034>] nmi_handle+0x31/0x4a
>    [<c1029dc5>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
>    [<c13950ed>] do_nmi+0xa0/0x2ff
>    [<c1029dc5>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
>    [<c13949e5>] nmi_stack_correct+0x28/0x2d
>    [<c1029dc5>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
>    [<c1003603>] ? do_softirq+0x4b/0x7f
>    <IRQ>
>    [<c102a06f>] irq_exit+0x35/0x5b
>    [<c1018f56>] smp_apic_timer_interrupt+0x6c/0x7a
>    [<c1394746>] apic_timer_interrupt+0x2a/0x30
>   Code: 89 fe eb 08 31 c9 8b 45 0c ff 55 ec 83 c3 04 83 7d 10 00 74 0c 3b 5d 10 73 26 3b 5d e4 73 0c eb 1f 3b 5d f0 76 1a 3b 5d e8 73 15<8b>  13 89 d0 89 55 e0 e8 ad 42 03 00 85 c0 8b 55 e0 75 a6 eb cc
>   EIP: [<c1004237>] print_context_stack+0x6e/0x8d SS:ESP 0068:f5409ea0
>   CR2: 000000000000000a
>   ---[ end trace 62afee3481b00012 ]---
>   Kernel panic - not syncing: Fatal exception in interrupt
>
> Reported-by: Yang Wei<wei.yang@windriver.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Robert Richter<robert.richter@amd.com>
> ---
>   arch/x86/include/asm/ptrace.h |   15 ++++-----------
>   arch/x86/kernel/ptrace.c      |   21 +++++++++++++++++++++
>   arch/x86/oprofile/backtrace.c |    2 +-
>   3 files changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
> index dcfde52..19f16eb 100644
> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -205,21 +205,14 @@ static inline bool user_64bit_mode(struct pt_regs *regs)
>   }
>   #endif
>
> -/*
> - * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
> - * when it traps.  The previous stack will be directly underneath the saved
> - * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
> - *
> - * This is valid only for kernel mode traps.
> - */
> -static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> -{
>   #ifdef CONFIG_X86_32
> -	return (unsigned long)(&regs->sp);
> +extern unsigned long kernel_stack_pointer(struct pt_regs *regs);
>   #else
> +static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> +{
>   	return regs->sp;
> -#endif
>   }
> +#endif
>
>   #define GET_IP(regs) ((regs)->ip)
>   #define GET_FP(regs) ((regs)->bp)
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index c4c6a5c..5a9a8c9 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -165,6 +165,27 @@ static inline bool invalid_selector(u16 value)
>
>   #define FLAG_MASK		FLAG_MASK_32
>
> +/*
> + * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
> + * when it traps.  The previous stack will be directly underneath the saved
> + * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
> + *
> + * This is valid only for kernel mode traps.
> + */
> +unsigned long kernel_stack_pointer(struct pt_regs *regs)
> +{
> +	unsigned long context = (unsigned long)regs&  ~(THREAD_SIZE - 1);
> +	unsigned long sp = (unsigned long)&regs->sp;
> +	struct thread_info *tinfo;
> +
> +	if (context == (sp&  ~(THREAD_SIZE - 1)))
> +		return sp;
> +
> +	tinfo = (struct thread_info *)context;
> +
> +	return tinfo->previous_esp;
> +}
> +
>   static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
>   {
>   	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
> diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
> index d6aa6e8..5b5741e 100644
> --- a/arch/x86/oprofile/backtrace.c
> +++ b/arch/x86/oprofile/backtrace.c
> @@ -113,7 +113,7 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
>
>   	if (!user_mode_vm(regs)) {
>   		unsigned long stack = kernel_stack_pointer(regs);
> -		if (depth)
> +		if (depth&  stack)
>   			dump_trace(NULL, regs, (unsigned long *)stack, 0,
>   				&backtrace_ops,&depth);
>   		return;

