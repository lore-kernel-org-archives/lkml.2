Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0KBPS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:18:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0KBPSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:18:23 -0400
Date: Tue, 2 Nov 2010 08:18:29 -0700
From: Greg KH <gregkh@suse.de>
To: Atul Sowani <sowani@gmail.com>
Cc: arnaud.patard@rtp-net.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.36 1/1] xgifb: change obsolete pci_find_device()
	with pci_get_device().
Message-ID: <20101102151829.GB2033@suse.de>
References: <4CD02860.2020103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD02860.2020103@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 08:34:00PM +0530, Atul Sowani wrote:
> Replaced obsolete pci_find_device() calls with pci_get_device() calls. This is
> recommended in pci.txt filei in PCI Documentation.

Yes, but you just caused a resource leak :(

> 
> Signed-off-by: Atul Sowani <sowani@gmail.com>
> ---
> diff -uprN a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
> --- a/drivers/staging/xgifb/XGI_main_26.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/drivers/staging/xgifb/XGI_main_26.c	2010-11-01 14:25:21.032436943 +0530
> @@ -483,7 +483,7 @@ XGIfb_query_VGA_config_space(struct xgi_
>  			break;
>  		}
> 
> -		pdev = pci_find_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
> +		pdev = pci_get_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);

Please read the documentation for pci_get_device() for the fact that you
now have a reference to the pci device.  You need to properly drop it
when finished.

Please change this patch to do that properly and I will be glad to apply
it.

thanks,

greg k-h
