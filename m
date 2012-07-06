Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2GFRqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:46:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40664 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab2GFRql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:46:41 -0400
Date: Fri, 6 Jul 2012 14:46:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: fix segfault with info subcommand following
 move to libtraceevent
Message-ID: <20120706174636.GC24429@infradead.org>
References: <1341590538-19523-1-git-send-email-dsahern@gmail.com>
 <20120706171431.GF7533@infradead.org>
 <4FF71DB5.5050104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF71DB5.5050104@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 06, 2012 at 11:17:41AM -0600, David Ahern escreveu:
> On 7/6/12 11:14 AM, Arnaldo Carvalho de Melo wrote:
> >Em Fri, Jul 06, 2012 at 10:02:18AM -0600, David Ahern escreveu:
> >>+++ b/tools/perf/builtin-lock.c
> >>@@ -877,6 +877,9 @@ static int read_events(void)
> >>  	if (!session)
> >>  		die("Initializing perf session failed\n");
> >>
> >>+	if (!perf_session__has_traces(session, "lock record"))
> >>+		exit(1);
> >>+
> >>  	return perf_session__process_events(session, &eops);
> >>  }
> >
> >This is getting out of hand, first a die(), then an exit(1) and finally
> >this function returns a value, ouch.
> >
> >I'd rather use return to signal that something went wrong and as well
> >print some helpful warning to the user.
> >
> >Eventually we should fix all the other offenders, but lets try not to
> >add even more.
> 
> Agree. But....
> 
> >
> >Can you please resend with a pr_warning + return failure?
> 
> 
> This command needs some love. The rc is not checked and requires
> some rework. e.g., the report path:
> 
>     setup_pager();
>     select_key();
>     read_events();    <---- the function I changed
>     sort_result();
>     print_result();
> 
> and the info path:
>         setup_pager();
>         read_events();
>         dump_info();
> 
> I figured for 3.5 at least not segfault; clean up for 3.6 or later.

Fair enough, so answering that other question, you want this for
perf/urgent.

Ok, queing it up for that branch,

- Arnaldo
