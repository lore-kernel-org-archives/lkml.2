Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab2FRMdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:33:41 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:55158 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056Ab2FRMdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:33:40 -0400
Message-ID: <4FDF201E.2090408@med.uni-frankfurt.de>
Date: Mon, 18 Jun 2012 14:33:34 +0200
From: Thomas Sattler <sattler@med.uni-frankfurt.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: scheduling while atomic: chcpu/6197/0x00000002
References: <4FDF00CB.7090703@med.uni-frankfurt.de>
In-Reply-To: <4FDF00CB.7090703@med.uni-frankfurt.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vanilla 3.4.3 seems to work, but 3.4.3-rt10 bugs too:

[  247.758134] BUG: scheduling while atomic: chcpu/2947/0x00000002
[  247.758137] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid 3c59x uhci_hcd mii ehci_hcd e1000e usbcore usb_common sg
[  247.758157] Pid: 2947, comm: chcpu Not tainted 3.4.3-rt10 #22
[  247.758159] Call Trace:
[  247.758168]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  247.758173]  [<c1355394>] __schedule+0x68/0x571
[  247.758179]  [<c1045840>] ? enqueue_entity+0x313/0x3d8
[  247.758183]  [<c103e7da>] ? resched_task+0x3c/0x5a
[  247.758187]  [<c1355942>] schedule+0x60/0x70
[  247.758191]  [<c1354962>] schedule_timeout+0x17/0x160
[  247.758195]  [<c103ed57>] ? check_preempt_curr+0x29/0x64
[  247.758200]  [<c135524d>] wait_for_common+0xa3/0xff
[  247.758204]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  247.758208]  [<c135532a>] wait_for_completion+0x12/0x14
[  247.758213]  [<c103781c>] kthread_create_on_node+0x71/0xb5
[  247.758217]  [<c102542c>] ? put_online_cpus+0x44/0x44
[  247.758222]  [<c1350101>] ? init_amd+0x50f/0x64f
[  247.758227]  [<c13471ff>] _cpu_down+0x106/0x2b4
[  247.758231]  [<c102542c>] ? put_online_cpus+0x44/0x44
[  247.758236]  [<c13473d2>] cpu_down+0x25/0x34
[  247.758240]  [<c1348a16>] store_online+0x29/0x70
[  247.758244]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  247.758248]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  247.758254]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  247.758259]  [<c10ab946>] vfs_write+0x8c/0x122
[  247.758263]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  247.758267]  [<c10abb97>] sys_write+0x3b/0x60
[  247.758272]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  247.758297] BUG: scheduling while atomic: chcpu/2947/0x00000002
[  247.758299] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid 3c59x uhci_hcd mii ehci_hcd e1000e usbcore usb_common sg
[  247.758315] Pid: 2947, comm: chcpu Not tainted 3.4.3-rt10 #22
[  247.758317] Call Trace:
[  247.758322]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  247.758326]  [<c1355394>] __schedule+0x68/0x571
[  247.758331]  [<c1356ac1>] ? _raw_spin_unlock_irqrestore+0x1a/0x2f
[  247.758335]  [<c103a992>] ? __hrtimer_start_range_ns+0x2cf/0x2f6
[  247.758340]  [<c1355942>] schedule+0x60/0x70
[  247.758344]  [<c1354e4a>] schedule_hrtimeout_range_clock+0xc5/0xec
[  247.758348]  [<c103a202>] ? update_rmtp+0x68/0x68
[  247.758352]  [<c1354e7b>] schedule_hrtimeout_range+0xa/0xc
[  247.758356]  [<c1354e89>] schedule_hrtimeout+0xc/0xe
[  247.758361]  [<c103f197>] wait_task_inactive+0xc5/0xd6
[  247.758365]  [<c1037773>] kthread_bind+0x13/0x4b
[  247.758369]  [<c134721a>] _cpu_down+0x121/0x2b4
[  247.758374]  [<c13473d2>] cpu_down+0x25/0x34
[  247.758378]  [<c1348a16>] store_online+0x29/0x70
[  247.758381]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  247.758385]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  247.758390]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  247.758394]  [<c10ab946>] vfs_write+0x8c/0x122
[  247.758398]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  247.758402]  [<c10abb97>] sys_write+0x3b/0x60
[  247.758406]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  247.761021] BUG: scheduling while atomic: chcpu/2947/0x00000002
[  247.761024] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid 3c59x uhci_hcd mii ehci_hcd e1000e usbcore usb_common sg
[  247.761040] Pid: 2947, comm: chcpu Not tainted 3.4.3-rt10 #22
[  247.761042] Call Trace:
[  247.761048]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  247.761052]  [<c1355394>] __schedule+0x68/0x571
[  247.761058]  [<c1008017>] ? sched_clock+0x9/0xd
[  247.761062]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  247.761067]  [<c1355942>] schedule+0x60/0x70
[  247.761070]  [<c1354962>] schedule_timeout+0x17/0x160
[  247.761075]  [<c135524d>] wait_for_common+0xa3/0xff
[  247.761079]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  247.761083]  [<c135532a>] wait_for_completion+0x12/0x14
[  247.761087]  [<c1347229>] _cpu_down+0x130/0x2b4
[  247.761092]  [<c13473d2>] cpu_down+0x25/0x34
[  247.761095]  [<c1348a16>] store_online+0x29/0x70
[  247.761099]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  247.761103]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  247.761108]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  247.761112]  [<c10ab946>] vfs_write+0x8c/0x122
[  247.761116]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  247.761120]  [<c10abb97>] sys_write+0x3b/0x60
[  247.761124]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  247.761159] BUG: scheduling while atomic: chcpu/2947/0x00000002
[  247.761161] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid 3c59x uhci_hcd mii ehci_hcd e1000e usbcore usb_common sg
[  247.761177] Pid: 2947, comm: chcpu Not tainted 3.4.3-rt10 #22
[  247.761179] Call Trace:
[  247.761184]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  247.761188]  [<c1355394>] __schedule+0x68/0x571
[  247.761193]  [<c1008017>] ? sched_clock+0x9/0xd
[  247.761197]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  247.761201]  [<c1355942>] schedule+0x60/0x70
[  247.761205]  [<c1354962>] schedule_timeout+0x17/0x160
[  247.761210]  [<c135524d>] wait_for_common+0xa3/0xff
[  247.761214]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  247.761218]  [<c135532a>] wait_for_completion+0x12/0x14
[  247.761222]  [<c1037742>] kthread_stop+0x2d/0x4b
[  247.761227]  [<c10330fa>] destroy_worker+0x54/0x74
[  247.761231]  [<c1348d97>] workqueue_cpu_down_callback+0x193/0x251
[  247.761236]  [<c1185d7d>] ? compute_batch_value+0x19/0x29
[  247.761240]  [<c1353d7e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  247.761245]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  247.761249]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  247.761253]  [<c1025331>] __cpu_notify+0x15/0x29
[  247.761257]  [<c1347251>] _cpu_down+0x158/0x2b4
[  247.761262]  [<c13473d2>] cpu_down+0x25/0x34
[  247.761266]  [<c1348a16>] store_online+0x29/0x70
[  247.761269]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  247.761273]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  247.761278]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  247.761282]  [<c10ab946>] vfs_write+0x8c/0x122
[  247.761286]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  247.761290]  [<c10abb97>] sys_write+0x3b/0x60
[  247.761294]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  247.761301] BUG: scheduling while atomic: chcpu/2947/0x00000002
[  247.761303] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid 3c59x uhci_hcd mii ehci_hcd e1000e usbcore usb_common sg
[  247.761319] Pid: 2947, comm: chcpu Not tainted 3.4.3-rt10 #22
[  247.761322] Call Trace:
[  247.761326]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  247.761330]  [<c1355394>] __schedule+0x68/0x571
[  247.761335]  [<c1008017>] ? sched_clock+0x9/0xd
[  247.761341]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  247.761345]  [<c1355942>] schedule+0x60/0x70
[  247.761349]  [<c1354962>] schedule_timeout+0x17/0x160
[  247.761353]  [<c135524d>] wait_for_common+0xa3/0xff
[  247.761357]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  247.761361]  [<c135532a>] wait_for_completion+0x12/0x14
[  247.761365]  [<c1037742>] kthread_stop+0x2d/0x4b
[  247.761369]  [<c10330fa>] destroy_worker+0x54/0x74
[  247.761373]  [<c1348d97>] workqueue_cpu_down_callback+0x193/0x251
[  247.761378]  [<c1185d7d>] ? compute_batch_value+0x19/0x29
[  247.761382]  [<c1353d7e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  247.761387]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  247.761391]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  247.761395]  [<c1025331>] __cpu_notify+0x15/0x29
[  247.761399]  [<c1347251>] _cpu_down+0x158/0x2b4
[  247.761404]  [<c13473d2>] cpu_down+0x25/0x34
[  247.761407]  [<c1348a16>] store_online+0x29/0x70
[  247.761411]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  247.761415]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  247.761420]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  247.761424]  [<c10ab946>] vfs_write+0x8c/0x122
[  247.761428]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  247.761432]  [<c10abb97>] sys_write+0x3b/0x60
[  247.761436]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  247.761455] BUG: scheduling while atomic: chcpu/2947/0x00000002
[  247.761457] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid 3c59x uhci_hcd mii ehci_hcd e1000e usbcore usb_common sg
[  247.761473] Pid: 2947, comm: chcpu Not tainted 3.4.3-rt10 #22
[  247.761475] Call Trace:
[  247.761479]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  247.761483]  [<c1355394>] __schedule+0x68/0x571
[  247.761489]  [<c1008017>] ? sched_clock+0x9/0xd
[  247.761492]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  247.761497]  [<c1355942>] schedule+0x60/0x70
[  247.761501]  [<c1354962>] schedule_timeout+0x17/0x160
[  247.761505]  [<c135524d>] wait_for_common+0xa3/0xff
[  247.761509]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  247.761513]  [<c135532a>] wait_for_completion+0x12/0x14
[  247.761517]  [<c1037742>] kthread_stop+0x2d/0x4b
[  247.761521]  [<c10330fa>] destroy_worker+0x54/0x74
[  247.761525]  [<c1348d97>] workqueue_cpu_down_callback+0x193/0x251
[  247.761530]  [<c1185d7d>] ? compute_batch_value+0x19/0x29
[  247.761534]  [<c1353d7e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  247.761539]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  247.761543]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  247.761547]  [<c1025331>] __cpu_notify+0x15/0x29
[  247.761551]  [<c1347251>] _cpu_down+0x158/0x2b4
[  247.761556]  [<c13473d2>] cpu_down+0x25/0x34
[  247.761560]  [<c1348a16>] store_online+0x29/0x70
[  247.761563]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  247.761567]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  247.761572]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  247.761576]  [<c10ab946>] vfs_write+0x8c/0x122
[  247.761580]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  247.761584]  [<c10abb97>] sys_write+0x3b/0x60
[  247.761588]  [<c1357863>] sysenter_do_call+0x12/0x2c
