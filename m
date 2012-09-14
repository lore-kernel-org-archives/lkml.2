Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2INNXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:23:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45204 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2INNXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:23:45 -0400
Date: Fri, 14 Sep 2012 09:12:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, axboe@kernel.dk
Cc: arnd@arndb.de, linux@arm.linux.org.uk, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        tim@xen.org, Ian.Campbell@citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 19/24] xen/arm: compile blkfront and blkback
Message-ID: <20120914131242.GN25249@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
 <1347621207-11294-19-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347621207-11294-19-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:13:21PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

So this should go through Jen's tree or at least get his Ack.
But doing all of these patches seperatly is painfull - and remembering
where they go is a bit of logistical nightmare.

Jen, are you OK with this patch?
> ---
>  drivers/block/xen-blkback/blkback.c  |    1 +
>  include/xen/interface/io/protocols.h |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 73f196c..63dd5b9 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -42,6 +42,7 @@
>  
>  #include <xen/events.h>
>  #include <xen/page.h>
> +#include <xen/xen.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
>  #include "common.h"
> diff --git a/include/xen/interface/io/protocols.h b/include/xen/interface/io/protocols.h
> index 01fc8ae..0eafaf2 100644
> --- a/include/xen/interface/io/protocols.h
> +++ b/include/xen/interface/io/protocols.h
> @@ -5,6 +5,7 @@
>  #define XEN_IO_PROTO_ABI_X86_64     "x86_64-abi"
>  #define XEN_IO_PROTO_ABI_IA64       "ia64-abi"
>  #define XEN_IO_PROTO_ABI_POWERPC64  "powerpc64-abi"
> +#define XEN_IO_PROTO_ABI_ARM        "arm-abi"
>  
>  #if defined(__i386__)
>  # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_X86_32
> @@ -14,6 +15,8 @@
>  # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_IA64
>  #elif defined(__powerpc64__)
>  # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_POWERPC64
> +#elif defined(__arm__)
> +# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_ARM
>  #else
>  # error arch fixup needed here
>  #endif
> -- 
> 1.7.2.5
