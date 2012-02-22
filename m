Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2BVWWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:22:45 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62022 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab2BVWWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:22:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.227.36 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F456AAF.3090809@gmail.com>
Date: Thu, 23 Feb 2012 09:22:39 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v2 02/19] ARM: at91/at91x40: remove use of at91_sys_read/write
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <fac36a5ab9fe5a8bd977d2305eeccad48389cbb5.1329903206.git.nicolas.ferre@atmel.com>
In-Reply-To: <fac36a5ab9fe5a8bd977d2305eeccad48389cbb5.1329903206.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/12 20:39, Nicolas Ferre wrote:

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/at91x40.c              |    2 +-
>  arch/arm/mach-at91/at91x40_time.c         |   28 +++++++++++++++++-----------
>  arch/arm/mach-at91/include/mach/at91x40.h |   18 +++++++++---------
>  3 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
> index 0154b7f..5400a1d 100644
> --- a/arch/arm/mach-at91/at91x40.c
> +++ b/arch/arm/mach-at91/at91x40.c
> @@ -44,7 +44,7 @@ static void at91x40_idle(void)
>  	 * Disable the processor clock.  The processor will be automatically
>  	 * re-enabled by an interrupt or by a reset.
>  	 */
> -	at91_sys_write(AT91_PS_CR, AT91_PS_CR_CPU);
> +	__raw_writel(AT91_PS_CR_CPU, AT91_PS_CR);


This doesn't seem to be equivalent, at91_sys_write does:

  void __iomem *addr = (void __iomem *)AT91_VA_BASE_SYS;
  __raw_writel(value, addr + reg_offset);

and this patch doesn't redefine AT91_PS_CR. Was it broken before this
patch? What am I missing?

~Ryan
