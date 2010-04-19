Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0DSXEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 19:04:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63898 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0DSXEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 19:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lxw0hzth9c3HkmTmsBFZSrG3I+fUH2UJ8OmCcCu2dVD9Clt/YuIMmU01+ayMXiMq8s
         YUDOwMV6+O+swZ4zO/awmKeI7RKoCMrgM1QXnEo0/+Gv/vkMAfbrSMftflZghfvNPjZd
         oYnOrcA5nSWkXlO+8cdJp2p0j3/iZ0ZwatkFo=
Date: Tue, 20 Apr 2010 01:04:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: request to add trace off and trace on with events
Message-ID: <20100419230438.GA11493@nowhere>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com> <4BCCBF6D.3030105@am.sony.com> <1271709846.10448.29.camel@gandalf.stny.rr.com> <20100419212950.GB8811@nowhere> <1271713074.10448.101.camel@gandalf.stny.rr.com> <20100419220437.GC8811@nowhere> <1271715227.10448.145.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271715227.10448.145.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 06:13:47PM -0400, Steven Rostedt wrote:
> On Tue, 2010-04-20 at 00:04 +0200, Frederic Weisbecker wrote:
> > On Mon, Apr 19, 2010 at 05:37:54PM -0400, Steven Rostedt wrote:
> 
> > > # cat event/sched/sched_switch/triggers/tracing_off
> > > disabled
> > > 
> > > Or it can be a filter, or enabled.
> > 
> > 
> > Yep, since it would share exatly the same code than filter (as
> > filter basically becomes a trigger command), it can behave the
> > same: displaying "none" when there is no filter, or a filter.
> > 
> 
> Then do we make the triggers themselves directories too?
> 
> # ls event/sched/sched_switch/triggers/tracing_off
> filter   enable
> 
> ?


That would be perhaps an overkill.
Having a filter inside means it's on, otherwise it's off.



> 
> > 
> > > 
> > > This could also allow a user to do:
> > > 
> > > echo "(a > 100)" > tracing_on
> > > echo "(a < 100)" > tracing_off
> > 
> > 
> > Yeah :)
> > But if the scope of the "tracing off" is only for this event, then
> > rather use:
> > 
> > echo "(a < 100)" > filter
> > 
> > You could have tracing_off/on that have this event scope and
> > tracing_off/on_all for a global tracing scope.
> 
> The two are not equivalent. In fact, just enabling a trigger does not
> mean that the event itself will be traced.


Yeah, the enable file would first need to be activated before any
trigger to take effect on the event, just like filters.

In fact I was thinking of tracing_on/tracing_off as kinds of
local pause/resume.

And tracing_on_global/tracing_off_global would act like what does
/debug/tracing/tracing_on: something that disables every tracing.

But of course, before any of these conditional triggers to be
evaluated, you need to enable the corresponding event.

