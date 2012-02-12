Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab2BLGOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 01:14:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40386 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2BLGOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 01:14:37 -0500
MIME-Version: 1.0
Date: Sun, 12 Feb 2012 14:14:36 +0800
Message-ID: <CACVXFVPZr+RWm3+6ON9do0+HH+SPrW0OG-H2eAL+StOoCH1Ytg@mail.gmail.com>
Subject: 3.3-rc3-next BUG: scheduling while atomic: init/1/0x00000000
From: Ming Lei <tom.leiming@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel boot failed on 3.3.0-rc3-next-20120210-arm.


[    3.305847] BUG: scheduling while atomic: init/1/0x00000000
[    3.311706] Modules linked in:
[    3.314910] Backtrace:
[    3.317535] [<c0017340>] (dump_backtrace+0x0/0x110) from
[<c04096b4>] (dump_stack+0x18/0x1c)
[    3.326416]  r6:c05d0600 r5:00000000 r4:ee0c6b40 r3:60000113
[    3.332427] [<c040969c>] (dump_stack+0x0/0x1c) from [<c006b810>]
(__schedule_bug+0x84/0x98)
[    3.341217] [<c006b78c>] (__schedule_bug+0x0/0x98) from
[<c040b230>] (__schedule+0x74/0x768)
[    3.350097]  r5:c11c5600 r4:ee0c6b40
[    3.353851] [<c040b1bc>] (__schedule+0x0/0x768) from [<c040baa8>]
(schedule+0x78/0x7c)
[    3.362243] [<c040ba30>] (schedule+0x0/0x7c) from [<c040bb20>]
(io_schedule+0x74/0xa4)
[    3.370574] [<c040baac>] (io_schedule+0x0/0xa4) from [<c0127120>]
(sleep_on_buffer+0x10/0x18)
[    3.379547]  r6:c0127110 r5:c11b5da0 r4:ee0ddbe4 r3:00000002
[    3.385498] [<c0127110>] (sleep_on_buffer+0x0/0x18) from
[<c0409ee8>] (__wait_on_bit+0x5c/0xa4)
[    3.394653] [<c0409e8c>] (__wait_on_bit+0x0/0xa4) from [<c0409fb0>]
(out_of_line_wait_on_bit+0x80/0x8c)
[    3.404510] [<c0409f30>] (out_of_line_wait_on_bit+0x0/0x8c) from
[<c01270b8>] (__wait_on_buffer+0x28/0x30
)
[    3.414672] [<c0127090>] (__wait_on_buffer+0x0/0x30) from
[<c0181474>] (__ext4_get_inode_loc+0x414/0x47c)
[    3.424743] [<c0181060>] (__ext4_get_inode_loc+0x0/0x47c) from
[<c0183260>] (ext4_iget+0x48/0x620)
[    3.434143] [<c0183218>] (ext4_iget+0x0/0x620) from [<c018b9e0>]
(ext4_lookup+0x88/0x108)
[    3.442749] [<c018b958>] (ext4_lookup+0x0/0x108) from [<c0105d50>]
(d_alloc_and_lookup+0x4c/0x68)
[    3.452056]  r6:ee0dde48 r5:ea4d4e00 r4:ea529f68
[    3.457092] [<c0105d04>] (d_alloc_and_lookup+0x0/0x68) from
[<c0107bc8>] (do_lookup+0x204/0x328)
[    3.466308]  r6:ead77f68 r5:ee0dddbc r4:ee0dde48 r3:00000002
[    3.472290] [<c01079c4>] (do_lookup+0x0/0x328) from [<c0107ea4>]
(link_path_walk+0x1b8/0x7d4)
[    3.481262] [<c0107cec>] (link_path_walk+0x0/0x7d4) from
[<c01098d8>] (path_openat+0xa4/0x380)
[    3.490295] [<c0109834>] (path_openat+0x0/0x380) from [<c0109cc4>]
(do_filp_open+0x34/0x80)
[    3.499084] [<c0109c90>] (do_filp_open+0x0/0x80) from [<c0101684>]
(open_exec+0x24/0xf8)
[    3.507568]  r7:00000000 r6:eb025f00 r5:c05f1e10 r4:c0503132
[    3.513549] [<c0101660>] (open_exec+0x0/0xf8) from [<c0102c30>]
(do_execve+0x174/0x348)
[    3.521942]  r7:00000000 r6:eb025f00 r5:c05f1e10 r4:c0503132
[    3.527923] [<c0102abc>] (do_execve+0x0/0x348) from [<c0016e08>]
(kernel_execve+0x40/0x88)
[    3.536590] [<c0016dc8>] (kernel_execve+0x0/0x88) from [<c0008750>]
(run_init_process+0x1c/0x24)
[    3.545837]  r7:0000007e r6:c05b8a50 r5:c05b8a70 r4:c0648640
[    3.551940] [<c0008734>] (run_init_process+0x0/0x24) from
[<c00087e8>] (init_post+0x90/0xcc)
[    3.560821] [<c0008758>] (init_post+0x0/0xcc) from [<c0587a20>]
(kernel_init+0x178/0x1bc)
[    3.569427]  r4:00000007 r3:edc03f68
[    3.573211] [<c05878a8>] (kernel_init+0x0/0x1bc) from [<c0044b88>]
(do_exit+0x0/0x7b4)

thanks,
-- 
Ming Lei
