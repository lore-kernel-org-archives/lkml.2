Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab0DOVr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:47:58 -0400
Received: from mailsrvr2.bull.com ([192.90.162.8]:49722 "EHLO
	mailsrvr2.bull.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab0DOVr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:47:57 -0400
X-Greylist: delayed 1877 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2010 17:47:48 EDT
In-Reply-To: <1269969305.5258.479.camel@laptop>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Stephane Eranian <eranian@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
X-Mailer: Lotus Notes Release 7.0.1 January 17, 2006
Message-ID: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
From: Gary.Mohr@Bull.com
Date: Thu, 15 Apr 2010 14:16:04 -0700
X-MIMETrack: Serialize by Router on US-PHX1/US/BULL(Release 7.0.2FP2 HF144|July 27, 2007) at
 04/15/2010 02:16:07 PM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, 2010-03-30 at 09:49 -0700, Corey Ashford wrote:
>
> Right, I've got some definite ideas on how to go here, just need some
> time to implement them.
>
> The first thing that needs to be done is get rid of all the __weak
> functions (with exception of perf_callchain*, since that really is arch
> specific).
>
> For hw_perf_event_init() we need to create a pmu registration facility
> and lookup a pmu_id, either passed as an actual id found in sysfs or an
> open file handle from sysfs (the cpu pmu would be pmu_id 0 for backwards
> compat).
>
> hw_perf_disable/enable() would become struct pmu functions and
> perf_disable/enable need to become per-pmu, most functions operate on a
> specific event, for those we know the pmu and hence can call the per-pmu
> version. (XXX find those sites where this is not true).
>
> Then we can move to context, yes I think we want new context for new
> PMUs, otherwise we get very funny RR interleaving problems. My idea was
> to move find_get_context() into struct pmu as well, this allows you to
> have per-pmu contexts. Initially I'd not allow per-pmu-per-task contexts
> because then things like perf_event_task_sched_out() would get rather
> complex.
>
> For RR we can move away from perf_event_task_tick and let the pmu
> install a (hr)timer for this on their own.
>
> I've been planning to implement this for more than a week now, its just
> that other stuff keeps getting in the way.
>

Hi Peter,

My name is Gary Mohr and I work for Bull Information Systems.  I have been
following your discussions with Corey (and others) about how to implement
support for nest PMU's in the linux kernel.

My company feels that support for Intel Nehalem uncore events is very
important
to our customers.  Has the "other stuff" mentioned above quited down to
allow
you to get started on building support for these features ??  If
development
is actually in progress, would you be willing to make a guess as to which
version of the kernel may offer the new capabilities ??

As I said we are interested so if there is any way we can assist you,
please
let us know.  We would be happy to take experimental patch sets and
validate,
test, and debug any problems we encounter if that would help your
development.

Thanks for your time.
Gary

