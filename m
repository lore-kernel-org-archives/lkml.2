Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0KLAbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 19:31:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:27566 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab0KLAbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 19:31:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,185,1288594800"; 
   d="scan'208";a="572728965"
Subject: Re: [RFC PATCH 2/2] perf stat: Use event group to simulate PMI on
 PMI-less hardware counter
From: Zhang Rui <rui.zhang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Lin, Ming M" <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Matt Fleming <matt@console-pimps.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289479601.2084.76.camel@laptop>
References: <1289369725.2430.39.camel@minggr.sh.intel.com>
	 <1289391709.2191.102.camel@laptop>  <1289400319.2479.39.camel@localhost>
	 <1289400784.2191.134.camel@laptop>  <1289440836.8148.1365.camel@rui>
	 <1289479601.2084.76.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 08:32:44 +0800
Message-ID: <1289521964.8148.1388.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 20:46 +0800, Peter Zijlstra wrote:
> On Thu, 2010-11-11 at 10:00 +0800, Zhang Rui wrote:
> > Well, the RAPL package energy perf event may need this piece of code.
> > 
> >  "MSR_PKG_ENERGY_STATUS is a read-only MSR. It reports the actual energy
> > use for the package domain. This MSR is updated every ~1msec. It has a
> > wraparound time of around 60 secs when power consumption is high, and
> > may be longer otherwise."
> > 
> > As it's an energy counter, we should show it in "perf stat", right?
> > As it doesn't have interrupt, I want to schedule a timer interrupt every
> > 30s to update the event counter. 
> 
> So use a timer inside the RAPL pmu driver. No need to change the
> interface or add generic code.

Okay.
I was wondering if this can be done with the current perf framework.
If not, surely I'm okay with using a timer inside RAPL driver. :)

thanks,
rui


