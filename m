Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2DQLZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:25:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab2DQLZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:25:09 -0400
Date: Tue, 17 Apr 2012 13:25:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: acme@ghostprotocols.net, a.p.zijlstra@chello.nl, mingo@redhat.com,
        linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCHv2] perf tools: Add 'G' and 'H' modifiers to event parsing
Message-ID: <20120417112500.GC1650@m.brq.redhat.com>
References: <20120417111345.GK11918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417111345.GK11918@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 02:13:45PM +0300, Gleb Natapov wrote:
> They were dropped during conversion of event parser. Add test case to
> make sure this will not happen again.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> index 1c5b980..223ffdc 100644
> --- a/tools/perf/builtin-test.c
> +++ b/tools/perf/builtin-test.c
> @@ -851,6 +851,28 @@ static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
>  	return test__checkevent_symbolic_name(evlist);
>  }
>  
> +static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
> +{
> +	struct perf_evsel *evsel = list_entry(evlist->entries.next,
> +					      struct perf_evsel, node);
> +
> +	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
> +	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
> +
> +	return test__checkevent_symbolic_name(evlist);
> +}
> +
> +static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
> +{
> +	struct perf_evsel *evsel = list_entry(evlist->entries.next,
> +					      struct perf_evsel, node);
> +
> +	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
> +	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
> +
> +	return test__checkevent_symbolic_name(evlist);
> +}
> +
>  static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
>  {
>  	struct perf_evsel *evsel = list_entry(evlist->entries.next,
> @@ -1091,6 +1113,14 @@ static struct test__event_st {
>  		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
>  		.check = test__checkevent_list,
>  	},
> +	{
> +		.name  = "instructions:G",
> +		.check = test__checkevent_exclude_host_modifier,
> +	},
> +	{
> +		.name  = "instructions:H",
> +		.check = test__checkevent_exclude_guest_modifier,
> +	},
>  };
>  
>  #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 05d766e..1fcf1bb 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -54,7 +54,7 @@ num_dec		[0-9]+
>  num_hex		0x[a-fA-F0-9]+
>  num_raw_hex	[a-fA-F0-9]+
>  name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
> -modifier_event	[ukhp]{1,5}
> +modifier_event	[ukhpGH]{1,8}
>  modifier_bp	[rwx]
>  
>  %%
> --
> 			Gleb.
