Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2ALOW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:22:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35359 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2ALOWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:22:25 -0500
MIME-Version: 1.0
In-Reply-To: <20120111000051.GA28874@dztty>
References: <20120111000051.GA28874@dztty>
Date: Thu, 12 Jan 2012 22:22:25 +0800
Message-ID: <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
From: Ming Lei <tom.leiming@gmail.com>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I saw the warning too during S2R.

thanks,
--
Ming Lei


On Wed, Jan 11, 2012 at 8:00 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> Today's pull from Linus' tree shows a warning during poweroff, the
> message is related to the machinecheck.
> The drivers/base/core.c:device_release() did not find the registred
> release() function.
>
> This kernel is used for development and it's running under KVM/Qemu, so
> if you need further information or tests let me know.
>
> Qemu is simulating 2 CPUs.
>
> Thanks.
>
>
> [ 1879.944193] ------------[ cut here ]------------
> [ 1879.950488] WARNING: at drivers/base/core.c:194 device_release+0x82/0x90()
> [ 1879.959424] Hardware name: Bochs
> [ 1879.964714] Device 'machinecheck1' does not have a release() function, it is broken and must be fixed.
> [ 1879.977354] Modules linked in:
> [ 1879.979704] Pid: 1738, comm: halt Not tainted 3.2.0-minimal-kvm-05692-g1c81065-dirty #41
> [ 1879.989093] Call Trace:
> [ 1879.992729]  [<ffffffff8103952a>] warn_slowpath_common+0x7a/0xb0
> [ 1879.999308]  [<ffffffff81039601>] warn_slowpath_fmt+0x41/0x50
> [ 1880.005463]  [<ffffffff8172b022>] device_release+0x82/0x90
> [ 1880.012915]  [<ffffffff81601667>] kobject_release+0x47/0x90
> [ 1880.019107]  [<ffffffff8160152c>] kobject_put+0x2c/0x60
> [ 1880.024269]  [<ffffffff8172acc2>] put_device+0x12/0x20
> [ 1880.031254]  [<ffffffff8172ba19>] device_unregister+0x19/0x20
> [ 1880.038594]  [<ffffffff81afb49d>] mce_cpu_callback+0xea/0x18b
> [ 1880.043389]  [<ffffffff81b08924>] notifier_call_chain+0x64/0xf0
> [ 1880.051928]  [<ffffffff81066c89>] __raw_notifier_call_chain+0x9/0x10
> [ 1880.059077]  [<ffffffff8103b50b>] __cpu_notify+0x1b/0x30
> [ 1880.063894]  [<ffffffff8103b530>] cpu_notify_nofail+0x10/0x20
> [ 1880.071952]  [<ffffffff81ae27dd>] _cpu_down+0x11d/0x2c0
> [ 1880.078534]  [<ffffffff81b01235>] ? printk+0x3c/0x3e
> [ 1880.082662]  [<ffffffff8103b7cb>] disable_nonboot_cpus+0x8b/0x110
> [ 1880.091129]  [<ffffffff81053f21>] kernel_power_off+0x21/0x50
> [ 1880.098420]  [<ffffffff81054220>] sys_reboot+0x110/0x220
> [ 1880.104098]  [<ffffffff8108efdd>] ? trace_hardirqs_on+0xd/0x10
> [ 1880.112006]  [<ffffffff81b04deb>] ? _raw_spin_unlock_irq+0x2b/0x50
> [ 1880.119181]  [<ffffffff8106dc0d>] ? finish_task_switch+0x8d/0x1a0
> [ 1880.126741]  [<ffffffff8106dbce>] ? finish_task_switch+0x4e/0x1a0
> [ 1880.134793]  [<ffffffff81b02f0b>] ? __schedule+0x3db/0x890
> [ 1880.140510]  [<ffffffff81b0cfc7>] ? sysret_check+0x1b/0x56
> [ 1880.148101]  [<ffffffff8160d33e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1880.156706]  [<ffffffff81b0cfa2>] system_call_fastpath+0x16/0x1b
> [ 1880.162885] ---[ end trace d8faf9d3af9f23e8 ]---
> [ 1880.171148] Power down.
>
>
> $ cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 2
> model name      : QEMU Virtual CPU version 0.12.5
> stepping        : 3
> microcode       : 0x1
> cpu MHz         : 2800.047
> cache size      : 4096 KB
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 4
> wp              : yes
> flags           : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pse36 clflush mmx fxsr sse sse2 syscall nx lm rep_good nopl pni cx16
> tsc_deadlin _timer hypervisor lahf_lm
> bogomips        : 5600.09
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 40 bits physical, 48 bits virtual
> power management:
>
>
> --
> tixxdz
> http://opendz.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ming Lei
