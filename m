Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2KNIhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:37:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab2KNIhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:37:02 -0500
Date: Wed, 14 Nov 2012 09:36:53 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC] rework mem_cgroup iterator
Message-ID: <20121114083653.GA17111@dhcp22.suse.cz>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <50A2F9FC.5050303@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A2F9FC.5050303@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-11-12 09:55:08, Li Zefan wrote:
> On 2012/11/13 23:30, Michal Hocko wrote:
> > Hi all,
> > this patch set tries to make mem_cgroup_iter saner in the way how it
> > walks hierarchies. css->id based traversal is far from being ideal as it
> > is not deterministic because it depends on the creation ordering.
> > 
> > Diffstat looks promising but it is fair the say that the biggest cleanup is
> > just css_get_next removal. The memcg code has grown a bit but I think it is
> > worth the resulting outcome (the sanity ;)).
> > 
> 
> So memcg won't use css id at all, right?

Unfortunately we still use it for the swap accounting but that one could
be replaced by something else, probably. Have to think about it.

> Then we can remove the whole css_id stuff, and that's quite a bunch of
> code.

Is memcg the only user of css_id? Quick grep shows that yes but I
haven't checked all the callers of the exported functions. I would be
happy if more code goes away.

-- 
Michal Hocko
SUSE Labs
