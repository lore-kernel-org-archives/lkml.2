Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0FHLXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:23:20 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:56486 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753386Ab0FHLXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:23:18 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2010 07:23:18 EDT
Message-ID: <4C0E2822.2060300@ribosome.natur.cuni.cz>
Date: Tue, 08 Jun 2010 13:23:14 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100516 Gentoo/2.0.4-r1 SeaMonkey/2.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32: <IRQ>  __alloc_pages_nodemask+0x54b/0x595
References: <4C0E26ED.3040103@ribosome.natur.cuni.cz>
In-Reply-To: <4C0E26ED.3040103@ribosome.natur.cuni.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Mokrejs wrote:
> Hi,
>   I am running a server with 16 GB RAM, which was running some long-time 
> CPU intensive job (a week). It has two SATA drives in RAID mirror mode.
> Once a week I re-sync the array members (part of the output included below).
> The hardware is MSI-P45Neo2 with intel quad cpu.

A short follow-up on my own posting:

r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:05:00.0: PCI->APIC IRQ transform: INT A -> IRQ 17
r8169 0000:05:00.0: setting latency timer to 64
r8169 0000:05:00.0: irq 30 for MSI/MSI-X
eth0: RTL8168c/8111c at 0xffffc90000020000, 00:21:85:c1:7a:66, XID 1c4000c0 IRQ 30


> swapper: page allocation failure. order:0, mode:0x20
> Pid: 0, comm: swapper Not tainted 2.6.32-default #6
> Call Trace:
>  <IRQ>  [<ffffffff8106c711>] __alloc_pages_nodemask+0x54b/0x595
>  [<ffffffff81409b82>] ? tcp_current_mss+0x43/0x62
>  [<ffffffff8108bad4>] cache_alloc_refill+0x24f/0x485
>  [<ffffffff8108bd90>] __kmalloc+0x86/0xb8
>  [<ffffffff813d9186>] __alloc_skb+0x67/0x154
>  [<ffffffff813d9d8f>] __netdev_alloc_skb+0x1d/0x3a
>  [<ffffffff81316586>] rtl8169_rx_fill+0xa3/0x14f
>  [<ffffffff8131698a>] rtl8169_rx_interrupt+0x358/0x3c2
>  [<ffffffff813190bc>] rtl8169_poll+0x37/0x19a
>  [<ffffffff813df943>] net_rx_action+0x6d/0x139
>  [<ffffffff8103ecab>] __do_softirq+0x91/0x11a
>  [<ffffffff8100c9bc>] call_softirq+0x1c/0x28
>  [<ffffffff8100e447>] do_softirq+0x33/0x6b
>  [<ffffffff8103e80a>] irq_exit+0x36/0x38
>  [<ffffffff8100db97>] do_IRQ+0xa0/0xb7
>  [<ffffffff8100c253>] ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff81012286>] ? mwait_idle+0x66/0x6b
>  [<ffffffff8100ad44>] ? enter_idle+0x20/0x22
>  [<ffffffff8100ad8e>] ? cpu_idle+0x48/0x7e
>  [<ffffffff817fd147>] ? start_secondary+0x17a/0x17e
> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:    0, btch:   1 usd:   0
> CPU    1: hi:    0, btch:   1 usd:   0
> CPU    2: hi:    0, btch:   1 usd:   0
> CPU    3: hi:    0, btch:   1 usd:   0
> DMA32 per-cpu:
> CPU    0: hi:  186, btch:  31 usd: 177
> CPU    1: hi:  186, btch:  31 usd: 148
> CPU    2: hi:  186, btch:  31 usd:  43
> CPU    3: hi:  186, btch:  31 usd: 166
> Normal per-cpu:
> CPU    0: hi:  186, btch:  31 usd: 193
> CPU    1: hi:  186, btch:  31 usd: 208
> CPU    2: hi:  186, btch:  31 usd:  37
> CPU    3: hi:  186, btch:  31 usd: 186
> active_anon:1343533 inactive_anon:140362 isolated_anon:64
>  active_file:714465 inactive_file:1753044 isolated_file:0
>  unevictable:0 dirty:11429 writeback:64667 unstable:0
>  free:18535 slab_reclaimable:106621 slab_unreclaimable:18444
>  mapped:11762 shmem:546 pagetables:6610 bounce:0
> DMA free:15864kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15240kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
> lowmem_reserve[]: 0 2999 16129 16129
> DMA32 free:53556kB min:3020kB low:3772kB high:4528kB active_anon:152716kB inactive_anon:39140kB active_file:544600kB inactive_file:1878536kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3071776kB mlocked:0kB dirty:11680kB writeback:70620kB mapped:160kB shmem:4kB slab_reclaimable:115388kB slab_unreclaimable:12992kB kernel_stack:24kB pagetables:484kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 13130 13130
> Normal free:4720kB min:13220kB low:16524kB high:19828kB active_anon:5221416kB inactive_anon:522308kB active_file:2313260kB inactive_file:5133640kB unevictable:0kB isolated(anon):256kB isolated(file):0kB present:13445120kB mlocked:0kB dirty:34036kB writeback:188048kB mapped:46888kB shmem:2180kB slab_reclaimable:311096kB slab_unreclaimable:60784kB kernel_stack:2744kB pagetables:25956kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0 0
> DMA: 0*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15864kB
> DMA32: 1628*4kB 1662*8kB 1702*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 1*4096kB = 53184kB
> Normal: 94*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 4472kB
> 2469490 total pagecache pages
> 1566 pages in swap cache
> Swap cache stats: add 130904, delete 129338, find 316914/317763
> Free swap  = 15167368kB
> Total swap = 15647288kB
> 4194288 pages RAM
> 82473 pages reserved
> 2444838 pages shared
> 1693229 pages non-shared
> ------------[ cut here ]------------
> WARNING: at net/sched/sch_generic.c:261 dev_watchdog+0xdf/0x13c()
> Hardware name: MS-7558
> NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> Modules linked in: f71882fg coretemp i2c_i801 firewire_ohci firewire_core
> Pid: 0, comm: swapper Not tainted 2.6.32-default #6
> Call Trace:
>  <IRQ>  [<ffffffff8103a51e>] warn_slowpath_common+0x77/0x8f
>  [<ffffffff8103a583>] warn_slowpath_fmt+0x3c/0x3e
>  [<ffffffff813ed984>] ? netif_tx_lock+0x3f/0x67
>  [<ffffffff813edad3>] dev_watchdog+0xdf/0x13c
>  [<ffffffff8104899e>] ? __queue_work+0x35/0x3e
>  [<ffffffff81042805>] run_timer_softirq+0x15a/0x1c4
>  [<ffffffff813ed9f4>] ? dev_watchdog+0x0/0x13c
>  [<ffffffff8101cce3>] ? lapic_next_event+0x10/0x14
>  [<ffffffff8103ecab>] __do_softirq+0x91/0x11a
>  [<ffffffff8105553d>] ? tick_program_event+0x25/0x27
>  [<ffffffff8100c9bc>] call_softirq+0x1c/0x28
>  [<ffffffff8100e447>] do_softirq+0x33/0x6b
>  [<ffffffff8103e80a>] irq_exit+0x36/0x38
>  [<ffffffff8101d39d>] smp_apic_timer_interrupt+0x81/0x8f
>  [<ffffffff8100c3b3>] apic_timer_interrupt+0x13/0x20
>  <EOI>  [<ffffffff81012286>] ? mwait_idle+0x66/0x6b
>  [<ffffffff8100ad44>] ? enter_idle+0x20/0x22
>  [<ffffffff8100ad8e>] ? cpu_idle+0x48/0x7e
>  [<ffffffff817fd147>] ? start_secondary+0x17a/0x17e
> ---[ end trace 277e396d24aaa901 ]---
> r8169: eth0: link up

[cut]

 
> # cat /proc/interrupts 
>            CPU0       CPU1       CPU2       CPU3       
>   0:       6622       6607       6535       6668   IO-APIC-edge      timer
>   1:      25945      26055      25838      26187   IO-APIC-edge      i8042
>   2:          0          0          0          0    XT-PIC-XT        cascade
>   4:          0          1          0          0   IO-APIC-edge    
>   8:         14         14         14         13   IO-APIC-edge      rtc0
>  12:          0          0          2          2   IO-APIC-edge      i8042
>  16:   10009479    9993440    9960761   10005048   IO-APIC-fasteoi   ahci, uhci_hcd:usb3
>  17:      31235      30566      30239      31562   IO-APIC-fasteoi   pata_jmicron, HDA Intel, firewire_ohci
>  18:          2          1          1          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb8
>  19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb5, uhci_hcd:usb7
>  21:         38         38         34         44   IO-APIC-fasteoi   uhci_hcd:usb4
>  22:         50         51         51         51   IO-APIC-fasteoi   HDA Intel
>  23:     172113     171807     171735     171915   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
>  29:   94874235   95288996   95218820   94798524   PCI-MSI-edge      ahci
>  30:   54750278   54778157   54873715   54762432   PCI-MSI-edge      eth0
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC: 3920740067 3913124351 2131868122 2120456788   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:          0          0          0          0   Performance monitoring interrupts
> PND:          0          0          0          0   Performance pending work
> RES:    7266829    7671287    7183417    8073089   Rescheduling interrupts
> CAL:   76080694        505   78997635         84   Function call interrupts
> TLB:   34542216   30185814   35666755   33126463   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:      26365      26365      26365      26365   Machine check polls
> ERR:          0
> MIS:          0
