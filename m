Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0JZFGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 01:06:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41945 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0JZFGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 01:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vZRlBzSZhvFuRKR0W/EJ9VCgfdclhW6iju4DY2XRGsBRMz2HOLozWchDF7bj/1DqXh
         5NGbZJAgyb3fepTBSy0d+a5lh4oJQOfALtjt5FWMMEQset8pOczMgl6d/coOqOzbqd5h
         EhmV6n3pU3Nwfz3umH5OhtqysE2q5ZRDga4A4=
MIME-Version: 1.0
Date: Tue, 26 Oct 2010 10:36:19 +0530
Message-ID: <AANLkTim=jD-C4DwDS2=KuQnhPOyP+Cnd-hUTdaZ7Opth@mail.gmail.com>
Subject: ath9k crashing the kernel
From: Jaswinder Singh <jaswinderlinux@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

ath9k is crashing the kernel :

[   21.276554] BUG: spinlock bad magic on CPU#1, NetworkManager/1056
[   21.277015]  lock: f5be80a8, .magic: 00000000, .owner: <none>/-1,
.owner_cpu: 0
[   21.277015] Pid: 1056, comm: NetworkManager Not tainted 2.6.36-netbook+ #20
[   21.277015] Call Trace:
[   21.277015]  [<c14767a7>] ? printk+0xf/0x11
[   21.277015]  [<c117b823>] spin_bug+0x7c/0x87
[   21.301365]  [<c117b8bd>] do_raw_spin_lock+0x1e/0x125
[   21.301365]  [<c1478d0a>] ? _raw_spin_unlock_bh+0x1a/0x1c
[   21.301365]  [<c1478dc3>] _raw_spin_lock_irqsave+0x17/0x1c
[   21.318857]  [<c1288a74>] ath9k_config+0x255/0x38b
[   21.318857]  [<c1447bdb>] ieee80211_hw_config+0x10a/0x114
[   21.328034]  [<c1453545>] ieee80211_do_open+0x3de/0x4cf
[   21.328034]  [<c1452206>] ? ieee80211_check_concurrent_iface+0x21/0x13a
[   21.328034]  [<c104c470>] ? raw_notifier_call_chain+0xc/0xe
[   21.328034]  [<c1453691>] ieee80211_open+0x5b/0x5e
[   21.328034]  [<c13947cf>] __dev_open+0x80/0xa9
[   21.328034]  [<c13920bb>] __dev_change_flags+0xa1/0x116
[   21.328034]  [<c1394723>] dev_change_flags+0x13/0x3f
[   21.328034]  [<c139d568>] do_setlink+0x226/0x507
[   21.328034]  [<c139d917>] rtnl_setlink+0xce/0xd4
[   21.328034]  [<c11786d2>] ? copy_to_user+0x3a/0x118
[   21.328034]  [<c139d849>] ? rtnl_setlink+0x0/0xd4
[   21.328034]  [<c139df4d>] rtnetlink_rcv_msg+0x17e/0x194
[   21.328034]  [<c139ddcf>] ? rtnetlink_rcv_msg+0x0/0x194
[   21.328034]  [<c13a59c4>] netlink_rcv_skb+0x30/0x76
[   21.328034]  [<c139ddc8>] rtnetlink_rcv+0x1b/0x22
[   21.328034]  [<c13a5772>] netlink_unicast+0x1aa/0x20b
[   21.328034]  [<c13a5eac>] netlink_sendmsg+0x22c/0x27a
[   21.328034]  [<c13862b8>] sock_sendmsg+0xa5/0xbb
[   21.328034]  [<c13862b8>] ? sock_sendmsg+0xa5/0xbb
[   21.328034]  [<c138e05b>] ? verify_iovec+0x3e/0x6b
[   21.328034]  [<c1386ab2>] sys_sendmsg+0x149/0x196
[   21.328034]  [<c10826f5>] ? unlock_page+0x40/0x43
[   21.328034]  [<c10952d5>] ? __do_fault+0x367/0x393
[   21.328034]  [<c1096b8e>] ? handle_mm_fault+0x3bd/0x77a
[   21.328034]  [<c10b6fb3>] ? destroy_inode+0x1f/0x30
[   21.328034]  [<c138694e>] ? sys_recvmsg+0x2b/0x46
[   21.328034]  [<c1387c00>] sys_socketcall+0x146/0x18b
[   21.328034]  [<c1002850>] sysenter_do_call+0x12/0x26
[   21.344846] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   21.487994] atl1c 0000:03:00.0: irq 42 for MSI/MSI-X
[   21.543870] ADDRCONF(NETDEV_UP): eth0: link is not ready


Linux 2.6.36 f6f94e2ab1 is good
and
229aebb873e2972 is bad

I am trying to bisect it but I am getting compilation error :

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `ath_do_set_opmode':
/home/jaswinder/jaswinder-git/linux-2.6/drivers/net/wireless/ath/ath5k/base.c:567:
undefined reference to `ath_opmode_to_string'
/home/jaswinder/jaswinder-git/linux-2.6/drivers/net/wireless/ath/ath5k/base.c:568:
undefined reference to `ath_opmode_to_string'
make: *** [.tmp_vmlinux1] Error 1
[jaswinder@ linux-2.6]$

Thanks,
--
Jaswinder Singh.
