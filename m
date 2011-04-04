Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1DDKGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:06:15 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33787 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1DDKGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:06:13 -0400
X-AuditID: b753bd60-a0cf4ba000000ee4-0e-4d9998128719
X-AuditID: b753bd60-a0cf4ba000000ee4-0e-4d9998128719
Message-ID: <4D99980E.5080807@hitachi.com>
Date: Mon, 04 Apr 2011 19:06:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 22/26] 22: perf: rename target_module
 to target
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6> <20110401143657.15455.4701.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110401143657.15455.4701.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/04/01 23:36), Srikar Dronamraju wrote:
> This is a precursor patch that modifies names that refer to kernel/module
> to also refer to user space names.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  tools/perf/builtin-probe.c    |   12 ++++++------
>  tools/perf/util/probe-event.c |    6 +++---
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 2c0e64d..98db08f 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -61,7 +61,7 @@ static struct {
>  	struct perf_probe_event events[MAX_PROBES];
>  	struct strlist *dellist;
>  	struct line_range line_range;
> -	const char *target_module;
> +	const char *target;
>  	int max_probe_points;
>  	struct strfilter *filter;
>  } params;
> @@ -241,7 +241,7 @@ static const struct option options[] = {
>  		   "file", "vmlinux pathname"),
>  	OPT_STRING('s', "source", &symbol_conf.source_prefix,
>  		   "directory", "path to kernel source"),
> -	OPT_STRING('m', "module", &params.target_module,
> +	OPT_STRING('m', "module", &params.target,
>  		   "modname", "target module name"),
>  #endif
>  	OPT__DRY_RUN(&probe_event_dry_run),
> @@ -327,7 +327,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
>  		if (!params.filter)
>  			params.filter = strfilter__new(DEFAULT_FUNC_FILTER,
>  						       NULL);
> -		ret = show_available_funcs(params.target_module,
> +		ret = show_available_funcs(params.target,
>  					   params.filter);
>  		strfilter__delete(params.filter);
>  		if (ret < 0)
> @@ -348,7 +348,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
>  			usage_with_options(probe_usage, options);
>  		}
>  
> -		ret = show_line_range(&params.line_range, params.target_module);
> +		ret = show_line_range(&params.line_range, params.target);
>  		if (ret < 0)
>  			pr_err("  Error: Failed to show lines. (%d)\n", ret);
>  		return ret;
> @@ -365,7 +365,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
>  
>  		ret = show_available_vars(params.events, params.nevents,
>  					  params.max_probe_points,
> -					  params.target_module,
> +					  params.target,
>  					  params.filter,
>  					  params.show_ext_vars);
>  		strfilter__delete(params.filter);
> @@ -387,7 +387,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
>  	if (params.nevents) {
>  		ret = add_perf_probe_events(params.events, params.nevents,
>  					    params.max_probe_points,
> -					    params.target_module,
> +					    params.target,
>  					    params.force_add);
>  		if (ret < 0) {
>  			pr_err("  Error: Failed to add events. (%d)\n", ret);
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 5ddee66..09c53c1 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1979,7 +1979,7 @@ static int filter_available_functions(struct map *map __unused,
>  	return 1;
>  }
>  
> -int show_available_funcs(const char *module, struct strfilter *_filter)
> +int show_available_funcs(const char *elfobject, struct strfilter *_filter)
>  {
>  	struct map *map;
>  	int ret;
> @@ -1990,9 +1990,9 @@ int show_available_funcs(const char *module, struct strfilter *_filter)
>  	if (ret < 0)
>  		return ret;
>  
> -	map = kernel_get_module_map(module);
> +	map = kernel_get_module_map(elfobject);
>  	if (!map) {
> -		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
> +		pr_err("Failed to find %s map.\n", (elfobject) ? : "kernel");

Hmm, these changes(module -> elfobject) are put back by the next patch.
Could you check your patch stack?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
