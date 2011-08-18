Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1HRArh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 20:47:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60699 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1HRArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 20:47:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Aug 2011 09:39:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v9 03/13] memcg: add dirty page accounting
 infrastructure
Message-Id: <20110818093959.cdf501ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1313597705-6093-4-git-send-email-gthelen@google.com>
References: <1313597705-6093-1-git-send-email-gthelen@google.com>
	<1313597705-6093-4-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 09:14:55 -0700
Greg Thelen <gthelen@google.com> wrote:

> Add memcg routines to count dirty, writeback, and unstable_NFS pages.
> These routines are not yet used by the kernel to count such pages.  A
> later change adds kernel calls to these new routines.
> 
> As inode pages are marked dirty, if the dirtied page's cgroup differs
> from the inode's cgroup, then mark the inode shared across several
> cgroup.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A nitpick..



> +static inline
> +void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
> +				       struct mem_cgroup *to,
> +				       enum mem_cgroup_stat_index idx)
> +{
> +	preempt_disable();
> +	__this_cpu_dec(from->stat->count[idx]);
> +	__this_cpu_inc(to->stat->count[idx]);
> +	preempt_enable();
> +}
> +

this_cpu_dec()
this_cpu_inc()

without preempt_disable/enable will work. CPU change between dec/inc will
not be problem.

Thanks,
-Kame



