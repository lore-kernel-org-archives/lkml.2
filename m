Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2HWImv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:42:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43206 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2HWImo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:42:44 -0400
Date: Thu, 23 Aug 2012 10:42:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/36] AutoNUMA24
Message-ID: <20120823084238.GB8742@gmail.com>
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
 <5035325C.3070909@redhat.com>
 <20120822214048.GA3092@gmail.com>
 <20120822221931.GE8107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822221931.GE8107@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Aug 22, 2012 at 11:40:48PM +0200, Ingo Molnar wrote:
> > 
> > * Rik van Riel <riel@redhat.com> wrote:
> > 
> > > On 08/22/2012 10:58 AM, Andrea Arcangeli wrote:
> > > >Hello everyone,
> > > >
> > > >Before the Kernel Summit, I think it's good idea to post a new
> > > >AutoNUMA24 and to go through a new review cycle. The last review cycle
> > > >has been fundamental in improving the patchset. Thanks!
> > > 
> > > Thanks for improving the code and incorporating all our 
> > > feedback. The AutoNUMA codebase is now in a state where I can 
> > > live with it.
> > > 
> > > I hope the code will be acceptable to others, too.
> > 
> > Lots of scheduler changes. Has all of peterz's review feedback 
> > been addressed?
> 
> git diff --stat origin kernel/sched/
>  kernel/sched/Makefile |    1 +
>  kernel/sched/core.c   |    1 +
>  kernel/sched/fair.c   |   86 ++++++-
>  kernel/sched/numa.c   |  604 +++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/sched.h  |   19 ++
>  5 files changed, 699 insertions(+), 12 deletions(-)
> 
> Lots of scheduler changes only if CONFIG_AUTONUMA=y.

That's a lot of scheduler changes.

> [...] If CONFIG_AUTONUMA=n it's just 107 lines of scheduler 
> changes (numa.c won't get built in that case).
> 
> > Hm, he isn't even Cc:-ed, how is that supposed to work?
> 
> I separately forwarded him the announcement email because I 
> wanted to add a few more (minor) details for him. Of course 
> Peter's review is fundamental and appreciated and already 
> helped to make the code a lot better.

I see no reason why such details shouldn't be discussed openly 
and why forwarding him things separately should cause you to 
drop a scheduler co-maintainer from the Cc:, with a 700 lines 
kernel/sched/ diffstat ...

> His previous comments should have been addressed, [...]

That's good news. Peter?

Thanks,

	Ingo
