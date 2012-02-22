Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2BVBEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:04:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62349 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2BVBEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:04:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.50.155.231 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Wed, 22 Feb 2012 02:04:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cgroup: Walk task list under tasklist_lock in
 cgroup_enable_task_cg_list
Message-ID: <20120222010431.GD13403@somewhere.redhat.com>
References: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
 <1328668647-24125-3-git-send-email-fweisbec@gmail.com>
 <20120221222343.GU3090@google.com>
 <20120222005525.GC13403@somewhere.redhat.com>
 <20120222010015.GH12236@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222010015.GH12236@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 05:00:15PM -0800, Tejun Heo wrote:
> On Wed, Feb 22, 2012 at 01:55:28AM +0100, Frederic Weisbecker wrote:
> > > > +	 * We need tasklist_lock because RCU is not safe against
> > > > +	 * while_each_thread(). Besides, a forking task that has passed
> > > > +	 * cgroup_post_fork() without seeing use_task_css_set_links = 1
> > > > +	 * is not guaranteed to have its child immediately visible in the
> > > > +	 * tasklist if we walk through it with RCU.
> > > > +	 */
> > > 
> > > Maybe add TODO to remove the lock once do_each_thread()/while_each_thread()
> > > is made rcu safe. On a large system, it could take a while to iterate
> > > over every thread in the system. Thats a long time to hold a spinlock.
> > > But it only happens once so probably not that big a deal.
> > 
> > I think that even if while_each_thread() was RCU safe, that wouldn't
> > work here.
> 
> Guys, this is one time thing.  It happens *once* after boot and we're
> already holding exclusive lock.  There's no reason to optimize this at
> all.  Let's just keep it simple.

For now I agree. But one day the real time guys might eye that thing.
