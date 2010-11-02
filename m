Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0KBPhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:37:48 -0400
Received: from mail.perches.com ([173.55.12.10]:3927 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab0KBPhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:37:41 -0400
Subject: Re: [PATCH] staging: frontier: alphatrack: fixed coding style
 issues
From: Joe Perches <joe@perches.com>
To: Audun Hoem <audun.hoem@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288711861-3625-1-git-send-email-audun.hoem@gmail.com>
References: <1288711861-3625-1-git-send-email-audun.hoem@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 08:37:39 -0700
Message-ID: <1288712259.7326.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 16:31 +0100, Audun Hoem wrote:
> Cleaned up a macro definition and another simple style warning.
> Signed-off-by: Audun Hoem <audun.hoem@gmail.com>
> ---
>  drivers/staging/frontier/alphatrack.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
> index ef7fbf8..6e3bd73 100644
> --- a/drivers/staging/frontier/alphatrack.c
> +++ b/drivers/staging/frontier/alphatrack.c
> @@ -88,8 +88,11 @@ MODULE_SUPPORTED_DEVICE("Frontier Designs Alphatrack Control Surface");
>  static int debug = ALPHATRACK_DEBUG;
>  
>  /* Use our own dbg macro */
> -#define dbg_info(dev, format, arg...) do \
> -    { if (debug) dev_info(dev , format , ## arg); } while (0)
> +#define dbg_info(dev, format, arg...) \
> +do { \
> +	if (debug) \
> +		dev_info(dev , format , ## arg); \

There is no need for the spaces before commas.

gcc 2.xx required a space before a comma with a trailing ##arg,
but that compiler version is no longer supported.

This should be:
	dev_info(dev, format, ##arg);

though I think using dev_dbg and getting rid of the dbg_info
macro is better.

> +} while (0)
>  
>  #define alphatrack_ocmd_info(dev, cmd, format, arg...)
>  
> @@ -769,7 +772,7 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
>  	}
>  
>  	dev->write_buffer =
> -	    kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);
> +	    kmalloc(sizeof(struct alphatrack_ocmd) *true_size, GFP_KERNEL);

Not an improvement.

If checkpatch warns about this, it's a checkpatch defect.


