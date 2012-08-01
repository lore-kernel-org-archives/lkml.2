Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2HAOZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:25:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24726 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2HAOZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:25:51 -0400
Date: Wed, 1 Aug 2012 10:16:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH 05/24] xen/arm: empty implementation of grant_table arch
 specific functions
Message-ID: <20120801141624.GD7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316846-25860-5-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:33:47PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/Makefile      |    2 +-
>  arch/arm/xen/grant-table.c |   53 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/xen/grant-table.c
> 
> diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
> index b9d6acc..4384103 100644
> --- a/arch/arm/xen/Makefile
> +++ b/arch/arm/xen/Makefile
> @@ -1 +1 @@
> -obj-y		:= enlighten.o hypercall.o
> +obj-y		:= enlighten.o hypercall.o grant-table.o
> diff --git a/arch/arm/xen/grant-table.c b/arch/arm/xen/grant-table.c
> new file mode 100644
> index 0000000..0a4ee80
> --- /dev/null
> +++ b/arch/arm/xen/grant-table.c
> @@ -0,0 +1,53 @@
> +/******************************************************************************
> + * grant_table.c
> + * ARM specific part
> + *
> + * Granting foreign access to our memory reservation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation; or, when distributed
> + * separately from the Linux kernel or incorporated into other
> + * software packages, subject to the following license:
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this source file (the "Software"), to deal in the Software without
> + * restriction, including without limitation the rights to use, copy, modify,
> + * merge, publish, distribute, sublicense, and/or sell copies of the Software,
> + * and to permit persons to whom the Software is furnished to do so, subject to
> + * the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
> + * IN THE SOFTWARE.
> + */
> +
> +#include <xen/interface/xen.h>
> +#include <xen/page.h>
> +#include <xen/grant_table.h>
> +
> +int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
> +			   unsigned long max_nr_gframes,
> +			   void **__shared)
> +{
> +	return -1;

-ENOSYS
> +}
> +
> +void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
> +{
> +	return;
> +}
> +
> +int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
> +			   unsigned long max_nr_gframes,
> +			   grant_status_t **__shared)
> +{
> +	return -1;

Same here -ENOSYS
> +}
> -- 
> 1.7.2.5
