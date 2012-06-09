Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2FIORO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 10:17:14 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40160 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2FIORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 10:17:12 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, mgorman@suse.de,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, dhillf@gmail.com,
        aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
In-Reply-To: <20120608160612.dea6d1ce.akpm@linux-foundation.org>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com> <87lik920h8.fsf@skywalker.in.ibm.com> <20120608160612.dea6d1ce.akpm@linux-foundation.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 09 Jun 2012 19:46:52 +0530
Message-ID: <87zk8cfu3v.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12060914-8878-0000-0000-000002D5B452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 30 May 2012 20:13:31 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>
>> >> 
>> >>  - code: seperating hugetlb bits out from memcg bits to avoid growing 
>> >>    mm/memcontrol.c beyond its current 5650 lines, and
>> >> 
>> >
>> > I can definitely look at spliting mm/memcontrol.c 
>> >
>> >
>> >>  - performance: not incurring any overhead of enabling memcg for per-
>> >>    page tracking that is unnecessary if users only want to limit hugetlb 
>> >>    pages.
>> >> 
>> 
>> Since Andrew didn't sent the patchset to Linus because of this
>> discussion, I looked at reworking the patchset as a seperate
>> controller. The patchset I sent here
>> 
>> http://thread.gmane.org/gmane.linux.kernel.mm/79230
>> 
>> have seen minimal testing. I also folded the fixup patches
>> Andrew had in -mm to original patchset.
>> 
>> Let me know if the changes looks good.
>
> This is starting to be a problem.  I'm still sitting on the old version
> of this patchset and it will start to get in the way of other work.
>
> We now have this new version of the patchset which implements a
> separate controller but it is unclear to me which way we want to go.
>
> Can the memcg developers please drop everything else and make a
> decision here?


David Rientjes didn't like HugetTLB limit to be a memcg extension and
wanted this to be a separate controller. I posted a v7 version that did
HugeTLB limit as a separate controller and used page cgroup to track
HugeTLB cgroup. Kamezawa Hiroyuki didn't like the usage of page_cgroup
in HugeTLB controller( http://mid.gmane.org/4FCD648E.90709@jp.fujitsu.com )

I ended up doing a v8 that used page[2].lru.next for storing hugetlb
controller.

http://mid.gmane.org/1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com

I guess that should address all the concerns.

-aneesh

