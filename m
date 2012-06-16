Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2FPU04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:26:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54301 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2FPU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:26:54 -0400
Date: Sat, 16 Jun 2012 13:26:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Aditya Kali <adityakali@google.com>
cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com,
        aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
In-Reply-To: <CAGr1F2EzDc3Ypv6twFE8Ua-JZUEkEVQJOPKwLt0O56c2-PycvA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1206161322310.8407@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com> <20120608160612.dea6d1ce.akpm@linux-foundation.org> <4FD56C19.4060307@jp.fujitsu.com> <alpine.DEB.2.00.1206110220290.6843@chino.kir.corp.google.com> <CAGr1F2EzDc3Ypv6twFE8Ua-JZUEkEVQJOPKwLt0O56c2-PycvA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012, Aditya Kali wrote:

> Based on the usecase at Google, I see a definite value in including
> hugepage usage in memory.usage_in_bytes as well and having a single
> limit for memory usage for the job. Our jobs wants to specify only one
> (total) memory limit (including slab usage, and other kernel memory
> usage, hugepages, etc.).
> 
> The hugepage/smallpage requirements of the job vary during its
> lifetime. Having two different limits means less flexibility for jobs
> as they now have to specify their limit as (max_hugepage,
> max_smallpage) instead of max(hugepage + smallpage). Two limits
> complicates the API for the users and requires them to over-specify
> the resources.
> 

If a large number of hugepages, for example, are allocated on the command 
line because there's a lower success rate of dynamic allocation due to 
fragmentation, with your suggestion it would no longer allow the admin to 
restrict the use of those hugepages to only a particular set of tasks.  
Consider especially 1GB hugepagez on x86, your suggestion would treat a 
single 1GB hugepage which cannot be freed after boot exactly the same as 
using 1GB of memory which is obviously not the desired behavior of any 
hugetlb controller.
