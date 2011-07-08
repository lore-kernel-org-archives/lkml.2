Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1GHEWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:22:46 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60778 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851Ab1GHEWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:22:44 -0400
X-Sasl-enc: GOe1k4K3oHMmxGsv52NRUFgRsngzIV4AekLUuZ5lTj5g 1310098963
Date: Thu, 7 Jul 2011 21:22:35 -0700
From: Greg KH <greg@kroah.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] driver core: Add ability for arch code to setup
 pdev_archdata
Message-ID: <20110708042235.GA26357@kroah.com>
References: <1310097643-8414-1-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310097643-8414-1-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 11:00:41PM -0500, Kumar Gala wrote:
> On some architectures we need to setup pdev_archdata before we add the
> device.  Waiting til a bus_notifier is too late since we might need the
> pdev_archdata in the bus notifier.  One example is setting up of dma_mask
> pointers such that it can be used in a bus_notifier.
> 
> We add weak noop version of arch_setup_pdev_archdata() and allow the arch
> code to override with access the full definitions of struct device,
> struct platform_device, and struct pdev_archdata.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> v4:
> * Move to use a weak function based on comments from Greg
> v3:
> * Add more comments and add missing call to arch_setup_pdev_archdata in
>   platform_device_register
> v2:
> * Added license, and comments about arch_setup_pdev_archdata()
>   per Mike's comments
> 
>  drivers/base/platform.c         |   22 ++++++++++++++++++++++
>  include/linux/platform_device.h |    1 +
>  2 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 1c291af..060686d 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -32,6 +32,26 @@ struct device platform_bus = {
>  EXPORT_SYMBOL_GPL(platform_bus);
>  
>  /**
> + * arch_setup_pdev_archdata - Allow manipulation of archdata before its used
> + * @dev: platform device
> + *
> + * This is called before platform_device_add() such that any pdev_archdata may
> + * be setup before the platform_notifier is called.  So if a user needs to
> + * manipulate any relevant information in the pdev_archdata they can do:
> + *
> + * 	platform_devic_alloc()
> + * 	... manipulate ...
> + * 	platform_device_add()
> + *
> + * And if they don't care they can just call platform_device_register() and
> + * everything will just work out.
> + */
> +void __weak arch_setup_pdev_archdata(struct platform_device *pdev)
> +{
> +	return ;
> +}

The "return" isn't needed, nor is the extra ' ' there, right?  :)

Change that and you can take this through the ppc tree and add a:
	Acked-by: Greg Kroah-Hartman
to them.

thanks,

greg k-h
