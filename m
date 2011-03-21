Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1CUCYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 22:24:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34397 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1CUCYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 22:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=v/SOxmhQtyiJPn/q0yzQRbWWu6RVmvIdUyJIzVwneXGCxUdxtsg+mvP+9e98sACwXy
         vOFmwNhviW5VnRThnJeLKhcqTKwIthYO1fFN+VJPP8+LXSBltwuyy9mn5/nKwUQ7BmqE
         Jcju1mcBS5hFDPhDadvtCBY/tf2DlMOdMJ1KE=
MIME-Version: 1.0
Date: Mon, 21 Mar 2011 05:24:08 +0300
Message-ID: <AANLkTi=5pSyJVqOQUJ8wXbNpXogWcRdavswx9my0OzEX@mail.gmail.com>
Subject: 2.6.39-rc0: umount tmpfs hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

kernel is 2.6.38-06507-ga952baa

/etc/init.d/swap stop
runs
umount -a -t tmpfs

which is hangs at

$cat /proc/4453/stack
[<c1066332>] rcu_barrier_sched+0x32/0x40
[<c109fdca>] deactivate_locked_super+0x3a/0x60
[<c10a05f6>] deactivate_super+0x46/0x60
[<c10b6f2a>] mntput_no_expire+0x5a/0x90
[<c10b7a6d>] sys_umount+0x5d/0x300
[<c10b7d29>] sys_oldumount+0x19/0x20
[<c136eb50>] sysenter_do_call+0x12/0x36
[<ffffffff>] 0xffffffff

INFO: task umount:4453 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount          D 00000000  5400  4453   4446 0x00000000
 d87cfe24 00000046 00000000 00000000 00000424 00000000 00000424 c19f0418
 d87cfe24 d87c3d20 286b9967 0000007f d87c3d20 0000007f c17d3970 edb07b89
 000000ec 00000092 d87cfe2c c1047882 28a482c8 0000007f 28a45c7b 0000007f
Call Trace:
 [<c1047882>] ? sched_clock_local.clone.1+0x42/0x1a0
 [<c1367585>] schedule_timeout+0x125/0x1b0
 [<c1047a9d>] ? sched_clock_cpu+0x7d/0xf0
 [<c10518eb>] ? trace_hardirqs_off+0xb/0x10
 [<c1369b02>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c105431b>] ? trace_hardirqs_on+0xb/0x10
 [<c13672d5>] wait_for_common+0xd5/0x130
 [<c1021a80>] ? default_wake_function+0x0/0x10
 [<c13673d2>] wait_for_completion+0x12/0x20
 [<c1066332>] rcu_barrier_sched+0x32/0x40
 [<c103f5b0>] ? wakeme_after_rcu+0x0/0x10
 [<c1367231>] ? wait_for_common+0x31/0x130
 [<c109fdca>] deactivate_locked_super+0x3a/0x60
 [<c10a05f6>] deactivate_super+0x46/0x60
 [<c10b6f2a>] mntput_no_expire+0x5a/0x90
 [<c10b7a6d>] sys_umount+0x5d/0x300
 [<c10b7d29>] sys_oldumount+0x19/0x20
 [<c136eb50>] sysenter_do_call+0x12/0x36
no locks held by umount/4453.
