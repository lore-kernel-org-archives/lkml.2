Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1K3F4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:56:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54281 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1K3F4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:56:48 -0500
Message-ID: <1322632602.23721.0.camel@edumazet-laptop>
Subject: Re: 3.2.0-rc3+ (Linus git -
 883381d9f1c5a6329bbb796e23ae52c939940310) - INFO: suspicious RCU usage
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 30 Nov 2011 06:56:42 +0100
In-Reply-To: <CAHFgRy-hAMF344eChZ9tLnFB7qUS_v3m0LvtBKWjbFmBeeASsA@mail.gmail.com>
References: <CAHFgRy-hAMF344eChZ9tLnFB7qUS_v3m0LvtBKWjbFmBeeASsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 30 novembre 2011 à 00:09 -0500, Miles Lane a écrit :
> I got the following message while running "find /proc | xargs head" to
> see whether accessing any proc files would cause trouble.
> 
> [  442.112632] [ INFO: suspicious RCU usage. ]
> [  442.112634] -------------------------------
> [  442.112637] include/net/dst.h:91 suspicious rcu_dereference_check() usage!
> [  442.112640]
> [  442.112641] other info that might help us debug this:
> [  442.112643]
> [  442.112645]
> [  442.112646] rcu_scheduler_active = 1, debug_locks = 1
> [  442.112650] 2 locks held by head/4903:
> [  442.112652]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff810e160a>]
> seq_read+0x38/0x35d
> [  442.112665]  #1:  (rcu_read_lock_bh){.+....}, at:
> [<ffffffff812f831e>] rcu_read_lock_bh+0x0/0x35
> [  442.112676]
> [  442.112677] stack backtrace:
> [  442.112681] Pid: 4903, comm: head Not tainted 3.2.0-rc3+ #42
> [  442.112684] Call Trace:
> [  442.112691]  [<ffffffff8105cdd2>] lockdep_rcu_suspicious+0xaf/0xb8
> [  442.112697]  [<ffffffff812f8e02>] dst_get_neighbour.isra.31+0x44/0x4c
> [  442.112702]  [<ffffffff812f8e86>] rt_cache_seq_show+0x46/0x194
> [  442.112708]  [<ffffffff812f8351>] ? rcu_read_lock_bh+0x33/0x35
> [  442.112714]  [<ffffffff8104b57a>] ? rcu_read_lock_bh_held+0x9/0x37
> [  442.112719]  [<ffffffff812f85c2>] ? rt_cache_get_first+0x72/0x116
> [  442.112725]  [<ffffffff810e184d>] seq_read+0x27b/0x35d
> [  442.112730]  [<ffffffff810e15d2>] ? seq_lseek+0xda/0xda
> [  442.112736]  [<ffffffff8110e3e1>] proc_reg_read+0x8e/0xad
> [  442.112741]  [<ffffffff810c6e23>] vfs_read+0xa0/0xc7
> [  442.112746]  [<ffffffff810c80bf>] ? fget_light+0x35/0x98
> [  442.112750]  [<ffffffff810c6e8f>] sys_read+0x45/0x69
> [  442.112756]  [<ffffffff8136a27b>] system_call_fastpath+0x16/0x1b


Thanks for the report Miles, I'll provide a patch in a couple of minutes
after testing it



