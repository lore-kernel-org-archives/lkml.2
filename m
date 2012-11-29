Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2K2Lye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:54:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab2K2Lyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:54:31 -0500
Date: Thu, 29 Nov 2012 12:53:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/14] perf tool: Fix period symbol_conf.field_sep display
Message-ID: <20121129115344.GB1096@krava.brq.redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
 <1354110769-2998-4-git-send-email-jolsa@redhat.com>
 <878v9kq1uz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v9kq1uz.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 04:56:04PM +0900, Namhyung Kim wrote:
> On Wed, 28 Nov 2012 14:52:38 +0100, Jiri Olsa wrote:
> > Currently we don't properly display hist data with
> > symbol_conf.field_sep separator. We need to display
> > either space or separator.
> >
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/ui/hist.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> > index 5452960..20a4392 100644
> > --- a/tools/perf/ui/hist.c
> > +++ b/tools/perf/ui/hist.c
> > @@ -523,17 +523,13 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
> >  	struct perf_hpp_fmt *fmt;
> >  	char *start = hpp->buf;
> >  	int ret;
> > -	bool first = true;
> >  
> >  	if (symbol_conf.exclude_other && !he->parent)
> >  		return 0;
> >  
> >  	perf_hpp__for_each_format(fmt) {
> > -		if (!sep || !first) {
> > -			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
> > -			advance_hpp(hpp, ret);
> > -			first = false;
> > -		}
> > +		ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
> > +		advance_hpp(hpp, ret);
> 
> It will display the separator even before the first column so that the
> output can be messed up with this.  I can see that there's a bug setting
> 'first' to false - the line should be moved out of the block otherwise
> it's pointless since we cannot enter the block.

hum, I'll retest

thanks,
jirka
