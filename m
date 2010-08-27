Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0H0HmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:42:14 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44881 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0H0HmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ane6OVHcRz6CQqOQAfmRbrdveXlsfPjpoTwj/tHpuDeQkVxlmXVeYN0o6uesUehPfS
         flXA9DKhu4aCRgWlnnW0dV96wzOepqgjJWnitvrLubUxBm/Xlv8MmHDg5Ra/M9PGfi+M
         PDR3Q4eFo5v1SfklP/dw3pWrQKP3vliViow+c=
MIME-Version: 1.0
In-Reply-To: <4C775675.4090700@snapgear.com>
References: <1282148854-17103-1-git-send-email-phdm@macqel.be>
	<4C775675.4090700@snapgear.com>
Date: Fri, 27 Aug 2010 09:42:10 +0200
X-Google-Sender-Auth: eI7GT3hUQIRpfOQ5h0nCuCLjTHc
Message-ID: <AANLkTi=c+brmSOjVQhhTngRFezfyrAooZRhcCg9kFw4m@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH] m68k{nommu} : Remove unused DEFINE's from asm-offsets.c
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: uClinux development list <uclinux-dev@uclinux.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 08:08, Greg Ungerer <gerg@snapgear.com> wrote:
> Philippe De Muyter wrote:
>>
>> m68k{nommu}/asm-offsets.c define many constants which are not used
>> anymore anywhere; remove IRQ_DEVID, IRQ_HANDLER, IRQ_NEXT, STAT_IRQ,
>> TASK_ACTIVE_MM, TASK_BLOCKED, TASK_FLAGS, TASK_PTRACE, TASK_STATE,
>> TASK_THREAD_INFO, TI_CPU, TI_EXECDOMAIN and TI_TASK.
>>
>> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>
> I have no problem with the m68knommu part. I can push that into
> the m68knommu git tree. Or if the m68k guys are happy I can put
> the whole thing there?

The m68k part is fine, too.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

>> ---
>>  arch/m68k/kernel/asm-offsets.c      |   12 ------------
>>  arch/m68knommu/kernel/asm-offsets.c |    9 ---------
>>  2 files changed, 0 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/m68k/kernel/asm-offsets.c
>> b/arch/m68k/kernel/asm-offsets.c
>> index 73e5e58..78e59b8 100644
>> --- a/arch/m68k/kernel/asm-offsets.c
>> +++ b/arch/m68k/kernel/asm-offsets.c
>> @@ -22,13 +22,9 @@
>>  int main(void)
>>  {
>>        /* offsets into the task struct */
>> -       DEFINE(TASK_STATE, offsetof(struct task_struct, state));
>> -       DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
>> -       DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
>>        DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
>>        DEFINE(TASK_INFO, offsetof(struct task_struct, thread.info));
>>        DEFINE(TASK_MM, offsetof(struct task_struct, mm));
>> -       DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
>>  #ifdef CONFIG_MMU
>>        DEFINE(TASK_TINFO, offsetof(struct task_struct, thread.info));
>>  #endif
>> @@ -64,14 +60,6 @@ int main(void)
>>        /* bitfields are a bit difficult */
>>        DEFINE(PT_OFF_FORMATVEC, offsetof(struct pt_regs, pc) + 4);
>>  -      /* offsets into the irq_handler struct */
>> -       DEFINE(IRQ_HANDLER, offsetof(struct irq_node, handler));
>> -       DEFINE(IRQ_DEVID, offsetof(struct irq_node, dev_id));
>> -       DEFINE(IRQ_NEXT, offsetof(struct irq_node, next));
>> -
>> -       /* offsets into the kernel_stat struct */
>> -       DEFINE(STAT_IRQ, offsetof(struct kernel_stat, irqs));
>> -
>>        /* offsets into the irq_cpustat_t struct */
>>        DEFINE(CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t,
>> __softirq_pending));
>>  diff --git a/arch/m68knommu/kernel/asm-offsets.c
>> b/arch/m68knommu/kernel/asm-offsets.c
>> index 9a8876f..eca508c 100644
>> --- a/arch/m68knommu/kernel/asm-offsets.c
>> +++ b/arch/m68knommu/kernel/asm-offsets.c
>> @@ -21,14 +21,8 @@
>>  int main(void)
>>  {
>>        /* offsets into the task struct */
>> -       DEFINE(TASK_STATE, offsetof(struct task_struct, state));
>> -       DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
>> -       DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
>> -       DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
>>        DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
>> -       DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
>>        DEFINE(TASK_MM, offsetof(struct task_struct, mm));
>> -       DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
>>        /* offsets into the irq_cpustat_t struct */
>>        DEFINE(CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t,
>> __softirq_pending));
>> @@ -77,11 +71,8 @@ int main(void)
>>        DEFINE(THREAD_SIZE, THREAD_SIZE);
>>        /* Offsets in thread_info structure */
>> -       DEFINE(TI_TASK, offsetof(struct thread_info, task));
>> -       DEFINE(TI_EXECDOMAIN, offsetof(struct thread_info, exec_domain));
>>        DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
>>        DEFINE(TI_PREEMPTCOUNT, offsetof(struct thread_info,
>> preempt_count));
>> -       DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
>>        return 0;
>>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
