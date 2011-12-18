Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1LRGqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 01:46:14 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50285 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1LRGqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 01:46:12 -0500
Date: Sun, 18 Dec 2011 12:11:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: strange commit in the uprobes tree
Message-ID: <20111218064146.GN8575@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111217182811.ead5e91706f5198f7d7f5560@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111217182811.ead5e91706f5198f7d7f5560@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11121806-5806-0000-0000-0000109F450A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [2011-12-17 18:28:11]:

> Hi Srikar,
> 
> I just fetched the uprobes tree and noticed that commit 05f7cebbdbc8
> ("rcu: Introduce bulk reference count") has no patch, just a commit
> message.   In the previous version of your tree, the commit had Paul as
> author and now has you (which is what brought it to my attention), but
> the lack of patch is more interesting ... I do notice that there is
> another patch from Paul ("rcu: Introduce raw SRCU read-side primitives")
> and was wondering if that replaces the above patch.
> 

Thanks Stephen for reporting this.  yes, the patch from Paul replaces
the empty commit that you see.  After I cherry-picked the 3 commits from
the -tip tree, I had pushed my existing patches that had older Paul's
bulkref patch (removed the changes as part of merge; thats why it shows
my name in author for the faulty commit;) I should have removed the
commit. 

Sorry for the inconvienience.

git log --oneline -n 16 output  as reported by you.
-----------------------------
6a80f33 perf: perf interface for uprobes
6bb498e perf: rename target_module to target
73cf3b4 tracing: uprobes trace_event interface
b0c3265 tracing: Extract out common code for kprobes/uprobes traceevents.
bdc41f9 tracing: modify is_delete, is_return from ints to bool.
10b7939 uprobes: counter to optimize probe hits.
e7ff3d7 uprobes: slot allocation.
6866510 uprobes: handle breakpoint and signal step exception.
8f5ef11 uprobes: Install and remove breakpoints.
05f7ceb rcu: Introduce bulk reference count
	^^^^ faulty commit.
18fe9f4 x86: Call do_notify_resume() with interrupts enabled
557824a x86: Clean up and extend do_int3()
e73ddde rcu: Introduce raw SRCU read-side primitives
	^^^^ 3 commits cherry-picked from -tip including the
	superseeding patch from Paul.
dc47ce9 Linux 3.2-rc5
8def5f5 Merge git://git.samba.org/sfrench/cifs-2.6
a776878 Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip


new git log --oneline -n 16 output after making the correction
--------------------------------------------------------------
1b46788 perf: perf interface for uprobes
9b6b4a2 perf: rename target_module to target
ceeb93e tracing: uprobes trace_event interface
fa05b8b tracing: Extract out common code for kprobes/uprobes traceevents.
1a355a5 tracing: modify is_delete, is_return from ints to bool.
3f563d4 uprobes: counter to optimize probe hits.
59c919d uprobes: slot allocation.
599b83b uprobes: handle breakpoint and signal step exception.
70b8389 uprobes: Install and remove breakpoints.
18fe9f4 x86: Call do_notify_resume() with interrupts enabled
557824a x86: Clean up and extend do_int3()
e73ddde rcu: Introduce raw SRCU read-side primitives
dc47ce9 Linux 3.2-rc5
8def5f5 Merge git://git.samba.org/sfrench/cifs-2.6
a776878 Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
e2f4e0b Merge branch 'spi/for-3.2' of git://git.pengutronix.de/git/wsa/linux-2.6


I have pushed in the change to for-next branch.

-- 
Thanks and Regards
Srikar

