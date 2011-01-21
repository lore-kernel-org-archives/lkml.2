Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1AUNXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:23:51 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:61581 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1AUNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:23:50 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: Tejun Heo <tj@kernel.org>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Q. block: check bdev_read_only() from blkdev_get()
Date: Fri, 21 Jan 2011 22:19:39 +0900
Message-ID: <23846.1295615979@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By the commit 75f1dc0
	2010-11-13 block: check bdev_read_only() from blkdev_get()
bdev_read_only() call is added into blkdev_get().

This check makes the loopback block device unable to be mounted as
writable once it is set to readonly, even if the corresponding is
detached and the device becomes free.
We may need to re-initialize the readonly/writable status flag somewhere?

# simple tests with loopback

# mount as writable, succeed
+ sudo mount -o loop ./ext2.img /mnt
+ sudo umount /mnt

# mount as readonly, succeed
+ sudo mount -o ro,loop ./ext2.img /mnt
+ sudo umount /mnt

# mount as writable again, fail
+ sudo mount -o loop ./ext2.img /mnt
/dev/loop0: Permission denied

Now /dev/loop0 is fixed as readonly.


J. R. Okajima
