Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2FKJXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:23:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45836 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2FKJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:23:15 -0400
Date: Mon, 11 Jun 2012 02:23:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com,
        aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
In-Reply-To: <4FD56C19.4060307@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206110220290.6843@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com> <20120608160612.dea6d1ce.akpm@linux-foundation.org> <4FD56C19.4060307@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, Kamezawa Hiroyuki wrote:

> Now, I think...
> 
>   1. I need to agree that overhead is _not_ negligible.
> 
>   2. THP should be the way rather than hugetlb for my main target platform.
>      (shmem/tmpfs should support THP. we need study.)
>      user-experience should be fixed by THP+tmpfs+memcg.
> 
>   3. It seems Aneesh decided to have independent hugetlb cgroup.
> 
> So, now, I admit to have independent hugetlb cgroup.
> Other opinions ?
> 

I suggested the seperate controller in the review of the patchset so I 
obviously agree with your conclusion.  I don't think we should account for 
hugetlb pages in memory.usage_in_bytes and enforce memory.limit_in_bytes 
since 512 4K pages is not the same as 1 2M page which may be a sacred 
resource if fragmentation is high.

Many thanks to Aneesh for continuing to update the patchset and working 
toward a resolution on this, I love the direction its taking.
