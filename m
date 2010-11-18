Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab0KRPjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:39:19 -0500
Received: from imr4.ericy.com ([198.24.6.8]:49622 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759181Ab0KRPjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:39:18 -0500
Date: Thu, 18 Nov 2010 07:38:56 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Davide Rizzo <elpa.rizzo@gmail.com>
CC: LM Sensors <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: (lm95241) Rewritten without using macros
Message-ID: <20101118153856.GA27671@ericsson.com>
References: <AANLkTi=n7f_40ZdLBd4rYC-PgVABHp_gEWKm264n=yjC@mail.gmail.com>
 <1289340866.22931.304.camel@groeck-laptop>
 <AANLkTinEzMPxEnrEY5K8u5qLkQutU0vdRh_vOGU=QOCF@mail.gmail.com>
 <20101116150305.GA4442@ericsson.com>
 <AANLkTikQ9X0ntcBfD391zsyAZ1BfCCD1-DcKBb-O8kJn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTikQ9X0ntcBfD391zsyAZ1BfCCD1-DcKBb-O8kJn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On Wed, Nov 17, 2010 at 06:05:43AM -0500, Davide Rizzo wrote:
> > Removing the above includes violates SubmitChecklist rule #1. Also, please reparent to Linus'
> > latest tree.
> >
> > Other than that, there are a only few formatting issues, but I can take care of those myself.
> > So please re-submit with the above changes, and we should be ready to go.
> >
> > Thanks,
> > Guenter
> 
> Here it is as requested.
> Regards,
> Davide Rizzo
> 
> From: Davide Rizzo <elpa.rizzo@gmail.com<mailto:elpa.rizzo@gmail.com>>
> 
> Rewriting of driver/hwmon/lm95241.c to avoid using macros
> 
> Signed-off-by: Davide Rizzo <elpa.rizzo@gmail.com<mailto:elpa.rizzo@gmail.com>>
> ---
> --- linux-2.6.37-rc2/drivers/hwmon/lm95241.c    2010-11-16 03:31:02.000000000 +0100
> +++ linux-2.6.37-rc2.elpa/drivers/hwmon/lm95241.c       2010-11-17
> 11:47:21.911752940 +0100

Looks like you still have trouble with line wraps. You might want to get this fixed; 
having to figure out why the patch does not apply is a bit annoying.

> @@ -1,13 +1,9 @@
>  /*
> - * lm95241.c - Part of lm_sensors, Linux kernel modules for hardware
> - *             monitoring
> - * Copyright (C) 2008 Davide Rizzo <elpa-rizzo@gmail.com>
> + * Copyright (C) 2008, 2010 Davide Rizzo <elpa.rizzo@gmail.com>
>   *
> - * Based on the max1619 driver. The LM95241 is a sensor chip made by National
> - *   Semiconductors.
> - * It reports up to three temperatures (its own plus up to
> - * two external ones). Complete datasheet can be
> - * obtained from National's website at:
> + * The LM95241 is a sensor chip made by National Semiconductors.
> + * It reports up to three temperatures (its own plus up to two external ones).
> + * Complete datasheet can be obtained from National's website at:
>   *   http://www.national.com/ds.cgi/LM/LM95241.pdf
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -27,14 +23,17 @@
> 
>  #include <linux/module.h>
>  #include <linux/init.h>
> -#include <linux/slab.h>
>  #include <linux/jiffies.h>
> +#include <linux/mutex.h>
> +#include <linux/sysfs.h>
> +
> +#include <linux/slab.h>
>  #include <linux/i2c.h>
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/err.h>
> -#include <linux/mutex.h>
> -#include <linux/sysfs.h>
> +

Moving include statements around is just a whitespace change and should be avoided.
Also, you added a blank line at the end of the file which causes a git whitespace error
when applying the patch.

No need to retransmit. I fixed both and applied the patch with a couple of additional
formatting changes to make the file checkpatch clean.

Thanks,
Guenter

