Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2JWNJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:09:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55773 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2JWNJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:09:50 -0400
Message-ID: <5086971A.1070009@linaro.org>
Date: Tue, 23 Oct 2012 15:09:46 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [CPU hotplug, cpuidle_disable_device] BUG: unable to handle kernel
 NULL pointer dereference at (null)
References: <20121023124856.GA17692@localhost>
In-Reply-To: <20121023124856.GA17692@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 02:48 PM, Fengguang Wu wrote:

Hi Fengguang,

I believe this bug has been fixed by https://lkml.org/lkml/2012/10/8/87

Thanks for reporting the problem.

  -- Daniel

> Hi Daniel,
> 
> When doing CPU hotplug tests, I got the following bug
> 
> [   25.979429] KVM setup async PF for cpu 1
> [   25.980593] kvm-stealtime: cpu 1, msr 1f40d140
> [   25.982728] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [   25.982741] IP: [<ffffffff81678fad>] cpuidle_disable_device+0xc/0x5c
> [   25.982744] PGD 1adb6067 PUD 18d97067 PMD 0 
> [   25.982747] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [   25.982749] Modules linked in:
> [   25.982753] CPU 0 
> [   25.982753] Pid: 2273, comm: 01-cpu-hotplug Not tainted 3.6.0-00324-g8937cc5 #1290 Bochs Bochs
> [   25.982756] RIP: 0010:[<ffffffff81678fad>]  [<ffffffff81678fad>] cpuidle_disable_device+0xc/0x5c
> [   25.982760] RSP: 0018:ffff880018c75cd8  EFLAGS: 00010246
> [   25.982761] RAX: ffff880018c75fd8 RBX: ffff88001b49c000 RCX: ffff880018c3aaf0
> [   25.982762] RDX: 0000000000000006 RSI: ffff880018c3aaf0 RDI: 0000000000000000
> [   25.982764] RBP: ffff880018c75ce8 R08: ffff880018c75c88 R09: 000000000000000a
> [   25.982765] R10: ffff88001f20a000 R11: ffff880018c3aaf0 R12: 0000000000000000
> [   25.982766] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81ce2a70
> [   25.982767] FS:  00007f286a3fc700(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
> [   25.982769] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   25.982770] CR2: 0000000000000000 CR3: 0000000018c7c000 CR4: 00000000000006f0
> [   25.982774] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   25.982778] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   25.982779] Process 01-cpu-hotplug (pid: 2273, threadinfo ffff880018c74000, task ffff880018c3a350)
> [   25.982780] Stack:
> [   25.982782]  ffff88001b49c000 0000000000000000 ffff880018c75d18 ffffffff8137732f
> [   25.982785]  ffff88001b49c000 ffff88001b49c000 0000000000000002 ffffffff81c81c01
> [   25.982787]  ffff880018c75d48 ffffffff81374dd7 0000000000000001 0000000000000001
> [   25.982788] Call Trace:
> [   25.982799]  [<ffffffff8137732f>] acpi_processor_hotplug+0x55/0x97
> [   25.982801]  [<ffffffff81374dd7>] acpi_cpu_soft_notify+0x92/0xcd
> [   25.982804]  [<ffffffff817e1c2b>] notifier_call_chain+0x65/0x95
> [   25.982812]  [<ffffffff8105c9ae>] __raw_notifier_call_chain+0xe/0x10
> [   25.982816]  [<ffffffff810384ec>] __cpu_notify+0x20/0x37
> [   25.982819]  [<ffffffff81038516>] cpu_notify+0x13/0x15
> [   25.982834]  [<ffffffff817c57fb>] _cpu_up+0x16c/0x1ae
> [   25.982837]  [<ffffffff817c58ac>] cpu_up+0x6f/0x81
> [   25.982839]  [<ffffffff8178cffd>] store_online+0x5f/0x8f
> [   25.982847]  [<ffffffff813cb558>] dev_attr_store+0x18/0x24
> [   25.982857]  [<ffffffff81176ab0>] sysfs_write_file+0xee/0x126
> [   25.982865]  [<ffffffff81119129>] vfs_write+0xa6/0x132
> [   25.982868]  [<ffffffff811193b0>] sys_write+0x4c/0x80
> [   25.982871]  [<ffffffff817e581e>] tracesys+0xd0/0xd5
> [   25.982898] Code: d8 48 01 d6 48 81 fe ff ff ff 7f 48 0f 4e ce 41 89 4c 24 08 48 83 c4 28 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 53 <f6> 07 02 48 89 fb 74 43 e8 e2 05 00 00 48 85 c0 74 39 48 83 3d 
> [   25.982900] RIP  [<ffffffff81678fad>] cpuidle_disable_device+0xc/0x5c
> [   25.982901]  RSP <ffff880018c75cd8>
> [   25.982902] CR2: 0000000000000000
> 
> which is bisected to:
> 
> 3d339dcbb56d8d70c1b959aff87d74adc3a84eea is the first bad commit
> commit 3d339dcbb56d8d70c1b959aff87d74adc3a84eea
> Author: Daniel Lezcano <daniel.lezcano@linaro.org>
> Date:   Mon Sep 17 23:01:56 2012 +0200
> 
>     cpuidle / ACPI : move cpuidle_device field out of the acpi_processor_power structure
> 
> Thanks,
> Fengguang


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

