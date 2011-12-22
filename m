Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab1LVPf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:35:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab1LVPf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:35:56 -0500
Date: Thu, 22 Dec 2011 16:30:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20111222153004.GA30522@redhat.com>
References: <20111221034334.GD17668@somewhere> <20111221130848.GA19679@redhat.com> <20111221175632.GF17668@somewhere> <20111221190102.GE13529@google.com> <20111221190817.GI17668@somewhere> <20111221192413.GF13529@google.com> <20111221200422.GJ17668@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221200422.GJ17668@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Frederic Weisbecker wrote:
>
> On Wed, Dec 21, 2011 at 11:24:13AM -0800, Mandeep Singh Baines wrote:
> >
> > If you call exec from a thread other than g, g is now unlinked. So
> > "t != g" will always be true. If you then pthread_create, you now
> > have two threads so "t != __prev" will also always be true. So
> > you now have an infinite loop.
>
> Oh you're right.
>
> But then we can't use t != t->group_leader because that assumes while_each_thread()
> started on the leader.

Yes, this can't work.

Besides, we need more burriers to rely on the ->group_leader check.

See http://marc.info/?t=127688987300002

in particular, http://marc.info/?l=linux-kernel&m=127714242731448
I think this should work, but then we should do something with the
users like zap_threads().

Oleg.

