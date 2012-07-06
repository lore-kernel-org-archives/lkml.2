Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2GFSMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:12:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2GFSMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:12:06 -0400
Date: Fri, 6 Jul 2012 14:14:32 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: fix segfault with info subcommand following
 move to libtraceevent
Message-ID: <20120706171431.GF7533@infradead.org>
References: <1341590538-19523-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341590538-19523-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 06, 2012 at 10:02:18AM -0600, David Ahern escreveu:
> +++ b/tools/perf/builtin-lock.c
> @@ -877,6 +877,9 @@ static int read_events(void)
>  	if (!session)
>  		die("Initializing perf session failed\n");
>  
> +	if (!perf_session__has_traces(session, "lock record"))
> +		exit(1);
> +
>  	return perf_session__process_events(session, &eops);
>  }

This is getting out of hand, first a die(), then an exit(1) and finally
this function returns a value, ouch.

I'd rather use return to signal that something went wrong and as well
print some helpful warning to the user.

Eventually we should fix all the other offenders, but lets try not to
add even more.

Can you please resend with a pr_warning + return failure?

- Arnaldo
