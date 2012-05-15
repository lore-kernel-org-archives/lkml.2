Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154Ab2EOPM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:12:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2EOPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:12:23 -0400
Date: Tue, 15 May 2012 08:12:10 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] memcg: fix error code in
 hugetlb_force_memcg_empty()
Message-ID: <20120515151210.GB6119@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <4FACDFAE.5050808@jp.fujitsu.com>
 <20120514181556.GE2366@google.com>
 <20120514183219.GG2366@google.com>
 <4FB1AD0A.50901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB1AD0A.50901@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:10:34AM +0900, KAMEZAWA Hiroyuki wrote:
> (2012/05/15 3:32), Tejun Heo wrote:
> 
> > On Mon, May 14, 2012 at 11:15:56AM -0700, Tejun Heo wrote:
> >> On Fri, May 11, 2012 at 06:45:18PM +0900, KAMEZAWA Hiroyuki wrote:
> >>> -		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
> >>> +		if (cgroup_task_count(cgroup)
> >>> +			|| !list_empty(&cgroup->children)) {
> >>> +			ret = -EBUSY;
> >>>  			goto out;
> >>
> >> Why break the line?  It doesn't go over 80 col.
> > 
> > Ooh, it does.  Sorry, my bad.  But still, isn't it more usual to leave
> > the operator in the preceding line and align the start of the second
> > line with the first?  ie.
> > 
> > 		if (cgroup_task_count(cgroup) ||
> > 		    !list_empty(&cgroup->children)) {
> > 
> 
> 
> How about this ?
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Fri, 27 Apr 2012 13:19:19 +0900
> Subject: [PATCH] memcg: fix error code in hugetlb_force_memcg_empty()
> 
> Changelog:
>  - clean up.
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Heh, it was a nitpick anyway.  Please feel free to add my reviewed-by
for the whole series.

Thank you!

-- 
tejun
