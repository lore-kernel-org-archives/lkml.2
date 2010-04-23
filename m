Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab0DWQAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:00:46 -0400
Received: from mail.perches.com ([173.55.12.10]:1717 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757783Ab0DWQAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:00:42 -0400
Subject: Re: [PATCH] Staging: wlan-ng: fix many style issues in
 hfa384x_usb.c
From: Joe Perches <joe@perches.com>
To: Alessandro Ghedini <al3xbio@gmail.com>
Cc: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1272035706-12212-1-git-send-email-al3xbio@gmail.com>
References: <1272035706-12212-1-git-send-email-al3xbio@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 09:00:40 -0700
Message-ID: <1272038440.1730.817.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 17:15 +0200, Alessandro Ghedini wrote:
> This patch fixes all the errors and most of the checkpatch.pl warnings
> and other style issues in the hfa384x_usb.c file

Hi Alessandro.

Almost there...  One more pass and it should be good to go.

> @@ -351,7 +351,8 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
>  	hw->rx_urb_skb = skb;
>  
>  	result = -ENOLINK;
> -	if (!hw->wlandev->hwremoved && !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
> +	if (!hw->wlandev->hwremoved &&
> +				!test_bit(WORK_RX_HALT, &hw->usb_flags)) {

This is more difficult to read and less standard than

	if (!hw->wlandev->hwremoved &&
	    !test_bit(WORK_RX_HALT, &hw->usb_flags)) {

Please change it.

> @@ -2451,7 +2452,11 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
>  		currpage = HFA384x_ADDR_CMD_MKPAGE(pdaloc[i].cardaddr);
>  		curroffset = HFA384x_ADDR_CMD_MKOFF(pdaloc[i].cardaddr);
>  
> -		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf, len);	/* units of bytes */
> +		result = hfa384x_dormem_wait(hw,
> +					     currpage,
> +					     curroffset,
> +					     buf,
> +					     len); /* units of bytes */

Try not to make function calls use separate lines for each argument
unless you've got a specific reason like a comment for each arg or
something.

> @@ -2610,20 +2617,21 @@ int hfa384x_drvr_start(hfa384x_t *hw)
>  	result = result2 = hfa384x_cmd_initialize(hw);
>  	if (result1 != 0) {
>  		if (result2 != 0) {
> -			printk(KERN_ERR
> -			       "cmd_initialize() failed on two attempts, results %d and %d\n",
> -			       result1, result2);
> +			printk
> +			   (KERN_ERR "cmd_initialize() failed on two attempts,"
> +			    " results %d and %d\n",
> +			    result1, result2);

Please don't split the format strings.
As Richard Kennedy said, it makes grep less convenient.

Put the format on the same line as the printk and
use a newer checkpatch.pl.

I think all these should become single line

	pr_<level>(fmt, args that fit before col 80);

or multiple lines like:

	pr_<level>(fmt,
		   args until col 80,
		   more args if necessary);

That may be a personal nit though.

cheers, Joe

