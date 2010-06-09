Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0FIVGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab0FIVGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:06:13 -0400
Date: Wed, 9 Jun 2010 23:03:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: Make coredump interruptible
Message-ID: <20100609210358.GA16545@redhat.com>
References: <20100602185812.4B5894A549@magilla.sf.frob.com> <20100602203827.GA29244@redhat.com> <20100604194635.72D3.A69D9226@jp.fujitsu.com> <20100604112721.GA12582@redhat.com> <20100609195309.GA6899@redhat.com> <alpine.DEB.2.00.1006091341040.3490@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006091341040.3490@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09, David Rientjes wrote:
>
> On Wed, 9 Jun 2010, Oleg Nesterov wrote:
>
> > --- x/mm/oom_kill.c
> > +++ x/mm/oom_kill.c
> > @@ -414,6 +414,7 @@ static void __oom_kill_task(struct task_
> >  	p->rt.time_slice = HZ;
> >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> >
> > +	clear_bit(MMF_COREDUMP, &p->mm->flags);
> >  	force_sig(SIGKILL, p);
> >  }
> >
>
> This requires task_lock(p).

Yes, yes, sure. This is only template. I'll wait for the next mmotm
to send the actual patch on top of recent changes. Unless Kosaki/Roland
have other ideas.

Imho, we really need to fix the coredump/oom problem.

Oleg.

