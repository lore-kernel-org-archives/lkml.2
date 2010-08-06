Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab0HFHSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:18:11 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56016 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab0HFHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:18:07 -0400
X-AuditID: b753bd60-a8cc1ba000005a63-d8-4c5bb72b16b9
Message-ID: <4C5BB727.80905@hitachi.com>
Date: Fri, 06 Aug 2010 16:17:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/2] [BUGFIX] perf probe: Fix to copy the type for raw
 parameters
References: <4C577AD8.50808@hitachi.com>
In-Reply-To: <4C577AD8.50808@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Copy type field if it is for raw parameters.
> Without this fix, perf probe drops the type if user passes it
> for raw parameters (e.g. %ax:u32 will be converted to %ax).

Hi Arnaldo,

Could you pick these patches?

Thank you,

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  tools/perf/util/probe-finder.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 840f1aa..b69d194 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -706,8 +706,12 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
>  		pf->tvar->value = strdup(pf->pvar->var);
>  		if (pf->tvar->value == NULL)
>  			return -ENOMEM;
> -		else
> -			return 0;
> +		if (pf->pvar->type) {
> +			pf->tvar->type = strdup(pf->pvar->type);
> +			if (pf->tvar->type == NULL)
> +				return -ENOMEM;
> +		}
> +		return 0;
>  	}
> 
>  	pr_debug("Searching '%s' variable in context.\n",
> 
> 

