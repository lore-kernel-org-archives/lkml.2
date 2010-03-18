Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0CRQBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:01:42 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37588 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CRQBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=grJnnjlD2kCv1TDX+iVyShfy0ytgfJC8vZYqOhMHpr/TVMGvKw2ogNcXjOkoa4/2wI
         wxiADQ3Hz/kEDrLhbYOewXUdIcTA0PG6VXf6GxllCQ8ioXHWK+vxN0Gbic0FDNOH/8sb
         dhhgBhZdOJ5wJx+A6a8toz771plp3FLDZb7DA=
Date: Thu, 18 Mar 2010 19:01:35 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] x86,perf: add cache events in p4 PMU
Message-ID: <20100318160135.GD5062@lenovo>
References: <1268908392.13901.128.camel@minggr.sh.intel.com> <20100318155610.GA28061@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318155610.GA28061@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 04:56:10PM +0100, Ingo Molnar wrote:
> 
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > Add cache events in p4 PMU.
> > 
> > Move the HT bit setting code from p4_pmu_event_map to p4_hw_config.
> > So the cache events can get HT bit set correctly.
> > 
> > Tested on my P4 desktop, below 6 cache events work.
> > L1-dcache-load-misses
> > LLC-load-misses
> > dTLB-load-misses
> > dTLB-store-misses
> > iTLB-loads
> > iTLB-load-misses
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  arch/x86/include/asm/msr-index.h     |    2 +
> >  arch/x86/include/asm/perf_event_p4.h |   10 ++
> >  arch/x86/kernel/cpu/perf_event_p4.c  |  153 ++++++++++++++++++++++++++++++++--
> >  3 files changed, 159 insertions(+), 6 deletions(-)
> 
> i tried it on a Pentium-D box, and it works pretty well:
> 
> rhea:/home/mingo/tip> perf stat -a sleep 1
> 
>  Performance counter stats for 'sleep 1':
> 
>     2003.237268  task-clock-msecs         #      2.000 CPUs 
>              11  context-switches         #      0.000 M/sec
>               2  CPU-migrations           #      0.000 M/sec
>             174  page-faults              #      0.000 M/sec
>           47361  cycles                   #      0.024 M/sec  (scaled from 52.83%)
>             430  instructions             #      0.009 IPC    (scaled from 74.58%)
>           23873  branches                 #      0.012 M/sec  (scaled from 96.70%)
>             193  branch-misses            #      0.808 %      (scaled from 49.64%)
>             867  cache-references         #      0.000 M/sec  (scaled from 49.69%)
>             504  cache-misses             #      0.000 M/sec  (scaled from 49.58%)
> 
>     1.001411586  seconds time elapsed
> 
> So i've applied your patches. Cyrill, what do you think?

Sorry for a bit delay, yes, pick it up please. I found that we have an
issue in escr binding (which is pretty mine error), hope to fix it up
today. Also I hope to eventually implement raw events this weekend
but better to base the new code on all this stuff merged. This will
allow to "take a look" on code structure from a high point and find
potential caveats.

All-in-one

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks a huge, Ming!

> 
> 	Ingo
> 
	-- Cyrill
