Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107Ab2ILBa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:30:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:32032 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968Ab2ILBa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,407,1344236400"; 
   d="scan'208";a="201908437"
Message-ID: <504FE5AB.4060406@intel.com>
Date: Wed, 12 Sep 2012 09:30:19 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] perf tool: Allow wildcard in PMU name
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com> <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com> <20120911140549.GC3800@krava.brq.redhat.com>
In-Reply-To: <20120911140549.GC3800@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 10:05 PM, Jiri Olsa wrote:
> On Mon, Sep 10, 2012 at 03:53:51PM +0800, Yan, Zheng wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
> 
> SNIP
> 
>> +int parse_events_add_pmu(struct list_head **_list, int *idx,
>>  			 char *name, struct list_head *head_config)
>>  {
>>  	struct perf_event_attr attr;
>> -	struct perf_pmu *pmu;
>> +	struct list_head *list;
>> +	struct perf_pmu *pmu = NULL;
>> +	struct perf_evsel *evsel, *first = NULL;
>> +	int orig_idx = *idx;
>>  
>> -	pmu = perf_pmu__find(name);
>> -	if (!pmu)
>> -		return -EINVAL;
>> +	list = malloc(sizeof(*list));
>> +	if (!list)
>> +		return -ENOMEM;
>> +	INIT_LIST_HEAD(list);
> 
> list should be allocated only if (!*_list)) same as in add_event function
> 
> I haven't test, but I think you'll leak/loose events if there's another pmu
> event defined after ','
> 

I think *_list is always NULL, because the code in parse-event.y is:

---
PE_NAME '/' event_config '/'
{
	struct parse_events_data__events *data = _data;
	struct list_head *list = NULL;

	ABORT_ON(parse_events_add_pmu(&list, &data->idx, $1, $3));
	parse_events__free_terms($3);
	$$ = list;
}

---

Regards
Yan, Zheng
