Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab1FJVE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:04:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57064 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259Ab1FJVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:04:57 -0400
X-Sasl-enc: pViFGmglxKmzdlt8kcennwjB7VZYYGFvSXyZZJjTUyW2 1307739897
Date: Fri, 10 Jun 2011 13:44:03 -0700
From: Greg KH <greg@kroah.com>
To: Jim Cromie <jim.cromie@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Subject: Re: [PATCH] fix bogus use of rc = alloc_chrdev_region()
Message-ID: <20110610204403.GA13450@kroah.com>
References: <1307079502-6326-1-git-send-email-jim.cromie@gmail.com>
 <BANLkTi=8bv54-Z=xCyqUhFAnxM5G40k2WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=8bv54-Z=xCyqUhFAnxM5G40k2WQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 02:29:42PM -0600, Jim Cromie wrote:
> can someone pick this up,
> for this release or next ?

It was rumored that Arnd wanted to take over drivers/char/.

Arnd?


> 
> On Thu, Jun 2, 2011 at 11:38 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> > Robert P.J. Day noticed a bogus assignment: major = rc, after
> > the call to alloc_chrdev_region() in pc8736x_gpio_init().
> >
> > The code as written expects return-code behavior as for
> > register_chrdev(), ie on success: rc = reserved-major when
> > requested-major = 0.  But for alloc_chrdev_region(), this isnt the
> > case.  Since its used for debug printing only, just excise the mess.
> >
> > Signed-of-by: Jim Cromie <jim.cromie@gmail.com>
> > Reported-by: Robert P.J. Day <rpjday@crashcourse.ca>
> > cc: Greg KH <greg@kroah.com.
> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> > ---
> >  drivers/char/pc8736x_gpio.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
> > index b304ec0..30d92fe 100644
> > --- a/drivers/char/pc8736x_gpio.c
> > +++ b/drivers/char/pc8736x_gpio.c
> > @@ -314,10 +314,7 @@ static int __init pc8736x_gpio_init(void)
> >                dev_err(&pdev->dev, "register-chrdev failed: %d\n", rc);
> >                goto undo_request_region;
> >        }
> > -       if (!major) {
> > -               major = rc;
> > -               dev_dbg(&pdev->dev, "got dynamic major %d\n", major);
> > -       }
> > +       dev_dbg(&pdev->dev, "using chardev major %d\n", major);
> >
> >        pc8736x_init_shadow();
> >
> > --
> > 1.7.4.2
> >
> >
