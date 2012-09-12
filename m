Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2ILJEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:04:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab2ILJEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:04:22 -0400
Date: Wed, 12 Sep 2012 11:03:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] perf tool: Allow wildcard in PMU name
Message-ID: <20120912090359.GA2882@krava.brq.redhat.com>
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
 <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com>
 <20120911140549.GC3800@krava.brq.redhat.com>
 <504FE5AB.4060406@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504FE5AB.4060406@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 09:30:19AM +0800, Yan, Zheng wrote:
> On 09/11/2012 10:05 PM, Jiri Olsa wrote:
> > On Mon, Sep 10, 2012 at 03:53:51PM +0800, Yan, Zheng wrote:
> >> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> >>
> > 
> > SNIP
> > 
> >> +int parse_events_add_pmu(struct list_head **_list, int *idx,
> >>  			 char *name, struct list_head *head_config)
> >>  {
> >>  	struct perf_event_attr attr;
> >> -	struct perf_pmu *pmu;
> >> +	struct list_head *list;
> >> +	struct perf_pmu *pmu = NULL;
> >> +	struct perf_evsel *evsel, *first = NULL;
> >> +	int orig_idx = *idx;
> >>  
> >> -	pmu = perf_pmu__find(name);
> >> -	if (!pmu)
> >> -		return -EINVAL;
> >> +	list = malloc(sizeof(*list));
> >> +	if (!list)
> >> +		return -ENOMEM;
> >> +	INIT_LIST_HEAD(list);
> > 
> > list should be allocated only if (!*_list)) same as in add_event function
> > 
> > I haven't test, but I think you'll leak/loose events if there's another pmu
> > event defined after ','
> > 
> 
> I think *_list is always NULL, because the code in parse-event.y is:
> 
> ---
> PE_NAME '/' event_config '/'
> {
> 	struct parse_events_data__events *data = _data;
> 	struct list_head *list = NULL;
> 
> 	ABORT_ON(parse_events_add_pmu(&list, &data->idx, $1, $3));
> 	parse_events__free_terms($3);
> 	$$ = list;
> }
> 
> ---
> 
> Regards
> Yan, Zheng

ouch, we update it in parse_events_update_lists.. then the '!list' check
is not needed.. I haven't realized we changed that, sry.

jirka
