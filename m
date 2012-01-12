Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2ALGlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:41:04 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43591 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab2ALGlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:41:01 -0500
Date: Thu, 12 Jan 2012 08:40:43 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Mel Gorman <mgorman@suse.de>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Several bugs in latest kernel
In-Reply-To: <20120111190829.GG4118@suse.de>
Message-ID: <alpine.LFD.2.02.1201120840010.2054@tux.localdomain>
References: <4F0DCFFC.5040805@linux.vnet.ibm.com> <20120111190829.GG4118@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012, Mel Gorman wrote:
>> [ 7314.427769] CPU 3
>> [ 7314.427769] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod bnx2 ioatdma tpm_tis tpm cdc_ether usbnet i2c_i801 iTCO_wdt mii i7core_edac i2c_core dca edac_core iTCO_vendor_support rtc_cmos tpm_bios shpchp pci_hotplug button pcspkr serio_raw sg uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>> [ 7314.427769]
>> [ 7314.427769] Pid: 6699, comm: cron Tainted: G        W    3.2.0-0.0.0.28.36b5ec9-default #3 IBM IBM System x -[7870C4Q]-/68Y8033
>> [ 7314.427769] RIP: 0010:[<ffffffff8115bcf9>]  [<ffffffff8115bcf9>] cache_alloc_refill+0x1e9/0x290
>> [ 7314.427769] RSP: 0018:ffff8808c881bc48  EFLAGS: 00010046
>> [ 7314.427769] RAX: 000000000000000f RBX: ffff8808ca66b000 RCX: 0000000000000018
>> [ 7314.427769] RDX: ffff8808c7e2d040 RSI: ffff8808c8f60040 RDI: 0000000000000024
>> [ 7314.427769] RBP: ffff8808c881bc88 R08: ffff8808ff802510 R09: ffff8808ff802520
>> [ 7314.427769] R10: dead000000200200 R11: dead000000100100 R12: 0000000000000024
>> [ 7314.427769] R13: ffff8808ff800880 R14: ffff8808ff802500 R15: 0000000000000000
>> [ 7314.427769] FS:  00007fdcd8f54780(0000) GS:ffff8808ffcc0000(0000) knlGS:0000000000000000
>> [ 7314.427769] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 7314.427769] CR2: ffffffffff600400 CR3: 00000008c6e95000 CR4: 00000000000006e0
>> [ 7314.427769] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [ 7314.427769] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [ 7314.427769] Process cron (pid: 6699, threadinfo ffff8808c881a000, task ffff8808c68a0380)
>> [ 7314.427769] Stack:
>> [ 7314.427769]  ffffffff81785cf1 00000000000412d0 ffff8808ff802540 ffff8808ff800880
>> [ 7314.427769]  ffff8808ff800880 0000000000000100 00000000000000d0 00000000000000d0
>> [ 7314.427769]  ffff8808c881bcd8 ffffffff8115c7e7 ffff8808c881bd26 ffffffff81230418
>> [ 7314.427769] Call Trace:
>> [ 7314.427769]  [<ffffffff8115c7e7>] __kmalloc+0x327/0x330
>> [ 7314.427769]  [<ffffffff81230418>] ? aa_get_name+0x58/0x100
>> [ 7314.427769]  [<ffffffff81230418>] aa_get_name+0x58/0x100
>> [ 7314.427769]  [<ffffffff8120c229>] ? cap_bprm_set_creds+0x239/0x2a0
>> [ 7314.427769]  [<ffffffff81230d92>] apparmor_bprm_set_creds+0x112/0x580
>> [ 7314.427769]  [<ffffffff8109b44e>] ? __lock_release+0x7e/0x170
>> [ 7314.427769]  [<ffffffff81131e2e>] ? might_fault+0x4e/0xa0
>> [ 7314.427769]  [<ffffffff8120cbae>] security_bprm_set_creds+0xe/0x10
>> [ 7314.427769]  [<ffffffff8117b48a>] prepare_binprm+0xca/0x140
>> [ 7314.427769]  [<ffffffff8117d624>] do_execve_common+0x204/0x320
>> [ 7314.427769]  [<ffffffff8117d7ca>] do_execve+0x3a/0x40
>> [ 7314.427769]  [<ffffffff8100b079>] sys_execve+0x49/0x70
>> [ 7314.427769]  [<ffffffff8149c0fc>] stub_execve+0x6c/0xc0
>> [ 7314.427769] Code: 08 49 89 76 10 eb a6 0f 1f 00 49 8b 76 20 41 c7 86 90 00 00 00 01 00 00 00 49 39 f1 74 97 8b 46 20 41 3b 45 18 0f 82 02 ff ff ff <0f> 0b eb fe 0f 1f 00 41 39 c4 41 89 c7 45 0f 46 fc e9 ab fe ff
>> [ 7314.427769] RIP  [<ffffffff8115bcf9>] cache_alloc_refill+0x1e9/0x290
>> [ 7314.427769]  RSP <ffff8808c881bc48>
>
> This does not look familiar but I am not up to date on linux-mm. Pekka,
> does this ring a bell?

No, I don't think I've seen this before but it looks like a plain old 
slab corruption issue that's probably related to AppArmor.

 			Pekka
