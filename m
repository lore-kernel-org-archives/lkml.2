Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0IVPun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:50:43 -0400
Received: from kroah.org ([198.145.64.141]:44043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab0IVPuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:50:12 -0400
Date: Wed, 22 Sep 2010 08:50:04 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Dan Carpenter <error27@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 04/14] memstick: core: fix device_register() error
 handling
Message-ID: <20100922155004.GC26178@kroah.com>
References: <1284900889-24369-1-git-send-email-segooon@gmail.com>
 <20100921152031.30365b3f.akpm@linux-foundation.org>
 <20100921224947.GA20183@kroah.com>
 <AANLkTimQWtQTBe3RBSbYd7vM4Y+SckkoBDbO8E+SwtJj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimQWtQTBe3RBSbYd7vM4Y+SckkoBDbO8E+SwtJj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 10:53:21AM +0200, Kay Sievers wrote:
> On Wed, Sep 22, 2010 at 00:49, Greg KH <greg@kroah.com> wrote:
> 
> >  int device_register(struct device *dev)
> >  {
> > +       int retval;
> > +
> >        device_initialize(dev);
> > -       return device_add(dev);
> > +       retval = device_add(dev);
> > +       if (retval)
> > +               put_device(dev);
> > +       return retval;
> >  }
> 
> > Kay, what am I missing here, why can't we just do this?  Hm, the
> > side-affect might be that if device_register() fails, NO ONE had better
> > touch that device again, as it might have just been freed from the
> > system.  I wonder if that will cause problems...
> 
> That looks right, besides that there might be callers already doing
> this. Which needs to be checked.

Yes, it would be.  I'll go through the tree.

> I never liked this pretty useless "convenience API", which just wraps
> two simple functions and the first one can never fail anyway.

Agreed.

> We better remove that device_register() stuff entirely in the long
> run, it's not doing any good. At the kobject level we killed the same
> stuff already long ago.

It's one of the things on my "to change" list.

thanks,

greg k-h
