Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934782Ab0GOUvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:51:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:42460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934699Ab0GOUvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:51:00 -0400
Date: Thu, 15 Jul 2010 13:45:40 -0700
From: Greg KH <gregkh@suse.de>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "Digi International, Inc" <Eng.Linux@digi.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/25] char: Convert pci_table entries to PCI_VDEVICE
	(if PCI_ANY_ID is used)
Message-ID: <20100715204540.GB24463@suse.de>
References: <201007152052.38060.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007152052.38060.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 08:52:37PM +0200, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
> PCI_VDEVICE macro, and thus improves readability.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/char/epca.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/epca.c b/drivers/char/epca.c
> index d9df46a..5dafcdb 100644
> --- a/drivers/char/epca.c
> +++ b/drivers/char/epca.c
> @@ -2762,10 +2762,10 @@ err_out:
>  
>  
>  static struct pci_device_id epca_pci_tbl[] = {
> -	{ PCI_VENDOR_DIGI, PCI_DEVICE_XR, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xr },
> -	{ PCI_VENDOR_DIGI, PCI_DEVICE_XEM, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xem },
> -	{ PCI_VENDOR_DIGI, PCI_DEVICE_CX, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_cx },
> -	{ PCI_VENDOR_DIGI, PCI_DEVICE_XRJ, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xrj },
> +	{ PCI_VDEVICE(DIGI, PCI_DEVICE_XR), brd_xr },
> +	{ PCI_VDEVICE(DIGI, PCI_DEVICE_XEM), brd_xem },
> +	{ PCI_VDEVICE(DIGI, PCI_DEVICE_CX), brd_cx },
> +	{ PCI_VDEVICE(DIGI, PCI_DEVICE_XRJ), brd_xrj },

The main reason I hate this macro, is that it now makes it almost
impossible to grep for any users of the PCI_VENDOR_DIGI pci vendor id.
I much prefer the PCI_DEVICE() macro instead, and as such, I'm not
willing to take any of these patches, sorry.

greg k-h
