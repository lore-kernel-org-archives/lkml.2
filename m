Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2CTKTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:19:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2CTKTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:19:08 -0400
Message-ID: <4F685960.4080904@redhat.com>
Date: Tue, 20 Mar 2012 12:18:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 00/26] sched/numa
References: <20120316144028.036474157@chello.nl>    <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>   <4F671B90.3010209@redhat.com> <1332158992.18960.316.camel@twins>  <4F672384.1030601@redhat.com> <1332187387.18960.389.camel@twins>
In-Reply-To: <1332187387.18960.389.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 10:03 PM, Peter Zijlstra wrote:
> On Mon, 2012-03-19 at 14:16 +0200, Avi Kivity wrote:
> > > Afaik we do not use dma engines for memory migration. 
> > 
> > We don't, but I think we should. 
>
> ISTR we (the community) had this discussion once. I also seem to
> remember the general consensus being that DMA engines would mostly
> likely not be worth the effort, although I can't really recall the
> specifics.
>
> Esp. for 4k pages the setup of the offload will likely be more expensive
> than actually doing the memcpy.

If you're copying a page, yes.  If you're copying a large vma, the
per-page setup cost is likely to be very low.

Especially if you're copying across nodes.

-- 
error compiling committee.c: too many arguments to function

