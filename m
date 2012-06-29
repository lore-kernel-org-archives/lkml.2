Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab2F2QnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:43:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab2F2QnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:43:18 -0400
Date: Fri, 29 Jun 2012 18:43:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] perf, tool: Add events support for pmu
Message-ID: <20120629164304.GG6978@krava.brq.redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
 <1339706321-8802-5-git-send-email-jolsa@redhat.com>
 <20120629163607.GB7847@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629163607.GB7847@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 01:36:07PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 14, 2012 at 10:38:39PM +0200, Jiri Olsa escreveu:
> > The pmu sysfs record expose events group attribute with
> > hardware events translations.
> > 
> > Adding support to read those and make it available throught:
> > __u64 perf_pmu__event(struct perf_pmu *pmu, unsigned id)
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  tools/perf/util/pmu.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >  tools/perf/util/pmu.h |    2 +
> >  2 files changed, 98 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> > index 1d73131..bf2a2a9 100644
> > --- a/tools/perf/util/pmu.c
> > +++ b/tools/perf/util/pmu.c
> > @@ -88,6 +88,94 @@ static int pmu_format(char *name, struct list_head *format)
> >  	return 0;
> >  }
> >  
> > +const char *events_files[PERF_COUNT_HW_MAX] = {
> > +	[PERF_COUNT_HW_CPU_CYCLES]              = "cycles",
> > +	[PERF_COUNT_HW_INSTRUCTIONS]            = "instructions",
> > +	[PERF_COUNT_HW_CACHE_REFERENCES]        = "cache_references",
> > +	[PERF_COUNT_HW_CACHE_MISSES]            = "cache_misses",
> > +	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]     = "branch_instructions",
> > +	[PERF_COUNT_HW_BRANCH_MISSES]           = "branch_misses",
> > +	[PERF_COUNT_HW_BUS_CYCLES]              = "bus_cycles",
> > +	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = "stalled_cycles_frontend",
> > +	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]  = "stalled_cycles_backend",
> > +	[PERF_COUNT_HW_REF_CPU_CYCLES]          = "ref_cycles",
> 
> we have this one:
> 
> static const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX] = {
> 
> Can't it be used?

right, probably yes... I need to redesign the patch anyway,
I'll see if I can use it

thanks,
jirka
