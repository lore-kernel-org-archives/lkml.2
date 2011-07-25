Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1GYPFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:05:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:36552 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1GYPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:05:04 -0400
Date: Mon, 25 Jul 2011 12:04:44 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 09/18] perf: Drop redundant FD macro definitions
Message-ID: <20110725150444.GB18804@ghostprotocols.net>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
 <1303576100-425-10-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303576100-425-10-git-send-email-bp@amd64.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Apr 23, 2011 at 06:28:11PM +0200, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Put a single define in the util/util.h header which should be generic
> enough and included by all builtin commands.

I'll apply this one, but will move those definitions to evsel.h, as they
operate on an evlist instance (e->fd).

- Arnaldo
 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  tools/perf/builtin-record.c |    2 --
>  tools/perf/builtin-top.c    |    2 --
>  tools/perf/util/evlist.c    |    3 ---
>  tools/perf/util/evsel.c     |    2 --
>  tools/perf/util/util.h      |    3 +++
>  5 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 4165382..4497a38 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -30,8 +30,6 @@
>  #include <sched.h>
>  #include <sys/mman.h>
>  
> -#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> -
>  enum write_mode_t {
>  	WRITE_FORCE,
>  	WRITE_APPEND
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 7e3d6e3..7fd50c1 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -62,8 +62,6 @@
>  #include <linux/unistd.h>
>  #include <linux/types.h>
>  
> -#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> -
>  static struct perf_top top = {
>  	.count_filter		= 5,
>  	.delay_secs		= 2,
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 45da8d1..65a8031 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -19,9 +19,6 @@
>  #include <linux/bitops.h>
>  #include <linux/hash.h>
>  
> -#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> -#define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
> -
>  void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
>  		       struct thread_map *threads)
>  {
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index d6fd59b..13ee267 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -13,8 +13,6 @@
>  #include "cpumap.h"
>  #include "thread_map.h"
>  
> -#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> -
>  void perf_evsel__init(struct perf_evsel *evsel,
>  		      struct perf_event_attr *attr, int idx)
>  {
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index fc78428..c32d66d 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -39,6 +39,9 @@
>  /* Approximation of the length of the decimal representation of this type. */
>  #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
>  
> +#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> +#define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
> +
>  #define _ALL_SOURCE 1
>  #define _GNU_SOURCE 1
>  #define _BSD_SOURCE 1
> -- 
> 1.7.4.rc2
