Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab2HSEbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 00:31:48 -0400
Received: from mail.digium.com ([216.207.245.2]:41844 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab2HSEbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 00:31:45 -0400
X-Greylist: delayed 858 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2012 00:31:45 EDT
Date: Sat, 18 Aug 2012 23:25:43 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Dave Haywood <tla@oak.selfip.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at 00010016
Message-ID: <20120819042543.GA14461@digium.com>
References: <502ECC74.9030605@oak.selfip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502ECC74.9030605@oak.selfip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding linux-net to the CC list.

On Fri, Aug 17, 2012 at 11:57:56PM +0100, Dave Haywood wrote:
> [1.] One line summary of the problem:
> BUG: unable to handle kernel paging request at 00010016
> 
> 	System boots then crashes a 5-10 or so seconds after getting to the login prompt
> 	Booting without the network cable attached prevents the crash (no evidence beyond 10 minutes after boot)
> 
>   Diagnostics:
> 	Captured the boot and managed a login + dmesg before the crash
> 	Some of the log looks corrupted. Probably my crappy usb dongle serial flow control but left it in anyway

[snip]

> [6.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
> [   62.907899] BUG: unable to handle kernel paging request at 00010016
> [   62.908002] IP: [<c15acfc9>] inet6_sk_rx_dst_set+0x29/0x40
> [   62.908002] *pde = 00000000
> [   62.908002] Oops: 0000 [#1] SMP
> [   62.908002] Pid: 2168, comm: mprime Not tainted 3.6.0-rc2 #297 Compaq Deskpro/06C4h
> [   62.908002] EIP: 0060:[<c15acfc9>] EFLAGS: 00010202 CPU: 0
> [   62.908002] EIP is at inet6_sk_rx_dst_set+0x29/0x40
> [   62.908002] EAX: ce738508 EBX: ce73a760 ECX: cf377000 EDX: 00010002
> [   62.908002] ESI: ca06c900 EDI: ce738000 EBP: cf80bc7c ESP: cf80bc7c
> [   62.908002]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   62.908002] CR0: 80050033 CR2: 00010016 CR3: 0a036000 CR4: 000007d0
> [   62.908002] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   62.908002] DR6: ffff0ff0 DR7: 00000400
> [   62.908002] Process mprime (pid: 2168, ti=cf80a000 task=ce4f7390 task.ti=ca052000)
> [   62.908002] Stack:
> [   62.908002]  cf80bc9c c15449cb ffffffff ce436780 00000000 ce738508 ca06c900 ce738000
> [   62.908002]  cf80bcc0 c154337e c167545e cf80bcec c124b318 ce436780 ce738508 ce738000
> [   62.908002]  ce436780 cf80bd48 c15aff9d 00000000 00000001 cf80bcec c1236880 ce691ec0
> [   62.908002] Call Trace:
> [   62.908002]  [<c15449cb>] tcp_create_openreq_child+0x3b/0x4a0
> [   62.908002]  [<c154337e>] tcp_v4_syn_recv_sock+0x2e/0x2a0
> [   62.908002]  [<c167545e>] ? _raw_spin_unlock_bh+0xe/0x10
> [   62.908002]  [<c124b318>] ? selinux_netlbl_sock_rcv_skb+0x18/0x190
> [   62.908002]  [<c15aff9d>] tcp_v6_syn_recv_sock+0x3ed/0x6d0
> [   62.908002]  [<c1236880>] ? selinux_parse_skb+0x50/0xb0
> [   62.908002]  [<c15450b3>] tcp_check_req+0x283/0x450
> [   62.908002]  [<c1541191>] tcp_v4_hnd_req+0x51/0x140
> [   62.908002]  [<c1542e69>] tcp_v4_do_rcv+0x129/0x1b0
> [   62.908002]  [<c14f5b45>] ? sk_filter+0x25/0xb0
> [   62.908002]  [<c154407e>] tcp_v4_rcv+0x5fe/0x730
> [   62.908002]  [<c15209b0>] ? ip_rcv_finish+0x2f0/0x2f0
> [   62.908002]  [<c1520a3c>] ip_local_deliver_finish+0x8c/0x260
> [   62.908002]  [<c15206c0>] ? inet_del_protocol+0x30/0x30
> [   62.908002]  [<c1520d9f>] ip_local_deliver+0x7f/0x90
> [   62.908002]  [<c15209b0>] ? ip_rcv_finish+0x2f0/0x2f0
> [   62.908002]  [<c15207b1>] ip_rcv_finish+0xf1/0x2f0
> [   62.908002]  [<c15206c0>] ? inet_del_protocol+0x30/0x30
> [   62.908002]  [<c1521002>] ip_rcv+0x252/0x320
> [   62.908002]  [<c15206c0>] ? inet_del_protocol+0x30/0x30
> [   62.908002]  [<c14e19bb>] __netif_receive_skb+0x46b/0x670
> [   62.908002]  [<c14e4b72>] netif_receive_skb+0x22/0x80
> [   62.908002]  [<c13eb6e2>] rtl8139_rx+0xd2/0x370
> [   62.908002]  [<c13eb9c2>] rtl8139_poll+0x42/0xb0
> [   62.908002]  [<c14e56dd>] net_rx_action+0xed/0x1c0
> [   62.908002]  [<c12c6110>] ? fbcon_add_cursor_timer+0xd0/0xd0
> [   62.908002]  [<c10427a7>] __do_softirq+0xa7/0x200
> [   62.908002]  [<c1042700>] ? local_bh_enable_ip+0x80/0x80
> [   62.908002]  <IRQ>
> [   62.908002]  [<c1042b0e>] ? irq_exit+0x6e/0x90
> [   62.908002]  [<c1004176>] ? do_IRQ+0x46/0xb0
> [   62.908002]  [<c1042af7>] ? irq_exit+0x57/0x90
> [   62.908002]  [<c10224a6>] ? smp_apic_timer_interrupt+0x56/0x90
> [   62.908002]  [<c1676289>] ? common_interrupt+0x29/0x30
> [   62.908002] Code: 90 90 55 8b 4a 48 89 e5 83 e1 fe 3e ff 41 40 89 88 8c 00 00 00 8b 52 74 89 90 cc 01 00 00 8b 51 58 85 d2 74 0c 8b 80 a0 01 00 00 <8b> 52 14 89 50 68 5d c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90
> [   62.908002] EIP: [<c15acfc9>] inet6_sk_rx_dst_set+0x29/0x40 SS:ESP 0068:cf80bc7c
> [   62.908002] CR2: 0000000000010016
> [   63.212118] ---[ end trace 1fcc7fe92846c9d3 ]---
> [   63.216734] Kernel panic - not syncing: Fatal exception in interrupt

Just a note that I see this as well. It happens reliably for me after trying to
login to the machine via ssh.

Here is the back trace I collected on the serial port.

[   67.258206] BUG: unable to handle kernel paging request at 00010016
[   67.260010] IP: [<f93a4ae6>] inet6_sk_rx_dst_set+0x3a/0x89 [ipv6]
[   67.260010] *pde = 00000000
[   67.260010] Oops: 0000 [#1] SMP
[   67.260010] Modules linked in: bluetooth rfkill crc16 lockd sunrpc ipv6 dm_multipath lp sg pcspkr serio_raw e1000 ata_piix libata floppy parport_pc pa rport e7xxx_edac edac_core ide_cd_mod cdrom intel_rng dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod megaraid_mbox megaraid_mm sd_mod scsi_mo
d ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
[   67.260010] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc2-00117-g741badf #14 Dell Computer Corporation PowerEdge 2600             /0F0364
[   67.260010] EIP: 0060:[<f93a4ae6>] EFLAGS: 00010202 CPU: 0
[   67.260010] EIP is at inet6_sk_rx_dst_set+0x3a/0x89 [ipv6]
[   67.260010] EAX: 00010002 EBX: f34c9680 ECX: 00000000 EDX: f35806c8
[   67.260010] ESI: f3580800 EDI: f21fc000 EBP: f5817c14 ESP: f5817c0c
[   67.260010]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   67.260010] CR0: 8005003b CR2: 00010016 CR3: 33ec6000 CR4: 000007d0
[   67.260010] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   67.260010] DR6: ffff0ff0 DR7: 00000400
[   67.260010] Process swapper/0 (pid: 0, ti=f5816000 task=c09bf780 task.ti=c09b4000)
[   67.260010] Stack:
[   67.260010]  00000000 f3580800 f5817c30 c0788ec3 f34c9680 f3580000 f93b0f00 f21fc000
[   67.260010]  00000000 f5817c50 c07874c1 f34c9680 f3580000 0172fcbc f93b0f00 f21fc000
[   67.260010]  f34c9698 f5817cb4 f93a6eb8 00000000 f21fc000 f34c9680 f3580000 f35806c8
[   67.260010] Call Trace:
[   67.260010]  [<c0788ec3>] tcp_create_openreq_child+0x41/0x4a7
[   67.260010]  [<c07874c1>] tcp_v4_syn_recv_sock+0x3c/0x2a1
[   67.260010]  [<f93a6eb8>] tcp_v6_syn_recv_sock+0x367/0x460 [ipv6]
[   67.260010]  [<c04848e1>] ? validate_chain+0xe2/0x4cd
[   67.260010]  [<c046859c>] ? local_clock+0x29/0x42
[   67.260010]  [<c0788ae2>] tcp_check_req+0x21e/0x401
[   67.260010]  [<c04859ed>] ? lock_release_nested+0x82/0xb8
[   67.260010]  [<c0785aeb>] tcp_v4_hnd_req+0x52/0x153
[   67.260010]  [<c0785cec>] tcp_v4_do_rcv+0x100/0x5e4
[   67.260010]  [<c07ef661>] ? _raw_spin_lock_nested+0x6a/0x71
[   67.260010]  [<c0787ed3>] tcp_v4_rcv+0x7ad/0xaf6
[   67.260010]  [<c0765aed>] ip_local_deliver_finish+0xb7/0x3ea
[   67.260010]  [<c0765a89>] ? ip_local_deliver_finish+0x53/0x3ea
[   67.260010]  [<c0765270>] ip_local_deliver+0x32/0x95
[   67.260010]  [<c07655ea>] ip_rcv_finish+0x154/0x5a0
[   67.260010]  [<c07cc572>] ? prb_retire_rx_blk_timer_expired+0xcc/0xcc
[   67.260010]  [<c0765157>] ip_rcv+0x217/0x2fe
[   67.260010]  [<c0764f40>] ? inet_del_protocol+0x35/0x35
[   67.260010]  [<c07335cf>] __netif_receive_skb+0x25f/0xa14
[   67.260010]  [<c0733406>] ? __netif_receive_skb+0x96/0xa14
[   67.260010]  [<c073567b>] netif_receive_skb+0x27/0x1c4
[   67.260010]  [<c07358a2>] napi_skb_finish+0x26/0x5e
[   67.260010]  [<c073b247>] napi_gro_receive+0xfb/0x116
[   67.260010]  [<c072d1fd>] ? __netdev_alloc_skb+0x95/0xca
[   67.260010]  [<f8a7f873>] e1000_receive_skb+0x4b/0x53 [e1000]
[   67.260010]  [<f8a84da7>] e1000_clean_rx_irq+0x262/0x3ef [e1000]
[   67.260010]  [<f8a83708>] e1000_clean+0x45/0x95 [e1000]
[   67.260010]  [<c0739a03>] net_rx_action+0x104/0x26f
[   67.260010]  [<c043b402>] __do_softirq+0xb3/0x33d
[   67.260010]  [<c043b34f>] ? _local_bh_enable+0x14/0x14
[   67.260010]  <IRQ>
[   67.260010]  [<c043b87f>] ? irq_exit+0x4d/0x80
[   67.260010]  [<c07f6df4>] ? do_IRQ+0x44/0xb0
[   67.260010]  [<c07f6d2e>] ? common_interrupt+0x2e/0x34
[   67.260010]  [<c048007b>] ? lockdep_init_map+0x421/0x4dd
[   67.260010]  [<c04089ff>] ? default_idle+0x54/0x416
[   67.260010]  [<c04094bf>] ? cpu_idle+0x6d/0x95
[   67.260010]  [<c07d7224>] ? rest_init+0xe4/0x13d
[   67.260010]  [<c07d7180>] ? rest_init+0x40/0x13d
[   67.260010]  [<c0a21ba5>] ? start_kernel+0x23b/0x2d6
[   67.260010]  [<c0a216c8>] ? obsolete_checksetup+0x97/0x97
[   67.260010]  [<c0a212a7>] ? i386_start_kernel+0x59/0x7e
[   67.260010] Code: 42 48 01 75 30 8b 43 48 83 e0 fe f0 ff 40 40 89 86 0c 01 00 00 8b 53 6c 89 96 f8 02 00 00 8b 40 58 85 c0 74 0c 8b 96 cc 02 00 00 <8b> 40 14 89 42 68 5b 5e 5d c3 e8 c5 db 0a c7 85 c0 74 c7 e8 c1
[   67.260010] EIP: [<f93a4ae6>] inet6_sk_rx_dst_set+0x3a/0x89 [ipv6] SS:ESP 0068:f5817c0c
[   67.260010] CR2: 0000000000010016
[   67.647660] ---[ end trace 292da9a1ec859dd5 ]---


Cheers,
Shaun
