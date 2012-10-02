Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2JBNcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:32:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab2JBNcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:32:33 -0400
Date: Tue, 2 Oct 2012 15:32:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/14] perf hists: Separate overhead and baseline columns
Message-ID: <20121002133200.GD6379@krava.brq.redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
 <1348744175-11115-4-git-send-email-jolsa@redhat.com>
 <87zk4au1vy.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk4au1vy.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:56:01PM +0900, Namhyung Kim wrote:
> On Thu, 27 Sep 2012 13:09:24 +0200, Jiri Olsa wrote:
> > Currently the overhead and baseline columns are handled within
> > single function and the distinction is made by 'baseline hists'
> > pointer passed by 'struct perf_hpp::ptr'.
> >
> > Since hists pointer is now part of each hist_entry, it's possible
> > to locate paired hists pointer directly from the passed struct
> > hist_entry pointer.
> >
> > Also separating those 2 columns makes the code more obvious.
> 
> Yes, it was thinking about something like this.
> 
> 
> >
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> [snip]
> > +static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
> > +{
> > +	double percent = baseline_percent(he);
> > +
> > +	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
> 
> Is it possible to have a baseline value over 100%?  I changed 'overhead'
> colum format from '2 spaces + %5.2f + %' to '1 space + %6.2f + %' for
> the case.  Probably it'd better using it here too for consistency.

I think you're right, I'll make the change

thanks,
jirka
