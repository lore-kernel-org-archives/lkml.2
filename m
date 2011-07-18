Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab1GRVwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:52:41 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:41029 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1GRVwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:52:40 -0400
MIME-Version: 1.0
Date: Mon, 18 Jul 2011 15:52:38 -0600
Message-ID: <CAN6cQ7ns8mdpgQmfdt+rf+41_eORsWsrXfK87ntGPR5LLCwwpA@mail.gmail.com>
Subject: Debugging a kernel panic on init (powerpc)
From: Brian Szmyd <brian.szmyd@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to resolve a kernel panic on my embedded system running a
PowerPC 405EP using the hotfoot platform. I am migrating from 2.6.11
to 2.6.35-13, however when kernel comes up and mounts the NFS root it
proceeds to panic with the message "Kernel panic - not syncing:
Attempted to kill init!". This root filesystem successfully brings up
my older 2.6.11 kernel, so the architecture and symlinks to busybox
are all okay as far as I can tell. I've also tried a JFFS2 filesystem
on my NOR flash with the same result. I would appreciate any advice or
suggestion on methods to debug this problem as I have exhausted all
avenues that I am aware of. Appreciate all replies to CC me directly
as I am not following the mailing at the moment.

Thanks in advance, and a snippet from the console:

Using PowerPC 40x Platform machine description
Linux version 2.6.35.13+ (bszmyd@bszmyd-laptop) (gcc version 4.6.1
(GCC) ) #2 PREEMPT Mon Jul 18 11:55:54 MDT 2011
Found legacy serial port 0 for /plb/opb/serial@ef600300
  mem=ef600300, taddr=ef600300, irq=0, clk=11097222, speed=38400
Found legacy serial port 1 for /plb/opb/serial@ef600400
  mem=ef600400, taddr=ef600400, irq=0, clk=11097222, speed=38400
Top of RAM: 0x8000000, Total RAM: 0x8000000
Memory hole size: 0MB
Zone PFN ranges:
  DMA      0x00000000 -> 0x00008000
  Normal   empty
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00008000
On node 0 totalpages: 32768
free_area_init_node: node 0, pgdat c035f1a8, node_mem_map c0382000
  DMA zone: 256 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 32512 pages, LIFO batch:7
MMU: Allocated 1088 bytes of context maps for 255 contexts
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: root=/dev/nfs rw console=ttyS0,38400 noinitrd
debug nfsroot=10.20.9.33:/home/bszmyd/nfs ip=dhcp
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 126316k/131072k available (3344k kernel code, 4756k reserved,
152k data, 88k bss, 128k init)
Kernel virtual memory layout:
  * 0xfffdf000..0xfffff000  : fixmap
  * 0xfde00000..0xfe000000  : consistent mem
  * 0xfde00000..0xfde00000  : early ioremap
  * 0xc9000000..0xfde00000  : vmalloc & ioremap
SLUB: Genslabs=11, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
...
eth0: link is down
eth0: link is up, 100 FDX, pause enabled
Sending DHCP requests .., OK
IP-Config: Got DHCP answer from 0.0.0.0, my address is 10.20.9.108
IP-Config: Complete:
     device=eth0, addr=10.20.9.108, mask=255.255.248.0, gw=10.20.8.1,
     host=10.20.9.108, domain=quantum.com, nis-domain=(none),
     bootserver=0.0.0.0, rootserver=10.20.9.33, rootpath=
Looking up port of RPC 100003/2 on 10.20.9.33
Looking up port of RPC 100005/1 on 10.20.9.33
VFS: Mounted root (nfs filesystem) on device 0:12.
Freeing unused kernel memory: 128k init
Kernel panic - not syncing: Attempted to kill init!
Call Trace:
[c781fd30] [c0007964] show_stack+0x48/0x15c (unreliable)
[c781fd70] [c0291b98] panic+0xb8/0x12c
[c781fdc0] [c0025bb8] do_exit+0x628/0x67c
[c781fe10] [c0025eec] do_group_exit+0x44/0xd0
[c781fe20] [c003277c] get_signal_to_deliver+0x1f4/0x44c
[c781fe70] [c00084c0] do_signal_pending.constprop.8+0x40/0x248
[c781ff30] [c0008840] do_signal+0x50/0x58
[c781ff40] [c000fba8] do_user_signal+0x74/0xc4
Rebooting in 180 seconds...

brian szmyd : brian.szmyd@gmail.com
