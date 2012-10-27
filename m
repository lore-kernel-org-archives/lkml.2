Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab2J0TJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:09:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab2J0TJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:09:06 -0400
Date: Sat, 27 Oct 2012 21:08:41 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 24/33] perf, tools: Move parse_events error printing to
 parse_events_options
Message-ID: <20121027190841.GA1039@krava.redhat.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
 <1351283415-13170-25-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351283415-13170-25-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:30:06PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The callers of parse_events usually have their own error handling.
> Move the fprintf for a bad event to parse_events_options, which
> is the only one who should need it.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/parse-events.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 75c7b0f..409da3e 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -827,8 +827,6 @@ int parse_events(struct perf_evlist *evlist, const char *str,
>  	 * Both call perf_evlist__delete in case of error, so we dont
>  	 * need to bother.
>  	 */
> -	fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
> -	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
>  	return ret;
>  }
>  
> @@ -836,7 +834,13 @@ int parse_events_option(const struct option *opt, const char *str,
>  			int unset __maybe_unused)
>  {
>  	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
> -	return parse_events(evlist, str, unset);
> +	int ret = parse_events(evlist, str, unset);
> +
> +	if (ret) {
> +		fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
> +		fprintf(stderr, "Run 'perf list' for a list of valid events\n");
> +	}
> +	return ret;
>  }
>  
>  int parse_filter(const struct option *opt, const char *str,
> -- 
> 1.7.7.6
> 

Acked-by: Jiri Olsa <jolsa@redhat.com>
