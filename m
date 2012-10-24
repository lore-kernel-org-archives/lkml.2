Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102Ab2JXO5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:57:14 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55921 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915Ab2JXO5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:57:12 -0400
Date: Wed, 24 Oct 2012 16:56:44 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        linux@sierrawireless.com, linux-usb@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Fix memory leak in sierra_release() (this time with
 signed-off-by)
Message-ID: <20121024145644.GB3131@localhost>
References: <20121024142309.GQ18610@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024142309.GQ18610@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:23:09AM -0400, Lennart Sorensen wrote:
> I found a memory leak in sierra_release() (well sierra_probe() I guess)
> that looses 8 bytes each time the driver releases a device.

Good catch! I missed this one when I fixed a bunch of other memory
leaks in the sierra with recent kernels:

	http://marc.info/?l=linux-usb&m=135100550421848&w=2

I'll rebase my patch on top of this one as your patch should be
backported to all stable kernels, whereas mine is only required for
v3.6 and later.

> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

Cc: <stable@vger.kernel.org>
Acked-by: Johan Hovold <jhovold@gmail.com>

Thanks,
Johan


> diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
> index 01d882c..76ef95b 100644
> --- a/drivers/usb/serial/sierra.c
> +++ b/drivers/usb/serial/sierra.c
> @@ -959,6 +959,7 @@ static void sierra_release(struct usb_serial *serial)
>  			continue;
>  		kfree(portdata);
>  	}
> +	kfree(serial->private);
>  }
>  
>  #ifdef CONFIG_PM
