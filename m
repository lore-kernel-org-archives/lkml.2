Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1G0GiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:38:09 -0400
Received: from mail.perches.com ([173.55.12.10]:4333 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab1G0GiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:38:06 -0400
Subject: Re: [PATCH] Staging: comedi: fix printk issue in adv_pci_dio.c
From: Joe Perches <joe@perches.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
In-Reply-To: <1311748284-19756-1-git-send-email-ravishankarkm32@gmail.com>
References: <[PATCH]Staging: Comedi: fix printk issue in adv_pci_dio.c>
	 <1311748284-19756-1-git-send-email-ravishankarkm32@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 23:38:04 -0700
Message-ID: <1311748684.21169.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 12:01 +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the adv_pci_dio.c file that fixes up a printk warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/adv_pci_dio.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
> index d23799b..1d2261f 100644
> --- a/drivers/staging/comedi/drivers/adv_pci_dio.c
> +++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
> @@ -1106,11 +1106,11 @@ static int pci_dio_attach(struct comedi_device *dev,
>  	unsigned long iobase;
>  	struct pci_dev *pcidev = NULL;
>  
> -	printk("comedi%d: adv_pci_dio: ", dev->minor);
> +	printk(KERN_INFO "comedi%d: adv_pci_dio: ", dev->minor);
>  
>  	ret = alloc_private(dev, sizeof(struct pci_dio_private));
>  	if (ret < 0) {
> -		printk(", Error: Cann't allocate private memory!\n");
> +		printk(KERN_CONT ", Error: Cann't allocate private memory!\n");
>  		return -ENOMEM;
>  	}
>  
> @@ -1140,19 +1140,19 @@ static int pci_dio_attach(struct comedi_device *dev,
>  	}
>  
>  	if (!dev->board_ptr) {
> -		printk(", Error: Requested type of the card was not found!\n");
> +		printk(KERN_ERR ", Error: Requested type of the card was not found!\n");
>  		return -EIO;
>  	}
>  
>  	if (comedi_pci_enable(pcidev, driver_pci_dio.driver_name)) {
>  		printk
> -		    (", Error: Can't enable PCI device and request regions!\n");
> +		(KERN_ERR ", Error: Can't enable PCI device and request "
> +		"regions!\n");
>  		return -EIO;
>  	}
>  	iobase = pci_resource_start(pcidev, this_board->main_pci_region);
> -	printk(", b:s:f=%d:%d:%d, io=0x%4lx",
> -	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
> -	       PCI_FUNC(pcidev->devfn), iobase);
> +	printk(KERN_INFO ", b:s:f=%d:%d:%d, io=0x%4lx",
> +	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
> +	       PCI_FUNC(pcidev->devfn), iobase);
>  
>  	dev->iobase = iobase;
>  	dev->board_name = this_board->name;
> @@ -1178,11 +1178,11 @@ static int pci_dio_attach(struct comedi_device *dev,
>  
>  	ret = alloc_subdevices(dev, n_subdevices);
>  	if (ret < 0) {
> -		printk(", Error: Cann't allocate subdevice memory!\n");
> +		printk(KERN_CONT ", Error: Cann't allocate subdevice memory!\n");
>  		return ret;
>  	}
>  
> -	printk(".\n");
> +	printk(KERN_CONT ".\n");
>  
>  	subdev = 0;
>  

Ravishankar, you _really_ aren't looking too hard when
you do these changes.  Your error rate is _quite_ high.

All of these changes are in the same function and are
continuations of the initial printk.  Every one of these
after the first one should use KERN_CONT.

_Please_ look harder before submitting these changes.

Otherwise, I'm going to have to agree with Dan Carpenter.

I'm sure you can do these sorts of trivial changes, but
you absolutely _must_ lower your error rate, otherwise
you work will be ignored and you will lose whatever
reputation you might want to establish within this
community.

Best, Joe Perches

