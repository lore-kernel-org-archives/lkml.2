Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1A3CaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 21:30:09 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45377 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1A3CaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 21:30:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=SOts7ODo3y4bj/CFvB8QkASTsm5fEiINprVeOuUI3U5hNkdCZ4ufYL9LlrEsPOy2tX
         WOuT7acA4lSFETmDyAgD78JN0m1lBRSKo92S/vEwXDtz1hGWKNgVIXcVErT1qapVxHE8
         ZJOgoCu60Ns6cYKwtCydTdQCYxAXTrDsiXqRw=
MIME-Version: 1.0
Date: Sat, 29 Jan 2011 18:30:06 -0800
Message-ID: <AANLkTi=FzQPkt1pogJ7BdEtF_nUgTZU5_u3RBX1v0_R2@mail.gmail.com>
Subject: segmentation fault running under kgdb
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I have been trying to setup kgdb on 64 bit ubuntu 10.
The target boots up ok if it is not run under kgdb, even if there are
oops system boots fine.
Under kgdb I am not able to get the OS up fully.


Here is the stack trace:
(gdb) bt
#0  kref_put (kref=0xffffffffffffffc9, release=0xffffffff8127b560
<aa_free_profile_kref>) at lib/kref.c:67
#1  0xffffffff8127b069 in aa_put_profile (udata=0xffff8801b7600000,
size=<value optimized out>, add_only=<value optimized out>) at
security/apparmor/include/policy.h:295
#2  aa_interface_replace_profiles (udata=0xffff8801b7600000,
size=<value optimized out>, add_only=<value optimized out>) at
security/apparmor/policy.c:999
#3  0xffffffff81277569 in aa_profile_replace (f=<value optimized out>,
buf=<value optimized out>, size=43291, pos=<value optimized out>) at
security/apparmor/apparmorfs.c:157
#4  0xffffffff8113e5e8 in vfs_write (file=0xffff8801b650e300,
buf=0x13dfd90 "\004\b", count=<value optimized out>,
pos=0xffff8801b9345f48) at fs/read_write.c:347
#5  0xffffffff8113ee81 in sys_write (fd=<value optimized out>,
buf=0x13dfd90 "\004\b", count=43291) at fs/read_write.c:399
#6  0xffffffff810120f2 in ?? () at arch/x86/kernel/entry_64.S:487
#7  0x0000000000000246 in ?? ()
#8  0x00007fff38fea040 in ?? ()
#9  0x7070612f79746972 in ?? ()
#10 0x00000000013de0a0 in ?? ()
#11 0x0000000000000001 in ?? ()
#12 0x000000000000a91b in ?? ()
#13 0x00000000013dfd90 in ?? ()
#14 0x0000000000000004 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)
(gdb)

Snippet from dmesg output:

Linux version 2.6.32.27+drm33.12-kgdb (root@rdk3) (gcc version 4.4.3
(Ubuntu 4.4."...
Linux rdk4 2.6.32.27 #32-Ubuntu SMP  x86_64 GNU/Linux

  214.242425] scsi5 :  on PCI bus 07 device 03 irq 41
[  214.968732] BUG: unable to handle kernel paging request at ffffffffffffffc9
[  215.026999] IP: [<ffffffff812ae655>] kref_put+0x25/0x70
[  215.066892] PGD 1003067 PUD 1004067 PMD 0
[  215.146676] Oops: 0002 [#1] SMP
[  215.206537] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/event0/uevent
[New Thread 520]

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 520]
kref_put (kref=0xffffffffffffffc9, release=0xffffffff8127b560
<aa_free_profile_kref>) at lib/kref.c:67
/root/linux-2.6.32/lib/kref.c:67:1709:beg:0xffffffff812ae655
(gdb)
