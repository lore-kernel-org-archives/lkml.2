Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1BYMSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:18:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38948 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158Ab1BYMSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:18:04 -0500
X-Greylist: delayed 1259 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Feb 2011 07:18:04 EST
Subject: Re: [PATCH 1/4] msm: scm: Mark inline asm as volatile
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1298573085-23217-2-git-send-email-sboyd@codeaurora.org>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
	 <1298573085-23217-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 11:56:57 +0000
Message-ID: <1298635017.958.0.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 2011-02-24 at 18:44 +0000, Stephen Boyd wrote:
> We don't want the compiler to remove these asm statements or
> reorder them in any way. Mark them as volatile to be sure.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/scm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
> index f4b9bc9..ba57b5a 100644
> --- a/arch/arm/mach-msm/scm.c
> +++ b/arch/arm/mach-msm/scm.c
> @@ -174,7 +174,7 @@ static u32 smc(u32 cmd_addr)
>         register u32 r0 asm("r0") = 1;
>         register u32 r1 asm("r1") = (u32)&context_id;
>         register u32 r2 asm("r2") = cmd_addr;
> -       asm(
> +       asm volatile(
>                 __asmeq("%0", "r0")
>                 __asmeq("%1", "r0")
>                 __asmeq("%2", "r1")
> @@ -271,7 +271,7 @@ u32 scm_get_version(void)
>                 return version;
> 
>         mutex_lock(&scm_lock);
> -       asm(
> +       asm volatile(
>                 __asmeq("%0", "r1")
>                 __asmeq("%1", "r0")
>                 __asmeq("%2", "r1")


These asm blocks all have sensible looking output constraints. Why
do they need to be marked volatile?

Will


