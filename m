Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2CPTmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:42:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50529 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab2CPTms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:42:48 -0400
Date: Fri, 16 Mar 2012 16:42:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] perf report: Add --symbol-filter option
Message-ID: <20120316194244.GP9528@infradead.org>
References: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
 <1331887855-874-4-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331887855-874-4-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 16, 2012 at 05:50:54PM +0900, Namhyung Kim escreveu:
> Add new --symbol-filter command line option to set appropriate
> filter string. Its short version is missing as I couldn't find
> an ideal one and --filter option of perf record also has no
> short version.

You need to update tools/perf/Documentation/perf-report.txt, please send
a follow on patch.
 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/builtin-report.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 8e91c6eba18a..80fb90741b64 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -50,6 +50,7 @@ struct perf_report {
>  	const char		*pretty_printing_style;
>  	symbol_filter_t		annotate_init;
>  	const char		*cpu_list;
> +	const char		*symbol_filter_str;
>  	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>  };
>  
> @@ -400,6 +401,9 @@ static int __cmd_report(struct perf_report *rep)
>  	list_for_each_entry(pos, &session->evlist->entries, node) {
>  		struct hists *hists = &pos->hists;
>  
> +		if (pos->idx == 0)
> +			hists->symbol_filter_str = rep->symbol_filter_str;
> +
>  		hists__collapse_resort(hists);
>  		hists__output_resort(hists);
>  		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
> @@ -591,6 +595,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>  		   "only consider symbols in these comms"),
>  	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
>  		   "only consider these symbols"),
> +	OPT_STRING(0, "symbol-filter", &report.symbol_filter_str, "filter",
> +		   "only show symbols that (partially) match with this filter"),
>  	OPT_STRING('w', "column-widths", &symbol_conf.col_width_list_str,
>  		   "width[,width...]",
>  		   "don't try to adjust column width, use these fixed values"),
> -- 
> 1.7.9
