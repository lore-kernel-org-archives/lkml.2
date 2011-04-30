Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1D3EOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 00:14:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:31266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1D3EOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 00:14:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,292,1301900400"; 
   d="scan'208";a="636105208"
Subject: Re: [RESEND PATCH 1/2] perf probe: Fix the missed parameter
 initialization
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110429173332.GA3273@ghostprotocols.net>
References: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
	 <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
	 <20110429173332.GA3273@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 12:14:54 +0800
Message-Id: <1304136894.3761.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-30 at 01:33 +0800, Arnaldo Carvalho de Melo wrote:
> Em Fri, Apr 29, 2011 at 08:41:57AM +0000, Lin Ming escreveu:
> > pubname_callback_param::found should be initialized to 0 in fastpath lookup.
> 
> 
> Is this really needed? Or is this just to stress it, for documentational
> purposes?

Yes, this is really needed.

It should be initialized to 0, and pubname_search_cb will set it to 1 if
the function is found.

>  
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  tools/perf/util/probe-finder.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> > index a7c7145..3b9d0b8 100644
> > --- a/tools/perf/util/probe-finder.c
> > +++ b/tools/perf/util/probe-finder.c
> > @@ -1538,6 +1538,7 @@ static int find_probes(int fd, struct probe_finder *pf)
> >  			.file	  = pp->file,
> >  			.cu_die	  = &pf->cu_die,
> >  			.sp_die	  = &pf->sp_die,
> > +			.found	  = 0,
> >  		};
> >  		struct dwarf_callback_param probe_param = {
> >  			.data = pf,
> > -- 
> > 1.7.4.4


