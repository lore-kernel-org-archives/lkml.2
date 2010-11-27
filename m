Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0K0ASe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 19:18:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:43909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0K0ASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 19:18:33 -0500
Date: Fri, 26 Nov 2010 22:18:17 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 2/5] perf events: Default to using event__process_lost
Message-ID: <20101127001817.GA17400@ghostprotocols.net>
References: <1290808041-16535-1-git-send-email-acme@infradead.org> <1290808041-16535-3-git-send-email-acme@infradead.org> <alpine.LFD.2.00.1011270042520.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011270042520.2900@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Nov 27, 2010 at 12:55:24AM +0100, Thomas Gleixner escreveu:
> On Fri, 26 Nov 2010, Arnaldo Carvalho de Melo wrote:
> 
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Tool developers have to fill in a 'perf_event_ops' method table to
> > specify how to handle each event, so far the ones that were not
> > explicitely especified would get a stub that would just discard the
> > event.
> > 
> > Change that so that tool developers can get the lost event details and
> > the total number of such events at the end of 'perf report -D' output.
> 
> That should be always displayed if the subcommand does not have it's
> own lost event handling. I stared long enough into the wrong place,
> just because the stupid thing just was silent about it. And with this
> patch it's still silent for the normal use case.

Will make it holler if perf_event_ops->lost == event__process_lost and
self->hists.stats.total_lost != 0, as you suggest.
 
> We really want to tell the user when something went wrong. Users do
> not run perf report -D when the tool shows fancy events, why should
> they? Just because they know that the tool is hiding problems? If
> that's the case then the trust into perf tools is about 0.
> 
> Darn, being silent about a known problem is the most stupid error
> handling ever.
> 
> That's what I added at the end of perf_session__process_events()
> 
> +	if (self->hists.stats.total_lost)
> +		fprintf(stderr, "Lost events. Check IO/CPU overload!\n");
> 
> It's hacky, but it does the job and tells me clearly that the trace is
> only halfways useful.

Ok, will implement it like you suggested, in a followon patch, in both
the --stdio and --tui modes.

- Arnaldo
