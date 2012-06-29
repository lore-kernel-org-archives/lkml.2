Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2F2QgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:36:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab2F2QgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:36:21 -0400
Date: Fri, 29 Jun 2012 13:36:07 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] perf, tool: Add events support for pmu
Message-ID: <20120629163607.GB7847@infradead.org>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
 <1339706321-8802-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339706321-8802-5-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 14, 2012 at 10:38:39PM +0200, Jiri Olsa escreveu:
> The pmu sysfs record expose events group attribute with
> hardware events translations.
> 
> Adding support to read those and make it available throught:
> __u64 perf_pmu__event(struct perf_pmu *pmu, unsigned id)
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/pmu.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  tools/perf/util/pmu.h |    2 +
>  2 files changed, 98 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 1d73131..bf2a2a9 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -88,6 +88,94 @@ static int pmu_format(char *name, struct list_head *format)
>  	return 0;
>  }
>  
> +const char *events_files[PERF_COUNT_HW_MAX] = {
> +	[PERF_COUNT_HW_CPU_CYCLES]              = "cycles",
> +	[PERF_COUNT_HW_INSTRUCTIONS]            = "instructions",
> +	[PERF_COUNT_HW_CACHE_REFERENCES]        = "cache_references",
> +	[PERF_COUNT_HW_CACHE_MISSES]            = "cache_misses",
> +	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]     = "branch_instructions",
> +	[PERF_COUNT_HW_BRANCH_MISSES]           = "branch_misses",
> +	[PERF_COUNT_HW_BUS_CYCLES]              = "bus_cycles",
> +	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = "stalled_cycles_frontend",
> +	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]  = "stalled_cycles_backend",
> +	[PERF_COUNT_HW_REF_CPU_CYCLES]          = "ref_cycles",

we have this one:

static const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX] = {

Can't it be used?

- Arnaldo
