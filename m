Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0ERWBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:01:39 -0400
Received: from kroah.org ([198.145.64.141]:51318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0ERWBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:01:38 -0400
Date: Tue, 18 May 2010 14:49:15 -0700
From: Greg KH <greg@kroah.com>
To: Neil Munro <neilmunro@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Staging: Rt2860: Fixed all but one error in mlme.h
Message-ID: <20100518214915.GA21880@kroah.com>
References: <1274096666-3282-1-git-send-email-neilmunro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274096666-3282-1-git-send-email-neilmunro@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 12:44:26PM +0100, Neil Munro wrote:
> From: Neil Munro <neilmunro@gmail.com>
> 
> Fixed all but error in mlme.h, I don't know how to fix the remaining
> error. It complains about parenthesis and do-while loops, maybe someone
> else can fix that?
> 
> Signed-off-by: Neil Munro <neilmunro@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/rt2860/mlme.h |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/rt2860/mlme.h b/drivers/staging/rt2860/mlme.h
> index 1143413..63cada3 100644
> --- a/drivers/staging/rt2860/mlme.h
> +++ b/drivers/staging/rt2860/mlme.h
> @@ -60,7 +60,7 @@
>  #define JAP_W56	4
>  #define MAX_RD_REGION 5
>  
> -#define BEACON_LOST_TIME            4 * OS_HZ	/* 2048 msec = 2 sec */
> +#define BEACON_LOST_TIME            { 4 * OS_HZ }	/* 2048 msec = 2 sec */

This is not correct, you need to use ( ) here.

And you can ignore the checkconfig error about the do-while loop here,
that's a bug in the script.

Care to redo this patch?

thanks,

greg k-h
