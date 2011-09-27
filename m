Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1I0BaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 21:30:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48088 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1I0BaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 21:30:05 -0400
Date: Mon, 26 Sep 2011 19:30:01 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC 1/5] ARM: dev_archdata: add private iommu extension
Message-ID: <20110927013001.GA20588@ponder.secretlab.ca>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
 <1316948337-7924-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316948337-7924-2-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 25, 2011 at 01:58:53PM +0300, Ohad Ben-Cohen wrote:
> Add a private iommu pointer to the ARM-specific arch data in the
> device struct, which will be used to attach iommu-specific data
> to devices which require iommu support.
> 
> Different iommu implementations (on different platforms) will attach
> different types of data to this pointer, so 'void *' is currently used
> (the downside is reduced typesafety).
> 
> Note: ia64, x86 and sparc have this exact iommu extension as well, and
> if others are likely to adopt it too, we might want to consider
> adding this to the device struct itself directly.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/include/asm/device.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/device.h b/arch/arm/include/asm/device.h
> index 9f390ce..6615f03 100644
> --- a/arch/arm/include/asm/device.h
> +++ b/arch/arm/include/asm/device.h
> @@ -10,6 +10,9 @@ struct dev_archdata {
>  #ifdef CONFIG_DMABOUNCE
>  	struct dmabounce_device_info *dmabounce;
>  #endif
> +#ifdef CONFIG_IOMMU_API
> +	void *iommu; /* private IOMMU data */
> +#endif

Blech.  Oh well.  Not much point in doing something different if x86
uses a void*.

g.

