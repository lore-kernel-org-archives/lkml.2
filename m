Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1A0OSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:18:42 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:38101 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1A0OSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:18:41 -0500
Date: Thu, 27 Jan 2011 15:18:37 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/7] memcg : fix charge function of THP allocation.
Message-ID: <20110127141837.GB14512@cmpxchg.org>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
 <20110121154430.70d45f15.kamezawa.hiroyu@jp.fujitsu.com>
 <20110127103438.GC2401@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127103438.GC2401@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 11:34:38AM +0100, Johannes Weiner wrote:
> On Fri, Jan 21, 2011 at 03:44:30PM +0900, KAMEZAWA Hiroyuki wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > When THP is used, Hugepage size charge can happen. It's not handled
> > correctly in mem_cgroup_do_charge(). For example, THP can fallback
> > to small page allocation when HUGEPAGE allocation seems difficult
> > or busy, but memory cgroup doesn't understand it and continue to
> > try HUGEPAGE charging. And the worst thing is memory cgroup
> > believes 'memory reclaim succeeded' if limit - usage > PAGE_SIZE.
> > 
> > By this, khugepaged etc...can goes into inifinite reclaim loop
> > if tasks in memcg are busy.
> > 
> > After this patch 
> >  - Hugepage allocation will fail if 1st trial of page reclaim fails.
> >  - distinguish THP allocaton from Bached allocation. 
> 
> This does too many things at once.  Can you split this into more
> patches where each one has a single objective?  Thanks.

So I sent three patches that, I think, fix the same issues this patch
fixes, only they are much simpler.

The more I look at this code, though, the less confident I am in it..
Can you guys give it a good look?

Thanks,
	Hannes
