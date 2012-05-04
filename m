Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab2EDS3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:29:17 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54241 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2EDS3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:29:15 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
In-Reply-To: <alpine.DEB.2.00.1205031454400.1631@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au> <4F9ABF9C.2070707@xenotime.net> <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com> <20120427132343.fbb443b9.akpm@linux-foundation.org> <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com> <20120427143646.8209627e.akpm@linux-foundation.org> <87fwbnag6u.fsf@skywalker.in.ibm.com> <alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com> <CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com> <alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com> <alpine.DEB.2.00.1205031454400.1631@chino.kir.corp.google.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 04 May 2012 23:59:02 +0530
Message-ID: <877gwryf4h.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12050418-8878-0000-0000-00000248F40C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

>> Is this a claim that memory-intensive workloads will have the exact same 
>> performance with and without memcg enabled?

> I've just run specjbb2005 three times on my system both with and without 
> cgroup_disable=memory on the command line and it is consistently 1% faster 
> without memcg.  If I add XX:+UseLargePages to the command line to use 
> hugepages it's even larger.  So why must I incur this performance 
> degradation if I simply want to control who may mmap hugepages out of the 
> global pool?

Even if we end up having a seperate controller for hugetlb, we would need
some bits of memcg, like tracking page cgroup, moving page cgroup on
page offline. We will also be duplicating some amount of framework for
supporting cgroup removal etc, because all those code deal with struct
page (actually compound page )

-aneesh

