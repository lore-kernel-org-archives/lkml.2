Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2LUM6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:58:47 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59791 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2LUM6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:58:41 -0500
X-AuditID: 9c930179-b7becae000000e51-c4-50d45d00cf2f
Date: Fri, 21 Dec 2012 21:58:39 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools lib traceevent: remove redundant check from
 process_dynamic_array
Message-ID: <20121221125839.GB2973@danjae>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-5-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1356030701-16284-5-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 02:11:13PM -0500, Sasha Levin wrote:
> We check twice that 'field' is non-NULL, no need to do that.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  tools/lib/traceevent/event-parse.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 5a824e3..f7dc053 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -2481,11 +2481,6 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
>  
>  	free_token(token);
>  	arg = alloc_arg();
> -	if (!field) {

I think it should be 'if (!arg)' instead.

Thanks,
Namhyung


> -		do_warning("%s: not enough memory!", __func__);
> -		*tok = NULL;
> -		return EVENT_ERROR;
> -	}
>  
>  	type = process_arg(event, arg, &token);
>  	if (type == EVENT_ERROR)
> -- 
> 1.8.0
