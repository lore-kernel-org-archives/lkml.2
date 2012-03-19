Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031031Ab2CSMZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab2CSMZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:25:31 -0400
Message-ID: <4F67257F.4030803@redhat.com>
Date: Mon, 19 Mar 2012 14:24:31 +0200
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
References: <20120316144028.036474157@chello.nl>   <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>  <4F671B90.3010209@redhat.com> <1332159657.18960.321.camel@twins>
In-Reply-To: <1332159657.18960.321.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 02:20 PM, Peter Zijlstra wrote:
> On Mon, 2012-03-19 at 13:42 +0200, Avi Kivity wrote:
> > It's the standard space/time tradeoff.  Once solution wants more
> > storage, the other wants more faults.
> > 
> > Note scanners can use A/D bits which are cheaper than faults.
>
> I'm not convinced.. the scanner will still consume time even if the
> system is perfectly balanced -- it has to in order to determine this.
>
> So sure, A/D/other page table magic can make scanners faster than faults
> however you only need faults when you're actually going to migrate a
> task. Whereas you always need to scan, even in the stable state.
>
> So while the per-instance times might be in favour of scanning, I'm
> thinking the accumulated time is in favour of faults.

When you migrate a vnode, you don't need the faults at all.  You know
exactly which pages need to be migrated, you can just queue them
immediately when you make that decision.

The scanning therefore only needs to pick up the stragglers and can be
set to a very low frequency.

-- 
error compiling committee.c: too many arguments to function

