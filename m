Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0DUSXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:23:17 -0400
Received: from mail-pz0-f186.google.com ([209.85.222.186]:50904 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab0DUSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:23:14 -0400
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 4/4]-V3 Add MFD driver for TPS6507x family of multi-function chips and move TPS6507x regulator driver from being stand-alone to using the MFD driver.
References: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
	<1270520639-20516-2-git-send-email-todd.fischer@ridgerun.com>
	<1270520639-20516-3-git-send-email-todd.fischer@ridgerun.com>
	<1270520639-20516-4-git-send-email-todd.fischer@ridgerun.com>
	<1270520639-20516-5-git-send-email-todd.fischer@ridgerun.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 21 Apr 2010 11:23:09 -0700
In-Reply-To: <1270520639-20516-5-git-send-email-todd.fischer@ridgerun.com> (Todd Fischer's message of "Mon\,  5 Apr 2010 20\:23\:59 -0600")
Message-ID: <87633kacmq.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todd Fischer <todd.fischer@ridgerun.com> writes:

> Add MFD driver for TPS6507x family of multi-function chips.  Move TPS6507x 
> regulator driver from being stand-alone driver to using the MFD TPS6507x driver.
>
> Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>

[...]

Not sure whose tree this is queued in currently, but testing with
current davinci git, I had a compile problem...

> diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
> new file mode 100644
> index 0000000..5bca398
> --- /dev/null
> +++ b/drivers/mfd/tps6507x.c
> @@ -0,0 +1,155 @@
> +/*
> + * tps6507x.c  --  TPS6507x chip family multi-function driver
> + *
> + *  Copyright (c) 2010 RidgeRun (todd.fischer@ridgerun.com)
> + *
> + * Author: Todd Fischer
> + *         todd.fischer@ridgerun.com
> + *
> + * Credits:
> + *
> + *    Using code from wm831x-*.c, wm8400-core, Wolfson Microelectronics PLC.
> + *
> + * For licencing details see kernel-base/COPYING
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/tps6507x.h>

Need an #include <linux/slab.h> here for kfree and kzalloc

Kevin
