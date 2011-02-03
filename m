Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1BCPCy (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 3 Feb 2011 10:02:54 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52805 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1BCPCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:02:52 -0500
Date: Thu, 3 Feb 2011 20:32:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: memcg: save 20% of per-page memcg memory overhead
Message-ID: <20110203150247.GD16409@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johannes Weiner <hannes@cmpxchg.org> [2011-02-03 15:26:01]:

> This patch series removes the direct page pointer from struct
> page_cgroup, which saves 20% of per-page memcg memory overhead (Fedora
> and Ubuntu enable memcg per default, openSUSE apparently too).
> 
> The node id or section number is encoded in the remaining free bits of
> pc->flags which allows calculating the corresponding page without the
> extra pointer.
> 
> I ran, what I think is, a worst-case microbenchmark that just cats a
> large sparse file to /dev/null, because it means that walking the LRU
> list on behalf of per-cgroup reclaim and looking up pages from
> page_cgroups is happening constantly and at a high rate.  But it made
> no measurable difference.  A profile reported a 0.11% share of the new
> lookup_cgroup_page() function in this benchmark.

Wow! defintely worth a deeper look.

> 
> 	Hannes

-- 
	Three Cheers,
	Balbir
