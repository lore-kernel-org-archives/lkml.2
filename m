Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab1CaRzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:55:18 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:53075 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab1CaRzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:55:16 -0400
Date: Thu, 31 Mar 2011 19:55:13 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uio: fix allocating minor id for uio device
Message-ID: <20110331175513.GC2734@local>
References: <AANLkTikKNOPi1ALD0vWiwPKDzUJSseuis63qYJKYkj6=@mail.gmail.com>
 <20110328214504.GC2786@local>
 <AANLkTi=AqMzS_cC1WRB+Knx1GT_Oha01kOyxC1TqyWxE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=AqMzS_cC1WRB+Knx1GT_Oha01kOyxC1TqyWxE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:38:47PM +0800, Hillf Danton wrote:
> The number of uio devices that could be used should be less than
> UIO_MAX_DEVICES by design, and this work guards any cases in which id
> more than UIO_MAX_DEVICES is utilized.

Looks good.

Thanks for your work,
Hans

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>

> ---
> 
> --- a/drivers/uio/uio.c	2011-01-05 08:50:20.000000000 +0800
> +++ b/drivers/uio/uio.c	2011-03-31 20:43:44.000000000 +0800
> @@ -381,7 +381,13 @@ static int uio_get_minor(struct uio_devi
>  			retval = -ENOMEM;
>  		goto exit;
>  	}
> -	idev->minor = id & MAX_ID_MASK;
> +	if (id < UIO_MAX_DEVICES) {
> +		idev->minor = id;
> +	} else {
> +		dev_err(idev->dev, "too many uio devices\n");
> +		retval = -EINVAL;
> +		idr_remove(&uio_idr, id);
> +	}
>  exit:
>  	mutex_unlock(&minor_lock);
>  	return retval;
> 
