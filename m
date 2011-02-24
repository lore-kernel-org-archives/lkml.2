Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab1BXTdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:33:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36384 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab1BXTdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:33:37 -0500
Message-ID: <4D66B236.4030003@ru.mvista.com>
Date: Thu, 24 Feb 2011 22:32:06 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] msm: scm: Get cacheline size from CTR
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org> <1298573085-23217-5-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1298573085-23217-5-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Stephen Boyd wrote:

> Instead of hardcoding the cacheline size as 32, get the cacheline
> size from the CTR register.

> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/scm.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
> index cfa808d..0528c71 100644
> --- a/arch/arm/mach-msm/scm.c
> +++ b/arch/arm/mach-msm/scm.c
[...]
> @@ -207,6 +204,14 @@ static int __scm_call(const struct scm_command *cmd)
>  	return ret;
>  }
>  
> +static inline u32 dcache_line_size(void)
> +{
> +	u32 ctr;
> +
> +	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
> +	return 4 << ((ctr >> 16) & 0xf);
> +}

    Won't generic cache_line_size() macro do instead? It's defined as 
L1_CACHE_BYTES.

WBR, Sergei
