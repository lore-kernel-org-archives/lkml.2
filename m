Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0HPJeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 05:34:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:39537 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab0HPJeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 05:34:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,375,1278313200"; 
   d="scan'208";a="596910248"
Subject: Re: perf, how to support multiple x86 hw pmus?
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Fu, Michael" <michael.fu@intel.com>
In-Reply-To: <1281949925.1926.1081.camel@laptop>
References: <1281946154.6555.46.camel@minggr.sh.intel.com>
	 <1281947113.1926.1004.camel@laptop>
	 <1281947959.6555.56.camel@minggr.sh.intel.com>
	 <1281949925.1926.1081.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 17:33:54 +0800
Message-ID: <1281951234.6555.65.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 17:12 +0800, Peter Zijlstra wrote:
> On Mon, 2010-08-16 at 16:39 +0800, Lin Ming wrote:
> > > After that and some patches adding per pmu contexts adding multiple
> > > hardware pmus should be simple.
> > 
> > I didn't see the per pmu contexts patches, are you still working on
> > them?
> > 
> Yes, although 3 weeks of holidays and a week of LinuxCon didn't help to
> finish that work ;-)
> 
> I hope to be back to that soon ;-)

Really thanks for your work, that makes uncore support much easier.

> 
> > > 
> > > uncore should not share any code with the regular pmu, since they're
> > > mostly unrelated.
> > 
> > But should they share code like collect_events, schedule_events,
> > x86_perf_event_set_period(with some modification) etc...?
> > 
> Maybe, I'd have to look at the uncore stuff again, I can't remember if
> it has much in the way of event scheduling constraints and if the
> counter programming is close enough to the regular pmu to make it worth
> sharing code over.

I looked at the Nehalem uncore stuff and it does not have event
constraints. Each event can be monitored with any uncore counter.

The counter programming is close to regular pmu. It has
PERFEVTSELx/GLOBAL_STATUS/GLOBAL_OVF_CTRL/FIXED_CTR_CTRL like regular
pmu.


