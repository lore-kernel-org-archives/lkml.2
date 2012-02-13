Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2BMDET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 22:04:19 -0500
Received: from ozlabs.org ([203.10.76.45]:52468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab2BMDEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 22:04:16 -0500
From: Michael Neuling <mikey@neuling.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        linux-next@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Milton Miller <miltonm@bga.com>
Subject: Re: Boot failure with next-20120208
In-reply-to: <20120212113805.c7e5d902c95a9d0f4037e12c@canb.auug.org.au>
References: <20120212113805.c7e5d902c95a9d0f4037e12c@canb.auug.org.au>
Comments: In-reply-to Stephen Rothwell <sfr@canb.auug.org.au>
   message dated "Sun, 12 Feb 2012 11:38:05 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Mon, 13 Feb 2012 14:04:14 +1100
Message-ID: <16788.1329102254@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just a quick note to say I got a boot OOPs with next-20120208 and 9 on a
> Power7 blade (my other PowerPC boot tests are ok.  I'll investigate this
> further on Monday.
>
> The line referenced below is:
>
> BUG_ON(!kobj || !kobj->sd || !attr);
>
> in sysfs_create_file().
> 
> calling  .topology_init+0x0/0x1ac @ 1
> initcall 7_.async_cpu_up+0x0/0x40 returned 0 after 9765 usecs
> async_continuing @ 20 after 9765 usec
> ------------[ cut here ]------------
> kernel BUG at fs/sysfs/file.c:573!
> Oops: Exception in kernel mode, sig: 5 [#1]
> SMP NR_CPUS=32 NUMA pSeries
> Modules linked in:
> NIP: c00000000024a35c LR: c0000000004ee050 CTR: c00000000083ca24
> REGS: c0000003fd9e7560 TRAP: 0700   Not tainted  (3.3.0-rc2-autokern1)
> MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 88002082  XER: 0000000f
> CFAR: c00000000024a370
> TASK = c0000003fd9e8000[20] 'kworker/u:6' THREAD: c0000003fd9e4000 CPU: 0
> GPR00: 0000000000000001 c0000003fd9e77e0 c000000000d19bb8 0000000000000000 
> GPR04: c000000000bf37a8 0000000000000008 8000000002096400 0000000000000000 
> GPR08: 0000000000000000 c000000000f80028 c000000000d52bd8 0000000000000000 
> GPR12: 0000000048002088 c00000000f33b000 0000000001affa78 00000000009aa000 
> GPR16: 0000000000e1f3c8 0000000002d517f0 0000000001aff984 0000000000000060 
> GPR20: 0000000000000000 ffffffffffffffff 0000000000000000 c000000000c45128 
> GPR24: 0000000000000000 0000000000000008 0000000000000000 c000000000c44200 
> GPR28: c000000000f80028 0000000000000008 c000000000c85038 0000000000000002 
> NIP [c00000000024a35c] .sysfs_create_file+0x1c/0x40
> LR [c0000000004ee050] .device_create_file+0x20/0x40
> Call Trace:
> [c0000003fd9e77e0] [c0000003fd9e78a0] 0xc0000003fd9e78a0 (unreliable)
> [c0000003fd9e7850] [c00000000083c9a4] .register_cpu_online+0x1d0/0x250
> [c0000003fd9e7900] [c00000000083ca8c] .sysfs_cpu_notify+0x68/0x28c
> [c0000003fd9e79b0] [c00000000083769c] .notifier_call_chain+0x9c/0x100
> [c0000003fd9e7a50] [c0000000000a5878] .__cpu_notify+0x38/0x80
> [c0000003fd9e7ad0] [c00000000083e124] ._cpu_up+0x10c/0x178
> [c0000003fd9e7b90] [c00000000083e2c8] .cpu_up+0x138/0x164
> [c0000003fd9e7c20] [c000000000ba46d0] .async_cpu_up+0x28/0x40
> [c0000003fd9e7ca0] [c0000000000d81ec] .async_run_entry_fn+0xbc/0x1f0
> [c0000003fd9e7d50] [c0000000000c7cbc] .process_one_work+0x19c/0x590
> [c0000003fd9e7e10] [c0000000000c8618] .worker_thread+0x188/0x4b0
> [c0000003fd9e7ed0] [c0000000000ce57c] .kthread+0xbc/0xd0
> [c0000003fd9e7f90] [c000000000021448] .kernel_thread+0x54/0x70
> Instruction dump:
> 7fa3eb78 ebe1fff8 eba1ffe8 7c0803a6 4e800020 2c230000 41820024 e8630030 
> 7c800074 7800d182 2fa30000 419e0014 <0b000000> 38a00002 4bfffebc e8630030 
> ---[ end trace 31fd0ba7d8756001 ]---
> initcall .topology_init+0x0/0x1ac returned 0 after 0 usecs
> calling  .pcibios_init+0x0/0xe8 @ 1
> PCI: Probing PCI hardware
> PCI: Probing PCI hardware done
> initcall .pcibios_init+0x0/0xe8 returned 0 after 0 usecs
> calling  .add_system_ram_resources+0x0/0x140 @ 1
> initcall .add_system_ram_resources+0x0/0x140 returned 0 after 0 usecs
> calling  .__machine_initcall_powermac_pmac_i2c_create_platform_devices+0x0/0xc8 @ 1
> initcall .__machine_initcall_powermac_pmac_i2c_create_platform_devices+0x0/0xc8 returned 0 after 0 usecs
> calling  .opal_init+0x0/0x1cc @ 1
> opal: Node not found
> initcall .opal_init+0x0/0x1cc returned -19 after 0 usecs
> calling  .__machine_initcall_pseries_ioei_init+0x0/0xa0 @ 1

Reverting "smp: start up non-boot CPUs asynchronously" (8de7a96405 from
next-20120208) fixes this problem for me.  

Only hit it when on a 32 thread (8 core 4 thread) POWER7 box.  Smaller
configs didn't hit it.

Adding Arjan who owns this to the CC.

Mikey
