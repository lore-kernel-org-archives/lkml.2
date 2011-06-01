Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161075Ab1FAGqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:46:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46954 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161016Ab1FAGq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:46:28 -0400
Subject: Re: [patch 1/2] ptp: return -EFAULT on copy_to_user() errors
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110530061237.GA3166@riccoc20.at.omicron.at>
References: <20110529195312.GA3099@shale.localdomain>
	 <20110530061237.GA3166@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 23:46:20 -0700
Message-ID: <1306910780.3359.53.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 08:12 +0200, Richard Cochran wrote:
> On Sun, May 29, 2011 at 10:53:12PM +0300, Dan Carpenter wrote:
> > copy_to_user() returns the number of bytes remaining, but we want a
> > negative error code here.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> > index a8d03ae..93fa22d 100644
> > --- a/drivers/ptp/ptp_chardev.c
> > +++ b/drivers/ptp/ptp_chardev.c
> > @@ -46,7 +46,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
> >  		caps.n_ext_ts = ptp->info->n_ext_ts;
> >  		caps.n_per_out = ptp->info->n_per_out;
> >  		caps.pps = ptp->info->pps;
> > -		err = copy_to_user((void __user *)arg, &caps, sizeof(caps));
> > +		if (copy_to_user((void __user *)arg, &caps, sizeof(caps)))
> > +			err = -EFAULT;
> 
> Yes, right, and thanks for the extra review.
> 
> Thomas, can you please queue these two patches for 3.0-rc2?
> 
> (Or should John Stultz handle this sort of thing?)

Queued in my tree.

Richard, Since you like these, do you mind formally acking them so I can
add that?

thanks
-john


