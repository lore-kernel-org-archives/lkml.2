Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2ICVqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 17:46:36 -0400
Received: from nm31-vm7.bullet.mail.ne1.yahoo.com ([98.138.229.47]:29488 "HELO
	nm31-vm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753692Ab2ICVqc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 17:46:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 779486.65357.bm@omp1062.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=wHzWPpeuYlsRtLqHJEtslJSpaPaRutP6fHQo38qr5Q88WrzrEhHmIhTQcC61/Vg1qson0N4XJQZGfokMuRVmoSfrzmh/gDMinP5ygwCuQxicONz6z1dW5WRa5kcmWzqRIycbbaohe99enVaFqsWoAiIdcMPPqPuXcE1Y5llN4jw=;
X-YMail-OSG: DasildIVM1liGTonNG_3LSQg8m3DKlG_s5VwFVc2_RrZ3Mk
 8xrc_O67BJVt5qkBWPX_ugle_8HZ2xqGVvlrgT9lEPQ9mu5GULaozTg7EvI3
 0LwjywmXEf3tTU1wpi4oTlAnlS8c1Zlh.Qy_lotAIF30yIihttCb8JCWl2O.
 Av7SFiFMc667H9Bl7ANwv3kmomIXjYjzMNV28r_yo28ZJvbNb_FKCcrLGixU
 TbXfn_rP85RD7axZrWWfstsxm.5S_vcYWDxfie5zIjRP28LxpsPHfaJNmSW6
 AMtqyX8nMzhoMaxX.Qhu.PZukpRk0jrXxr4WHwuZdr5op_uWbFCNkrCF7j4n
 ycryrIAartnUcLELhuYwt8BS7D9f3cv2BaavZ5cBg5LYLyyKGsB1R4dT3nPp
 ZsqqvXXr1Y9SB5W41Ip4Ze6USYYKq94A6ASdLxZnDSkNPVR1m5zw0PHcdqUI
 B1xJEI65Z2OkJP43ZtEbZ1FtL2i6FSdsZhcyDME_.ETIG8DSUp9KAWRDwqFM
 LxArb1zAuUegXCXLu_SalD3.khftAMKFQJIvKDvfm_TgHPhY8cS.9IQHPFZv
 IapwSNFo219GlSdPbKQ--
X-Mailer: YahooMailWebService/0.8.121.416
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120826130152.GA20021@liondog.tnic> <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com> <20120827215952.GA18719@liondog.tnic> <1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120830095808.GB24680@liondog.tnic> <1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20547.48101.900727.735398@pilspetsen.it.uu.se>
Message-ID: <1346708791.72123.YahooMailNeo@web124701.mail.ne1.yahoo.com>
Date: Mon, 3 Sep 2012 14:46:31 -0700 (PDT)
From: Adko Branil <adkobranil@yahoo.com>
Reply-To: Adko Branil <adkobranil@yahoo.com>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Borislav Petkov <bp@alien8.de>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20547.48101.900727.735398@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





> But now an interrupt occurs during the hard
>reset, and pdc_interrupt also has to take the host lock.

I have 4 sata connectors on the motherboard - http://www.hardwareheaven.com/reviews/asusA8V/
If i understand right, just 2 of them are linked to promise controller. Well i changed the connector where my HDD  is connected, 
and dmesg warning message is a bit different now - "ata_bmdma_interrupt" was replaced by "pdc_interrupt".




[    1.973049] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.984574] 
[    1.984575] =================================
[    1.984576] [ INFO: inconsistent lock state ]
[    1.984578] 3.5.2 #4 Not tainted
[    1.984578] ---------------------------------
[    1.984579] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    1.984581] swapper/1/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    1.984582]  (&(&host->lock)->rlock){?.+...}, at: [<ffffffff8190abd8>] pdc_interrupt+0x48/0x420
[    1.984590] {HARDIRQ-ON-W} state was registered at:
[    1.984591]   [<ffffffff810998fb>] __lock_acquire+0x61b/0x1af0
[    1.984595]   [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.984597]   [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
[    1.984602]   [<ffffffff8190b3c5>] pdc_sata_hardreset+0x85/0x100
[    1.984604]   [<ffffffff818eabba>] ata_do_reset+0x3a/0x90
[    1.984607]   [<ffffffff818edd72>] ata_eh_reset+0x372/0xe00
[    1.984610]   [<ffffffff818eec25>] ata_eh_recover+0x2a5/0x13d0
[    1.984612]   [<ffffffff818f073d>] ata_do_eh+0x4d/0xb0
[    1.984614]   [<ffffffff818f33ba>] ata_sff_error_handler+0xca/0x120
[    1.984617]   [<ffffffff8190a9e4>] pdc_error_handler+0x24/0x30
[    1.984619]   [<ffffffff818f029c>] ata_scsi_port_error_handler+0x47c/0x800
[    1.984622]   [<ffffffff818f06be>] ata_scsi_error+0x9e/0xd0
[    1.984624]   [<ffffffff816732e8>] scsi_error_handler+0xf8/0x500
[    1.984628]   [<ffffffff810654fe>] kthread+0xae/0xc0
[    1.984631]   [<ffffffff81b4f5f4>] kernel_thread_helper+0x4/0x10
[    1.984634] irq event stamp: 49968
[    1.984635] hardirqs last  enabled at (49965): [<ffffffff8100ab7d>] default_idle+0x5d/0x1b0
[    1.984639] hardirqs last disabled at (49966): [<ffffffff81b4da67>] common_interrupt+0x67/0x6c
[    1.984641] softirqs last  enabled at (49968): [<ffffffff810498d3>] _local_bh_enable+0x13/0x20
[    1.984645] softirqs last disabled at (49967): [<ffffffff8104a355>] irq_enter+0x75/0x90
[    1.984648] 
[    1.984648] other info that might help us debug this:
[    1.984648]  Possible unsafe locking scenario:
[    1.984648] 
[    1.984649]        CPU0
[    1.984649]        ----
[    1.984650]   lock(&(&host->lock)->rlock);
[    1.984651]   <Interrupt>
[    1.984651]     lock(&(&host->lock)->rlock);
[    1.984653] 
[    1.984653]  *** DEADLOCK ***
[    1.984653] 
[    1.984654] no locks held by swapper/1/0.
[    1.984654] 
[    1.984654] stack backtrace:
[    1.984656] Pid: 0, comm: swapper/1 Not tainted 3.5.2 #4
[    1.984656] Call Trace:
[    1.984657]  <IRQ>  [<ffffffff81b35961>] print_usage_bug+0x1f7/0x208
[    1.984662]  [<ffffffff8101001f>] ? save_stack_trace+0x2f/0x50
[    1.984665]  [<ffffffff81098730>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[    1.984668]  [<ffffffff810992a2>] mark_lock+0x262/0x2a0
[    1.984670]  [<ffffffff81099af3>] __lock_acquire+0x813/0x1af0
[    1.984672]  [<ffffffff8107da11>] ? load_balance+0xd1/0x730
[    1.984676]  [<ffffffff8107baa0>] ? update_cfs_shares+0x100/0x100
[    1.984678]  [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
[    1.984680]  [<ffffffff8190abd8>] ? pdc_interrupt+0x48/0x420
[    1.984682]  [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
[    1.984685]  [<ffffffff8190abd8>] ? pdc_interrupt+0x48/0x420
[    1.984686]  [<ffffffff8107e228>] ? rebalance_domains+0x1b8/0x1e0
[    1.984689]  [<ffffffff8190abd8>] pdc_interrupt+0x48/0x420
[    1.984691]  [<ffffffff810c2d5d>] handle_irq_event_percpu+0x5d/0x1f0
[    1.984694]  [<ffffffff810c2f38>] handle_irq_event+0x48/0x70
[    1.984695]  [<ffffffff81b4d059>] ? _raw_spin_lock+0x39/0x40
[    1.984698]  [<ffffffff810c5f0e>] ? handle_fasteoi_irq+0x1e/0xf0
[    1.984700]  [<ffffffff810c5f4a>] handle_fasteoi_irq+0x5a/0xf0
[    1.984702]  [<ffffffff81003ce2>] handle_irq+0x22/0x40
[    1.984706]  [<ffffffff81b4fdaa>] do_IRQ+0x5a/0xe0
[    1.984708]  [<ffffffff81b4da6c>] common_interrupt+0x6c/0x6c
[    1.984711]  <EOI>  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
[    1.984714]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[    1.984717]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
[    1.984719]  [<ffffffff81b2c7db>] start_secondary+0x1dd/0x1e4
[    1.984761] ata1.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
[    1.984763] ata1.00: 390721968 sectors, multi 0: LBA48 
[    2.006548] ata1.00: configured for UDMA/133




Here is the full dmesg - http://pastebin.com/1xLETNd5
And the crashes are continuing - heavy disk operations like "md5sum -c а.md5", where a.md5 contains md5 sums of more than 300 000 files,

speed up the crash between 10 and 100 times, compared to the idle case, and it crashes with oops like:




[10432.283017] BUG: unable to handle kernel NULL pointer dereference at           (null)
[10432.293110] IP: [<ffffffff8109530c>] update_ts_time_stats+0x6c/0x90
[10432.293110] PGD 7a223067 PUD 7958a067 PMD 0 
[10432.293110] Oops: 0002 [#1] SMP 
[10432.293110] CPU 1 
[10432.293110] Modules linked in:[10432.293110]  netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipt_REJECT xt_tcpudp iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables lp fuse nouveau mxm_wmi wmi video ttm drm_kms_helper drm snd_via82xx snd_ac97_codec snd_mpu401_uart snd_rawmidi powernow_k8 snd_seq_device snd_pcm mperf processor snd_page_alloc snd_timer i2c_algo_bit snd soundcore ac97_bus gameport ppdev k8temp shpchp parport_pc freq_table amd64_agp i2c_viapro thermal_sys button skge parport evdev i2c_core hwmon agpgart loop

[10432.293110] Pid: 0, comm: swapper/1 Not tainted 3.5.2 #4 To Be Filled By O.E.M. To Be Filled By O.E.M./A8V Deluxe
[10432.293110] RIP: 0010:[<ffffffff8109530c>]  [<ffffffff8109530c>] update_ts_time_stats+0x6c/0x90
[10432.293110] RSP: 0018:ffff88007fd03ed8  EFLAGS: 00010046
[10432.293110] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[10432.293110] RDX: 0000097cf485c143 RSI: ffff88007fd0da40 RDI: 0000000000000001
[10432.293110] RBP: ffff88007fd03f18 R08: 0000000000000000 R09: 0000000000000000
[10432.293110] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000e1360
[10432.293110] R13: 000000000000da40 R14: 0000097cf485c143 R15: 0000000000000000
[10432.293110] FS:  00007f8de7906740(0000) GS:ffff88007fd00000(0000) knlGS:00000000f6f66700
[10432.293110] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[10432.293110] CR2: 0000000000000000 CR3: 000000007a9d7000 CR4: 00000000000007e0
[10432.293110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10432.293110] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10432.293110] Process swapper/1 (pid: 0, threadinfo ffff88007c524000, task ffff88007d07dd60)
[10432.293110] Stack:
[10432.293110]  0000097cf485c143 ffff88007fd0da40 ffff88007c525fd8 ffff88007c525fd8
[10432.293110]  0000010000000009 0000000000000012 ffff88007fd0da40 0000000000000001
[10432.293110]  ffff88007fd03f38 ffffffff8109535d 000000000000da40 ffff88007fd0da40
[10432.293110] Call Trace:
[10432.293110]  <IRQ> 
[10432.293110]  [<ffffffff8109535d>] tick_nohz_stop_idle+0x2d/0x50
[10432.293110]  [<ffffffff81095873>] tick_check_idle+0xc3/0xe0
[10432.293110]  [<ffffffff8104a35c>] irq_enter+0x7c/0x90
[10432.293110]  [<ffffffff81b4fe6e>] smp_apic_timer_interrupt+0x3e/0x99
[10432.293110]  [<ffffffff81b4eedc>] apic_timer_interrupt+0x6c/0x80
[10432.293110]  <EOI> 
[10432.293110]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[10432.293110]  [<ffffffff8100ab7f>] ? default_idle+0x5f/0x1b0
[10432.293110]  [<ffffffff8100ab7d>] ? default_idle+0x5d/0x1b0
[10432.293110]  [<ffffffff8100b816>] cpu_idle+0x106/0x120
[10432.293110]  [<ffffffff81b2c7db>] start_secondary+0x1dd/0x1e4
[10432.293110] Code: f0 4c 8b 65 f8 c9 c3 49 89 d4 4c 2b a6 a0 00 00 00 48 89 55 c0 48 89 75 c8 e8 11 fb fd ff 48 85 c0 48 8b 55 c0 48 8b 75 c8 75 14 <4c> 01 a6 b8 00 00 00 48 89 96 a0 00 00 00 eb a8 0f 1f 40 00 4c 
[10432.293110] RIP  [<ffffffff8109530c>] update_ts_time_stats+0x6c/0x90
[10432.293110]  RSP <ffff88007fd03ed8>
[10432.293110] CR2: 0000000000000000
[10432.293110] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 0)
[10432.293110] ---[ end trace 9b7353d10a6013b6 ]---
[10432.293110] Kernel panic - not syncing: Fatal exception in interrupt
[10432.293110] panic occurred, switching back to text console
[10432.293110] Rebooting in 10 seconds..




>I don't know why the interrupt occurs, hotplug events are supposed to have been masked
>by ->freeze before ->hardreset. It might come from a different device

If this is the case, does it mean hardware bug ? Broken PIC, or just particular device, like integrated sound or lan ?
Is this interrupt, with unknown origin, the reason of both - dmesg warning and the crash caused this oops?

Any cure about that ? Except that i will try to disable what i can in BIOS. 


>I think I'll have to introduce a new private lock just for serializing
>pdc_hard_reset_port. Expect a patch next weekend (I'll be away from
>my Promise test equipment until then.)


Could this future patch solve the "crash problem", as well as the "warning problem",
or it will not bearing on the "crash problem"?




Thanks.

Best regards.
Adko.
