Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2GQBwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:52:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40086 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GQBwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:52:07 -0400
Date: Mon, 16 Jul 2012 18:52:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk
Subject: Re: [PATCH 01/30] staging: comedi: add pci_dev pointer to
 comedi_device
Message-ID: <20120717015201.GA10048@kroah.com>
References: <201207111449.15203.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207111449.15203.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 02:49:14PM -0700, H Hartley Sweeten wrote:
> The pci_dev pointer in the private driver data is used by every
> comedi pci driver. Some of them only have the need for the
> private data because of this pointer.
> 
> Introduce the pci_dev pointer in the comedi_device struct so it
> can be used instead of needing it in the private data.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/comedi/comedidev.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index de8c99c..55f2373 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -212,6 +212,8 @@ struct comedi_device {
>  	 * DMA_NONE */
>  	struct device *hw_dev;
>  
> +	struct pci_dev *pcidev;

No, the field above this, hw_dev, should be used instead here, as that's
what it is there for, right?

Care to rework this series with that change instead?

thanks,

greg k-h
