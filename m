Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0IMUjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:39:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:58965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab0IMUi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:38:59 -0400
Date: Mon, 13 Sep 2010 13:38:41 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 20/25] drivers/usb: Use static const char arrays
Message-ID: <20100913203841.GA17589@suse.de>
References: <cover.1284406638.git.joe@perches.com>
 <d366844155ca5af8525058f3376737ad7f94943e.1284406639.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d366844155ca5af8525058f3376737ad7f94943e.1284406639.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 12:47:58PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/usb/atm/ueagle-atm.c   |   14 +++++---------
>  drivers/usb/otg/langwell_otg.c |    2 +-
>  2 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
> index ea071a5..00d2516 100644
> --- a/drivers/usb/atm/ueagle-atm.c
> +++ b/drivers/usb/atm/ueagle-atm.c
> @@ -1574,20 +1574,16 @@ static int uea_stat_e4(struct uea_softc *sc)
>  
>  static void cmvs_file_name(struct uea_softc *sc, char *const cmv_name, int ver)
>  {
> -	char file_arr[] = "CMVxy.bin";
> +	char file_arr[sizeof("CMVxy.bin")];
>  	char *file;
>  
>  	kparam_block_sysfs_write(cmv_file);
>  	/* set proper name corresponding modem version and line type */
>  	if (cmv_file[sc->modem_index] == NULL) {
> -		if (UEA_CHIP_VERSION(sc) == ADI930)
> -			file_arr[3] = '9';
> -		else if (UEA_CHIP_VERSION(sc) == EAGLE_IV)
> -			file_arr[3] = '4';
> -		else
> -			file_arr[3] = 'e';
> -
> -		file_arr[4] = IS_ISDN(sc) ? 'i' : 'p';
> +		sprintf(file_arr, "CMV%c%c.bin",
> +			(UEA_CHIP_VERSION(sc) == ADI930) ? '9' :
> +			(UEA_CHIP_VERSION(sc) == EAGLE_IV) ? '4' : 'e',
> +			IS_ISDN(sc) ? 'i' : 'p');

I despise : ? logic wherever possible, so no, I will not take this
patch, sorry.

thanks,

greg k-h
