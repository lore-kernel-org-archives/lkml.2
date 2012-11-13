Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2KMVNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:13:31 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34227 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab2KMVN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:13:29 -0500
Date: Tue, 13 Nov 2012 16:13:24 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 4/6] cgroups: forbid pre_destroy callback to fail
Message-ID: <20121113211324.GC1543@cmpxchg.org>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
 <1351251453-6140-5-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351251453-6140-5-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:37:31PM +0200, Michal Hocko wrote:
> Now that mem_cgroup_pre_destroy callback doesn't fail (other than a race
> with a task attach resp. child group appears) finally we can safely move
> on and forbit all the callbacks to fail.
> The last missing piece is moving cgroup_call_pre_destroy after
> cgroup_clear_css_refs so that css_tryget fails so no new charges for the
> memcg can happen.
> We cannot, however, move cgroup_call_pre_destroy right after because we
> cannot call mem_cgroup_pre_destroy with the cgroup_lock held (see
> 3fa59dfb cgroup: fix potential deadlock in pre_destroy) so we have to
> move it after the lock is released.
> 
> Changes since v1
> - Li Zefan pointed out that mem_cgroup_pre_destroy cannot be called with
>   cgroup_lock held
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
