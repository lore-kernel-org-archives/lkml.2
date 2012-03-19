Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030975Ab2CSOfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:35:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab2CSOfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:35:16 -0400
Date: Mon, 19 Mar 2012 15:34:42 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 00/26] sched/numa
Message-ID: <20120319143442.GR24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
 <4F670325.7080700@redhat.com>
 <1332155527.18960.292.camel@twins>
 <20120319130401.GI24602@redhat.com>
 <1332163591.18960.334.camel@twins>
 <20120319135745.GL24602@redhat.com>
 <1332166079.18960.342.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332166079.18960.342.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:07:59PM +0100, Peter Zijlstra wrote:
> And no, I really don't think giving up 0.5% of RAM is acceptable.

Fine it's up to you :).

Also note 16 bytes of those 24 bytes, you need to spend them too if
you remotely hope to perform as good as AutoNUMA (I can already tell
you...), they've absolutely nothing to do with the background scanning
that AutoNUMA does to avoid modifying the apps.

The blame on autonuma you can give is 8 bytes per page only, so 0.07%,
which I can probably reduce 0.03% if I screw the natural alignment of
the list pointers and MAX_NUMNODES is < 32768 at build time, not sure
if it's worth it.
