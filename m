Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2BLKqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 05:46:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37415 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2BLKqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 05:46:15 -0500
Date: Sun, 12 Feb 2012 10:45:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Myron Stowe <mstowe@redhat.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "myron.stowe" <myron.stowe@redhat.com>
Subject: Re: [BUG] Multiple definition of pcibios_max_latency
Message-ID: <20120212104551.GX889@n2100.arm.linux.org.uk>
References: <20120204125904.GU889@n2100.arm.linux.org.uk> <1328551157.2264.11.camel@zim.stowe> <20120207085838.GB889@n2100.arm.linux.org.uk> <1328653604.2404.16.camel@zim.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328653604.2404.16.camel@zim.stowe>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 03:26:44PM -0700, Myron Stowe wrote:
> Mike:
> 
> Are you seeing the same failure as Russell, and if so, could you try the
> following patch and see if it fixes the build?
> 
> 
> linux-arm-kernel:
> 
> Any testing, with respect to what Russell encountered, of the various
> ARM variations/configurations would be much appreciated.  Please provide
> feedback as to the specific ARM variation/configuration, if it is
> currently encountering the build issue that Russell is, and if the
> attached patch fixes the build.

Given the lack of response, I think this should just be submitted so it's
no longer causing a build regression.

> ARM/PCI: Remove ARM's duplicate definition of 'pcibios_max_latency'
> 
> From: Myron Stowe <mstowe@redhat.com>
> 
> The patch series to re-factor PCI's 'latency timer' setup (re:
> http://marc.info/?l=linux-kernel&m=131983853831049&w=2) forgot to
> remove the ARM specific definition of 'pcibios_max_latency' once such
> had been moved into the pci core resulting in ARM related compile
> errors -
>   drivers/built-in.o:(.data+0x230): multiple definition of
>   `pcibios_max_latency'
>   arch/arm/common/built-in.o:(.data+0x40c): first defined here
>   make[1]: *** [vmlinux.o] Error 1
> 
> In the series, patch 2/16 (commit 168c8619fd8) converted the ARM
> specific version of 'pcibios_set_master()' to a non-inlined version.
> This was done in preperation for hosting it up into PCI's core, which
> was done in patch 10/16 (commit 96c5590058d) of the series (and
> where the removal of ARM's 'pcibios_max_latency' was overlooked).
> 
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
> 
>  arch/arm/common/it8152.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
> index d1bcd7b..fb1f1cf 100644
> --- a/arch/arm/common/it8152.c
> +++ b/arch/arm/common/it8152.c
> @@ -320,13 +320,6 @@ err0:
>  	return -EBUSY;
>  }
>  
> -/*
> - * If we set up a device for bus mastering, we need to check the latency
> - * timer as we don't have even crappy BIOSes to set it properly.
> - * The implementation is from arch/i386/pci/i386.c
> - */
> -unsigned int pcibios_max_latency = 255;
> -
>  /* ITE bridge requires setting latency timer to avoid early bus access
>     termination by PCI bus master devices
>  */
> 
> 
> 
