Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1LPHNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 02:13:43 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:31680 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1LPHNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 02:13:42 -0500
Message-ID: <4EEAEF83.3080100@gmail.com>
Date: Fri, 16 Dec 2011 11:13:07 +0400
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        asharma@fb.com, devel@openvz.org, dsahern@gmail.com,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 3/6] perf: add ability to record event period
References: <1323266161-394927-1-git-send-email-avagin@openvz.org> <1323266161-394927-4-git-send-email-avagin@openvz.org>
In-Reply-To: <1323266161-394927-4-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Could you review and commit this patch. It's quite common functionality, 
which allow to get events more effectively and to avoid losing events.

All other patches may be postponed, because Arun Sharma wants to suggest 
your version of "Profiling sleep times".

Thanks.

On 12/07/2011 05:55 PM, Andrew Vagin wrote:
> Signed-off-by: Andrew Vagin<avagin@openvz.org>
> ---
>   tools/perf/builtin-record.c |    1 +
>   tools/perf/perf.h           |    1 +
>   tools/perf/util/evsel.c     |    3 +++
>   3 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 766fa0a..f8fd14f 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -700,6 +700,7 @@ const struct option record_options[] = {
>   	OPT_BOOLEAN('d', "data",&record.opts.sample_address,
>   		    "Sample addresses"),
>   	OPT_BOOLEAN('T', "timestamp",&record.opts.sample_time, "Sample timestamps"),
> +	OPT_BOOLEAN('P', "period",&record.opts.period, "Sample period"),
>   	OPT_BOOLEAN('n', "no-samples",&record.opts.no_samples,
>   		    "don't sample"),
>   	OPT_BOOLEAN('N', "no-buildid-cache",&record.no_buildid_cache,
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index ea804f5..64f8bee 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -200,6 +200,7 @@ struct perf_record_opts {
>   	bool	     sample_time;
>   	bool	     sample_id_all_avail;
>   	bool	     system_wide;
> +	bool	     period;
>   	unsigned int freq;
>   	unsigned int mmap_pages;
>   	unsigned int user_freq;
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index e2d1b22..8550018 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -108,6 +108,9 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
>   	if (opts->system_wide)
>   		attr->sample_type	|= PERF_SAMPLE_CPU;
>
> +	if (opts->period)
> +		attr->sample_type	|= PERF_SAMPLE_PERIOD;
> +
>   	if (opts->sample_id_all_avail&&
>   	(opts->sample_time || opts->system_wide ||
>   	     !opts->no_inherit || opts->cpu_list))

