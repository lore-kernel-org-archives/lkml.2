Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2IKCw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 22:52:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46485 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab2IKCw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 22:52:57 -0400
Date: Mon, 10 Sep 2012 19:52:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bruce Humphrey <brucehum@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: fl512: change printk(KERN_INFO
 ... for the prefered pr_info(...
Message-ID: <20120911025252.GA28112@kroah.com>
References: <1347331815-7278-1-git-send-email-brucehum@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347331815-7278-1-git-send-email-brucehum@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 04:50:15AM +0200, Bruce Humphrey wrote:
> Change 5 instances of printk(KERN_INFO, KERN_WARN and KERN_ERROR for the prefered pr_info, pr_warn and pr_error
> 
> Signed-off-by: Bruce Humphrey Ventura <brucehum@gmail.com>
> ---
>  drivers/staging/comedi/drivers/fl512.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
> index d1da809..258a7b4 100644
> --- a/drivers/staging/comedi/drivers/fl512.c
> +++ b/drivers/staging/comedi/drivers/fl512.c
> @@ -118,9 +118,9 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	struct comedi_subdevice *s;
>  
>  	iobase = it->options[0];
> -	printk(KERN_INFO "comedi:%d fl512: 0x%04lx", dev->minor, iobase);
> +	pr_info("comedi:%d fl512: 0x%04lx", dev->minor, iobase);

Why can't you use dev_info() here, and in other places?  You should use
the dev_* functions instead of pr_* wherever possible.

thanks,

greg k-h
