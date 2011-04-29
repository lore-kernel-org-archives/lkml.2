Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538Ab1D2Rdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:33:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760156Ab1D2Rdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:33:36 -0400
Date: Fri, 29 Apr 2011 14:33:32 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 1/2] perf probe: Fix the missed parameter
 initialization
Message-ID: <20110429173332.GA3273@ghostprotocols.net>
References: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
 <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 29, 2011 at 08:41:57AM +0000, Lin Ming escreveu:
> pubname_callback_param::found should be initialized to 0 in fastpath lookup.


Is this really needed? Or is this just to stress it, for documentational
purposes?
 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  tools/perf/util/probe-finder.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index a7c7145..3b9d0b8 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1538,6 +1538,7 @@ static int find_probes(int fd, struct probe_finder *pf)
>  			.file	  = pp->file,
>  			.cu_die	  = &pf->cu_die,
>  			.sp_die	  = &pf->sp_die,
> +			.found	  = 0,
>  		};
>  		struct dwarf_callback_param probe_param = {
>  			.data = pf,
> -- 
> 1.7.4.4
