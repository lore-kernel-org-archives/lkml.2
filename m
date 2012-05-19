Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543Ab2ESAh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:37:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54921 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782Ab2ESAh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:37:27 -0400
Date: Fri, 18 May 2012 17:37:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Staging: ipack/bridges/tpci200: remove
 TPCI200_SHORTNAME constant
Message-ID: <20120519003724.GA10111@kroah.com>
References: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
 <1337332208-26057-3-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337332208-26057-3-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:10:07AM +0200, Samuel Iglesias Gonsalvez wrote:
> Removed TPCI200_SHORTNAME. For the pr_* the name of the module is already
> included due to pr_fmt declaration.
> 
> In other cases, KBUILD_MODNAME is used instead.
> 
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/bridges/tpci200.c |   70 +++++++++++++++----------------
>  drivers/staging/ipack/bridges/tpci200.h |    2 -
>  2 files changed, 33 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
> index b460587..c043345 100644
> --- a/drivers/staging/ipack/bridges/tpci200.c
> +++ b/drivers/staging/ipack/bridges/tpci200.c
> @@ -54,16 +54,15 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
>  	}
>  
>  	if (dev->slot >= TPCI200_NB_SLOT) {
> -		pr_info("Slot [%s %d:%d] doesn't exist! Last tpci200 slot is %d.\n",
> -			TPCI200_SHORTNAME, dev->bus_nr, dev->slot,
> -			TPCI200_NB_SLOT-1);
> +		pr_info("Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
> +			dev->bus_nr, dev->slot, TPCI200_NB_SLOT-1);

All of these should really be dev_err() calls, right?

You should have no pr_* calls at all in any driver, and probably none in
the ipack core as well, care to fix them all up?

thanks,

greg k-h
