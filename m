Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2GSK22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:28:28 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37076 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2GSK21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:28:27 -0400
Date: Thu, 19 Jul 2012 18:28:18 +0800
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>, Bob Liu <lliubbo@gmail.com>
Subject: Re: [PATCH v2] mm/memcg: use exist interface to get css from memcg
Message-ID: <20120719102818.GA20171@kernel>
Reply-To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
References: <1342609734-22437-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20120719092928.GA2864@tiehlicka.suse.cz>
 <5007E00B.6000802@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5007E00B.6000802@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12071900-5140-0000-0000-000001C53671
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 07:23:07PM +0900, Kamezawa Hiroyuki wrote:
>(2012/07/19 18:29), Michal Hocko wrote:
>>On Wed 18-07-12 19:08:54, Wanpeng Li wrote:
>>>use exist interface mem_cgroup_css instead of &mem->css.
>>
>>This interface has been added to enable mem->css outside of
>>mm/memcontrol.c (where we define struct mem_cgroup). There is one user
>>left (hwpoison_filter_task) after recent clean ups.
>>
>>I think we shouldn't spread the usage inside the mm/memcontrol.c. The
>>compiler inlines the function for all callers added by this patch but I
>>wouldn't rely on it. It is also unfortunate that we cannot convert all
>>dereferences (e.g. const mem_cgroup).
>>Moreover it doesn't add any additional type safety. So I would vote for
>>not taking the patch but if others like it I will not block it.
>>
>
>Agreed.

Hmm, I see, thank you. :-)

Best Regards,
Wanpeng Li
>
>-Kame

