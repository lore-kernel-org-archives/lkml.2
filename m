Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1CLBLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:11:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab1CLBLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:11:20 -0500
Date: Fri, 11 Mar 2011 17:10:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Thelen <gthelen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 0/9] memcg: per cgroup dirty page accounting
Message-Id: <20110311171006.ec0d9c37.akpm@linux-foundation.org>
In-Reply-To: <1299869011-26152-1-git-send-email-gthelen@google.com>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 10:43:22 -0800
Greg Thelen <gthelen@google.com> wrote:

>
> ...
> 
> This patch set provides the ability for each cgroup to have independent dirty
> page limits.

Here, it would be helpful to describe the current kernel behaviour. 
And to explain what is wrong with it and why the patch set improves
things!

> 
> ...
>
> Known shortcomings (see the patch 1/9 update to Documentation/cgroups/memory.txt
> for more details):
> - When a cgroup dirty limit is exceeded, then bdi writeback is employed to
>   writeback dirty inodes.  Bdi writeback considers inodes from any cgroup, not
>   just inodes contributing dirty pages to the cgroup exceeding its limit.  

This is a pretty large shortcoming, I suspect.  Will it be addressed?

There's a risk that a poorly (or maliciously) configured memcg could
have a pretty large affect upon overall system behaviour.  Would
elevated premissions be needed to do this?

We could just crawl the memcg's page LRU and bring things under control
that way, couldn't we?  That would fix it.  What were the reasons for
not doing this?

> - A cgroup may exceed its dirty limit if the memory is dirtied by a process in a
>   different memcg.

Please describe this scenario in (a lot) more detail?


