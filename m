Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936077Ab2JYUeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:34:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34929 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935649Ab2JYUeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:34:14 -0400
Date: Thu, 25 Oct 2012 13:34:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tilegx: move fixup hook from __init to __devinit
Message-ID: <20121025203401.GA2925@kroah.com>
References: <201210252022.q9PKMK9Q011000@farm-0023.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210252022.q9PKMK9Q011000@farm-0023.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 04:19:09PM -0400, Chris Metcalf wrote:
> Support having the PCI bus be removed at runtime and rediscovered.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Cc: stable@vger.kernel.org [v3.6]
> ---
>  arch/tile/kernel/pci_gx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
> index 2ba6d05..248d08a 100644
> --- a/arch/tile/kernel/pci_gx.c
> +++ b/arch/tile/kernel/pci_gx.c
> @@ -1047,7 +1047,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
>  }
>  
>  /* Called for each device after PCI setup is done. */
> -static void __init
> +static void __devinit

Just delete __devinit, it means nothing in 3.7, and really, you don't
want it there at all anyway for any older kernels.

thanks,

greg k-h
