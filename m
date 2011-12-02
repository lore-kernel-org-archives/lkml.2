Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1LBQFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:05:16 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35023 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756905Ab1LBQFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:05:14 -0500
X-Sasl-enc: 1OkWzjgJJbhCdZFfhrX4bhwk/T58avablEEzei88ZYkh 1322841912
Date: Fri, 2 Dec 2011 08:03:26 -0800
From: Greg KH <greg@kroah.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, David Altobelli <david.altobelli@hp.com>,
        Brent Casavant <bcasavan@sgi.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] MISC: Convert to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20111202160326.GA13819@kroah.com>
References: <1322794977.25851.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322794977.25851.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 11:02:57AM +0800, Axel Lin wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables. Also convert to the PCI_DEVICE/PCI_VDEVICE macros for better
> readablity.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <greg@kroah.com>
> Cc: David Altobelli <david.altobelli@hp.com>
> Cc: Brent Casavant <bcasavan@sgi.com>
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Cc: J Freyensee <james_p_freyensee@linux.intel.com>
> Cc: Alex Dubov <oakad@yahoo.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/misc/hpilo.c     |    2 +-
>  drivers/misc/ioc4.c      |    6 +++---
>  drivers/misc/pch_phub.c  |    2 +-
>  drivers/misc/phantom.c   |    2 +-
>  drivers/misc/pti.c       |    2 +-
>  drivers/misc/tifm_7xx1.c |   11 ++++-------
>  6 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
> index fffc227..f705cbb 100644
> --- a/drivers/misc/hpilo.c
> +++ b/drivers/misc/hpilo.c
> @@ -828,7 +828,7 @@ out:
>  	return error;
>  }
>  
> -static struct pci_device_id ilo_devices[] = {
> +static DEFINE_PCI_DEVICE_TABLE(ilo_devices) = {

No, I hate this macro, see, it's actually taking you more characters to
use it than to just properly define the structure yourself.  It's
pointless and stupid.

So no, I'm not going to accept this patch, sorry.

I would love to see a patch removing this macro from the kernel, but I'm
not the PCI maintainer anymore, so I can't directly accept it :(

>  	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB204) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3307) },
>  	{ }
> diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
> index df03dd3..46adc36 100644
> --- a/drivers/misc/ioc4.c
> +++ b/drivers/misc/ioc4.c
> @@ -456,9 +456,9 @@ ioc4_remove(struct pci_dev *pdev)
>  	kfree(idd);
>  }
>  
> -static struct pci_device_id ioc4_id_table[] = {
> -	{PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC4, PCI_ANY_ID,
> -	 PCI_ANY_ID, 0x0b4000, 0xFFFFFF},
> +static DEFINE_PCI_DEVICE_TABLE(ioc4_id_table) = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC4),
> +	  .class = 0x0b4000, .class_mask = 0xFFFFFF },

But the PCI_DEVICE() changes, yes, those are good as they make things
much more obvious as to what is going on.  Care to send me a patch for
just that instead?

thanks,

greg k-h
