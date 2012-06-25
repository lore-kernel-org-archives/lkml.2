Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2FYHbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 03:31:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29615 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab2FYHbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 03:31:41 -0400
Date: Mon, 25 Jun 2012 10:31:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 17/31] staging: comedi: ni_daq_700: remove unused private
 data variable
Message-ID: <20120625073115.GI5333@mwanda>
References: <201206221626.47010.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206221626.47010.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:26:46PM -0700, H Hartley Sweeten wrote:
> The 'have_irq' variable is not needed since this driver doesn't
> use interrupts. Remove it.
> 
> The kfree(s->private) needs to remain to free the memory allocated
> in subdev_700_init().
> 

Hm...  That's weird.  The function which set have_irq to 1 was never
called and you already removed it in a previous patch.

So this fixes a memory leak right?  Because the kfree() was never
called in the original code.  Please mark bug fixes as special if
you can.

>  #define CALLBACK_ARG	(((struct subdev_700_struct *)s->private)->cb_arg)
> @@ -166,9 +165,7 @@ static void subdev_700_cleanup(struct comedi_device *dev,
>  			       struct comedi_subdevice *s)
>  {
>  	if (s->private)
> -		if (subdevpriv->have_irq)
> -
> -			kfree(s->private);
> +		kfree(s->private);

You could also remove the: "if (s->private)" check.

regards,
dan carpenter


