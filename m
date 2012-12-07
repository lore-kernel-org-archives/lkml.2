Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2LGJBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:01:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab2LGJBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:01:36 -0500
Date: Fri, 7 Dec 2012 10:01:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup
 iterators
Message-ID: <20121207090135.GC31938@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-4-git-send-email-mhocko@suse.cz>
 <CALWz4ixQR0vHp+mGJdi2q77dMHaG8BZmb+iKfMmT=T0V8X8rAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWz4ixQR0vHp+mGJdi2q77dMHaG8BZmb+iKfMmT=T0V8X8rAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-12-12 19:39:41, Ying Han wrote:
[...]
> Michal,
> 
> I got some trouble while running this patch with my test. The test
> creates hundreds of memcgs which each runs some workload to generate
> global pressure. At the last, it removes all the memcgs by rmdir. Then
> the cmd "ls /dev/cgroup/memory/" hangs afterwards.
>
> I studied a bit of the patch, but not spending too much time on it
> yet. Looks like that the v2 has something different from your last
> post, where you replaces the mem_cgroup_get() with css_get() on the
> iter->last_visited. Didn't follow why we made that change, but after
> restoring the behavior a bit seems passed my test.

Hmm, strange. css reference counting should be stronger than mem_cgroup
one because it pins css thus cgroup which in turn keeps memcg alive.

> Here is the patch I applied on top of this one:

[...]
-- 
Michal Hocko
SUSE Labs
