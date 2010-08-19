Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab0HSD16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 23:27:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:16159 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0HSD15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 23:27:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,231,1280732400"; 
   d="scan'208";a="649142171"
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Lin Ming <ming.m.lin@intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Zhang, Rui" <rui.zhang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20100818124116.GA17957@console-pimps.org>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
	 <20100818124116.GA17957@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 11:28:17 +0800
Message-ID: <1282188497.11858.94.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 20:41 +0800, Matt Fleming wrote:
> On Wed, Aug 18, 2010 at 02:25:29PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-08-18 at 15:59 +0800, Zhang Rui wrote:
> > > Hi, all,
> > > 
> > > RAPL(running average power limit) is a new feature which provides
> > > mechanisms to enforce power consumption limit, on some new processors.
> > > 
> > > Generally speaking, by using RAPL, OS can set a power budget in a
> > > certain time window, and let Hardware to throttle the processor
> > > P/T-state to meet this energy limitation.
> > > 
> > > RAPL also provides a new MSR, i.e. MSR_PKG_ENERGY_STATUS, which reports
> > > the total amount of energy consumed by the package.
> > > 
> > > I'm not sure if to support RAPL or not, but anyway, it sounds like a
> > > good idea to export the energy status in perf.
> > > 
> > > So a new perf pmu and event to show the package energy consumed is
> > > introduced in this patch.
> > > 
> > > Here is what I get after applying the three patches,
> > > 
> > > #./perf stat -e energy test
> > > Performance counter stats for 'test':
> > > 
> > > 	202	Joules cost by package
> > > 7.926001238	seconds time elapsed
> > > 
> > > 
> > > Note that this patch set is made based on Peter's perf-pmu branch,
> > > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git
> > >  which provides better interfaces to register/unregister a new pmu.
> > > 
> > > any comment are welcome. :)
> > 
> > 
> > Nice,.. however:
> > 
> >  - if it is a pure read-only counter without sampling support,
> >    expose it as such, don't fudge in the hrtimer stuff. Simply
> >    fail to create a sampling event.
> > 
> >    SH has the same problem for its 'normal' PMU, the solution is
> >    to use event groups, Matt was looking at adding support to
> >    perf-record for that, if creating a sampling event fails, fall
> >    back to {hrtimer, $event} groups.
> 
> I had a quick look over the patches and Peter is right - the group
> events stuff would probably fit quite well here. Unfortunately, due to
> holidays and things, I haven't been able to get them finished
> yet. I'll get on that ASAP.

Hi, Matt

What's the "group events stuff"?
Is there some discussion on LKML or elsewhere I can have a look at?

Thanks,
Lin Ming



