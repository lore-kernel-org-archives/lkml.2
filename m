Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab2AWLxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 06:53:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64385 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2AWLxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 06:53:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120123112022.GB1707@cmpxchg.org>
References: <CAJd=RBC8dCGgqXqP+yjW2+pVoSeFXwXfjx8DLHhMuY8goOadZw@mail.gmail.com>
	<CAJd=RBBqp3bMGwFc14BJ7+=KsfO0gLnrnXwbRdLDYOJDdvbptA@mail.gmail.com>
	<20120123112022.GB1707@cmpxchg.org>
Date: Mon, 23 Jan 2012 19:53:45 +0800
Message-ID: <CAJd=RBDEGDZkCTC_rwE9jWRBJuWDdncoQ55fip9TYukqqUFoNw@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: ensure reclaiming pages on the lru lists of zone
From: Hillf Danton <dhillf@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 7:20 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Jan 23, 2012 at 12:47:34AM +0800, Hillf Danton wrote:
>> Hi all
>>
>> For easy review, it is re-prepared based on 3.3-rc1.
>>
>> Thanks
>> Hillf
>>
>> ===cut please===
>> From: Hillf Danton <dhillf@gmail.com>
>> Subject: [PATCH] mm: vmscan: ensure reclaiming pages on the lru lists of zone
>>
>> While iterating over memory cgroup hierarchy, pages are reclaimed from each
>> mem cgroup, and reclaim terminates after a full round-trip. It is possible
>> that no pages on the lru lists of given zone are reclaimed, as termination
>> is checked after the reclaiming function.
>>
>> Mem cgroup iteration is rearranged a bit to make sure that pages are reclaimed
>> from both mem cgroups and zone.
>
> It's not only possible, it's guaranteed: with the memory controller
> enabled, the global per-zone lru lists are empty.
>
> Pages used to be linked on the global per-zone AND the memcg per-zone
> lru lists.  Nowadays, they only sit on the memcg per-zone lists, which
> is why global reclaim does a hierarchy walk.
>

Thanks for getting me up to date 8-)
Hillf
