Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2CDTQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 14:16:15 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48919 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2CDTQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 14:16:13 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH -V2 0/9] memcg: add HugeTLB resource tracking
In-Reply-To: <20120301144029.545a5589.akpm@linux-foundation.org>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120301144029.545a5589.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 05 Mar 2012 00:45:55 +0530
Message-ID: <878vjgdvo4.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12030419-5816-0000-0000-000001954DBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012 14:40:29 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
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
> your attention to https://lkml.org/lkml/2012/2/15/548.

Hmm that's really serious bug.

>  That fix has
> been hanging around for a while, but I haven't done anything with it
> yet because I don't like its additional blurring of the separation
> between hugetlb core code and hugetlbfs.  I want to find time to sit
> down and see if the fix can be better architected but haven't got
> around to that yet.
> 
> I expect that your patches will conflict at least mechanically with
> David's, which is not a big issue.  But I wonder whether your patches
> will copy the same bug into other places, and whether you can think of
> a tidier way of addressing the bug which David is seeing?
> 

I will go through the implementation again and make sure the problem
explained by David doesn't happen in the new code path added by the
patch series.

Thanks
-aneesh

