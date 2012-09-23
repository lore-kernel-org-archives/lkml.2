Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2IWUdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:33:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35862 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2IWUdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:33:21 -0400
Date: Sun, 23 Sep 2012 16:33:13 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] PCI, x86: clear initial value for root info resources
Message-ID: <20120923203312.GA30816@konrad-lan.dumpdata.com>
References: <CAE9FiQW0PpBU0N9VzJyNKK9PvaUwokCYeB6w_j4mcN9EV0geLQ@mail.gmail.com>
 <1348076941-410-1-git-send-email-yinghai@kernel.org>
 <20120921165025.GF4780@phenom.dumpdata.com>
 <CAE9FiQV9WK4NG5+aGwVrGO3ueFH3TmmmG5zea+JjwgtQyngNRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV9WK4NG5+aGwVrGO3ueFH3TmmmG5zea+JjwgtQyngNRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:27:00AM -0700, Yinghai Lu wrote:
> On Fri, Sep 21, 2012 at 9:50 AM, Konrad Rzeszutek Wilk
> <konrad@kernel.org> wrote:
> > On Wed, Sep 19, 2012 at 10:49:00AM -0700, Yinghai Lu wrote:
> >
> > Can you include the stack trace?
> 
> [  414.997281] pci_bus 0000:00: freeing pci_bus info
> [  415.017221]  pci0000:00: freeing pci_host_bridge info
> [  415.017468] general protection fault: 0000 [#1] SMP
> [  415.036758] Modules linked in:
> [  415.036959] CPU 0
> [  415.037051] Pid: 4, comm: kworker/0:0 Not tainted
> 3.6.0-rc6-yh-03463-gbcab6f1-dirty #303 Oracle Corporation  Sun Fire
> X4800 M2 /
> [  415.056989] RIP: 0010:[<ffffffff81075218>]  [<ffffffff81075218>]
> __release_resource+0x11/0x3e
> [  415.076854] RSP: 0018:ffff883f4cea39f0  EFLAGS: 00010206
> [  415.077112] RAX: 0d00000000000030 RBX: ffff897ea6cd4070 RCX: 8c6318c6318c6320
> [  415.097000] RDX: ffff883f9d60e190 RSI: ffffffff8265f228 RDI: ffff897ea6cd4070
> [  415.116627] RBP: ffff883f4cea39f0 R08: 0000000000000005 R09: ffffffff810755de
> [  415.116953] R10: ffffffff81e2e7df R11: 0000000000000000 R12: 0000000000000002
> [  415.136790] R13: ffff897ea6d18600 R14: ffffffff826f18c0 R15: ffff883f9d60d800
> [  415.156541] FS:  0000000000000000(0000) GS:ffff883f9d600000(0000)
> knlGS:0000000000000000
> [  415.156953] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  415.176622] CR2: 0000000000619718 CR3: 000000000263f000 CR4: 00000000000007f0
> [  415.196401] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  415.196761] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  415.216702] Process kworker/0:0 (pid: 4, threadinfo
> ffff883f4cea2000, task ffff883f4cea8000)
> [  415.236370] Stack:
> [  415.236475]  ffff883f4cea3a20 ffffffff810755e6 ffff883f4cea3a60
> ffff883f00000000
> [  415.236866]  ffffffff824884ad ffff88fea6ce2440 ffff883f4cea3a40
> ffffffff81c2cfc5
> [  415.256682]  ffff88bf4a1ec800 ffff88bf4a1ec800 ffff883f4cea3a50
> ffffffff81c2d023
> [  415.276452] Call Trace:
> [  415.276611]  [<ffffffff810755e6>] release_resource+0x25/0x3e
> [  415.296206]  [<ffffffff81c2cfc5>] __release_pci_root_info+0x35/0x7e
> [  415.296556]  [<ffffffff81c2d023>] release_pci_root_info+0x15/0x1a
> [  415.316249]  [<ffffffff813f568a>] pci_release_bus_bridge_dev+0x37/0x4f
> [  415.316581]  [<ffffffff815c04d8>] device_release+0x93/0xcb
> [  415.336365]  [<ffffffff813d5888>] kobject_release+0x51/0x67
> [  415.336666]  [<ffffffff813d579a>] kobject_put+0x4a/0x4e
> [  415.361466]  [<ffffffff815c026a>] put_device+0x17/0x19
> [  415.361734]  [<ffffffff813f75b2>] pci_remove_root_bus+0x5a/0x64
> [  415.376188]  [<ffffffff81437dd8>] acpi_pci_root_remove+0xeb/0x114
> [  415.376509]  [<ffffffff81434c13>] acpi_device_remove+0x86/0xa5
> [  415.396230]  [<ffffffff815c33b6>] __device_release_driver+0x86/0xdc
> [  415.396551]  [<ffffffff815c3431>] device_release_driver+0x25/0x32
> [  415.416198]  [<ffffffff8143658b>] acpi_bus_trim+0x86/0x110
> [  415.416473]  [<ffffffff81439ae1>] handle_root_bridge_removal+0x4f/0x118
> [  415.436227]  [<ffffffff81439c8b>] _handle_hotplug_event_root+0xe1/0x121
> [  415.455957]  [<ffffffff81085515>] process_one_work+0x28a/0x453
> [  415.456228]  [<ffffffff81085480>] ? process_one_work+0x1f5/0x453
> [  415.475980]  [<ffffffff81439baa>] ? handle_root_bridge_removal+0x118/0x118
> [  415.476311]  [<ffffffff81085bd1>] worker_thread+0x12a/0x201
> [  415.495995]  [<ffffffff81085aa7>] ? manage_workers+0xed/0xed
> [  415.496301]  [<ffffffff8108b93a>] kthread+0xe7/0xef
> [  415.515957]  [<ffffffff81e2ef03>] ? _raw_spin_unlock_irq+0x2e/0x33
> [  415.516257]  [<ffffffff81e372e4>] kernel_thread_helper+0x4/0x10
> [  415.535926]  [<ffffffff81e2f259>] ? retint_restore_args+0xe/0xe
> [  415.536242]  [<ffffffff8108b853>] ? __init_kthread_worker+0x5a/0x5a
> [  415.555959]  [<ffffffff81e372e0>] ? gs_change+0xb/0xb
> [  415.556209] Code: 48 89 31 48 89 46 20 31 c0 eb 0d 48 39 7a 08 48
> 8d 4a 28 72 da 48 89 d0 5d c3 66 66 66 66 90 48 8b 47 20 55 48 89 e5
> 48 83 c0 30 <48> 8b 10 48 85 d2 74 1e 48 39 fa 75 13 48 8b 57 28 48 89
> 10 48
> [  415.596509] RIP  [<ffffffff81075218>] __release_resource+0x11/0x3e
> [  415.615741]  RSP <ffff883f4cea39f0>
> [  415.616020] ---[ end trace 8bcbc1bea9c3e0bc ]---
> 
> whole log is attached.

I meant it (and a filtered with just the valid lines in it) in terms of the patch commit description.
