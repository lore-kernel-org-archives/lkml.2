Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0KXSqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:46:08 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57795 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752515Ab0KXSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:46:06 -0500
Date: Sat, 1 Jan 2000 13:11:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hans Beck?rus <hans.beckerus@telia.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: NBD and 2.6 kernel MIPS problem
Message-ID: <20000101121104.GA2583@ucw.cz>
References: <4CED455F.3050709@telia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED455F.3050709@telia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Hi, I recently compiled the NBD kernel module for a 2.6 ucLibc
> kernel and are experiencing
> some crash problems. Are there any known issues with the 2.6 range
> of kernels together with NBD?

Nothing known to me, but I no longer maintain nbd. I suggest you ask
lkml and Paul...

									Pavel

> The nbd-server and nbd-client seems ok though and handshaking works.
> The platform is MIPS based.
> 
> I also get these syslog entries when doing insmod:
> 
> nbd: no version for "struct_module" found: kernel tainted.
> nbd: registered device at major 43
> 
> The major device information I understand but not the first one.
> 
> Best regards,
> Hans
> 
> /tmp/usbmounts/sda1 # ./nbd-client 192.168.0.30 1024 /dev/nbd/0
> Negotiation: ..size = 20480KB
> bs=1024, sz=20480
> 
> /tmp/usbmounts/sda1 # mkdir /tmp/x
> /tmp/usbmounts/sda1 # mount /dev/nbd/0 /tmp/x
> Segmentation fault
> 
> syslog output:
> 
> CPU 0 Unable to handle kernel paging request at virtual address
> 0000c604, epc == 803100c4, ra == c0076ccc
> Oops in arch/mips/mm/fault.c::do_page_fault, line 229[#1]:
> Cpu 0
> $ 0   : 00000000 10007f00 00000050 00000050
> $ 4   : 0000c5f8 8083c18c 0000c5f8 8083c18c
> $ 8   : 812b1c24 812b1c2c 00000000 810f9428
> $12   : 00000000 00001269 81a1ff7c 805aad20
> $16   : 812b1c10 806860f8 8159804c 812b1c18
> $20   : 00000002 801ad7cc 80028000 00000000
> $24   : 00000000 c0076c70
> $28   : 812b0000 812b1ba8 00000001 c0076ccc
> Hi    : 00000000
> Lo    : 00000002
> epc   : 803100c4 elv_remove_request+0x14/0x58     Tainted: GF
> ra    : c0076ccc do_nbd_request+0x5c/0x3b8 [nbd]
> Status: 10007f02    KERNEL EXL
> Cause : c8808008
> BadVA : 0000c604
> PrId  : 00019378
> Modules linked in: nbd ohci_hcd ehci_hcd sata_mars libata
> Process mount (pid: 657, threadinfo=812b0000, task=810f9428)
> Stack : 00000000 812b1c18 80313a94 80313a84 8083c18c 812b1bbc
> 812b1c10 806860f8
>         00000000 80313af0 80160888 812b1bbc 812b1bbc 812b1bdc
> 801ad810 806d9bc0
>         00000000 00000001 80316378 812b1bdc 80432350 00000000
> 806d9bc0 00000001
>         80490c30 0000000c 800b5c04 00000002 00000000 810f9428
> 801608cc 806860f8
>         806860f8 00000000 800b5c04 00000002 00000000 810f9428
> 801608cc 812b1c24
>         ...
> Call Trace:
>  [<80313a94>] __generic_unplug_device+0x3c/0x64
>  [<80313a84>] __generic_unplug_device+0x2c/0x64
>  [<80313af0>] generic_unplug_device+0x34/0x78
>  [<80160888>] autoremove_wake_function+0x0/0x44
>  [<801ad810>] sync_buffer+0x44/0x5c
>  [<80316378>] submit_bio+0xc4/0xe0
>  [<80432350>] out_of_line_wait_on_bit+0x1d8/0x240
>  [<801608cc>] wake_bit_function+0x0/0x9c
>  [<801608cc>] wake_bit_function+0x0/0x9c
>  [<801b163c>] submit_bh+0x1bc/0x344
>  [<801b66a0>] __bread+0x1e4/0x21c
>  [<801b6678>] __bread+0x1bc/0x21c
>  [<801ba2bc>] sb_set_blocksize+0x28/0x6c
>  [<8021a27c>] ext3_fill_super+0x188/0x17fc
>  [<8021a230>] ext3_fill_super+0x13c/0x17fc
>  [<802d288c>] snprintf+0x14/0x20
>  [<801fedf4>] disk_name+0x44/0xc4
>  [<801b9c9c>] get_sb_bdev+0x29c/0x308
>  [<8017dff8>] kmem_cache_alloc+0x5c/0x98
>  [<8017a610>] __get_free_pages+0x2c/0x64
>  [<8021c7f4>] ext3_get_sb+0x18/0x24
>  [<8021a0f4>] ext3_fill_super+0x0/0x17fc
>  [<801b9f38>] do_kern_mount+0x68/0x1c0
>  [<801b9f00>] do_kern_mount+0x30/0x1c0
>  [<801c8ca4>] path_lookup+0x524/0x548
>  [<8017a258>] __alloc_pages+0x110/0x430
>  [<801e0404>] do_mount+0x810/0x874
>  [<801fe228>] filesystems_read_proc+0x34/0x6c
>  [<8017a610>] __get_free_pages+0x2c/0x64
>  [<80120900>] tlb_do_page_fault_0+0x100/0x108
>  [<8017a258>] __alloc_pages+0x110/0x430
>  [<8017a610>] __get_free_pages+0x2c/0x64
>  [<801dfb04>] copy_mount_options+0x3c/0x12c
>  [<80433d60>] __lock_text_end+0xea0/0x16d8
>  [<801e0f00>] sys_mount+0xa4/0x100
>  [<801abbd8>] sys_read+0x58/0xa0
>  [<801978c0>] sys_brk+0x100/0x128
>  [<8011dea0>] stack_done+0x20/0x3c
>  [<8011dea0>] stack_done+0x20/0x3c
> 
> 
> Code: 8ca20008  30420050  24030050 <14430004> 8c88000c  8c82015c
> 24420001  ac82015c  8cc20008
> eth0 Regs : 0xb8016000
>  00 1c 85 0b 6c 49 00 00 00 00 00 80 00 00 00 00
>  1a 11 76 d3 00 00 00 00 00 00 00 00 00 00 00 00
>  1e 2a 58 a9 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 02 03 f5 00 00
>  00 00 0c 00 00 00 00 0e 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 e0 00 00 00 84 01 78 6d
>  08 0a 04 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> eth0 Regs : 0xb8016100
>  a1 98 54 00 00 11 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  a1 98 50 00 00 13 02 00 00 00 00 00 00 00 00 00
> eth0 Regs : 0xb8016200
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  12 00 10 00 00 0c 34 0c 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> eth0 RxFDP : 0xa1985000
>  00 08 00 80 10 50 9a 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 40 9a 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 e0 20 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 c0 b6 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 40 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 30 0d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 90 0e 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 90 8d 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 e0 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 10 9a 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 40 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 10 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 90 9b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 b0 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 f0 9b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 a0 9a 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 90 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 20 67 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 70 4d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 e0 53 01 00 00 00 00 00 00 00 00
>  00 08 00 80 10 90 51 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 c0 8d 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 e0 8f 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 40 52 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 20 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 60 02 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 80 9b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 00 0b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 e0 4b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 f0 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 c0 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 a0 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 90 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 80 9a 01 00 00 00 00 00 00 00 00
>  00 08 00 80 10 e0 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 e0 9b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 30 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 d0 9b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 d0 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 b0 8d 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 90 8f 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 20 b8 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 80 0e 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 70 52 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 30 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 30 9a 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 c0 9a 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 e0 41 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 90 4c 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 c0 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 d0 4b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 00 3c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 a0 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 f0 9a 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 c0 05 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 70 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 90 a7 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 20 9d 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 c0 09 00 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 50 9b 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 70 4e 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 80 9c 01 00 00 00 00 ff ff 00 00
>  00 08 00 80 10 b0 9b 01 00 00 00 00 ff ff 00 00
>  00 08 00 c0 10 70 0e 01 00 00 00 00 ff ff 00 00
> note: mount[657] exited with preempt_count 1
> scheduling while atomic: mount/0x10000001/657
> Call Trace:
>  [<8042f9f8>] schedule+0x74/0xe18
>  [<804316e4>] cond_resched+0x44/0x84
>  [<801905d8>] unmap_vmas+0x514/0x5a4
>  [<80182258>] __pagevec_lru_add_active+0x28c/0x2b0
>  [<8018280c>] lru_add_drain+0x22c/0x288
>  [<80197970>] exit_mmap+0x88/0x21c
>  [<80138c5c>] mmput+0xf0/0x268
>  [<8013e3b4>] printk+0x1c/0x28
>  [<80141000>] do_exit+0x1cc/0x11cc
>  [<8011afec>] __die_if_kernel+0x0/0x30
>  [<8011afbc>] __die+0xd4/0x104
>  [<8013e3b4>] printk+0x1c/0x28
>  [<801202a4>] do_page_fault+0x314/0x450
>  [<803100c4>] elv_remove_request+0x14/0x58
>  [<c0076ccc>] do_nbd_request+0x5c/0x3b8 [nbd]
>  [<8017a258>] __alloc_pages+0x110/0x430
>  [<80176fe8>] mempool_alloc+0x88/0x1dc
>  [<80160888>] autoremove_wake_function+0x0/0x44
>  [<80160888>] autoremove_wake_function+0x0/0x44
>  [<801ad7cc>] sync_buffer+0x0/0x5c
>  [<80120900>] tlb_do_page_fault_0+0x100/0x108
>  [<803195b8>] exact_lock+0x10/0x28
>  [<801ad7cc>] sync_buffer+0x0/0x5c
>  [<c0076c70>] do_nbd_request+0x0/0x3b8 [nbd]
>  [<c0076ccc>] do_nbd_request+0x5c/0x3b8 [nbd]
>  [<803100c4>] elv_remove_request+0x14/0x58
>  [<80313a94>] __generic_unplug_device+0x3c/0x64
>  [<80313a84>] __generic_unplug_device+0x2c/0x64
>  [<80313af0>] generic_unplug_device+0x34/0x78
>  [<80160888>] autoremove_wake_function+0x0/0x44
>  [<801ad810>] sync_buffer+0x44/0x5c
>  [<80316378>] submit_bio+0xc4/0xe0
>  [<80432350>] out_of_line_wait_on_bit+0x1d8/0x240
>  [<801608cc>] wake_bit_function+0x0/0x9c
>  [<801608cc>] wake_bit_function+0x0/0x9c
>  [<801b163c>] submit_bh+0x1bc/0x344
>  [<801b66a0>] __bread+0x1e4/0x21c
>  [<801b6678>] __bread+0x1bc/0x21c
>  [<801ba2bc>] sb_set_blocksize+0x28/0x6c
>  [<8021a27c>] ext3_fill_super+0x188/0x17fc
>  [<8021a230>] ext3_fill_super+0x13c/0x17fc
>  [<802d288c>] snprintf+0x14/0x20
>  [<801fedf4>] disk_name+0x44/0xc4
>  [<801b9c9c>] get_sb_bdev+0x29c/0x308
>  [<8017dff8>] kmem_cache_alloc+0x5c/0x98
>  [<8017a610>] __get_free_pages+0x2c/0x64
>  [<8021c7f4>] ext3_get_sb+0x18/0x24
>  [<8021a0f4>] ext3_fill_super+0x0/0x17fc
>  [<801b9f38>] do_kern_mount+0x68/0x1c0
>  [<801b9f00>] do_kern_mount+0x30/0x1c0
>  [<801c8ca4>] path_lookup+0x524/0x548
>  [<8017a258>] __alloc_pages+0x110/0x430
>  [<801e0404>] do_mount+0x810/0x874
>  [<801fe228>] filesystems_read_proc+0x34/0x6c
>  [<8017a610>] __get_free_pages+0x2c/0x64
>  [<80120900>] tlb_do_page_fault_0+0x100/0x108
>  [<8017a258>] __alloc_pages+0x110/0x430
>  [<8017a610>] __get_free_pages+0x2c/0x64
>  [<801dfb04>] copy_mount_options+0x3c/0x12c
>  [<80433d60>] __lock_text_end+0xea0/0x16d8
>  [<801e0f00>] sys_mount+0xa4/0x100
>  [<801abbd8>] sys_read+0x58/0xa0
>  [<801978c0>] sys_brk+0x100/0x128
>  [<8011dea0>] stack_done+0x20/0x3c
>  [<8011dea0>] stack_done+0x20/0x3c
> 
> 
> 
> 
> 
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
