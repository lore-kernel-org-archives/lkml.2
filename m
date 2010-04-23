Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0DWGIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 02:08:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57291 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab0DWGIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 02:08:49 -0400
Message-ID: <4BD139D8.80309@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 14:10:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg rcu lock fix v3
References: <4BD10D59.9090504@cn.fujitsu.com>	<20100423121424.ae47efcb.kamezawa.hiroyu@jp.fujitsu.com>	<4BD118E2.7080307@cn.fujitsu.com>	<4BD11A24.2070500@cn.fujitsu.com>	<20100423125814.01e95bce.kamezawa.hiroyu@jp.fujitsu.com> <20100423130349.f320d0be.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100423130349.f320d0be.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> css_id() should be called under rcu_read_lock().
> Following is a report from Li Zefan.
> ==
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/cgroup.c:4438 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by kswapd0/31:
>  #0:  (swap_lock){+.+.-.}, at: [<c05058bb>] swap_info_get+0x4b/0xd0
> 
> stack backtrace:
...
> 
> And css_is_ancestor() should be called under rcu_read_lock().
> 
> 
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

With this patch applied, I did some more test, and no warning was triggered.

Tested-by: Li Zefan <lizf@cn.fujitsu.com>

