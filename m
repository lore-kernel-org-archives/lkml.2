Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab1A2Fop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 00:44:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37053 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1A2Foo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 00:44:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eOed6YtcKL7lJFA/8+3oLLeYJKrR4Zccs8CpfqcML5neGZp/3xuVc1U7JHTg7Cn6P3
         4lDUYv3lfR2f6Phmln6nCLUgzIbcofpf5ggEzPZDhmPTcoCrVO/ghue3mt48xiUEHlH7
         UO0uE9UMKzqejhi7+Tr+qSnZlGF45z2WLIy+g=
MIME-Version: 1.0
In-Reply-To: <1296210619.15234.263.camel@laptop>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	<1295894492.28776.470.camel@laptop>
	<AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	<1295946736.28776.479.camel@laptop>
	<AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
	<1296210619.15234.263.camel@laptop>
Date: Sat, 29 Jan 2011 13:44:42 +0800
Message-ID: <AANLkTikagMAGssG09D+SCKTsu9T+==R2fsSM3tgHctdv@mail.gmail.com>
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused by pm_idle
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 6:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> We have seen an extremely slow system under the CPU-OFFLINE-ONLIE test
>> on a 4-sockets NHM-EX system.
>
> Slow is OK, cpu-hotplug isn't performance critical by any means.

Here is one example that the "slow" is not acceptable. Maybe I should
not use "slow" in the first place. It happnes after I resolved a
similar NMI watchdog warnning in calibrate_delay_direct..

Please note, I got the BUG in a 2.6.32-based kernel. Upstream  behaves
similar I guess.

BUG: soft lockup - CPU#63 stuck for 61s! [migration/63:256]
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table ipv6 dm_mirror dm_region_hash dm_log i2c_i801 i2c_core
iTCO_wdt iTCO_vendor_support ioatdma i7core_edac edac_core sg igb dca
ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic
ata_piix megaraid_sas dm_mod [last unloaded: microcode]
CPU 63:
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table ipv6 dm_mirror dm_region_hash dm_log i2c_i801 i2c_core
iTCO_wdt iTCO_vendor_support ioatdma i7core_edac edac_core sg igb dca
ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic
ata_piix megaraid_sas dm_mod [last unloaded: microcode]
Pid: 256, comm: migration/63 Not tainted 2.6.32 #13 QSSC-S4R
RIP: 0010:[<ffffffff81022120>]  [<ffffffff81022120>] mtrr_work_handler+0x20/0xc0
RSP: 0018:ffff88046d997de0  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88046d997df0 RCX: ffff880c8e5f2168
RDX: ffff88046d995520 RSI: 00000000ffffffff RDI: ffff88106dc1dea8
RBP: ffffffff8100bc8e R08: ffff88046d996000 R09: 00000000ffffffff
R10: 00000000ffffffff R11: 0000000000000001 R12: ffff88046d997df0
R13: ffffffff8100bc8e R14: 0000000000000000 R15: ffffffff814c2676
FS:  0000000000000000(0000) GS:ffff880c8e5e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f58b1761098 CR3: 0000000001a25000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff810be4da>] ? cpu_stopper_thread+0xda/0x1b0
 [<ffffffff814c2676>] ? thread_return+0x4e/0x778
 [<ffffffff81054792>] ? default_wake_function+0x12/0x20
 [<ffffffff810be400>] ? cpu_stopper_thread+0x0/0x1b0
 [<ffffffff81089d86>] ? kthread+0x96/0xa0
 [<ffffffff8100c1ca>] ? child_rip+0xa/0x20
 [<ffffffff81089cf0>] ? kthread+0x0/0xa0
 [<ffffffff8100c1c0>] ? child_rip+0x0/0x20
BUG: soft lockup - CPU#63 stuck for 61s! [migration/63:256]
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table ipv6 dm_mirro

>
>> The test case of off-line-on-line a cpu 1000 times and its performance
>> is dominated by IPI and ipi_handler performance. On NHM-EX, Sending
>> IPI not through broadcast is very slow. Needs to wake up processor by
>> IPI from deep-c-state also incurs heavy weight delay in set_mtrr
>> synchronization in stop_machinecontext. NHM-EX's c3-stop-APIC timer
>> adds more trouble to the problem. If I understand the problem
>> correctly, We probably need to tweak IPI code in upstream to get a
>> clean solution for NHM-EX's slow IPI delivery problem to get
>> reschedule tick processed without any delay on CPU which was in deep c state.
>> But it needs more time. So A quick fix is provided to make the test pass.
>
> If its slow but working, the test is broken, I don't see a reason to do
> anything to the kernel, let alone the below.

It not working sometimes, so I think it's not a solid feature right now.

>
>> Without the patch the current CPU Office Online feature would not work
>> reliably,
>
> But you just said it was slow, that means its reliable, just not fast.

I must have used a wrong term. Feel sorry about that.
>
>>  since it currently unnecessarily implicitly interact with
>> CPU power management.
>
> daft statement at best, because if not for some misguided power
> management purpose, what are you actually unplugging cpus for?
> (misguided because unplug doesn't actually safe more power than simply
> idling the cpu).
It's a RAS feature and Suspend Resume also hits same code path I think.
>
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 083e99d..832bbdc 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -83,6 +83,7 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
>>  * for idle threads.
>>  */
>>  #ifdef CONFIG_HOTPLUG_CPU
>> +static struct notifier_block pm_idle_cpu_notifier;
>>  /*
>>   * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
>>   * removed after init for !CONFIG_HOTPLUG_CPU.
>> @@ -1162,6 +1163,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>>                 uv_system_init();
>>
>>         set_mtrr_aps_delayed_init();
>> +       register_hotcpu_notifier(&pm_idle_cpu_notifier);
>>  out:
>>         preempt_enable();
>>  }
>> @@ -1469,6 +1471,42 @@ void native_play_dead(void)
>>         hlt_play_dead();
>>  }
>>
>> +static void (*pm_idle_saved)(void);
>> +
>> +static inline void save_pm_idle(void)
>> +{
>> +       pm_idle_saved = pm_idle;
>> +       pm_idle = default_idle;
>> +       cpu_idle_wait();
>> +}
>> +
>> +static inline void restore_pm_idle(void)
>> +{
>> +       pm_idle = pm_idle_saved;
>> +       cpu_idle_wait();
>> +}
>
> So you flip the pm_idle pointer protected unter hotplug mutex, but
> that's not serialized against module loading, so what happens if you
> concurrently load a module that sets another idle policy?
>
> Your changelog is vague at best, so what exactly is the purpose here? We
> flip to default_idle(), which uses HLT, which is C1. Then you run
> cpu_idle_wait(), which will IPI all cpus, all these CPUs (except one)
> could have been in deep C states (C3+) so you get your slow wakeup
> anyway.
>
> There-after you do the normal stop-machine hot-plug dance, which again
> will IPI all cpus once, then you flip it back to the saved pm_idle
> handler and again IPI all cpus.

https://lkml.org/lkml/2009/6/29/60
it needs 50-100us latency to send one IPI, you could get an idea on a
large NHM-EX system which contains 64 logical processors. With
Tickless and APIC timer stopped in C3 on NHM-EX, you could also have
an idea about the problem I have.

Let me know if there are still questions .
