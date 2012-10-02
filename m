Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2JBNQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:16:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43170 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2JBNQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:16:30 -0400
MIME-Version: 1.0
From: Arthur Lambert <lambertarthur22@gmail.com>
Date: Tue, 2 Oct 2012 15:16:09 +0200
Message-ID: <CAGpqJgoGepfBFh6b=x7=r7vTDNTuwH9i5Bn5S1_=x+QWowVkow@mail.gmail.com>
Subject: kernel oops : filemap_fdatawait
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am on MIPS Architecture with a 2.6.28.8 kernel.

I have some kernel oops when I try to run my kernel module. I am
currently trying to debug this by check my code but its thousand of
lines and I have no clue except that its probably a problem of missing
spinlock or access to unallocated pointer value...

But I would like to know its not an old bug of linux due to my old
version. I have try to look for in the kernel archive mailing list but
nothing. Also perhaps you have idea about a magic way to debug this
kind of situation....  I hope that it's the good place to ask that.
here you are the kernel dump :

root@OpenWrt:/# Unhandled kernel unaligned access[#1]:
Cpu 0
$ 0   : 00000000 00005268 00000000 00000001
$ 4   : 8ef691e4 00000000 00000000 0000000e
$ 8   : 8ef69280 ffffffff 00000008 00000000
$12   : 8ef69280 000014b8 00000001 6c0629ec
$16   : 00000000 000007f3 8ef6927c 8ef6927c
$20   : 00000007 8c35bcb8 8ef692f4 8ef691e4
$24   : 00000000 00005268
$28   : 8c35a000 8c35bc38 00000001 80070518
Hi    : 000000a6
Lo    : 8033e4f0
epc   : 80070510 filemap_fdatawait+0x3c/0xbc
    Tainted: PF
ra    : 80070518 filemap_fdatawait+0x44/0xbc
Status: 1100ff03    KERNEL EXL IE
Cause : 80800014
BadVA : 00000096
PrId  : 00019554 (MIPS 34Kc)
Modules linked in: ahci ohci_hcd ehci_hcd libahci atmdriver_lkm(P)
pppRelay_lkm ath_switch_lkm(PF) em_nbyte cls_u32 sch_ingress cls_fw
cls_flow sch_dsmark ac [...]
Process dhcpd (pid: 2140, threadinfo=8c35a000, task=8989c038, tls=00000000)
Stack : 00000001 80078714 8ef691e4 00000000 8ef691e4 00000000 00000001 800c2c4c
        00000000 00000001 00000000 8f1c2008 8c35bcbf 800708f4 8c35bcc0 000000ef
        00000000 000007f2 00000000 00000704 00000001 8ef691e4 00000001 00000000
        8ef691e4 00000704 8ef6927c 800c2f90 8ef69250 80070604 8ef691e4 80325770
        00000000 00000001 00000000 7fffffff 00000000 00000000 00000000 00000000
        ...
Call Trace:
[<80070510>] filemap_fdatawait+0x3c/0xbc
[<800c2c4c>] __writeback_single_inode+0x110/0x3c4
[<800c2f90>] write_inode_now+0x90/0x124
[<800c315c>] generic_osync_inode+0x138/0x184
[<80071610>] sync_page_range+0xe0/0x144
[<80071d00>] generic_file_aio_write+0xd4/0x144
[<8012641c>] ubifs_aio_write+0x1a8/0x280
[<8009ffa8>] do_sync_write+0xd8/0x15c
[<800a0a60>] vfs_write+0xbc/0x154
[<800a11e4>] sys_write+0x50/0xbc
[<80012224>] stack_done+0x20/0x3c


Code: 8f820014  2442ffff  af820014 <0dbb12c0> e0ee0088  14400019
00000000  02111025  14400007


And this is another version of the oops that appears :

root@OpenWrt:~# reboot
Unhandled kernel unaligned access[#2]:
Cpu 0
$ 0   : 00000000 fffffff8 00000000 00000000
$ 4   : 8ec02c08 898ffd94 00000000 0000000e
$ 8   : 8ec02ca4 ffffffff ffffffff feced300
$12   : 0000001e 6df2049a 803ef988 00000000
$16   : 00000000 01341000 8ec02ca0 00000000
$20   : 80324870 80320000 004222b4 0042b870
$24   : 803ef9a8 2ab1f3c0
$28   : 898fe000 898ffe78 0042a688 80070518
Hi    : 0000007b
Lo    : 2dd65a80
epc   : 80070510 filemap_fdatawait+0x3c/0xbc
    Tainted: PF     D
ra    : 80070518 filemap_fdatawait+0x44/0xbc
Status: 1100ff03    KERNEL EXL IE
Cause : 80800014
BadVA : 00000096
PrId  : 00019554 (MIPS 34Kc)
Modules linked in: ahci ohci_hcd ehci_hcd libahci atmdriver_lkm(P)
pppRelay_lkm ath_switch_lkm(PF) em_nbyte cls_u32 sch_ingrec
Process reboot (pid: 1788, threadinfo=898fe000, task=8f1cae00, tls=00000000)
Stack : 00000059 800338cc 7fffffff ffffffff 00000000 8ec02ca0 80320000 80071708
        00000000 00000000 7fffffff ffffffff 8f1ff600 8f1ff640 800c3844 800c3824
        00000000 800a5134 00000000 00000001 00000000 00000002 00000001 7fc7bb44
        00000059 004093dc 800c38fc 00000001 7fc7b698 0000540d 00000001 00000002
        00000001 800c7298 2aabc000 00000000 00000000 00000002 00000000 800c730c
        ...
Call Trace:
[<80070510>] filemap_fdatawait+0x3c/0xbc
[<80071708>] filemap_write_and_wait+0x58/0x74
[<800c3844>] __sync_inodes+0xa0/0x140
[<800c38fc>] sync_inodes+0x18/0x3c
[<800c7298>] do_sync+0x20/0x84
[<800c730c>] sys_sync+0x10/0x20
[<80012224>] stack_done+0x20/0x3c


Code: 8f820014  2442ffff  af820014 <0d4cf260> e0ee0088  14400019
00000000  02111025  14400007
Segmentation fault

Thanks,

--
- Arthur LAMBERT
EPITA GISTR2012
