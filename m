Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1LUSW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:22:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1LUSWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:22:24 -0500
Date: Wed, 21 Dec 2011 19:11:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20111221181101.GA3092@redhat.com>
References: <20111221034334.GD17668@somewhere> <20111221130848.GA19679@redhat.com> <20111221175943.GG17668@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221175943.GG17668@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Frederic Weisbecker wrote:
>
> On Wed, Dec 21, 2011 at 02:08:48PM +0100, Oleg Nesterov wrote:
> > On 12/21, Frederic Weisbecker wrote:
> > > - By the time we call cgroup_post_fork(), it is ready to be woken up
> > > and usable by the scheduler.
> >
> > No, the new child can't run until do_fork()->wake_up_new_task().
>
> Out of curiosity, why is it not possible for a task to kill and wake up the child
> before that happens?

Because it is not possible to wake it up.

Please note that copy_process() creates the "deactivated" child, iow
it is not on rq.

But, at the same time its ->state == TASK_RUNNING. This "fools"
try_to_wake_up() or anything else which in theory could place it
on the runqueue.

Except, of course, wake_up_new_task() does activate_task(). And
note that it does this unconditionally, exactly because we know that
this task can't be woken.

Oleg.

