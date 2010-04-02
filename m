Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0DBTRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab0DBTQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:16:57 -0400
Date: Fri, 2 Apr 2010 21:14:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: give current access to memory reserves if it has
	been killed
Message-ID: <20100402191414.GA982@redhat.com>
References: <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com> <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com> <20100401135927.GA12460@redhat.com> <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com> <20100402111406.GA4432@redhat.com> <alpine.DEB.2.00.1004021159310.1773@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1004021159310.1773@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, David Rientjes wrote:
>
> On Fri, 2 Apr 2010, Oleg Nesterov wrote:
>
> > David, you continue to ignore my arguments ;) select_bad_process()
> > must not filter out the tasks with ->mm == NULL.
> >
> I'm not ignoring your arguments, I think you're ignoring what I'm
> responding to.

Ah, sorry, I misunderstood your replies.

> I prefer to keep oom_badness() to be a positive range as
> it always has been (and /proc/pid/oom_score has always used an unsigned
> qualifier),

Yes, I thought about /proc/pid/oom_score, but imho this is minor issue.
We can s/%lu/%ld/ though, or just report 0 if oom_badness() returns -1.
Or something.

> so I disagree that we need to change oom_badness() to return
> anything other than 0 for such tasks.  We need to filter them explicitly
> in select_bad_process() instead, so please do this there.

The problem is, we need task_lock() to pin ->mm. Or, we can change
find_lock_task_mm() to do get_task_mm() and return mm_struct *.

But then oom_badness() (and proc_oom_score!) needs much more changes,
it needs the new "struct mm_struct *mm" argument which is not necessarily
equal to p->mm.

So, I can't agree.

Oleg.

