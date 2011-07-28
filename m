Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1G1WDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:03:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab1G1WDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:03:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv4 04/11] PM: Use *_dec_not_zero instead of *_add_unless
Date: Thu, 28 Jul 2011 23:43:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Sven Eckelmann <sven@narfation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org
References: <1311760070-21532-1-git-send-email-sven@narfation.org> <201107272150.37962.rjw@sisk.pl> <20110727203604.GA8468@elf.ucw.cz>
In-Reply-To: <20110727203604.GA8468@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107282343.54519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 27, 2011, Pavel Machek wrote:
> Hi!
> 
> > > atomic_dec_not_zero is defined for each architecture through
> > > <linux/atomic.h> to provide the functionality of
> > > atomic_add_unless(x, -1, 0).
> > > 
> > > Signed-off-by: Sven Eckelmann <sven@narfation.org>
> > > Cc: Len Brown <len.brown@intel.com>
> > > Cc: Pavel Machek <pavel@ucw.cz>
> > > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > Cc: linux-pm@lists.linux-foundation.org
> > 
> > Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > > ---
> > >  drivers/base/power/runtime.c |    4 ++--
> > >  include/linux/pm_runtime.h   |    2 +-
> > >  kernel/power/hibernate.c     |    4 ++--
> > >  kernel/power/user.c          |    2 +-
> > >  4 files changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> > > index 8dc247c..bda10d9 100644
> > > --- a/drivers/base/power/runtime.c
> > > +++ b/drivers/base/power/runtime.c
> > > @@ -401,7 +401,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
> > >  
> > >  		if (dev->parent) {
> > >  			parent = dev->parent;
> > > -			atomic_add_unless(&parent->power.child_count, -1, 0);
> > > +  atomic_dec_not_zero(&parent->power.child_count);
> 
> I'd like to understand... Why not atomic_dec in the first place? Count
> should be exact, anyway, or we run into problems, right?

Well, we'll also run into trouble if the count becomes negative.  We might
throw a WARN_ON() there if the old value weren't as expected, but that
would be a separate patch.

Thanks,
Rafael
