Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0CUBJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 21:09:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0CUBJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 21:09:12 -0400
X-Authority-Analysis: v=1.0 c=1 a=TaGW_cB_-KoA:10 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=q2TeAFTthi0JFQ_BphgA:9 a=-RYIg07D62xU3Dr0m4xLaCzLzoIA:4 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch v2] trace: find the correct ftrace event
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20100320143911.GF5331@bicker>
References: <20100320131923.GA20922@bicker>
	 <1269092233.28658.9.camel@localhost> <20100320135604.GA28881@bicker>
	 <1269094036.28658.12.camel@localhost>  <20100320143911.GF5331@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 21:09:10 -0400
Message-ID: <1269133750.5363.211.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 17:39 +0300, Dan Carpenter wrote:
> The original code doesn't work because "call" is never NULL there.                                                           
>                                                                                                                              
> Signed-off-by: Dan Carpenter <error27@gmail.com>     

Thanks, I'll apply and test this on Monday.

-- Steve

>                                                                         
> ---
> The original patch was fine, but this version is more tasteful.  ;)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 4615f62..c1a263a 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -1397,7 +1397,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
>  	}
>  
>  	err = -EINVAL;
> -	if (!call)
> +	if (&call->list == &ftrace_events)
>  		goto out_unlock;
>  
>  	err = -EEXIST;


