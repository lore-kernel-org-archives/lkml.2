Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3AGKLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:11:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab3AGKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:11:30 -0500
Date: Mon, 7 Jan 2013 11:11:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v4 08/18] perf/x86: add memory profiling via PEBS Load
 Latency
Message-ID: <20130107101113.GB963@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
 <1356018108-6081-9-git-send-email-eranian@google.com>
 <20130105184329.GB995@krava.brq.redhat.com>
 <CABPqkBRkJtB+5C=gq=ngJE9hYxVkxE7s2-4UN+Ub+Y8_pf9x2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRkJtB+5C=gq=ngJE9hYxVkxE7s2-4UN+Ub+Y8_pf9x2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 09:37:25PM +0100, Stephane Eranian wrote:
> On Sat, Jan 5, 2013 at 7:43 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Thu, Dec 20, 2012 at 04:41:38PM +0100, Stephane Eranian wrote:
> >> This patch adds support for memory profiling using the
> >> PEBS Load Latency facility.
> >>
> >> Load accesses are sampled by HW and the instruction
> >> address, data address, load latency, data source, tlb,
> >> locked information can be saved in the sampling buffer
> >> if using the PERF_SAMPLE_COST (for latency),
> >
> > PERF_SAMPLE_WEIGHT ?
> >
> No I switched to using Andi's PERF_SAMPLE_WEIGHT patch for this.
> So it's PERF_SAMPLE_COST now.

Is it? I dont see PERF_SAMPLE_COST being used in the code..

> 
> >> PERF_SAMPLE_ADDR, PERF_SAMPLE_DSRC types.
> >>
> >> To enable PEBS Load Latency, users have to use the
> >> model specific event:
> >> - on NHM/WSM: MEM_INST_RETIRED:LATENCY_ABOVE_THRESHOLD
> >> - on SNB/IVB: MEM_TRANS_RETIRED:LATENCY_ABOVE_THRESHOLD
> >>
> >> To make things easier, this patch also exports a generic
> >> alias via sysfs: mem-loads. It export the right event
> >> encoding based on the host CPU and can be used directly
> >> by the perf tool.
> >>
> >> Loosely based on Intel's Lin Ming patch posted on LKML
> >> in July 2011.
> >>
> >> Signed-off-by: Stephane Eranian <eranian@google.com>
> >
> > SNIP
> >
> >> +/*
> >> + * Map PEBS Load Latency Data Source encodings to generic
> >> + * memory data source information
> >> + */
> >> +#define P(a, b) PERF_MEM_S(a, b)
> >> +#define OP_LH (P(OP, LOAD) | P(LVL, HIT))
> >> +#define SNOOP_NONE_MISS (P(SNOOP, NONE) | P(SNOOP, MISS))
> >> +
> >
> > I checked Intel SDM 'Table 18-13. Data Source Encoding for Load Latency Record'
> > and it seems to be different (below) at some points.. did you use another source?
> >
> Yeah, and the table is wrong in the SDM. What I have is correct and approved by
> Intel.

Is there any public link?

thanks,
jirka
