Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1DSH7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:59:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1DSH7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vcHChaxb1JGQzbmx3KSPlPtaj/OKGTlVXvNqu0gnxreoVRFaJLmYko84Ym7yG03FcP
         /CqmxPAr39ljL1/1KOE2OaKfT1Sc65Sk6JWoICdmLKRk/DZkqeOgGPXjLCiNEO3oXQGA
         lEMrvMs+lbBdLIYerbgGIYhm2qa3H4f8Qa2WU=
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 09:59:20 +0200
Message-ID: <BANLkTimjxXkKa0_sLGW9ivz-aUxZGacmOA@mail.gmail.com>
Subject: BUG / Crash when using an Adaptec 31605 with 2.6.38.x
From: Endre Karlson <endre.karlson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: unable to handle kernel paging request at ffff880815386f50
IP: [<ffffffff8112a361>] do_split+0x269/0x428
PGD 16a6063 PUD 0
Oops: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:0e.0/host6/scsi_host/host6/proc_name
CPU 3
Modules linked in: raid0 aacraid

Pid: 28276, comm: rescan Not tainted 2.6.38.2 #5 Gigabyte Technology
Co., Ltd. H67A-UD3H-B3/H67A-UD3H-B3
RIP: 0010:[<ffffffff8112a361>]  [<ffffffff8112a361>] do_split+0x269/0x428
RSP: 0018:ffff8800845d1b08  EFLAGS: 00010202
RAX: 00000000ffffffff RBX: ffff8800845d1c80 RCX: ffff880015386f58
RDX: 0000000000000000 RSI: 0000000000000670 RDI: 0000000000000048
RBP: ffff8800968c7540 R08: ffff880015386f58 R09: 0000000000000800
R10: 0000000003629c88 R11: 00500db41b3a5a98 R12: ffff880089759000
R13: ffff880089759000 R14: ffff88008975a000 R15: 0000000000000015
FS:  00007f81b3777700(0000) GS:ffff8800dacc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff880815386f50 CR3: 00000000b8432000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rescan (pid: 28276, threadinfo ffff8800845d0000, task ffff88011e8932f0)
Stack:
 ffff880015387000 ffff880015386f58 ffff8800a4c7d3d8 0000100008080808
 ffff880015386000 0000000000001000 ffff880075313a68 ffff8800845d1c38
 ffff8800845d1c68 ffff88008975a000 ffff880000000048 ffff8800845d1c88
Call Trace:
 [<ffffffff8112ab8a>] ? ext3_add_entry+0x40f/0x845
 [<ffffffff81125610>] ? ext3_new_inode+0x8a2/0x8ea
 [<ffffffff8112b625>] ? ext3_add_nondir+0x18/0x60
 [<ffffffff8112babc>] ? ext3_create+0xa5/0xe3
 [<ffffffff810bcea7>] ? vfs_create+0x6a/0x9c
 [<ffffffff810bd7a7>] ? do_last+0x135/0x2d1
 [<ffffffff810bc9a2>] ? path_init_rcu+0x9e/0x174
 [<ffffffff810bf4a4>] ? do_filp_open+0x25a/0x573
 [<ffffffff811245e2>] ? ext3_readdir+0x1cb/0x525
 [<ffffffff810c0dea>] ? filldir+0x0/0xc3
 [<ffffffff8103937e>] ? current_fs_time+0x1e/0x24
 [<ffffffff810c5ed2>] ? touch_atime+0x6d/0x12c
 [<ffffffff810b278a>] ? do_sys_open+0x56/0xe1
 [<ffffffff81001ebb>] ? system_call_fastpath+0x16/0x1b
Code: 8d 04 06 45 39 c8 77 0d 0f b7 ff ff c2 01 fe ff c8 85 c0 79 d7
44 89 f8 29 d0 89 c2 89 c0 41 29 d7 4c 8d 04 c1 8d 42 ff 45 8b 10 <8b>
04 c1 48 8b 54 24 20 89 44 24 54 31 c0 eb 34 45 0f b7 48 04
RIP  [<ffffffff8112a361>] do_split+0x269/0x428
 RSP <ffff8800845d1b08>
CR2: ffff880815386f50
---[ end trace c61cd5b54d8b47de ]---

This happens when there's alot of read / writes on it, does anyone
know where to get info on this?
Controller is running newest firmware .
