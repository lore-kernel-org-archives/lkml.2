Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1EKPtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:49:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51715 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab1EKPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:49:48 -0400
Date: Wed, 11 May 2011 16:31:49 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110511143149.GA26548@aftab>
References: <20110511121135.GA25865@aftab>
 <1305121600.2914.214.camel@laptop>
 <20110511140208.GD25827@aftab>
 <20110511141342.GA19053@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511141342.GA19053@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:13:42AM -0400, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > On Wed, May 11, 2011 at 09:46:40AM -0400, Peter Zijlstra wrote:
> > > On Wed, 2011-05-11 at 14:11 +0200, Borislav Petkov wrote:
> > > >  include/linux/perf_event.h |  138 ++++++++++++-
> > > 
> > > I don't like exposing all that in a kernel wide header.. should we maybe
> > > have kernel/events/internal.h?
> > 
> > Sounds prudent. Maybe add a patch ontop that moves all perf_event.h
> > exports which are shared _only_ between kernel/events/*.c compilation
> > units to an internal.h header? Ingo?
> 
> There's not that many that are in perf_event.h and are only used in 
> kernel/event/core.c.
> 
> Below is a generated list of all exported functions and their usage sites. Out 
> of 40 functions 7 should not be exported:
> 
>  __perf_sw_event()
>  perf_swevent_put_recursion_context()
>  perf_pmu_unregister()
>  perf_output_copy()
>  __perf_event_task_sched_in()
>  __perf_event_task_sched_out()
>  perf_event_read_value()

Right, but splitting perf_event.c further would cause a bunch more
of them to go up in the header since they're being shared among
kernel/events/*.c files. But in the end, this is a judgement call - I
mean, even the polluting ones have a clearly defined namespace starting
their names with {_-,}perf_*. If you asked me, I'd do an internal.h
header from the get-go so that all is kept as clean as possible.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
