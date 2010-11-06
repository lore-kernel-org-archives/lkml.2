Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0KFRwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 13:52:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43482 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0KFRwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 13:52:11 -0400
Date: Sat, 6 Nov 2010 10:51:55 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, Oliver Neukum <oliver@neukum.org>,
        Joe Perches <joe@perches.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: misc: iowarrior: fix information leak to userland
Message-ID: <20101106175155.GB5327@outflux.net>
References: <1289054492-18278-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289054492-18278-1-git-send-email-segooon@gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 05:41:31PM +0300, Vasiliy Kulikov wrote:
> Structure iowarrior_info is copied to userland with padding byted
> between "serial" and "revision" fields uninitialized.  It leads to
> leaking of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: Kees Cook <kees.cook@canonical.com>

> ---
>  Compile tested.
> 
>  drivers/usb/misc/iowarrior.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
> index 3756641..c9078e4 100644
> --- a/drivers/usb/misc/iowarrior.c
> +++ b/drivers/usb/misc/iowarrior.c
> @@ -553,6 +553,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
>  			/* needed for power consumption */
>  			struct usb_config_descriptor *cfg_descriptor = &dev->udev->actconfig->desc;
>  
> +			memset(&info, 0, sizeof(info));
>  			/* directly from the descriptor */
>  			info.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
>  			info.product = dev->product_id;
> -- 
> 1.7.0.4
-- 
Kees Cook
Ubuntu Security Team
