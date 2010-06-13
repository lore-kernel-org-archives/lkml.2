Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0FMLZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:25:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48168 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0FMLYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:24:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] oom: Make coredump interruptible
Cc: kosaki.motohiro@jp.fujitsu.com, Roland McGrath <roland@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100609195309.GA6899@redhat.com>
References: <20100604112721.GA12582@redhat.com> <20100609195309.GA6899@redhat.com>
Message-Id: <20100613175547.616F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 13 Jun 2010 20:24:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay.

> On 06/04, Oleg Nesterov wrote:
> >
> > On 06/04, KOSAKI Motohiro wrote:
> > >
> > > In multi threaded OOM case, we have two problematic routine, coredump
> > > and vmscan. Roland's idea can only solve the former.
> > >
> > > But I also interest vmscan quickly exit if OOM received.
> >
> > Yes, agreed. See another email from me, MMF_ flags looks "obviously
> > useful" to me.
> 
> Well. But somehow we forgot about the !coredumping case... Suppose
> that select_bad_process() chooses the process P to kill and we have
> other processes (not sub-threads) which share the same ->mm.

Ah, yes. I think you are correct.


> In that case I am not sure we should blindly set MMF_OOMKILL. Suppose
> that we kill P and after that the "out-of-memory" condition goes away.
> But its ->mm still has MMF_OOMKILL set, and it is used. Who/when will
> clear this flag?
> 
> Perhaps something like below makes sense for now.

Probably, this works. at least I don't find any problems.
But umm... Do you mean we can't implement per-process oom flags?

example,
	1) back to implement signal->oom_victim
	   because We are using SIGKILL for OOM and struct signal
	   naturally represent signal target.
	2) mm->nr_oom_killed_task
	   just avoid simple flag. instead counting number of tasks of
	   oom-killed.

I think both avoid your explained problem. Am I missing something?

But, again, I have no objection to your patch. because I really hope to
fix coredump vs oom issue.



