Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2FRKmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:42:22 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:46820 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468Ab2FRKmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:42:20 -0400
X-Greylist: delayed 1340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2012 06:42:20 EDT
Message-ID: <4FDF00CB.7090703@med.uni-frankfurt.de>
Date: Mon, 18 Jun 2012 12:19:55 +0200
From: Thomas Sattler <sattler@med.uni-frankfurt.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@timesys.com>
Subject: BUG: scheduling while atomic: chcpu/6197/0x00000002
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there ...

I run into the BUG by running 'chcpu --disable 1' on an "Intel(R)
Core(TM)2 CPU" machine. I used 3.4.2-rt10 and I seems not to
happen in vanilla 3.4.2.

I'll try 3.4.3 and 3.4.3-rt10 next and I'll send their results as
a reply to this mail.

(Please CC: me, I'm not on LKML)

Thanks
Thomas


[  554.815919] BUG: scheduling while atomic: chcpu/6197/0x00000002
[  554.815923] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd ehci_hcd 3c59x mii e1000e sg usbcore usb_common
[  554.815942] Pid: 6197, comm: chcpu Not tainted 3.4.2-rt10 #19
[  554.815945] Call Trace:
[  554.815953]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  554.815958]  [<c1355334>] __schedule+0x68/0x571
[  554.815964]  [<c1045844>] ? enqueue_entity+0x313/0x3d8
[  554.815969]  [<c13558e2>] schedule+0x60/0x70
[  554.815972]  [<c1354902>] schedule_timeout+0x17/0x160
[  554.815977]  [<c103ed57>] ? check_preempt_curr+0x29/0x64
[  554.815981]  [<c13551ed>] wait_for_common+0xa3/0xff
[  554.815985]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  554.815989]  [<c13552ca>] wait_for_completion+0x12/0x14
[  554.815993]  [<c103781c>] kthread_create_on_node+0x71/0xb5
[  554.815997]  [<c102542c>] ? put_online_cpus+0x44/0x44
[  554.816002]  [<c1350101>] ? init_amd+0x56f/0x64f
[  554.816007]  [<c134719f>] _cpu_down+0x106/0x2b4
[  554.816021]  [<c102542c>] ? put_online_cpus+0x44/0x44
[  554.816027]  [<c1347372>] cpu_down+0x25/0x34
[  554.816030]  [<c13489b6>] store_online+0x29/0x70
[  554.816034]  [<c134898d>] ? acpi_processor_start+0xf7/0xf7
[  554.816038]  [<c127b037>] dev_attr_store+0x1b/0x23
[  554.816043]  [<c10eb6c6>] sysfs_write_file+0xae/0xe7
[  554.816048]  [<c10ab93e>] vfs_write+0x8c/0x122
[  554.816052]  [<c10eb618>] ? sysfs_poll+0x77/0x77
[  554.816056]  [<c10abb8f>] sys_write+0x3b/0x60
[  554.816061]  [<c1357823>] sysenter_do_call+0x12/0x2c
[  554.817316] BUG: scheduling while atomic: chcpu/6197/0x00000002
[  554.817319] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd ehci_hcd 3c59x mii e1000e sg usbcore usb_common
[  554.817335] Pid: 6197, comm: chcpu Not tainted 3.4.2-rt10 #19
[  554.817337] Call Trace:
[  554.817343]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  554.817347]  [<c1355334>] __schedule+0x68/0x571
[  554.817351]  [<c1356a61>] ? _raw_spin_unlock_irqrestore+0x1a/0x2f
[  554.817356]  [<c103a992>] ? __hrtimer_start_range_ns+0x2cf/0x2f6
[  554.817360]  [<c13558e2>] schedule+0x60/0x70
[  554.817364]  [<c1354dea>] schedule_hrtimeout_range_clock+0xc5/0xec
[  554.817368]  [<c103a202>] ? update_rmtp+0x68/0x68
[  554.817372]  [<c1354e1b>] schedule_hrtimeout_range+0xa/0xc
[  554.817376]  [<c1354e29>] schedule_hrtimeout+0xc/0xe
[  554.817380]  [<c103f197>] wait_task_inactive+0xc5/0xd6
[  554.817385]  [<c1037773>] kthread_bind+0x13/0x4b
[  554.817389]  [<c13471ba>] _cpu_down+0x121/0x2b4
[  554.817394]  [<c1347372>] cpu_down+0x25/0x34
[  554.817397]  [<c13489b6>] store_online+0x29/0x70
[  554.817401]  [<c134898d>] ? acpi_processor_start+0xf7/0xf7
[  554.817405]  [<c127b037>] dev_attr_store+0x1b/0x23
[  554.817409]  [<c10eb6c6>] sysfs_write_file+0xae/0xe7
[  554.817413]  [<c10ab93e>] vfs_write+0x8c/0x122
[  554.817417]  [<c10eb618>] ? sysfs_poll+0x77/0x77
[  554.817421]  [<c10abb8f>] sys_write+0x3b/0x60
[  554.817425]  [<c1357823>] sysenter_do_call+0x12/0x2c
[  554.819134] BUG: scheduling while atomic: chcpu/6197/0x00000002
[  554.819137] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd ehci_hcd 3c59x mii e1000e sg usbcore usb_common
[  554.819153] Pid: 6197, comm: chcpu Not tainted 3.4.2-rt10 #19
[  554.819155] Call Trace:
[  554.819160]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  554.819164]  [<c1355334>] __schedule+0x68/0x571
[  554.819170]  [<c1008017>] ? sched_clock+0x9/0xd
[  554.819173]  [<c10428f9>] ? sched_clock_local+0x11/0x12f
[  554.819178]  [<c13558e2>] schedule+0x60/0x70
[  554.819182]  [<c1354902>] schedule_timeout+0x17/0x160
[  554.819186]  [<c13551ed>] wait_for_common+0xa3/0xff
[  554.819190]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  554.819195]  [<c13552ca>] wait_for_completion+0x12/0x14
[  554.819199]  [<c13471c9>] _cpu_down+0x130/0x2b4
[  554.819203]  [<c1347372>] cpu_down+0x25/0x34
[  554.819207]  [<c13489b6>] store_online+0x29/0x70
[  554.819210]  [<c134898d>] ? acpi_processor_start+0xf7/0xf7
[  554.819214]  [<c127b037>] dev_attr_store+0x1b/0x23
[  554.819219]  [<c10eb6c6>] sysfs_write_file+0xae/0xe7
[  554.819223]  [<c10ab93e>] vfs_write+0x8c/0x122
[  554.819227]  [<c10eb618>] ? sysfs_poll+0x77/0x77
[  554.819230]  [<c10abb8f>] sys_write+0x3b/0x60
[  554.819235]  [<c1357823>] sysenter_do_call+0x12/0x2c
[  554.819269] BUG: scheduling while atomic: chcpu/6197/0x00000002
[  554.819271] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd ehci_hcd 3c59x mii e1000e sg usbcore usb_common
[  554.819287] Pid: 6197, comm: chcpu Not tainted 3.4.2-rt10 #19
[  554.819289] Call Trace:
[  554.819293]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  554.819297]  [<c1355334>] __schedule+0x68/0x571
[  554.819302]  [<c1008017>] ? sched_clock+0x9/0xd
[  554.819306]  [<c10428f9>] ? sched_clock_local+0x11/0x12f
[  554.819312]  [<c13558e2>] schedule+0x60/0x70
[  554.819316]  [<c1354902>] schedule_timeout+0x17/0x160
[  554.819320]  [<c13551ed>] wait_for_common+0xa3/0xff
[  554.819324]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  554.819328]  [<c13552ca>] wait_for_completion+0x12/0x14
[  554.819332]  [<c1037742>] kthread_stop+0x2d/0x4b
[  554.819337]  [<c10330fa>] destroy_worker+0x54/0x74
[  554.819341]  [<c1348d37>] workqueue_cpu_down_callback+0x193/0x251
[  554.819346]  [<c1185d3d>] ? compute_batch_value+0x19/0x29
[  554.819350]  [<c1353d1e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  554.819354]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  554.819358]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  554.819362]  [<c1025331>] __cpu_notify+0x15/0x29
[  554.819367]  [<c13471f1>] _cpu_down+0x158/0x2b4
[  554.819371]  [<c1347372>] cpu_down+0x25/0x34
[  554.819375]  [<c13489b6>] store_online+0x29/0x70
[  554.819378]  [<c134898d>] ? acpi_processor_start+0xf7/0xf7
[  554.819382]  [<c127b037>] dev_attr_store+0x1b/0x23
[  554.819386]  [<c10eb6c6>] sysfs_write_file+0xae/0xe7
[  554.819390]  [<c10ab93e>] vfs_write+0x8c/0x122
[  554.819394]  [<c10eb618>] ? sysfs_poll+0x77/0x77
[  554.819398]  [<c10abb8f>] sys_write+0x3b/0x60
[  554.819402]  [<c1357823>] sysenter_do_call+0x12/0x2c
[  554.819421] BUG: scheduling while atomic: chcpu/6197/0x00000002
[  554.819424] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd ehci_hcd 3c59x mii e1000e sg usbcore usb_common
[  554.819439] Pid: 6197, comm: chcpu Not tainted 3.4.2-rt10 #19
[  554.819442] Call Trace:
[  554.819446]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  554.819450]  [<c1355334>] __schedule+0x68/0x571
[  554.819455]  [<c1008017>] ? sched_clock+0x9/0xd
[  554.819459]  [<c10428f9>] ? sched_clock_local+0x11/0x12f
[  554.819463]  [<c13558e2>] schedule+0x60/0x70
[  554.819466]  [<c1354902>] schedule_timeout+0x17/0x160
[  554.819471]  [<c13551ed>] wait_for_common+0xa3/0xff
[  554.819475]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  554.819478]  [<c13552ca>] wait_for_completion+0x12/0x14
[  554.819482]  [<c1037742>] kthread_stop+0x2d/0x4b
[  554.819486]  [<c10330fa>] destroy_worker+0x54/0x74
[  554.819491]  [<c1348d37>] workqueue_cpu_down_callback+0x193/0x251
[  554.819495]  [<c1185d3d>] ? compute_batch_value+0x19/0x29
[  554.819499]  [<c1353d1e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  554.819504]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  554.819508]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  554.819512]  [<c1025331>] __cpu_notify+0x15/0x29
[  554.819516]  [<c13471f1>] _cpu_down+0x158/0x2b4
[  554.819521]  [<c1347372>] cpu_down+0x25/0x34
[  554.819524]  [<c13489b6>] store_online+0x29/0x70
[  554.819528]  [<c134898d>] ? acpi_processor_start+0xf7/0xf7
[  554.819532]  [<c127b037>] dev_attr_store+0x1b/0x23
[  554.819536]  [<c10eb6c6>] sysfs_write_file+0xae/0xe7
[  554.819540]  [<c10ab93e>] vfs_write+0x8c/0x122
[  554.819544]  [<c10eb618>] ? sysfs_poll+0x77/0x77
[  554.819548]  [<c10abb8f>] sys_write+0x3b/0x60
[  554.819552]  [<c1357823>] sysenter_do_call+0x12/0x2c
