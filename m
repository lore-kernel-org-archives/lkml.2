Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1JQWMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:12:32 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43089 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326Ab1JQWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:12:31 -0400
X-Sasl-enc: JVsSsfFfTuxbqL52RCV16RjTM3gzO+4UfGvwnQ+pg3EX 1318889550
Date: Mon, 17 Oct 2011 15:06:31 -0700
From: Greg KH <greg@kroah.com>
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] Staging: comedi: fix printk issue in cb_pcidda.c
Message-ID: <20111017220631.GA26535@kroah.com>
References: <1317649693-2301-1-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317649693-2301-1-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 07:18:12PM +0530, Ravishankar Karkala Mallikarjunayya wrote:
> This is a patch to the cb_pcidda.c file that fixes up a printk warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
> I was not mentioned  printk("eeprom:") and 
>  printk(" %i:0x%x ", index, devpriv->eeprom_data[index]); line in Earlier patch which is fixed.
> 
>  drivers/staging/comedi/drivers/cb_pcidda.c |   25 ++++++++++++++-----------
>  1 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
> index 49102b3..da5b8e5 100644
> --- a/drivers/staging/comedi/drivers/cb_pcidda.c
> +++ b/drivers/staging/comedi/drivers/cb_pcidda.c
> @@ -282,7 +282,8 @@ static int cb_pcidda_attach(struct comedi_device *dev,
>  	struct pci_dev *pcidev = NULL;
>  	int index;
>  
> -	printk("comedi%d: cb_pcidda: ", dev->minor);
> +	dev_info(&pcidev->dev, "comedi%d: cb_pcidda:\n",
> +		dev->minor);
>  
>  /*
>   * Allocate the private structure area.
> @@ -293,7 +294,6 @@ static int cb_pcidda_attach(struct comedi_device *dev,
>  /*
>   * Probe the device to determine what device in the series it is.
>   */
> -	printk("\n");
>  
>  	for_each_pci_dev(pcidev) {
>  		if (pcidev->vendor == PCI_VENDOR_ID_CB) {
> @@ -312,22 +312,24 @@ static int cb_pcidda_attach(struct comedi_device *dev,
>  		}
>  	}
>  	if (!pcidev) {
> -		printk
> -		    ("Not a ComputerBoards/MeasurementComputing card on requested position\n");
> +		dev_err(&pcidev->dev, "Not a "
> +			"ComputerBoards/MeasurementComputing "
> +			"card on requested position\n");

Please don't break strings across lines like this, just put them all on
one line.

greg k-h
