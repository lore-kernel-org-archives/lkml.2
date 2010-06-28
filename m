Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0F1DSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 23:18:20 -0400
Received: from koto.vergenet.net ([210.128.90.7]:38732 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab0F1DSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 23:18:16 -0400
Date: Mon, 28 Jun 2010 12:01:57 +0900
From: Simon Horman <horms@verge.net.au>
To: Gustavo Silva <silvagustavosilva@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH] Staging: otus: fix coding style issues in ioctl.c
Message-ID: <20100628030157.GN31668@verge.net.au>
References: <1277591813-15405-1-git-send-email-silvagustavo@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277591813-15405-1-git-send-email-silvagustavo@users.sourceforge.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 05:36:53PM -0500, Gustavo Silva wrote:
> This is a patch to the ioctl.c file that fixes up the following
> issues:
> 
> ERROR: that open brace { should be on the previous line				x  3
> WARNING: please, no space before tabs								x  1
> ERROR: space required before the open parenthesis '('				x  5
> WARNING: braces {} are not necessary for single statement blocks	x  2
> ERROR: space prohibited after that '!' (ctx:BxW)					x  1
> WARNING: suspect code indent for conditional statements				x  2
> ERROR: do not use C99 // comments									x  1
> WARNING: braces {} are not necessary for any arm of this statement	x  4
> 
> 
> Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>

This looks like a step in the right direction to me.
Minor comment below.

> ---
>  drivers/staging/otus/ioctl.c |   53 ++++++++++++++++++-----------------------
>  1 files changed, 23 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
> index a48c8e4..a6c30d2 100644
> --- a/drivers/staging/otus/ioctl.c
> +++ b/drivers/staging/otus/ioctl.c
> @@ -63,8 +63,7 @@
>  
>  extern u16_t zfLnxGetVapId(zdev_t *dev);
>  
> -static const u32_t channel_frequency_11A[] =
> -{
> +static const u32_t channel_frequency_11A[] = {
>  	/* Even element for Channel Number, Odd for Frequency */
>  	36, 5180,
>  	40, 5200,
> @@ -1361,7 +1360,7 @@ int usbdrvwext_giwpower(struct net_device *dev,
>  }
>  
>  /*int usbdrvwext_setparam(struct net_device *dev, struct iw_request_info *info,
> -*		   	 void *w, char *extra)
> +*				void *w, char *extra)
>  *{
>  *	struct ieee80211vap *vap = dev->ml_priv;
>  *	struct ieee80211com *ic = vap->iv_ic;
> @@ -2261,10 +2260,10 @@ int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm)
>  		printk(KERN_ERR "wd->ap.wpaLen : % d\n", len);
>  
>  		/* DUMP WPA IE */
> -		for(ii = 0; ii < len;) {
> +		for (ii = 0; ii < len;) {
>  			printk(KERN_ERR "0x%02x ", wpaie[ii]);
>  
> -			if((++ii % 16) == 0)
> +			if ((++ii % 16) == 0)
>  				printk(KERN_ERR "\n");
>  		}
>  		printk(KERN_ERR "\n");
> @@ -2309,11 +2308,10 @@ int usbdrv_cenc_ioctl(struct net_device *dev, struct zydas_cenc_param *zdparm)
>  	/* Get the AP Id */
>  	apId = zfLnxGetVapId(dev);
>  
> -	if (apId == 0xffff) {
> +	if (apId == 0xffff)
>  		apId = 0;
> -	} else {
> +	else
>  		apId = apId + 1;
> -	}
>  
>  	switch (zdparm->cmd) {
>  	case ZM_CMD_CENC_SETCENC:
> @@ -2334,15 +2332,15 @@ int usbdrv_cenc_ioctl(struct net_device *dev, struct zydas_cenc_param *zdparm)
>  
>  		printk(KERN_ERR "Key Index : % d\n", zdparm->u.crypt.keyid);
>  		printk(KERN_ERR "Encryption key = ");
> -		for (ii = 0; ii < 16; ii++) {
> +		for (ii = 0; ii < 16; ii++)
>  			printk(KERN_ERR "0x%02x ", zdparm->u.crypt.key[ii]);
> -		}
> +
>  		printk(KERN_ERR "\n");
>  
>  		printk(KERN_ERR "MIC key = ");
> -		for(ii = 16; ii < ZM_CENC_KEY_SIZE; ii++) {
> +		for (ii = 16; ii < ZM_CENC_KEY_SIZE; ii++)
>  			printk(KERN_ERR "0x%02x ", zdparm->u.crypt.key[ii]);
> -		}
> +
>  		printk(KERN_ERR "\n");
>  
>  		/* Set up key information */
> @@ -2424,7 +2422,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  		break;
>  	case SIOCSIWRTS:
>  		err = usbdrv_ioctl_setrts(dev, &wrq->u.rts);
> -		if (! err)
> +		if (!err)
>  			changed = 1;
>  		break;
>  	/* set_auth */
> @@ -2582,8 +2580,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  							ZM_AUTH_MODE_WPA);
>  					} else if ((macp->supIe[17] == 0xf) &&
>  						(macp->supIe[18] == 0xac) &&
> -						(macp->supIe[19] == 0x2))
> -					{
> +						(macp->supIe[19] == 0x2)) {
>  						printk(KERN_ERR
>  				"wd->sta.authMode = ZM_AUTH_MODE_WPA2PSK\n");
>  				/* wd->sta.authMode = ZM_AUTH_MODE_WPA2PSK; */
> @@ -2592,8 +2589,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  				ZM_AUTH_MODE_WPA2PSK);
>  			} else if ((macp->supIe[17] == 0xf) &&
>  				(macp->supIe[18] == 0xac) &&
> -				(macp->supIe[19] == 0x1))
> -				{
> +				(macp->supIe[19] == 0x1)) {
>  					printk(KERN_ERR
>  				"wd->sta.authMode = ZM_AUTH_MODE_WPA2\n");
>  				/* wd->sta.authMode = ZM_AUTH_MODE_WPA2; */
> @@ -2618,7 +2614,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  				zfiWlanSetWepStatus(dev, ZM_ENCRYPTION_AES);
>  				}
>  			}
> -			//WPA2 or WPA2PSK
> +			/*WPA2 or WPA2PSK*/

			"/* WPA2 or WPA2PSK */" would be more in keeping
			with the prevailing kernel comment style, IMHO.

>  			if ((macp->supIe[17] == 0xf) ||
>  				(macp->supIe[18] == 0xac)) {
>  				if (macp->supIe[13] == 0x2) {
> @@ -2656,7 +2652,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  			printk(KERN_ERR
>  				"****************ZD_PARAM_COUNTERMEASURES : ");
>  
> -			if(arg) {
> +			if (arg) {
>  				/*    mCounterMeasureState=1; */
>  				printk(KERN_ERR "enable\n");
>  			} else {
> @@ -2667,20 +2663,18 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  		if (op == ZD_PARAM_DROPUNENCRYPTED) {
>  			printk(KERN_ERR "ZD_PARAM_DROPUNENCRYPTED : ");
>  
> -			if(arg) {
> +			if (arg)
>  				printk(KERN_ERR "enable\n");
> -			} else {
> +			else
>  				printk(KERN_ERR "disable\n");
> -			}
>  		}
>  		if (op == ZD_PARAM_AUTH_ALGS) {
>  			printk(KERN_ERR "ZD_PARAM_AUTH_ALGS : ");
>  
> -			if (arg == 0) {
> +			if (arg == 0)
>  				printk(KERN_ERR "OPEN_SYSTEM\n");
> -			} else {
> +			else
>  				printk(KERN_ERR "SHARED_KEY\n");
> -			}
>  		}
>  		if (op == ZD_PARAM_WPS_FILTER) {
>  			printk(KERN_ERR "ZD_PARAM_WPS_FILTER : ");
> @@ -2705,11 +2699,10 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  		/* Get the AP Id */
>  		apId = zfLnxGetVapId(dev);
>  
> -		if (apId == 0xffff) {
> +		if (apId == 0xffff)
>  			apId = 0;
> -		} else {
> +		else
>  			apId = apId + 1;
> -		}
>  
>  		if (copy_from_user(&req_wpaie, ifr->ifr_data,
>  					sizeof(struct ieee80211req_wpaie))) {
> @@ -2721,10 +2714,10 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  			for (j = 0; j < IEEE80211_ADDR_LEN; j++) {
>  				if (macp->stawpaie[i].wpa_macaddr[j] !=
>  						req_wpaie.wpa_macaddr[j])
> -				break;
> +					break;
>  			}
>  			if (j == 6)
> -			break;
> +				break;
>  		}
>  
>  		if (i < ZM_OAL_MAX_STA_SUPPORT) {
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
