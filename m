Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0DBTqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:46:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0DBTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:46:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=AomRUIuslKcs4y80eXaaCYGKHqFbPUAri3CvJsr321rjW/sreNsy3xw4xPrGOyfGM
	084QvxyV5U3xPFeuNhfbQ==
Date: Fri, 2 Apr 2010 12:46:32 -0700 (PDT)
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
In-Reply-To: <20100402191414.GA982@redhat.com>
Message-ID: <alpine.DEB.2.00.1004021244010.15445@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com>
 <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com> <20100401135927.GA12460@redhat.com> <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com> <20100402111406.GA4432@redhat.com> <alpine.DEB.2.00.1004021159310.1773@chino.kir.corp.google.com>
 <20100402191414.GA982@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010, Oleg Nesterov wrote:

> > > David, you continue to ignore my arguments ;) select_bad_process()
> > > must not filter out the tasks with ->mm == NULL.
> > >
> > I'm not ignoring your arguments, I think you're ignoring what I'm
> > responding to.
> 
> Ah, sorry, I misunderstood your replies.
> 
> > I prefer to keep oom_badness() to be a positive range as
> > it always has been (and /proc/pid/oom_score has always used an unsigned
> > qualifier),
> 
> Yes, I thought about /proc/pid/oom_score, but imho this is minor issue.
> We can s/%lu/%ld/ though, or just report 0 if oom_badness() returns -1.
> Or something.
> 

Just have it return 0, meaning never kill, and then ensure "chosen" is 
never set for an oom_badness() of 0, even if we don't have another task to 
kill.  That's how Documentation/filesystems/proc.txt describes it anyway.
