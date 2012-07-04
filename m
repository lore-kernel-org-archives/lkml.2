Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab2GDLZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:25:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6572 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab2GDLZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:25:21 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336363200"; 
   d="scan'208";a="201017326"
Message-ID: <4FF4281E.9040801@citrix.com>
Date: Wed, 4 Jul 2012 12:25:18 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH WIP 2/5] xen/arm: set xen_platform_pci_unplug to XEN_UNPLUG_ALL
References: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>  <1341400520-31770-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1341400520-31770-2-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/12 12:15, Stefano Stabellini wrote:
> Set xen_platform_pci_unplug to XEN_UNPLUG_ALL by default to make
> blkfront happy. The parameter doesn't make sense on ARM and should be
> removed.

Why is this parameter nonsensical on ARM?  ARM systems can have PCI devices.

David

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 6901e37..a6dc9eb 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -8,6 +8,7 @@
>  #include <xen/grant_table.h>
>  #include <xen/hvm.h>
>  #include <xen/xenbus.h>
> +#include <xen/platform_pci.h>
>  
>  #include <linux/module.h>
>  
> @@ -33,7 +34,7 @@ __read_mostly int xen_have_vector_callback;
>  EXPORT_SYMBOL_GPL(xen_have_vector_callback);
>  
>  /* XXX: to be removed */
> -int xen_platform_pci_unplug;
> +int xen_platform_pci_unplug = XEN_UNPLUG_ALL;
>  EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
>  
>  #define FOREIGN_MAP_BUFFER 0x90000000UL

