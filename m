Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2GSKZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:25:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58465 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2GSKZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:25:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5007E00B.6000802@jp.fujitsu.com>
Date: Thu, 19 Jul 2012 19:23:07 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: Re: [PATCH v2] mm/memcg: use exist interface to get css from memcg
References: <1342609734-22437-1-git-send-email-liwanp@linux.vnet.ibm.com> <20120719092928.GA2864@tiehlicka.suse.cz>
In-Reply-To: <20120719092928.GA2864@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/19 18:29), Michal Hocko wrote:
> On Wed 18-07-12 19:08:54, Wanpeng Li wrote:
>> use exist interface mem_cgroup_css instead of &mem->css.
>
> This interface has been added to enable mem->css outside of
> mm/memcontrol.c (where we define struct mem_cgroup). There is one user
> left (hwpoison_filter_task) after recent clean ups.
>
> I think we shouldn't spread the usage inside the mm/memcontrol.c. The
> compiler inlines the function for all callers added by this patch but I
> wouldn't rely on it. It is also unfortunate that we cannot convert all
> dereferences (e.g. const mem_cgroup).
> Moreover it doesn't add any additional type safety. So I would vote for
> not taking the patch but if others like it I will not block it.
>

Agreed.

-Kame

