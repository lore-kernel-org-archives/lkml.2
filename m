Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1K2FgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:36:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:23284 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1K2FgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:36:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,589,1315206000"; 
   d="scan'208";a="90053320"
Date: Tue, 29 Nov 2011 13:00:32 -0500
From: Youquan Song <youquan.song@intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        david.woodhouse@intel.com, allen.m.kay@intel.com, mtosatti@redhat.com,
        chrisw@redhat.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] thp: Add compound tail page _mapcount when mapped
Message-ID: <20111129180032.GA20622@linux-youquan.bj.intel.com>
References: <1322200030-26350-1-git-send-email-youquan.song@intel.com> <20111128161626.e4be400a.akpm@linux-foundation.org> <20111129001927.GO24062@one.firstfloor.org> <20111129005839.GE23466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129005839.GE23466@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Is the patch also applicable to 3.1.x?
> > 
> > I suspect it's broken since many kernels back, at least since THP 
> > was introduced, maybe earlier.
> 
> Correct. And the other patch in this series if applied without the
> above too, would make things worse for earlier releases (it'd trigger
> the lack of above at first invocation instead of from the second by
> having the _count start at 0 instead of 1, so it'd go negative at the
> first put_page). The correct thing is to have _count start at 0, but
> to increase it with the above during gup_fast (or to increase
> _mapcount since 3.2-rc and leave _count at 0 at all times on tail
> pages). Both patches should be ok for earlier releases too but I think
> it's just a false positive that goes away with DEBUG_VM=n or we should
> have noticed sooner (all production systems runs with DEBUG_VM=n of
> course). If there is no problem with DEBUG_VM=n like it seems from the
> source, I doubt it needs backporting. Also worst case a VM_BUG_ON
> hits, there's no risk of memory corruption because the refcounting on
> the head pages has always been correct, and that's all it matters
> as far as hugetlbfs is concerned.

I notice 70b50f94f1644e2aa7cb374819cfd93f3c28d725 "mm: thp: tail page
refcounting fix" is in kernel 3.1.1 stable, so this series patches can be also
applied to 3.1 stable. 

I expect the patch 70b50f94f1644e2aa7cb374819cfd93f3c28d725 also go to
3.0 stable, so this series patches also applied to 3.0 stable.
 
Thanks
-Youquan
