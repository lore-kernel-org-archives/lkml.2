Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab2GDMOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:14:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2GDMOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:14:04 -0400
Subject: Re: [PATCH 07/10] perf, tool: Add support to specify hw event as
 pmu event term
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120704120001.GC960@krava.redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-8-git-send-email-jolsa@redhat.com>
	 <1341398360.2507.99.camel@laptop>  <20120704120001.GC960@krava.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 14:13:39 +0200
Message-ID: <1341404019.2507.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 14:00 +0200, Jiri Olsa wrote:
> On Wed, Jul 04, 2012 at 12:39:20PM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> > > 
> > > It's possible to use sysfs attribute name as 'event' term value,
> > > or any possible alias for hw event, e.g.:
> > >   cycles                     OR cpu-cycles
> > >   branch_misses              OR branch-misses
> > >   bus_cycles                 OR bus-cycles
> > >   cache_misses               OR cache-misses
> > >   cache_references           OR cache-references
> > >   ref_cycles                 OR ref-cycles
> > >   stalled_cycles_backend     OR stalled-cycles-backend
> > >   stalled_cycles_frontend    OR stalled-cycles-frontend 
> > 
> > Do we really want to do that?
> 
> well, the aliasing works on sysfs filename base.. so when you specify
>    event=str 
> 
> 'str' file is looked up in 'events' dir.

Right..

> We use '_' in file names and '-' in event symbol names. I thought it might be
> confusing allowing just '_' so I added also the '-' version.
> 
> I could keep just the '-' version.. with some more work on kernel ATTR
> function names ;) but it seems like common sysfs practise to use '_'.

We could map '-' to '_', but I'm not sure about the aliases in general.
I mean if the sysfs event name is 'cycles' also allowing 'cpu_cycles' is
somewhat confusing and arbitrary.

I think it would be best to stick to discoverable names only. Anybody?


