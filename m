Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0EER6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:58:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42730 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0EER6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v1hRAriI5kXc2rjivrkzLtdUsqGjSEOj6ot8YaBbRIpdxkObw9RaIJeD0/5zr0muWm
         2YZb8o62zQAXQ6zUsL2WeuIpKhnm4J9zUD8b4pm4zZc4dYLb7aqnKZ3Wb6spJ0eorvRZ
         twC96PXIZYiQi8gv0bAEdnKP/tyk+Tw3CHeRg=
Date: Wed, 5 May 2010 19:58:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
	from preemption
Message-ID: <20100505175815.GE6320@nowhere>
References: <20100505150740.GB5686@lenovo> <20100505165731.GA6320@nowhere> <20100505174234.GH5686@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505174234.GH5686@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 09:42:34PM +0400, Cyrill Gorcunov wrote:
> On Wed, May 05, 2010 at 06:57:34PM +0200, Frederic Weisbecker wrote:
> ...
> > > @@ -741,7 +743,7 @@ static int p4_pmu_schedule_events(struct
> > >  {
> > >  	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> > >  	unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
> > > -	int cpu = raw_smp_processor_id();
> > > +	int cpu = get_cpu();
> > >  	struct hw_perf_event *hwc;
> > >  	struct p4_event_bind *bind;
> > >  	unsigned int i, thread, num;
> > > @@ -777,6 +779,7 @@ reserve:
> > >  	}
> > >  
> > >  done:
> > > +	put_cpu();
> > >  	return num ? -ENOSPC : 0;
> > >  }
> > 
> > That's no big deal. But I think the schedule_events() is called on
> > pmu::enable() time, when preemption is already disabled.
> > 
> 
> We'll be on a safe side using get/put_cpu here (ie in case
> if something get changed one day).
> 
> 	-- Cyrill


Sure, no problem with that.

