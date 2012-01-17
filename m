Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2AQJxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:53:40 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:34904 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2AQJxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:53:37 -0500
Message-ID: <4F1544EA.5060907@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 15:22:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com> <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com> <4F10EB5B.5060804@linux.vnet.ibm.com> <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011709-8878-0000-0000-000000F93A99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 07:51 AM, Suresh Siddha wrote:

> On Sat, 2012-01-14 at 08:11 +0530, Srivatsa S. Bhat wrote:
>> Of course, the warnings at drivers/base/core.c: device_release()
>> as well as the IPI to offline cpu warnings still appear but are rather
>> unrelated and harmless to the issue being discussed.
> 
> As far the IPI offline cpu warnings are concerned, appended patch should
> fix it. Can you please give it a try? Peterz, can you please review and
> queue it after Srivatsa confirms that it works? Thanks.


Hi Suresh,

Thanks for the patch, but unfortunately it doesn't fix the problem!
Exactly the same stack traces are seen during a CPU Hotplug stress test.
(I didn't even have to stress it - it is so fragile that just a script
to offline all cpus except the boot cpu was good enough to reproduce the
problem easily.)

[  562.269083] ------------[ cut here ]------------
[  562.273079] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[  562.273079] Hardware name: IBM System x -[7870C4Q]-
[  562.273079] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod iTCO_wdt i7core_edac i2c_i801 ioatdma cdc_ether i2c_core tpm_tis bnx2 shpchp usbnet pcspkr mii iTCO_vendor_support edac_core serio_raw dca sg rtc_cmos tpm tpm_bios pci_hotplug button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  562.273079] Pid: 6, comm: migration/0 Not tainted 3.2.0-sureshipi-0.0.0.28.36b5ec9-default #2
[  562.273079] Call Trace:
[  562.273079]  <IRQ>  [<ffffffff810213d9>] ? native_smp_send_reschedule+0x59/0x60
[  562.273079]  [<ffffffff8103cf4a>] warn_slowpath_common+0x7a/0xb0
[  562.273079]  [<ffffffff8103cf95>] warn_slowpath_null+0x15/0x20
[  562.273079]  [<ffffffff810213d9>] native_smp_send_reschedule+0x59/0x60
[  562.273079]  [<ffffffff81082d65>] trigger_load_balance+0x185/0x500
[  562.273079]  [<ffffffff81082d9b>] ? trigger_load_balance+0x1bb/0x500
[  562.273079]  [<ffffffff81073db7>] scheduler_tick+0x107/0x170
[  562.273079]  [<ffffffff8104e6f7>] update_process_times+0x67/0x80
[  562.273079]  [<ffffffff8109c64f>] tick_sched_timer+0x5f/0xc0
[  562.273079]  [<ffffffff8109c5f0>] ? tick_nohz_handler+0x100/0x100
[  562.273079]  [<ffffffff8106a85e>] __run_hrtimer+0x12e/0x330
[  562.273079]  [<ffffffff8106aca7>] hrtimer_interrupt+0xc7/0x1f0
[  562.273079]  [<ffffffff81022ff4>] smp_apic_timer_interrupt+0x64/0xa0
[  562.273079]  [<ffffffff814a2a33>] apic_timer_interrupt+0x73/0x80
[  562.273079]  <EOI>  [<ffffffff810c563a>] ? stop_machine_cpu_stop+0xda/0x130
[  562.273079]  [<ffffffff810c5560>] ? stop_one_cpu_nowait+0x50/0x50
[  562.273079]  [<ffffffff810c5279>] cpu_stopper_thread+0xd9/0x1b0
[  562.273079]  [<ffffffff81498ddf>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
[  562.273079]  [<ffffffff810c51a0>] ? res_counter_init+0x50/0x50
[  562.273079]  [<ffffffff810a2add>] ? trace_hardirqs_on_caller+0x12d/0x1b0
[  562.273079]  [<ffffffff810a2b6d>] ? trace_hardirqs_on+0xd/0x10
[  562.273079]  [<ffffffff810c51a0>] ? res_counter_init+0x50/0x50
[  562.273079]  [<ffffffff8106553e>] kthread+0x9e/0xb0
[  562.273079]  [<ffffffff814a3334>] kernel_thread_helper+0x4/0x10
[  562.273079]  [<ffffffff81499174>] ? retint_restore_args+0x13/0x13
[  562.273079]  [<ffffffff810654a0>] ? __init_kthread_worker+0x70/0x70
[  562.273079]  [<ffffffff814a3330>] ? gs_change+0x13/0x13
[  562.273079] ---[ end trace 4efec5b2532b902d ]---


I have a few questions regarding the synchronization with CPU Hotplug.
What guarantees that the code which selects and IPIs the new ilb is totally
race-free with respect to CPU hotplug and we will never IPI an offline CPU?

(In 3.2-rc7 I hadn't hit the IPI to offline cpu issue (the above stack trace)
as far as I remember.)

While trying to figure out what changed in the 3.3 merge window, I added a
WARN_ON in the 3.2-rc7 kernel as shown below:

static void nohz_balancer_kick(int cpu)
{
        ....

        if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
                cpu_rq(ilb_cpu)->nohz_balance_kick = 1;

                smp_mb();
                /*
                 * Use smp_send_reschedule() instead of resched_cpu().
                 * This way we generate a sched IPI on the target cpu which
                 * is idle. And the softirq performing nohz idle load balance
                 * will be run before returning from the IPI.
                 */
==========>      if (!cpu_active(ilb_cpu))
==========>             WARN_ON(1);
                smp_send_reschedule(ilb_cpu);
        }
        return;
}

As expected, I hit this warning during my CPU hotplug stress tests. I am sure
this happens on latest kernel too (3.3 merge window), since there is
apparently no change in that part of code in that aspect.

So, while selecting the new ilb, why are we not careful enough to ensure we
don't select a cpu that is going offline? Is this by design (to avoid some
overhead) or is this a bug? (As demonstrated above, this issue is in 3.2-rc7
as well.)

And the only reason I can think why we did not hit the "IPI to offline CPU"
issue in 3.2-rc7 kernel is that the race window (with CPU offline) was
probably too small and _not_ because we explicitly synchronized with CPU
Hotplug.

Probably I am missing something obvious... I would be grateful if you could
kindly help me understand how this works..

Regards,
Srivatsa S. Bhat

