Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1C2RxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:53:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1C2RxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:53:09 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=XYJHFtupD_QA:10 a=Lez6re_TyHsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=Vhb9xjdRlfbN_aQ6qmsA:9 a=aAIOTwyS6l3s9ZqWLjMA:7 a=bKXeFvWL9oNJCDBrDHfu91e_IaYA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 29 Mar 2011 13:53:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH]arch:Kconfig.locks Remove unused config option.
Message-ID: <20110329175302.GF8529@home.goodmis.org>
References: <1301416611-3651-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301416611-3651-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 09:36:51AM -0700, Justin P. Mattock wrote:
> using a cleanup script I found this, could be real/fake not sure
> I grepped the whole kernel and only found this. If/when you have
> time let me know..

This was added by: 36cd3c9f925b9307236505ae7ad1ad7ac4d4357c
mutex: have non-spinning mutexes on s390 by default

and removed by: fa188ae1657d6edc7963d524ce9a0650fe725242
[S390] mutex: enable spinning mutex on s390

So I think you are safe in removing it.

Thanks!

> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> ---
>  arch/Kconfig         |    3 ---
>  kernel/Kconfig.locks |    2 +-
>  2 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index f78c2be..8d24bac 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -144,9 +144,6 @@ config HAVE_CLK
>  config HAVE_DMA_API_DEBUG
>  	bool
>  
> -config HAVE_DEFAULT_NO_SPIN_MUTEXES
> -	bool
> -
>  config HAVE_HW_BREAKPOINT
>  	bool
>  	depends on PERF_EVENTS
> diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
> index 88c92fb..5e62baf 100644
> --- a/kernel/Kconfig.locks
> +++ b/kernel/Kconfig.locks
> @@ -199,4 +199,4 @@ config INLINE_WRITE_UNLOCK_IRQRESTORE
>  	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
>  
>  config MUTEX_SPIN_ON_OWNER
> -	def_bool SMP && !DEBUG_MUTEXES && !HAVE_DEFAULT_NO_SPIN_MUTEXES
> +	def_bool SMP && !DEBUG_MUTEXES 
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
