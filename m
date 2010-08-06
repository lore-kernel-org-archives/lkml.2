Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849Ab0HFBOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:14:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2291 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab0HFBOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:14:09 -0400
Subject: Re: [PATCH 3/3] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Joe Perches <joe@perches.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281018316-1466-4-git-send-email-maximlevitsky@gmail.com>
References: <1281018316-1466-1-git-send-email-maximlevitsky@gmail.com>
	 <1281018316-1466-4-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 18:14:06 -0700
Message-ID: <1281057246.19943.20.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 17:25 +0300, Maxim Levitsky wrote:
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Trivial comments:

> ---
>  MAINTAINERS                    |    6 +
> +RICOH R5C592 MEMORYSTICK DRIVER
> +M:	Maxim Levitsky <maximlevitsky@gmail.com>
> +S:	Maintained
> +F:	drivers/memstick/host/r592.c
> +F:	drivers/memstick/host/r592.h

Patterns in maintainers can use wildcards

F:	drivers/memstick/host/r592*

> --- /dev/null
> +++ b/drivers/memstick/host/r592.c
> @@ -0,0 +1,889 @@
[]
> +static char *tpc_names[] = {

const ?

> +	"MS_TPC_READ_MG_STATUS",
> +	"MS_TPC_READ_LONG_DATA",

[]

> +#define dbg(format, ...) \
> +	if (debug) \
> +		printk(KERN_DEBUG DRV_NAME ": " format "\n", ## __VA_ARGS__)
> +
> +#define dbg_verbose(format, ...) \
> +	if (debug > 1) \
> +		printk(KERN_DEBUG DRV_NAME ": " format "\n", ## __VA_ARGS__)
> +
> +#define dbg_reg(format, ...) \
> +	if (debug > 2) \
> +		printk(KERN_DEBUG DRV_NAME ": " format "\n", ## __VA_ARGS__)
> +

These style macros should use do { if (test) print(); } while (9)
so they could be used without problems in if/else blocks.
 
Maybe it'd be better to have and use 1 macro with a level passed:

#define dbg(level, format, ...)						\
do {									\
	if (debug > level)						\
		printk(KERN_DEBUG pr_fmt(format), ##__VA_ARGS__);	\
} while (0)

> +#define message(format, ...) \
> +	printk(KERN_INFO DRV_NAME ": " format "\n", ## __VA_ARGS__)

Why not just use pr_info?


