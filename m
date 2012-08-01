Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2HAOoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:44:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22684 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2HAOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:44:20 -0400
Date: Wed, 1 Aug 2012 10:34:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Ian.Campbell@citrix.com, arnd@arndb.de,
        catalin.marinas@arm.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH 11/24] xen/arm: introduce CONFIG_XEN on ARM
Message-ID: <20120801143459.GH7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-11-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316846-25860-11-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:33:53PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/Kconfig |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a91009c..9c54cb4 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -2228,6 +2228,16 @@ config NEON
>  	  Say Y to include support code for NEON, the ARMv7 Advanced SIMD
>  	  Extension.
>  
> +config XEN_DOM0
> +	def_bool y

What is the benefit of this ? I was hoping at some point to rip out all of those
XEN_DOM0 and just have, mostly,
	CONFIG_XEN_BACKEND_SUPPORT
		(which would compile whatever is needed for HVM or PV guests to run
		blkback/netback/grant/grantalloc/etc)
	CONFIG_XEN_FRONTEND_SUPPORT
		(the vice-versa)

	CONFIG_XEN_PCI
		which would have the PCI support, the ACPI routing (which is
		predomaintaly most of the dom0 support), VGA text support, and
		whatever else is in there.

In that fashion you could compile a kernel with CONFIG_XEN_BACKEND_SUPPORT
without any CONFIG_XEN_PCI and drop it in as an HVM device driver domain.
Thought maybe that wouldn't really work as if you do PCI passthrough to such
domain, you are going to need the PCI support and ACPI routing. The VGA text
maybe not...

OK, never mind - we should brainstorm it and figure out how to make this
nicely work. In the meantime this is OK.

> +
> +config XEN
> +	bool "Xen guest support on ARM"
> +	depends on ARM && OF
> +	select XEN_DOM0
> +	help
> +	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> +
>  endmenu
>  
>  menu "Userspace binary formats"
> -- 
> 1.7.2.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
