Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0IAWta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 18:49:30 -0400
Received: from sati.usurf.usu.edu ([129.123.194.129]:38884 "EHLO
	echo.usurf.usu.edu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab0IAWt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 18:49:28 -0400
From: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
To: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: Memory allocation modifications in ibm_newemac driver
Thread-Topic: Memory allocation modifications in ibm_newemac driver
Thread-Index: ActKFh1163SqUHTiROCjSFgwjSee2wABD/h2AAHTCpEAAXilaQ==
Date: Wed, 1 Sep 2010 22:46:42 +0000
Message-ID: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A305B@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2F09@Mercury.usurf.usu.edu>,<5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2FBE@Mercury.usurf.usu.edu>,<5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A301B@Mercury.usurf.usu.edu>
In-Reply-To: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A301B@Mercury.usurf.usu.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently I spoke too soon - sorry about that.  I am still getting the error when I try to write to disk and receive on the network at the same time.  Here is the output:

blastee: page allocation failure. order:1, mode:0x4020
Call Trace:
[ccea9a40] [c0006ef0] show_stack+0x44/0x16c (unreliable)
[ccea9a80] [c006f9f0] __alloc_pages_nodemask+0x38c/0x4f8
[ccea9b00] [c0095008] __slab_alloc+0x594/0x5e0
[ccea9b40] [c0095a08] __kmalloc_track_caller+0xe8/0xf0
[ccea9b60] [c01c848c] __alloc_skb+0x60/0x140
[ccea9b80] [c01a7df8] emac_poll_rx+0x568/0x768
[ccea9bc0] [c01a28e4] mal_poll+0xa8/0x1ec
[ccea9bf0] [c01d3eec] net_rx_action+0x9c/0x1b4
[ccea9c20] [c003b3c0] __do_softirq+0xc4/0x148
[ccea9c60] [c0004d18] do_softirq+0x78/0x80
[ccea9c70] [c003b67c] local_bh_enable+0xc0/0xd8
[ccea9c80] [c01c29bc] lock_sock_nested+0xc0/0xdc
[ccea9cc0] [c0212cb4] udp_recvmsg+0x318/0x3a4
[ccea9d10] [c01c2334] sock_common_recvmsg+0x3c/0x60
[ccea9d30] [c01c06c4] sock_recvmsg+0xb8/0xf0
[ccea9e20] [c01c09b0] sys_recvfrom+0x8c/0xfc
[ccea9f00] [c01c18d4] sys_socketcall+0x128/0x1f8
[ccea9f40] [c000f434] ret_from_syscall+0x0/0x3c
Mem-Info:
DMA per-cpu:
CPU    0: hi:   90, btch:  15 usd:  48
Active_anon:28 active_file:807 inactive_anon:85
 inactive_file:171 unevictable:0 dirty:0 writeback:0 unstable:0
 free:506 slab:53530 mapped:362 pagetables:19 bounce:0
DMA free:2024kB min:2036kB low:2544kB high:3052kB active_anon:112kB inactive_anon:340kB active_file:3228kB inactive_file:684kB unevictable:0kB present:260096kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 410*4kB 28*8kB 4*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2024kB
978 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
65536 pages RAM
1400 pages reserved
1001 pages shared
62828 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
  node 0: slabs: 7140, objs: 25809, free: 0

Can anyone explain to me why I would be getting this error in the first place?  Why is it failing to allocate a page when there are pages available?  That does not make any sense to me.

Thanks,

Jonathan