Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab2LCWo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 17:44:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40991 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2LCWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 17:44:26 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxO+nOM--EJmrT+_54jF8AL2YZ7GhbwCT2cg2qxM2Md+A@mail.gmail.com>
References: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
	<874nk2u69u.fsf@silenus.orebokech.com>
	<CA+55aFxO+nOM--EJmrT+_54jF8AL2YZ7GhbwCT2cg2qxM2Md+A@mail.gmail.com>
Date: Mon, 3 Dec 2012 14:44:24 -0800
X-Google-Sender-Auth: bEaLkrMf4ekeF874XBBHWuofY8o
Message-ID: <CA+8MBbJGy7xQFqi1VXPuPNHJnoZUcxjWDkmyRKeajXGAA_Q+GA@mail.gmail.com>
Subject: Re: Linux 3.7-rc8
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just for info, can you add a "WARN_ON_ONCE()" to handle_bad_sector()
> just so that I see which particular path your kvm load triggers.

On native ia64 (with SLES11 userspace) I see:

WARNING: at block/blk-core.c:1557 generic_make_request_checks+0x680/0xa40()
Hardware name: I8QBH
Modules linked in: usb_storage sg container button usbhid uhci_hcd
ehci_hcd usbcore usb_common fan processor thermal thermal_sys

Call Trace:
 [<a000000100016280>] show_stack+0x80/0xa0
                                sp=e0000003153cf670 bsp=e0000003153c1638
 [<a000000100af0310>] dump_stack+0x30/0x50
                                sp=e0000003153cf840 bsp=e0000003153c1620
 [<a00000010007eba0>] warn_slowpath_common+0xc0/0x100
                                sp=e0000003153cf840 bsp=e0000003153c15d8
 [<a00000010007ec20>] warn_slowpath_null+0x40/0x60
                                sp=e0000003153cf840 bsp=e0000003153c15b0
 [<a00000010050dd20>] generic_make_request_checks+0x680/0xa40
                                sp=e0000003153cf840 bsp=e0000003153c1570
 [<a00000010050e110>] generic_make_request+0x30/0x280
                                sp=e0000003153cf880 bsp=e0000003153c1550
 [<a00000010050e4d0>] submit_bio+0x170/0x3c0
                                sp=e0000003153cf890 bsp=e0000003153c1500
 [<a000000100277570>] submit_bh+0x310/0x4e0
                                sp=e0000003153cf8b0 bsp=e0000003153c14d0
 [<a000000100281b80>] block_read_full_page+0x720/0x820
                                sp=e0000003153cf8b0 bsp=e0000003153c1430
 [<a000000100288e10>] blkdev_readpage+0x30/0x60
                                sp=e0000003153cfcb0 bsp=e0000003153c1408
 [<a00000010017a7e0>] read_pages+0x220/0x260
                                sp=e0000003153cfcb0 bsp=e0000003153c13a0
 [<a00000010017a950>] __do_page_cache_readahead+0x130/0x320
                                sp=e0000003153cfce0 bsp=e0000003153c1310
 [<a00000010017ab80>] ra_submit+0x40/0x60
                                sp=e0000003153cfcf0 bsp=e0000003153c12e0
 [<a00000010017b1b0>] ondemand_readahead+0x210/0x580
                                sp=e0000003153cfcf0 bsp=e0000003153c1278
 [<a00000010017b730>] page_cache_sync_readahead+0x90/0x100
                                sp=e0000003153cfcf0 bsp=e0000003153c1238
 [<a000000100162070>] do_generic_file_read+0x770/0xce0
                                sp=e0000003153cfcf0 bsp=e0000003153c1140
 [<a000000100163c40>] generic_file_aio_read+0x260/0x5c0
                                sp=e0000003153cfcf0 bsp=e0000003153c10d0
 [<a00000010020d470>] do_sync_read+0x130/0x240
                                sp=e0000003153cfd30 bsp=e0000003153c1078
 [<a00000010020f070>] vfs_read+0x1b0/0x340
                                sp=e0000003153cfe20 bsp=e0000003153c1030
 [<a00000010020f390>] sys_read+0x90/0xe0
                                sp=e0000003153cfe20 bsp=e0000003153c0fb0
 [<a00000010000bc40>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000003153cfe30 bsp=e0000003153c0fb0
 [<a000000000040720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000003153d0000 bsp=e0000003153c0fb0
