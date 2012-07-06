Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2GFFJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:09:01 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49775 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2GFFI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:08:59 -0400
Date: Fri, 6 Jul 2012 13:08:20 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: swappiness should between 0 and 100
Message-ID: <20120706050820.GB5929@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
 <20120706050013.GA15372@shangw>
 <20120706050430.GA27704@shangw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706050430.GA27704@shangw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 01:04:30PM +0800, Gavin Shan wrote:
>On Fri, Jul 06, 2012 at 01:00:13PM +0800, Gavin Shan wrote:
>>On Fri, Jul 06, 2012 at 12:51:52PM +0800, Wanpeng Li wrote:
>>>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>>
>>>Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>>>---
>>> mm/memcontrol.c |    2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>index 5e4d1ab..69a7d45 100644
>>>--- a/mm/memcontrol.c
>>>+++ b/mm/memcontrol.c
>>>@@ -4176,7 +4176,7 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
>>
>>It seems that we don't have the function in mainline.
>>
>>shangw@shangw:~/sandbox/linux/mm$ grep mem_cgroup_swappiness_write -r .
>>shangw@shangw:~/sandbox/linux/mm$ 
>>
>
>Please ignore that cause my git tree has some problems and everything
>in linux/mm has been cleared :-)

No problem. :-)

Best Regards,
Wanpeng Li

>
>Thanks,
>Gavin
>
>>Thanks,
>>Gavin
>>
>>> 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
>>> 	struct mem_cgroup *parent;
>>>
>>>-	if (val > 100)
>>>+	if (val > 100 || val < 0)
>>> 		return -EINVAL;
>>>
>>> 	if (cgrp->parent == NULL)
>>>-- 
>>>1.7.5.4
>>>
>>>--
>>>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>>the body to majordomo@kvack.org.  For more info on Linux MM,
>>>see: http://www.linux-mm.org/ .
>>>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>>
>>
>>--
>>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>the body to majordomo@kvack.org.  For more info on Linux MM,
>>see: http://www.linux-mm.org/ .
>>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
