Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0ISEwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:52:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50371 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0ISEwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rMUMN2VRf+ZogHjmKYY9tov2uUfSgkf75MubIJNoFBnywZstT29ElhvOxeo1koVKnY
         bv51fxsU+bLFomBkpUYduyS/Wi5FIbEmWkj+rxxkBKxAxfJUzvqP7zdLfXgco5lsO+eN
         BFgqCJYLBwJptvWFPFJoGomJrHMFNdR2XxeDY=
MIME-Version: 1.0
In-Reply-To: <4C8F39A6.10504@kernel.org>
References: <20100914002132.bf17c19e.sfr@canb.auug.org.au> <4C8F39A6.10504@kernel.org>
From: Matt Turner <mattst88@gmail.com>
Date: Sun, 19 Sep 2010 00:52:19 -0400
Message-ID: <AANLkTimsf03FvWeTV0mC=dX7vsH=6yihiXa5MH_raAw+@mail.gmail.com>
Subject: Re: [PATCH] alpha: fix build breakage in asm/cacheflush.h
To: Tejun Heo <tj@kernel.org>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 5:00 AM, Tejun Heo <tj@kernel.org> wrote:
> Alpha SMP flush_icache_user_range() is implemented as an inline
> function inside include/asm/cacheflush.h.  It dereferences @current
> but doesn't include linux/sched.h and thus causes build failure if
> linux/sched.h wasn't included previously.  Fix it by including the
> needed header file explicitly.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/alpha/include/asm/cacheflush.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/alpha/include/asm/cacheflush.h b/arch/alpha/include/asm/cacheflush.h
> index 01d71e1..012f124 100644
> --- a/arch/alpha/include/asm/cacheflush.h
> +++ b/arch/alpha/include/asm/cacheflush.h
> @@ -43,6 +43,8 @@ extern void smp_imb(void);
>  /* ??? Ought to use this in arch/alpha/kernel/signal.c too.  */
>
>  #ifndef CONFIG_SMP
> +#include <linux/sched.h>
> +
>  extern void __load_new_mm_context(struct mm_struct *);
>  static inline void
>  flush_icache_user_range(struct vm_area_struct *vma, struct page *page,

Thanks! Applied this to my tree and sent it to Linus.
