Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2CVID1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 04:03:27 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39637 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab2CVIDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 04:03:19 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Subject: 3.3 and hidepid feature problem - options not always applied at mount
Date: Thu, 22 Mar 2012 09:03:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-final-dirty; KDE/4.8.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203220903.15360.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm trying to use hidepid feature in 3.3 kernel but I'm getting weird
things like options not being applied _sometimes_ at mount.

[@ ~]# cat /proc/mounts
sh: cat: /proc/mounts: No such file or directory
[@ ~]# strace -e mount -f -F -s 200 mount none /proc -t proc -o hidepid=2,gid=17                            
mount("none", "/proc", "proc", MS_MGC_VAL, "hidepid=2,gid=17") = 0
[@ ~]# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/sda3 / xfs rw,relatime,attr2,noquota 0 0
run /run tmpfs rw,relatime 0 0
none /proc proc rw,relatime 0 0

No hidepid, no gid - huh?

[@ ~]# mount /proc -o remount,hidepid=2,gid=17
[@ ~]# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/sda3 / xfs rw,relatime,attr2,noquota 0 0
run /run tmpfs rw,relatime 0 0
none /proc proc rw,relatime,gid=17,hidepid=2 0 0

remount and hidepid/gid is there

[@ ~]# umount /proc
[@ ~]# strace -e mount -f -F -s 200 mount none /proc -t proc -o hidepid=2,gid=17                            
mount("none", "/proc", "proc", MS_MGC_VAL, "hidepid=2,gid=17") = 0
[@ ~]# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/sda3 / xfs rw,relatime,attr2,noquota 0 0
run /run tmpfs rw,relatime 0 0
none /proc proc rw,relatime,gid=17,hidepid=2 0 0

and now I'm lost - every new umount & mount gets hidepid/gid right.

Any ideas why initial mount fails to get hidepid/gid options applied?
The syscall seems correct.
-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
