Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0FQANq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:13:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55583 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476Ab0FQANp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:13:45 -0400
Date: Wed, 16 Jun 2010 17:13:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc3 - include/linux/fdtable.h:85 invoked
 rcu_dereference_check() 	without protection!
Message-ID: <20100617001343.GL2457@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTikBziddf8Z88WnMiuIk2AEeHxI6k6K9tiisSyLc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikBziddf8Z88WnMiuIk2AEeHxI6k6K9tiisSyLc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 02:36:03AM -0400, Miles Lane wrote:
> [ 2074.377176] [ INFO: suspicious rcu_dereference_check() usage. ]
> [ 2074.377180] ---------------------------------------------------
> [ 2074.377185] include/linux/fdtable.h:85 invoked
> rcu_dereference_check() without protection!
> [ 2074.377189]
> [ 2074.377190] other info that might help us debug this:
> [ 2074.377191]
> [ 2074.377195]
> [ 2074.377196] rcu_scheduler_active = 1, debug_locks = 1
> [ 2074.377200] no locks held by gvfsd/4402.
> [ 2074.377203]
> [ 2074.377204] stack backtrace:
> [ 2074.377209] Pid: 4402, comm: gvfsd Not tainted 2.6.35-rc3 #1
> [ 2074.377213] Call Trace:
> [ 2074.377226]  [<ffffffff8106f2c5>] lockdep_rcu_dereference+0x9d/0xa5
> [ 2074.377235]  [<ffffffff810e9104>] fcheck_files+0x5c/0xc9
> [ 2074.377242]  [<ffffffff810e91c9>] fget_light+0x35/0x96
> [ 2074.377250]  [<ffffffff810f77b0>] do_sys_poll+0x1ff/0x3e5
> [ 2074.377257]  [<ffffffff810f6eb2>] ? __pollwait+0x0/0xc7
> [ 2074.377264]  [<ffffffff810f6f79>] ? pollwake+0x0/0x4f
> [ 2074.377271]  [<ffffffff810f6f79>] ? pollwake+0x0/0x4f
> [ 2074.377277]  [<ffffffff810f6f79>] ? pollwake+0x0/0x4f
> [ 2074.377285]  [<ffffffff812d2f18>] ? __sock_recvmsg_nosec+0x65/0x6e
> [ 2074.377292]  [<ffffffff812d4401>] ? __sock_recvmsg+0x49/0x54
> [ 2074.377299]  [<ffffffff812d6842>] ? sock_aio_read+0xc2/0xd6
> [ 2074.377307]  [<ffffffff810e7faf>] ? do_sync_read+0xc6/0x103
> [ 2074.377316]  [<ffffffff8119ec0c>] ? security_file_permission+0x11/0x13
> [ 2074.377324]  [<ffffffff8100877a>] ? sysret_check+0x2e/0x69
> [ 2074.377331]  [<ffffffff810f7b2a>] sys_poll+0x50/0xbb
> [ 2074.377338]  [<ffffffff81008742>] system_call_fastpath+0x16/0x1b

Hmmm...  This was supposed to have been fixed by the following:

	http://lkml.org/lkml/2010/5/11/489

The rcu_my_thread_group_empty() function that it depends on is in
mainline, but this is not.  Checking the -vfs tree...  Not seeing it
there, either.

I will repost the patch.

Thank you for following up on this!!!

							Thanx, Paul
