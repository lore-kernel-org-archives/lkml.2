Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1IFCL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 22:11:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52028 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1IFCLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 22:11:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110905224749.GC26980@sucs.org>
References: <20110901210442.GA9660@sucs.org>
	<20110905224749.GC26980@sucs.org>
Date: Tue, 6 Sep 2011 10:11:17 +0800
Message-ID: <CABqxG0efguhCqgz3hFyz9d1ouV84E-K1rK7BLJYsuvL13J1QZQ@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6c6f (bdi_lock_two+0x22/0x50)
From: Dave Young <hidave.darkstar@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 6:47 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Thu, Sep 01, 2011 at 10:04:42PM +0100, Sitsofe Wheeler wrote:
>> When pulling out a USB flash disk formatted with a single FAT32
>> partition the following oops and errors are produced:

Hi, please try patch in following thread:
https://lkml.org/lkml/2011/8/31/23

>>
>> [  112.427744] FAT-fs (sdc1): FAT read failed (blocknr 685)
>> [  112.427832] FAT-fs (sdc1): unable to read inode block for updating (i_pos 209504275)
>> [  112.523097] BUG: unable to handle kernel paging request at 6b6b6c6f
>> [  112.523229] IP: [<b0157dbf>] __lock_acquire+0x23f/0x1740
>> [  112.523328] *pde = 00000000
>> [  112.523381] Oops: 0002 [#1] DEBUG_PAGEALLOC
>> [  112.523459]
>> [  112.523490] Pid: 1486, comm: nautilus Not tainted 3.1.0-rc4-00131-g9e79e3e-dirty #488 ASUSTeK Computer INC. 900/900
>> [  112.523665] EIP: 0060:[<b0157dbf>] EFLAGS: 00010002 CPU: 0
>> [  112.523751] EIP is at __lock_acquire+0x23f/0x1740
>> [  112.523826] EAX: 00000001 EBX: daa5b510 ECX: 6b6b6b6b EDX: 00000000
>> [  112.523922] ESI: 00000002 EDI: ee4f9e84 EBP: dae63d2c ESP: dae63cbc
>> [  112.524011]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>> [  112.524011] Process nautilus (pid: 1486, ti=dae62000 task=daa5b510 task.ti=dae62000)
>> [  112.524011] Stack:
>> [  112.524011]  dae63d38 00000246 b026be79 00000000 00160007 00000006 dc198958 00000282
>> [  112.524011]  daa5b528 daa5b950 b08ff1b0 00000000 b0afab18 00000001 00000000 000052d7
>> [  112.524011]  ee802280 ef513308 dc198e60 dc198958 00000282 dc198000 00160006 b0ca9414
>> [  112.524011] Call Trace:
>> [  112.524011]  [<b026be79>] ? kobject_release+0x49/0x90
>> [  112.524011]  [<b01597cb>] lock_acquire+0x7b/0x90
>> [  112.524011]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
>> [  112.524011]  [<b055ef2a>] _raw_spin_lock_nested+0x3a/0x50
>> [  112.524011]  [<b0182b62>] ? bdi_lock_two+0x22/0x50
>> [  112.524011]  [<b0182b62>] bdi_lock_two+0x22/0x50
>> [  112.524011]  [<b01c7dde>] bdev_inode_switch_bdi+0x2e/0xa0
>> [  112.524011]  [<b01c8baf>] __blkdev_put+0xbf/0x160
>> [  112.524011]  [<b01c8be3>] __blkdev_put+0xf3/0x160
>> [  112.524011]  [<b01c8c92>] blkdev_put+0x42/0x120
>> [  112.524011]  [<b019d66f>] kill_block_super+0x3f/0x70
>> [  112.524011]  [<b019df1d>] deactivate_locked_super+0x3d/0x70
>> [  112.524011]  [<b019e890>] deactivate_super+0x50/0x70
>> [  112.524011]  [<b01b5a38>] mntput_no_expire+0x68/0xa0
>> [  112.524011]  [<b01b5a83>] mntput+0x13/0x30
>> [  112.524011]  [<b01a4525>] path_put+0x15/0x20
>> [  112.524011]  [<b01a574d>] terminate_walk+0x4d/0x60
>> [  112.524011]  [<b01a769f>] do_last+0x60f/0x6d0
>> [  112.524011]  [<b01a77f8>] path_openat+0x98/0x320
>> [  112.524011]  [<b0159317>] ? lock_release_non_nested+0x57/0x2e0
>> [  112.524011]  [<b01a7b60>] do_filp_open+0x30/0x80
>> [  112.524011]  [<b055f75d>] ? _raw_spin_unlock+0x1d/0x30
>> [  112.524011]  [<b01b404c>] ? alloc_fd+0xbc/0x100
>> [  112.524011]  [<b019ac61>] do_sys_open+0xf1/0x1c0
>> [  112.524011]  [<b019ad99>] sys_open+0x29/0x40
>> [  112.524011]  [<b055ff57>] sysenter_do_call+0x12/0x36
>
> This Oops is still happening in 3.1.0-rc5.
>
> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
Yang RuiRui
