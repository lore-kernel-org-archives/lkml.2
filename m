Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab2CBKx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:53:26 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62140 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab2CBKxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:53:24 -0500
MIME-Version: 1.0
Date: Fri, 2 Mar 2012 18:53:23 +0800
Message-ID: <CAJxxZ0NNb6981fpLyiH97Q3Y6ucWm=XB5-MmMRnBCr-dmQrpyw@mail.gmail.com>
Subject: Fail to mount a ext2 partition /dev/mmcblk0p1 on SD card as root file
 system in kernel 3.2
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, initramfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel 3.2 panic when I mount a ext2 partition /dev/mmcblk0p1 on SD
card as root file system.

My boot parameter line is "root=/dev/mmcblk0p1 rw rootwait
earlyprintk=serial,uart0,57600 console=ttyBF0,57600".

After reading init/do_mounts.c a bit, I find VFS folders "/dev" and
"/root" don't exist when mount_root() tries to create block device
node "/dev/root" and mount this device at  path "/root". If I create
these folders by mkdir() before line create_dev() in function
mount_root(), kernel boots up on SD card properly.

Where should folders "/dev" and "/root" be created? Any hint?

Thanks

void __init mount_root(void)
{
.......
#ifdef CONFIG_BLOCK
        create_dev("/dev/root", ROOT_DEV);
        mount_block_root("/dev/root", root_mountflags);
#endif
}

static int __init do_mount_root(char *name, char *fs, int flags, void *data)
{
        int err = sys_mount(name, "/root", fs, flags, data);
        if (err)
                return err;
......
}

Sonic Zhang
