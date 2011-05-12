Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab1ELRYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:24:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179Ab1ELRYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:24:05 -0400
Date: Thu, 12 May 2011 10:23:45 -0700
From: Greg KH <gregkh@suse.de>
To: Stephane Pajot <pajot.stephane@gmail.com>
Cc: arun.thomas@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: fix tabulation and over 80 chars
 issues in amplc_pci224.c This is a patch to the amplc_pci224.c file that
 fixes up tabulation style errors and over 80 chars warning found by the
 checkpatch.pl tool Signed-off-by: Stephane Pajot <pajot.stephane@gmail.com>
Message-ID: <20110512172345.GC14812@suse.de>
References: <1305218698-7889-1-git-send-email-pajot.stephane@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305218698-7889-1-git-send-email-pajot.stephane@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 06:44:58PM +0200, Stephane Pajot wrote:
> ---
>  drivers/staging/comedi/drivers/amplc_pci224.c |   63 +++++++++++++------------
>  1 files changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
> index 1b5ba1c..2f61358 100644
> --- a/drivers/staging/comedi/drivers/amplc_pci224.c
> +++ b/drivers/staging/comedi/drivers/amplc_pci224.c
> @@ -52,33 +52,33 @@ Supports:
>  Configuration options - PCI224:
>    [0] - PCI bus of device (optional).
>    [1] - PCI slot of device (optional).
> -          If bus/slot is not specified, the first available PCI device
> -          will be used.
> +	If bus/slot is not specified, the first available PCI device
> +	will be used.

Why did you change these comment lines?

> @@ -401,7 +401,8 @@ MODULE_DEVICE_TABLE(pci, pci224_pci_table);
>  
>  /* this structure is for data unique to this hardware driver.  If
>     several hardware drivers keep similar information in this structure,
> -   feel free to suggest moving the variable to the struct comedi_device struct.  */
> +   feel free to suggest moving the variable
> +   to the struct comedi_device struct.  */

If you are going to change a multi-line comment like this, please use
the proper formatting for it.  Your change didn't really help anything
here.

>  struct pci224_private {
>  	struct pci_dev *pci_dev;	/* PCI device */
>  	const unsigned short *hwrange;
> @@ -678,12 +679,14 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
>  	switch (dacstat & PCI224_DACCON_FIFOFL_MASK) {
>  	case PCI224_DACCON_FIFOFL_EMPTY:
>  		room = PCI224_FIFO_ROOM_EMPTY;
> -		if (!devpriv->ao_stop_continuous && devpriv->ao_stop_count == 0) {
> -			/* FIFO empty at end of counted acquisition. */
> -			pci224_ao_stop(dev, s);
> -			s->async->events |= COMEDI_CB_EOA;
> -			comedi_event(dev, s);
> -			return;
> +		if (!devpriv->ao_stop_continuous == 0) {
> +			if (devpriv->ao_stop_count == 0) {

You just changed the logic of this if statment, not good at all.

thanks,

greg k-h
