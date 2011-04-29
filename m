Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab1D2NSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:18:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:26184 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919Ab1D2NSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:18:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,287,1301900400"; 
   d="scan'208";a="635834491"
Subject: Re: [RESEND PATCH 1/2] perf probe: Fix the missed parameter
 initialization
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110429094441.GA22092@elte.hu>
References: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
	 <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
	 <20110429094441.GA22092@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 21:18:15 +0800
Message-Id: <1304083095.2548.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 17:44 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > pubname_callback_param::found should be initialized to 0 in fastpath lookup.
> > 
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
> 
> Hm, why is this a 'misc cleanup'? If this field is uninitialized (it does 

I should call it 'misc cleanup and fix'.

> appear so) and we rely on the field then right now this is a bug and the fix 
> should be pushed to perf/urgent.

Indeed.

> 
> Thanks,
> 
> 	Ingo


