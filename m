Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1E3GMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:12:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36828 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1E3GMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J0yyFc3/44DraJM9DLR6uJMfmTnx+MOoEfYHQ5n4xB0UHZBtDEJ4IFh82NFcJ/h0pt
         f47GKMkaRLtP0kQjyoI2i+qkPVbG5dfN7OOOsH9wDNlKVK2URsVPpflD8d7o7D6Yz+3x
         eecHpCUI6N0AIGJCa7KiEzF2qioeroglJvUus=
Date: Mon, 30 May 2011 08:12:38 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Richard Cochran <richard.cochran@omicron.at>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/2] ptp: return -EFAULT on copy_to_user() errors
Message-ID: <20110530061237.GA3166@riccoc20.at.omicron.at>
References: <20110529195312.GA3099@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110529195312.GA3099@shale.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 10:53:12PM +0300, Dan Carpenter wrote:
> copy_to_user() returns the number of bytes remaining, but we want a
> negative error code here.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index a8d03ae..93fa22d 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -46,7 +46,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  		caps.n_ext_ts = ptp->info->n_ext_ts;
>  		caps.n_per_out = ptp->info->n_per_out;
>  		caps.pps = ptp->info->pps;
> -		err = copy_to_user((void __user *)arg, &caps, sizeof(caps));
> +		if (copy_to_user((void __user *)arg, &caps, sizeof(caps)))
> +			err = -EFAULT;

Yes, right, and thanks for the extra review.

Thomas, can you please queue these two patches for 3.0-rc2?

(Or should John Stultz handle this sort of thing?)

Thanks,
Richard
