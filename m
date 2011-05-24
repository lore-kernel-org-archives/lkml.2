Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab1EXWjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1EXWjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:39:42 -0400
Subject: Re: [PATCH] pci, dmar: Update dmar units devices list during
 hotplug
From: Alex Williamson <alex.williamson@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4DDC26FE.6070207@kernel.org>
References: <4DC6E569.1060808@kernel.org> <1305843308.3100.10.camel@x201>
	 <1306234696.7218.14.camel@i7.infradead.org> <1306258959.3100.79.camel@x201>
		  <4DDC0858.3090406@kernel.org> <1306267639.3100.102.camel@x201>
	  <4DDC26FE.6070207@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 16:38:56 -0600
Message-ID: <1306276736.3100.107.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 14:45 -0700, Yinghai Lu wrote:
> No, it does not work.

I didn't say this wasn't without some effort, just thought it might give
you a jump start.

Alex

> [  592.792864] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [  592.793279] IP: [<ffffffff8136271a>] dmar_match_scope+0x27/0xb6
> [  592.804488] PGD 0 
> [  592.804629] Oops: 0000 [#1] SMP 
> [  592.804849] CPU 1 
> [  592.804947] Modules linked in:
> [  592.824426] 
> [  592.824521] Pid: 14498, comm: kworker/u:7 Tainted: G        W   2.6.39-tip-yh-06738-g5d55a15-dirty #1043 Oracle Corporation  Sun Fire X4800 M2 /     
> [  592.844637] RIP: 0010:[<ffffffff8136271a>]  [<ffffffff8136271a>] dmar_match_scope+0x27/0xb6
> [  592.864410] RSP: 0018:ffff881ffce45a70  EFLAGS: 00010293
> [  592.864673] RAX: 0000000000000000 RBX: 0000000000000008 RCX: 0000000000000000
> [  592.884403] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88fffeef6000
> [  592.904205] RBP: ffff881ffce45ab0 R08: 0000000000000000 R09: 0000000000000000
> [  592.904535] R10: 0000000000000000 R11: ffff88dffedda320 R12: 0000000000000000
> [  592.924419] R13: 0000000000000000 R14: ffff88fffeef6000 R15: 0000000000000000
> [  592.924748] FS:  0000000000000000(0000) GS:ffff88207d800000(0000) knlGS:0000000000000000
> [  592.944447] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  592.964196] CR2: 0000000000000010 CR3: 00000000023cb000 CR4: 00000000000006e0
> [  592.964541] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  592.984308] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  593.004091] Process kworker/u:7 (pid: 14498, threadinfo ffff881ffce44000, task ffff881ffce3c560)
> [  593.004492] Stack:
> [  593.024051]  ffff881ffce45a80 ffffffff8134bf6a ffff881ffce45ab0 ffff88407d002640
> [  593.024479]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> [  593.044272]  ffff881ffce45ae0 ffffffff81363e4a ffff881ffce45b00 ffff88dffe1c1d00
> [  593.064027] Call Trace:
> [  593.064156]  [<ffffffff8134bf6a>] ? pci_get_device+0x16/0x18
> [  593.064441]  [<ffffffff81363e4a>] device_to_iommu+0x4c/0x77
> [  593.084054]  [<ffffffff81364163>] domain_remove_one_dev_info+0x39/0x1fc
> [  593.084361]  [<ffffffff8136637f>] device_notifier+0x52/0x78
> [  593.104093]  [<ffffffff81c24cc3>] notifier_call_chain+0x68/0x9f
> [  593.123814]  [<ffffffff81193710>] ? sysfs_schedule_callback+0x1df/0x1df
> [  593.124125]  [<ffffffff8109f209>] __blocking_notifier_call_chain+0x4c/0x61
> [  593.143899]  [<ffffffff8109f232>] blocking_notifier_call_chain+0x14/0x16
> [  593.144207]  [<ffffffff81414909>] __device_release_driver+0xcd/0xd2
> [  593.163934]  [<ffffffff81414933>] device_release_driver+0x25/0x32
> [  593.164222]  [<ffffffff814144bd>] bus_remove_device+0x8e/0x9f
> [  593.183934]  [<ffffffff8141255e>] device_del+0x130/0x17f
> [  593.184186]  [<ffffffff814125c3>] device_unregister+0x16/0x23
> [  593.203888]  [<ffffffff813473e5>] pci_stop_bus_device+0x61/0x83
> [  593.223661]  [<ffffffff8134c88a>] ? remove_callback+0x1f/0x3c
> [  593.223932]  [<ffffffff813473b4>] pci_stop_bus_device+0x30/0x83
> [  593.243652]  [<ffffffff81347470>] pci_remove_bus_device+0x1a/0xba
> [  593.243955]  [<ffffffff8134c896>] remove_callback+0x2b/0x3c
> [  593.263631]  [<ffffffff8119372c>] sysfs_schedule_callback_work+0x1c/0x5f
> [  593.263962]  [<ffffffff8109433b>] process_one_work+0x231/0x3e6
> [  593.283667]  [<ffffffff810942ac>] ? process_one_work+0x1a2/0x3e6
> [  593.283958]  [<ffffffff81094829>] worker_thread+0x17c/0x240
> [  593.303651]  [<ffffffff810add32>] ? trace_hardirqs_on+0xd/0xf
> [  593.303927]  [<ffffffff810946ad>] ? manage_workers+0xab/0xab
> [  593.323617]  [<ffffffff81099ea5>] kthread+0xa0/0xa8
> [  593.323845]  [<ffffffff810adbcc>] ? trace_hardirqs_on_caller+0x1f/0x178
> [  593.343620]  [<ffffffff81c29614>] kernel_thread_helper+0x4/0x10
> [  593.343888]  [<ffffffff81c218c4>] ? _raw_spin_unlock_irq+0x30/0x36
> [  593.363642]  [<ffffffff810add32>] ? trace_hardirqs_on+0xd/0xf
> [  593.383357]  [<ffffffff81c21bc0>] ? retint_restore_args+0xe/0xe
> [  593.383624]  [<ffffffff81099e05>] ? __init_kthread_worker+0x5b/0x5b
> [  593.403441]  [<ffffffff81c29610>] ? gs_change+0xb/0xb
> [  593.403667] Code: 41 5f c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 66 66 66 66 90 45 31 ed 89 f3 49 89 d4 49 89 fe 44 0f b7 f9 eb 72 
> [  593.424146]  8b 44 24 10 49 8b 16 48 8b 80 88 00 00 00 44 3b 38 75 57 48 
> [  593.443684] RIP  [<ffffffff8136271a>] dmar_match_scope+0x27/0xb6
> [  593.443968]  RSP <ffff881ffce45a70>
> [  593.463319] CR2: 0000000000000010
> [  593.463510] ---[ end trace 75ddbb3d94414ea9 ]---
> [  593.465841] BUG: unable to handle kernel 
> 



