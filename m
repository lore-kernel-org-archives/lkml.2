Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab2ATD7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 22:59:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40953 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab2ATD7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 22:59:17 -0500
Date: Fri, 20 Jan 2012 04:59:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Don't call release_callchain_buffers if alloc
 fails
Message-ID: <20120120035910.GB18056@somewhere>
References: <1327021966-27688-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327021966-27688-1-git-send-email-namhyung.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 10:12:45AM +0900, Namhyung Kim wrote:
> When alloc_callchain_buffers() fails, it frees all of
> entries before return. In addition, calling the
> release_callchain_buffers() will cause a NULL pointer
> dereference since callchain_cpu_entries is not set.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> ---
>  kernel/events/callchain.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> index 057e24b665cf..6581a040f399 100644
> --- a/kernel/events/callchain.c
> +++ b/kernel/events/callchain.c
> @@ -115,8 +115,6 @@ int get_callchain_buffers(void)
>  	}
>  
>  	err = alloc_callchain_buffers();
> -	if (err)
> -		release_callchain_buffers();
>  exit:
>  	mutex_unlock(&callchain_mutex);
>  
> -- 
> 1.7.9.rc1.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
