Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab1CLJN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 04:13:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51585 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1CLJNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 04:13:23 -0500
Date: Sat, 12 Mar 2011 02:13:20 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gpio: add MODULE_DEVICE_TABLE
Message-ID: <20110312091320.GH9347@angua.secretlab.ca>
References: <1299746914.18619.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299746914.18619.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:48:34PM +0800, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> After adding MODULE_DEVICE_TABLE, below entries will be added to modules.pcimap:
> 
> pch_gpio             0x00008086 0x00008803 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
> ml_ioh_gpio          0x000010db 0x0000802e 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/ml_ioh_gpio.c |    1 +
>  drivers/gpio/pch_gpio.c    |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/ml_ioh_gpio.c b/drivers/gpio/ml_ioh_gpio.c
> index cead8e6..7f6f01a 100644
> --- a/drivers/gpio/ml_ioh_gpio.c
> +++ b/drivers/gpio/ml_ioh_gpio.c
> @@ -326,6 +326,7 @@ static DEFINE_PCI_DEVICE_TABLE(ioh_gpio_pcidev_id) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x802E) },
>  	{ 0, }
>  };
> +MODULE_DEVICE_TABLE(pci, ioh_gpio_pcidev_id);
>  
>  static struct pci_driver ioh_gpio_driver = {
>  	.name = "ml_ioh_gpio",
> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
> index 0eba0a7..2c6af87 100644
> --- a/drivers/gpio/pch_gpio.c
> +++ b/drivers/gpio/pch_gpio.c
> @@ -286,6 +286,7 @@ static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
>  	{ 0, }
>  };
> +MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
>  
>  static struct pci_driver pch_gpio_driver = {
>  	.name = "pch_gpio",
> -- 
> 1.7.2
> 
> 
> 
