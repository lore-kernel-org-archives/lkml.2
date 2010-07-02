Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab0GBTX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 15:23:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46753 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0GBTXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 15:23:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Fri, 2 Jul 2010 21:21:45 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>, "Arve Hj??nnev??g" <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201006261514.13491.rjw@sisk.pl> <201007012102.27495.rjw@sisk.pl> <20100702181449.GC16577@elf.ucw.cz>
In-Reply-To: <20100702181449.GC16577@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007022121.45640.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 02, 2010, Pavel Machek wrote:
> On Thu 2010-07-01 21:02:27, Rafael J. Wysocki wrote:
> > On Thursday, July 01, 2010, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > @@ -114,3 +114,17 @@ Description:
> > > >  		if this file contains "1", which is the default.  It may be
> > > >  		disabled by writing "0" to this file, in which case all devices
> > > >  		will be suspended and resumed synchronously.
> > > > +
> > > > +What:		/sys/power/wakeup_count
> > > > +Date:		July 2010
> > > > +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> > > > +Description:
> > > > +		The /sys/power/wakeup_count file allows user space to avoid
> > > > +		losing wakeup events when transitioning the system into a sleep
> > > > +		state.  Reading from it returns the current number of registered
> > > > +		wakeup events and it blocks if some wakeup events are being
> > > > +		processed at the time the file is read from.  Writing to it
> > > > +		will only succeed if the current number of wakeup events is
> > > > +		equal to the written value and, if successful, will make the
> > > > +		kernel abort a subsequent transition to a sleep state if any
> > > > +		wakeup events are reported after the write has returned.
> > > 
> > > I assume that second suspend always succeeds?
> > 
> > The mechanism is one-shot if that's what you're asking for.
> 
> Yep, it would be nice to document it.
> 
> Plus maybe... should there be way to clear the wakeup_count? For
> example when userspace decides that battery is low and that it wants
> to go to sleep now?

You don't need to clear it, just don't write to it before writing to
/sys/power/state.

Rafael
