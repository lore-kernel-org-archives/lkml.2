Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2FTJbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:31:46 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:51983 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab2FTJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:31:45 -0400
X-Greylist: delayed 997 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2012 05:31:44 EDT
Message-ID: <4FE19494.6000303@med.uni-frankfurt.de>
Date: Wed, 20 Jun 2012 11:15:00 +0200
From: Thomas Sattler <sattler@med.uni-frankfurt.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: scheduling while atomic: chcpu/6197/0x00000002
References: <4FDF00CB.7090703@med.uni-frankfurt.de> <4FDF201E.2090408@med.uni-frankfurt.de>
In-Reply-To: <4FDF201E.2090408@med.uni-frankfurt.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still in 3.4.3-rt11:

[  191.423385] BUG: scheduling while atomic: chcpu/2831/0x00000002
[  191.423389] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd e1000e ehci_hcd usbcore 3c59x mii usb_common sg
[  191.423408] Pid: 2831, comm: chcpu Not tainted 3.4.3-rt11 #29
[  191.423411] Call Trace:
[  191.423419]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  191.423424]  [<c1355394>] __schedule+0x68/0x571
[  191.423430]  [<c1045840>] ? enqueue_entity+0x313/0x3d8
[  191.423434]  [<c1355942>] schedule+0x60/0x70
[  191.423438]  [<c1354962>] schedule_timeout+0x17/0x160
[  191.423442]  [<c103ed57>] ? check_preempt_curr+0x29/0x64
[  191.423447]  [<c135524d>] wait_for_common+0xa3/0xff
[  191.423451]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  191.423455]  [<c135532a>] wait_for_completion+0x12/0x14
[  191.423459]  [<c103781c>] kthread_create_on_node+0x71/0xb5
[  191.423464]  [<c102542c>] ? put_online_cpus+0x44/0x44
[  191.423469]  [<c1350101>] ? init_amd+0x50f/0x64f
[  191.423474]  [<c13471ff>] _cpu_down+0x106/0x2b4
[  191.423478]  [<c102542c>] ? put_online_cpus+0x44/0x44
[  191.423483]  [<c13473d2>] cpu_down+0x25/0x34
[  191.423486]  [<c1348a16>] store_online+0x29/0x70
[  191.423490]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  191.423495]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  191.423500]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  191.423505]  [<c10ab946>] vfs_write+0x8c/0x122
[  191.423509]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  191.423513]  [<c10abb97>] sys_write+0x3b/0x60
[  191.423518]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  191.423543] BUG: scheduling while atomic: chcpu/2831/0x00000002
[  191.423545] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd e1000e ehci_hcd usbcore 3c59x mii usb_common sg
[  191.423560] Pid: 2831, comm: chcpu Not tainted 3.4.3-rt11 #29
[  191.423563] Call Trace:
[  191.423567]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  191.423571]  [<c1355394>] __schedule+0x68/0x571
[  191.423576]  [<c1356ac1>] ? _raw_spin_unlock_irqrestore+0x1a/0x2f
[  191.423580]  [<c103a992>] ? __hrtimer_start_range_ns+0x2cf/0x2f6
[  191.423585]  [<c1355942>] schedule+0x60/0x70
[  191.423589]  [<c1354e4a>] schedule_hrtimeout_range_clock+0xc5/0xec
[  191.423593]  [<c103a202>] ? update_rmtp+0x68/0x68
[  191.423598]  [<c1354e7b>] schedule_hrtimeout_range+0xa/0xc
[  191.423602]  [<c1354e89>] schedule_hrtimeout+0xc/0xe
[  191.423606]  [<c103f197>] wait_task_inactive+0xc5/0xd6
[  191.423610]  [<c1037773>] kthread_bind+0x13/0x4b
[  191.423615]  [<c134721a>] _cpu_down+0x121/0x2b4
[  191.423619]  [<c13473d2>] cpu_down+0x25/0x34
[  191.423623]  [<c1348a16>] store_online+0x29/0x70
[  191.423627]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  191.423631]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  191.423635]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  191.423639]  [<c10ab946>] vfs_write+0x8c/0x122
[  191.423643]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  191.423647]  [<c10abb97>] sys_write+0x3b/0x60
[  191.423652]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  191.426368] BUG: scheduling while atomic: chcpu/2831/0x00000002
[  191.426371] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd e1000e ehci_hcd usbcore 3c59x mii usb_common sg
[  191.426387] Pid: 2831, comm: chcpu Not tainted 3.4.3-rt11 #29
[  191.426389] Call Trace:
[  191.426394]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  191.426399]  [<c1355394>] __schedule+0x68/0x571
[  191.426405]  [<c1008017>] ? sched_clock+0x9/0xd
[  191.426409]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  191.426413]  [<c1355942>] schedule+0x60/0x70
[  191.426417]  [<c1354962>] schedule_timeout+0x17/0x160
[  191.426421]  [<c135524d>] wait_for_common+0xa3/0xff
[  191.426425]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  191.426430]  [<c135532a>] wait_for_completion+0x12/0x14
[  191.426434]  [<c1347229>] _cpu_down+0x130/0x2b4
[  191.426439]  [<c13473d2>] cpu_down+0x25/0x34
[  191.426442]  [<c1348a16>] store_online+0x29/0x70
[  191.426446]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  191.426450]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  191.426454]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  191.426459]  [<c10ab946>] vfs_write+0x8c/0x122
[  191.426463]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  191.426467]  [<c10abb97>] sys_write+0x3b/0x60
[  191.426471]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  191.426507] BUG: scheduling while atomic: chcpu/2831/0x00000002
[  191.426509] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd e1000e ehci_hcd usbcore 3c59x mii usb_common sg
[  191.426525] Pid: 2831, comm: chcpu Not tainted 3.4.3-rt11 #29
[  191.426527] Call Trace:
[  191.426531]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  191.426535]  [<c1355394>] __schedule+0x68/0x571
[  191.426540]  [<c1008017>] ? sched_clock+0x9/0xd
[  191.426544]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  191.426549]  [<c1355942>] schedule+0x60/0x70
[  191.426553]  [<c1354962>] schedule_timeout+0x17/0x160
[  191.426557]  [<c135524d>] wait_for_common+0xa3/0xff
[  191.426561]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  191.426565]  [<c135532a>] wait_for_completion+0x12/0x14
[  191.426569]  [<c1037742>] kthread_stop+0x2d/0x4b
[  191.426574]  [<c10330fa>] destroy_worker+0x54/0x74
[  191.426578]  [<c1348d97>] workqueue_cpu_down_callback+0x193/0x251
[  191.426583]  [<c1185d7d>] ? compute_batch_value+0x19/0x29
[  191.426588]  [<c1353d7e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  191.426593]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  191.426597]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  191.426601]  [<c1025331>] __cpu_notify+0x15/0x29
[  191.426605]  [<c1347251>] _cpu_down+0x158/0x2b4
[  191.426610]  [<c13473d2>] cpu_down+0x25/0x34
[  191.426614]  [<c1348a16>] store_online+0x29/0x70
[  191.426617]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  191.426622]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  191.426626]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  191.426630]  [<c10ab946>] vfs_write+0x8c/0x122
[  191.426634]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  191.426638]  [<c10abb97>] sys_write+0x3b/0x60
[  191.426643]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  191.426650] BUG: scheduling while atomic: chcpu/2831/0x00000002
[  191.426652] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd e1000e ehci_hcd usbcore 3c59x mii usb_common sg
[  191.426667] Pid: 2831, comm: chcpu Not tainted 3.4.3-rt11 #29
[  191.426670] Call Trace:
[  191.426674]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  191.426678]  [<c1355394>] __schedule+0x68/0x571
[  191.426683]  [<c1008017>] ? sched_clock+0x9/0xd
[  191.426687]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  191.426691]  [<c1355942>] schedule+0x60/0x70
[  191.426695]  [<c1354962>] schedule_timeout+0x17/0x160
[  191.426699]  [<c135524d>] wait_for_common+0xa3/0xff
[  191.426703]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  191.426708]  [<c135532a>] wait_for_completion+0x12/0x14
[  191.426712]  [<c1037742>] kthread_stop+0x2d/0x4b
[  191.426716]  [<c10330fa>] destroy_worker+0x54/0x74
[  191.426720]  [<c1348d97>] workqueue_cpu_down_callback+0x193/0x251
[  191.426724]  [<c1185d7d>] ? compute_batch_value+0x19/0x29
[  191.426729]  [<c1353d7e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  191.426733]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  191.426738]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  191.426742]  [<c1025331>] __cpu_notify+0x15/0x29
[  191.426746]  [<c1347251>] _cpu_down+0x158/0x2b4
[  191.426751]  [<c13473d2>] cpu_down+0x25/0x34
[  191.426754]  [<c1348a16>] store_online+0x29/0x70
[  191.426758]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  191.426762]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  191.426766]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  191.426771]  [<c10ab946>] vfs_write+0x8c/0x122
[  191.426775]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  191.426779]  [<c10abb97>] sys_write+0x3b/0x60
[  191.426783]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  191.426789] BUG: scheduling while atomic: chcpu/2831/0x00000002
[  191.426791] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd e1000e ehci_hcd usbcore 3c59x mii usb_common sg
[  191.426807] Pid: 2831, comm: chcpu Not tainted 3.4.3-rt11 #29
[  191.426809] Call Trace:
[  191.426813]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  191.426817]  [<c1355394>] __schedule+0x68/0x571
[  191.426822]  [<c1008017>] ? sched_clock+0x9/0xd
[  191.426828]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  191.426832]  [<c1355942>] schedule+0x60/0x70
[  191.426836]  [<c1354962>] schedule_timeout+0x17/0x160
[  191.426840]  [<c135524d>] wait_for_common+0xa3/0xff
[  191.426845]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  191.426849]  [<c135532a>] wait_for_completion+0x12/0x14
[  191.426853]  [<c1037742>] kthread_stop+0x2d/0x4b
[  191.426857]  [<c10330fa>] destroy_worker+0x54/0x74
[  191.426861]  [<c1348d97>] workqueue_cpu_down_callback+0x193/0x251
[  191.426865]  [<c1185d7d>] ? compute_batch_value+0x19/0x29
[  191.426870]  [<c1353d7e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  191.426874]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  191.426879]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  191.426883]  [<c1025331>] __cpu_notify+0x15/0x29
[  191.426887]  [<c1347251>] _cpu_down+0x158/0x2b4
[  191.426892]  [<c13473d2>] cpu_down+0x25/0x34
[  191.426895]  [<c1348a16>] store_online+0x29/0x70
[  191.426899]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  191.426903]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  191.426907]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  191.426912]  [<c10ab946>] vfs_write+0x8c/0x122
[  191.426916]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  191.426920]  [<c10abb97>] sys_write+0x3b/0x60
[  191.426924]  [<c1357863>] sysenter_do_call+0x12/0x2c
[  191.426943] BUG: scheduling while atomic: chcpu/2831/0x00000002
[  191.426945] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd e1000e ehci_hcd usbcore 3c59x mii usb_common sg
[  191.426960] Pid: 2831, comm: chcpu Not tainted 3.4.3-rt11 #29
[  191.426963] Call Trace:
[  191.426967]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  191.426971]  [<c1355394>] __schedule+0x68/0x571
[  191.426976]  [<c1008017>] ? sched_clock+0x9/0xd
[  191.426980]  [<c10428f5>] ? sched_clock_local+0x11/0x12f
[  191.426985]  [<c1355942>] schedule+0x60/0x70
[  191.426988]  [<c1354962>] schedule_timeout+0x17/0x160
[  191.426993]  [<c135524d>] wait_for_common+0xa3/0xff
[  191.426997]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  191.427010]  [<c135532a>] wait_for_completion+0x12/0x14
[  191.427014]  [<c1037742>] kthread_stop+0x2d/0x4b
[  191.427019]  [<c10330fa>] destroy_worker+0x54/0x74
[  191.427023]  [<c1348d97>] workqueue_cpu_down_callback+0x193/0x251
[  191.427027]  [<c1185d7d>] ? compute_batch_value+0x19/0x29
[  191.427032]  [<c1353d7e>] ? percpu_counter_hotcpu_callback+0x13/0x8b
[  191.427036]  [<c103b6b9>] notifier_call_chain+0x26/0x48
[  191.427040]  [<c103b6fd>] __raw_notifier_call_chain+0xe/0x10
[  191.427044]  [<c1025331>] __cpu_notify+0x15/0x29
[  191.427049]  [<c1347251>] _cpu_down+0x158/0x2b4
[  191.427053]  [<c13473d2>] cpu_down+0x25/0x34
[  191.427057]  [<c1348a16>] store_online+0x29/0x70
[  191.427061]  [<c13489ed>] ? acpi_processor_start+0xf7/0xf7
[  191.427065]  [<c127b06f>] dev_attr_store+0x1b/0x23
[  191.427069]  [<c10eb6ce>] sysfs_write_file+0xae/0xe7
[  191.427073]  [<c10ab946>] vfs_write+0x8c/0x122
[  191.427077]  [<c10eb620>] ? sysfs_poll+0x77/0x77
[  191.427081]  [<c10abb97>] sys_write+0x3b/0x60
[  191.427086]  [<c1357863>] sysenter_do_call+0x12/0x2c
