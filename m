Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2EaRAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:00:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2EaRAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:00:24 -0400
Message-ID: <1338483600.28384.66.camel@twins>
Subject: Re: [PATCH 1/3] perf: Remove duplicate invocation on
 perf_event_for_each
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 31 May 2012 19:00:00 +0200
In-Reply-To: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
References: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 14:51 +0900, Namhyung Kim wrote:
> The @func callback was invoked twice for group leader
> when perf_event_for_each() called. It seems the commit
> 75f937f24bd9 ("perf_counter: Fix ctx->mutex vs counter
> ->mutex inversion") made the mistake during the change.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>

Good spotting, thanks!

> ---
>  kernel/events/core.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 5b06cbbf6931..f85c0154b333 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3181,7 +3181,6 @@ static void perf_event_for_each(struct perf_event *event,
>  	event = event->group_leader;
>  
>  	perf_event_for_each_child(event, func);
> -	func(event);
>  	list_for_each_entry(sibling, &event->sibling_list, group_entry)
>  		perf_event_for_each_child(sibling, func);
>  	mutex_unlock(&ctx->mutex);

