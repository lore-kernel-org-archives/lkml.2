Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab2J2Nph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:45:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45987 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625Ab2J2Npf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:45:35 -0400
Message-ID: <508E886C.20908@parallels.com>
Date: Mon, 29 Oct 2012 17:45:16 +0400
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
Subject: Re: [PATCH v3 1/6] memcg: split mem_cgroup_force_empty into reclaiming
 and reparenting parts
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-2-git-send-email-mhocko@suse.cz>
In-Reply-To: <1351251453-6140-2-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 03:37 PM, Michal Hocko wrote:
> mem_cgroup_force_empty did two separate things depending on free_all
> parameter from the very beginning. It either reclaimed as many pages as
> possible and moved the rest to the parent or just moved charges to the
> parent. The first variant is used as memory.force_empty callback while
> the later is used from the mem_cgroup_pre_destroy.
> 
> The whole games around gotos are far from being nice and there is no
> reason to keep those two functions inside one. Let's split them and
> also move the responsibility for css reference counting to their callers
> to make to code easier.
> 
> This patch doesn't have any functional changes.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Glauber Costa <glommer@parallels.com>
