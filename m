Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0FHRgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:36:24 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54810 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0FHRgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:36:23 -0400
Date: Tue, 8 Jun 2010 23:05:59 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
Message-ID: <20100608173559.GE2800@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
 <1276012661.2046.120.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1276012661.2046.120.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2010-06-08 at 11:33 -0400, Steven Rostedt wrote:
> > I'm pushing this as an RFC first. This probably should be something that
> > makes it into 2.6.35.
> > 
> > Acks and perhaps a little testing from the perf and kprobe angle?
> 
> I'll have a look soon, but lets add Srikar to CC, he actually reported
> the problem :-)
> 
> > Steven Rostedt (1):
> >       tracing: Use class->reg() for all registering of evints
> > 

I tested the patch and it fixed the regression where
perf record -e probe:do_fork -aR sleep 1 would fail. 

Now with this patch, it records the events. However perf record
encounters a floating point exception .. (Peter said he was aware and had a
fix for the floating point exception problem)


However I still see another minor regression (atleast on the tip tree)
This regression was present even before this patch.
The first time I run a perf probe command, it fails, subsequent runs
pass. 

i.e 

411 [srikar@llm69 ]$  sudo perf probe do_fork 
kprobe_events file does not exist - please rebuild kernel with CONFIG_KPROBE_EVENT.
  Error: Failed to add events. (-1)
411 [srikar@llm69 ]$  sudo perf probe do_fork 
Add new event:
  probe:do_fork        (on do_fork)

You can now use it on all perf tools, such as:

        perf record -e probe:do_fork -aR sleep 1

411 [srikar@llm69 ]$ 


--
Thanks and Regards
Srikar
