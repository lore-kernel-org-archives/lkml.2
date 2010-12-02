Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0LBWqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:46:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:33202 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0LBWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:46:17 -0500
Date: Thu, 2 Dec 2010 20:46:10 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] perf: Prevent potential null dereference
Message-ID: <20101202224609.GA31473@ghostprotocols.net>
References: <20101202222605.GA6471@lenovo> <20101202224104.GA1639@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202224104.GA1639@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 02, 2010 at 11:41:08PM +0100, Frederic Weisbecker escreveu:
> On Fri, Dec 03, 2010 at 01:26:05AM +0300, Cyrill Gorcunov wrote:
> > In case if there is no memory we might hit null
> > dereference on accessing calloc'ed data.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> > 
> > It seems exit right here is more convenient than passing error
> > handling level up (which would have to exit anyway), thought
> > if handling it "upper" is preferred -- just say a word.
> > 
> >  tools/perf/builtin-record.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > Index: linux-2.6.git/tools/perf/builtin-record.c
> > =====================================================================
> > --- linux-2.6.git.orig/tools/perf/builtin-record.c
> > +++ linux-2.6.git/tools/perf/builtin-record.c
> > @@ -524,6 +524,10 @@ static void comm__construct(int argc, co
> >  		return;
> >  
> >  	comm = calloc(1, size);
> > +	if (!comm) {
> > +		pr_err("Not enough memory to construct internal command line.\n");
> > +		exit(-1);
> > +	}
> >  
> >  	tmp = comm;
> >  	for (i = 0; i < argc; i++) {
> 
> 
> Good.
> 
> As a nit, not that it matters that much because we are very close to the starting code
> anyway, but it would be better to propagate the error to the callers.

I'm of the opinion that main() should be where exit() is allowed, and
even there... return would be better. 8-)

- Arnaldo
