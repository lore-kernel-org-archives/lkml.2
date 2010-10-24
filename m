Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab0JXNvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 09:51:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37942 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab0JXNvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 09:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DrOw9F8H0cldPKEB1bJnhjphZ2Ah7FX6kz2CltKCAUYsjN4Gb6axlu+/XlXW7dn7kO
         q5HuXMoNvRVIUEFpMdeNsDiINaVsmfzYhbZ3/iU+Y0ZOtRigO0vwpzcmOLvNWeYGOLJf
         nNPy6stbxfoA/3mRhg+qcDAzIZRXhaqjJW7/c=
MIME-Version: 1.0
Date: Sun, 24 Oct 2010 21:51:48 +0800
Message-ID: <AANLkTikmGE2Pz0=57i4CQZrnunFzQHpmFdha2nwivm=Q@mail.gmail.com>
Subject: linux-2.6.36 WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git pulled latest linux 2.6.36 (at
35da7a307c535f9c2929cae277f3df425c9f9b1e), and 2nd mount for loop
device resulted in the following error. Has this been reported or
shall I bisect?

# mount -o loop cd.iso /mnt
# umount /mnt

# repeat a second time
# mount -o loop cd.iso /mnt

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
Hardware name: 5413FGA
sysfs: cannot create duplicate filename '/devices/virtual/block/loop0/loop'
Modules linked in: [last unloaded: usb_storage]
Pid: 7000, comm: mount Tainted: G        W   2.6.36 #3
Call Trace:
 [<ffffffff81033b2c>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81033bdf>] ? warn_slowpath_fmt+0x45/0x4a
 [<ffffffff810ecf86>] ? sysfs_add_one+0x82/0x95
 [<ffffffff810ed81a>] ? create_dir+0x67/0xaa
 [<ffffffff810eec10>] ? internal_create_group+0x51/0x16f
 [<ffffffff8129de00>] ? lo_ioctl+0x27d/0x615
 [<ffffffff811bba75>] ? blkdev_ioctl+0x527/0x55a
 [<ffffffff810c93f1>] ? block_ioctl+0x32/0x36
 [<ffffffff810b1ee5>] ? do_vfs_ioctl+0x418/0x465
 [<ffffffff810b469e>] ? dput+0x23/0x156
 [<ffffffff810b1f6e>] ? sys_ioctl+0x3c/0x5c
 [<ffffffff81002082>] ? system_call_fastpath+0x16/0x1b
---[ end trace 8b619bd1dfdf9659 ]---

Thanks,
Jeff
