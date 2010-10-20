Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab0JTHmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:42:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:23908 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab0JTHmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:42:22 -0400
Date: Wed, 20 Oct 2010 09:42:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
Message-ID: <20101020094208.3136b9dd@endymion.delvare>
In-Reply-To: <1287530020.10409.594.camel@Joe-Laptop>
References: <1287530020.10409.594.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 19 Oct 2010 16:13:40 -0700, Joe Perches wrote:
> Convert printks to pr_<level>
> Coalesce long formats
> Removed prefixes from formats
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Standardized abitguru messages for reporting and finding MAINTAINER
> (...)
> diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
> index 03694cc..8f07a9d 100644
> --- a/drivers/hwmon/abituguru.c
> +++ b/drivers/hwmon/abituguru.c
> @@ -20,6 +20,9 @@
>      the custom Abit uGuru chip found on Abit uGuru motherboards. Note: because
>      of lack of specs the CPU/RAM voltage & frequency control is not supported!
>  */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>

It looks odd that every driver would have to set this. Shouldn't this
be the default set in <linux/kernel.h>? Something like:

#ifndef pr_fmt
#ifdef KBUILD_MODNAME
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
#else
#define pr_fmt(fmt) fmt
#endif /* KBUILD_MODNAME */
#endif

Overall I like this cleanup patch, but the addition of #define pr_fmt
to every driver looks plain wrong.

I'll review the rest of the patch(es) once this point is sorted out.

-- 
Jean Delvare
