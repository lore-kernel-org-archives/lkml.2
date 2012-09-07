Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab2IGLdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:33:03 -0400
Received: from nm7-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.137]:30176 "HELO
	nm7-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760365Ab2IGLc6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:32:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 123837.83203.bm@omp1021.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KoSOKyK86r1QKbVREDKIjm/luKh03/8NXWaejYSk7tdMWEQDrGTq95FD6Grt/ytU8yaNXR8E7TLS1NvotG9g4pVKGivrAplzBwOnszoyNPAQPCN+EVMyhPnD8ErnS7spECLRzvJfRTIK/l/HYRVOTvbxFA2MBNV5uudt8/oQWG4=;
X-YMail-OSG: InUKY28VM1ndz5DVAFJYBygIZ5W5R2s842oikNSE6mDcn1H
 aEEV_m.zLPJyYH1p4Jyclf9rzBTL7jo7Yd9AhYqSah7HNKORXPp_S88o4nTT
 NwM0kZD6YvVUEk7lS7OaiQ2ORPos4y.60TP5UFXoc72JybOX6kOkM76VhikN
 MUZJmxYsnNhluWvhAz_NzGNmkrxTTXp2o_CYkpv_Azr.OSdYhpT598YeX0lT
 dQlLzgxN5c5Y2MC3ZzU9imgFf7zWhEKh98V3.fNxOeVLh7r6CMGTvHyIDKKh
 78ymh_CQRLbNIi1H1V9h0hagJCfe4ExfLub2vBT3FTE0Sx_1rbTVSLlyFzNJ
 QwXRVFlktowfyKWVL1mx3KXLalkn1BObozSQnqwGq8m2ufQvoUJq7QMmK8s8
 VrDCTzDT5vuGj42PiKsQ41ic8ETXw3lNiTXTgO3M1
X-Mailer: YahooMailWebService/0.8.121.416
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120826130152.GA20021@liondog.tnic> <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com> <20120827215952.GA18719@liondog.tnic> <1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120830095808.GB24680@liondog.tnic> <1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20547.48101.900727.735398@pilspetsen.it.uu.se>
Message-ID: <1347017576.44763.YahooMailNeo@web124703.mail.ne1.yahoo.com>
Date: Fri, 7 Sep 2012 04:32:56 -0700 (PDT)
From: Adko Branil <adkobranil@yahoo.com>
Reply-To: Adko Branil <adkobranil@yahoo.com>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Borislav Petkov <bp@alien8.de>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Dan Merillat <dan.merillat@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20547.48101.900727.735398@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After updating bios no more crashes happened, i tested it many times on heavy HDD IO loads, with many kernels (including CONFIG_PREEMPT kernels). But now if enable "Cool'n' Quiet" option in bios,  CONFIG_PREEMPT_VOLUNTARY kernel with passed "nosmp" at boot time, crashes during boot process with kernel panic, while  CONFIG_PREEMPT kernlel without "nosmp" works fine  - but it is another story i think, should not be related with the crashes when it was old bios, and i think it is probably "nosmp" the reason. (i have never changed cpu frequency of this cpu at all) When "Cool'n' Quiet" is disabled, the system works perfectly adequately with all kind of kernels i tried. Except that this warning message in dmesg still appears (if it is problem at all). I put here this message for "nosmp" case as well, kernel is 3.5.2:





[    1.912494] =================================
[    1.912494] [ INFO: inconsistent lock state ]
[    1.912494] 3.5.2 #4 Not tainted
[    1.912494] ---------------------------------
[    1.912494] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    1.912494] swapper/0/1 [HC1[1]:SC1[1]:HE0:SE0] takes:
[    1.912494]  (&(&host->lock)->rlock){?.+...}, at: [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
[    1.912494] {HARDIRQ-ON-W} state was registered at:
[    1.912494]   [<ffffffff810998fb>] __lock_acquire+0x61b/0x1af0
[    1.912494]   [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.912494]   [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
[    1.912494]   [<ffffffff8190b3c5>] pdc_sata_hardreset+0x85/0x100
[    1.912494]   [<ffffffff818eabba>] ata_do_reset+0x3a/0x90
[    1.912494]   [<ffffffff818edd72>] ata_eh_reset+0x372/0xe00
[    1.912494]   [<ffffffff818eec25>] ata_eh_recover+0x2a5/0x13d0
[    1.912494]   [<ffffffff818f073d>] ata_do_eh+0x4d/0xb0
[    1.912494]   [<ffffffff818f33ba>] ata_sff_error_handler+0xca/0x120
[    1.912494]   [<ffffffff8190a9e4>] pdc_error_handler+0x24/0x30
[    1.912494]   [<ffffffff818f029c>] ata_scsi_port_error_handler+0x47c/0x800
[    1.912494]   [<ffffffff818f06be>] ata_scsi_error+0x9e/0xd0
[    1.912494]   [<ffffffff816732e8>] scsi_error_handler+0xf8/0x500
[    1.912494]   [<ffffffff810654fe>] kthread+0xae/0xc0
[    1.912494]   [<ffffffff81b4f5f4>] kernel_thread_helper+0x4/0x10
[    1.912494] irq event stamp: 661637
[    1.912494] hardirqs last  enabled at (661636): [<ffffffff81049ff1>] __do_softirq+0x71/0x1f0
[    1.912494] hardirqs last disabled at (661637): [<ffffffff81b4da67>] common_interrupt+0x67/0x6c
[    1.912494] softirqs last  enabled at (661610): [<ffffffff8104a0b4>] __do_softirq+0x134/0x1f0
[    1.912494] softirqs last disabled at (661635): [<ffffffff81b4f6ec>] call_softirq+0x1c/0x30
[    1.912494] 
[    1.912494] other info that might help us debug this:
[    1.912494]  Possible unsafe locking scenario:
[    1.912494] 
[    1.912494]        CPU0
[    1.912494]        ----
[    1.912494]   lock(&(&host->lock)->rlock);
[    1.912494]   <Interrupt>
[    1.912494]     lock(&(&host->lock)->rlock);
[    1.912494] 
[    1.912494]  *** DEADLOCK ***
[    1.912494] 
[    1.912494] 5 locks held by swapper/0/1:
[    1.912494]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff81636b1b>] __driver_attach+0x5b/0xb0
[    1.912494]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81636b29>] __driver_attach+0x69/0xb0
[    1.912494]  #2:  (usb_bus_list_lock){+.+.+.}, at: [<ffffffff81954f95>] usb_add_hcd+0x295/0x6a0
[    1.912494]  #3:  (&__lockdep_no_validate__){......}, at: [<ffffffff816367ea>] device_attach+0x2a/0xc0
[    1.912494]  #4:  (&__lockdep_no_validate__){......}, at: [<ffffffff816367ea>] device_attach+0x2a/0xc0
[    1.912494] 
[    1.912494] stack backtrace:
[    1.912494] Pid: 1, comm: swapper/0 Not tainted 3.5.2 #4
[    1.912494] Call Trace:
[    1.912494]  <IRQ>  [<ffffffff81b35961>] print_usage_bug+0x1f7/0x208
[    1.912494]  [<ffffffff8101001f>] ? save_stack_trace+0x2f/0x50
[    1.912494]  [<ffffffff81098730>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[    1.912494]  [<ffffffff810992a2>] mark_lock+0x262/0x2a0
[    1.912494]  [<ffffffff810995b5>] ? __lock_acquire+0x2d5/0x1af0
[    1.912494]  [<ffffffff81099af3>] __lock_acquire+0x813/0x1af0
[    1.912494]  [<ffffffff810995b5>] ? __lock_acquire+0x2d5/0x1af0
[    1.912494]  [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.912494]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
[    1.912494]  [<ffffffff81079258>] ? cpuacct_charge+0xa8/0xf0
[    1.912494]  [<ffffffff81b4d151>] _raw_spin_lock_irqsave+0x41/0x60
[    1.912494]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
[    1.912494]  [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
[    1.912494]  [<ffffffff810061f2>] ? mask_and_ack_8259A+0x32/0x110
[    1.912494]  [<ffffffff810c2d5d>] handle_irq_event_percpu+0x5d/0x1f0
[    1.912494]  [<ffffffff810c2f38>] handle_irq_event+0x48/0x70
[    1.912494]  [<ffffffff8100622e>] ? mask_and_ack_8259A+0x6e/0x110
[    1.912494]  [<ffffffff810c5a3e>] ? handle_level_irq+0x1e/0xc0
[    1.912494]  [<ffffffff810c5a91>] handle_level_irq+0x71/0xc0
[    1.912494]  [<ffffffff81003ce2>] handle_irq+0x22/0x40
[    1.912494]  [<ffffffff81b4fdaa>] do_IRQ+0x5a/0xe0
[    1.912494]  [<ffffffff81b4da6c>] common_interrupt+0x6c/0x6c
[    1.912494]  [<ffffffff810c2f43>] ? handle_irq_event+0x53/0x70
[    1.912494]  [<ffffffff81049ff9>] ? __do_softirq+0x79/0x1f0
[    1.912494]  [<ffffffff81b4f6ec>] call_softirq+0x1c/0x30
[    1.912494]  [<ffffffff81003d85>] do_softirq+0x85/0xc0
[    1.912494]  [<ffffffff8104a425>] irq_exit+0xb5/0xc0
[    1.912494]  [<ffffffff81b4fdb3>] do_IRQ+0x63/0xe0
[    1.912494]  [<ffffffff81b4da6c>] common_interrupt+0x6c/0x6c
[    1.912494]  <EOI>  [<ffffffff8104378b>] ? vprintk_emit+0x16b/0x4c0
[    1.912494]  [<ffffffff81b34815>] printk_emit+0x31/0x33
[    1.912494]  [<ffffffff81138f64>] ? kfree+0xd4/0x160
[    1.912494]  [<ffffffff81632c97>] __dev_printk+0x127/0x240
[    1.912494]  [<ffffffff81138f25>] ? kfree+0x95/0x160
[    1.912494]  [<ffffffff8195818f>] ? usb_control_msg+0xef/0x130
[    1.912494]  [<ffffffff8109bd25>] ? trace_hardirqs_on_caller+0x105/0x190
[    1.912494]  [<ffffffff8109bdbd>] ? trace_hardirqs_on+0xd/0x10
[    1.912494]  [<ffffffff81632e03>] _dev_info+0x53/0x60
[    1.912494]  [<ffffffff8195159a>] hub_probe+0x3ea/0x850
[    1.912494]  [<ffffffff81b4b3de>] ? mutex_unlock+0xe/0x10
[    1.912494]  [<ffffffff8195b494>] usb_probe_interface+0x184/0x230
[    1.912494]  [<ffffffff8163692e>] driver_probe_device+0x7e/0x210
[    1.912494]  [<ffffffff81636b70>] ? __driver_attach+0xb0/0xb0
[    1.912494]  [<ffffffff81636bbb>] __device_attach+0x4b/0x60
[    1.912494]  [<ffffffff81634a4e>] bus_for_each_drv+0x4e/0xa0
[    1.912494]  [<ffffffff81636867>] device_attach+0xa7/0xc0
[    1.912494]  [<ffffffff81635ce0>] bus_probe_device+0xb0/0xe0
[    1.912494]  [<ffffffff8163404d>] device_add+0x5cd/0x6a0
[    1.912494]  [<ffffffff8195977e>] usb_set_configuration+0x4be/0x710
[    1.912494]  [<ffffffff81962fb3>] generic_probe+0x43/0xa0
[    1.912494]  [<ffffffff8195b56f>] usb_probe_device+0x2f/0x60
[    1.912494]  [<ffffffff8163692e>] driver_probe_device+0x7e/0x210
[    1.912494]  [<ffffffff81636b70>] ? __driver_attach+0xb0/0xb0
[    1.912494]  [<ffffffff81636bbb>] __device_attach+0x4b/0x60
[    1.912494]  [<ffffffff81634a4e>] bus_for_each_drv+0x4e/0xa0
[    1.912494]  [<ffffffff81636867>] device_attach+0xa7/0xc0
[    1.912494]  [<ffffffff81635ce0>] bus_probe_device+0xb0/0xe0
[    1.912494]  [<ffffffff8163404d>] device_add+0x5cd/0x6a0
[    1.912494]  [<ffffffff81951bdc>] usb_new_device+0x1dc/0x2a0
[    1.912494]  [<ffffffff8195506b>] usb_add_hcd+0x36b/0x6a0
[    1.912494]  [<ffffffff819641a9>] usb_hcd_pci_probe+0x249/0x3c0
[    1.912494]  [<ffffffff815a629f>] pci_device_probe+0xaf/0x130
[    1.912494]  [<ffffffff8163692e>] driver_probe_device+0x7e/0x210
[    1.912494]  [<ffffffff81636b6b>] __driver_attach+0xab/0xb0
[    1.912494]  [<ffffffff81636ac0>] ? driver_probe_device+0x210/0x210
[    1.912494]  [<ffffffff81634af5>] bus_for_each_dev+0x55/0x90
[    1.912494]  [<ffffffff82162f4d>] ? ohci_hcd_mod_init+0x54/0x54
[    1.912494]  [<ffffffff8163629e>] driver_attach+0x1e/0x20
[    1.912494]  [<ffffffff81635ff8>] bus_add_driver+0x1a8/0x270
[    1.912494]  [<ffffffff82162f4d>] ? ohci_hcd_mod_init+0x54/0x54
[    1.912494]  [<ffffffff81637217>] driver_register+0x77/0x150
[    1.912494]  [<ffffffff82162f4d>] ? ohci_hcd_mod_init+0x54/0x54
[    1.912494]  [<ffffffff815a4fff>] __pci_register_driver+0x6f/0xe0
[    1.912494]  [<ffffffff82162f4d>] ? ohci_hcd_mod_init+0x54/0x54
[    1.912494]  [<ffffffff82162f4d>] ? ohci_hcd_mod_init+0x54/0x54
[    1.912494]  [<ffffffff82162fcd>] uhci_hcd_init+0x80/0xc3
[    1.912494]  [<ffffffff82162f4d>] ? ohci_hcd_mod_init+0x54/0x54
[    1.912494]  [<ffffffff810002a2>] do_one_initcall+0x122/0x170
[    1.912494]  [<ffffffff8212cd03>] kernel_init+0x139/0x1bd
[    1.912494]  [<ffffffff8212c5af>] ? do_early_param+0x8c/0x8c
[    1.912494]  [<ffffffff81b4f5f4>] kernel_thread_helper+0x4/0x10
[    1.912494]  [<ffffffff81b4db19>] ? retint_restore_args+0xe/0xe
[    1.912494]  [<ffffffff8212cbca>] ? start_kernel+0x3bc/0x3bc
[    1.912494]  [<ffffffff81b4f5f0>] ? gs_change+0xb/0xb
[    3.201635] ata4.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
[    3.209975] ata4.00: 390721968 sectors, multi 16: LBA48 
[    3.218619] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    3.227150] ata2: SATA link down (SStatus 0 SControl 0)



Thanks.

Best regards
Adko.

