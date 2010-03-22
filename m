Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0CVSG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:06:29 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:38863 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0CVSG1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 22 Mar 2010 14:06:27 -0400
Date: Mon, 22 Mar 2010 13:30:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [LKML] [PATCH -v6] x86: do not free zero sized per cpu areas
Message-ID: <20100322173038.GA16353@phenom.dumpdata.com>
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org> <4BA3F8ED.2090600@zytor.com> <4BA407B8.7070503@kernel.org> <4BA408EE.5000001@zytor.com> <4BA40C83.1030202@kernel.org> <alpine.LFD.2.00.1003191758460.18017@i5.linux-foundation.org> <4BA42C05.3060800@kernel.org> <alpine.LFD.2.00.1003191940060.18017@i5.linux-foundation.org> <4BA46D66.3050306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA46D66.3050306@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BA7B0B2.00F1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 11:38:30PM -0700, Yinghai Lu wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> This avoids an infinite loop in free_early_partial().
> 
> Add a warning to free_early_partial to catch future problems.
> 
> -v5: put back start > end back into WARN_ONCE()
> -v6: use one line for if according to linus
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
>  kernel/early_res.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6/kernel/early_res.c
> ===================================================================
> --- linux-2.6.orig/kernel/early_res.c
> +++ linux-2.6/kernel/early_res.c
> @@ -333,6 +333,12 @@ void __init free_early_partial(u64 start
>  	struct early_res *r;
>  	int i;
>  
> +	if (start == end)
> +		return;
> +
> +	if (WARN_ONCE(start > end, "free_early_partial: wrong range [%#llx, %#llx]\n", start, end))
> +		return;
> +
>  try_next:
>  	i = find_overlapped_early(start, end);
>  	if (i >= max_early_res)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
