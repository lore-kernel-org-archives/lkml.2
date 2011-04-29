Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab1D2Joy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 05:44:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44398 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187Ab1D2Jow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 05:44:52 -0400
Date: Fri, 29 Apr 2011 11:44:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 1/2] perf probe: Fix the missed parameter
 initialization
Message-ID: <20110429094441.GA22092@elte.hu>
References: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
 <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> pubname_callback_param::found should be initialized to 0 in fastpath lookup.
> 
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

Hm, why is this a 'misc cleanup'? If this field is uninitialized (it does 
appear so) and we rely on the field then right now this is a bug and the fix 
should be pushed to perf/urgent.

Thanks,

	Ingo
