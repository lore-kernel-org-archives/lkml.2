Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0ENQcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:32:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47469 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0ENQcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MhRTvUWaEJY/PL3UndX56TAF6xK0zeqaReX7gvy+N3OjZazKHMX2P21sP1ZnNWXh6a
         GFXiv88DzOIY42fiEmdsqlXAHrIwex1NkKBGIy/kiRR9HChRGJQgz/uDqwCsMBoaKX+4
         1miPcZtDrvdlgKMjLdCz037ygQHE7JXjyQgco=
Date: Fri, 14 May 2010 09:31:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 3/3] input: Default to only using PNP for i8042 probing
 on x86
Message-ID: <20100514163158.GC31607@core.coreip.homeip.net>
References: <1273853403-2870-1-git-send-email-mjg@redhat.com>
 <1273853403-2870-3-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273853403-2870-3-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 12:10:03PM -0400, Matthew Garrett wrote:
> Experimenting with Windows has revealed that it will not probe the
> keyboard controller unless a valid PNPACPI device is present. Change our
> behaviour to match, and add a new i8042.forcedprobe parameter to allow
> people to override it.
> 

i8042.nopnp would not do?

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/input/serio/i8042-x86ia64io.h |    5 +++++
>  drivers/input/serio/i8042.c           |    3 +++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 6168469..2c5d9c0 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -1,6 +1,8 @@
>  #ifndef _I8042_X86IA64IO_H
>  #define _I8042_X86IA64IO_H
>  
> +#include <linux/acpi.h>
> +
>  /*
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License version 2 as published by
> @@ -747,6 +749,9 @@ static int __init i8042_pnp_init(void)
>  #if defined(__ia64__)
>  		return -ENODEV;
>  #else
> +		if (!acpi_disabled && !i8042_forceprobe)
> +			return -ENODEV;
> +
>  		printk(KERN_INFO "PNP: No PS/2 controller found. Probing ports directly.\n");
>  		return 0;
>  #endif
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index 6440a8f..413c5a6 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -75,6 +75,9 @@ MODULE_PARM_DESC(dritek, "Force enable the Dritek keyboard extension");
>  static bool i8042_nopnp;
>  module_param_named(nopnp, i8042_nopnp, bool, 0);
>  MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
> +static bool i8042_forceprobe;
> +module_param_named(forceprobe, i8042_forceprobe, bool, 0);
> +MODULE_PARM_DESC(forceprobe, "Force probing even if no PNP devices were found");
>  #endif
>  
>  #define DEBUG
> -- 
> 1.7.0.1
> 

-- 
Dmitry
