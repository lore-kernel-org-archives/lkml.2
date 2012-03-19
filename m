Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045Ab2CSMVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:21:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59481 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819Ab2CSMVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:21:15 -0400
Message-ID: <1332159657.18960.321.camel@twins>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Date: Mon, 19 Mar 2012 13:20:57 +0100
In-Reply-To: <4F671B90.3010209@redhat.com>
References: <20120316144028.036474157@chello.nl>
	  <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>
	 <4F671B90.3010209@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 13:42 +0200, Avi Kivity wrote:
> It's the standard space/time tradeoff.  Once solution wants more
> storage, the other wants more faults.
> 
> Note scanners can use A/D bits which are cheaper than faults.

I'm not convinced.. the scanner will still consume time even if the
system is perfectly balanced -- it has to in order to determine this.

So sure, A/D/other page table magic can make scanners faster than faults
however you only need faults when you're actually going to migrate a
task. Whereas you always need to scan, even in the stable state.

So while the per-instance times might be in favour of scanning, I'm
thinking the accumulated time is in favour of faults.
