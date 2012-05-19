Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab2ESAfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:35:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2ESAff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:35:35 -0400
Date: Fri, 18 May 2012 17:35:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Staging: ipack: remove board_name and bus_name
 fields from struct ipack_device
Message-ID: <20120519003531.GA2206@kroah.com>
References: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
 <1337332208-26057-2-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337332208-26057-2-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:10:06AM +0200, Samuel Iglesias Gonsalvez wrote:
> Removed board_name and bus_name fields from struct ipack_device that are
> completely useless.
> 
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/bridges/tpci200.c |   20 ++++----------------
>  drivers/staging/ipack/bridges/tpci200.h |    8 ++++----
>  drivers/staging/ipack/ipack.h           |    4 ----
>  3 files changed, 8 insertions(+), 24 deletions(-)

Much nicer, and I'll take this, but why are you doing this:

> @@ -450,7 +448,7 @@ static ssize_t tpci200_show_board(struct device *pdev, char *buf, int slot)
>  	struct ipack_device *dev = card->slots[slot].dev;
>  
>  	if (dev != NULL)
> -		return snprintf(buf, PAGE_SIZE, "%s\n", dev->board_name);
> +		return snprintf(buf, PAGE_SIZE, "%s\n", dev_name(&dev->dev));

?  That implies that the name isn't already in the path, which it should
be (or at the least, a symlink should be there, so this sysfs file
should not be needed at all, right?)

Also:
> +	slot_irq->name = dev_name(&dev->dev);

Why do that?  Who needs this name now that we already have it in the
device?  Can't that field be removed entirely now also?

thanks,

greg k-h
