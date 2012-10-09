Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2JIPgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:36:07 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:48921 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab2JIPgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:36:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344211200"; 
   d="scan'208";a="15043536"
Message-ID: <1349796958.21847.219.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 5/9] ARM: Xen: fix initial build problems:
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 9 Oct 2012 16:35:58 +0100
In-Reply-To: <1349796183-30648-6-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
	 <1349796183-30648-6-git-send-email-arnd@arndb.de>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 16:22 +0100, Arnd Bergmann wrote:
> * The XEN_BALLOON code requires the balloon infrastructure that is not
>   getting built on ARM.

I've got patches to enable this, but not for 3.7 so this looks good for
now.

> * The tmem hypercall is not available on ARM
> 
> * ARMv6 does not support cmpxchg on 16-bit words that are used in the

missing the end of this sentence?

> * sys-hypervisor.c needs to include linux/err.h in order to use the
>   IS_ERR/PTR_ERR/ERR_PTR family of functions.

I tripped over this too. Not sure where that patch got to though.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: xen-devel@lists.xensource.com
> ---
>  arch/arm/Kconfig             |    1 +
>  drivers/xen/Kconfig          |    2 ++
>  drivers/xen/sys-hypervisor.c |    1 +
>  3 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 6d2f7f5..85eaac3 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1846,6 +1846,7 @@ config XEN_DOM0
>  config XEN
>  	bool "Xen guest support on ARM (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL && ARM && OF
> +	depends on !CPU_V6
>  	help
>  	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
>  
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index d4dffcd..126d8ce 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -3,6 +3,7 @@ menu "Xen driver support"
>  
>  config XEN_BALLOON
>  	bool "Xen memory balloon driver"
> +	depends on !ARM
>  	default y
>  	help
>  	  The balloon driver allows the Xen domain to request more memory from
> @@ -145,6 +146,7 @@ config SWIOTLB_XEN
>  
>  config XEN_TMEM
>  	bool
> +	depends on !ARM
>  	default y if (CLEANCACHE || FRONTSWAP)
>  	help
>  	  Shim to interface in-kernel Transcendent Memory hooks
> diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
> index 5e5ad7e..66a0a14 100644
> --- a/drivers/xen/sys-hypervisor.c
> +++ b/drivers/xen/sys-hypervisor.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/kobject.h>
> +#include <linux/err.h>
>  
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>


