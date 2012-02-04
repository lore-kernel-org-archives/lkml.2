Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab2BDWbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 17:31:01 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29303 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2BDWbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 17:31:00 -0500
Date: Sat, 4 Feb 2012 23:31:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Arjan van de Ven <arjan@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][Trivial] Fix up version number reference in
 include/trace/events/power.h
In-Reply-To: <1328368512.5882.215.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LNX.2.00.1202042330210.30244@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net>  <1326661784.7642.140.camel@gandalf.stny.rr.com>  <alpine.LNX.2.00.1201152210300.13389@swampdragon.chaosbits.net>  <alpine.LNX.2.00.1202032241380.25026@pobox.suse.cz> 
 <4F2C56D9.8010801@linux.intel.com> <1328368512.5882.215.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Feb 2012, Steven Rostedt wrote:

> On Fri, 2012-02-03 at 13:51 -0800, Arjan van de Ven wrote:
> > On 2/3/2012 1:42 PM, Jiri Kosina wrote:
> > > On Sun, 15 Jan 2012, Jesper Juhl wrote:
> > > 
> > >>>> -/* This code will be removed after deprecation time exceeded (2.6.41) */
> > >>>> +/* This code will be removed after deprecation time exceeded (3.1) */
> > >>>
> > >>> Shouldn't the real fix be to remove this code? What's the use of
> > >>> changing the version number that this code will be removed from, when
> > >>> the change won't get in until after the version that this code should
> > >>> have been removed?
> > >>>
> > >>> This is like updating 2014 calendars to say the world will end in 2012.
> > >>>
> > >> Heh, yeah, in a way you are right. But we have lots of code in the kernel 
> > >> that says it will be removed at <some date in the past>, so I just figured 
> > >> that if this code ends up hanging around it should at least display the 
> > >> correct version number for when it /should/ have been removed.
> > >> The actual removal I'll leave up to others.
> > > 
> > > Funny thing. Okay, this doesn't seem to be in linux-next, so I am taking 
> > > it.
> > > 
> > > Steven, planning to drop the code in a near future? :)
> > 
> > we shouldn't be dropping these yet.. tools are still using them.
> > and there really is no cost to keeping them either.
> 
> Then the correct fix is to remove the comment, as it is incorrect.

From: Jesper Juhl <jj@chaosbits.net>
Date: Sat, 4 Feb 2012 23:29:19 +0100
Subject: [PATCH] Remove incorrect comment from include/trace/events/power.h

The code is not going to be removed, so remove the comment stating
that it will be.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 include/trace/events/power.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 1bcc2a8..5800eb8 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -65,7 +65,6 @@ TRACE_EVENT(machine_suspend,
 	TP_printk("state=%lu", (unsigned long)__entry->state)
 );
 
-/* This code will be removed after deprecation time exceeded (2.6.41) */
 #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
 
 /*
-- 
1.7.9



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

