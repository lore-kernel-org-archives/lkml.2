Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2GWSOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:14:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54074 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2GWSOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:14:05 -0400
Date: Mon, 23 Jul 2012 20:13:58 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120723181358.GC6717@infradead.org>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342826756-64663-9-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 20, 2012 at 05:25:53PM -0600, David Ahern escreveu:
> PEBS cannot be used with guest mode. If user adds :p modifier set
> exclude_guest as well.

Is this something Intel specific? Or can someone think of an arch where
this limitation wouldn't exist?
 
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Gleb Natapov <gleb@redhat.com>
> Link: https://lkml.org/lkml/2012/7/9/264
> ---
>  tools/perf/util/parse-events.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 1aa721d..f34629b 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -653,6 +653,9 @@ int parse_events_modifier(struct list_head *list, char *str)
>  			eH = 0;
>  		} else if (*str == 'p') {
>  			precise++;
> +			/* use of precise requires exclude_guest */
> +			if (!exclude_GH)
> +				eG = 1;
>  		} else
>  			break;
>  
> -- 
> 1.7.10.1
