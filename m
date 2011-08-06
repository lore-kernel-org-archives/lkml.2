Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1HFXkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 19:40:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:7177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1HFXkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 19:40:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,330,1309762800"; 
   d="scan'208";a="35868999"
Subject: Re: [PATCH v2 6/6] perf tool: Parse general/raw events from sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CABPqkBRTw5mcHn29gba8OyeUfMuGU3mQcKsrADug1401n6j0kw@mail.gmail.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-7-git-send-email-ming.m.lin@intel.com>
	 <CABPqkBRTw5mcHn29gba8OyeUfMuGU3mQcKsrADug1401n6j0kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Aug 2011 07:38:08 +0800
Message-ID: <1312673888.2664.18.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-07 at 04:10 +0800, Stephane Eranian wrote:
> Hi,
> 
> On Fri, Jul 15, 2011 at 7:35 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > PMU can export general events to sysfs, for example,
> >
> > /sys/bus/event_source/devices/uncore/events
> > └── cycle
> >
> > Then specify the event as <pmu>:<event>,
> >
> > $ sudo perf stat -a -C 0 -e uncore:cycle
> 
> I think this event syntax should be adjusted a bit.
> 
> How would the tool differentiate:
>        perf stat -e uncore:cycle
> form:
>       perf stat -e cycle:u
> 
> It would have to scan sysfs for a 'cycle' PMU and conclude
> there is none,  then resolve the 'cycle' event name. And if
> you're unlucky and you have a event name that matches
> the PMU name, you get into troubles.
> 
> I think, one could instead do:
> 
>     perf stat -e uncore::cycle:k
> 
> That way, by virtue of the '::' separator, the tool would know
> that it needs to first look into sysfs for an 'uncore' PMU, then
> it needs to look for the 'cycle' event.

Yes, I like this '::' separator too.
Will update to use it.

> 
> I also use the '::' notation in libpfm4 to separate the PMU model
> form the event+umask+modifiers.
> 
> I also suspect that with this sysfs interface for PMU models, you
> would simply add a number to differentiate each instance of a PMU.
> So for GPU, you would do:
>     perf stat -e  gfx0::cycles
> 
> Is that right?

A number or other thing is OK.
 
int perf_pmu_register(struct pmu *pmu, char *name, int type)
will be called to register a PMU.

So I think any name that can differentiate each instance is OK.

Adding a number looks like the easiest way.

Thanks,
Lin Ming


