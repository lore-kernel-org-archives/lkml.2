Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab1FVRxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:53:00 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:36842
	"EHLO CH1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758464Ab1FVRw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:52:58 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 22 Jun 2011 12:52:52 -0500
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] driver core: Add ability for arch code to setup
 pdev_archdata
Message-ID: <20110622125252.66eceb46@schlenkerla.am.freescale.net>
In-Reply-To: <1308755396-17988-1-git-send-email-galak@kernel.crashing.org>
References: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org>
	<1308755396-17988-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 10:09:56 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 1c291af..c25e0c0 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -20,6 +20,7 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
> +#include <asm/platform_device.h>
>  
>  #include "base.h"
>  
> @@ -173,6 +174,7 @@ struct platform_device *platform_device_alloc(const char *name, int id)
>  		pa->pdev.id = id;
>  		device_initialize(&pa->pdev.dev);
>  		pa->pdev.dev.release = platform_device_release;
> +		arch_setup_pdev_archdata(&pa->pdev);
>  	}
>  
>  	return pa ? &pa->pdev : NULL;

Need to call this from platform_device_register() as well, for devices
which are not dynamically allocated.

> +/*
> + * an architecture can override to define arch_setup_pdev_archdata
> + */
> +#ifndef arch_setup_pdev_archdata
> +static inline void arch_setup_pdev_archdata(struct platform_device *pdev) { }
> +#endif

That's not a particularly useful comment.  More useful would be a statement
of when this hook is called, examples of what it's meant to be used for,
etc.

-Scott

