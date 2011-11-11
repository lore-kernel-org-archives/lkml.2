Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab1KKPsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:48:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:63269 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab1KKPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:48:36 -0500
Message-ID: <4EBD43BB.8090903@windriver.com>
Date: Fri, 11 Nov 2011 10:48:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Liu Gang <Gang.Liu@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>
Subject: Re: [PATCH] fsl-rio: fix compile error
References: <1321019308-7785-1-git-send-email-Gang.Liu@freescale.com>
In-Reply-To: <1321019308-7785-1-git-send-email-Gang.Liu@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-11 08:48 AM, Liu Gang wrote:
> The "#include <linux/module.h>" was replaced by "#include <linux/export.h>"
> in the patch "powerpc: various straight conversions from module.h --> export.h".
> This will cause the following compile problem:
> arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
> arch/powerpc/sysdev/fsl_rio.c:296: error: implicit declaration of function 'search_exception_tables'.
> 
> The file fsl_rio.c needs the declaration of function "search_exception_tables"
> in the header file "linux/module.h".

Thanks -- not sure why this never showed up in my builds of all the
powerpc configs, _or_ the linux-next builds.  Maybe srio isn't enabled
in any of them? 

In any case it looks fine to me.  Having the search_exception_tables
live in module.h seems odd, but that is an independent issue for later.

I can queue this unless someone else has already done so.

Paul.

> 
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
>  arch/powerpc/sysdev/fsl_rio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
> index de170fd..22ffccd 100644
> --- a/arch/powerpc/sysdev/fsl_rio.c
> +++ b/arch/powerpc/sysdev/fsl_rio.c
> @@ -23,7 +23,7 @@
>   */
>  
>  #include <linux/init.h>
> -#include <linux/export.h>
> +#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/interrupt.h>
