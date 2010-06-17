Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789Ab0FQB4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:56:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39228 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab0FQBvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 9/9] oom: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100616153120.GH9278@barrios-desktop>
References: <20100616203517.72EF.A69D9226@jp.fujitsu.com> <20100616153120.GH9278@barrios-desktop>
Message-Id: <20100617084811.FB42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	struct sched_param param = { .sched_priority = 1 };
> > +
> > +	if (mem)
> > +		return;
> > +
> > +	if (rt_task(p)) {
> > +		p->rt.time_slice = HZ;
> > +		return;
> 
> I have a question from long time ago. 
> If we change rt.time_slice _without_ setscheduler, is it effective?
> I mean scheduler pick up the task faster than other normal task?

if p is SCHED_OTHER, no effective. if my understand is correct, that's
only meaningfull if p is SCHED_RR.  that's the reason why I moved this
check into "if (rt_task())".

but honestly I haven't observed this works effectively. so, I agree
this can be removed as Luis mentioned.



