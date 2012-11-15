Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767844Ab2KONsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:48:13 -0500
Received: from mx2.parallels.com ([64.131.90.16]:51078 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767809Ab2KONsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:48:12 -0500
Message-ID: <50A4F289.1090807@parallels.com>
Date: Thu, 15 Nov 2012 17:47:53 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 5/7] memcg: get rid of once-per-second cache shrinking
 for dead memcgs
References: <1352948093-2315-1-git-send-email-glommer@parallels.com> <1352948093-2315-6-git-send-email-glommer@parallels.com> <50A4B8C8.6020202@jp.fujitsu.com>
In-Reply-To: <50A4B8C8.6020202@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 01:41 PM, Kamezawa Hiroyuki wrote:
> (2012/11/15 11:54), Glauber Costa wrote:
>> The idea is to synchronously do it, leaving it up to the shrinking
>> facilities in vmscan.c and/or others. Not actively retrying shrinking
>> may leave the caches alive for more time, but it will remove the ugly
>> wakeups. One would argue that if the caches have free objects but are
>> not being shrunk, it is because we don't need that memory yet.
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> CC: Michal Hocko <mhocko@suse.cz>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Johannes Weiner <hannes@cmpxchg.org>
>> CC: Andrew Morton <akpm@linux-foundation.org>
> 
> I agree this patch but can we have a way to see the number of unaccounted
> zombie cache usage for debugging ?
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
Any particular interface in mind ?


