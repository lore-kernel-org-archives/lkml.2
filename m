Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370Ab2D0Udn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:33:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38423 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623Ab2D0Udl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:33:41 -0400
Date: Fri, 27 Apr 2012 13:33:36 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: Re: [RFC][PATCH 7/9 v2] cgroup: avoid attaching task to a cgroup
 under rmdir()
Message-ID: <20120427203336.GM26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A366E.9020307@jp.fujitsu.com>
 <20120427203159.GL26595@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427203159.GL26595@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 01:31:59PM -0700, Tejun Heo wrote:
> On Fri, Apr 27, 2012 at 03:02:22PM +0900, KAMEZAWA Hiroyuki wrote:
> > attach_task() is done under cgroup_mutex() but ->pre_destroy() callback
> > in rmdir() isn't called under cgroup_mutex().
> > 
> > It's better to avoid attaching a task to a cgroup which
> > is under pre_destroy(). Considering memcg, the attached task may
> > increase resource usage after memcg's pre_destroy() confirms that
> > memcg is empty. This is not good.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Hmm... once memcg's pre_destroy() can't fail, I think what we should
> do is marking a cgroup DEAD before calling pre_destroy() and the
> existing cgroup_is_removed() check should be enough.  Patches upto
> this point already make ->pre_destroy() not fail, right?

Ooh, I was confused about patch order.  This patch, probably with the
update suggested by Frederic looks good as an interim solution for
now.

Thanks.

-- 
tejun
