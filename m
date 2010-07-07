Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0GGAZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:25:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50819 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab0GGAZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xVpCOVfoj+XkUQ9+CjyvGWQp1hmNEc/lv+c8V34z/6p50uAHGBp0tsi4334P3ebQ+c
         17iaB3m4GnuLc884MheEEwoN+pP8W4jYj7PeP3d8TnQNIPiKTcKKrGF3Q8jD7ipQ+NXi
         FOfTDiYios5BiNooI7XG6gw4+7AYo/FcydY0E=
MIME-Version: 1.0
Date: Tue, 6 Jul 2010 20:25:56 -0400
Message-ID: <AANLkTinDWl1qJzK-H9Qw3jjKs9zdUYE1Hh3hTaDw8asd@mail.gmail.com>
Subject: 2.6.35-rc4 - include/linux/fdtable.h:85 invoked rcu_dereference_check() 
	without protection!
From: Miles Lane <miles.lane@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [ INFO: suspicious rcu_dereference_check() usage. ]
 ---------------------------------------------------
 include/linux/fdtable.h:85 invoked rcu_dereference_check() without protection!

 other info that might help us debug this:

 rcu_scheduler_active = 1, debug_locks = 1
 no locks held by compiz/4286.

 stack backtrace:
 Pid: 4286, comm: compiz Not tainted 2.6.35-rc4 #6
 Call Trace:
  [<ffffffff8106714e>] lockdep_rcu_dereference+0x9d/0xa6
  [<ffffffff810d3bdd>] fcheck_files+0x5c/0xca
  [<ffffffff810d3ca3>] fget_light+0x35/0x96
  [<ffffffff810e1b02>] do_sys_poll+0x1ff/0x3e5
  [<ffffffff810e1316>] ? __pollwait+0x0/0xc7
  [<ffffffff810e13dd>] ? pollwake+0x0/0x4f
  [<ffffffff8125b785>] ? __sock_sendmsg+0x66/0x72
  [<ffffffff8125da9e>] ? sock_aio_write+0x0/0xf6
  [<ffffffff8125db7f>] ? sock_aio_write+0xe1/0xf6
  [<ffffffff810d295f>] ? do_sync_readv_writev+0xbc/0xfb
  [<ffffffff810d284f>] ? fsnotify_modify+0x67/0x6f
  [<ffffffff810d35eb>] ? do_readv_writev+0x109/0x122
  [<ffffffff81009cba>] ? sysret_check+0x2e/0x69
  [<ffffffff810e1e7c>] sys_poll+0x50/0xba
  [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b

===============================================================================

 [ INFO: suspicious rcu_dereference_check() usage. ]
 ---------------------------------------------------
 include/linux/fdtable.h:88 invoked rcu_dereference_check() without protection!

 other info that might help us debug this:

 rcu_scheduler_active = 1, debug_locks = 1
 no locks held by gnome-panel/4293.

 stack backtrace:
 Pid: 4293, comm: gnome-panel Not tainted 2.6.35-rc4 #6
 Call Trace:
  [<ffffffff8106714e>] lockdep_rcu_dereference+0x9d/0xa6
  [<ffffffff810d3c32>] fcheck_files+0xb1/0xca
  [<ffffffff810ab263>] ? might_fault+0x63/0xb3
  [<ffffffff810d3ca3>] fget_light+0x35/0x96
  [<ffffffff810e1b02>] do_sys_poll+0x1ff/0x3e5
  [<ffffffff810e1316>] ? __pollwait+0x0/0xc7
  [<ffffffff8125a2ae>] ? __sock_recvmsg_nosec+0x65/0x6e
  [<ffffffff8125b7da>] ? __sock_recvmsg+0x49/0x54
  [<ffffffff8125da8a>] ? sock_aio_read+0xe8/0xfc
  [<ffffffff810d2b67>] ? do_sync_read+0xc6/0x103
  [<ffffffff81009cba>] ? sysret_check+0x2e/0x69
  [<ffffffff810e1e7c>] sys_poll+0x50/0xba
  [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b
