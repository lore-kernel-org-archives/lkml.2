Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2IYLMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:12:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2IYLMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:12:10 -0400
Date: Tue, 25 Sep 2012 08:12:03 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 27/30] tools lib traceevent: Carve out events format
 parsing routine
Message-ID: <20120925111203.GB28902@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
 <1348502384-14442-28-git-send-email-acme@infradead.org>
 <878vbyybzq.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vbyybzq.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 01:15:05PM +0900, Namhyung Kim escreveu:
> On Mon, 24 Sep 2012 12:59:41 -0300, Arnaldo Carvalho de Melo wrote:
> > +	if (add_event(pevent, event))
> > +		goto event_add_failed;
 
> It seems we should set the 'ret' to a proper pevent_errno -
> PEVENT_ERRNO__MEM_ALLOC_FAILED.
 
> > +event_add_failed:
> > +	free(event->system);
> > +	free(event->name);
> > +	free(event);
> 
> At this point, the 'event' also has fields and format information and
> they all need to be freed.  Looks like calling pevent_free_format()
> would be the right thing IMHO.

Right, care to send a patch?

This patch even exported pevent_free_format, used in the next patch in
this series, should've used it here :-\

- Arnaldo
