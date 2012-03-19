Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032593Ab2CSTDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032496Ab2CSTDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:03:15 -0400
Date: Mon, 19 Mar 2012 20:02:34 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] AutoNUMA alpha6
Message-ID: <20120319190234.GH24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
 <20120316182511.GJ24602@redhat.com>
 <1332182842.18960.376.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332182842.18960.376.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 07:47:22PM +0100, Peter Zijlstra wrote:
> On Fri, 2012-03-16 at 19:25 +0100, Andrea Arcangeli wrote:
> > http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=patch;h=30ed50adf6cfe85f7feb12c4279359ec52f5f2cd;hp=c03cf0621ed5941f7a9c1e0a343d4df30dbfb7a1
> > 
> > It's a big monlithic patch, but I'll split it.
> 
> I applied this big patch to a fairly recent tree from Linus but it
> failed to boot. It got stuck somewhere in SMP bringup.
> 
> I waited for several seconds but pressed the remote power switch when
> nothing more came out..
> 
> The last bit out of my serial console looked like:

btw, the dump_stack in your trace are very superflous and I should
remove them... They were meant to debug a problem in numa emulation
that I fixed some time ago and sent to Andrew just a few days ago.

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commit;h=c03cf0621ed5941f7a9c1e0a343d4df30dbfb7a1

You may want to try to checkout a full git tree to be sure it's not a
collision with something else, at that point of the boot stage
autonuma shouldn't run at all so it's unlikely related.

Hillf just sent me a fix for large systems which I already committed,
maybe that's your problem?

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=shortlog;h=refs/heads/autonuma

I also added checks for cpu_online that are probably needed but those
aren't visible yet but you don't need them to boot...

If you want to extract the patch and all other patches to apply it
hand, the simplest is to:

git clone --reference linux -b autonuma git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git
git diff origin/master origin/autonuma > x

Or "git format-patch origin/master..origin/autonuma"
