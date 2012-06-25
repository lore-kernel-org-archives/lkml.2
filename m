Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2FYEqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:46:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46222 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2FYEqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:46:48 -0400
Date: Mon, 25 Jun 2012 12:46:38 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpen Li <liwp.linux@gmail.com>
Subject: Re: [PATCH 1/6] memcg: replace unsigned long by u64 to avoid overflow
Message-ID: <20120625044638.GB3894@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340432134-5178-1-git-send-email-liwp.linux@gmail.com>
 <20120623081514.GJ27816@cmpxchg.org>
 <20120623090339.GA6184@kernel>
 <20120623092654.GL27816@cmpxchg.org>
 <4FE7E7FA.80702@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE7E7FA.80702@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 01:24:26PM +0900, Kamezawa Hiroyuki wrote:
>(2012/06/23 18:26), Johannes Weiner wrote:
>>On Sat, Jun 23, 2012 at 05:03:39PM +0800, Wanpeng Li wrote:
>>>On Sat, Jun 23, 2012 at 10:15:14AM +0200, Johannes Weiner wrote:
>>>>On Sat, Jun 23, 2012 at 02:15:34PM +0800, Wanpeng Li wrote:
>>>>>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>>>>
>>>>>Since the return value variable in mem_cgroup_zone_nr_lru_pages and
>>>>>mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
>>>>>value of funtions by u64 to avoid overflow.
>>>>
>>>>I wonder what 16 TB of memory must think running on a 32-bit kernel...
>>>>"What is this, an address space for ants?"
>>>
>>>Hi Johannes,
>>>
>>>You mean change all u64 in memcg to unsigned long? or something I
>>>miss....
>>
>>Not _all_ of them, we have some that count bytes.  But those counting
>>pages should probably be ulong, yes.
>>
>>I think Kame added the ones that you wanted to adjust the surroundings
>>for in particular, so let's ask him.  Kame?
>>
>
>I've been using 'unsigned long' for the number of pages and 'u64' for the number of
>bytes. I think it's enough and it should be. I don't have any reason to use u64 for
>the number of pages on 32bit archs.
>If 'bytes' are handled by 'unsigned long', please fix it.
>
>BTW, zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'.
>If you want to change this in memcg, please change zone's ones first.

Thank you for your comments Kame! :-) I will do this in next version.
Is any suggestion about patches in this patchset.

Regards,
Wanpeng Li

>
>Thanks,
>-Kame
>
