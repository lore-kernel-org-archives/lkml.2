Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab0CTHMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 03:12:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18042 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab0CTHMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 03:12:12 -0400
X-IronPort-AV: E=Sophos;i="4.51,278,1267419600"; 
   d="scan'208";a="88879747"
Subject: Re: [PATCH -v6] x86: do not free zero sized per cpu areas
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4BA46D66.3050306@kernel.org>
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org>
	 <4BA3F8ED.2090600@zytor.com> <4BA407B8.7070503@kernel.org>
	 <4BA408EE.5000001@zytor.com> <4BA40C83.1030202@kernel.org>
	 <alpine.LFD.2.00.1003191758460.18017@i5.linux-foundation.org>
	 <4BA42C05.3060800@kernel.org>
	 <alpine.LFD.2.00.1003191940060.18017@i5.linux-foundation.org>
	 <4BA46D66.3050306@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Sat, 20 Mar 2010 07:12:08 +0000
Message-ID: <1269069128.28761.40.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me, thanks Yinghai.

On Sat, 2010-03-20 at 06:38 +0000, Yinghai Lu wrote: 
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


