Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945912Ab2EKSAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:00:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43215 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972Ab2EKR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:59:58 -0400
Date: Fri, 11 May 2012 10:59:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk, fmhess@users.sourceforge.net
Subject: Re: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
Message-ID: <20120511175954.GA7920@kroah.com>
References: <201205111007.46754.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205111007.46754.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 10:07:43AM -0700, H Hartley Sweeten wrote:
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -950,6 +950,34 @@ void comedi_pci_auto_unconfig(struct pci_dev *pcidev)
>  }
>  EXPORT_SYMBOL_GPL(comedi_pci_auto_unconfig);
>  
> +int comedi_pci_driver_register(struct comedi_driver *comedi_driver,
> +		struct pci_driver *pci_driver)
> +{
> +	int ret;
> +
> +	ret = comedi_driver_register(comedi_driver);
> +	if (ret < 0)
> +		return ret;
> +
> +	pci_driver->name = comedi_driver->driver_name;
> +	ret = pci_register_driver(pci_driver);
> +	if (ret < 0) {
> +		comedi_driver_unregister(comedi_driver);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(comedi_pci_driver_register);
> +
> +void comedi_pci_driver_unregister(struct comedi_driver *comedi_driver,
> +		struct pci_driver *pci_driver)
> +{
> +	pci_unregister_driver(pci_driver);
> +	comedi_driver_unregister(comedi_driver);
> +}
> +EXPORT_SYMBOL(comedi_pci_driver_unregister);

EXPORT_SYMBOL_GPL() for these two functions?

thanks,

greg k-h
