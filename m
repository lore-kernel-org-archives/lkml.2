Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab2ECXRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:17:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65403 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2ECXRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:17:13 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
	<4F9ABF9C.2070707@xenotime.net>
	<alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com>
	<20120427132343.fbb443b9.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
	<20120427143646.8209627e.akpm@linux-foundation.org>
	<87fwbnag6u.fsf@skywalker.in.ibm.com>
	<alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com>
	<CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
	<alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
Date: Fri, 4 May 2012 08:17:11 +0900
Message-ID: <CABEgKgoNaWtoNN_DOH+KTg7VHYDxVCyekcUC3TBfA313TR0jCw@mail.gmail.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 5:56 AM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 3 May 2012, Hiroyuki Kamezawa wrote:
>
>> I think hugetlb should be handled under memcg.

>> 2. The characteristics of hugetlb usage you pointed out is
>> characteristics comes from
>>    "current" implementation.
>>     Yes, it's now unreclaimable and should be allocated by hands of
>> admin. But,
>>     considering recent improvements, memory-defrag, CMA, it can be less
>>     hard-to-use thing by updating implementation and on-demand allocation
>>     can be allowed.
>>
>
> You're describing transparent hugepages which are already supported by
> memcg specifically because they are transparent.

THP just handles hugepages whose size is equal to pgd size. So, hugetlb
is something more than that, it has various sizes.

> I haven't seen any
> proposals on how to change hugetlb when it comes to preallocation and
> mmaping the memory because it would break the API with userspace.
> Userspace packages like hugeadm are actually used in a wide variety of
> places.
>

I just said if users doesn't need to set sysctl, it's more useful. I got similar
claims from users with IPC max params ;) I answerd set it unlimited...


>> 3. If overhead is the problem, and it's better to disable memcg,
>>     Please show numbers with HPC apps. I didn't think memcg has very
>> bad overhead
>>     with Bull's presentation in collaboration summit, this April.
>>
>
> Is this a claim that memory-intensive workloads will have the exact same
> performance with and without memcg enabled?

I wrote that I don't get any report that memcg is too slow and need to be fixed.

I think, in general, once memory is allocated, application will run
faster if it never
free memory. So, good application frees memory in batch when it can do. Because
memcg just adds overheads to memory allocation and unmapping, runtime overhead
tend to be small.
My target number when I started to join memcg developments was 2-3% overheads.

> Even if there's the slightest performance degradation, these are what
> users of hugetlb are concerned with already.  They use hugetlb for
> performance and it would be a shame for it to regress because you have to
> enable memcg.
>

I think such people don't limit any usages....any kinds of
virtualization/resource controls has 0 overheads.

>> 4. I guess a user who uses hugetlbfs will use usual memory at the same time.
>>     Having 2 hierarchy for memory and hugetlb will bring him a confusion.
>>
>
> Cgroups is moving to a single hierarchy for simplification, this isn't the
> only example of where this is currently suboptimal and it would be
> disappointing to solidify hugetlb control as part of memcg because of this
> current limitation that will be addressed by generic cgroups development.
>
> Folks, once these things are merged they become an API that can't easily
> be shifted around and seperated out later.  The decision now is either to
> join hugetlb control with memcg forever when they act in very different
> ways or to seperate them so they can be used and configured individually.

How do other guys think ? Tejun ?

Thanks,
-Kame
