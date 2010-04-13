Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0DMQsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:48:12 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35647 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0DMQsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:48:11 -0400
Date: Tue, 13 Apr 2010 18:48:05 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, bryan.wu@canonical.com,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 2/8] mxc: Update GPIO for USB support on
 Freescale MX51 Babbage HW
Message-ID: <20100413164805.GN30801@buzzloop.caiaq.de>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:10:25AM -0500, Dinh.Nguyen@freescale.com wrote:
> This patch is part of enabling USB for Freescale MX51 Babbage HW. This
> patch updates the iomux pins for USB, and gpio line for reset the
> USB hub on the MX51 Babbage HW.
> 
> This patch applies to 2.6.34-rc4.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/plat-mxc/ehci.c                    |    4 +++
>  arch/arm/plat-mxc/include/mach/iomux-mx51.h |   33 ++++++++++++++++----------
>  2 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/ehci.c b/arch/arm/plat-mxc/ehci.c
> index cb0b638..20eaddc 100644
> --- a/arch/arm/plat-mxc/ehci.c
> +++ b/arch/arm/plat-mxc/ehci.c
> @@ -186,6 +186,10 @@ int mxc_set_usbcontrol(int port, unsigned int flags)
>  		return 0;
>  	}
>  #endif /* CONFIG_MACH_MX27 */
> +#ifdef CONFIG_ARCH_MX5
> +	/* Nothing needs to be done for MX5 here */
> +	return 0;
> +#endif

This needs a cpu_is_mx5() condition. For now that's just nit-picking,
but once another platform is added, the statement will return where it
shouldn't.

Daniel

