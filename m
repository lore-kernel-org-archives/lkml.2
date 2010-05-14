Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0ENQQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:16:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16958 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0ENQQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:16:35 -0400
Date: Fri, 14 May 2010 09:15:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 3/3] input: Default to only using PNP for i8042 probing
 on x86
Message-Id: <20100514091549.ff3cb4bc.randy.dunlap@oracle.com>
In-Reply-To: <1273853403-2870-3-git-send-email-mjg@redhat.com>
References: <1273853403-2870-1-git-send-email-mjg@redhat.com>
	<1273853403-2870-3-git-send-email-mjg@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4BED773A.0023:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 12:10:03 -0400 Matthew Garrett wrote:

> Experimenting with Windows has revealed that it will not probe the
> keyboard controller unless a valid PNPACPI device is present. Change our
> behaviour to match, and add a new i8042.forcedprobe parameter to allow
> people to override it.

and add that parameter to Documentation/kernel-parameters.txt, please.


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


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
