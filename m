Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2IKLAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:00:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44878 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2IKLAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:00:09 -0400
Date: Tue, 11 Sep 2012 13:59:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bruce Humphrey <brucehum@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: fl512: change printk(KERN_INFO
 ... for the prefered pr_info(...
Message-ID: <20120911105943.GU19396@mwanda>
References: <1347331815-7278-1-git-send-email-brucehum@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347331815-7278-1-git-send-email-brucehum@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
>  	if (!request_region(iobase, FL512_SIZE, "fl512")) {
> -		printk(KERN_WARNING " I/O port conflict\n");
> +		pr_warn(" I/O port conflict\n");
>  		return -EIO;

These weren't right at all in the original code.  Doing small white
space cleanups is pointless when the print statements are wrong.
(Line continuations.  Also printing bogus nonsense.  Look Hartley's
patches for examples on how to fix these properly).

regards,
dan carpenter

