Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2FWJ1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 05:27:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52367 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab2FWJ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 05:27:13 -0400
Date: Sat, 23 Jun 2012 11:26:54 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] memcg: replace unsigned long by u64 to avoid overflow
Message-ID: <20120623092654.GL27816@cmpxchg.org>
References: <1340432134-5178-1-git-send-email-liwp.linux@gmail.com>
 <20120623081514.GJ27816@cmpxchg.org>
 <20120623090339.GA6184@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623090339.GA6184@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 05:03:39PM +0800, Wanpeng Li wrote:
> On Sat, Jun 23, 2012 at 10:15:14AM +0200, Johannes Weiner wrote:
> >On Sat, Jun 23, 2012 at 02:15:34PM +0800, Wanpeng Li wrote:
> >> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> >> 
> >> Since the return value variable in mem_cgroup_zone_nr_lru_pages and
> >> mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
> >> value of funtions by u64 to avoid overflow.
> >
> >I wonder what 16 TB of memory must think running on a 32-bit kernel...
> >"What is this, an address space for ants?"
> 
> Hi Johannes,
> 
> You mean change all u64 in memcg to unsigned long? or something I
> miss....

Not _all_ of them, we have some that count bytes.  But those counting
pages should probably be ulong, yes.

I think Kame added the ones that you wanted to adjust the surroundings
for in particular, so let's ask him.  Kame?
