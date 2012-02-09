Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2BIOny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:43:54 -0500
Received: from vt.electrainfo.com ([207.136.236.70]:60543 "EHLO
	black.transpect.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2BIOnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:43:52 -0500
Date: Thu, 9 Feb 2012 09:43:50 -0500
From: Whit Blauvelt <whit@transpect.com>
To: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/timer.c:1011 del_timer_sync+0x56/0x60() -
 3.2.2 - tulip?
Message-ID: <20120209144350.GA10609@black.transpect.com>
References: <20120129184437.GA10176@black.transpect.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120129184437.GA10176@black.transpect.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another instance, in this case with the card becoming non-operational. There
have been several other instances of the kernel halting possibly related. In
any case, stress testing CPU and RAM doesn't reproduce the halt.

Feb  8 19:38:08 whit kernel: [11045.627031] net eth0: (99048) System Error occurred (0)
Feb  8 19:38:08 whit kernel: [11045.627088] net eth0: (99048) System Error occurred (0)
Feb  8 19:38:19 whit kernel: [11057.050016] ------------[ cut here ]------------
Feb  8 19:38:19 whit kernel: [11057.050035] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x262/0x270()
Feb  8 19:38:19 whit kernel: [11057.050041] Hardware name: SK22V10
Feb  8 19:38:19 whit kernel: [11057.050046] NETDEV WATCHDOG: eth0 (tulip): transmit queue 0 timed out
Feb  8 19:38:19 whit kernel: [11057.050050] Modules linked in: Modules linked in: binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc
  exportfs dm_crypt xt_limit autofs4 ipt_REJECT xt_multiport ipt_LOG xt_tcpudp xt_state iptable_filter ip_tables
  nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_proto_udplite nf_conntrack_proto_dccp nf_conntrack_tftp speedstep_lib
  nf_conntrack_netbios_ns nf_conntrack_snmp nf_conntrack_broadcast nf_conntrack_proto_sctp nf_conntrack_irc          
  nf_conntrack_sane nf_conntrack_h323 nf_conntrack_pptp kvm_amd nf_conntrack_proto_gre kvm ts_kmp nf_conntrack_netlink
  nfnetlink nf_conntrack_amanda xt_conntrack x_tables nf_conntrack_sip snd_via82xx gameport snd_ac97_codec ac97_bus
  snd_pcm snd_page_alloc snd_mpu401_uart snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq nf_conntrack_ftp
  nf_conntrack snd_timer snd_seq_device firewire_sbp2 ppdev shpchp lp parport_pc k8temp bridge stp snd soundcore
  i2c_viapro parport edac_core edac_mce_amd e1000e floppy firewire_ohci sata_via via_rhine pata_via firewire_core
  crc_itu_t tulip
Feb  8 19:38:19 whit kernel: [11057.050182] Pid: 0, comm: swapper/0 Not tainted 3.2.2-black01 #1
Feb  8 19:38:19 whit kernel: [11057.050186] Call Trace:
Feb  8 19:38:19 whit kernel: [11057.050191]  <IRQ>  [<ffffffff81063d8f>] warn_slowpath_common+0x7f/0xc0
Feb  8 19:38:19 whit kernel: [11057.050211]  [<ffffffff81063e86>] warn_slowpath_fmt+0x46/0x50
Feb  8 19:38:19 whit kernel: [11057.050220]  [<ffffffff8108d638>] ? sched_clock_cpu+0xa8/0x110
Feb  8 19:38:19 whit kernel: [11057.050233]  [<ffffffff814f0f32>] dev_watchdog+0x262/0x270
Feb  8 19:38:19 whit kernel: [11057.050240]  [<ffffffff8105db02>] ? scheduler_tick+0x122/0x280
Feb  8 19:38:19 whit kernel: [11057.050249]  [<ffffffff810740a4>] run_timer_softirq+0x134/0x360
Feb  8 19:38:19 whit kernel: [11057.050256]  [<ffffffff814f0cd0>] ? netif_carrier_off+0x30/0x30
Feb  8 19:38:19 whit kernel: [11057.050265]  [<ffffffff8106b388>] __do_softirq+0xa8/0x1c0
Feb  8 19:38:19 whit kernel: [11057.050274]  [<ffffffff810981f4>] ? tick_program_event+0x24/0x30
Feb  8 19:38:19 whit kernel: [11057.050282]  [<ffffffff815e916c>] call_softirq+0x1c/0x30
Feb  8 19:38:19 whit kernel: [11057.050292]  [<ffffffff810152b5>] do_softirq+0x65/0xa0
Feb  8 19:38:19 whit kernel: [11057.050299]  [<ffffffff8106b71e>] irq_exit+0x8e/0xb0
Feb  8 19:38:19 whit kernel: [11057.050307]  [<ffffffff815e9b0e>] smp_apic_timer_interrupt+0x6e/0x99
Feb  8 19:38:19 whit kernel: [11057.050316]  [<ffffffff815e79de>] apic_timer_interrupt+0x6e/0x80
Feb  8 19:38:19 whit kernel: [11057.050321]  <EOI>  [<ffffffff8103b21b>] ? native_safe_halt+0xb/0x10
Feb  8 19:38:19 whit kernel: [11057.050337]  [<ffffffff8101b9c1>] default_idle+0x41/0xe0
Feb  8 19:38:19 whit kernel: [11057.050344]  [<ffffffff8101babd>] amd_e400_idle+0x5d/0x120
Feb  8 19:38:19 whit kernel: [11057.050351]  [<ffffffff81012276>] cpu_idle+0xd6/0x110
Feb  8 19:38:19 whit kernel: [11057.050362]  [<ffffffff815c1c45>] rest_init+0x75/0x80
Feb  8 19:38:19 whit kernel: [11057.050371]  [<ffffffff81ad7c0a>] start_kernel+0x3b3/0x3be
Feb  8 19:38:19 whit kernel: [11057.050379]  [<ffffffff81ad7347>] x86_64_start_reservations+0x132/0x136
Feb  8 19:38:19 whit kernel: [11057.050386]  [<ffffffff81ad744c>] x86_64_start_kernel+0x101/0x110
Feb  8 19:38:19 whit kernel: [11057.050393] ---[ end trace ff676ffe84ac588c ]---
Feb  8 19:38:19 whit kernel: [11057.050406] net eth0: PNIC2 transmit timed out, status ec69000d, CSR6/7 e7fe42c5 / e7fe42cd CSR12 000000c4, resetting...
Feb  8 19:38:27 whit kernel: [11065.050029] net eth0: PNIC2 transmit timed out, status ec69010f, CSR6/7 e7fe42c5 / e7fe42cd CSR12 000000c4, resetting...

Needless to say, I've swapped out the old NIC now.

Whit


On Sun, Jan 29, 2012 at 01:44:37PM -0500, Whit Blauvelt wrote:
> 3.2.2 kernel. Just in case it's of interest:
> 
> Jan 29 11:15:31 whit kernel: [50599.304905] ------------[ cut here ]------------
> Jan 29 11:15:31 whit kernel: [50599.304924] WARNING: at kernel/timer.c:1011 del_timer_sync+0x56/0x60()
> Jan 29 11:15:31 whit kernel: [50599.304929] Hardware name: SK22V10
> Jan 29 11:15:31 whit kernel: [50599.304933] Modules linked in: joydev st lp parport_pc binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs xt_limit ipt_REJECT xt_multiport ipt_LOG xt_tcpudp dm_crypt bridge xt_state stp iptable_filter ip_
> Jan 29 11:15:31 whit kernel: crc_itu_t sata_via [last unloaded: ppa]
> Jan 29 11:15:31 whit kernel: [50599.305073] Pid: 0, comm: swapper/1 Not tainted 3.2.2-black01 #1
> Jan 29 11:15:31 whit kernel: [50599.305078] Call Trace:
> Jan 29 11:15:31 whit kernel: [50599.305083]  <IRQ>  [<ffffffff81063d8f>] warn_slowpath_common+0x7f/0xc0
> Jan 29 11:15:31 whit kernel: [50599.305105]  [<ffffffff81063dea>] warn_slowpath_null+0x1a/0x20
> Jan 29 11:15:31 whit kernel: [50599.305111]  [<ffffffff81074406>] del_timer_sync+0x56/0x60
> Jan 29 11:15:31 whit kernel: [50599.305130]  [<ffffffffa002ee79>] pnic2_lnk_change+0xe9/0x698 [tulip]
> Jan 29 11:15:31 whit kernel: [50599.305145]  [<ffffffffa00283a9>] tulip_interrupt+0x1e9/0x1010 [tulip]
> Jan 29 11:15:31 whit kernel: [50599.305159]  [<ffffffff810d4d04>] handle_irq_event_percpu+0x54/0x200  
> Jan 29 11:15:31 whit kernel: [50599.305169]  [<ffffffff810d4f04>] handle_irq_event+0x54/0x80
> Jan 29 11:15:31 whit kernel: [50599.305178]  [<ffffffff810d7eca>] handle_fasteoi_irq+0x6a/0x100
> Jan 29 11:15:31 whit kernel: [50599.305190]  [<ffffffff81015232>] handle_irq+0x22/0x40
> Jan 29 11:15:31 whit kernel: [50599.305199]  [<ffffffff815e9a1d>] do_IRQ+0x5d/0xe0
> Jan 29 11:15:31 whit kernel: [50599.305210]  [<ffffffff815df0ee>] common_interrupt+0x6e/0x6e
> Jan 29 11:15:31 whit kernel: [50599.305215]  <EOI>  [<ffffffff8103b21b>] ? native_safe_halt+0xb/0x10  
> Jan 29 11:15:31 whit kernel: [50599.305233]  [<ffffffff8101b9c1>] default_idle+0x41/0xe0
> Jan 29 11:15:31 whit kernel: [50599.305241]  [<ffffffff8101babd>] amd_e400_idle+0x5d/0x120
> Jan 29 11:15:31 whit kernel: [50599.305250]  [<ffffffff81012276>] cpu_idle+0xd6/0x110     
> Jan 29 11:15:31 whit kernel: [50599.305259]  [<ffffffff815d70e8>] start_secondary+0x1e0/0x1e7
> Jan 29 11:15:31 whit kernel: [50599.305267] ---[ end trace 525e0a5d40ea44de ]---
> 
> Seeing "tulip" there, I'm guessing this relates to this old NIC:
> 
>   LNE100TX [Linksys EtherFast 10/100]
> 
> Whit
