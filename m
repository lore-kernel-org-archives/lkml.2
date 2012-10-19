Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2JSJd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:33:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4372 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2JSJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:33:54 -0400
Message-ID: <50811E5E.1090205@huawei.com>
Date: Fri, 19 Oct 2012 17:33:18 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz> <1350480648-10905-5-git-send-email-mhocko@suse.cz>
In-Reply-To: <1350480648-10905-5-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/10/17 21:30, Michal Hocko wrote:
> Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
> safely move on and forbit all the callbacks to fail. The last missing
> piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
> that css_tryget fails so no new charges for the memcg can happen.

> The callbacks are also called from within cgroup_lock to guarantee that
> no new tasks show up. 

I'm afraid this won't work. See commit 3fa59dfbc3b223f02c26593be69ce6fc9a940405
("cgroup: fix potential deadlock in pre_destroy")

> We could theoretically call them outside of the
> lock but then we have to move after CGRP_REMOVED flag is set.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  kernel/cgroup.c |   30 +++++++++---------------------
>  1 file changed, 9 insertions(+), 21 deletions(-)

