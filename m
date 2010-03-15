Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936866Ab0COVaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:30:10 -0400
Received: from mail.vyatta.com ([76.74.103.46]:33587 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936835Ab0COVaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:30:06 -0400
Date: Mon, 15 Mar 2010 14:29:53 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org,
       Roger Oksanen <roger.oksanen@cs.helsinki.fi>
Subject: Re: [Stable-review] [19/39] e100: Use pci pool to work around
 GFP_ATOMIC order 5 memory allocation failure
Message-ID: <20100315142953.7aae4395@nehalam>
In-Reply-To: <20100105200301.449062585@mini.kroah.org>
References: <20100105195007.GA23952@kroah.com>
 <20100105200301.449062585@mini.kroah.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jan 2010 12:02:15 -0800
Greg KH <gregkh@suse.de> wrote:

> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
> 
> commit 98468efddb101f8a29af974101c17ba513b07be1 upstream.
> 
> pci_alloc_consistent uses GFP_ATOMIC allocation that may fail on some systems
> with limited memory (Bug #14265). pci_pool_alloc allows waiting with
> GFP_KERNEL.
> 
> Tested-by: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


These two e100 patches in 2.6.31.10 (and 2.6.32) caused kernel panic on one customer
system. I recommend they be reverted in next --stable update.



The user system configuration and backtrace were.
---
# lspci -v
00:00.0 Host bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
        Subsystem: ASUSTeK Computer Inc. A7V266-E Mainboard
        Flags: bus master, medium devsel, latency 0
        Memory at fc000000 (32-bit, prefetchable) [size=32M]
        Capabilities: [a0] AGP version 2.0
        Capabilities: [c0] Power Management version 2
        Kernel driver in use: agpgart-via
        Kernel modules: via-agp

00:01.0 PCI bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333 AGP] (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, medium devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Capabilities: [80] Power Management version 2
        Kernel modules: shpchp

00:05.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev 10)
        Subsystem: ASUSTeK Computer Inc. CMI8738 6ch-MX
        Flags: bus master, stepping, medium devsel, latency 32, IRQ 11
        I/O ports at d800 [size=256]
        Capabilities: [c0] Power Management version 2

00:06.0 Mass storage controller: Promise Technology, Inc. PDC20265 (FastTrak100 Lite/Ultra100) (rev 02)
        Subsystem: Promise Technology, Inc. Ultra100
        Flags: bus master, medium devsel, latency 32, IRQ 12
        I/O ports at d400 [size=8]
        I/O ports at d000 [size=4]
        I/O ports at b800 [size=8]
        I/O ports at b400 [size=4]
        I/O ports at b000 [size=64]
        Memory at fb000000 (32-bit, non-prefetchable) [size=128K]
        [virtual] Expansion ROM at 80020000 [disabled] [size=64K]
        Capabilities: [58] Power Management version 1
        Kernel driver in use: pata_pdc202xx_old
        Kernel modules: pata_pdc202xx_old

00:0c.0 VGA compatible controller: S3 Inc. ViRGE/DX or /GX (rev 01) (prog-if 00 [VGA controller])
        Subsystem: S3 Inc. ViRGE/DX
        Flags: bus master, medium devsel, latency 32, IRQ 12
        Memory at f4000000 (32-bit, non-prefetchable) [size=64M]
        Expansion ROM at 80030000 [disabled] [size=64K]
        Kernel modules: s3fb

00:0e.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 0c)
        Subsystem: Intel Corporation EtherExpress PRO/100 S Desktop Adapter
        Flags: bus master, medium devsel, latency 32, IRQ 11
        Memory at f3800000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at a800 [size=64]
        Memory at f3000000 (32-bit, non-prefetchable) [size=128K]
        [virtual] Expansion ROM at 80040000 [disabled] [size=64K]
        Capabilities: [dc] Power Management version 2
        Kernel driver in use: e100
        Kernel modules: e100

00:0f.0 Ethernet controller: Intel Corporation 82541PI Gigabit Ethernet Controller (rev 05)
        Subsystem: Intel Corporation PRO/1000 GT Desktop Adapter
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 10
        Memory at f2800000 (32-bit, non-prefetchable) [size=128K]
        Memory at f2000000 (32-bit, non-prefetchable) [size=128K]
        I/O ports at a400 [size=64]
        [virtual] Expansion ROM at 80000000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
        Capabilities: [e4] PCI-X non-bridge device
        Kernel driver in use: e1000
        Kernel modules: e1000

00:11.0 ISA bridge: VIA Technologies, Inc. VT8233 PCI to ISA Bridge
        Subsystem: ASUSTeK Computer Inc. VT8233A
        Flags: bus master, stepping, medium devsel, latency 0
        Capabilities: [c0] Power Management version 2
        Kernel modules: i2c-viapro

00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if 8a [Master SecP PriP])
        Flags: bus master, stepping, medium devsel, latency 32, IRQ 11
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
        I/O ports at a000 [size=16]
        Capabilities: [c0] Power Management version 2
        Kernel driver in use: pata_via
        Kernel modules: pata_via

00:11.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1b) (prog-if 00 [UHCI])
        Subsystem: First International Computer, Inc. VA-502 Mainboard
        Flags: bus master, medium devsel, latency 32, IRQ 12
        I/O ports at 9800 [size=32]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:11.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1b) (prog-if 00 [UHCI])
        Subsystem: First International Computer, Inc. VA-502 Mainboard
        Flags: bus master, medium devsel, latency 32, IRQ 12
        I/O ports at 9400 [size=32]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:11.4 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1b) (prog-if 00 [UHCI])
        Subsystem: First International Computer, Inc. VA-502 Mainboard
        Flags: bus master, medium devsel, latency 32, IRQ 12
        I/O ports at 9000 [size=32]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd





Code:

[  849.707104] BUG: unable to handle kernel NULL pointer dereference at 00000002
[  849.711050] IP: [<f7ca63e0>] e100_exec_cb+0x6b/0xd8 [e100]
[  849.711050] *pde = 00000000 
[  849.711050] Thread overran stack, or stack corrupted
[  849.711050] Oops: 0002 [#1] SMP 
[  849.711050] last sysfs file: /sys/class/i2c-adapter/i2c-0/name
[  849.711050] Modules linked in: ip_gre xt_comment unionfs iptable_nat iptable_filter ip6table_filter ip6table_raw ip6_tables xt_NOTRACK iptable_raw ip_tables x_tables nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_h323 nf_conntrack_h323 nf_nat_sip nf_conntrack_sip nf_nat_proto_gre nf_nat_tftp nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_tftp nf_conntrack_ftp nf_conntrack ipv6 evdev serio_raw parport_pc pcspkr parport processor button i2c_viapro shpchp i2c_core pci_hotplug via_agp agpgart ext3 jbd mbcache raid6_pq async_xor async_memcpy async_tx xor md_mod sg usb_storage sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic pata_pdc202xx_old pata_via uhci_hcd libata usbcore nls_base e1000 e100 mii scsi_mod thermal fan thermal_sys [last unloaded: raid10]
[  849.711050] 
[  849.711050] Pid: 0, comm: swapper Tainted: G        W  (2.6.31-1-586-vyatta #1) System Name
[  849.711050] EIP: 0060:[<f7ca63e0>] EFLAGS: 00010006 CPU: 0
[  849.711050] EIP is at e100_exec_cb+0x6b/0xd8 [e100]
[  849.711050] EAX: 00000000 EBX: f67dffe0 ECX: 000004ce EDX: 36697510
[  849.711050] ESI: f6d8e340 EDI: 00000000 EBP: f67310c0 ESP: c12d1ca0
[  849.711050]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  849.711050] Process swapper (pid: 0, ti=c12d0000 task=c12febc0 task.ti=c12d0000)
[  849.711050] Stack:
[  849.711050]  f7ca5190 f6d8e380 00000286 f6d8e000 f6d8e340 f67310c0 f6d8e000 f7ca68a5
[  849.711050] <0> 00000000 f67310c0 c132d150 c11a3bb8 f64b9b80 f7ca83b8 00000004 00000000
[  849.711050] <0> f64b9b80 f66b4100 f67310c0 c11b14a3 000218d2 f66b415c f6d8e000 f64b9b80
[  849.711050] Call Trace:
[  849.711050]  [<f7ca5190>] ? e100_xmit_prepare+0x0/0x97 [e100]
[  849.711050]  [<f7ca68a5>] ? e100_xmit_frame+0x5b/0xd9 [e100]
[  849.711050]  [<c11a3bb8>] ? dev_hard_start_xmit+0x205/0x298
[  849.711050]  [<c11b14a3>] ? __qdisc_run+0xbd/0x196
[  849.711050]  [<c11a3f6d>] ? dev_queue_xmit+0x243/0x336
[  849.711050]  [<c11c2098>] ? ip_finish_output2+0x189/0x1c4
[  849.711050]  [<c11c15d8>] ? ip_local_out+0x15/0x17
[  849.711050]  [<c11c1d8f>] ? ip_queue_xmit+0x2f4/0x338
[  849.711050]  [<c101c15f>] ? activate_task+0x1c/0x21
[  849.711050]  [<c1026086>] ? try_to_wake_up+0x193/0x19d
[  849.711050]  [<c10a4a2e>] ? pollwake+0x5d/0x67
[  849.711050]  [<c11d3c46>] ? tcp_v4_send_check+0x7a/0xb0
[  849.711050]  [<c11d0833>] ? tcp_transmit_skb+0x5c9/0x602
[  849.711050]  [<c11d09d8>] ? tcp_send_ack+0xcf/0xd3
[  849.711050]  [<c11cef3d>] ? tcp_rcv_established+0x383/0x4cd
[  849.711050]  [<c11d50a2>] ? tcp_v4_do_rcv+0x151/0x2a1
[  849.711050]  [<c11d5592>] ? tcp_v4_rcv+0x3a0/0x594
[  849.711050]  [<c11be22e>] ? ip_local_deliver_finish+0xca/0x14e
[  849.711050]  [<c11bdeb5>] ? ip_rcv_finish+0x295/0x2a9
[  849.711050]  [<c11a3168>] ? netif_receive_skb+0x3cb/0x3e6
[  849.711050]  [<f7ca7afb>] ? e100_poll+0x184/0x29d [e100]
[  849.711050]  [<c11a36b9>] ? net_rx_action+0x91/0x173
[  849.711050]  [<c102e431>] ? __do_softirq+0xa5/0x147
[  849.711050]  [<c102e4f6>] ? do_softirq+0x23/0x27
[  849.711050]  [<c102e5d3>] ? irq_exit+0x26/0x53
[  849.711050]  [<c10043fd>] ? do_IRQ+0x78/0x89
[  849.711050]  [<c1002fe9>] ? common_interrupt+0x29/0x30
[  849.711050]  [<c10085ae>] ? default_idle+0x3e/0x5c
[  849.711050]  [<c1001c5c>] ? cpu_idle+0x41/0x5d
[  849.711050]  [<c132e744>] ? start_kernel+0x29c/0x29f
[  849.711050] Code: 89 86 8c 00 00 00 89 f0 89 ab 2c 02 00 00 83 7e 50 01 19 ff 83 e7 e4 ff 14 24 66 81 4b 02 00 40 0f ae f8 8b c0 8b 83 24 02 00 00 <66> 81 60 02 ff bf eb 40 8b 88 28 02 00 00 89 f0 0f b6 56 4c e8 
[  849.711050] EIP: [<f7ca63e0>] e100_exec_cb+0x6b/0xd8 [e100] SS:ESP 0068:c12d1ca0
[  849.711050] CR2: 0000000000000002
[  849.711050] ---[ end trace 4eaa2a86a8e2da24 ]---
[  849.711050] Kernel panic - not syncing: Fatal exception in interrupt
[  849.711050] Pid: 0, comm: swapper Tainted: G      D W  2.6.31-1-586-vyatta #1
[  849.711050] Call Trace:
[  849.711050]  [<c120bee2>] ? panic+0x38/0xd1
[  849.711050]  [<c100581c>] ? oops_end+0x6c/0x76
[  849.711050]  [<c1017f6a>] ? no_context+0x105/0x10e
[  849.711050]  [<c101809b>] ? __bad_area_nosemaphore+0x128/0x133
[  849.711050]  [<c101c15f>] ? activate_task+0x1c/0x21
[  849.711050]  [<f7f3f5de>] ? ipt_do_table+0x4b2/0x4f0 [ip_tables]
[  849.711050]  [<f7ca5e09>] ? e100_exec_cmd+0x7f/0x88 [e100]
[  849.711050]  [<f7ca6443>] ? e100_exec_cb+0xce/0xd8 [e100]
[  849.711050]  [<c10181ce>] ? do_page_fault+0x0/0x270
[  849.711050]  [<c10180b0>] ? bad_area_nosemaphore+0xa/0xc
[  849.711050]  [<c120dac6>] ? error_code+0x66/0x70
[  849.711050]  [<c10181ce>] ? do_page_fault+0x0/0x270
[  849.711050]  [<f7ca63e0>] ? e100_exec_cb+0x6b/0xd8 [e100]
[  849.711050]  [<f7ca5190>] ? e100_xmit_prepare+0x0/0x97 [e100]
[  849.711050]  [<f7ca68a5>] ? e100_xmit_frame+0x5b/0xd9 [e100]
[  849.711050]  [<c11a3bb8>] ? dev_hard_start_xmit+0x205/0x298
[  849.711050]  [<c11b14a3>] ? __qdisc_run+0xbd/0x196
[  849.711050]  [<c11a3f6d>] ? dev_queue_xmit+0x243/0x336
[  849.711050]  [<c11c2098>] ? ip_finish_output2+0x189/0x1c4
[  849.711050]  [<c11c15d8>] ? ip_local_out+0x15/0x17
[  849.711050]  [<c11c1d8f>] ? ip_queue_xmit+0x2f4/0x338
[  849.711050]  [<c101c15f>] ? activate_task+0x1c/0x21
[  849.711050]  [<c1026086>] ? try_to_wake_up+0x193/0x19d
[  849.711050]  [<c10a4a2e>] ? pollwake+0x5d/0x67
[  849.711050]  [<c11d3c46>] ? tcp_v4_send_check+0x7a/0xb0
[  849.711050]  [<c11d0833>] ? tcp_transmit_skb+0x5c9/0x602
[  849.711050]  [<c11d09d8>] ? tcp_send_ack+0xcf/0xd3
[  849.711050]  [<c11cef3d>] ? tcp_rcv_established+0x383/0x4cd
[  849.711050]  [<c11d50a2>] ? tcp_v4_do_rcv+0x151/0x2a1
[  849.711050]  [<c11d5592>] ? tcp_v4_rcv+0x3a0/0x594
[  849.711050]  [<c11be22e>] ? ip_local_deliver_finish+0xca/0x14e
[  849.711050]  [<c11bdeb5>] ? ip_rcv_finish+0x295/0x2a9
[  849.711050]  [<c11a3168>] ? netif_receive_skb+0x3cb/0x3e6
[  849.711050]  [<f7ca7afb>] ? e100_poll+0x184/0x29d [e100]
[  849.711050]  [<c11a36b9>] ? net_rx_action+0x91/0x173
[  849.711050]  [<c102e431>] ? __do_softirq+0xa5/0x147
[  849.711050]  [<c102e4f6>] ? do_softirq+0x23/0x27
[  849.711050]  [<c102e5d3>] ? irq_exit+0x26/0x53
[  849.711050]  [<c10043fd>] ? do_IRQ+0x78/0x89
[  849.711050]  [<c1002fe9>] ? common_interrupt+0x29/0x30
[  849.711050]  [<c10085ae>] ? default_idle+0x3e/0x5c
[  849.711050]  [<c1001c5c>] ? cpu_idle+0x41/0x5d
[  849.711050]  [<c132e744>] ? start_kernel+0x29c/0x29f
[  849.711050] Rebooting in 60 seconds..



