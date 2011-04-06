Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1DFTQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:16:31 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:54657 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1DFTQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:16:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMC6nE2rRDoI/2dsb2JhbAClfXenQpxEhWwEhU6HboNj
X-IronPort-AV: E=Sophos;i="4.63,311,1299456000"; 
   d="scan'208";a="290702826"
Message-ID: <4D9CBC0B.5050602@cisco.com>
Date: Wed, 06 Apr 2011 13:16:27 -0600
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH] perf script: improve validation of sample attributes
 for output fields
References: <1301841300-14425-1-git-send-email-daahern@cisco.com> <20110406185827.GD4987@ghostprotocols.net>
In-Reply-To: <20110406185827.GD4987@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/06/11 12:58, Arnaldo Carvalho de Melo wrote:
> Em Sun, Apr 03, 2011 at 08:35:00AM -0600, David Ahern escreveu:
>> +++ b/tools/perf/builtin-script.c
>> @@ -94,41 +95,111 @@ static bool output_set_by_user(void)
>> +static const char *output_field2str(enum perf_output_field field)
>> +{
>> +	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
> 
> Use ARRAY_SIZE(all_output_options)
> 
>> +	for (i = 0; i < imax; ++i) {
>> +		if (all_output_options[i].field == field) {
>> +			str = all_output_options[i].str;
>> +			break;
> 
>> +static int perf_attr__check_stype(struct perf_event_attr *attr,
>> +				  u64 sample_type, const char *sample_msg,
>> +				  enum perf_output_field field)
> 
> s/perf_attr__check_stype/perf_event_attr__check_stype/g
> 
>> +	/* user did not ask for it explicitly so remove from the default list */
>> +	output[type].fields &= ~field;
>> +	evname = __event_name(attr->type, attr->config);
>> +	pr_debug("Samples for '%s' event do not have %s attribute set. "
>> +		 "Skipping '%s' field.\n",
>> +		 evname, sample_msg, output_field2str(field));
> 
> pr_warning?

In this case, it seems more like a debug. You have default options which
are not available for the specific perf.data file.


> 
>> +static int perf_evsel__check_attr(struct perf_session *session,
>> +				  struct perf_evsel *evsel)
> 
> for consistency, please make evsel the first parameter.
> 
>> +/* verify all user requested events exist and the samples
>> + * have the expected data
>> + */
>> +static int perf_session__check_output_opt(struct perf_session *session)
>> +{
>> +	int j;
>> +	struct perf_evsel *evsel;
>> +
>> +	for (j = 0; j < PERF_TYPE_MAX; ++j) {
>> +		evsel = perf_session__find_event(session, j);
> 
> You're nog finding an specific event, you're looking for the first event
> of type j, so I think perf_session__find_first_evtype is clearer.
> 
>> +
>> +		/* even if fields is set to 0 (ie., show nothing) event must
>> +		 * exist if user explicitly includes it on the command line
>> +		 */
> 
> Please use:
> 
> 		/*
>   		 * even if fields is set to 0 (ie., show nothing) event must
>   		 * exist if user explicitly includes it on the command line
>   		 */
> 
> There are other places like this, please fix those too.

Ok, I'll make the changes and resend.

David

> 
> - Arnaldo
