Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2GSMlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:41:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44618 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab2GSMlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:41:44 -0400
Message-ID: <50080083.6050204@mev.co.uk>
Date: Thu, 19 Jul 2012 13:41:39 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 88/90] staging: comedi: rtd520: store the pci_dev in the
 comedi_device
References: <201207181905.13723.hartleys@visionengravers.com>
In-Reply-To: <201207181905.13723.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 03:05, H Hartley Sweeten wrote:
> Use the hw_dev pointer in the comedi_device struct to hold the
> pci_dev instead of carrying it in the private data.

My reply to patch 86 has a knock-on effect for this patch...

>   	/* Get the physical address from PCI config */
> -	dev->iobase = pci_resource_start(devpriv->pci_dev, LAS0_PCIINDEX);
> -	physLas1 = pci_resource_start(devpriv->pci_dev, LAS1_PCIINDEX);
> -	physLcfg = pci_resource_start(devpriv->pci_dev, LCFG_PCIINDEX);
> +	dev->iobase = pci_resource_start(pcidev, LAS0_PCIINDEX);
> +	physLas1 = pci_resource_start(pcidev, LAS1_PCIINDEX);
> +	physLcfg = pci_resource_start(pcidev, LCFG_PCIINDEX);

...in the use of dev->iobase to hold a PCI memory address.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


