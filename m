Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0H0Jgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:36:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46485 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0H0Jgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:36:39 -0400
Date: Fri, 27 Aug 2010 15:01:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv11 2.6.36-rc2-tip 10/15] 10: tracing: config option to
 enable both kprobe-tracer and uprobe-tracer.
Message-ID: <20100827093135.GI14431@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134315.5447.96501.sendpatchset@localhost6.localdomain6>
 <4C76038A.40400@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C76038A.40400@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Why are lots of end-of-line 's' character missing? :)
> 

Okay will correct them.

<snipped>

> >  
> >  config PROBE_EVENTS
> > -	def_bool n
> > +	bool "Enable kprobes and uprobe based dynamic events"
> > +	select TRACING
> > +	default n
> 
> Hmm, without this series, KPROBE_EVENT is set "y" by default.
> (PROBE_EVENTS is introduced by 8/15)
> I'd like to set this "y" by default, because it doesn't
> affect other parts.
> 
> Thank you,
> 

This is based on what we discussed here
http://lkml.org/lkml/2010/8/2/86.

To recollect, 
Frederic wanted that there should be one option to select both
UPROBE_EVENT and KPROBE_EVENT. 

However if we make PROBE_EVENTS (which is the option to enable both
events) default "Y", then both UPROBE_EVENT and KPROBE_EVENT will be
selected.

Also if we look at http://lkml.org/lkml/2010/6/21/160, Steven
Rostedt didnt want UPROBE_EVENT to selected by default.

I agree that we should keep UPROBE_EVENT to be 'default n' till it gets
tested. Hence we have two choices. Either set the common knob to be
'default n' or dont have the common knob for now (i.e drop this
patch for now).

I think we should go with the first one, i.e have a common knob thats
by default unselected.

-- 
Thanks and Regards
Sriakr
