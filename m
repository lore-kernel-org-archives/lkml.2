Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1BBJCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:02:52 -0500
Received: from smtp-tls2.univ-nantes.fr ([193.52.101.146]:50206 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1BBJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:02:48 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Feb 2011 04:02:48 EST
Message-ID: <4D491B8D.1000107@univ-nantes.fr>
Date: Wed, 02 Feb 2011 09:53:33 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14pre) Gecko/20110118 Shredder/3.1.8pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel 2.6.37 : oops in cleanup_once
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
We recently upgraded one machine with vanilla 2.6.37, and experienced 2 
kernel oops since. Each oops is after ~1 week of uptime.
The last oops was last night but we didn't had any trace.

Here is the previous oops :

Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316042] 
BUG: unable to handle kernel NULL pointer dereference at 000000000000000d
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316096] 
IP: [<ffffffff8130e6bf>] cleanup_once+0x3f/0xa0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316135] PGD 0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316157] 
Oops: 0002 [#1] SMP
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316188] 
last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316234] CPU 1
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316240] 
Modules linked in: xt_physdev ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 
ipt_LOG xt_multiport xt_limit nf_conntrack_tftp nf_conntrack_ftp tun 
ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_tcpudp iptable_filter ip_tables x_tables kvm_intel kvm ipv6 8021q 
bridge stp ext2 mbcache fuse snd_pcm snd_timer snd soundcore 
snd_page_alloc i5000_edac edac_core psmouse evdev i5k_amb tpm_tis tpm 
joydev dcdbas tpm_bios pcspkr rng_core ghes shpchp serio_raw pci_hotplug 
processor hed button thermal_sys xfs exportfs dm_mod sg sr_mod sd_mod 
cdrom usbhid hid usb_storage qla2xxx scsi_transport_fc scsi_tgt uhci_hcd 
mptsas mptscsih ehci_hcd mptbase bnx2 scsi_transport_sas scsi_mod [last 
unloaded: scsi_wait_scan]
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316694]
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316715] 
Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-dsiun-110105 #17 
0MY736/PowerEdge M600
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316761] 
RIP: 0010:[<ffffffff8130e6bf>]  [<ffffffff8130e6bf>] cleanup_once+0x3f/0xa0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316808] 
RSP: 0018:ffff8800cfc43e20  EFLAGS: 00010202
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316834] 
RAX: ffff8803d3158018 RBX: ffff8803d3158000 RCX: 0000000000000005
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.316878] 
RDX: 0b000209f1beadde RSI: 00000000000000ac RDI: ffffffff8152a970
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318512] 
RBP: 00000000000248f6 R08: 00000000003d0900 R09: 0000000000000000
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318560] 
R10: dead000000200200 R11: 0000000000000000 R12: ffff8800cfc43ea0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318604] 
R13: 0000000000000100 R14: ffff88040fc99fd8 R15: 0000000000000000
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318652] 
FS:  0000000000000000(0000) GS:ffff8800cfc40000(0000) knlGS:0000000000000000
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318698] 
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318725] 
CR2: 000000000000000d CR3: 00000000014f1000 CR4: 00000000000026e0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318768] 
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318812] 
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318855] 
Process kworker/0:0 (pid: 0, threadinfo ffff88040fc98000, task 
ffff88040fc6c2e0)
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318901] 
Stack:
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318921]  
0000000000000082 00000001029221c1 00000000000248f6 ffffffff8130e988
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.318971]  
ffff88040fc90000 ffff88040fc90000 ffffffff8152a9a0 ffffffff8105e95f
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319021]  
ffff8800cfc43e58 ffff88040fc91020 ffffffff8130e950 ffff88040fc99fd8
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319072] 
Call Trace:
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319093] <IRQ>
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319116]  
[<ffffffff8130e988>] ? peer_check_expire+0x38/0x110
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319146]  
[<ffffffff8105e95f>] ? run_timer_softirq+0x16f/0x350
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319175]  
[<ffffffff8130e950>] ? peer_check_expire+0x0/0x110
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319204]  
[<ffffffff81079c6b>] ? ktime_get+0x5b/0xe0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319232]  
[<ffffffff8105685a>] ? __do_softirq+0xaa/0x1e0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319260]  
[<ffffffff81003ddc>] ? call_softirq+0x1c/0x30
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319288]  
[<ffffffff81005f75>] ? do_softirq+0x65/0xa0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319315]  
[<ffffffff81056745>] ? irq_exit+0x85/0x90
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319343]  
[<ffffffff8102137a>] ? smp_apic_timer_interrupt+0x6a/0xa0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319373]  
[<ffffffff81003893>] ? apic_timer_interrupt+0x13/0x20
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319401] <EOI>
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319427]  
[<ffffffffa032218c>] ? acpi_idle_enter_bm+0x243/0x27b [processor]
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319473]  
[<ffffffffa0322185>] ? acpi_idle_enter_bm+0x23c/0x27b [processor]
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319519]  
[<ffffffff812c0deb>] ? cpuidle_idle_call+0x8b/0x140
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319547]  
[<ffffffff8100208a>] ? cpu_idle+0x6a/0xf0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319573] 
Code: 00 48 8b 05 c4 c2 21 00 48 3d 60 a9 52 81 74 5c 48 8d 58 e8 48 8b 
15 11 02 24 00 2b 53 28 48 39 ea 72 49 48 8b 4b 18 48 8b 53 20 <48> 89 
51 08 48 89 0a 48 89 43 18 48 89 43 20 f0 ff 40 14 48 c7
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319768] 
RIP  [<ffffffff8130e6bf>] cleanup_once+0x3f/0xa0
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319797]  
RSP <ffff8800cfc43e20>
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.319820] 
CR2: 000000000000000d
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.320187] 
---[ end trace eaf3ed2d46c78768 ]---
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.320257] 
Kernel panic - not syncing: Fatal exception in interrupt
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.320329] 
Pid: 0, comm: kworker/0:0 Tainted: G      D     2.6.37-dsiun-110105 #17
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.320418] 
Call Trace:
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.320481] 
<IRQ>  [<ffffffff8137c75e>] ? panic+0x92/0x1a2
Jan 21 13:15:41 linkwood.u11.univ-nantes.prive kernel: [172825.320601]  
[<ffffffff81007357>] ? oops_end+0xe7/0xf0


Any ideas ??

This machine is running lots of kvm hosts. I can provide the .config if 
needed.

-- 
Yann Dupont - Service IRTS, DSI Université de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

