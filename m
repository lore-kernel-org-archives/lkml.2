Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1B1Opd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:45:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:29994 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1B1Opc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:45:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,240,1297065600"; 
   d="scan'208";a="714139852"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1298903087.2428.10875.camel@twins>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <1298884559.2428.10083.camel@twins>  <1298902887.2169.48.camel@localhost>
	 <1298903087.2428.10875.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 22:45:25 +0800
Message-Id: <1298904325.2169.54.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 22:24 +0800, Peter Zijlstra wrote:
> On Mon, 2011-02-28 at 22:21 +0800, Lin Ming wrote:
> > > >  #define INTEL_EVENT_CONSTRAINT(c, n)       \
> > > >     EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
> > > > +#define INTEL_EVENT_CONSTRAINT2(c, n)      \
> > > > +   EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
> > > 
> > > That's a particularly bad name, how about something like
> > > 
> > > INTEL_UEVENT_CONSTRAINT or somesuch.
> > 
> > OK.
> > 
> > But any case it's duplicated with PEBS_EVENT_CONSTRAINT.
> > 
> > #define PEBS_EVENT_CONSTRAINT(c, n)     \
> >         EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK) 
> 
> Ah, indeed, so maybe we can remove PEBS_EVENT_CONSTRAINT and use regular
> INTEL_*_CONSTRAINTS there, that could also help for PEBS events where
> all umasks are allowed (not sure there are any such things but the SNB
> PEBS list was quite large).

Yes, there are, for example, BR_INST_RETIRED.*

