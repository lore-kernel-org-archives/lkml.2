Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0HRMlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 08:41:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58450 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797Ab0HRMlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 08:41:17 -0400
Date: Wed, 18 Aug 2010 13:41:16 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        mingo@elte.hu, robert.richter@amd.com, acme@redhat.com,
        paulus@samba.org, dzickus@redhat.com, gorcunov@gmail.com,
        fweisbec@gmail.com, Lin Ming <ming.m.lin@intel.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
Message-ID: <20100818124116.GA17957@console-pimps.org>
References: <1282118350.5181.115.camel@rui> <1282134329.1926.3918.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282134329.1926.3918.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 02:25:29PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-08-18 at 15:59 +0800, Zhang Rui wrote:
> > Hi, all,
> > 
> > RAPL(running average power limit) is a new feature which provides
> > mechanisms to enforce power consumption limit, on some new processors.
> > 
> > Generally speaking, by using RAPL, OS can set a power budget in a
> > certain time window, and let Hardware to throttle the processor
> > P/T-state to meet this energy limitation.
> > 
> > RAPL also provides a new MSR, i.e. MSR_PKG_ENERGY_STATUS, which reports
> > the total amount of energy consumed by the package.
> > 
> > I'm not sure if to support RAPL or not, but anyway, it sounds like a
> > good idea to export the energy status in perf.
> > 
> > So a new perf pmu and event to show the package energy consumed is
> > introduced in this patch.
> > 
> > Here is what I get after applying the three patches,
> > 
> > #./perf stat -e energy test
> > Performance counter stats for 'test':
> > 
> > 	202	Joules cost by package
> > 7.926001238	seconds time elapsed
> > 
> > 
> > Note that this patch set is made based on Peter's perf-pmu branch,
> > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git
> >  which provides better interfaces to register/unregister a new pmu.
> > 
> > any comment are welcome. :)
> 
> 
> Nice,.. however:
> 
>  - if it is a pure read-only counter without sampling support,
>    expose it as such, don't fudge in the hrtimer stuff. Simply
>    fail to create a sampling event.
> 
>    SH has the same problem for its 'normal' PMU, the solution is
>    to use event groups, Matt was looking at adding support to
>    perf-record for that, if creating a sampling event fails, fall
>    back to {hrtimer, $event} groups.

I had a quick look over the patches and Peter is right - the group
events stuff would probably fit quite well here. Unfortunately, due to
holidays and things, I haven't been able to get them finished
yet. I'll get on that ASAP.
