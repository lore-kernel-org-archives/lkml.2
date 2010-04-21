Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0DUSPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:15:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:43206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0DUSPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:15:46 -0400
Date: Wed, 21 Apr 2010 11:03:49 -0700
From: Greg KH <gregkh@suse.de>
To: Alessandro Ghedini <al3xbio@gmail.com>
Cc: Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com, svenne@krap.dk,
       jkosina@suse.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: fix many style warnings in
 hfa384x_usb.c
Message-ID: <20100421180349.GA24812@suse.de>
References: <1271870950-19305-1-git-send-email-al3xbio@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271870950-19305-1-git-send-email-al3xbio@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 07:29:10PM +0200, Alessandro Ghedini wrote:
> This patch fixes most of the style warnings found with checkpatch.pl in the
> hfa384x_usb.c file.
> 
> Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>
> ---
>  drivers/staging/wlan-ng/hfa384x_usb.c |   59 ++++++++++++++++++--------------
>  1 files changed, 33 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 5df56f0..db819be 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
> @@ -62,7 +62,7 @@
>  *
>  * hfa384x_drvr_xxxconfig  An example of the drvr level abstraction. These
>  *			functions are wrappers for the RID get/set
> -*			sequence. They 	call copy_[to|from]_bap() and
> +*			sequence. They call copy_[to|from]_bap() and
>  *			cmd_access().	These functions operate on the
>  *			RIDs and buffers without validation.  The caller
>  *			is responsible for that.
> @@ -351,7 +351,9 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
>  	hw->rx_urb_skb = skb;
>  
>  	result = -ENOLINK;
> -	if (!hw->wlandev->hwremoved && !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
> +	if (!hw->wlandev->hwremoved && \
> +			!test_bit(WORK_RX_HALT, &hw->usb_flags)) {

As Joe pointed out, this isn't good form.

> @@ -451,7 +453,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
>  	if (test_bit(WORK_RX_HALT, &hw->usb_flags)) {
>  		int ret;
>  
> -		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock! */
> +		usb_kill_urb(&hw->rx_urb); /* Cannot be holding spinlock! */

Put stuff like this on the line before, not after the code please.

thanks,

greg k-h
