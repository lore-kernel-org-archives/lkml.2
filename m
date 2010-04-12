Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0DLSrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:47:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0DLSrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:47:17 -0400
Subject: Re: INFO: suspicious rcu_dereference_check() usage - 
 include/linux/cgroup.h:492 invoked rcu_dereference_check() without 
 protection!
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Paris <eparis@parisplace.org>
Cc: paulmck@linux.vnet.ibm.com, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
	 <20100311032843.GE6767@linux.vnet.ibm.com>
	 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 12 Apr 2010 20:47:12 +0200
Message-ID: <1271098032.4807.137.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 14:44 -0400, Eric Paris wrote:
> On Wed, Mar 10, 2010 at 11:28 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:

> I know you indicated this was fixed in mainline and I see that set of
> commits objects, but I'm seeing the below spew from linux-next today.
> 
> tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> tag: next-20100412
> commit: bbeecf185fe464ccd7ee97ce6d3646ad686995b4
> 
> [    0.035602] ===================================================
> [    0.036003] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    0.037006] ---------------------------------------------------
> [    0.038004] include/linux/cgroup.h:533 invoked
> rcu_dereference_check() without protection!
> [    0.039003]
> [    0.039004] other info that might help us debug this:
> [    0.039004]
> [    0.040003]
> [    0.040004] rcu_scheduler_active = 1, debug_locks = 0
> [    0.041004] no locks held by swapper/0.
> [    0.042003]
> [    0.042004] stack backtrace:
> [    0.043005] Pid: 0, comm: swapper Not tainted 2.6.34-rc3-next-20100412+ #65
> [    0.044003] Call Trace:
> [    0.045015]  [<ffffffff8108584f>] lockdep_rcu_dereference+0xaf/0xc0
> [    0.046010]  [<ffffffff81044812>] set_task_cpu+0x2d2/0x370

Oh, right, I still have to sort that out.

I need to figure out how all that scheduler and cgroup muck interact to
fix this.
