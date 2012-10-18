Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2JRWqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:46:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55679 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab2JRWqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:46:10 -0400
Date: Thu, 18 Oct 2012 15:46:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Message-ID: <20121018224606.GS13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <20121018224148.GR13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018224148.GR13370@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 03:41:48PM -0700, Tejun Heo wrote:
> Note that the patch is broken in a couple places but it does show the
> general direction.  I'd prefer if patch #3 simply makes pre_destroy()
> return 0 and drop __DEPRECATED_clear_css_refs from mem_cgroup_subsys.
> Then, I can pull the branch in and drop all the unnecessary cruft.

But you need the locking change for further memcg cleanup.  To avoid
interlocked pulls from both sides, I think it's okay to push this one
with the rest of memcg changes.  I can do the cleanup on top of this
whole series, but please do drop .__DEPRECATED_clear_css_refs from
memcg.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
