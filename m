Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1EXOXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:23:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26846 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1EXOXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:23:51 -0400
Date: Tue, 24 May 2011 16:16:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Hillf Danton <dhillf@gmail.com>
cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] sched: remove noop in next_prio()
In-Reply-To: <BANLkTimq31hMRa+vD=pLrtTAx=Hv=h0Acg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105241615080.7986@swampdragon.chaosbits.net>
References: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com> <BANLkTikhvhptDG-eRZ9uD5wSm3RxTn1RFw@mail.gmail.com> <1306238014.16375.0.camel@marge.simson.net> <BANLkTimq31hMRa+vD=pLrtTAx=Hv=h0Acg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Hillf Danton wrote:

> On Tue, May 24, 2011 at 7:53 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Tue, 2011-05-24 at 16:17 +0800, Yong Zhang wrote:
> >> On Sat, May 21, 2011 at 10:19 PM, Hillf Danton <dhillf@gmail.com> wrote:
> >> > When computing the next priority for a given run-queue, the check for
> >> > RT priority of the task determined by the pick_next_highest_task_rt()
> >> > function could be removed, since only RT task is returned by the
> >> > function.
> >> >
> >> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> >>
> >> Yup, it's true.
> >
> > (could whack the else while there)
> >
> 
> Where is it, Mike?
> 


-       if (next && rt_prio(next->prio))
+       if (next)
               return next->prio;
-       else
-              return MAX_RT_PRIO;
+       return MAX_RT_PRIO;



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

