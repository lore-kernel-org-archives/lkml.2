Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2FWKNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:13:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56645 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2FWKNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:13:44 -0400
Date: Sat, 23 Jun 2012 18:13:28 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH 4/6] memcg: move recent_rotated and recent_scanned
 informations
Message-ID: <20120623101328.GA2153@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340432259-5317-1-git-send-email-liwp.linux@gmail.com>
 <20120623095112.GO27816@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623095112.GO27816@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 11:51:13AM +0200, Johannes Weiner wrote:
>On Sat, Jun 23, 2012 at 02:17:39PM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Move recent_rotated and recent_scanned prints next to inactive_anon,
>> ative_anon, inactive_file, active_file, and unevictable prints to
>> save developers' time. Since they have to go a long way(when cat memory.stat)
>> to find recent_rotated and recent_scanned prints which has relationship
>> with the memory cgroup we care. These prints are behind total_* which
>> not just focus on the memory cgroup we care currently.
>
>The hierarchical stats are about that memcg, too.  And I don't want to

Move recent_rotated and recent_scanned prints next to file lru lists
just because the pageout code in vmscan.c keeps track of how many of 
the mem/swap backed and file backed pages are referenced, and the 
higher the rotated/scanned ratio, the more valuable that cache is. 
Move five lru lists and associated debug informations together can 
make things convenience. :-)

Regards,
Wanpeng Li

>turn on debugging and then look for the extra information hiding in
>the middle of regular stats.
