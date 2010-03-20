Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0CTNhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:37:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0CTNhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:37:16 -0400
X-Authority-Analysis: v=1.0 c=1 a=owmX5hmkyK4A:10 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=xgg_VDsRRmxjk1H8i0QA:9 a=1oRrc4bDQxxQH5HmDkdKz7pmNcUA:4 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch] trace: find the correct ftrace event
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20100320131923.GA20922@bicker>
References: <20100320131923.GA20922@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 09:37:13 -0400
Message-ID: <1269092233.28658.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 16:19 +0300, Dan Carpenter wrote:
> The original code doesn't work because "call" is never NULL there.

A one line change would have done the same ;-)

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> My code should work, but it seems like there should but it seems like
> there should be a more elegant way to do this?
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 4615f62..6070c70 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -1388,16 +1388,19 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
>  	struct event_filter *filter;
>  	struct filter_parse_state *ps;
>  	struct ftrace_event_call *call = NULL;
> +	int found = 0;
>  
>  	mutex_lock(&event_mutex);
>  
>  	list_for_each_entry(call, &ftrace_events, list) {
> -		if (call->id == event_id)
> +		if (call->id == event_id) {
> +			found = 1;
>  			break;
> +		}
>  	}
>  
>  	err = -EINVAL;
> -	if (!call)

	if (call == &ftrace_events)

-- Steve

> +	if (!found)
>  		goto out_unlock;
>  
>  	err = -EEXIST;


