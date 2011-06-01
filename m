Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab1FAKQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:16:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36743 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab1FAKQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f6IAEDOJBFbb7RSLSuJr+jISLUsUfRdDuB906UC/mq5bpBMa2te5yHPc2BIPMv7nbw
         HW3MgA70uXENdQ7V804GXhmZ95LgAf3gBo51/J2thoO/XQ5I0HAwMqCl+BSQ+pI7HSaD
         vIiq07eka+dLK529+REojgWWMoR1NHuxiC1wM=
Date: Wed, 1 Jun 2011 12:16:42 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Dan Carpenter <error27@gmail.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/2] ptp: return -EFAULT on copy_to_user() errors
Message-ID: <20110601101642.GA8928@riccoc20.at.omicron.at>
References: <20110529195312.GA3099@shale.localdomain>
 <20110530061237.GA3166@riccoc20.at.omicron.at>
 <1306910780.3359.53.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306910780.3359.53.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:46:20PM -0700, John Stultz wrote:
> On Mon, 2011-05-30 at 08:12 +0200, Richard Cochran wrote:
> > On Sun, May 29, 2011 at 10:53:12PM +0300, Dan Carpenter wrote:
> > > copy_to_user() returns the number of bytes remaining, but we want a
> > > negative error code here.
> > > 
> > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > 
> > > diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> > > index a8d03ae..93fa22d 100644
> > > --- a/drivers/ptp/ptp_chardev.c
> > > +++ b/drivers/ptp/ptp_chardev.c
> > > @@ -46,7 +46,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
> > >  		caps.n_ext_ts = ptp->info->n_ext_ts;
> > >  		caps.n_per_out = ptp->info->n_per_out;
> > >  		caps.pps = ptp->info->pps;
> > > -		err = copy_to_user((void __user *)arg, &caps, sizeof(caps));
> > > +		if (copy_to_user((void __user *)arg, &caps, sizeof(caps)))
> > > +			err = -EFAULT;
> > 
> > Yes, right, and thanks for the extra review.
> > 
> > Thomas, can you please queue these two patches for 3.0-rc2?
> > 
> > (Or should John Stultz handle this sort of thing?)
> 
> Queued in my tree.
> 
> Richard, Since you like these, do you mind formally acking them so I can
> add that?

Acked-by: Richard Cochran <richard.cochran@omicron.at>
