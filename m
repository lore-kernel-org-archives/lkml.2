Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1LUJzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 04:55:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab1LUJzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 04:55:43 -0500
Date: Wed, 21 Dec 2011 10:55:20 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
Message-ID: <20111221095520.GA1726@m.redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
 <20111220173721.GB22107@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220173721.GB22107@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 03:37:22PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 15, 2011 at 04:30:37PM +0100, Jiri Olsa escreveu:
> > Changing event parsing to use flex/bison parse generator.
> > The event syntax stays as it is.
> 
> Seems really cool, using the right tool for the task, comments:
> 
> . Can we avoid more globals? Like that __event_list one.
ok, looks like there's a way to pass an parameter to the parse function,
I'll chec and make the change if possible


> . All those ABORT_ON do what? die() like stuff? /me googles YYABORT...
> 
> ----
> YYABORT
> Return immediately with value 1 (to report failure).
> ----
> 
> 	Ok, so it gets propagated back and hopefully the we die() just
> back at main() in tools/perf/perf.c, right?
right, it'll make parse_events_parse return error

> 
> . make help | perf
> 
> 	Then running one of those targets and trying to build perf still
> works? I guess so, but better check that.
> 
> 	Having it added to some new "make perf-test" that does that +
> 'perf test' too would get you brownie points. Leave it for later/someone
> else if you're busy/not looking for more work, of course 8-)
> 
> . We have some tests to parse events in 'perf test', right? From the top
> of my head it was even ya that did that, guess those are ok/improved
> (still need to look at the other patches in the backlog).
right ;)

thanks,
jirka
