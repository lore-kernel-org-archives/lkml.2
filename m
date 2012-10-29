Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab2J2NsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:48:15 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46098 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759108Ab2J2NsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:48:13 -0400
Message-ID: <508E8910.40203@parallels.com>
Date: Mon, 29 Oct 2012 17:48:00 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 2/6] memcg: root_cgroup cannot reach mem_cgroup_move_parent
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-3-git-send-email-mhocko@suse.cz>
In-Reply-To: <1351251453-6140-3-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 03:37 PM, Michal Hocko wrote:
> The root cgroup cannot be destroyed so we never hit it down the
> mem_cgroup_pre_destroy path and mem_cgroup_force_empty_write shouldn't
> even try to do anything if called for the root.
> 
> This means that mem_cgroup_move_parent doesn't have to bother with the
> root cgroup and it can assume it can always move charges upwards.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Tejun Heo <tj@kernel.org>

I think it would be safer to have this folded in the last patch, to
avoid a weird intermediate state (specially for force_empty). Being a
single statement, it doesn't confuse review so much.

However, this is also pretty much just a nitpick, do as you prefer.

Reviewed-by: Glauber Costa <glommer@parallels.com>

