Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0IWMKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:10:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40695 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0IWMKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=s92NbzMA77t/v0Z2FQqMSXOJ87Ilo0jQV3cnBZq87liQUF5tZqwTnBpwuTnsPNtpm1
         r5AREuipCe5RSkZ7o0q4Bhd1hlJwGezcERO1X09i2Vc5iG0Ws21/8MOfUstjerI0kABN
         lht1IopPW6wYxctMA9Kc64jU+ZOS2C6lwl9F0=
Date: Thu, 23 Sep 2010 16:10:24 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel-janitors@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Dan Carpenter <error27@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 04/14] memstick: core: fix device_register() error
 handling
Message-ID: <20100923121024.GA26888@albatros>
References: <1284900889-24369-1-git-send-email-segooon@gmail.com>
 <20100921152031.30365b3f.akpm@linux-foundation.org>
 <20100921224947.GA20183@kroah.com>
 <AANLkTimQWtQTBe3RBSbYd7vM4Y+SckkoBDbO8E+SwtJj@mail.gmail.com>
 <20100922155004.GC26178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100922155004.GC26178@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 08:50 -0700, Greg KH wrote:
> On Wed, Sep 22, 2010 at 10:53:21AM +0200, Kay Sievers wrote:
> > On Wed, Sep 22, 2010 at 00:49, Greg KH <greg@kroah.com> wrote:
> > 
> > >  int device_register(struct device *dev)
> > >  {
> > > +       int retval;
> > > +
> > >        device_initialize(dev);
> > > -       return device_add(dev);
> > > +       retval = device_add(dev);
> > > +       if (retval)
> > > +               put_device(dev);
> > > +       return retval;
> > >  }
> > 
> > > Kay, what am I missing here, why can't we just do this?  Hm, the
> > > side-affect might be that if device_register() fails, NO ONE had better
> > > touch that device again, as it might have just been freed from the
> > > system.  I wonder if that will cause problems...
> > 
> > That looks right, besides that there might be callers already doing
> > this. Which needs to be checked.
> 
> Yes, it would be.  I'll go through the tree.

As I see with this in-device_register patch we should check for 2 things:

1) nobody should call put_device() because of failed device_register().

2) dev has to be already got, other words its ref counter should not be zero.

Correct?

-- 
Vasiliy
