Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0FHH0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:26:34 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37827 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0FHH0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:26:32 -0400
Subject: Re: 2.6.35-rc2-git1 - net/mac80211/sta_info.c:125 invoked
 rcu_dereference_check() without protection!
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: Miles Lane <miles.lane@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       Eric Paris <eparis@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20100607235941.GD2387@linux.vnet.ibm.com>
References: <AANLkTintKf_9C1sBsUac6Prvb1nWn7nWszatJ8yUb-VM@mail.gmail.com>
	 <20100607235941.GD2387@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 09:26:09 +0200
Message-ID: <1275981969.3706.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 16:59 -0700, Paul E. McKenney wrote:
> On Mon, Jun 07, 2010 at 02:25:44PM -0400, Miles Lane wrote:
> > [   43.478812] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [   43.478815] ---------------------------------------------------
> > [   43.478820] net/mac80211/sta_info.c:125 invoked
> > rcu_dereference_check() without protection!
> > [   43.478824]
> > [   43.478824] other info that might help us debug this:
> > [   43.478826]
> > [   43.478829]
> > [   43.478830] rcu_scheduler_active = 1, debug_locks = 1
> > [   43.478834] no locks held by NetworkManager/4017.
> 
> Hmmm...  Johannes's update has been merged, and it requires that callers
> either be in an RCU read-side critical section or hold either the
> ->sta_lock or the ->sta_mtx, and this thread does none of this.
> 
> Johannes, any thoughts?
> 
> 							Thanx, Paul
> 
> > [   43.478837] stack backtrace:
> > [   43.478842] Pid: 4017, comm: NetworkManager Not tainted 2.6.35-rc2-git1 #8
> > [   43.478846] Call Trace:
> > [   43.478849]  <IRQ>  [<ffffffff81064e9c>] lockdep_rcu_dereference+0x9d/0xa5
> > [   43.478876]  [<ffffffffa010cb3c>] sta_info_get_bss+0x71/0x12d [mac80211]
> > [   43.478889]  [<ffffffffa010cc0d>] ieee80211_find_sta+0x15/0x2f [mac80211]
> > [   43.478902]  [<ffffffffa019ae16>] iwlagn_tx_queue_reclaim+0xe7/0x1bb [iwlagn]

iwlwifi wasn't using rcu protection here -- already sent a patch fixing
it. My mistake, I  think. Thanks for checking :)

johannes

