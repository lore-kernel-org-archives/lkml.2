Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1EFHmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:42:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:15454 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab1EFHmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:42:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,325,1301900400"; 
   d="scan'208";a="743206219"
Subject: Re: [PATCH] perf events, x86: Add SandyBridge
 stalled-cycles-frontend/backend events
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110506073832.GG23166@elte.hu>
References: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
	 <20110506073832.GG23166@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 15:43:41 +0800
Message-ID: <1304667821.3924.284.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 15:38 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > Extend the Intel SandyBridge PMU driver with definitions
> > for generic front-end and back-end stall events.
> > 
> > ( As commit 3011203 says, these are only approximations. )
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event_intel.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > index c1ec7a5..61cbf48 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -1485,6 +1485,12 @@ static __init int intel_pmu_init(void)
> >  
> >  		x86_pmu.event_constraints = intel_snb_event_constraints;
> >  		x86_pmu.pebs_constraints = intel_snb_pebs_events;
> > +
> > +		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
> > +		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
> > +		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
> > +		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x18001b1;
> > +
> 
> Nice!
> 
> Could you check Intel Atom perhaps as well, does it have any useful event to 
> approximate this?

OK, let me check.

> 
> Thanks,
> 
> 	Ingo


