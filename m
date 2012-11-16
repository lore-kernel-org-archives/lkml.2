Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab2KPFIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:08:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33667 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2KPFIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:08:52 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A5CA16.7070603@jp.fujitsu.com>
Date: Fri, 16 Nov 2012 14:07:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 5/7] memcg: get rid of once-per-second cache shrinking
 for dead memcgs
References: <1352948093-2315-1-git-send-email-glommer@parallels.com> <1352948093-2315-6-git-send-email-glommer@parallels.com> <50A4B8C8.6020202@jp.fujitsu.com> <50A4F289.1090807@parallels.com>
In-Reply-To: <50A4F289.1090807@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/15 22:47), Glauber Costa wrote:
> On 11/15/2012 01:41 PM, Kamezawa Hiroyuki wrote:
>> (2012/11/15 11:54), Glauber Costa wrote:
>>> The idea is to synchronously do it, leaving it up to the shrinking
>>> facilities in vmscan.c and/or others. Not actively retrying shrinking
>>> may leave the caches alive for more time, but it will remove the ugly
>>> wakeups. One would argue that if the caches have free objects but are
>>> not being shrunk, it is because we don't need that memory yet.
>>>
>>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>>> CC: Michal Hocko <mhocko@suse.cz>
>>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> CC: Johannes Weiner <hannes@cmpxchg.org>
>>> CC: Andrew Morton <akpm@linux-foundation.org>
>>
>> I agree this patch but can we have a way to see the number of unaccounted
>> zombie cache usage for debugging ?
>>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
> Any particular interface in mind ?
> 

Hmm, it's debug interface and having cgroup file may be bad.....
If it can be seen in bytes or some, /proc/vmstat ?

out_of_track_slabs  xxxxxxx. hm ?

Thanks,
-Kame






