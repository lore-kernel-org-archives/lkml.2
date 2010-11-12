Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab0KLRN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:13:28 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35494 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab0KLRN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:user-agent:date:message-id:mime-version
         :content-type;
        b=ibYPeQbU98/hl2BO5FSJzxP+nN2ewVGbJYoPIlafIi79BDelwPS0XigcwGbq5X87/+
         21bM9YirkZ7tODWEQIJa2qQ+YGzrQYhxTc+25axciLUESnGmcwg9f4vH12m99Khv0OYs
         sQUBSmlybJvFsckiusAvYUN0L3+9yziln8mV4=
From: Ben Gamari <bgamari@gmail.com>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Mounting blkio cgroup hierarchy
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Fri, 12 Nov 2010 12:13:24 -0500
Message-ID: <87fwv6sbwr.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to configure cgroups and have encountered some very
strange behavior. In particular, when I follow the instructions in
Documentation/cgroups/blkio-controller.txt I quickly reach an error,

$ cd /mnt
$ sudo mkdir -p cgroups/blkio
$ # Confirm it's not already mounted:
$ cat /proc/mounts
rootfs / rootfs rw 0 0
none /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
none /proc proc rw,nosuid,nodev,noexec,relatime 0 0
none /dev devtmpfs rw,relatime,size=1993264k,nr_inodes=498316,mode=755 0 0
none /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
/dev/disk/by-uuid/7d908a9f-fe46-4a82-bb2b-3fc108c96280 / ext4 rw,relatime,errors=remount-ro,barrier=1,data=ordered 0 0
none /sys/kernel/debug debugfs rw,relatime 0 0
none /sys/kernel/security securityfs rw,relatime 0 0
none /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
none /var/run tmpfs rw,nosuid,relatime,mode=755 0 0
none /var/lock tmpfs rw,nosuid,nodev,noexec,relatime 0 0
/dev/sda1 /boot ext4 rw,relatime,barrier=1,data=ordered 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,nosuid,nodev,noexec,relatime 0 0
gvfs-fuse-daemon /home/ben/.gvfs fuse.gvfs-fuse-daemon rw,nosuid,nodev,relatime,user_id=1000,group_id=1000 0 0
$ sudo mount -t cgroup -o blkio none /mnt/cgroups/blkio
mount: special device none does not exist

I've done quite a bit of Googling and yet it's very difficult to find
good information on configuring cgroups. I would use the libcg
toolset[1] but every attempt to configure it has ended in frustratingly
vague error messages.

Any ideas?

Cheers,

- Ben
