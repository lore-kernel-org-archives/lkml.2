Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab1CXUg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:36:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58155 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab1CXUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:36:28 -0400
Date: Thu, 24 Mar 2011 20:36:20 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv2 3/4] drivers/otp: allow an ioctl to be specified
Message-ID: <20110324203620.GK3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-4-git-send-email-jamie@jamieiles.com>
 <AANLkTi=c+664qQqiKOLmvdFScizUC7+88SrCx7WJnp0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=c+664qQqiKOLmvdFScizUC7+88SrCx7WJnp0b@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Mar 24, 2011 at 02:35:00PM -0400, Mike Frysinger wrote:
> On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> > Some drivers may need an ioctl method to provide device specific control
> > such as blackfin for providing locking.  Regions can specify an ioctl to
> > be used but this field method is optional.
> 
> shouldnt this just be squashed into patch 1 since you havent merged
> any of this yet ?

Probably yes, I was just trying to keep the patches smaller to review, 
but in this case it probably isn't a sensible split.

> 
> > +static long otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
> > +{
> > +       struct otp_region *region = filp->private_data;
> > +       long ret = -ENOTTY;
> > +
> > +       if (down_interruptible(&otp_sem))
> > +               return -ERESTARTSYS;
> > +
> > +       if (region->ops->ioctl)
> > +               ret = region->ops->ioctl(region, cmd, arg);
> > +
> > +       up(&otp_sem);
> > +
> > +       return ret;
> > +}
> 
> the existence check can be pulled out of the locking
> 
> long ret;
> 
> if (!region->ops->ioctl)
>     return -ENOTTY;
> 
> if (down_interruptible(&otp_sem))
> 
>     return -ERESTARTSYS;
> 
> ret = region->ops->ioctl(region, cmd, arg);
> 
> up(&otp_sem);
> 
> return ret;
>
Ok, will do.

Jamie
