Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0DVReL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 13:34:11 -0400
Received: from mail.perches.com ([173.55.12.10]:1698 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab0DVReJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 13:34:09 -0400
Subject: Re: [PATCH] Staging: wlan-ng: fix many style warnings in
 hfa384x_usb.c
From: Joe Perches <joe@perches.com>
To: Alessandro Ghedini <al3xbio@gmail.com>
Cc: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1271951365-17644-1-git-send-email-al3xbio@gmail.com>
References: <1271951365-17644-1-git-send-email-al3xbio@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 10:34:07 -0700
Message-ID: <1271957647.1730.754.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 17:49 +0200, Alessandro Ghedini wrote:
> This patch fixes most of the style warnings found with checkpatch.pl in the
> hfa384x_usb.c file.
> Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>

Hi Alessandro.

http://driverdev.linuxdriverproject.org/pipermail/devel/2010-April/005105.html
http://driverdev.linuxdriverproject.org/pipermail/devel/2010-April/005106.html

When you get feedback about style changes in your patch submission,
you should see if the feedback applies to more than just a single
instance in your patch.

> @@ -2451,7 +2451,8 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
>  		currpage = HFA384x_ADDR_CMD_MKPAGE(pdaloc[i].cardaddr);
>  		curroffset = HFA384x_ADDR_CMD_MKOFF(pdaloc[i].cardaddr);
>  
> -		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf, len);	/* units of bytes */
> +		result = hfa384x_dormem_wait(hw, currpage, curroffset, \
> +					buf, len); /* units of bytes */

These unnecessary line continuations are many.
Please remove them.
 
> @@ -2610,20 +2611,21 @@ int hfa384x_drvr_start(hfa384x_t *hw)
>  	result = result2 = hfa384x_cmd_initialize(hw);
>  	if (result1 != 0) {
>  		if (result2 != 0) {
> -			printk(KERN_ERR
> -			       "cmd_initialize() failed on two attempts, results %d and %d\n",
> +			printk(KERN_ERR "cmd_initialize() failed on two" \
> +					"attempts, results %d and %d\n",

here.


> -			pr_debug
> -			    ("but second attempt succeeded. All should be ok\n");
> +			pr_debug("but second attempt succeeded. " \
> +						"All should be ok\n");

here, etc.

@@ -2075,12 +2078,9 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
>  			    (j * HFA384x_USB_RWMEM_MAXLEN);
>  
>  			writepage = HFA384x_ADDR_CMD_MKPAGE(dlbufaddr +
> -							    (j *
> -							     HFA384x_USB_RWMEM_MAXLEN));
> -			writeoffset =
> -			    HFA384x_ADDR_CMD_MKOFF(dlbufaddr +
> -						   (j *
> -						    HFA384x_USB_RWMEM_MAXLEN));
> +					(j * HFA384x_USB_RWMEM_MAXLEN));
> +			writeoffset = HFA384x_ADDR_CMD_MKOFF(dlbufaddr +
> +					(j * HFA384x_USB_RWMEM_MAXLEN));
>  
>  			writelen = burnlen - (j * HFA384x_USB_RWMEM_MAXLEN);

Try not to be slavish in simply fixing the checkpatch
errors.  The goal isn't just to keep the silly tool quiet
but to make code readable and maintainable while making it
reasonably conforming to the predominant kernel coding
styles.

This code could be simplified and made much more readable
by using a temporary for (j * HFA384x_USB_RWMEM_MAXLEN)

Something like:

		for (j = 0; j < nwrites; j++) {
			int pos = j * HFA384x_USB_RWMEM_MAXLEN; 
			writebuf = buf + (i * hw->bufinfo.len) + pos;
			writepage = HFA384x_ADDR_CMD_MKPAGE(dlbufaddr + pos);
			writeoffset = HFA384x_ADDR_CMD_MKOFF(dlbufaddr + pos);
			writelen = burnlen - jmax;

> @@ -3583,8 +3586,10 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
>  	struct sk_buff *skb;
>  	hfa384x_t *hw = wlandev->priv;
>  
> -	/* Don't forget the status, time, and data_len fields are in host order */
> -	/* Figure out how big the frame is */
> +	/* Don't forget the status, time, and data_len fields are in
> +	 * host order
> +	 * Figure out how big the frame is
> +	 */

If you're going to convert something like this
perhaps a better style would be:

	/*
	 * Figure out how big the frame is
	 * The status, time and data_len fields are in host order
	 */

>  	fc = le16_to_cpu(rxdesc->frame_control);
>  	hdrlen = p80211_headerlen(fc);
>  	datalen = le16_to_cpu(rxdesc->data_len);
> @@ -3632,7 +3637,9 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
>  		caphdr->encoding = htonl(1);	/* cck */
>  	}
>  
> -	/* Copy the 802.11 header to the skb (ctl frames may be less than a full header) */
> +	/* Copy the 802.11 header to the skb (ctl frames may be less
> +	 * than a full header)

If you're breaking comments up like this, use some taste.
Don't necessarily fill all comments to the maximum line length.

	/*
	 * Copy the 80211.11 header to the skb
	 * (ctl frames may be less than a full header)
	 */

cheers, Joe

