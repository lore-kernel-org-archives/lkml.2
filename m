Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1CFLUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 06:20:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54823 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1CFLUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 06:20:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH rh6] mm: skip zombie in OOM-killer
Cc: kosaki.motohiro@jp.fujitsu.com, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1103041541040.7795@chino.kir.corp.google.com>
References: <1299274256-2122-1-git-send-email-avagin@openvz.org> <alpine.DEB.2.00.1103041541040.7795@chino.kir.corp.google.com>
Message-Id: <20110306201947.6CCC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  6 Mar 2011 20:20:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 5 Mar 2011, Andrey Vagin wrote:
> 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 7dcca55..2fc554e 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -311,7 +311,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
> >  		 * blocked waiting for another task which itself is waiting
> >  		 * for memory. Is there a better alternative?
> >  		 */
> > -		if (test_tsk_thread_flag(p, TIF_MEMDIE))
> > +		if (test_tsk_thread_flag(p, TIF_MEMDIE) && p->mm)
> >  			return ERR_PTR(-1UL);
> >  
> >  		/*
> 
> I think it would be better to just do
> 
> 	if (!p->mm)
> 		continue;
> 
> after the check for oom_unkillable_task() because everything that follows 
> this really depends on p->mm being non-NULL to actually do anything 
> useful.

I'm glad you join to review MM patches. It is worth effort for making
solid kernel. But, please look at a current code at first.


