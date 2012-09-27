Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab2I0KsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:48:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43876 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2I0KsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:48:14 -0400
X-AuditID: 9c93016f-b7b1eae000000815-50-50642eec585f
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: <acme@redhat.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        <andi@firstfloor.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v3 3/9] perf script: Add more filter to find_scripts()
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-4-git-send-email-feng.tang@intel.com>
	<87lifyyiug.fsf@sejong.aot.lge.com> <20120926165641.74f2e5b3@feng-i7>
	<87vcf0ul91.fsf@sejong.aot.lge.com>
Date: Thu, 27 Sep 2012 19:39:59 +0900
In-Reply-To: <87vcf0ul91.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Thu, 27 Sep 2012 13:45:30 +0900")
Message-ID: <87mx0bvjeo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 13:45:30 +0900, Namhyung Kim wrote:
> It'd not that hard.  How about using below (untested) patch?

Hmm... it won't work for some cases.  Please ignore this.

Thanks,
Namhyung

>
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index bf5d033ee1b4..5dc71f598028 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -817,6 +817,21 @@ int parse_events_terms(struct list_head *terms, const char *str)
>  	return ret;
>  }
>  
> +int __parse_events(struct list_head *evsel_list, const char *str)
> +{
> +	int ret;
> +	struct parse_events_data__events data = {
> +		.list = LIST_HEAD_INIT(data.list),
> +	};
> +
> +	ret = parse_events__scanner(str, &data, PE_START_EVENTS);
> +	if (!ret) {
> +		list_splice(evsel_list, &data.list);
> +		return 0;
> +	}
> +	return -1;
> +}
> +
>  int parse_events(struct perf_evlist *evlist, const char *str,
>  		 int unset __maybe_unused)
>  {
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index c356e443448d..c13e9bd0f041 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -32,6 +32,7 @@ extern int parse_events_option(const struct option *opt, const char *str,
>  extern int parse_events(struct perf_evlist *evlist, const char *str,
>  			int unset);
>  extern int parse_events_terms(struct list_head *terms, const char *str);
> +extern int __parse_events(struct list_head *evsel_list, const char *str);
>  extern int parse_filter(const struct option *opt, const char *str, int unset);
>  
>  #define EVENTS_HELP_MAX (128*1024)
