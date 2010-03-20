Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab0CTVwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 17:52:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58576 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0CTVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 17:52:21 -0400
X-Authority-Analysis: v=1.0 c=1 a=d0FnPKeSovcA:10 a=IkcTkHD0fZMA:10 a=D19gQVrFAAAA:8 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=nzjOwup3y9Dx0Z0um4YA:9 a=PW9lE0IWkD-WOXem4ucA:7 a=x58srdDR-dDVQpUdiqY0RyFapbEA:4 a=QEXdDO2ut3YA:10 a=x8gzFH9gYPwA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] kconfig: recalc symbol value before showing search
 results
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <4BA3206B.9020405@cn.fujitsu.com>
References: <4BA3206B.9020405@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 17:52:16 -0400
Message-ID: <1269121936.5363.199.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-19 at 14:57 +0800, Li Zefan wrote:
> A symbol's value won't be recalc-ed until we save config file or
> enter the menu where the symbol sits.
> 
> So If I enable OPTIMIZE_FOR_SIZE, and search FUNCTION_GRAPH_TRACER:
> 
>   Symbol: FUNCTION_GRAPH_TRACER [=y]
>   Prompt: Kernel Function Graph Tracer
>     Defined at kernel/trace/Kconfig:140
>     Depends on: ... [=y] && (!X86_32 [=y] || !CC_OPTIMIZE_FOR_SIZE [=y])

[ off topic ]

I'm not sure we need that anymore. I think Thomas added a patch that can
disable the cases that gcc causes the function graph to fail.

I pushed a patch before that also runs a check at compile time to make
sure that gcc does not produce a bad mcount setup that would screw up
the function graph tracer.

http://lkml.org/lkml/2009/11/20/2

It probably still makes sense to add it.

-- Steve

>     ...
> 
> >From the dependency it should result in FUNCTION_GRAPH_TRACER=n,
> but it still shows FUNCTION_GRAPH_TRACER=y.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  scripts/kconfig/symbol.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index 6c8fbbb..dfef8d1 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -750,6 +750,7 @@ struct symbol **sym_re_search(const char *pattern)
>  				return NULL;
>  			}
>  		}
> +		sym_calc_value(sym);
>  		sym_arr[cnt++] = sym;
>  	}
>  	if (sym_arr)
> -- 1.6.3 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


