Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab2D0X7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:59:10 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55610 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab2D0X7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120427182018.GI26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A34B2.8080103@jp.fujitsu.com>
	<20120427182018.GI26595@google.com>
Date: Sat, 28 Apr 2012 08:59:08 +0900
Message-ID: <CABEgKgooq6EUFRC2-19QxACpGN5+EHn=OwPzk+tMBLy-pYM9XQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/7 v2] memcg: use res_counter_uncharge_until in move_parent
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 3:20 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Apr 27, 2012 at 02:54:58PM +0900, KAMEZAWA Hiroyuki wrote:
>> By using res_counter_uncharge_until(), we can avoid
>> unnecessary charging.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  mm/memcontrol.c |   63 ++++++++++++++++++++++++++++++++++++------------------
>>  1 files changed, 42 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 613bb15..ed53d64 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2420,6 +2420,24 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
>>  }
>>
>>  /*
>> + * Cancel chages in this cgroup....doesn't propagates to parent cgroup.
>
>             ^typo                                     ^ unnecessary s

Ya, thanks. I'll fix it.

-Kame
