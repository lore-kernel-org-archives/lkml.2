Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2GFFB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:01:27 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54830 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab2GFFB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:01:26 -0400
Date: Fri, 6 Jul 2012 13:00:13 +0800
From: Gavin Shan <shangw@linux.vnet.ibm.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: swappiness should between 0 and 100
Message-ID: <20120706050013.GA15372@shangw>
Reply-To: Gavin Shan <shangw@linux.vnet.ibm.com>
References: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070605-6078-0000-0000-00000CED4C21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 12:51:52PM +0800, Wanpeng Li wrote:
>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
>Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>---
> mm/memcontrol.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>index 5e4d1ab..69a7d45 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -4176,7 +4176,7 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,

It seems that we don't have the function in mainline.

shangw@shangw:~/sandbox/linux/mm$ grep mem_cgroup_swappiness_write -r .
shangw@shangw:~/sandbox/linux/mm$ 

Thanks,
Gavin

> 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> 	struct mem_cgroup *parent;
>
>-	if (val > 100)
>+	if (val > 100 || val < 0)
> 		return -EINVAL;
>
> 	if (cgrp->parent == NULL)
>-- 
>1.7.5.4
>
>--
>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>the body to majordomo@kvack.org.  For more info on Linux MM,
>see: http://www.linux-mm.org/ .
>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

