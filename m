Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0DWJTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 05:19:15 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:57952 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445Ab0DWJTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 05:19:13 -0400
Message-ID: <4BD1660C.3090301@rsk.demon.co.uk>
Date: Fri, 23 Apr 2010 10:19:08 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alessandro Ghedini <al3xbio@gmail.com>
CC: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH] Staging: wlan-ng: fix many style warnings in hfa384x_usb.c
References: <1271951365-17644-1-git-send-email-al3xbio@gmail.com>
In-Reply-To: <1271951365-17644-1-git-send-email-al3xbio@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/10 16:49, Alessandro Ghedini wrote:
> This patch fixes most of the style warnings found with checkpatch.pl in the
> hfa384x_usb.c file.
> 
> Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>
> ---

>  		if (result2 != 0) {
> -			printk(KERN_ERR
> -			       "cmd_initialize() failed on two attempts, results %d and %d\n",
> +			printk(KERN_ERR "cmd_initialize() failed on two" \
> +					"attempts, results %d and %d\n",
>  			       result1, result2);

Hi Alessandro,

I'm not keen on splitting up printk strings. It makes it more difficult
to grep for them. It's nice and easy if you can just copy most of the
log message into grep and get to the correct bit of code.

>  			usb_kill_urb(&hw->rx_urb);
>  			goto done;
>  		} else {
>  			pr_debug("First cmd_initialize() failed (result %d),\n",
>  				 result1);
> -			pr_debug
> -			    ("but second attempt succeeded. All should be ok\n");
> +			pr_debug("but second attempt succeeded. " \
> +						"All should be ok\n");
>  		}
>  	} else if (result2 != 0) {
>  		printk(KERN_WARNING
> -		       "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
> +		       "First cmd_initialize() succeeded, but second " \
> +					"attempt failed (result=%d)\n",
>  		       result2);
>  		printk(KERN_WARNING
>  		       "Most likely the card will be functional\n");
> @@ -3382,8 +3384,9 @@ retry:
>  			 * our request has been acknowledged. Odd,
>  			 * but our OUT URB is still alive...
>  			 */
> -			pr_debug
> -			    ("Causality violation: please reboot Universe, or email linux-wlan-devel@lists.linux-wlan.com\n");
> +			pr_debug("Causality violation: please reboot " \
> +				"Universe, or email " \
> +				"linux-wlan-devel@lists.linux-wlan.com\n");
>  			ctlx->state = CTLX_RESP_COMPLETE;
>  			break;

There has already been a patch for this -- I don't know if it's stuck in
Greg's queue or it got lost, but that mailing list is now dead so we can
just drop the second half of that message.

regards
Richard
