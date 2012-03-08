Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2CHDmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 22:42:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:29747 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab2CHDmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 22:42:38 -0500
X-IronPort-AV: E=Sophos;i="4.73,550,1325433600"; 
   d="scan'208";a="4486740"
Message-ID: <4F582A37.8060802@cn.fujitsu.com>
Date: Thu, 08 Mar 2012 11:40:39 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier related
 damage v2
References: <20120306132735.GA2855@suse.de> <4F572730.8000000@cn.fujitsu.com> <20120307112201.GC17697@suse.de>
In-Reply-To: <20120307112201.GC17697@suse.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 11:40:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 11:40:41,
	Serialize complete at 2012-03-08 11:40:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wed, 7 Mar 2012 11:22:01 +0000, Mel Gorman wrote:
>> Beside that, we need deal with fork() carefully, or it is possible that the child
>> task will be set to a wrong nodemask.
>>
> 
> Can you clarify this statement please? It's not clear what the old code
> did that protected against problems in fork() versus this patch. fork is
> not calling get_mems_allowed() for example or doing anything special
> around mems_allowed.
> 
> Maybe you are talking about an existing problem whereby during fork
> there should be get_mems_allowed/put_mems_allowed and the mems_allowed
> mask gets copied explicitly?

Yes, If someone updates cpuset's nodemask or cpumask before the child task is attached
into the cpuset cgroup, the child task's nodemask and cpumask can not be updated, just
holds the old mask.

We can fix this problem by seqcounter in a new patch.(It seems the freeze subsystem also
has the same problem)

Thanks
Miao
