Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2J2NwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:52:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab2J2NwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:52:07 -0400
Date: Mon, 29 Oct 2012 14:52:03 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 2/6] memcg: root_cgroup cannot reach
 mem_cgroup_move_parent
Message-ID: <20121029135203.GA20757@dhcp22.suse.cz>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
 <1351251453-6140-3-git-send-email-mhocko@suse.cz>
 <508E8910.40203@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508E8910.40203@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29-10-12 17:48:00, Glauber Costa wrote:
> On 10/26/2012 03:37 PM, Michal Hocko wrote:
> > The root cgroup cannot be destroyed so we never hit it down the
> > mem_cgroup_pre_destroy path and mem_cgroup_force_empty_write shouldn't
> > even try to do anything if called for the root.
> > 
> > This means that mem_cgroup_move_parent doesn't have to bother with the
> > root cgroup and it can assume it can always move charges upwards.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > Reviewed-by: Tejun Heo <tj@kernel.org>
> 
> I think it would be safer to have this folded in the last patch, to
> avoid a weird intermediate state (specially for force_empty).

force_empty excludes root cgroup explicitly so there is no way to fail
here. I have kept VM_BUG_ON for future reference but it also can go away
completely.

> Being a single statement, it doesn't confuse review so much.
> 
> However, this is also pretty much just a nitpick, do as you prefer.
> 
> Reviewed-by: Glauber Costa <glommer@parallels.com>
> 

-- 
Michal Hocko
SUSE Labs
