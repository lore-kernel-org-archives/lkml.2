Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab1JCX1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:27:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63791 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1JCX1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:27:46 -0400
Message-ID: <4E8A44ED.4090406@gmail.com>
Date: Tue, 04 Oct 2011 10:27:41 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] Staging: comedi: fix printk  issue in cb_pcidio.c
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
In-Reply-To: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/11 23:18, Ravishankar Karkala Mallikarjunayya wrote:

> This is a patch to the cb_pcidio.c file that fixes up a printk warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
>  drivers/staging/comedi/drivers/cb_pcidio.c |   27 +++++++++++++++------------
>  1 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
> index 79477a5..85cc78d 100644
> --- a/drivers/staging/comedi/drivers/cb_pcidio.c
> +++ b/drivers/staging/comedi/drivers/cb_pcidio.c
> @@ -184,7 +184,8 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	int index;
>  	int i;
>  
> -	printk("comedi%d: cb_pcidio: \n", dev->minor);
> +	dev_info(&pcidev->dev, "comedi%d: cb_pcidio:\n",
> +		dev->minor);
>  
>  /*
>   * Allocate the private structure area.  alloc_private() is a
> @@ -223,8 +224,9 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  		}
>  	}
>  
> -	printk("No supported ComputerBoards/MeasurementComputing card found on "
> -	       "requested position\n");
> +	dev_err(&pcidev->dev, "No supported"
> +		" ComputerBoards/MeasurementComputing"
> +		" card found on requested position\n");


printk strings should be on a single line (80 column rule doesn't apply)
so that they can be easily grepped for. There are many instances which
need to be fixed in this series.

~Ryan
