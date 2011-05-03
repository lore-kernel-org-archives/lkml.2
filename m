Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1ECVw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:52:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54863 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1ECVwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=FRXt74pV5Mh22X6DItUwVOZQDliPFld7vDdiSazRFYIYmybjgdfiTK0e5l3weDKqfc
         KHVioBE1d0wHFqbRhgcyVE7uzbvz0FzYTFMLC7CuMVPw4ItNdxqm5ejyJg9cFtw6oWJ/
         E1CEhxuNCC5/j3Lp9jIT2+Jx1B1W+RsMh9g34=
Date: Wed, 4 May 2011 01:52:11 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110503215211.GA8491@oksana.dev.rtsoft.ru>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 03:13:20PM -0600, Grant Likely wrote:
> > struct gpio_mmio_generic {
> >        spinlock_t      lock;
> >
> >        /* initialized by user */
> >        unsigned long   reg_data;
> >        unsigned long   reg_set;
> >        unsigned long   reg_clr;
> >        unsigned long   reg_dir;
> >
> >        void __iomem    *reg_base;

This assumes that all reg_* will be mapped with a single ioremap().
My solution (see below) doesn't have this issue.

> > void gpio_mmio_generic_setup(struct gpio_mmio_generic *gmg, int register_width);
> > int gpio_mmio_generic_add(struct gpio_mmio_generic *gmg);
> > void gpio_mmio_generic_remove(struct gpio_mmio_generic *gmg);

I'm not sure you need that complex API.

> > gpio_mmio_generic_setup() sets up the common callback ops in the
> > embedded gpio_chip, but the decisions it makes could be overridden by
> > the user before calling gpio_mmio_generic_add().
> >
> > I've not had time to prototype this yet, but I wanted to get it
> > written down and out onto the list for feedback since I probably won't
> > have any chance to get to it until after UDS.  Bonus points to anyone
> > who wants to take the initiative to hack it together before I get to
> > it.  Extra bonus points to anyone who also converts some of the other
> > gpio controllers to use it.  :-D
> 
> And triple bonus points to anyone who thinks this is stupid and comes
> up with a better approach.  :-)

This isn't stupid. And I started working on this, so what about
http://lkml.org/lkml/2011/4/19/401 ? This is pretty much the same
that you propose.

Thanks.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
