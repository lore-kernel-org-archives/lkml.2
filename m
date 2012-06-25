Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2FYKCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:02:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44056 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2FYKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:01:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE83695.6010007@jp.fujitsu.com>
Date: Mon, 25 Jun 2012 18:59:49 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Wanpeng Li <liwp.linux@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 1/4] memcg: cleanup useless LRU_ALL_EVICTABLE
References: <1340613812-9458-1-git-send-email-liwp.linux@gmail.com> <20120625093328.GD19805@tiehlicka.suse.cz>
In-Reply-To: <20120625093328.GD19805@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/25 18:33), Michal Hocko wrote:
> Marking this patch as memcg is quite misleading. mm is more suitable.
>
> On Mon 25-06-12 16:43:32, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>
>> Since LRU_ALL_EVICTABLE is useless, just remove it.
>
> It's really strange but I do not see any usage of this except for it's
> introduction. So agreed to remove it.
>
>> Add LRU_ALL_UNEVICTABLE to mask unevictable pages.
>
> Does it really make sense to introduce just for two uses in a single
> function?
>

I don't think so.

I doubt LRU_ALL_UNEVICTABLE implies there are other UNEVICTABLE LRUS
other than LRU_UNEVICTABLE.

For example, LRU_ALL_UNEVICTABLE means
	if total_swap==0, UNEVICTABLE+ANON
	if total_swap!=0, UNEVICTABLE,

This will have its own meanings...but I don't see there are any users.

Thanks,
-Kame


