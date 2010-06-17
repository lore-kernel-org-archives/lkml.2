Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab0FQB4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:56:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34278 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab0FQBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 9/9] oom: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100616195447.GH5009@uudg.org>
References: <20100616153120.GH9278@barrios-desktop> <20100616195447.GH5009@uudg.org>
Message-Id: <20100617084943.FB45.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jun 17, 2010 at 12:31:20AM +0900, Minchan Kim wrote:
> | >         /*
> | >          * We give our sacrificial lamb high priority and access to
> | >          * all the memory it needs. That way it should be able to
> | >          * exit() and clear out its resources quickly...
> | >          */
> | >  	p->rt.time_slice = HZ;
> | >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> ...
> | > +	if (rt_task(p)) {
> | > +		p->rt.time_slice = HZ;
> | > +		return;
> 
> I am not sure the code above will have any real effect for an RT task.
> Kosaki-san, was this change motivated by test results or was it just a code
> cleanup? I ask that out of curiosity.

just cleanup.
ok, I remove this dubious code.

> 
> | I have a question from long time ago. 
> | If we change rt.time_slice _without_ setscheduler, is it effective?
> | I mean scheduler pick up the task faster than other normal task?
> 
> $ git log --pretty=oneline -Stime_slice mm/oom_kill.c
> 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2
> 
> This code ("time_slice = HZ;") is around for quite a while and
> probably comes from a time where having a big time slice was enough to be
> sure you would be the next on the line. I would say sched_setscheduler is
> indeed necessary.

ok


