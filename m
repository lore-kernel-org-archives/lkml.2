Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1AMTdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:33:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538Ab1AMTdQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <20110113192152.GA18217@agk-dp.fab.redhat.com>
References: <4D2F03A7.2030809@fusionio.com> <20110113192152.GA18217@agk-dp.fab.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 11:26:09 -0800
Message-ID: <AANLkTin8icx0cir8czy9snZ0wg=QovJ4HSZru4jYUoea@mail.gmail.com>
Subject: Re: [GIT PULL] core block bits for 2.6.38
To: Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 11:21 AM, Alasdair G Kergon <agk@redhat.com> wrote:
>
> This one was found to be causing problems in linux-next yesterday:
>  http://permalink.gmane.org/gmane.linux.file-systems/50132
>
> Perhaps you could drop it for now until a solution's found?

Sadly I already merged.

And yes, I get the warning too. Tejun?

                          Linus
---
[    5.177189] dracut: Reading all physical volumes. This may take a while...
[    5.178962] dracut: Found volume group "VolGroup" using metadata type lvm2
[    5.206183] dracut: The link /dev/VolGroup/lv_root should had been
created by udev but it was not found. Falling back to direct link
creation.
[    5.217826] ------------[ cut here ]------------
[    5.219670] WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x4f/0xfb()
[    5.221542] Hardware name: System Product Name
[    5.223402] Modules linked in: [last unloaded: scsi_wait_scan]
[    5.225278] Pid: 1771, comm: lvm Not tainted 2.6.37-06858-g581548d-dirty #45
[    5.227150] Call Trace:
[    5.229021]  [<ffffffff81039df8>] ? warn_slowpath_common+0x80/0x98
[    5.230872]  [<ffffffff81039e25>] ? warn_slowpath_null+0x15/0x17
[    5.232776]  [<ffffffff810ee8a7>] ? bd_link_disk_holder+0x4f/0xfb
[    5.234647]  [<ffffffff810efa67>] ? blkdev_get_by_dev+0x2c/0x48
[    5.236523]  [<ffffffff813e3ee2>] ? open_dev+0x54/0x7b
[    5.238386]  [<ffffffff813e42be>] ? dm_get_device+0x11a/0x1b6
[    5.240261]  [<ffffffff813e55b6>] ? linear_ctr+0x9e/0xda
[    5.242113]  [<ffffffff813e48ba>] ? dm_table_add_target+0x149/0x1d4
[    5.243964]  [<ffffffff813e69ef>] ? table_load+0xf0/0x27b
[    5.245826]  [<ffffffff813e68ff>] ? table_load+0x0/0x27b
[    5.247677]  [<ffffffff813e775f>] ? ctl_ioctl+0x1c8/0x220
[    5.249512]  [<ffffffff813e77c5>] ? dm_ctl_ioctl+0xe/0x12
[    5.251338]  [<ffffffff810d3f6e>] ? do_vfs_ioctl+0x4aa/0x4eb
[    5.253125]  [<ffffffff810c5ef5>] ? fget_light+0x13a/0x31a
[    5.254952]  [<ffffffff8100202c>] ? sysret_check+0x27/0x62
[    5.256750]  [<ffffffff810d4000>] ? sys_ioctl+0x51/0x75
[    5.258548]  [<ffffffff81001ffb>] ? system_call_fastpath+0x16/0x1b
[    5.260311] ---[ end trace c76cd8f047b9c147 ]---
[    5.269327] dracut: The link /dev/VolGroup/lv_swap should had been
created by udev but it was not found. Falling back to direct link
creation.
[    5.271528] dracut: 2 logical volume(s) in volume group "VolGroup" now active
