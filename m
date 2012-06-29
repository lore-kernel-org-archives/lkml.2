Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2F2Q7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:59:21 -0400
Received: from mail2.unitix.de ([176.9.2.175]:42804 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab2F2Q7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:59:19 -0400
Message-ID: <4FEDDED8.2050607@arndnet.de>
Date: Fri, 29 Jun 2012 18:59:04 +0200
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: 3.5.0-rc4: WARNING: at kernel/irq/manage.c:1214 __free_irq+0xa0/0x1d0()
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got below warning on suspend on my Thinkpad T510.
Not sure where this belongs to, ACPI?


[61844.171021] Suspending console(s) (use no_console_suspend to debug)
[61844.357443] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[61844.357551] sd 0:0:0:0: [sda] Stopping disk
[61844.610130] ACPI handle has no context!
[61844.610162] ------------[ cut here ]------------
[61844.610170] WARNING: at /home/arnd/Projekte/kernel/linux-2.6/kernel/irq/manage.c:1214 __free_irq+0xa0/0x1d0()
[61844.610171] Hardware name: 4384GEG
[61844.610171] Trying to free already-free IRQ 40
[61844.610243] Pid: 24945, comm: kworker/u:11 Tainted: G        W    3.5.0-rc4aha+ #6
[61844.610244] Call Trace:
[61844.610250]  [<ffffffff8105061f>] warn_slowpath_common+0x7f/0xc0
[61844.610252]  [<ffffffff81050716>] warn_slowpath_fmt+0x46/0x50
[61844.610257]  [<ffffffff8103ea39>] ? default_spin_lock_flags+0x9/0x10
[61844.610259]  [<ffffffff810dbae0>] __free_irq+0xa0/0x1d0
[61844.610263]  [<ffffffff8162d0ce>] ? _raw_spin_lock+0xe/0x20
[61844.610266]  [<ffffffff8107c0d0>] ? async_schedule+0x20/0x20
[61844.610268]  [<ffffffff810dbe05>] free_irq+0x55/0xd0
[61844.610275]  [<ffffffffa01894d8>] mei_pci_suspend+0x78/0xd0 [mei]
[61844.610280]  [<ffffffff81348b65>] pci_pm_suspend+0x75/0x140
[61844.610285]  [<ffffffff8140b3e0>] ? device_pm_wait_for_dev+0x30/0x30
[61844.610286]  [<ffffffff81348af0>] ? pci_pm_freeze+0xb0/0xb0
[61844.610289]  [<ffffffff8140b74b>] dpm_run_callback.isra.5+0x3b/0x80
[61844.610290]  [<ffffffff8140b84e>] __device_suspend+0xbe/0x250
[61844.610293]  [<ffffffff8140c19f>] async_suspend+0x1f/0xa0
[61844.610295]  [<ffffffff8107c14e>] async_run_entry_fn+0x7e/0x170
[61844.610298]  [<ffffffff8106e44a>] process_one_work+0x11a/0x480
[61844.610300]  [<ffffffff8106f308>] ? manage_workers.isra.28+0x1e8/0x230
[61844.610302]  [<ffffffff8106f4b5>] worker_thread+0x165/0x370
[61844.610304]  [<ffffffff8106f350>] ? manage_workers.isra.28+0x230/0x230
[61844.610306]  [<ffffffff810741b3>] kthread+0x93/0xa0
[61844.610310]  [<ffffffff816366e4>] kernel_thread_helper+0x4/0x10
[61844.610312]  [<ffffffff81074120>] ? kthread_freezable_should_stop+0x70/0x70
[61844.610314]  [<ffffffff816366e0>] ? gs_change+0x13/0x13
[61844.610315] ---[ end trace a264c7ac155dd162 ]---
[61844.617731] ACPI handle has no context!
[61844.633986] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[61844.641689] i915 0000:00:02.0: power state changed by ACPI to D3
[61844.944999] PM: suspend of devices complete after 775.764 msecs


Best regards
Arnd
