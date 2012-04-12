Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461Ab2DLRzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:55:04 -0400
Received: from mx2.parallels.com ([64.131.90.16]:33310 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab2DLRzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:55:03 -0400
Message-ID: <4F87168F.3060405@parallels.com>
Date: Thu, 12 Apr 2012 14:53:19 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com> <20120412172309.GM1787@cmpxchg.org> <20120412174155.GC13069@google.com>
In-Reply-To: <20120412174155.GC13069@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 02:41 PM, Tejun Heo wrote:
> I'm still split on the issue.
>
> * #tasks as unit of accounting / limiting is well understood (or at
>    least known).  I think this holds the same to #open files, to a
>    lesser extent.  It means there are and will continue to be people
>    wanting them.  So, they have some value in familiarity - "but... I
>    want to limit the resources consumed by tasks cuz that's what I
>    know!" factor.
>
> * People could want counting and limiting #tasks or #open files
>    without the overhead of tracking all memory resources.  This stems
>    from the same reason #tasks was used for this sort of things in the
>    first place.  Counting tasks or open files tends to be easier and
>    cheaper than tracking all memory allocations.
>
> So, there's spectrum of solutions between merging task counter and
> just directing everyone to kmem without distinguishing task resource
> at all, and at the moment voices in my head are succeeding at making
> cases for both directions.  What do you guys think about the above two
> issues?
>

About each of your points:

1) Quite honestly, if we were implementing what people say they want...
We'd have a lisp interpreter in the kernel by now.
At the very best, it is an issue of getting the communication right.
I really don't think this is of any concern.

2) It is dependent on the previous question/answer. Do people really 
want to account and limit that? Or do they just think they want?

Also note that we need to make memcg cheaper anyway... And right not it 
is not *that* expensive if you are not doing deep hierarchy.

user pages get cached through the stock mechanism, slab pages are not 
very frequently allocated (because first you need to exhaust the objects 
on the slab, etc)
