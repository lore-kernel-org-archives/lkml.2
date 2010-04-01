Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab0DAS6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:58:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8875 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0DAS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:58:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=igSjqgv+5vSOGssvtbG5Iuhte5/w4kmmEeol9xncoMIiskunhqhdqUTlrjlHdwkU2
	PGZz7HxY9RpENaX5Qp1jg==
Date: Thu, 1 Apr 2010 11:58:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: give current access to memory reserves if it has
 been killed
In-Reply-To: <20100401143910.GB14603@redhat.com>
Message-ID: <alpine.DEB.2.00.1004011156040.30661@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com>
 <20100331175836.GA11635@redhat.com> <alpine.DEB.2.00.1003311342410.25284@chino.kir.corp.google.com> <20100331224904.GA4025@redhat.com> <20100331233058.GA6081@redhat.com> <alpine.DEB.2.00.1003311641470.2150@chino.kir.corp.google.com>
 <20100401143910.GB14603@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Oleg Nesterov wrote:

> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -459,7 +459,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  	 * its children or threads, just set TIF_MEMDIE so it can die quickly
> >  	 */
> >  	if (p->flags & PF_EXITING) {
> > -		__oom_kill_task(p);
> > +		set_tsk_thread_flag(p, TIF_MEMDIE);
> 
> So, probably this makes sense anyway but not strictly necessary, up to you.
> 

It matches the already-existing comment that only says we need to set 
TIF_MEMDIE so it can quickly exit rather than call __oom_kill_task(), so 
it seems worthwhile.

> >  	if (fatal_signal_pending(current)) {
> > -		__oom_kill_task(current);
> > +		set_tsk_thread_flag(current, TIF_MEMDIE);
> 
> Yes, I think this fix is needed.
> 

Ok, I'll add your acked-by and send this to Andrew with a follow-up that 
consolidates __oom_kill_task() into oom_kill_task(), thanks.
