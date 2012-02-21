Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2BUNBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:01:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49262 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2BUNBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:01:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 21 Feb 2012 14:01:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] Driver: firewire: Use the macro DMA_BIT_MASK().
Message-ID: <20120221140103.773d0962@stein>
In-Reply-To: <1329818893-8276-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1329818893-8276-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 21 santosh nayak wrote:
> Use the macro DMA_BIT_MASK instead of the constant  0xffffffff
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  drivers/firewire/nosy.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
> index 763626b..a7c4422 100644
> --- a/drivers/firewire/nosy.c
> +++ b/drivers/firewire/nosy.c
> @@ -36,7 +36,7 @@
>  #include <linux/timex.h>
>  #include <linux/uaccess.h>
>  #include <linux/wait.h>
> -
> +#include <linux/dma-mapping.h>
>  #include <linux/atomic.h>
>  #include <asm/byteorder.h>
>  
> @@ -536,7 +536,7 @@ add_card(struct pci_dev *dev, const struct pci_device_id *unused)
>  	u32 p, end;
>  	int ret, i;
>  
> -	if (pci_set_dma_mask(dev, 0xffffffff)) {
> +	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
>  		dev_err(&dev->dev,
>  		    "DMA address limits not supported for PCILynx hardware\n");
>  		return -ENXIO;

Thanks, I will commit it to linux1394.git soon.
-- 
Stefan Richter
-=====-===-- --=- =-=-=
http://arcgraph.de/sr/
