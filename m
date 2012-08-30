Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2H3LKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:10:12 -0400
Received: from nm36-vm3.bullet.mail.ne1.yahoo.com ([98.138.229.115]:42856 "HELO
	nm36-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752851Ab2H3LKJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:10:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 354317.63388.bm@omp1057.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=DRQNd9TMSjFO8Oj7HosTEd72lc/dKXCtkfwaL6G2p/4Ul3EaZaDYYp3H/ol/4keFkyRwonBW8qQROFilffyGsk3iDmjrF5qjya7IXzwVG427SvUP7dMKm60G5um0KW/CzNuUIxXmEwT8EkQudwPHrFQuMLRM5m/v0O0oOFJNwgA=;
X-YMail-OSG: cSIIgWYVM1nKF.IGiLtSEu4ni28Hd.VI48JWnk5f8BZ.NdP
 Szrv1jV4DKiCfeKIN7FLOisFBYDvr7AFylh5Z6DQds.L7np_vmzkC4hyR_Lx
 i1pIuzGrd6blNQkeInKEggnRx4wqXrytLPC2SW86HbWYn2n3Zff0Q2nyfiNm
 adxb4XzxHGxufQhxrUqX1pPq.361OMFip1CA_u0Uqsw_pV4y088mJXhmucwz
 Yg7mRD4TSQBIns3G8pLdJiaOcrngNDwbOlHH1PDsSOc_QWRABt454qpCD2I.
 wD6fFyWRzG4laV2TlrGoiCCGJrWfhvm5DW8CTY_AQo_fsCqEQM1VGxLB3Lcd
 5mrpToKmGnJH4J3GiZC5V23dJEbaQ.c6._Q_WV_Mt8RQ9tsg6S6oAX6YgWpc
 OEA.TXRZ10iQNTvE9pEJUBhzqwVuJa2vkxbWo98hd
X-Mailer: YahooMailWebService/0.8.121.416
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120826130152.GA20021@liondog.tnic> <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com> <20120827215952.GA18719@liondog.tnic> <1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120830095808.GB24680@liondog.tnic>
Message-ID: <1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com>
Date: Thu, 30 Aug 2012 04:10:07 -0700 (PDT)
From: Adko Branil <adkobranil@yahoo.com>
Reply-To: Adko Branil <adkobranil@yahoo.com>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
To: Borislav Petkov <bp@alien8.de>, Jeff Garzik <jgarzik@pobox.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-ide <linux-ide@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20120830095808.GB24680@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Right near the end there's a lockdep warning about a deadlock

>between sata_promise's hardreset thing and the machine getting a
>ata_bmdma_interrupt.

>But since I don't know this code, it would be nice if you could take a
>look at it.

I picked up 3 more dmesg after rebooting, and 2 more oopses.
 I will put here just pieces from dmesgs about these locks, they differs slightly each-other:

***********************************************************************************
1.


[    1.859215] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.943678] 
[    1.943679] =================================
[    1.943680] [ INFO: inconsistent lock state ]
[    1.943682] 3.5.2 #4 Not tainted
[    1.943683] ---------------------------------
[    1.943684] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    1.943686] swapper/1/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    1.943687]  (&(&host->lock)->rlock){?.+...}, at: [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
[    1.943695] {HARDIRQ-ON-W} state was registered at:
[    1.943696]   [<ffffffff810998fb>] __lock_acquire+0x61b/0x1af0
[    1.943701]   [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.943703]   [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
[    1.943708]   [<ffffffff8190b3c5>] pdc_sata_hardreset+0x85/0x100
[    1.943711]   [<ffffffff818eabba>] ata_do_reset+0x3a/0x90
[    1.943713]   [<ffffffff818edd72>] ata_eh_reset+0x372/0xe00
[    1.943716]   [<ffffffff818eec25>] ata_eh_recover+0x2a5/0x13d0
[    1.943718]   [<ffffffff818f073d>] ata_do_eh+0x4d/0xb0
[    1.943721]   [<ffffffff818f33ba>] ata_sff_error_handler+0xca/0x120
[    1.943723]   [<ffffffff8190a9e4>] pdc_error_handler+0x24/0x30
[    1.943725]   [<ffffffff818f029c>] ata_scsi_port_error_handler+0x47c/0x800
[    1.943728]   [<ffffffff818f06be>] ata_scsi_error+0x9e/0xd0
[    1.943730]   [<ffffffff816732e8>] scsi_error_handler+0xf8/0x500
[    1.943734]   [<ffffffff810654fe>] kthread+0xae/0xc0
[    1.943737]   [<ffffffff81b4f5f4>] kernel_thread_helper+0x4/0x10
[    1.943740] irq event stamp: 51304
[    1.943741] hardirqs last  enabled at (51301): [<ffffffff8100ab7d>] default_idle+0x5d/0x1b0
[    1.943745] hardirqs last disabled at (51302): [<ffffffff81b4da67>] common_interrupt+0x67/0x6c
[    1.943748] softirqs last  enabled at (51304): [<ffffffff810498d3>] _local_bh_enable+0x13/0x20
[    1.943752] softirqs last disabled at (51303): [<ffffffff8104a355>] irq_enter+0x75/0x90
[    1.943754] 
[    1.943754] other info that might help us debug this:
[    1.943755]  Possible unsafe locking scenario:
[    1.943755] 
[    1.943755]        CPU0
[    1.943755]        ----
[    1.943756]   lock(&(&host->lock)->rlock);
[    1.943757]   <Interrupt>
[    1.943758]     lock(&(&host->lock)->rlock);
[    1.943759] 
[    1.943759]  *** DEADLOCK ***
[    1.943759] 
[    1.943760] no locks held by swapper/1/0.
[    1.943760] 
[    1.943760] stack backtrace:
[    1.943762] Pid: 0, comm: swapper/1 Not tainted 3.5.2 #4
[    1.943762] Call Trace:
[    1.943763]  <IRQ>  [<ffffffff81b35961>] print_usage_bug+0x1f7/0x208
[    1.943768]  [<ffffffff8101001f>] ? save_stack_trace+0x2f/0x50
[    1.943772]  [<ffffffff81098730>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[    1.943774]  [<ffffffff810992a2>] mark_lock+0x262/0x2a0
[    1.943776]  [<ffffffff81099af3>] __lock_acquire+0x813/0x1af0
[    1.943779]  [<ffffffff810c9920>] ? force_qs_rnp+0x40/0x180
[    1.943782]  [<ffffffff81076f93>] ? try_to_wake_up+0x1c3/0x2d0
[    1.943786]  [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.943788]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
[    1.943791]  [<ffffffff81b4d151>] _raw_spin_lock_irqsave+0x41/0x60
[    1.943794]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
[    1.943796]  [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
[    1.943799]  [<ffffffff810c2d5d>] handle_irq_event_percpu+0x5d/0x1f0
[    1.943801]  [<ffffffff810c2f38>] handle_irq_event+0x48/0x70
[    1.943803]  [<ffffffff81b4d059>] ? _raw_spin_lock+0x39/0x40
[    1.943806]  [<ffffffff810c5f0e>] ? handle_fasteoi_irq+0x1e/0xf0
[    1.943808]  [<ffffffff810c5f4a>] handle_fasteoi_irq+0x5a/0xf0
[    1.943810]  [<ffffffff81003ce2>] handle_irq+0x22/0x40
[    1.943813]  [<ffffffff81b4fdaa>] do_IRQ+0x5a/0xe0
[    1.943816]  [<ffffffff81b4da6c>] common_interrupt+0x6c/0x6c
[    1.943819]  <EOI>  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
[    1.943822]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[    1.943824]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
[    1.943827]  [<ffffffff81b2c7db>] start_secondary+0x1dd/0x1e4
[    1.943854] ata4.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
[    1.943856] ata4.00: 390721968 sectors, multi 16: LBA48 
[    1.965556] ata4.00: configured for UDMA/133
[    2.028035] ata2: SATA link down (SStatus 0 SControl 300)



*************************************************************************
2.

[    1.760599] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.943627] 
[    1.943628] =================================
[    1.943628] [ INFO: inconsistent lock state ]
[    1.943630] 3.5.2 #4 Not tainted
[    1.943631] ---------------------------------
[    1.943632] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    1.943634] swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    1.943635]  (&(&host->lock)->rlock){?.+...}, at: [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
[    1.943644] {HARDIRQ-ON-W} state was registered at:
[    1.943645]   [<ffffffff810998fb>] __lock_acquire+0x61b/0x1af0
[    1.943649]   [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.943652]   [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
[    1.943656]   [<ffffffff8190b3c5>] pdc_sata_hardreset+0x85/0x100
[    1.943659]   [<ffffffff818eabba>] ata_do_reset+0x3a/0x90
[    1.943661]   [<ffffffff818edd72>] ata_eh_reset+0x372/0xe00
[    1.943664]   [<ffffffff818eec25>] ata_eh_recover+0x2a5/0x13d0
[    1.943666]   [<ffffffff818f073d>] ata_do_eh+0x4d/0xb0
[    1.943668]   [<ffffffff818f33ba>] ata_sff_error_handler+0xca/0x120
[    1.943671]   [<ffffffff8190a9e4>] pdc_error_handler+0x24/0x30
[    1.943673]   [<ffffffff818f029c>] ata_scsi_port_error_handler+0x47c/0x800
[    1.943675]   [<ffffffff818f06be>] ata_scsi_error+0x9e/0xd0
[    1.943677]   [<ffffffff816732e8>] scsi_error_handler+0xf8/0x500
[    1.943680]   [<ffffffff810654fe>] kthread+0xae/0xc0
[    1.943683]   [<ffffffff81b4f5f4>] kernel_thread_helper+0x4/0x10
[    1.943687] irq event stamp: 73472
[    1.943688] hardirqs last  enabled at (73469): [<ffffffff8100ab7d>] default_idle+0x5d/0x1b0
[    1.943691] hardirqs last disabled at (73470): [<ffffffff81b4da67>] common_interrupt+0x67/0x6c
[    1.943694] softirqs last  enabled at (73472): [<ffffffff810498d3>] _local_bh_enable+0x13/0x20
[    1.943698] softirqs last disabled at (73471): [<ffffffff8104a355>] irq_enter+0x75/0x90
[    1.943701] 
[    1.943701] other info that might help us debug this:
[    1.943701]  Possible unsafe locking scenario:
[    1.943701] 
[    1.943701]        CPU0
[    1.943702]        ----
[    1.943702]   lock(&(&host->lock)->rlock);
[    1.943704]   <Interrupt>
[    1.943704]     lock(&(&host->lock)->rlock);
[    1.943705] 
[    1.943705]  *** DEADLOCK ***
[    1.943705] 
[    1.943706] no locks held by swapper/0/0.
[    1.943706] 
[    1.943706] stack backtrace:
[    1.943708] Pid: 0, comm: swapper/0 Not tainted 3.5.2 #4
[    1.943709] Call Trace:
[    1.943710]  <IRQ>  [<ffffffff81b35961>] print_usage_bug+0x1f7/0x208
[    1.943715]  [<ffffffff8101001f>] ? save_stack_trace+0x2f/0x50
[    1.943718]  [<ffffffff81098730>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[    1.943720]  [<ffffffff810992a2>] mark_lock+0x262/0x2a0
[    1.943723]  [<ffffffff81099af3>] __lock_acquire+0x813/0x1af0
[    1.943725]  [<ffffffff8107da11>] ? load_balance+0xd1/0x730
[    1.943728]  [<ffffffff8107baa0>] ? update_cfs_shares+0x100/0x100
[    1.943731]  [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.943733]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
[    1.943736]  [<ffffffff81b4d151>] _raw_spin_lock_irqsave+0x41/0x60
[    1.943738]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
[    1.943741]  [<ffffffff8107e070>] ? load_balance+0x730/0x730
[    1.943743]  [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
[    1.943746]  [<ffffffff810c2d5d>] handle_irq_event_percpu+0x5d/0x1f0
[    1.943748]  [<ffffffff810c2f38>] handle_irq_event+0x48/0x70
[    1.943750]  [<ffffffff81b4d059>] ? _raw_spin_lock+0x39/0x40
[    1.943753]  [<ffffffff810c5f0e>] ? handle_fasteoi_irq+0x1e/0xf0
[    1.943755]  [<ffffffff810c5f4a>] handle_fasteoi_irq+0x5a/0xf0
[    1.943757]  [<ffffffff81003ce2>] handle_irq+0x22/0x40
[    1.943761]  [<ffffffff81b4fdaa>] do_IRQ+0x5a/0xe0
[    1.943763]  [<ffffffff81b4da6c>] common_interrupt+0x6c/0x6c
[    1.943766]  <EOI>  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
[    1.943769]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[    1.943771]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
[    1.943774]  [<ffffffff81b0014e>] rest_init+0xb2/0xc4
[    1.943777]  [<ffffffff81b0009c>] ? csum_partial_copy_generic+0x16c/0x16c
[    1.943779]  [<ffffffff8212cbbd>] start_kernel+0x3af/0x3bc
[    1.943782]  [<ffffffff8212c60d>] ? repair_env_string+0x5e/0x5e
[    1.943784]  [<ffffffff8212c32d>] x86_64_start_reservations+0x131/0x135
[    1.943787]  [<ffffffff8212c409>] x86_64_start_kernel+0xd8/0xdc
[    1.943812] ata4.00: ATA-6: ST3200822AS, 3.01, max UDMA/133



************************************************************************
3
[    1.938534] =================================
[    1.938535] [ INFO: inconsistent lock state ]
[    1.938537] 3.5.2 #4 Not tainted
[    1.938538] ---------------------------------
[    1.938539] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    1.938540] swapper/1/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    1.938542]  (&(&host->lock)->rlock){?.+...}, at: [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
[    1.938550] {HARDIRQ-ON-W} state was registered at:
[    1.938551]   [<ffffffff810998fb>] __lock_acquire+0x61b/0x1af0
[    1.938556]   [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.938558]   [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
[    1.938563]   [<ffffffff8190b3c5>] pdc_sata_hardreset+0x85/0x100
[    1.938565]   [<ffffffff818eabba>] ata_do_reset+0x3a/0x90
[    1.938568]   [<ffffffff818edd72>] ata_eh_reset+0x372/0xe00
[    1.938571]   [<ffffffff818eec25>] ata_eh_recover+0x2a5/0x13d0
[    1.938573]   [<ffffffff818f073d>] ata_do_eh+0x4d/0xb0
[    1.938575]   [<ffffffff818f33ba>] ata_sff_error_handler+0xca/0x120
[    1.938578]   [<ffffffff8190a9e4>] pdc_error_handler+0x24/0x30
[    1.938580]   [<ffffffff818f029c>] ata_scsi_port_error_handler+0x47c/0x800
[    1.938583]   [<ffffffff818f06be>] ata_scsi_error+0x9e/0xd0
[    1.938585]   [<ffffffff816732e8>] scsi_error_handler+0xf8/0x500
[    1.938588]   [<ffffffff810654fe>] kthread+0xae/0xc0
[    1.938591]   [<ffffffff81b4f5f4>] kernel_thread_helper+0x4/0x10
[    1.938595] irq event stamp: 51552
[    1.938596] hardirqs last  enabled at (51549): [<ffffffff8100ab7d>] default_idle+0x5d/0x1b0
[    1.938599] hardirqs last disabled at (51550): [<ffffffff81b4da67>] common_interrupt+0x67/0x6c
[    1.938602] softirqs last  enabled at (51552): [<ffffffff810498d3>] _local_bh_enable+0x13/0x20
[    1.938606] softirqs last disabled at (51551): [<ffffffff8104a355>] irq_enter+0x75/0x90
[    1.938608] 
[    1.938608] other info that might help us debug this:
[    1.938609]  Possible unsafe locking scenario:
[    1.938609] 
[    1.938609]        CPU0
[    1.938610]        ----
[    1.938610]   lock(&(&host->lock)->rlock);
[    1.938611]   <Interrupt>
[    1.938612]     lock(&(&host->lock)->rlock);
[    1.938613] 
[    1.938613]  *** DEADLOCK ***
[    1.938613] 
[    1.938614] no locks held by swapper/1/0.
[    1.938614] 
[    1.938614] stack backtrace:
[    1.938616] Pid: 0, comm: swapper/1 Not tainted 3.5.2 #4
[    1.938617] Call Trace:
[    1.938618]  <IRQ>  [<ffffffff81b35961>] print_usage_bug+0x1f7/0x208
[    1.938623]  [<ffffffff8101001f>] ? save_stack_trace+0x2f/0x50
[    1.938626]  [<ffffffff810972da>] ? add_lock_to_list.isra.25.constprop.39+0x7a/0xd0
[    1.938629]  [<ffffffff81098730>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[    1.938631]  [<ffffffff810992a2>] mark_lock+0x262/0x2a0
[    1.938633]  [<ffffffff81099af3>] __lock_acquire+0x813/0x1af0
[    1.938636]  [<ffffffff8107c655>] ? enqueue_task_fair+0x85/0xc0
[    1.938639]  [<ffffffff8109bbc9>] ? mark_held_locks+0xa9/0x100
[    1.938641]  [<ffffffff81076f93>] ? try_to_wake_up+0x1c3/0x2d0
[    1.938645]  [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.938647]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
[    1.938650]  [<ffffffff81b4d151>] _raw_spin_lock_irqsave+0x41/0x60
[    1.938652]  [<ffffffff818f4e47>] ? ata_bmdma_interrupt+0x27/0x1d0
[    1.938655]  [<ffffffff8105fee0>] ? __queue_work+0x390/0x390
[    1.938658]  [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
[    1.938661]  [<ffffffff810c2d5d>] handle_irq_event_percpu+0x5d/0x1f0
[    1.938664]  [<ffffffff810c2f38>] handle_irq_event+0x48/0x70
[    1.938665]  [<ffffffff81b4d059>] ? _raw_spin_lock+0x39/0x40
[    1.938668]  [<ffffffff810c5f0e>] ? handle_fasteoi_irq+0x1e/0xf0
[    1.938670]  [<ffffffff810c5f4a>] handle_fasteoi_irq+0x5a/0xf0
[    1.938672]  [<ffffffff81003ce2>] handle_irq+0x22/0x40
[    1.938676]  [<ffffffff81b4fdaa>] do_IRQ+0x5a/0xe0
[    1.938678]  [<ffffffff81b4da6c>] common_interrupt+0x6c/0x6c
[    1.938681]  <EOI>  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
[    1.938685]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[    1.938687]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
[    1.938689]  [<ffffffff81b2c7db>] start_secondary+0x1dd/0x1e4
[    1.938717] ata4.00: ATA-6: ST3200822AS, 3.01, max UDMA/133





oopses:
*****************************************************************
1



[  918.496049] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga encoder (output 0)
[1346318855.630001] BUG: unable to handle kernel NULL pointer dereference at           (null)
[1346318855.630001] IP: [<ffffffff81099430>] __lock_acquire+0x150/0x1af0
[1346318855.630001] PGD 0 
[1346318855.630001] Oops: 0002 [#1] SMP 
[1346318855.630001] CPU 1 
[1346318855.630001] Modules linked in:[1346318855.630001]  netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipt_REJECT xt_tcpudp iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables lp fuse nouveau snd_via82xx snd_ac97_codec snd_mpu401_uart mxm_wmi wmi snd_rawmidi video ttm drm_kms_helper drm snd_seq_device snd_pcm snd_page_alloc snd_timer snd powernow_k8 button i2c_algo_bit mperf i2c_viapro shpchp amd64_agp agpgart skge soundcore ac97_bus gameport ppdev freq_table evdev i2c_core processor k8temp parport_pc parport thermal_sys hwmon loop

[1346318855.630001] Pid: 0, comm: swapper/1 Not tainted 3.5.2 #4 To Be Filled By O.E.M. To Be Filled By O.E.M./A8V Deluxe
[1346318855.630001] RIP: 0010:[<ffffffff81099430>]  [<ffffffff81099430>] __lock_acquire+0x150/0x1af0
[1346318855.630001] RSP: 0018:ffff88007fd03d98  EFLAGS: 00010046
[1346318855.630001] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000002
[1346318855.630001] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff82022180
[1346318855.630001] RBP: ffff88007fd03e88 R08: 0000000000000001 R09: 0000000000000001
[1346318855.630001] R10: ffff88007d07dd60 R11: 0000000000000001 R12: 0000000000000001
[1346318855.630001] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
[1346318855.630001] FS:  00007f38d8c5f740(0000) GS:ffff88007fd00000(0000) knlGS:00000000f6f7a700
[1346318855.630001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1346318855.630001] CR2: 0000000000000000 CR3: 000000000200b000 CR4: 00000000000007e0
[1346318855.630001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1346318855.630001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1346318855.630001] Process swapper/1 (pid: 0, threadinfo ffff88007c524000, task ffff88007d07dd60)
[1346318855.630001] Stack:
[1346318855.630001]  ffffffff81051c0e ffffffff00000000 0000000000000006 0000000000000096
[1346318855.630001]  0000000000000046 000000008107e70c ffff88007c534018 ffff88007fd12780
[1346318855.630001]  0000000000000082 ffff88007c534000 ffff88007c534000 ffff88007c534000
[1346318855.630001] Call Trace:
[1346318855.630001]  <IRQ> 
[1346318855.630001]  [<ffffffff81051c0e>] ? run_timer_softirq+0x3e/0x390
[1346318855.630001]  [<ffffffff8109bdbd>] ? trace_hardirqs_on+0xd/0x10
[1346318855.630001]  [<ffffffff81b4d7c0>] ? _raw_spin_unlock_irq+0x30/0x40
[1346318855.630001]  [<ffffffff81051dde>] ? run_timer_softirq+0x20e/0x390
[1346318855.630001]  [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[1346318855.630001]  [<ffffffff8106b8a0>] ? raw_notifier_call_chain+0x20/0x20
[1346318855.630001]  [<ffffffff8106b8f6>] __atomic_notifier_call_chain+0x56/0xa0
[1346318855.630001]  [<ffffffff8106b8a0>] ? raw_notifier_call_chain+0x20/0x20
[1346318855.630001]  [<ffffffff8109536e>] ? tick_nohz_stop_idle+0x3e/0x50
[1346318855.630001]  [<ffffffff8106b956>] atomic_notifier_call_chain+0x16/0x20
[1346318855.630001]  [<ffffffff8100b703>] exit_idle+0x43/0x50
[1346318855.630001]  [<ffffffff81b4fe73>] smp_apic_timer_interrupt+0x43/0x99
[1346318855.630001]  [<ffffffff81b4eedc>] apic_timer_interrupt+0x6c/0x80
[1346318855.630001]  <EOI> 
[1346318855.630001]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[1346318855.630001]  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
[1346318855.630001]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[1346318855.630001]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
[1346318855.630001]  [<ffffffff81b2c7db>] start_secondary+0x1dd/0x1e4
[1346318855.630001] Code: 85 f6 0f 85 91 11 00 00 49 89 5d 08 83 3d 58 0f 19 01 00 75 0a 44 3b 73 28 0f 85 8e 17 00 00 48 85 db 75 60 0f 1f 80 00 00 00 00 <31> c0 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d 
[1346318855.630001] RIP  [<ffffffff81099430>] __lock_acquire+0x150/0x1af0
[1346318855.630001]  RSP <ffff88007fd03d98>
[1346318855.630001] CR2: 0000000000000000
[1346318855.630001] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 0)
[1346318855.630001] ---[ end trace 8d0e3b845eb2daca ]---
[1346318855.630001] Kernel panic - not syncing: Fatal exception in interrupt
[1346318855.630001] panic occurred, switching back to text console
[1346318855.630001] Rebooting in 10 seconds..


*************************************************************
2

[  890.786007] general protection fault: 0000 [#1] SMP 
[  890.786007] CPU 0 
[  890.786007] Modules linked in:[  890.786007]  netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipt_REJECT xt_tcpudp iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables lp fuse nouveau mxm_wmi wmi video ttm drm_kms_helper drm snd_via82xx snd_ac97_codec snd_mpu401_uart snd_rawmidi powernow_k8 mperf snd_seq_device snd_pcm snd_page_alloc processor amd64_agp snd_timer agpgart skge freq_table i2c_algo_bit i2c_viapro i2c_core snd k8temp soundcore thermal_sys ac97_bus gameport hwmon button ppdev shpchp evdev parport_pc parport loop

[  890.786007] Pid: 0, comm: swapper/0 Not tainted 3.5.2 #4 To Be Filled By O.E.M. To Be Filled By O.E.M./A8V Deluxe
[  890.786007] RIP: 0010:[<ffffffff810957ea>]  [<ffffffff810957ea>] tick_check_idle+0x3a/0xe0
[  890.786007] RSP: 0018:ffff88007fc03f50  EFLAGS: 00010086
[  890.786007] RAX: 0000000000015180 RBX: c31e1ad9b83b64d7 RCX: ffffffffffffffff
[  890.786007] RDX: 0000000000000000 RSI: 0000000000000200 RDI: 0000000000015180
[  890.786007] RBP: ffff88007fc03f88 R08: 0000000000000000 R09: 0000000000000000
[  890.786007] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000015180
[  890.786007] R13: 000000000000da40 R14: ffff88007ff1d8c0 R15: 0000000000000000
[  890.786007] FS:  00007f79bf1b6740(0000) GS:ffff88007fc00000(0000) knlGS:00000000f719c940
[  890.786007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  890.786007] CR2: 00007fff8f780518 CR3: 000000007af3c000 CR4: 00000000000007f0
[  890.786007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  890.786007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  890.786007] Process swapper/0 (pid: 0, threadinfo ffffffff82000000, task ffffffff82013440)
[  890.786007] Stack:
[  890.786007]  ffffffff821762c0 ffff88007fc03f68 ffffffff810497f7 0000000000000000
[  890.786007]  0000000000000000 ffffffff821762c0 ffff88007ff1d8c0 ffff88007fc03fa8
[  890.786007]  ffffffff81b4fe6e ffffffff82001fd8 0000000000000000 ffffffff82001ef8
[  890.786007] Call Trace:
[  890.786007]  <IRQ> 
[  890.786007]  [<ffffffff810497f7>] ? local_bh_disable+0x17/0x20
[  890.786007]  [<ffffffff81b4fe6e>] smp_apic_timer_interrupt+0x3e/0x99
[  890.786007]  [<ffffffff81b4eedc>] apic_timer_interrupt+0x6c/0x80
[  890.786007]  <EOI> 
[  890.786007]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[  890.786007]  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
[  890.786007]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[  890.786007]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
[  890.786007]  [<ffffffff81b0014e>] rest_init+0xb2/0xc4
[  890.786007]  [<ffffffff81b0009c>] ? csum_partial_copy_generic+0x16c/0x16c
[  890.786007]  [<ffffffff8212cbbd>] start_kernel+0x3af/0x3bc
[  890.786007]  [<ffffffff8212c60d>] ? repair_env_string+0x5e/0x5e
[  890.786007]  [<ffffffff8212c32d>] x86_64_start_reservations+0x131/0x135
[  890.786007]  [<ffffffff8212c409>] x86_64_start_kernel+0xd8/0xdc
[  890.786007] Code: e8 4c 89 6d f0 4c 89 75 f8 66 66 66 66 90 49 c7 c5 40 da 00 00 41 89 fc 4c 89 eb e8 31 ed ff ff 49 63 c4 48 03 1c c5 80 18 11 82 <8b> 83 98 00 00 00 85 c0 75 1c 8b 43 7c 85 c0 75 15 48 8b 5d e0 
[  890.786007] RIP  [<ffffffff810957ea>] tick_check_idle+0x3a/0xe0
[  890.786007]  RSP <ffff88007fc03f50>
[  890.786007] ---[ end trace 5a3761b5f4473308 ]---
[  890.786007] Kernel panic - not syncing: Fatal exception in interrupt
[  890.786007] panic occurred, switching back to text console
[  890.786007] Rebooting in 10 seconds..


Thanks.

Best regards
Adko.
