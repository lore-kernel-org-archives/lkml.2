Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1KMS3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 13:29:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36157 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab1KMS3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 13:29:00 -0500
Message-ID: <4EC00C67.1080603@gmail.com>
Date: Sun, 13 Nov 2011 11:28:55 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf tools: make -C consistent across commands (for cpu
 list arg)
References: <1321208497-6752-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1321208497-6752-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disregard this version; forgot to save the script documentation file
before committing.


On 11/13/2011 11:21 AM, David Ahern wrote:
> Currently the meaning of -C varies by perf command: for perf-top,
> perf-stat, perf-record it means cpu list. For perf-report it
> means comm list. Then perf-annotate, perf-report and perf-script
> use -c for cpu list.
> 
> Fix annotate, report and script to use -C for cpu list to be
> consistent with top, stat and record. This means report needs
> to use -c for comm list which does introduce a backward
> compatibility change.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/Documentation/perf-annotate.txt |    2 +-
>  tools/perf/Documentation/perf-report.txt   |    4 ++--
>  tools/perf/builtin-annotate.c              |    2 +-
>  tools/perf/builtin-report.c                |    4 ++--
>  tools/perf/builtin-script.c                |    2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
> index fe6762e..476029d 100644
> --- a/tools/perf/Documentation/perf-annotate.txt
> +++ b/tools/perf/Documentation/perf-annotate.txt
> @@ -66,7 +66,7 @@ OPTIONS
>  	used. This interfaces starts by centering on the line with more
>  	samples, TAB/UNTAB cycles through the lines with more samples.
>  
> --c::
> +-C::
>  --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
>  	be provided as a comma-separated list with no space: 0,1. Ranges of
>  	CPUs are specified with -: 0-2. Default is to report samples on all
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 212f24d..dc85392 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -39,7 +39,7 @@ OPTIONS
>  -T::
>  --threads::
>  	Show per-thread event counters
> --C::
> +-c::
>  --comms=::
>  	Only consider symbols in these comms. CSV that understands
>  	file://filename entries.
> @@ -128,7 +128,7 @@ OPTIONS
>  --symfs=<directory>::
>          Look for files with symbols relative to this directory.
>  
> --c::
> +-C::
>  --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
>  	be provided as a comma-separated list with no space: 0,1. Ranges of
>  	CPUs are specified with -: 0-2. Default is to report samples on all
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 46b4c24..1b5e68c 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -269,7 +269,7 @@ static const struct option options[] = {
>  		    "print matching source lines (may be slow)"),
>  	OPT_BOOLEAN('P', "full-paths", &full_paths,
>  		    "Don't shorten the displayed pathnames"),
> -	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
> +	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		   "Look for files with symbols relative to this directory"),
>  	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 4d7c834..85a3160 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -474,7 +474,7 @@ static const struct option options[] = {
>  	OPT_BOOLEAN('G', "inverted", &inverted_callchain, "alias for inverted call graph"),
>  	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
>  		   "only consider symbols in these dsos"),
> -	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
> +	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
>  		   "only consider symbols in these comms"),
>  	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
>  		   "only consider these symbols"),
> @@ -488,7 +488,7 @@ static const struct option options[] = {
>  		    "Only display entries resolved to a symbol"),
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		    "Look for files with symbols relative to this directory"),
> -	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
> +	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
>  	OPT_BOOLEAN('I', "show-info", &show_full_info,
>  		    "Display extended information about perf.data file"),
>  	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 2f62a29..01329ca 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -1083,7 +1083,7 @@ static const struct option options[] = {
>  	OPT_CALLBACK('f', "fields", NULL, "str",
>  		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
>  		     parse_output_fields),
> -	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
> +	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
>  	OPT_BOOLEAN('I', "show-info", &show_full_info,
>  		    "display extended information from perf.data file"),
>  	OPT_END()
