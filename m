Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1CEIaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:30:05 -0500
Received: from ozlabs.org ([203.10.76.45]:43563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1CEIaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:30:04 -0500
Date: Sat, 5 Mar 2011 19:24:09 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 02/12] of: Allow scripts/dtc/libfdt to be used
 from kernel code
Message-ID: <20110305082409.GB3312@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
	ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
	grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
References: <1299267744-17278-1-git-send-email-ddaney@caviumnetworks.com>
 <1299267744-17278-3-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299267744-17278-3-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 11:42:14AM -0800, David Daney wrote:
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
[snip]
> --- /dev/null
> +++ b/lib/libfdt/libfdt_env.h
> @@ -0,0 +1,21 @@
> +#ifndef _LIBFDT_ENV_H
> +#define _LIBFDT_ENV_H
> +
> +#include <linux/string.h>
> +
> +#define _B(n)	((unsigned long long)((uint8_t *)&x)[n])
> +static inline uint32_t fdt32_to_cpu(uint32_t x)
> +{
> +	return (_B(0) << 24) | (_B(1) << 16) | (_B(2) << 8) | _B(3);
> +}
> +#define cpu_to_fdt32(x) fdt32_to_cpu(x)
> +
> +static inline uint64_t fdt64_to_cpu(uint64_t x)
> +{
> +	return (_B(0) << 56) | (_B(1) << 48) | (_B(2) << 40) | (_B(3) << 32)
> +		| (_B(4) << 24) | (_B(5) << 16) | (_B(6) << 8) | _B(7);
> +}
> +#define cpu_to_fdt64(x) fdt64_to_cpu(x)
> +#undef _B

Ah, yuck.  I only used those nasty macros in the userspace version of
libfdt_env.h because bytesex.h is such a portability nightmare.  The
kernel already has cpu_to_be{32,64}(), and the fdt byteswapping
functions should just be aliased to them.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
