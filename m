Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2JRWmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:42:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54158 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab2JRWlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:41:52 -0400
Date: Thu, 18 Oct 2012 15:41:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Message-ID: <20121018224148.GR13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350480648-10905-5-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Oct 17, 2012 at 03:30:46PM +0200, Michal Hocko wrote:
> Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
> safely move on and forbit all the callbacks to fail. The last missing
> piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
> that css_tryget fails so no new charges for the memcg can happen.
> The callbacks are also called from within cgroup_lock to guarantee that
> no new tasks show up. We could theoretically call them outside of the
> lock but then we have to move after CGRP_REMOVED flag is set.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

So, the plan is to do something like the following once memcg is
ready.

  http://thread.gmane.org/gmane.linux.kernel.containers/22559/focus=75251

Note that the patch is broken in a couple places but it does show the
general direction.  I'd prefer if patch #3 simply makes pre_destroy()
return 0 and drop __DEPRECATED_clear_css_refs from mem_cgroup_subsys.
Then, I can pull the branch in and drop all the unnecessary cruft.

Thanks.

-- 
tejun
