Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2ECJN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:13:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51914 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2ECJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:13:54 -0400
Date: Thu, 3 May 2012 02:13:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
In-Reply-To: <87fwbnag6u.fsf@skywalker.in.ibm.com>
Message-ID: <alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au> <4F9ABF9C.2070707@xenotime.net> <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com> <20120427132343.fbb443b9.akpm@linux-foundation.org> <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
 <20120427143646.8209627e.akpm@linux-foundation.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu) <87fwbnag6u.fsf@skywalker.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2012, Aneesh Kumar K.V wrote:

> My first version was to do it as a seperate controller 
> 
> http://thread.gmane.org/gmane.linux.kernel.mm/73826
> 
> But the feedback I received was to do it as a part of memcg extension,
> because what the controller is limiting is memory albeit a different
> type. AFAIU there is also this goal of avoiding controller proliferation.
> 

Maybe Kame can speak up if he feels strongly about this, but I really 
think it should be its own controller in its own file (which would 
obviously make this discussion irrelevant since mm/hugetlbcg.c would be 
dependent on your own config symbol).  I don't feel like this is the same 
as kmem since its not a global resource like hugetlb pages are.

Hugetlb pages can either be allocated statically on the command line at 
boot or dynamically via sysfs and they are globally available to whoever 
mmaps them through hugetlbfs.  I see a real benefit from being able to 
limit the number of hugepages in the global pool to a set of tasks so they 
can't overuse what has been statically or dynamically allocated.  And that 
ability should be available, in my opinion, without having to enable 
memcg, the page_cgroup metadata overhead that comes along with it, and the 
performance impact in using it.  I also think it would be wise to seperate 
it out into its own file at the source level so things like this don't 
arise in the future.

What do you think?  Kame?
