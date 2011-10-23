Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1JWIUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:20:36 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33141 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952Ab1JWIUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:20:11 -0400
X-Sasl-enc: otwlyMi6dxW7AXFdKmPmfL1YCP6hA0vMwYOksiXEqYAA 1319358010
Date: Sun, 23 Oct 2011 10:19:03 +0200
From: Greg KH <greg@kroah.com>
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/24] Staging: comedi: fix printk coding style issue in
Message-ID: <20111023081903.GB13409@kroah.com>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
 <1319091550-2558-2-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319091550-2558-2-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:48:48AM +0530, Ravishankar Karkala Mallikarjunayya wrote:
> This is a patch to the serial2002.c file that fixes up a printk warning
> found by the checkpatch.pl tool.
> Converted printks to pr_<level>.
> 
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
>  drivers/staging/comedi/drivers/serial2002.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
> index ade2202..6bd07ec 100644
> --- a/drivers/staging/comedi/drivers/serial2002.c
> +++ b/drivers/staging/comedi/drivers/serial2002.c
> @@ -431,7 +431,8 @@ static int serial_2002_open(struct comedi_device *dev)
>  		}
>  
>  		tty_setspeed(devpriv->tty, devpriv->speed);
> -		poll_channel(devpriv->tty, 31);	/*  Start reading configuration */
> +		/* Start reading configuration */
> +		poll_channel(devpriv->tty, 31);
>  		while (1) {
>  			struct serial_data data;
>  
> @@ -824,7 +825,7 @@ static int serial2002_attach(struct comedi_device *dev,
>  {
>  	struct comedi_subdevice *s;
>  
> -	printk("comedi%d: serial2002: ", dev->minor);
> +	pr_debug("comedi%d: serial2002: attached\n", dev->minor);

You have a device, so use dev_dbg() instead of pr_debug()

>  	dev->board_name = thisboard->name;
>  	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
>  		return -ENOMEM;
> @@ -832,7 +833,7 @@ static int serial2002_attach(struct comedi_device *dev,
>  	dev->close = serial_2002_close;
>  	devpriv->port = it->options[0];
>  	devpriv->speed = it->options[1];
> -	printk("/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
> +	pr_debug("/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
>  
>  	if (alloc_subdevices(dev, 5) < 0)
>  		return -ENOMEM;
> @@ -891,7 +892,7 @@ static int serial2002_detach(struct comedi_device *dev)
>  	struct comedi_subdevice *s;
>  	int i;
>  
> -	printk("comedi%d: serial2002: remove\n", dev->minor);
> +	pr_debug("comedi%d: serial2002: remove\n", dev->minor);

Same for the above two as well.

greg k-h
