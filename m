Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1AZRs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:48:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64750 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab1AZRsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:48:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Pn/jq9OiHUSOmWvGo4vMq1XYqwwxGSU1wkrz8tFvrWnw36nOw8ZhdSyhtSCZ+ieygg
         q6AWW22As9+AUTYQao2CcVMlBwG1OIBLq+PT/dbeDdQ0l6YUi413wSpwmb8WUljH3Rpk
         PiFhDGz9gQGbj7EH6hzG21+3vCYpdlARVWst4=
Date: Wed, 26 Jan 2011 20:48:43 +0300
From: Dan Carpenter <error27@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] zram: mark the disk as non-rotating media
Message-ID: <20110126174843.GR2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110126172148.GB8446@linux.vnet.ibm.com>
 <20110126172743.GI8446@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126172743.GI8446@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jan 26, 2011 at 11:27:44AM -0600, Robert Jennings wrote:
> Adding QUEUE_FLAG_NONROT for the in the request_queue flags.  When used
                           ^^^^^^^^^^^^^^
"to the" perhaps?

> as a swap device, scan_swap_map will avoid the extra work of optimizing
> for rotating media.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
>  drivers/staging/zram/zram_drv.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index d5e0275..450c618 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -593,6 +593,7 @@ static int create_device(struct zram *zram, int device_id)
>  		goto out;
>  	}
>  
> +	zram->queue->queue_flags ^= QUEUE_FLAG_NONROT;

QUEUE_FLAG_NONROT is 14.  We want to set the 14 bit.  This won't work.

Use queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->queue);

regards,
dan carpenter


