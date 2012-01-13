Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2AMUXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:23:25 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54489 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab2AMUXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:23:20 -0500
Message-ID: <4F10929E.8070007@linux.vnet.ibm.com>
Date: Sat, 14 Jan 2012 01:52:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
In-Reply-To: <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011310-0260-0000-0000-000000601641
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 07:52 PM, Ming Lei wrote:

> Hi,
> 
> I saw the warning too during S2R.
> 

> 

> 
> On Wed, Jan 11, 2012 at 8:00 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> Today's pull from Linus' tree shows a warning during poweroff, the
>> message is related to the machinecheck.
>> The drivers/base/core.c:device_release() did not find the registred
>> release() function.
>>
>> This kernel is used for development and it's running under KVM/Qemu, so
>> if you need further information or tests let me know.
>>
>> Qemu is simulating 2 CPUs.
>>
>> Thanks.
>>
>>
>> [ 1879.944193] ------------[ cut here ]------------
>> [ 1879.950488] WARNING: at drivers/base/core.c:194 device_release+0x82/0x90()
>> [ 1879.959424] Hardware name: Bochs
>> [ 1879.964714] Device 'machinecheck1' does not have a release() function, it is broken and must be fixed.
>> [ 1879.977354] Modules linked in:
>> [ 1879.979704] Pid: 1738, comm: halt Not tainted 3.2.0-minimal-kvm-05692-g1c81065-dirty #41
>> [ 1879.989093] Call Trace:
>> [ 1879.992729]  [<ffffffff8103952a>] warn_slowpath_common+0x7a/0xb0
>> [ 1879.999308]  [<ffffffff81039601>] warn_slowpath_fmt+0x41/0x50
>> [ 1880.005463]  [<ffffffff8172b022>] device_release+0x82/0x90
>> [ 1880.012915]  [<ffffffff81601667>] kobject_release+0x47/0x90
>> [ 1880.019107]  [<ffffffff8160152c>] kobject_put+0x2c/0x60
>> [ 1880.024269]  [<ffffffff8172acc2>] put_device+0x12/0x20
>> [ 1880.031254]  [<ffffffff8172ba19>] device_unregister+0x19/0x20
>> [ 1880.038594]  [<ffffffff81afb49d>] mce_cpu_callback+0xea/0x18b
>> [ 1880.043389]  [<ffffffff81b08924>] notifier_call_chain+0x64/0xf0
>> [ 1880.051928]  [<ffffffff81066c89>] __raw_notifier_call_chain+0x9/0x10
>> [ 1880.059077]  [<ffffffff8103b50b>] __cpu_notify+0x1b/0x30
>> [ 1880.063894]  [<ffffffff8103b530>] cpu_notify_nofail+0x10/0x20
>> [ 1880.071952]  [<ffffffff81ae27dd>] _cpu_down+0x11d/0x2c0
>> [ 1880.078534]  [<ffffffff81b01235>] ? printk+0x3c/0x3e

>> [ 1880.082662]  [<ffffffff8103b7cb>] disable_nonboot_cpus+0x8b/0x110
>> [ 1880.091129]  [<ffffffff81053f21>] kernel_power_off+0x21/0x50
>> [ 1880.098420]  [<ffffffff81054220>] sys_reboot+0x110/0x220
>> [ 1880.104098]  [<ffffffff8108efdd>] ? trace_hardirqs_on+0xd/0x10
>> [ 1880.112006]  [<ffffffff81b04deb>] ? _raw_spin_unlock_irq+0x2b/0x50
>> [ 1880.119181]  [<ffffffff8106dc0d>] ? finish_task_switch+0x8d/0x1a0
>> [ 1880.126741]  [<ffffffff8106dbce>] ? finish_task_switch+0x4e/0x1a0
>> [ 1880.134793]  [<ffffffff81b02f0b>] ? __schedule+0x3db/0x890
>> [ 1880.140510]  [<ffffffff81b0cfc7>] ? sysret_check+0x1b/0x56
>> [ 1880.148101]  [<ffffffff8160d33e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> [ 1880.156706]  [<ffffffff81b0cfa2>] system_call_fastpath+0x16/0x1b
>> [ 1880.162885] ---[ end trace d8faf9d3af9f23e8 ]---
>> [ 1880.171148] Power down.
>>


Fundamentally, this warning is triggered during CPU Offline, which is done
during poweroff, suspend, hibernate etc. IOW, even a simple
# echo 0 > /sys/devices/system/cpu/cpuX/online will trigger it.

Some discussion about this warning and a probable fix is going on in this
thread: https://lkml.org/lkml/2012/1/13/278

[And there have been reports of Suspend/Hibernate not working in recent
kernels (3.3 merge window)]

However, it is to be noted that, technically this warning (machinecheck1
not having a release() function) is not all that new. Just that people
didn't probably notice it earlier (reason explained below).

Prior to the 3.3 merge window (when everything was fine, particularly
suspend/resume), upon a CPU offline, we used to get the following message:

Broke affinity for irq 49
Broke affinity for irq 87
CPU 1 is now offline
kobject:kobject: 'index0' (ffff8802764e5c00): does not have a release() function, it is broken and must be fixed.
kobject:kobject: 'index1' (ffff8802764e5c48): does not have a release() function, it is broken and must be fixed.
kobject:kobject: 'index2' (ffff8802764e5c90): does not have a release() function, it is broken and must be fixed.
kobject:kobject: 'index3' (ffff8802764e5cd8): does not have a release() function, it is broken and must be fixed.
kobject:kobject: 'cache' (ffff88027926c480): does not have a release() function, it is broken and must be fixed.
kobject:kobject: 'machinecheck1' (ffff88002822d8f0): does not have a release() function, it is broken and must be fixed.
                    ^^^^^^^^^
This is from the kobject_cleanup() function defined in lib/kobject.c. Since
pr_debug() was used for printing, it made this kind of obscure.

After commit 8a25a2fd (cpu: convert 'cpu' and 'machinecheck' sysdev_class to
a regular subsystem), the callpaths changed and we now hit the rather strong
looking WARN() in drivers/base/core.c:device_release(), which is why it is
getting everyone's attention now.

So, in the recent kernels (3.3 merge window), we get:

(Note the difference in the kobject line about machinecheck)

[46407.738415] kobject: 'cpufreq' (ffff88026f794098): calling ktype release
[46407.752649] CPU 1 is now offline
[46407.757002] kobject: 'index0' (ffff88026f0cac00): does not have a release() function, it is broken and must be fixed.
[46407.769302] kobject: 'index1' (ffff88026f0cac48): does not have a release() function, it is broken and must be fixed.
[46407.781412] kobject: 'index2' (ffff88026f0cac90): does not have a release() function, it is broken and must be fixed.
[46407.793480] kobject: 'index3' (ffff88026f0cacd8): does not have a release() function, it is broken and must be fixed.
[46407.805547] kobject: 'cache' (ffff880272e0d3c0): does not have a release() function, it is broken and must be fixed.
[46407.817906] kobject: 'machinecheck1' (ffff88027fc2cb70): calling ktype release
[46407.826182] ------------[ cut here ]------------
[46407.831514] WARNING: at drivers/base/core.c:194 device_release+0x82/0x90()
[46407.831515] Hardware name: IBM System X iDataPlex dx360 M4 Server -[7912AC1]-
[46407.831517] Device 'machinecheck1' does not have a release() function, it is broken and must be fixed.

IOW, the warning about machinecheck has just been moved from one place to
another.

My only point here is that we have essentially seen this warning before
when suspend/resume was working fine. And it has been reported that
suspend/resume works fine if CONFIG_X86_MCE is not set. So I guess something
else is wrong somewhere.. IOW, I feel whether or not machinecheck has a
release function doesn't really matter that much for suspend/resume to get
any better.

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

