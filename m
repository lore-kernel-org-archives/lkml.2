Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0F3T31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:29:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37313 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab0F3T3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:29:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Wed, 30 Jun 2010 21:27:37 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <Pine.LNX.4.44L0.1006301351530.1707-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006301351530.1707-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006302127.37432.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 30, 2010, Alan Stern wrote:
> On Mon, 28 Jun 2010, Rafael J. Wysocki wrote:
> 
> > +/*
> > + * The functions below use the observation that each wakeup event starts a
> > + * period in which the system should not be suspended.  The moment this period
> > + * will end depends on how the wakeup event is going to be processed after being
> > + * detected and all of the possible cases can be divided into two distinct
> > + * groups.
> > + *
> > + * First, a wakeup event may be detected by the same functional unit that will
> > + * carry out the entire processing of it and possibly will pass it to user space
> > + * for further processing.  In that case the functional unit that has detected
> > + * the event may later "close" the "no suspend" period associated with it
> > + * directly as soon as it has been dealt with.  The pair of pm_stay_awake() and
> > + * pm_relax(), balanced with each other, is supposed to be used in such
> > + * situations.
> > + *
> > + * Second, a wakeup event may be detected by one functional unit and processed
> > + * by another one.  In that case the unit that has detected it cannot really
> > + * "close" the "no suspend" period associated with it, unless it knows in
> > + * advance what's going to happen to the event during processing.  This
> > + * knowledge, however, may not be available to it, so it can simply specify time
> > + * to wait before the system can be suspended and pass it as the second
> > + * argument of pm_wakeup_event().
> > + */
> 
> Since there's no longer any way to cancel a call to pm_wakeup_event()  
> or close the "no suspend" period early, there is no need to use
> dynamically-allocated delayed_work structures.  You can make do with a
> single static timer; always keep it set to expire at the latest time
> passed to pm_wakeup_event().

The decremenations of events_in_progress wouldn't be balanced with
incrementations this way.  Or do you have any clever way of dealing with
that in mind?

Rafael
