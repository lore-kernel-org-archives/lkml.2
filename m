Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1JXWKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:10:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54834 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab1JXWKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:10:07 -0400
Date: Tue, 25 Oct 2011 00:10:04 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] h8300: Move gpio.h to gpio-internal.h
Message-ID: <20111024221004.GE4394@ponder.secretlab.ca>
References: <1319493561-4094-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319493561-4094-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:59:21PM +0200, Mark Brown wrote:
> The current h8300 GPIO implementation doesn't provide the standard GPIO
> API, and in fact provides only direction control rather than normal GPIO
> functionality. Currently this is only used by the platform interrupt
> implementation rather than by a range of drivers so in preparation for
> moving over to gpiolib move the header out of the way of the gpiolib
> header, allowing a default GPIO implementation to be provided.
> 
> For actual use of these GPIOs with gpiolib a real driver would still need
> to be written but there appears to be no current need for this.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

This of course should go via the h8300 tree instead of the gpio tree.

g.

> ---
> 
> It might be best to merge this via the gpiolib tree, partly because
> there appears to be little other activity on h8300 right now and partly
> to allow further refactoring.
> 
>  arch/h8300/include/asm/{gpio.h => gpio-internal.h} |    0
>  arch/h8300/platform/h8300h/irq.c                   |    2 +-
>  arch/h8300/platform/h8s/irq.c                      |    2 +-
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename arch/h8300/include/asm/{gpio.h => gpio-internal.h} (100%)
> 
> diff --git a/arch/h8300/include/asm/gpio.h b/arch/h8300/include/asm/gpio-internal.h
> similarity index 100%
> rename from arch/h8300/include/asm/gpio.h
> rename to arch/h8300/include/asm/gpio-internal.h
> diff --git a/arch/h8300/platform/h8300h/irq.c b/arch/h8300/platform/h8300h/irq.c
> index e977345..bc4f51b 100644
> --- a/arch/h8300/platform/h8300h/irq.c
> +++ b/arch/h8300/platform/h8300h/irq.c
> @@ -11,7 +11,7 @@
>  #include <asm/traps.h>
>  #include <asm/irq.h>
>  #include <asm/io.h>
> -#include <asm/gpio.h>
> +#include <asm/gpio-internal.h>
>  #include <asm/regs306x.h>
>  
>  const int __initdata h8300_saved_vectors[] = {
> diff --git a/arch/h8300/platform/h8s/irq.c b/arch/h8300/platform/h8s/irq.c
> index 8182f04..7b5f29f 100644
> --- a/arch/h8300/platform/h8s/irq.c
> +++ b/arch/h8300/platform/h8s/irq.c
> @@ -14,7 +14,7 @@
>  #include <asm/traps.h>
>  #include <asm/irq.h>
>  #include <asm/io.h>
> -#include <asm/gpio.h>
> +#include <asm/gpio-internal.h>
>  #include <asm/regs267x.h>
>  
>  /* saved vector list */
> -- 
> 1.7.6.3
> 
