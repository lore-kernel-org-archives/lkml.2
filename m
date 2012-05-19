Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2ESORW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:17:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44646 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2ESORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:17:20 -0400
Message-ID: <4FB7AB4D.5040900@mvista.com>
Date: Sat, 19 May 2012 18:16:45 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH -next] usb: add usb.h stubs for CONFIG_USB not enabled
References: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au> <4FB6ED55.6090805@xenotime.net> <20120519005031.GA27613@kroah.com> <4FB6FFBF.6000509@xenotime.net>
In-Reply-To: <4FB6FFBF.6000509@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-05-2012 6:04, Randy Dunlap wrote:

> From: Randy Dunlap<rdunlap@xenotime.net>

> Add stubs for some usb core functions when CONFIG_USB
> is not enabled.  This fixes these comedi build errors:

> ERROR: "usb_deregister" [drivers/staging/comedi/comedi.ko] undefined!
> ERROR: "usb_register_driver" [drivers/staging/comedi/comedi.ko] undefined!

> Signed-off-by: Randy Dunlap<rdunlap@xenotime.net>
> ---
> I am only adding the stubs that are needed for comedi to build.
> I expect that more stubs will be needed as more build errors are
> found.  It seems to me that linux/usb.h might need more (major)
> moving of lines to support more stubs in the future.

>   Documentation/usb/error-codes.txt |    2 ++
>   include/linux/usb.h               |   24 +++++++++++++++++++++++-
>   2 files changed, 25 insertions(+), 1 deletion(-)
>
> --- linux-next-20120518.orig/include/linux/usb.h
> +++ linux-next-20120518/include/linux/usb.h
> @@ -10,7 +10,7 @@
>
>   #ifdef __KERNEL__
>
> -#include<linux/errno.h>         /* for -ENODEV */
> +#include<linux/errno.h>         /* for -ENODEV, -ENOSYS */
>   #include<linux/delay.h>	/* for mdelay() */
>   #include<linux/interrupt.h>	/* for in_interrupt() */
>   #include<linux/list.h>		/* for struct list_head */
> @@ -515,6 +515,8 @@ static inline struct usb_device *interfa
>   	return to_usb_device(intf->dev.parent);
>   }
>
> +#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)

    You can use IS_ENABLED(CONFIG_USB) instead of these two now.

WBR, Sergei
