Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2GRGJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:09:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56026 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2GRGJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:09:18 -0400
Date: Tue, 17 Jul 2012 23:09:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/17] input/serio/hp_sdc.c: remove IRQF_SAMPLE_RANDOM
 which is now a no-op
Message-ID: <20120718060913.GA23668@core.coreip.homeip.net>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
 <1342560756-18737-3-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342560756-18737-3-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 05:32:21PM -0400, Theodore Ts'o wrote:
> With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> no-op; interrupt randomness is now collected unconditionally in a very
> low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> flag was scheduled to be removed in 2009 on the
> feature-removal-schedule, so this patch is preparation for the final
> removal of this flag.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I assume you'll be merging it through random tree with the rest of the
patches?

> ---
>  drivers/input/serio/hp_sdc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
> index 09a0899..d7a7e54 100644
> --- a/drivers/input/serio/hp_sdc.c
> +++ b/drivers/input/serio/hp_sdc.c
> @@ -878,7 +878,7 @@ static int __init hp_sdc_init(void)
>  #endif
>  
>  	errstr = "IRQ not available for";
> -	if (request_irq(hp_sdc.irq, &hp_sdc_isr, IRQF_SHARED|IRQF_SAMPLE_RANDOM,
> +	if (request_irq(hp_sdc.irq, &hp_sdc_isr, IRQF_SHARED,
>  			"HP SDC", &hp_sdc))
>  		goto err1;
>  
> -- 
> 1.7.11.1.108.gb129051
> 

-- 
Dmitry
