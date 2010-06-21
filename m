Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab0FUPrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:47:16 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:52227 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755853Ab0FUPrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:47:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGMlH0xGGOJc/2dsb2JhbACfA3LDToUbBA
Date: Mon, 21 Jun 2010 11:47:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] tracing: Fix undelared ENOSYS in
	include/linux/tracepoint.h
Message-ID: <20100621154712.GB6965@Krystal>
References: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com> <1277130520.9181.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1277130520.9181.12.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:45:40 up 75 days,  1:39,  2 users,  load average: 0.13, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Mon, 2010-06-21 at 19:09 +0800, Wu Zhangjin wrote:
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > The header file include/linux/tracepoint.h may be included without
> > include/linux/errno.h and then the compiler will fail on building for
> > undelcared ENOSYS. This patch fixes this problem via including <linux/errno.h>
> > to include/linux/tracepoint.h.
> > 
> 
> Hi Wu,
> 
> I have not hit this. Did you hit this with mips? Does it need to get
> into 2.6.35 or can it wait till 2.6.36?

errno.h is included by sched.h, which is included almost everywhere. No
wonder it took that much time for someone to hit the problem. But given
it's a simple bug fix, it should fit into the "for-2.6.35" definition,
although I am no expert in these definitions. ;-)

Thanks,

Mathieu

> 
> -- Steve
> 
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > ---
> >  include/linux/tracepoint.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 9a59d1f..103d1b6 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -14,6 +14,7 @@
> >   * See the file COPYING for more details.
> >   */
> >  
> > +#include <linux/errno.h>
> >  #include <linux/types.h>
> >  #include <linux/rcupdate.h>
> >  
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
