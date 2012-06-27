Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2F0MLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:11:47 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:33154 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756556Ab2F0MLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:11:45 -0400
X-Greylist: delayed 1813 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2012 08:11:45 EDT
Message-ID: <4FEAF165.9090008@med.uni-frankfurt.de>
Date: Wed, 27 Jun 2012 13:41:25 +0200
From: Thomas Sattler <sattler@med.uni-frankfurt.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: scheduling while atomic: chcpu/6197/0x00000002
References: <4FDF00CB.7090703@med.uni-frankfurt.de> <4FDF201E.2090408@med.uni-frankfurt.de> <4FE19494.6000303@med.uni-frankfurt.de> <4FE86067.9010408@med.uni-frankfurt.de>
In-Reply-To: <4FE86067.9010408@med.uni-frankfurt.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux dragon 3.4.4-rt13 #2 SMP PREEMPT Tue Jun 26 12:22:23 CEST 2012
i686 Intel(R) Core(TM)2 CPU 6300 @ 1.86GHz GenuineIntel GNU/Linux

still BUG message in dmesg:

[  105.585086] BUG: scheduling while atomic: chcpu/2817/0x00000002
[  105.585090] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd ehci_hcd 3c59x usbcore e1000e mii usb_common sg
[  105.585109] Pid: 2817, comm: chcpu Not tainted 3.4.4-rt13 #2
[  105.585111] Call Trace:
[  105.585119]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  105.585124]  [<c1355474>] __schedule+0x68/0x571
[  105.585130]  [<c1045840>] ? enqueue_entity+0x313/0x3d8
[  105.585134]  [<c1355a22>] schedule+0x60/0x70
[  105.585138]  [<c1354a42>] schedule_timeout+0x17/0x160
[  105.585142]  [<c103ed57>] ? check_preempt_curr+0x29/0x64
[  105.585146]  [<c135532d>] wait_for_common+0xa3/0xff
[  105.585150]  [<c10412e2>] ? try_to_wake_up+0x391/0x391
[  105.585154]  [<c135540a>] wait_for_completion+0x12/0x14
[  105.585158]  [<c103781c>] kthread_create_on_node+0x71/0xb5
[  105.585162]  [<c102542c>] ? put_online_cpus+0x44/0x44
[  105.585167]  [<c1350101>] ? init_amd+0x42f/0x64f
[  105.585172]  [<c134727f>] _cpu_down+0x106/0x2b4
[  105.585176]  [<c102542c>] ? put_online_cpus+0x44/0x44
[  105.585180]  [<c1347452>] cpu_down+0x25/0x34
[  105.585183]  [<c1348a96>] store_online+0x29/0x70
[  105.585187]  [<c1348a6d>] ? acpi_processor_start+0xf7/0xf7
[  105.585192]  [<c127b0ef>] dev_attr_store+0x1b/0x23
[  105.585197]  [<c10eb73e>] sysfs_write_file+0xae/0xe7
[  105.585201]  [<c10ab9b6>] vfs_write+0x8c/0x122
[  105.585205]  [<c10eb690>] ? sysfs_poll+0x77/0x77
[  105.585209]  [<c10abc07>] sys_write+0x3b/0x60
[  105.585214]  [<c1357963>] sysenter_do_call+0x12/0x2c
[  105.585242] BUG: scheduling while atomic: chcpu/2817/0x00000002
[  105.585244] Modules linked in: loop rfcomm bnep btusb hid_microsoft
usbhid hid uhci_hcd ehci_hcd 3c59x usbcore e1000e mii usb_common sg
[  105.585260] Pid: 2817, comm: chcpu Not tainted 3.4.4-rt13 #2
[  105.585262] Call Trace:
[  105.585266]  [<c103df4d>] __schedule_bug+0x3d/0x42
[  105.585270]  [<c1355474>] __schedule+0x68/0x571
[  105.585275]  [<c1356ba1>] ? _raw_spin_unlock_irqrestore+0x1a/0x2f
[  105.585279]  [<c103a992>] ? __hrtimer_start_range_ns+0x2cf/0x2f6
[  105.585283]  [<c1355a22>] schedule+0x60/0x70
[  105.585287]  [<c1354f2a>] schedule_hrtimeout_range_clock+0xc5/0xec
[  105.585291]  [<c103a202>] ? update_rmtp+0x68/0x68
[  105.585295]  [<c1354f5b>] schedule_hrtimeout_range+0xa/0xc
[  105.585299]  [<c1354f69>] schedule_hrtimeout+0xc/0xe
[  105.585303]  [<c103f197>] wait_task_inactive+0xc5/0xd6
[  105.585307]  [<c1037773>] kthread_bind+0x13/0x4b
[  105.585312]  [<c134729a>] _cpu_down+0x121/0x2b4
[  105.585316]  [<c1347452>] cpu_down+0x25/0x34
[  105.585319]  [<c1348a96>] store_online+0x29/0x70
[  105.585323]  [<c1348a6d>] ? acpi_processor_start+0xf7/0xf7
[  105.585327]  [<c127b0ef>] dev_attr_store+0x1b/0x23
[  105.585331]  [<c10eb73e>] sysfs_write_file+0xae/0xe7
[  105.585335]  [<c10ab9b6>] vfs_write+0x8c/0x122
[  105.585339]  [<c10eb690>] ? sysfs_poll+0x77/0x77
[  105.585342]  [<c10abc07>] sys_write+0x3b/0x60
[  105.585347]  [<c1357963>] sysenter_do_call+0x12/0x2c

[...]
