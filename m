Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab0GAVHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:07:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716Ab0GAVHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:07:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Thu, 1 Jul 2010 23:05:31 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <Pine.LNX.4.44L0.1007011627030.1303-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1007011627030.1303-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007012305.31380.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 01, 2010, Alan Stern wrote:
> On Thu, 1 Jul 2010, Rafael J. Wysocki wrote:
> 
> > > > +	if (msec) {
> > > > +		ktime_t kt;
> > > > +		struct timespec ts;
> > > > +		unsigned long expires;
> > > > +
> > > > +		kt = ktime_get();
> > > > +		kt = ktime_add_ns(kt, msec * NSEC_PER_MSEC);
> > > > +		ts = ktime_to_timespec(kt);
> > > > +		expires = timespec_to_jiffies(&ts);
> > > 
> > > Is this somehow better than jiffies + msecs_to_jiffies(msec)?
> > 
> > I'm not sure about overflows.  That said, the "+" version is used in many
> > places, so there's no problem I think.
> 
> Hmm.  NSEC_PER_MSEC must be one million, right?  So if msec referred to
> anything above 4 seconds (which seems unlikely but not impossible), the
> multiplication would overflow on a 32-bit machine.
> 
> Apart from that, the main difference between the two patches lies in
> when the events are counted, i.e., whether event_count gets incremented
> at the start or when the timer expires.  I can't see that it matters 
> much either way.

Well, your version doesn't require the additional static variable and
generally takes fewer lines of code. :-)

> > Index: linux-2.6/drivers/base/power/wakeup.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/wakeup.c
> > +++ linux-2.6/drivers/base/power/wakeup.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/device.h>
> >  #include <linux/slab.h>
> >  #include <linux/sched.h>
> > +#include <linux/ktime.h>
> 
> This isn't needed any more.

Right, I've dropped this line.

Rafael
