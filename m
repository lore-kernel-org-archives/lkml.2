Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2FRPXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:23:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40657 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2FRPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:23:20 -0400
Date: Mon, 18 Jun 2012 08:23:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: Convert dbg to pr_eliminated and pr_debug
Message-ID: <20120618152315.GB1050@kroah.com>
References: <cover.1339985626.git.joe@perches.com>
 <25071de4def201f947780d6937b9732ccac3b3f0.1339985627.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25071de4def201f947780d6937b9732ccac3b3f0.1339985627.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 07:25:10PM -0700, Joe Perches wrote:
> Change the dbg macro to use pr_eliminated when not
> DEBUG and pr_debug with DEBUG so dynamic_debug can
> be used.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/usb.h |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index f717fbd..56b88b8 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -1714,14 +1714,12 @@ extern void usb_register_notify(struct notifier_block *nb);
>  extern void usb_unregister_notify(struct notifier_block *nb);
>  
>  #ifdef DEBUG
> -#define dbg(format, arg...)						\
> -	printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg)
> +#define dbg(format, ...)						\
> +	pr_debug("%s: " format "\n", __FILE__, ##__VA_ARGS__)

No, I really want to delete this macro entirely, and am slowly working
toward that, moving drivers to use the correct dev_dbg() macro instead.

>  #else
> -#define dbg(format, arg...)						\
> -do {									\
> -	if (0)								\
> -		printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg); \
> -} while (0)
> +#define dbg(format, ...)						\
> +	printk_eliminated(KERN_DEBUG "%s: " format "\n",		\
> +			  __FILE__, ##__VA_ARGS)

As Paul pointed out, this breaks the build, please build test your
patches before sending them out, it just wastes our time otherwise :(

greg k-h
