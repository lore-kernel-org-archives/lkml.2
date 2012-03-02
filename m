Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2CBDez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 22:34:55 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34924 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab2CBDey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 22:34:54 -0500
Date: Fri, 2 Mar 2012 14:28:53 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, linux-mm@kvack.org,
        mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V2 0/9] memcg: add HugeTLB resource tracking
Message-ID: <20120302032853.GB2728@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
	dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120301144029.545a5589.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301144029.545a5589.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030117-1618-0000-0000-000000F7D035
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 02:40:29PM -0800, Andrew Morton wrote:
> On Thu,  1 Mar 2012 14:46:11 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > This patchset implements a memory controller extension to control
> > HugeTLB allocations. It is similar to the existing hugetlb quota
> > support in that, the limit is enforced at mmap(2) time and not at
> > fault time. HugeTLB's quota mechanism limits the number of huge pages
> > that can allocated per superblock.
> > 
> > For shared mappings we track the regions mapped by a task along with the
> > memcg. We keep the memory controller charged even after the task
> > that did mmap(2) exits. Uncharge happens during truncate. For Private
> > mappings we charge and uncharge from the current task cgroup.
> 
> I haven't begin to get my head around this yet, but I'd like to draw
> your attention to https://lkml.org/lkml/2012/2/15/548.  That fix has
> been hanging around for a while, but I haven't done anything with it
> yet because I don't like its additional blurring of the separation
> between hugetlb core code and hugetlbfs.  I want to find time to sit
> down and see if the fix can be better architected but haven't got
> around to that yet.

So.. that version of the fix I specifically rebuilt to address your
concerns about that blurring - in fact I think it reduces the current
layer blurring.  I haven't had any reply - what problems do see it as
still having?

> I expect that your patches will conflict at least mechanically with
> David's, which is not a big issue.  But I wonder whether your patches
> will copy the same bug into other places, and whether you can think of
> a tidier way of addressing the bug which David is seeing?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

