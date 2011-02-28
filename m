Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1B1OZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:25:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:37894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab1B1OZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:25:07 -0500
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1298902887.2169.48.camel@localhost>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <1298884559.2428.10083.camel@twins>  <1298902887.2169.48.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Feb 2011 15:24:47 +0100
Message-ID: <1298903087.2428.10875.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 22:21 +0800, Lin Ming wrote:
> > >  #define INTEL_EVENT_CONSTRAINT(c, n)       \
> > >     EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
> > > +#define INTEL_EVENT_CONSTRAINT2(c, n)      \
> > > +   EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
> > 
> > That's a particularly bad name, how about something like
> > 
> > INTEL_UEVENT_CONSTRAINT or somesuch.
> 
> OK.
> 
> But any case it's duplicated with PEBS_EVENT_CONSTRAINT.
> 
> #define PEBS_EVENT_CONSTRAINT(c, n)     \
>         EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK) 

Ah, indeed, so maybe we can remove PEBS_EVENT_CONSTRAINT and use regular
INTEL_*_CONSTRAINTS there, that could also help for PEBS events where
all umasks are allowed (not sure there are any such things but the SNB
PEBS list was quite large).
